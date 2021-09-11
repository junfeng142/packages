-- Copyright 2019 Shun Li <riverscn@gmail.com>
-- This is free software, licensed under the Apache License, Version 2.0

module("luci.controller.omcproxy", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/omcproxy") then
		return
	end

	entry({"admin", "services", "omcproxy"}, cbi("omcproxy"), _("omcproxy"), 13).dependent = true

end
