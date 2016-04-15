-- This file contains miscellaneous useful functions

json = VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")

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
-- Returns the length of a table
-----------------------
function tableLength(t)
	count = 0
	for _, _ in pairs(t) do
		count = count + 1
	end
	return count
end

-----------------------
-- Returns the index of the minimum element of a table
-----------------------
function minOfTable(t)
	local index = 0
	local value = 0
	for i, e in ipairs(t) do
		if e < value or index == 0 then
			value = e
			index = i
		end
	end
	return index
end

-----------------------
-- Returns true if element is in table
-----------------------
function findInTable(tab, e)
	for k, el in pairs(tab) do
		if e == el then
			return true
		end
	end
	return false
end

-------------------------------------
-- Useful function to split messages into tokens
-------------------------------------
function splitString(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	local i = 1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
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
-- @return to disable click to select
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
		return true
	end
	return false
end

-----------------------
-- Returns a table containing the team color for each team as described in the .txt file
-----------------------
function getTeamsInformation()
	local txtFile = VFS.LoadFile("Missions/"..Game.modShortName.."/LevelEditor.txt")
	local i = 0
	local teams = {}
	while true do
		local regexSection="%[".."TEAM"..tostring(i).."%]%s*%{([^%}]*)%}"
		local contentSection = string.match(txtFile, regexSection)
		if contentSection == nil then
			break
		end
		local rgbRegex = "RGBColor%=%d.%d+ %d.%d+ %d.%d+"
		local rgbSection = string.match(contentSection, rgbRegex)
		local msgContents = splitString(rgbSection, "=")
		local colors = splitString(msgContents[2], " ")
		teams[i] = { id = i, red = colors[1], green = colors[2], blue = colors[3] }
		i = i + 1
	end
	return teams
end

-----------------------
-- Sort units by faction
-----------------------
function getFactionUnits()
	local factionUnits = {} -- return
	local inspected = {} -- units already inspected (prevents infinite loops)
	
	local function buildOptionsTree(unitDefID) -- recursively builds the construction tree
		table.insert(inspected, unitDefID)
		local tmptable = {}
		for i, u in ipairs(UnitDefs[unitDefID].buildOptions) do
			if not findInTable(inspected, u) then
				local t = buildOptionsTree(u)
				for _, unitID in ipairs(t) do
					if not findInTable(tmptable, unitID) then
						table.insert(tmptable, unitID)
					end
				end
			end
		end
		if not findInTable(tmptable, unitDefID) then
			table.insert(tmptable, unitDefID)
		end
		return tmptable
	end
	
	local function compareHumanNames(a, b) -- compare human names without caring about upper/lower cases
		return string.upper(UnitDefNames[a].humanName) < string.upper(UnitDefNames[b].humanName)
	end
	
	for id, unitDef in pairs(UnitDefs) do
		for name, param in unitDef:pairs() do
			if name == "modCategories" then
				if param.commander then
					local factionTable = {}
					for i, u in ipairs(buildOptionsTree(unitDef.id)) do -- sort string by faction
						table.insert(factionTable, UnitDefs[u].name)
					end
					table.sort(factionTable, compareHumanNames)
					table.insert(factionUnits, factionTable)
				end
			end
		end
	end
	
	local otherUnits = {} -- contains units that does not seem to belong to a faction
	for id, unitDef in pairs(UnitDefs) do
		local alreadyInAFaction = false
		for i, t in ipairs(factionUnits) do
			if findInTable(t, unitDef.name) then
				alreadyInAFaction = true
				break
			end
		end
		if not alreadyInAFaction then
			table.insert(otherUnits, unitDef.name)
		end
	end
	table.sort(otherUnits, compareHumanNames)
	table.insert(factionUnits, otherUnits)
	
	return factionUnits
end