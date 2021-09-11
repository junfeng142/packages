local m,s,o
local sys = require "luci.sys"
local ifaces = sys.net:devices()
local net = require "luci.model.network".init()

m = Map("omcproxy")
m.title = translate("omcproxy")
m.description = translate("omcproxy Multicast Agent(Support for IGMPv3 and MLDv2)")

s=m:section(TypedSection,"proxy")
s.anonymous=true
s.addremove = true;
s.addbtntitle = translate("Add instance")

o = s:option(ListValue, "scope")
o.title = translate("Scope of agency")
o.description = translate("Minimum multicast scope to proxy (only affects IPv6 multicast)")
o.datatype= "string"
o:value("", translate("default"))
o:value("global", translate("global"))
o:value("organization", translate("organization-local"))
o:value("site", translate("site-local"))
o:value("admin", translate("admin-local"))
o:value("realm", translate("realm"))
o.default=''
o.rmempty=true

o = s:option(ListValue,"uplink")
o.title = translate("Uplink interface")
for _, iface in ipairs(ifaces) do
	if not (iface == "lo" or iface:match("^ifb.*")) then
		local nets = net:get_interface(iface)
		nets = nets and nets:get_networks() or {}
		for k, v in pairs(nets) do
			nets[k] = nets[k].sid
		end
		nets = table.concat(nets, ",")
		o:value(iface, ((#nets > 0) and "%s (%s)" % {iface, nets} or iface))
	end
end
o.rmempty = false

o = s:option(ListValue, "downlink")
o.title = translate("Downlink interface")
for _, iface in ipairs(ifaces) do
	if not (iface == "lo" or iface:match("^ifb.*")) then
		local nets = net:get_interface(iface)
		nets = nets and nets:get_networks() or {}
		for k, v in pairs(nets) do
			nets[k] = nets[k].sid
		end
		nets = table.concat(nets, ",")
		o:value(iface, ((#nets > 0) and "%s (%s)" % {iface, nets} or iface))
	end
end
o.rmempty = false

return m

