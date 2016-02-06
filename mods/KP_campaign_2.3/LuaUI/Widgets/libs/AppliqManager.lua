-- This module enable Prog&Play to load xml produce with Appliq software
-- Xml exported by Appliq has to be renamed with the same short name as define in ModInfo.lua
-- The names activities in Appliq XML export has to have the same name with files stored into Missions/[ModShortName]/

local xml = VFS.Include ("LuaUI/Widgets/libs/LuaXML/luaxml-mod-xml.lua")
local handler = VFS.Include ("LuaUI/Widgets/libs/LuaXML/luaxml-mod-handler.lua")
--VFS.Include ("LuaUI/Widgets/libs/LuaXML/pretty.lua")

local game = nil
local scenario = nil
local activities = nil
local goals = nil

-- if init is ok return true and false otherwise
-- initialisation consists in parse xml and check existance of "game" node
local function init()
	if VFS.FileExists("Appliq/"..Game.modShortName..".xml") then
		local xmldata = VFS.LoadFile ("Appliq/"..Game.modShortName..".xml")
		local treehandler = handler.simpleTreeHandler()
		-- do not reduce node activity, input_state, output_state, goal, goal_link, link_set and output_input_link if they are alone
		-- in our case it is preferable to always insert elements as a vector which can be specified on a per element basis
		treehandler.options.noreduce = {activity = true, input_state = true, output_state = true, goal = true, goal_link = true, link_set = true, output_input_link = true}
		-- define parser and parse xml
		local x = xml.xmlParser(treehandler)
		x:parse(xmldata)
		-- check if we have at least a game node. If not, something wrong !!!
		if (treehandler.root and treehandler.root.games and treehandler.root.games.game) then
			game = treehandler.root.games.game
			-- trying to initialise scenario
			if game.link_sets and game.link_sets.link_set then
				scenario = game.link_sets.link_set
			end
			-- trying to initialise activities
			if game.activities and game.activities.activity then
				activities = game.activities.activity
			end
			-- trying to initialise and goals
			if game.goals and game.goals.goal then
				goals = game.goals.goal
			end
		end
		return game ~= nil
	else
		-- no appliq modelisation for this mod
		return false
	end
end

-- return the number of scenario
local function scenarioGetN()
	if scenario ~= nil then
		return table.getn(scenario)
	end
	return 0
end

-- id must be include into [1, scenarioGetN()]
-- return title of scenario number "id"
-- return nil if error
local function scenarioGetTitle(id)
	-- check if scenario id is valid
	if id < 1 or scenarioGetN() < id then
		return nil
	end
	-- check if title node exists
	if scenario[id].title ~= nil then
		return scenario[id].title
	else
		return nil
	end
end

-- return links forming scenario
-- return nil on error
local function scenarioGetLinks(id)
	-- check if scenario id is valid
	if id < 1 or scenarioGetN() < id then
		return nil
	end
	-- check if scenario have at least one link
	if scenario[id].links ~= nil and scenario[id].links.output_input_link ~= nil then
		return scenario[id].links.output_input_link
	end
	return nil
end

-- return name activity of the first activity of scenario number "id"
-- return nil on error
local function scenarioGetFirstActivity(id)
	-- get links forming scenario
	local links = scenarioGetLinks(id)
	if links == nil then
		return nil
	end
	-- look for input_state linked with start
	local input_stateId = nil
	for i=1,table.getn(links) do
		if links[i]._attr ~= nil and links[i]._attr.id_output == "start" then
			input_stateId = links[i]._attr.id_input
			break
		end
	end
	-- check if an input_stateId has been found
	if input_stateId == nil then
		return nil
	end
	-- find activity's name with this input_stateId
	for i=1,table.getn(activities) do
		-- check if activity is well formed
		if activities[i].name ~= nil and activities[i].input_states ~= nil and activities[i].input_states.input_state ~= nil then
			local inputStates = activities[i].input_states.input_state
			-- parse all input states of this activity to find the input state id we look for
			for j=1,table.getn(inputStates) do
				if inputStates[j]._attr ~= nil and inputStates[j]._attr.id_input == input_stateId then
					return activities[i].name
				end
			end
		end
	end
	-- nothing found => error
	return nil
end

local AppliqManager = {} 

AppliqManager.init = init
AppliqManager.scenarioGetN = scenarioGetN
AppliqManager.scenarioGetTitle = scenarioGetTitle
AppliqManager.scenarioGetFirstActivity = scenarioGetFirstActivity

return AppliqManager
