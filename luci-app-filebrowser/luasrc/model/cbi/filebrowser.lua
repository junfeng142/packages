local fs = require "nixio.fs"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local util = require "luci.util"
local http = luci.http

m = Map("filebrowser")
m.title	= translate("FileBrowser")
m:section(SimpleSection).template = "filebrowser/filebrowser_status"
m.description = translate("Filebrowser is an online file manager based on go, which helps you manage files on your device conveniently.")

s = m:section(TypedSection, "filebrowser")
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
o.default = 8989
o.rmempty = false

o = s:taboption("server", Value, "root_path")
o.title = translate("Manage Path")
o.default = "/"
o.rmempty = false

o = s:taboption("server", Value, "admin")
o.title = translate("First Login Name")
o.default = "admin"
o.datatype = "string"
o.rmempty = false

o = s:taboption("server", Value, "password")
o.title = translate("First Login Password")
o.default = "admin"
o.password = true
o.rmempty = false

o = s:taboption("server", DummyValue, "")
o.title = "<p style=\"font-size:14px;font-weight:bold\">" .. translate("Update binary files manually") .. "</p>"

o = s:taboption("server", Value, "project_path")
o.title = translate("Project storage directory")
o.default = "/usr/bin"
o.rmempty = false

o = s:taboption("server", FileUpload, "_upload")
o.title = translate("Choose local file:")
o.template = "filebrowser/upload"

um = s:taboption("server", DummyValue, "")
um.template = "filebrowser/tip"

local fd
local dir = util.trim(util.exec("uci get filebrowser.@filebrowser[0].project_path"):gsub("[ \t\n\r/]+$", ""))
local dpath = dir .. "/filebrowser"
local tempath = "/tmp/filebrowser-tmp/"
local filepath = ""

sys.call("/bin/mkdir -p '".. dir .."'")
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

s:tab("log", translate("Log"))

o = s:taboption("log", Flag, "Enabled")
o.title = translate("Enable Log")
o.enabled = "true"
o.disabled = "false"
o.default = o.enabled
o.description = translate("Start and run information document for filebrowser.")

o = s:taboption("log", Value, "log_path")
o.title = translate("Log Path")
o:depends("Enabled", "true")
o.placeholder = "/tmp"

local logpath = util.trim(util.exec("uci get filebrowser.@filebrowser[0].log_path"):gsub("[ \t\n\r/]+$", ""))
if logpath == "" then
    logpath = "/tmp"
end
local logfile = logpath .. "/filebrowser.log"
o = s:taboption("log", TextValue, "logs")
o:depends("Enabled", "true")
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
