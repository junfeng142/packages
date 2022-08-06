local fs = require "nixio.fs"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local util = require "luci.util"
local http = luci.http

m = Map("baidupcs-web")
m.title	= translate("BaiduPCS Web")
m:section(SimpleSection).template = "baidupcs-web/status"
m.description = translate("BaiduPCS Web based on BaiduPCS-Go, you can use baidu cloud efficiently")

s = m:section(NamedSection, "service", "service")
s.anonymous = true

o = s:option(Flag, "enable")
o.title = translate("Enable")
o.default = 0
o.rmempty = false

o = s:option(Value, "port")
o.title = translate("Listen Port")
o.datatype = "port"
o.default = 5299
o.rmempty = false

o = s:option(Value, "download_path")
o.title = translate("Download Path")
o.default = "/mnt/sda1/baidupcs-download"
o.rmempty = false

o = s:option(Flag, "en_aria2")
o.title = translate("Call aria2 to download")
o.default = 0
o.description = translate("Make sure that aria2 is started normally before checking, otherwise it will be invalid")
o.rmempty = false

o = s:option(Value, "au_value")
o.title = translate("Aria2 URL")
o:depends("en_aria2", 1)
o.default = "http://localhost:6800/jsonrpc"

o = s:option(Value, "as_value")
o.title = translate("Aria2-RPC Secret")
o:depends("en_aria2", 1)

o = s:option(Value, "ap_value")
o.title = translate("Aria2-RPC Prefix")
o:depends("en_aria2", 1)
o.description = translate("Used to partially solve the problem of unable to download, example: http://localhost:5299/bd/")

o = s:option(Value, "pd_value")
o.title = translate("Speed Up Download Link URL")
o:depends("en_aria2", 1)
o.description = translate("Build a pandowload website to speed up the download of the URL, such as https://pandl.live/")

o = s:option(DummyValue, "")
o.title = "<p style=\"font-size:14px;font-weight:bold\">" .. translate("Update binary files manually") .. "</p>"

o = s:option(Value, "project_path")
o.title = translate("Project storage directory")
o.default = "/usr/bin"
o.rmempty = false

o = s:option(FileUpload, "_upload")
o.title = translate("Choose local file:")
o.template = "baidupcs-web/upload"

um = s:option(DummyValue, "")
um.template = "baidupcs-web/tip"

local fd
local dir = util.trim(util.exec("uci get baidupcs-web.service.project_path"):gsub("[ \t\n\r/]+$", ""))
local dpath = dir .. "/baidupcs-web"
local tempath = "/tmp/baidupcs-tmp/"
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

return m
