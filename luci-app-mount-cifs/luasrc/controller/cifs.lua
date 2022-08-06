
module("luci.controller.cifs", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/cifs") then
		return
	end

    	entry({"admin", "nas"}, firstchild(), "NAS", 44).dependent = false
	entry({"admin", "nas", "cifs"}, cbi("cifs"), _("Mount SMB NetShare"),280).dependent = true

end
