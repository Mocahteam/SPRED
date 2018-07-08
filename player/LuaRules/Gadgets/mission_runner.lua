
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
local showBriefing = {}

local initializeUnits = true

local solutions = missionName and (table.getn(VFS.DirList("traces\\expert\\"..missionName,"*.xml")) > 0)

-- message sent by pp_gui_main_menu (Widget)
function gadget:RecvLuaMsg(msg, player)
	if missionScript then
		missionScript.RecvLuaMsg(msg, player)
	end
	if msg == "Show briefing" then
		showBriefing[player]=true
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
		outputState = gameOverState.outputstate or ""
        _G.event = {logicType = "ShowMissionMenu", team = teamId,
          state = gameOverState.victoryState, outputstate=missionName.."||"..outputState,
		  finalFeedback = missionScript.GetFinalFeedback(teamId)}
        SendToUnsynced("MissionEvent")
        _G.event = nil
      end
    end
  end
  
  -- if required, show briefing
  for playerID, _ in pairs(showBriefing) do
    missionScript.ShowBriefing(playerID)
  end
  showBriefing = {}
end

-- used to show briefings (called by missionScript i.e. MissionPlayer_Editor.lua)
function showMessage (msg, p, w, playerID)
  _G.event = {logicType = "ShowMessage",
    message = msg,
    width = w,
    pause = p,
	playerID = playerID}
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
  local killTable={unitID=unitID, unitDefID=unitDefID, unitTeam=unitTeam, attackerID=attackerID, attackerDefID=attackerDefID, attackerTeam=attackerTeam}   
  Spring.SendLuaRulesMsg("kill"..json.encode(killTable))
