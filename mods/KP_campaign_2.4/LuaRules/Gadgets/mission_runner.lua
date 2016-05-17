
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

local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
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
local initializeUnits = true

  
-- message sent by mission_gui (Widget)
function gadget:RecvLuaMsg(msg, player)
  if msg == "Show briefing" then
    Spring.Echo("it is tried to Show briefing") 
    showBriefing=true  
  end
  if((msg~=nil)and(string.len(msg)>7)and(string.sub(msg,1,7)=="mission")) then
    local jsonfile=string.sub(msg,8,-1)
    missionScript.parseJson(jsonfile)
  end
end

function gadget:GamePreload()
  if Spring.GetModOptions()["jsonlocation"]=="editor" then
    fileToLoad="MissionPlayer_Editor.lua"
  else 
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
    missionScript.parseJson()
  end
  if Spring.GetModOptions()["jsonlocation"]=="editor" then
    local da=VFS.LoadFile("Missions/KPC/"..missionName..".editor")
    Spring.Echo("try to parse"..missionName)
    missionScript.parseJson(da)
  end
end

function gadget:GameFrame( frameNumber )
  -- update mission
  if missionScript ~= nil and gameOver == 0 then
    -- update gameOver
    local outputState
    if(frameNumber>2 and frameNumber<5)then -- now the first frame is officially 5 
      if (initializeUnits)then
        missionScript.StartAfterJson()
        initializeUnits = false
      end
    else
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

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam) 
  if(attackerTeam~=nil)and(attackerID~=nil)then
    local killTable={unitID=unitID, unitDefID=unitDefID, unitTeam=unitTeam, attackerID=attackerID, attackerDefID=attackerDefID, attackerTeam=attackerTeam}   
    Spring.SendLuaRulesMsg("kill"..json.encode(killTable))
  end
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
  if(unitID~=nil)then
    local damageTable={attackedUnit=unitID,damage=damage, attacker=attackerID,frame=-1}--frame -1 indicates that we don't know when the event occured, it will be computed in the update loop mission player 
    Spring.SendLuaRulesMsg("damage"..json.encode(damageTable))
    --Spring.Echo("damage sent")
  end
end

--function gadget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders) 
--    local damageTable={unitID=unitID,unitDefID=unitDefID, unitTeam=unitTeam}--frame -1 indicates that we don't know when the event occured, it will be computed in the update loop mission player 
--    Spring.SendLuaRulesMsg("unitCreation"..json.encode(damageTable))
--    Spring.Echo("unitCreatedFromFactory")
--end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    local damageTable={unitID=unitID,unitDefID=unitDefID, unitTeam=unitTeam}--frame -1 indicates that we don't know when the event occured, it will be computed in the update loop mission player 
    Spring.SendLuaRulesMsg("unitCreation"..json.encode(damageTable))
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
    mouseDisabled = true
  elseif arg1 == "mouseEnabled" then
    mouseDisabled = false

--    mouseDisabled = arg2
  elseif arg1 == "enableCameraAuto" then
    --Script.LuaUI.DisplayMessageAtPosition("teeeeeeest", 1200, Spring.GetGroundHeight(1200,300), 300, 10)
    if Script.LuaUI("CameraAuto") then
      local specialPositions = {}
      for k, v in spairs(SYNCED.cameraAuto["specialPositions"]) do
        specialPositions[k] = {v[1], v[2]}
      end
      Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], specialPositions) -- function defined and registered in cameraAuto widget
    end

  elseif arg1 == "disableCameraAuto" then
    Spring.Echo("try to desab")
    if Script.LuaUI("CameraAuto") then
      Spring.Echo("try to desab_2")
      Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], {}) -- absolutely not sure of the "disable" thing
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
  elseif arg1=="centerCamera" then
    --Spring.Echo("I tried Bonnie, I tried")
    local state = Spring.GetCameraState()
    local pos=json.decode(arg2)
    state.px=pos.x
    state.pz=pos.z
    state.height = 800
    Spring.SetCameraState(state, 2)  
  elseif arg1 == "DisplayMessageAboveUnit" then
    local p=json.decode(arg2)
    Spring.Echo("try to on unit")
    Script.LuaUI.DisplayMessageAboveUnit(p.message, p.unit, p.time)
  elseif arg1 == "displayMessageOnPosition" then
    --Spring.Echo("try to on pos")
    local p=json.decode(arg2)
    
  elseif arg1 == "changeWidgetState" then
    -- This may be not the better approach to activate/deactivate widgets
    -- as an activated widget will be reloaded. These special settings are processed at frame0
    -- so the side effects may not be harmful. If they do are harmful, then changeWidgetState from widget_activator.lua
    -- should be called. However, registerGlobals do not work as registerGlobals can't work because of the necessary option handler = true
    -- Using a Callins such as :KeyPress could be a workaround to use the function changeWidgetState whenever it's necessary
    local p=json.decode(arg2)
    Spring.Echo("try to change widget Activation")
    Spring.Echo(p.widgetName)
    Spring.Echo(p.activation)
    if(not p.activation) then Spring.SendCommands("luaui disablewidget "..p.widgetName) end
    if(p.activation) then Spring.SendCommands("luaui enablewidget "..p.widgetName) end
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
