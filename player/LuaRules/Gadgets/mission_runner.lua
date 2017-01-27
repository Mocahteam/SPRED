
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

local missionScript = nil
local lang = Spring.GetModOptions()["language"] -- get the language
local missionName = Spring.GetModOptions()["missionname"] -- get the name of the current mission
local testmap = Spring.GetModOptions()["testmap"]  --indicate the editor that wants to test a level ("test mission button")
-- variable to know the state of the mission
-- -1 => mission lost
--  0 => mission running
--  1 => mission won
local gameOver = 0

-- used to show briefing
local showBriefing = false
local initializeUnits = true

local solutions = missionName and (table.getn(VFS.DirList("traces\\expert\\"..missionName,"*.xml")) > 0)
-- message sent by pp_gui_main_menu (Widget)
function gadget:RecvLuaMsg(msg, player)
  missionScript.RecvLuaMsg(msg, player)
  if msg == "Show briefing" then
    showBriefing=true  
  end
  if((msg~=nil)and(string.len(msg)>7)and(string.sub(msg,1,7)=="mission")) then
    local jsonfile=string.sub(msg,8,-1)
    missionScript.parseJson(jsonfile)
  end
  if((msg~=nil)and(string.len(msg)>8)and(string.sub(msg,1,8)=="Feedback")) then -- received from game engine (ProgAndPlay.cpp)
    local jsonfile=string.sub(msg,10,-1) -- not 9,-1 because an underscore is used as a separator
    SendToUnsynced("Feedback", jsonfile)
  end
end

function gadget:GamePreload()
	-- remove all existing units
	local units = Spring.GetAllUnits()
	for i = 1,table.getn(units) do
	  Spring.DestroyUnit(units[i], false, true)
	end
	missionScript = VFS.Include("MissionPlayer_Editor.lua")
	missionScript.parseJson(VFS.LoadFile("Missions/"..missionName..".editor"))
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
		-- build event for unsynchronized section
        local prefix=true
        if (prefix)then
          outputState=missionName.."//"..outputState
        end
        _G.event = {logicType = "ShowMissionMenu",
          state = "", outputstate=outputState}
        if gameOver == -1 then
          _G.event.state = "lost"
        else
          _G.event.state = "won"
        end
        local victoryState = _G.event.state or ""
		Spring.SetConfigString("victoryState", victoryState, 1) -- inform the game engine that the mission is ended
        SendToUnsynced("MissionEvent")
        -- if not solutions or testmap ~= nil or Spring.GetConfigString("PP Show Feedbacks","disabled") ~= "enabled" then
          -- SendToUnsynced("MissionEvent")
        -- else
          -- SendToUnsynced("MissionEnded", victoryState)
        -- end
        _G.event = nil
		SendToUnsynced("MissionEnded", victoryState) -- write trace in meta log (see pp_meta_traces_manager.lua)
      end
    end
  end
  
  -- if required, show briefing
  if showBriefing then
    missionScript.ShowBriefing()
    showBriefing = false
  end
end

-- used to show briefings (called by missionScript i.e. MissionPlayer_Editor.lua)
function showMessage (msg, p, w)
  _G.event = {logicType = "ShowMessage",
    message = msg,
    width = w,
    pause = p}
  SendToUnsynced("MissionEvent")
  _G.event = nil
end

-- used to show tuto (called by missionScript i.e. MissionPlayer_Editor.lua)
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
--weaponDefID, projectileID, attackerID,
function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, attackerID, attackerDefID, attackerTeam)
  if(unitID~=nil)then
    local damageTable={attackedUnit=unitID,damage=damage, attackerID=attackerID,frame=-1}--frame -1 indicates that we don't know when the event occured, it will be computed in the update loop mission player 
    Spring.SendLuaRulesMsg("damage"..json.encode(damageTable))
  end
end

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

Spring.SendCommands("resbar 0","fps 0","console 0","info 0") -- TODO : change fps 1 to fps 0 in release
-- leaves rendering duty to widget (we won't)
gl.SlaveMiniMap(true)
-- a hitbox remains for the minimap, unless you do this
gl.ConfigMiniMap(0,0,0,0)
  
local mouseDisabled = false

function gadget:RecvFromSynced(...)
  local arg1, arg2 = ...
  if arg1 == "mouseDisabled" then
    mouseDisabled = true
	
  elseif arg1 == "mouseEnabled" then
    mouseDisabled = false
	
  elseif arg1 == "enableCameraAuto" then
    if Script.LuaUI("CameraAuto") then
      local specialPositions = {}
      for k, v in spairs(SYNCED.cameraAuto["specialPositions"]) do
        specialPositions[k] = {v[1], v[2]}
      end
      Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], specialPositions) -- function defined and registered in cameraAuto widget
    end

  elseif arg1 == "disableCameraAuto" then
    if Script.LuaUI("CameraAuto") then
      Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], {}) -- absolutely not sure of the "disable" thing
    end
    
  elseif arg1 == "TutorialEvent" then
    if Script.LuaUI("TutorialEvent") then
      Script.LuaUI.TutorialEvent() -- function defined and registered in pp_gui_main_menu widget
    end
	
  elseif arg1 == "MissionEvent" then
    if Script.LuaUI("MissionEvent") then
      local e = {}
        for k, v in spairs(SYNCED.event) do
        e[k] = v
        end
      Script.LuaUI.MissionEvent(e) -- function defined and registered in pp_gui_main_menu widget
    end
	
  elseif arg1=="centerCamera" then
    local state = Spring.GetCameraState()
    local pos=json.decode(arg2)
    state.px=pos.x
    state.pz=pos.z
    state.height = 800
    Spring.SetCameraState(state, 2) 
	
  elseif arg1 == "DisplayMessageAboveUnit" then
    local p=json.decode(arg2)
    if(not p.bubble)then
      Script.LuaUI.DisplayMessageAboveUnit(p.message, p.unit, p.time)
    else
      Script.LuaUI.DisplayMessageInBubble(p.message, p.unit, p.time)
    end
	
  elseif arg1 == "displayMessageOnPosition" then
    local p=json.decode(arg2)
    Script.LuaUI.DisplayMessageAtPosition(p.message, p.x, p.y, p.z, p.time)
    
  elseif arg1 == "displayZone" then
    local zone=json.decode(arg2)
    Script.LuaUI.AddZoneToDisplayList(zone)
    
  elseif arg1 == "changeWidgetState" then
    local p=json.decode(arg2)
    if(not p.activation) then Spring.SendCommands("luaui disablewidget "..p.widgetName) end
    if(p.activation) then Spring.SendCommands("luaui enablewidget "..p.widgetName) end
	
  elseif arg1 == "requestUnsyncVals" then
    local valsToSend={}
    valsToSend["speedFactor"]=Spring.GetGameSpeed()
    Spring.SendLuaRulesMsg("returnUnsyncVals"..json.encode(valsToSend))
	
  elseif arg1 == "MissionEnded" then
    Script.LuaUI.MissionEnded(arg2) -- function defined and registered in Meta Traces Manager widget
	
  elseif arg1 == "Feedback" then
    Script.LuaUI.handleFeedback(arg2) -- function defined and registered in Show Feedbacks widget
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