end
--weaponDefID, projectileID, attackerID,
function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
  if(unitID~=nil)then
    local damageTable={attackedUnit=unitID,damage=damage, attackerID=attackerID} 
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
  if arg1 == "mouseDisabled" then -- sent by MissionPlayer_Editor.lua
	local target = arg2
	if (target == nil or target == -1 or target == Spring.GetMyTeamID()) then
		if not mouseDisabled then
			mouseDisabled = true
			Spring.SendCommands("luaui enablewidget SPRED Hide commands")
		end
	end
	
  elseif arg1 == "mouseEnabled" then -- sent by MissionPlayer_Editor.lua
	local target = arg2
	if (target == nil or target == -1 or target == Spring.GetMyTeamID()) then
		if mouseDisabled then
			mouseDisabled = false
			Spring.SendCommands("luaui disablewidget SPRED Hide commands")
		end
	end
	
  elseif arg1 == "enableCameraAuto" then -- sent by MissionPlayer_Editor.lua
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

  elseif arg1 == "disableCameraAuto" then -- sent by MissionPlayer_Editor.lua
	local target = SYNCED.cameraAuto["target"]
	if (target == nil or target == -1 or target == Spring.GetMyTeamID()) then
		if Script.LuaUI("CameraAuto") then
		  Script.LuaUI.CameraAuto(SYNCED.cameraAuto["enable"], {}) -- absolutely not sure of the "disable" thing
		end
	end
	
  elseif arg1 == "MissionEvent" then -- sent by this script (see synced part)
    if Script.LuaUI("MissionEvent") then
      local e = {}
      for k, v in spairs(SYNCED.event) do
        e[k] = v
      end
	  if e.playerID == nil or e.playerID == Spring.GetMyPlayerID() then
		Script.LuaUI.MissionEvent(e) -- function defined and registered in pp_gui_main_menu widget
	  end
    end
	
  elseif arg1=="centerCamera" then -- sent by MissionPlayer_Editor.lua
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		local state = Spring.GetCameraState()
		state.px=p.pos.x
		state.pz=p.pos.z
		state.height = ((p.distance/100)*3588)+60 -- we keep height between 60 and 3648 (min and max values for Spring)
		-- set rotation
		-- Two magic constants : 0.0529831736655 and 2.99573227355
		-- If we decompose rotation with a linear function the camera seams to follow a logarithmic movement (quick on start (0, 1, 2...) and slow at the end (... 98, 99, 100)
		-- So we compute zscale with an exponential to compensate for this behavior
		-- At vertical position p.rotation == 0 and zscale must be set to 0.05
		-- At horizontal position p.rotation == 100 and zscale must be set to 10
		-- so we have : 0.05 = e(a*0+b)
		--              10   = e(a*100+b)
		--
		--              ln(0.05) = b
		--              ln(10)   = a*100+b
		--
		--              ln(0.05) = b
		--              ln(10)   = a*100+ln(0.05)
		--
		--              ln(0.05)              = b
		--              (ln(10)-ln(0.05))/100 = a
		--
		--              b = -2.99573227355
		--              a = 0.0529831736655
		-- With these parameters we inverse the behavior too slow on start but better at the end so we speed up start with a linear function
		-- To see this function trace it: f(x) = e((ln(10)-ln(0.05))/100*x-ln(0.05))*x/100+4*x/100*(1-x/100)
		local zscale1 = math.exp(0.0529831736655*p.rotation-2.99573227355)
		local zscale2 = 4*p.rotation/100
		state.zscale = zscale1*p.rotation/100+zscale2*(1-p.rotation/100)
		Spring.SetCameraState(state, 2)
	end
	
  elseif arg1 == "DisplayMessageAboveUnit" then -- sent by MissionPlayer_Editor.lua
    local p=json.decode(arg2)
    if(not p.bubble)then
      Script.LuaUI.DisplayMessageAboveUnit(p.message, p.unit, p.time, p.id)
    else
      Script.LuaUI.DisplayMessageInBubble(p.message, p.unit, p.time, p.id)
    end
	
  elseif arg1 == "displayMessageOnPosition" then -- sent by MissionPlayer_Editor.lua
    local p=json.decode(arg2)
    Script.LuaUI.DisplayMessageAtPosition(p.message, p.x, p.y, p.z, p.time, p.id)
	
  elseif arg1 == "displayUIMessage" then -- sent by MissionPlayer_Editor.lua
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		Script.LuaUI.DisplayUIMessage(p.message, p.x, p.y, p.width, p.height, p.id)
	end
	
  elseif arg1 == "updateMessageUI" then -- sent by MissionPlayer_Editor.lua
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		Script.LuaUI.UpdateUIMessage(p.id, p.message)
	end
	
  elseif arg1 == "removeMessage" then -- sent by MissionPlayer_Editor.lua
    local p=json.decode(arg2)
    Script.LuaUI.RemoveMessageById(p.id)
    
  elseif arg1 == "showZone" then -- sent by MissionPlayer_Editor.lua
    local zone=json.decode(arg2)
    Script.LuaUI.AddZoneToDisplayList(zone) -- function defined and registered in pp_display_zone widget
    
  elseif arg1 == "hideZone" then -- sent by MissionPlayer_Editor.lua
    local zone=json.decode(arg2)
    Script.LuaUI.RemoveZoneFromDisplayList(zone) -- function defined and registered in pp_display_zone widget
    
  elseif arg1 == "changeWidgetState" then -- sent by MissionPlayer_Editor.lua
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		if(not p.activation) then Spring.SendCommands("luaui disablewidget "..p.widgetName) end
		if(p.activation) then Spring.SendCommands("luaui enablewidget "..p.widgetName) end
	end
    
  elseif arg1 == "traceAction" then -- sent by MissionPlayer_Editor.lua
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		if Script.LuaUI.TraceAction then
			Script.LuaUI.TraceAction(p.traceContent) -- registered by pp_meta_trace_manager.lua
		end
	end
	
  elseif arg1 == "requestUnsyncVals" then -- sent by MissionPlayer_Editor.lua
    local valsToSend={}
    valsToSend["speedFactor"]=Spring.GetGameSpeed()
    Spring.SendLuaRulesMsg("returnUnsyncVals"..json.encode(valsToSend))
	
  elseif arg1 == "askWidgetState" then -- sent by MissionPlayer_Editor.lua
    local p=json.decode(arg2)
	if (p.target == nil or p.target == -1 or p.target == Spring.GetMyTeamID()) then
		if Script.LuaUI.AskWidgetState then
			Script.LuaUI.AskWidgetState(p.widgetName, p.idCond) -- registered by pp_widget_informer.lua
		end
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
