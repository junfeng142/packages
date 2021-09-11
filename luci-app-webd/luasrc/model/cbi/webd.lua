
mp = Map("webd", translate("Web Filemanage"))
mp.description = translate("WebD is a self-hosted network disk server,No other dependence, fast speed and low resource occupation")

mp:section(SimpleSection).template  = "webd_status"

s = mp:section(TypedSection, "webd", translate("Global Setting"))
s.addremove = false
s.anonymous = true

enabled = s:option(Flag, "enabled", translate("Enable"))
enabled.default = 0
enabled.rmempty = false

addrtype = s:option(ListValue, "addrtype", translate("Adress Type"))
addrtype:value("lan", translate("Listen LAN Address"))
addrtype:value("wan", translate("Listen WAN And LAN Address"))
addrtype.default = "lan"
addrtype.rmempty = false

listenport = s:option(Value, "listenport", translate("Listen Port"))
listenport.default = 9212
listenport.rmempty = false

rootpath = s:option(Value, "rootpath", translate("Manage Path"))
rootpath.default = "/tmp"
rootpath.rmempty = false

rootname = s:option(Value, "rootname", translate("Admin Name"))
rootname.datatype = "string"
rootname.rmempty = false

rootpass = s:option(Value, "rootpass", translate("Admin Password"))
rootpass.password = true
rootpass.rmempty = false

username = s:option(Value, "username", translate("User name"))
username.datatype = "string"
username.rmempty = false

password = s:option(Value, "password", translate("Password"))
password.password = true
password.rmempty = false

guestallow = s:option(Flag, "guestallow", translate("Allow Guest"))
guestallow.default = 0
guestallow.rmempty = false

return mp