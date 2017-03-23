--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--
--  I wanted the new worm toggle button to be called autohold instead of on/off.
--  But I had trouble getting the button graphic to update after pressing it.
--  So I just gave up and instead copy'n'pasted a custom toggle from another
--  mod, namely unit_stealth.lua from Complete Annihilation.
--
--  The original was by trepan (Dave Rodgers). jK added a little bugfix.
--  Then I (zwzsg) edited it to change the name from stealth to burrow,
--  cut out parts that I didn't need, and probably added bugs in the process.
--
--  Also changed it to make it inherited from factories.
--
--  New edit: Different init values for humans and bots
--
--  Since the original unit_stealth.lua was licensed under the terms of
--  the GNU GPL, v2 or later, I guess this autohold.lua is too.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "UnitAutoHold",
    desc      = "A toggle named AutoHold",
    author    = "trepan, bugfixed by jK, maimed by zwzsg",
    date      = "January 2008 / December 2008",
    license   = "Copy pasta from CA's unit_stealth.lua, so probably GPL",
    layer     = 20,
    enabled   = true
  }
end

--------------------------------------------------------------------------------

local autoholdDefs = {
  worm = {
    draw   = true,
    init   = {human=true,bot=false},
    inherited = true,
  },
  hole = {
    draw   = true,
    init   = {human=true,bot=false},
    inherited = true,
  },
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Proposed Command ID Ranges:
--
--    all negative:  Engine (build commands)
--       0 -   999:  Engine
--    1000 -  9999:  Group AI
--   10000 - 19999:  LuaUI
--   20000 - 29999:  LuaCob
--   30000 - 39999:  LuaRules
--

VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)


--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

--
--  speed-ups
--

local SetUnitRulesParam = Spring.SetUnitRulesParam

local autoholdUnits = {} -- make it global in Initialize()

local wantingUnits = {}

local autoholdCmdDesc = {
  id      = CMD_AUTOHOLD,
  type    = CMDTYPE.ICON_MODE,
  name    = 'AutoHold',
  cursor  = 'AutoHold',  -- add with LuaUI?
  action  = 'autohold',
  tooltip = 'Automatically change agressivity according to cloakedness',
  params  = {'0', 'AutoHold Off', 'AutoHold On' }
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function ValidateAutoHoldDefs(mds)
  local newDefs = {}
  for udName,autoholdData in pairs(mds) do
    local ud = UnitDefNames[udName]
    if (not ud) then
      Spring.Echo('Bad autohold unit type: ' .. udName)
    else
      local newData = {}
      newData.draw      = autoholdData.draw
      newData.init      = {human=autoholdData.init.human,bot=autoholdData.init.bot}
      newData.inherited = autoholdData.inherited or false
      newData.delay     = autoholdData.delay or 30
      newDefs[ud.id]    = newData
    end
  end
  return newDefs
end

--------------------------------------------------------------------------------

local function AddAutoHoldCmdDesc(unitID, active)
  autoholdCmdDesc.params[1] = (active and '1') or '0'
  local insertID = 
    Spring.FindUnitCmdDesc(unitID, CMD.CLOAK)      or
    Spring.FindUnitCmdDesc(unitID, CMD.ONOFF)      or
    Spring.FindUnitCmdDesc(unitID, CMD.TRAJECTORY) or
    Spring.FindUnitCmdDesc(unitID, CMD.REPEAT)     or
    Spring.FindUnitCmdDesc(unitID, CMD.MOVE_STATE) or
    Spring.FindUnitCmdDesc(unitID, CMD.FIRE_STATE) or
    123456 -- back of the pack
    Spring.InsertUnitCmdDesc(unitID, insertID + 1, autoholdCmdDesc)
end

--------------------------------------------------------------------------------

local function AddAutoHoldUnit(unitID, autoholdDef)

  local teamNum,leader,isDead,isAiTeam,side,allyTeam = Spring.GetTeamInfo(Spring.GetUnitTeam(unitID))
  local active=nil

  if isAiTeam then
    active=autoholdDef.init.bot
  else
    active=autoholdDef.init.human
  end

  local autoholdData = {
    id      = unitID,
    def     = autoholdDef,
    draw    = autoholdDef.draw,
    active  = active,
  }

  autoholdUnits[unitID] = autoholdData

  AddAutoHoldCmdDesc(unitID, active)

  local params = Spring.GetUnitRulesParams(unitID)
  local haveAutoHold = false
  for i,p in ipairs(params) do
    if (next(p) == "autohold") then
      haveAutoHold = true
      break
    end
  end
  if (not haveAutoHold) then
    Spring.CreateUnitRulesParams(unitID, { { ["autohold"] = 0 } })
  end

  if (autoholdData.active) then
    SetUnitRulesParam(unitID, "autohold", 2)
  else
    SetUnitRulesParam(unitID, "autohold", 0)
  end
  wantingUnits[unitID] = autoholdData
end

--------------------------------------------------------------------------------

function gadget:Initialize()
  -- get the autoholdDefs
  -- autoholdDefs = include("LuaRules/Configs/autohold_defs.lua")
  if (not autoholdDefs) then
    gadgetHandler:RemoveGadget()
    return
  end
  gadgetHandler:RegisterCMDID(CMD_AUTOHOLD)

  autoholdDefs = ValidateAutoHoldDefs(autoholdDefs)

  -- add the AutoHold command to existing units
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local unitDefID = Spring.GetUnitDefID(unitID)
    local autoholdDef = autoholdDefs[unitDefID]
    if (autoholdDef) then
      AddAutoHoldUnit(unitID, autoholdDef)
    end
  end
end

--------------------------------------------------------------------------------

function gadget:Shutdown()
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local ud = UnitDefs[Spring.GetUnitDefID(unitID)]
    Spring.CallCOBScript(unitID, "AutoHold", 0, ud.autohold)
    local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_AUTOHOLD)
    if (cmdDescID) then
      Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
    end
  end
