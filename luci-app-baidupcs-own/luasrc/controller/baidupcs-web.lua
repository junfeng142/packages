module("luci.controller.baidupcs-web", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/baidupcs-web") then
		return
    end

    entry({"admin", "nas", "baidupcs-web"}, cbi("baidupcs-web"), _("BaiduPCS Web"), 200).dependent = true
    entry({"admin", "nas", "baidupcs-web", "status"}, call("act_status")).leaf = true
end

function act_status()
    local e={}
    e.running = luci.sys.call("pgrep baidupcs-web >/dev/null")==0
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end
