--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--
f = SimpleForm("password", translate("Admin Password"), translate("Change the admin password"))

user = f:field(Value, "user", translate("Username"))

pw1 = f:field(Value, "pw1", translate("Password"))
pw1.password = true
pw1.rmempty = false

pw2 = f:field(Value, "pw2", translate("Confirmation"))
pw2.password = true
pw2.rmempty = false

function pw2.validate(self, value, section)
	return pw1:formvalue(section) == value and value
end

function f.handle(self, state, data)
	if state == FORM_VALID then
    local stat = luci.sys.call('printf "' .. data.pw1 .. ':' .. data.user .. '" > /usr/lib/lua/luci/peopleswifi/passwd') == 0
		
		if stat then
			f.message = translate("Password successfully changed")
		else
			f.errmessage = translate("Unknown Error")
		end
		
		data.pw1 = nil
		data.pw2 = nil
	end
	return true
end

return f