
function gadget:GetInfo()
  return {
    name      = "Mission Tester",
    desc      = "Test a mission described in a json file, based on the tests section",
    author    = "martin",
    date      = "February 08, 2016",
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
local missionIsHardcoded = (Spring.GetModOptions()["hardcoded"]=="yes") --indicate if the mission is hard coded (i.e described by a lua file)
-- variable to know the state of the mission
-- -1 => mission lost
--  0 => mission running
--  1 => mission won
local gameOver = 0

-- used to show briefing
local showBriefing = false
local missionScript=nil


function startTheGame(jsonfile)
  local status1, err1 = pcall(function() missionScript.Start(jsonfile) end) 
  local status2, err2 = pcall(function() missionScript.ShowBriefing() end) 
  Spring.Echo(status1)
  Spring.Echo(status2)
  Spring.Echo(err1)
  Spring.Echo(err2)
  gameOver = 0
end   
-- message sent by mission_gui (Widget)
function gadget:RecvLuaMsg(msg, player)
  if msg == "Show briefing" then
    Spring.Echo("it is tried to Show briefing") 
    showBriefing=true  
  end
  if((msg~=nil)and(string.len(msg)>7)and(string.sub(msg,1,7)=="mission")) then
    local jsonfile=string.sub(msg,8,-1)
    startTheGame(jsonfile)
  end
end

function gadget:GamePreload()
  if missionIsHardcoded then 
    Spring.Echo("mission is hardcoded")
    if missionName ~= nil then
     fileToLoad=missionName..".lua"
    else
      Spring.Echo ("File "..missionName..".lua not found: start standard game")
    end
  else
    fileToLoad="MissionPlayer.lua"
  end
  if VFS.FileExists(fileToLoad) then --TODO can't work anymore, need to be fixed in start
    missionScript = VFS.Include(fileToLoad)
    local units = Spring.GetAllUnits()
    for i = 1,table.getn(units) do
      Spring.DestroyUnit(units[i], false, true)
    end
  else
    Spring.Echo ("No mission name defined: start standard game")
  end
  if(missionIsHardcoded)then
    startTheGame()
  end
end

function updateTheGame()
  local outputState
  gameOver,outputState = missionScript.Update(Spring.GetGameFrame())
  -- if required, show GuiMission
  if gameOver == -1 or gameOver == 1 then
    _G.event = {logicType = "ShowMissionMenu",
      state = "", outputstate=outputState}
    if gameOver == -1 then
      _G.event.state = "lost"
    else
      _G.event.state = "won"
    end
    SendToUnsynced("MissionEvent")
    _G.event = nil
 end
end

function gadget:GameFrame( frameNumber )
  -- update mission
  if missionScript ~= nil and gameOver == 0 then
    -- update gameOver
    updateTheGame()
    end 
  -- if required, show briefing
  if showBriefing then
    missionScript.ShowBriefing()
    showBriefing = false
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
