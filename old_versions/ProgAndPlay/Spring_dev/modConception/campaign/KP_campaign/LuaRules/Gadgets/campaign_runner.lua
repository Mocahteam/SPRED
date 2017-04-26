
function gadget:GetInfo()
  return {
    name      = "Campaign Runner",
    desc      = "Runs a campaign missions",
    author    = "muratet",
    date      = "Jan 18, 2010",
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

local startingMission = tonumber(Spring.GetModOptions()["startingmission"]) -- get the starting mission number

local campaign = VFS.Include ("campaign.lua") -- a campaign is an array of missions and launchers
local nbMissions = table.getn(campaign) -- get the number of mission which make up the campaign

local events = {}

-- Variable used to change mission
-- nil => do nothing
--  -1 => previous mission
--   0 => replay mission
--   1 => next mission
local changeMission = nil

-- variable to know the state of the mission
-- -1 => mission lost
--  0 => mission running
--  1 => mission won
local gameOver = 0

-- store the frame number when the mission started
local startedFrame = 0

-- boolean to send team/cheat command just one time
local protectAgainstDeath = {cheat = false, team = false}

-- used to show briefing
local showBriefing = false

local function AddEvent(frame, event)
  events[frame] = events[frame] or {}
  table.insert(events[frame], event)
end

function gadget:GameStart()
end

function gadget:GameFrame( frameNumber )
	-- initialize mission
	if frameNumber == 0 then
		Spring.Echo ("Game Start ")
		if nbMissions <= 0 then
			Spring.Echo ("No missions: start standard game")
		else
			if startingMission == nil or startingMission > nbMissions then
				Spring.Echo ("New game")
				startingMission = 1
			else
				Spring.Echo ("Continue game")
			end
			Spring.Echo ("Start mission " .. startingMission)
			campaign[startingMission].Start()
			campaign[startingMission].ShowBriefing()
			startedFrame = Spring.GetGameFrame()
			gameOver = 0
			changeMission = nil
		end
	end
	
	-- update mission
	if nbMissions > 0 and startingMission ~= nil and (gameOver == 0 or gameOver == nil) then
	  gameOver = campaign[startingMission].Update(Spring.GetGameFrame()-startedFrame)
		-- if required, show GuiEndMission
		if gameOver == -1 or gameOver == 1 then
			_G.action = {logicType = "GuiEndMissionAction",
				gameOver = "",
				posMission = ""}
			if gameOver == -1 then
				_G.action.gameOver = "lost"
			elseif gameOver == 1 then
				_G.action.gameOver = "won"
			end
			if startingMission == 1 then
				_G.action.posMission = "first"
			elseif startingMission == nbMissions then
				_G.action.posMission = "last"
			end
		  SendToUnsynced("MissionEvent")
			_G.action = nil
		end
	end
	-- if required, change mission
	if changeMission ~= nil then
		campaign[startingMission].Stop()
		startingMission = startingMission + changeMission
 		startedFrame = Spring.GetGameFrame()
 		campaign[startingMission].Start()
 		campaign[startingMission].ShowBriefing()
 		changeMission = nil
 		gameOver = 0
	end
	-- if cheating is activated, protect my Team against death
	if Spring.IsCheatingEnabled() and protectAgainstDeath.cheat then
		-- Get my player info
		local name, active, spectator = Spring.GetPlayerInfo(0)
		if spectator and not protectAgainstDeath.team then
			Spring.SendCommands("team")
			protectAgainstDeath.team = true
		end
		if protectAgainstDeath.team and not spectator then
			-- no more cheating
			Spring.SendCommands("cheat")
			protectAgainstDeath.team = false
			protectAgainstDeath.cheat = false
		end
	end
	-- if required, show briefing
	if showBriefing then
		campaign[startingMission].ShowBriefing()
		showBriefing = false
	end
end

function gadget:RecvLuaMsg(msg, player)
	if msg == "Previous mission" then
		changeMission = -1
	elseif msg == "Replay mission" then
		changeMission = 0
	elseif msg == "Next mission" then
		changeMission = 1
	elseif msg == "Show briefing" then
		showBriefing = true
	end
end

function showMessage (msg, p, w)
	_G.action = {logicType = "GuiMessageAction",
		message = msg,
		width = w,
		pause = p}
	SendToUnsynced("MissionEvent")
	_G.action = nil
end

function gadget:Initialize()
  gadgetHandler:RegisterGlobal("showMessage", showMessage)
end


function gadget:Shutdown()
  gadgetHandler:DeregisterGlobal("showMessage")
end

function gadget:TeamDied(teamID)
	-- protect my Team against death
	if teamID == 0 then
		-- activate cheating
		Spring.SendCommands("cheat")
		protectAgainstDeath.cheat = true
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 
-- UNSYNCED
--
else
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local mouseDisabled = false

function gadget:RecvFromSynced(...)
	local arg1, arg2 = ...
	if arg1 == "mouseDisabled" then
		mouseDisabled = arg2
	end
end

function gadget:MousePress(x, y, button)
	if mouseDisabled then
		return true
	end
end

function WrapToLuaUI()
  if Script.LuaUI("MissionEvent") then
    local action = {}
    for k, v in spairs(SYNCED.action) do
      action[k] = v
    end
    Script.LuaUI.MissionEvent(action)
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:Initialize()
  gadgetHandler:AddSyncAction("MissionEvent", WrapToLuaUI)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
