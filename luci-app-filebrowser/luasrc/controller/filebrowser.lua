module("luci.controller.filebrowser", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/filebrowser") then
		return
    end

    entry({"admin", "nas", "filebrowser"}, cbi("filebrowser"), _("FileBrowser"), 300).dependent = true
    entry({"admin", "nas", "filebrowser", "status"}, call("act_status")).leaf = true
end

function act_status()
    local e={}
    e.running = luci.sys.call("ps -w | grep -v grep | grep 'filebrowser -a' >/dev/null")==0
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end
