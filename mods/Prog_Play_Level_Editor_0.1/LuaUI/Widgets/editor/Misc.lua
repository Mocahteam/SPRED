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
-- Transform decimal number into hex
-----------------------
function DEC_HEX(IN)
	local NUM = IN
	if NUM == 0 then return "00" end
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B), (IN%B)+1
        OUT=string.sub(K,D,D)..OUT
    end
	if NUM < B then return "0"..OUT end
    return OUT
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
			return k
		end
	end
	return nil
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
-- Generate a name for a file from a string
-----------------------
function generateSaveName(name)
	local saveName = name
	saveName = string.gsub(name, " ", "_")
	saveName = string.gsub(saveName, "[/\\%.%*:%?\"<>|]", "")
	return saveName
end

-----------------------
-- Copy an array
-----------------------
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-----------------------
-- Returns a table containing the team color for each team as described in the .txt file
-----------------------
function getTeamsInformation()
	local txtFile = VFS.LoadFile("LevelEditor.txt")
	local i = 0
	local teams = {}
	while true do
		local regexSection="%[".."TEAM"..tostring(i).."%]%s*%{([^%}]*)%}"
		local contentSection = string.match(txtFile, regexSection)
		if contentSection == nil then
			break
		end
		local colors = {}
		colors[1], colors[2], colors[3] = Spring.GetTeamColor(i)
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

-----------------------
-- Get the game this version of the editor is based on
-----------------------
function getMasterGame()
	local dependencies = VFS.GetArchiveDependencies(Game.modName)
	local games = VFS.GetGames()
	for i, d in ipairs(dependencies) do
		for ii, g in ipairs(games) do
			if d == g then
				return g
			end
		end
	end
	return ""
end