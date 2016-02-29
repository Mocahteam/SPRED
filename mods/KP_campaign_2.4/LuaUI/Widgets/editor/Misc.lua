-- This file contains miscellaneous useful functions

local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")

-- Sort two values
function sort(v1, v2)
	if v1 > v2 then
		return v2, v1
	else
		return v1, v2
	end
end

-- Select every units in a rectangle
function GetUnitsInScreenRectangle(x1, y1, x2, y2)
	local units = Spring.GetAllUnits()
	
	local left, right = sort(x1, x2)
	local bottom, top = sort(y1, y2)

	local result = {}

	for i=1, #units do
		local uid = units[i]
		x, y, z = Spring.GetUnitPosition(uid)
		x, y = Spring.WorldToScreenCoords(x, y, z)
		if (left <= x and x <= right) and (top >= y and y >= bottom) then
			result[#result+1] = uid
		end
	end
	return result
end

-----------------------
-- Remove all units on the map
-----------------------
function newMap()
	Spring.SendLuaRulesMsg("New Map")
end

-----------------------
-- Load a map using MissionPlayer utilities (may have to be changed)
-- TODO : Allow the loading of multiple maps (bugs the game atm)
-----------------------
function loadMap(jsonPath)
	newMap()
	local jsonFile = VFS.LoadFile(jsonPath)
	Spring.SendLuaRulesMsg("Load Map".."++"..jsonFile)
end

function saveMap()

end