module("luci.controller.alist", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/alist") then
		return
    end

    entry({"admin", "nas"}, firstchild(), "NAS", 44).dependent = false
    entry({"admin", "nas", "alist"}, cbi("alist"), _("Alist"), 210).dependent = true
    entry({"admin", "nas", "alist", "status"}, call("act_status")).leaf = true
end

function act_status()
    local e={}
    e.running = luci.sys.call("pidof alist >/dev/null")==0
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end