end

--------------------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
  local autoholdDef =  autoholdDefs[unitDefID]
  if (not autoholdDef) then
    return
  end
  if (autoholdDef.inherited == true) and (builderID ~= nil) then
    local autoholdBuilderData = autoholdUnits[builderID]
    if autoholdBuilderData ~= nil then
      local state=autoholdBuilderData.active
      if state~= nil then
        -- We can't modify autoholdDef, as it is actually a reference and
        -- modifying it would modify the corresponding autoholdDefs field
        autoholdDef = {}
        autoholdDef.draw = autoholdDefs[unitDefID].draw
        autoholdDef.init = {human=autoholdUnits[builderID].active,bot=autoholdUnits[builderID].active}
      end
    end
  end
  AddAutoHoldUnit(unitID, autoholdDef)
end

--------------------------------------------------------------------------------

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
  autoholdUnits[unitID] = nil
  wantingUnits[unitID] = nil
end

--------------------------------------------------------------------------------

function gadget:GameFrame()
  for unitID, autoholdData in pairs(wantingUnits) do
    if (autoholdData.delay) then
      autoholdData.delay = autoholdData.delay - 1
      if (autoholdData.delay <= 0) then
        autoholdData.delay = nil
      end
    else
      Spring.CallCOBScript(unitID, "AutoHold", 0, autoholdData.active)
      wantingUnits[unitID] = nil
      autoholdData.delay = autoholdData.def.delay
    end
  end
end

--------------------------------------------------------------------------------

function AutoHoldCommand(unitID, cmdParams)
  if (type(cmdParams[1]) ~= 'number') then
    return false
  end
  local autoholdData = autoholdUnits[unitID]
  if (not autoholdData) then
    return false
  end

  local state = (cmdParams[1] == 1)
  if (state) then
    wantingUnits[unitID] = autoholdData
    SetUnitRulesParam(unitID, "autohold", 2)
  else
    wantingUnits[unitID] = nil
    SetUnitRulesParam(unitID, "autohold", 0)
  end
  autoholdData.active = state
  Spring.CallCOBScript(unitID, "AutoHold", 0, state)

  local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_AUTOHOLD)
  if (cmdDescID) then
    autoholdCmdDesc.params[1] = (state and '1') or '0'
    Spring.EditUnitCmdDesc(unitID, cmdDescID, { params = autoholdCmdDesc.params})
  end
end

--------------------------------------------------------------------------------

function gadget:AllowCommand(unitID, unitDefID, teamID,
                             cmdID, cmdParams, cmdOptions)
  if (cmdID ~= CMD_AUTOHOLD) then
    return true  -- command was not used
  end
  AutoHoldCommand(unitID, cmdParams)  
  return false  -- command was used
end

--------------------------------------------------------------------------------

function gadget:CommandFallback(unitID, unitDefID, teamID,
                                cmdID, cmdParams, cmdOptions)
  if (cmdID ~= CMD_AUTOHOLD) then
    return false  -- command was not used
  end
  AutoHoldCommand(unitID, cmdParams)  
  return true, true  -- command was used, remove it
end

--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
