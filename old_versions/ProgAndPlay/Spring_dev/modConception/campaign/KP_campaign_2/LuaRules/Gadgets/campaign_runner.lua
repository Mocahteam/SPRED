
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

local lang = Spring.GetModOptions()["language"] -- get the language

local startingMission = tonumber(Spring.GetModOptions()["startingmission"]) -- get the starting mission number

local campaign = VFS.Include ("campaign.lua") -- a campaign is an array of missions and launchers
local nbMissions = table.getn(campaign) -- get the number of mission which make up the campaign

-- variable to know the state of the mission
-- -1 => mission lost
--  0 => mission running
--  1 => mission won
local gameOver = 0

-- used to show briefing
local showBriefing = false

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
			-- Destroy all units to let a free environnment for missions
			units = Spring.GetAllUnits()
			for i = 1,table.getn(units) do
				Spring.DestroyUnit(units[i], false, true)
			end
			campaign[startingMission][1].Start()
			campaign[startingMission][1].ShowBriefing()
			gameOver = 0
		end
	end
	
	-- update mission
	if nbMissions > 0 and startingMission ~= nil and (gameOver == 0 or gameOver == nil) then
	  gameOver = campaign[startingMission][1].Update(Spring.GetGameFrame())
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
	
	-- if required, show briefing
	if showBriefing then
		campaign[startingMission][1].ShowBriefing()
		showBriefing = false
	end
end

local function DoTheRestart(startscript)
	local trimmed=startscript
	Spring.Echo("Wanting to reload : "..trimmed)
	trimmed,_=string.gsub(trimmed,"language=[^;]*;","language="..lang..";",1)
	trimmed,_=string.gsub(trimmed,"//[^\r\n]-[\r\n]+","\n")-- Remove // comments
	trimmed,_=string.gsub(trimmed,"/%*.-%*/","")-- Remove /* comments */
	Spring.Echo("\n\n<<BEGIN DUMPING TRIMMED>>\n\n")
	Spring.Echo(trimmed)
	Spring.Echo("\n\n<<END DUMPING TRIMMED>>\n\n")
	Spring.Echo("Ok, calling Spring.Restart(\"\",\"[GAME]{..}\") now!")
	Spring.Restart("",trimmed)
	Spring.Echo("Just called Spring.Restart(\"\",\"[GAME]{..}\")")
	Spring.Echo("Wait, we shouldn't be here, should have restarted or crashed or quitted by now.")
end

function gadget:RecvLuaMsg(msg, player)
	if msg == "Previous mission" then
		DoTheRestart(campaign[startingMission-1][2])
	elseif msg == "Replay mission" then
		DoTheRestart(campaign[startingMission][2])
	elseif msg == "Next mission" then
		DoTheRestart(campaign[startingMission+1][2])
	elseif msg == "Show briefing" then
		showBriefing = true
	end
end

-- used to show briefings
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
	elseif arg1 == "enableCameraAuto" then
		if Script.LuaUI("CameraAuto") then
			local specialPositions = {}
			for k, v in spairs(SYNCED.cameraAuto["specialPositions"]) do
				specialPositions[k] = {v[1], v[2]}
			end
			Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], specialPositions)
		end
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
