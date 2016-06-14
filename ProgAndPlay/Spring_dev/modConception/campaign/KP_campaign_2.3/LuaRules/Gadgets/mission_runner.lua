
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

local json = VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")

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
local missionScript = nil -- the lua script that define current mission

-- variable to know the state of the mission
-- -1 => mission lost
--  0 => mission running
--  1 => mission won
local gameOver = 0

-- used to show briefing
local showBriefing = false

-- is set to true by the engine if Prog&Play is used by the player and if the trace and analysis modules are enabled
local PP = false

local white = "\255\255\255\255"
local red = "\255\255\0\0"
local green = "\255\0\255\0"
local blue = "\255\0\0\255"

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
			if not PP then
				_G.event = {logicType = "ShowMissionMenu", state = victoryState}
				SendToUnsynced("MissionEvent")
				_G.event = nil
			else
				SendToUnsynced("createMissionEndedFile", victoryState)
			end
		end
	end
	
	-- if required, show briefing
	if showBriefing then
		missionScript.ShowBriefing()
		showBriefing = false
	end
end

function getFeedbackMessage(json_obj)
	local s = ""
	local color = ""
	if json_obj.score ~= nil then
		local score = json_obj.score
		if score < 25 then
			color = red
		elseif score >= 25 and score < 75 then
			color = blue
		else
			color = green
		end
		s = s.."Votre score : "..color..score.." / 100"..white.."\n"
	end
	if json_obj.num_attempts ~= nil then
		s = s.."Nombre de de tentatives de résolution de la mission : "..json_obj.num_attempts.."\n"
	end
	if json_obj.execution_time ~= nil then
		s = s.."Temps d'éxecution de ton programme : "..json_obj.execution_time.." s\n"
		s = s.."Temps d'éxecution référence : "..json_obj.ref_execution_time.." s\n"
	end
	if json_obj.exec_mean_wait_time ~= nil then
		s = s.."Temps d'attente moyen entre deux tentatives : "..json_obj.exec_mean_wait_time.." s\n"
	end
	if json_obj.resolution_time ~= nil then
		s = s.."Temps de résolution de la mission : "..json_obj.resolution_time.." s\n"
		s = s.."Temps de résolution référence : "..json_obj.ref_resolution_time.." s\n"
	end
	if json_obj.feedbacks ~= nil and #json_obj.feedbacks > 0 then
		if #json_obj.feedbacks == 1 then
			s = s.."\nUn conseil pour améliorer votre programme :\n\n"
		else
			s = s.."\nQuelques conseils pour améliorer votre programme :\n\n"
		end
		for i = 1,#json_obj.feedbacks do
			s = s..color.."- "..json_obj.feedbacks[i]..white.."\n"
		end
	end
	if json_obj.warnings ~= nil and #json_obj.warnings > 0 then
		s = s.."\nAttention :\n\n"
		for i = 1,#json_obj.warnings do
			s = s..red.."- "..json_obj.warnings[i]..white.."\n"
		end
	end
	return s
end

-- message sent by mission_gui (Widget)
function gadget:RecvLuaMsg(msg, player)
	if msg == "Show briefing" then
		showBriefing = true
	elseif msg == "PP" then
		PP = true
	else
		local ind_s = string.find(msg, "_")
		if ind_s ~= nil then
			local prefix = string.sub(msg, 1, ind_s-1)
			if prefix == "Feedback" then
				local json_obj = json.decode(string.sub(msg, ind_s+1))
				local json_string = getFeedbackMessage(json_obj)
				if json_obj.won ~= nil then -- the mission is over
					local state = ""
					if json_obj.won then
						state = "won"
					else
						state = "lost"
					end
					_G.event = {logicType = "ShowMissionMenu", state = state, feedback = json_string}
					SendToUnsynced("MissionEvent")
					_G.event = nil
				else -- the mission is not over yet
					showMessage(json_string, true, 1000)
				end
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
	elseif arg1 == "createMissionEndedFile" then
		Script.LuaUI.CreateMissionEndedFile(arg2) -- function defined and registered in mission_traces widget
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
