
function gadget:GetInfo()
  return {
    name      = "Mission Runner",
    desc      = "Runs a mission",
    author    = "muratet",
    date      = "Sept 06, 2015",
    license   = "GPL v2 or later",
    layer     = 0,
    enabled   = true --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- SYNCED
--
if (gadgetHandler:IsSyncedCode()) then 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local lang = Spring.GetModOptions()["language"] -- get the language
local missionName = Spring.GetModOptions()["missionname"] -- get the name of the current mission
local activeTraces = Spring.GetModOptions()["activetraces"]
local testmap = Spring.GetModOptions()["testmap"]
local missionScript = nil -- the lua script that define current mission

-- variable to know the state of the mission
-- -1 => mission lost
--  0 => mission running
--  1 => mission won
local gameOver = 0

-- used to show briefing
local showBriefing = false

-- check if there is expert solutions in the archive for this mission
local solutions = table.getn(VFS.DirList("traces\\expert\\"..missionName,"*.xml")) > 0

function gadget:GamePreload()
	if missionName ~= nil then
		if VFS.FileExists(missionName..".lua") then
			-- initialize mission
			missionScript = VFS.Include(missionName..".lua")
			-- Destroy all units to let a free environnment for missions
			units = Spring.GetAllUnits()
			for i = 1,table.getn(units) do
				Spring.DestroyUnit(units[i], false, true)
			end
			missionScript.Start()
			missionScript.ShowBriefing()
			gameOver = 0
		else
			Spring.Echo ("File "..missionName..".lua not found: start standard game")
		end
	else
		Spring.Echo ("No mission name defined: start standard game")
	end
end

function gadget:GameFrame( frameNumber )
	-- update mission
	if missionScript ~= nil and gameOver == 0 then
		-- update gameOver
		gameOver = missionScript.Update(Spring.GetGameFrame())
		-- if required, show GuiMission
		if gameOver == -1 or gameOver == 1 then
			local victoryState = ""
			if gameOver == -1 then 
				victoryState = "lost"
			else
				victoryState = "won"
			end
			if activeTraces == "0" or not solutions or testmap == "1" or Spring.GetConfigString("Feedbacks Widget","disabled") ~= "enabled" then -- old end mission display
				_G.event = {logicType = "ShowMissionMenu", state = victoryState}
				SendToUnsynced("MissionEvent")
				_G.event = nil
			else -- feedbacks widget will handled the end mission display
				SendToUnsynced("MissionEnded", victoryState)
			end
		end
	end
	
	-- if required, show briefing
	if showBriefing then
		missionScript.ShowBriefing()
		showBriefing = false
	end
end

-- message sent by mission_gui (Widget)
function gadget:RecvLuaMsg(msg, player)
	if msg == "Show briefing" then
		showBriefing = true
	else
		local ind_s = string.find(msg, "_")
		if ind_s ~= nil then
			local prefix = string.sub(msg, 1, ind_s-1)
			local suffix = string.sub(msg, ind_s+1)
			if prefix == "Feedback" then -- a feedback has been received from the engine
				SendToUnsynced(prefix, suffix)
			end
		end
	end
end

-- used to show briefings (called by mission lua script)
function showMessage (msg, p, w)
	_G.event = {logicType = "ShowMessage",
		message = msg,
		width = w,
		pause = p}
	SendToUnsynced("MissionEvent")
	_G.event = nil
end

-- used to show tuto (called by tuto lua script)
function showTuto ()
	SendToUnsynced("TutorialEvent")
end

function gadget:Initialize()
  gadgetHandler:RegisterGlobal("showMessage", showMessage)
  gadgetHandler:RegisterGlobal("showTuto", showTuto)
end


function gadget:Shutdown()
  gadgetHandler:DeregisterGlobal("showMessage")
  gadgetHandler:DeregisterGlobal("showTuto")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 
-- UNSYNCED
--
else
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local mouseDisabled = true

function gadget:RecvFromSynced(...)
	local arg1, arg2 = ...
	if arg1 == "mouseDisabled" then
		mouseDisabled = arg2
	elseif arg1 == "MissionEnded" then
		Script.LuaUI.MissionEnded(arg2) -- function defined and registered in mission_traces widget
	elseif arg1 == "Feedback" then
		Script.LuaUI.handleFeedback(arg2) -- function defined and registered in mission_feedback widget
	elseif arg1 == "enableCameraAuto" then
		if Script.LuaUI("CameraAuto") then
			local specialPositions = {}
			for k, v in spairs(SYNCED.cameraAuto["specialPositions"]) do
				specialPositions[k] = {v[1], v[2]}
			end
			Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], specialPositions) -- function defined and registered in cameraAuto widget
		end
	elseif arg1 == "TutorialEvent" then
		if Script.LuaUI("TutorialEvent") then
			Script.LuaUI.TutorialEvent() -- function defined and registered in mission_gui widget
		end
	elseif arg1 == "MissionEvent" then
		if Script.LuaUI("MissionEvent") then
			local e = {}
		    for k, v in spairs(SYNCED.event) do
				e[k] = v
		    end
			Script.LuaUI.MissionEvent(e) -- function defined and registered in mission_gui widget
		end
	end
end

function gadget:MousePress(x, y, button)
	if mouseDisabled then
		return true
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
