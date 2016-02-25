-- This file contains miscellaneous useful functions

local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")

-----------------------
-- Sort two values
-----------------------
function sort(v1, v2)
	if v1 > v2 then
		return v2, v1
	else
		return v1, v2
	end
end

-----------------------
-- Round a value
-----------------------
function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

-----------------------
-- Get the sign of a number
-----------------------
function sign(x)
	if x >= 0 then
		return 1
	else
		return -1
	end
end

-----------------------
-- Shows units information above unit
-----------------------
function showUnitInformation(u)
	local xU, yU, zU = Spring.GetUnitPosition(u)
	local x, y = Spring.WorldToScreenCoords(xU, yU+50, zU)
	local text1 = "ID:"..tostring(u)
	local w1 = gl.GetTextWidth(text1)
	gl.Text(text1, x - (15*w1/2), y, 15, "s")
	local text2 = "x:"..tostring(round(xU)).." z:"..tostring(round(zU))
	local w2 = gl.GetTextWidth(text2)
	gl.Text(text2, x - (15*w2/2), y-15, 15, "s")
end

-----------------------
-- Select every units in a rectangle
-----------------------
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

-----------------------
-- Save a map to .json and .txt files
-- TODO
-----------------------
function saveMap()

end

-----------------------
-- Select units or add them to the current selection if shift is pressed
-----------------------
function proceedSelection(units)
	local _, _, _, shiftPressed = Spring.GetModKeyState()
	if shiftPressed then
		local selectedUnits = Spring.GetSelectedUnits()
		for i, u in ipairs(units) do
			table.insert(selectedUnits, u) -- add units to selection
		end
		Spring.SelectUnitArray(selectedUnits)
	else
		Spring.SelectUnitArray(units)
	end
end

-----------------------
-- Remove a unit from the current selection if shift is pressed
-- @return shiftPressed to disable click to select
-----------------------
function proceedDeselection(unit)
	local _, _, _, shiftPressed = Spring.GetModKeyState()
	if shiftPressed then
		local selectedUnits = Spring.GetSelectedUnits()
		for i, u in ipairs(selectedUnits) do
			if u == unit then
				table.remove(selectedUnits, i) -- remove unit from selection
			end
		end
		Spring.SelectUnitArray(selectedUnits)
	end
	return shiftPressed
end