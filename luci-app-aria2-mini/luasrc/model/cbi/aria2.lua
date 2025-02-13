--[[
LuCI - Lua Configuration Interface - Aria2 support

Copyright 2014-2016 nanpuyue <nanpuyue@gmail.com>
Modified by maz-1 <ohmygod19993@gmail.com>
Modified by kuoruan <kuoruan@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
]]--

local fs = require "nixio.fs"
local sys  = require "luci.sys"
local util = require "luci.util"
local uci = require "luci.model.uci".cursor()

function ipkg_ver(pkg)
	local version = nil
	local control = io.open("/usr/lib/opkg/info/%s.control" % pkg, "r")
	if control then
		local ln
		repeat
			ln = control:read("*l")
			if ln and ln:match("^Version: ") then
				version = ln:gsub("^Version: ", ""):gsub("-%d", "")
				break
			end
		until not ln
		control:close()
	end
	return version
end

function ipkg_ver_lined(pkg)
	return ipkg_ver(pkg):gsub("%.", "-")
end

m = Map("aria2", translate("Aria2"), translate("Aria2 is a lightweight multi-protocol & multi-source command-line download utility.It supports HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink.<br /><font color=\"red\">Plus + version can download a file from multiple sources/protocols and tries to utilize your maximum download bandwidth.</font>"))

m:section(SimpleSection).template  = "aria2/overview_status"

s = m:section(TypedSection, "aria2", translate("Aria2"))
s.addremove = false
s.anonymous = true

s:tab("general", translate("General Settings"))
s:tab("task", translate("Task Settings"))
s:tab("bittorrent", translate("BitTorrent Settings"))
s:tab("log", translate("Log"))

o = s:taboption("general", Flag, "enabled", translate("Enabled"))
o.rmempty = false

user = s:taboption("general", ListValue, "user", translate("Run daemon as user"))
local p_user
for _, p_user in util.vspairs(util.split(sys.exec("cat /etc/passwd | cut -f 1 -d :"))) do
	user:value(p_user)
end

o = s:taboption("general", Value, "config_dir", translate("Config file directory"))
o.placeholder = "/var/etc/aria2"

o = s:taboption("general", Value, "dir", translate("Default download directory"))
o.rmempty = false

o = s:taboption("general", Value, "disk_cache")
o.title = translate("Disk cache")
o.description = translate("in bytes, You can append K or M.")
o.rmempty = true

o = s:taboption("general", ListValue, "file_allocation", translate("Preallocation"), translate("\"Falloc\" is not available in all cases."))
o:value("none", translate("Off"))
o:value("prealloc", translate("Prealloc"))
o:value("trunc", translate("Trunc"))
o:value("falloc", translate("Falloc"))

o = s:taboption("general", Value, "rpc_listen_port", translate("RPC port"))
o.datatype = "port"
o.placeholder = "6800"

rpc_auth_method = s:taboption("general", ListValue, "rpc_auth_method", translate("RPC authentication method"))
rpc_auth_method:value("none", translate("No Authentication"))
rpc_auth_method:value("user_pass", translate("Username & Password"))
rpc_auth_method:value("token", translate("Token"))

o = s:taboption("general", Value, "rpc_user", translate("RPC username"))
o:depends("rpc_auth_method", "user_pass")

o = s:taboption("general", Value, "rpc_passwd", translate("RPC password"))
o:depends("rpc_auth_method", "user_pass")
o.password  =  true

o = s:taboption("general", Value, "rpc_secret", translate("RPC Token"))
o:depends("rpc_auth_method", "token")
o.template = "aria2/value_with_btn"
o.btntext = translate("Generate Randomly")
o.btnclick = "randomSecret(32);"

o = s:taboption("general", Flag, "_use_ws", translate("Use WebSocket"))

o = s:taboption("general", Value, "_rpc_url", translate("Json-RPC URL"))
o.template = "aria2/value_with_btn"
o.onmouseover = "this.focus();this.select();"
o.btntext = translate("Show URL")
o.btnclick = "showRPCURL();"

