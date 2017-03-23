function widget:GetInfo()
	return {
		name = "Kernel Panic Default Commands",
		desc = "Allows using the rightclick for some commands",
		author = "KDR_11k (David Becker)",
		date = "2008-02-12",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

local TYPE_ENTER = 2
local TYPE_DISPATCH = 3
local TYPE_MINIFAC = 4
local TYPE_NONE = 1

local cmd = {
	[TYPE_ENTER] = CMD_ENTER,
	[TYPE_DISPATCH] = CMD_DISPATCH,
}

local builder = {
	[UnitDefNames.gateway.id]=UnitDefNames.gateway.id,
	[UnitDefNames.assembler.id]=UnitDefNames.socket.id,
	[UnitDefNames.trojan.id]=UnitDefNames.window.id,
}

local packet = UnitDefNames.packet.id
local port = UnitDefNames.port.id
local teleporter = {
	[UnitDefNames.port.id]=true,
	[UnitDefNames.connection.id]=true,
}

function widget:DefaultCommand()
	local type = nil
	local portonly = true
--	local con = nil
	for _,u in ipairs(Spring.GetSelectedUnits()) do
		local ud = Spring.GetUnitDefID(u)
		if not type and ud==packet then
			local mx, my = Spring.GetMouseState()
			local s,t = Spring.TraceScreenRay(mx, my)
			if s == "unit" and teleporter[Spring.GetUnitDefID(t)] then
				type = TYPE_ENTER
			else
				type = TYPE_NONE
			end
		end
--		if builder[ud] and type~=TYPE_MINIFAC then
--			local mx, my = Spring.GetMouseState()
--			local s,t = Spring.TraceScreenRay(mx, my)
--			if s == "feature" and FeatureDefs(Spring.GetFeatureDefID(t)).geoThermal then
--				type = TYPE_MINIFAC
--				con = ud
--			end
--		end
		if ud ~= port then
			portonly = false
		end
	end
	if portonly then
		type = TYPE_DISPATCH
	end
--	if type == TYPE_MINIFAC then
--		return -builder[con]
--	end
	return cmd[type]
end
