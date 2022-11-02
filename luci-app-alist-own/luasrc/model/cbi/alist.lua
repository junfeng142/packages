local fs = require "nixio.fs"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local util = require "luci.util"
local http = luci.http

m = Map("alist")
m.title	= translate("Alist")
m:section(SimpleSection).template = "alist/status"
m.description = translate("A file list program that supports multiple storage.") .. "<br/>" .. [[<a href="https://alist.nn.ci/zh/guide/drivers/local.html" target="_blank">]] .. translate("User Manual") .. [[</a>]]

s = m:section(TypedSection, "alist")
s.anonymous = true

s:tab("server", translate("Server Settings"))

o = s:taboption("server", Flag, "enable")
o.title = translate("Enable")
o.default = 0
o.rmempty = false

o = s:taboption("server", ListValue, "addrtype")
o.title = translate("Adress Type")
o:value("lan", translate("Listen LAN Address"))
o:value("wan", translate("Listen WAN And LAN Address"))
o.default = "lan"
o.rmempty = false

o = s:taboption("server", Value, "port")
o.title = translate("Listen Port")
o.datatype = "port"
o.default = 5244
o.rmempty = false

o = s:taboption("server", Flag, "ssl")
o.title = translate("Enable SSL")
o.enabled = "true"
o.disabled = "false"
o.default = o.disabled

o = s:taboption("server", Value, "ssl_cert")
o.title = translate("SSL cert")
o.datatype = "file"
o:depends("ssl", "true")
o.description = translate("SSL certificate file path")

o = s:taboption("server", Value, "ssl_key")
o.title = translate("SSL key")
o.datatype = "file"
o:depends("ssl", "true")
o.description = translate("SSL key file path")

o = s:taboption("server", Value, "temp_dir")
o.title = translate("Cache directory")
o.datatype = "string"
o.default = "/tmp/alist"
o.rmempty = false

o = s:taboption("server", DummyValue, "")
o.title = "<p style=\"font-size:18px;font-weight:bold\">" .. translate("Update binary files manually") .. "</p>"

o = s:taboption("server", Value, "project_path")
o.title = translate("Project storage directory")
o.default = "/tmp"
o.rmempty = false

o = s:taboption("server", FileUpload, "_upload")
o.title = translate("Choose local file:")
o.template = "alist/upload"

um = s:taboption("server", DummyValue, "")
um.template = "alist/tip"

local fd
local dir = util.trim(util.exec("uci get alist.@alist[0].project_path"):gsub("[ \t\n\r/]+$", ""))
local dpath = dir .. "/alist"
local tempath = "/tmp/alist-tmp/"
local filepath = ""

fs.mkdir(dir)
fs.mkdir(tempath)
http.setfilehandler(
	function(meta, chunk, eof)
		if not fd then
			if not meta then return end

			if	meta and chunk then fd = nixio.open(tempath .. meta.file, "w") end

			if not fd then
				um.value = translate("Create upload file error.")
				sys.call("/bin/rm -rf '".. tempath .."'")
				return
			end
		end
		if chunk and fd then
			fd:write(chunk)
		end
		if eof and fd then
			fd:close()
			fd = nil
			filepath = util.trim(util.exec("find '".. tempath .."' -name '".. meta.file .."' -a -size +512k"))
			if filepath == "" then
				um.value = translate("The uploaded file is invalid.")
				sys.call("/bin/rm -rf '".. tempath .."'")
			else
				sys.call("/bin/mv -f '".. tempath .. meta.file .."' '".. dpath .."'")
				sys.exec("/bin/chmod 755 '".. dpath .."'")
				um.value = translate("File saved to") .. '"' .. dpath .. '"'
				sys.call("/bin/rm -rf '".. tempath .."'")
			end		
		end
	end
)

s:tab("advance", translate("Advanced Settings"))

o = s:taboption("advance", Flag, "log")
o.title = translate("Enable Logs")
o.enabled = "true"
o.disabled = "false"
o.default = o.enabled

local logpath = util.trim(util.exec("uci get alist.@alist[0].temp_dir"):gsub("[ \t\n\r/]+$", ""))
if logpath == "" then
    logpath = "/tmp/alist"
end
local logfile = logpath .. "/alist.log"
o = s:taboption("advance", TextValue, "logs")
o:depends("log", "true")
o.rows = 10
o.wrap = "off"
function o.cfgvalue()
	local logs = luci.util.execi("cat "..logfile)
    local s = ""
    for line in logs do
	    s = line .. "\n" .. s
    end
    return s
end
o.readonly="readonly"

return m
