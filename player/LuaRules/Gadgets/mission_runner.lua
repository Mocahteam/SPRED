
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
local missionName = Spring.GetModOptions()["missionname"] -- get the name of the current mission

-- used to show briefing
local showBriefing = false
local initializeUnits = true

local solutions = missionName and (table.getn(VFS.DirList("traces\\expert\\"..missionName,"*.xml")) > 0)

-- message sent by pp_gui_main_menu (Widget)
function gadget:RecvLuaMsg(msg, player)
	if missionScript then
		missionScript.RecvLuaMsg(msg, player)
	end
	if msg == "Show briefing" then
		showBriefing=true  
	end
	if((msg~=nil)and(string.len(msg)>7)and(string.sub(msg,1,7)=="CHATMSG")) then -- received from Chat widget (chat_interface.lua)
        _G.event = {msg = string.sub(msg,9), teamId = string.sub(msg, 8, 8)}
		SendToUnsynced("NewChatMsg")
        _G.event = nil
	end
end

function gadget:GamePreload()
	-- remove all existing units
	local units = Spring.GetAllUnits()
	for i = 1,table.getn(units) do
	  Spring.DestroyUnit(units[i], false, true)
	end
	if missionName then
		missionScript = VFS.Include("MissionPlayer_Editor.lua")
		missionScript.parseJson(VFS.LoadFile("Missions/"..missionName..".editor"))
	end
end

function gadget:GameFrame( frameNumber )
  -- update mission
  if missionScript ~= nil then
    if(frameNumber>2 and frameNumber<5)then -- now the first frame is officially 5 
      if (initializeUnits)then
        missionScript.StartAfterJson()
        initializeUnits = false
      end
    else
	  -- Update mission and check mission end
      gameOverStates = missionScript.Update(Spring.GetGameFrame())
	  for teamId, gameOverState in pairs(gameOverStates) do
		-- build event for unsynchronized section
        _G.event = {logicType = "ShowMissionMenu", team = teamId,
          state = gameOverState.victoryState, outputstate=missionName.."||"..gameOverState.outputstate}
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

-- used to show briefings (called by missionScript i.e. MissionPlayer_Editor.lua)
function showMessage (msg, p, w)
  _G.event = {logicType = "ShowMessage",
    message = msg,
    width = w,
    pause = p}
  SendToUnsynced("MissionEvent")
  _G.event = nil
end

function gadget:Initialize()
  gadgetHandler:RegisterGlobal("showMessage", showMessage)
end


function gadget:Shutdown()
  gadgetHandler:DeregisterGlobal("showMessage")
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
	local target = arg2
	if (target == nil or target == -1 or target == Spring.GetMyTeamID()) then
		if not mouseDisabled then
			mouseDisabled = true
			Spring.SendCommands("luaui enablewidget Hide commands")
		end
	end
	
  elseif arg1 == "mouseEnabled" then
	local target = arg2
	if (target == nil or target == -1 or target == Spring.GetMyTeamID()) then
		if mouseDisabled then
			mouseDisabled = false
			Spring.SendCommands("luaui disablewidget Hide commands")
		end
	end
	
  elseif arg1 == "enableCameraAuto" then
	local target = SYNCED.cameraAuto["target"]
	if (target == nil or target == -1 or target == Spring.GetMyTeamID()) then
		if Script.LuaUI("CameraAuto") then
		  local specialPositions = {}
		  for k, v in spairs(SYNCED.cameraAuto["specialPositions"]) do
			specialPositions[k] = {v[1], v[2]}
		  end
		  Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], specialPositions) -- function defined and registered in cameraAuto widget
		end
	end

  elseif arg1 == "disableCameraAuto" then
	local target = SYNCED.cameraAuto["target"]
	if (target == nil or target == -1 or target == Spring.GetMyTeamID()) then
		if Script.LuaUI("CameraAuto") then
		  Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], {}) -- absolutely not sure of the "disable" thing
		end
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
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		local state = Spring.GetCameraState()
		state.px=p.pos.x
		state.pz=p.pos.z
		state.height = 800
		Spring.SetCameraState(state, 2)
	end
	
  elseif arg1 == "DisplayMessageAboveUnit" then
    local p=json.decode(arg2)
    if(not p.bubble)then
      Script.LuaUI.DisplayMessageAboveUnit(p.message, p.unit, p.time, p.id)
    else
      Script.LuaUI.DisplayMessageInBubble(p.message, p.unit, p.time, p.id)
    end
	
  elseif arg1 == "displayMessageOnPosition" then
    local p=json.decode(arg2)
    Script.LuaUI.DisplayMessageAtPosition(p.message, p.x, p.y, p.z, p.time, p.id)
	
  elseif arg1 == "displayUIMessage" then
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		Script.LuaUI.DisplayUIMessage(p.message, p.x, p.y, p.width, p.height, p.id)
	end
	
  elseif arg1 == "removeMessage" then
    local p=json.decode(arg2)
    Script.LuaUI.RemoveMessageById(p.id)
    
  elseif arg1 == "showZone" then
    local zone=json.decode(arg2)
    Script.LuaUI.AddZoneToDisplayList(zone) -- function defined and registered in pp_display_zone widget
    
  elseif arg1 == "hideZone" then
    local zone=json.decode(arg2)
    Script.LuaUI.RemoveZoneFromDisplayList(zone) -- function defined and registered in pp_display_zone widget
    
  elseif arg1 == "changeWidgetState" then
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		if(not p.activation) then Spring.SendCommands("luaui disablewidget "..p.widgetName) end
		if(p.activation) then Spring.SendCommands("luaui enablewidget "..p.widgetName) end
	end
    
  elseif arg1 == "traceAction" then
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		if Script.LuaUI.TraceAction then
			Script.LuaUI.TraceAction(p.traceContent) -- registered by pp_meta_trace_manager.lua
		end
	end
	
  elseif arg1 == "requestUnsyncVals" then
    local valsToSend={}
    valsToSend["speedFactor"]=Spring.GetGameSpeed()
    Spring.SendLuaRulesMsg("returnUnsyncVals"..json.encode(valsToSend))
  
  elseif arg1 == "NewChatMsg" then
    if Script.LuaUI("NewChatMsg") then -- function defined and registered in chat widget
      Script.LuaUI.NewChatMsg(SYNCED.event.msg, tonumber(SYNCED.event.teamId)) 
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