overall_speed_limit = s:taboption("task", Flag, "overall_speed_limit", translate("Overall speed limit enabled"))
overall_speed_limit.rmempty = true

o = s:taboption("task", Value, "max_overall_download_limit", translate("Overall download limit"), translate("in bytes/sec, You can append K or M."))
o:depends("overall_speed_limit", "1")

o = s:taboption("task", Value, "max_overall_upload_limit", translate("Overall upload limit"), translate("in bytes/sec, You can append K or M."))
o:depends("overall_speed_limit", "1")

task_speed_limit = s:taboption("task", Flag, "task_speed_limit", translate("Per task speed limit enabled"))
task_speed_limit.rmempty = true

o = s:taboption("task", Value, "max_download_limit", translate("Per task download limit"), translate("in bytes/sec, You can append K or M."))
o:depends("task_speed_limit", "1")

o = s:taboption("task", Value, "max_upload_limit", translate("Per task upload limit"), translate("in bytes/sec, You can append K or M."))
o:depends("task_speed_limit", "1")

o = s:taboption("task", Value, "max_concurrent_downloads", translate("Max concurrent downloads"))
o.placeholder = "5"

o = s:taboption("task", Value, "max_connection_per_server", translate("Max connection per server"), "1-16")
o.datatype = "range(1, 16)"
o.placeholder = "1"

o = s:taboption("task", Value, "min_split_size", translate("Min split size"), "1M-1024M")
o.placeholder = "20M"

o = s:taboption("task", Value, "split", translate("Max number of split"))
o.placeholder = "5"

o = s:taboption("task", Value, "save_session_interval", translate("Autosave session interval"), translate("Sec"))
o.default = "30"

o = s:taboption("task", Value, "user_agent", translate("User agent value"))
o.placeholder = "aria2/" .. ipkg_ver("aria2")

o = s:taboption("bittorrent", Flag, "enable_dht", translate("<abbr title=\"Distributed Hash Table\">DHT</abbr> enabled"))
o.enabled = "true"
o.disabled = "false"

o = s:taboption("bittorrent", Flag, "bt_enable_lpd", translate("<abbr title=\"Local Peer Discovery\">LPD</abbr> enabled"))
o.enabled = "true"
o.disabled = "false"

o = s:taboption("bittorrent", Flag, "follow_torrent", translate("Follow torrent"))
o.enabled = "true"
o.disabled = "false"

o = s:taboption("bittorrent", Value, "listen_port", translate("BitTorrent listen port"))
o.placeholder = "6881-6999"

o = s:taboption("bittorrent", Value, "bt_max_peers", translate("Max number of peers per torrent"))
o.placeholder = "55"

bt_tracker_enable = s:taboption("bittorrent", Flag, "bt_tracker_enable", translate("Additional Bt tracker enabled"))
bt_tracker = s:taboption("bittorrent", DynamicList, "bt_tracker", translate("List of additional Bt tracker"))
bt_tracker:depends("bt_tracker_enable", "1")
bt_tracker.rmempty = true

function bt_tracker.cfgvalue(self, section)
	local rv = {}
	local val = Value.cfgvalue(self, section)
	if type(val) == "table" then
		val = table.concat(val, ",")
	elseif not val then
		val = ""
	end
	for v in val:gmatch("[^,%s]+") do
		rv[#rv+1] = v
	end
	return rv
end

function bt_tracker.write(self, section, value)
	local rv = {}
	for v in util.imatch(value) do
		rv[#rv+1] = v
	end
	Value.write(self, section, table.concat(rv, ","))
end

o = s:taboption("bittorrent", Value, "peer_id_prefix", translate("Prefix of peer ID"))
o.placeholder = "A2-" .. ipkg_ver_lined("aria2") .. "-"

s = m:section(TypedSection, "aria2", translate("Extra Settings"))
s.addremove = false
s.anonymous = true
s.description = translate("Settings in this section will be added to config file.")

o = s:option(DynamicList, "extra_settings", translate("List of extra settings"))
o.placeholder = "option=value"
o.rmempty = true
o.description = translate("List of extra settings. Format: option=value, eg. <code>netrc-path=/tmp/.netrc</code>.")

return m
