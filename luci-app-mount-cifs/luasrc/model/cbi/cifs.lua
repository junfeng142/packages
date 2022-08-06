local fs = require "nixio.fs"

m = Map("cifs", translate("Mount SMB/CIFS Netshare"), translate("Mount SMB/CIFS Netshare for OpenWrt"))

s = m:section(TypedSection, "cifs")
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

workgroup = s:option(Value, "workgroup", translate("Workgroup"))
workgroup.default = "WORKGROUP"

s = m:section(TypedSection, "natshare", translate("CIFS/SMB Netshare"))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

server = s:option(Value, "server", translate("Server IP"))
server.rmempty = false
server.width = "14%"
server.size = 14

name = s:option(Value, "name", translate("Share Folder"))
name.rmempty = false
name.width = "14%"
name.size = 14

pth = s:option(Value, "natpath", translate("Mount Path"))
if nixio.fs.access("/etc/config/fstab") then
        pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end
pth.rmempty = false
pth.width = "14%"
pth.size = 14

smbver = s:option(ListValue, "smbver", translate("SMB Version"))
smbver.rmempty = false
smbver:value("1.0","SMB v1")
smbver:value("2.0","SMB v2")
smbver:value("3.0","SMB v3")
smbver.default = "2.0"
smbver.width = "10%"

agm = s:option(ListValue, "agm", translate("Arguments"))
agm:value("ro", translate("Read Only"))
agm:value("rw", translate("Read/Write"))
agm.rmempty = true
agm.default = "ro"
agm.width = "10%"

iocharset = s:option(Value, "iocharset", translate("Charset"))
iocharset.default = "utf8"
iocharset.width = "7%"
iocharset.size = 7

users = s:option(Value, "users", translate("User"))
users.rmempty = true
users.default = "guest"
users.width = "12%"
users.size = 10

pwd = s:option(Value, "pwd", translate("Password"))
pwd.rmempty = true
pwd.width = "12%"
pwd.size = 10

return m
