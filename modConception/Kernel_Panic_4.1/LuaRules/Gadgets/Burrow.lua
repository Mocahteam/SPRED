--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--
--  I wanted the old worm and bug toggle button to be called surfaced/burrowed
--  instead of on/off. But I had trouble getting the button graphic to update
--  after pressing it. So I just gave up and instead copy'n'pasted a custom
--  toggle from another mod, namely unit_stealth.lua from www.caspring.org
--
--  The original was by trepan (Dave Rodgers). jK added a little bugfix.
--  Then I (zwzsg) edited it to change the name from stealth to burrow,
--  cut out parts that I didn't need, and probably added bugs in the process.
--
--  Since the original unit_stealth.lua was licensed under the terms of
--  the GNU GPL, v2 or later, I guess this Burrow.lua is too.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Burrow",
    desc      = "A toggle named burrow",
    author    = "trepan, bugfixed by jK, maimed by zwzsg",
    date      = "January 2008",
    license   = "Copy pasta from CA's unit_stealth.lua, so probably GPL",
    layer     = 20,
    enabled   = true
  }
end



local burrowDefs = {
  wormold = {
    draw   = true,
    init   = true,
  },
  bugold = {
    draw   = true,
    init   = true,
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

local SYNCSTR = "unit_burrow"


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


--------------------------------------------------------------------------------

-- local burrowDefs = {}

local burrowUnits = {} -- make it global in Initialize()

local wantingUnits = {}


local burrowCmdDesc = {
  id      = CMD_BURROW,
  type    = CMDTYPE.ICON_MODE,
  name    = 'Burrow',
  cursor  = 'Burrow',  -- add with LuaUI?
  action  = 'burrow',
  tooltip = 'Make the unit burrow',
  params  = {'0', 'Burrowed', 'Surfaced' }
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function ValidateBurrowDefs(mds)
  local newDefs = {}
  for udName,burrowData in pairs(mds) do
    local ud = UnitDefNames[udName]
    if (not ud) then
      Spring.Echo('Bad burrow unit type: ' .. udName)
    else
      local newData = {}
      newData.draw   = burrowData.draw
      newData.init   = burrowData.init
      newData.delay  = burrowData.delay or 30
      newDefs[ud.id] = newData
    end
  end
  return newDefs
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AddBurrowCmdDesc(unitID, burrowDef)
  burrowCmdDesc.params[1] = (burrowDef.init and '1') or '0'
  local insertID = 
    Spring.FindUnitCmdDesc(unitID, CMD.CLOAK)      or
    Spring.FindUnitCmdDesc(unitID, CMD.ONOFF)      or
    Spring.FindUnitCmdDesc(unitID, CMD.TRAJECTORY) or
    Spring.FindUnitCmdDesc(unitID, CMD.REPEAT)     or
    Spring.FindUnitCmdDesc(unitID, CMD.MOVE_STATE) or
    Spring.FindUnitCmdDesc(unitID, CMD.FIRE_STATE) or
    123456 -- back of the pack
  Spring.InsertUnitCmdDesc(unitID, insertID + 1, burrowCmdDesc)
end


local function AddBurrowUnit(unitID, burrowDef)

  AddBurrowCmdDesc(unitID, burrowDef)

  local burrowData = {
    id      = unitID,
    def     = burrowDef,
    draw    = burrowDef.draw,
    active  = burrowDef.init,
  }
  burrowUnits[unitID] = burrowData

  local params = Spring.GetUnitRulesParams(unitID)
  local haveBurrow = false
  for i,p in ipairs(params) do
    if (next(p) == "burrow") then
      haveBurrow = true
      break
    end
  end
  if (not haveBurrow) then
    Spring.CreateUnitRulesParams(unitID, { { ["burrow"] = 0 } })
  end

  if (burrowDef.init) then
    wantingUnits[unitID] = burrowData
    SetUnitRulesParam(unitID, "burrow", 2)
    if (burrowDef.draw) then
      SendToUnsynced(SYNCSTR, unitID, true)
    end
  else
    SetUnitRulesParam(unitID, "burrow", 0)
  end
end


--------------------------------------------------------------------------------

function gadget:Initialize()
  -- get the burrowDefs
  -- burrowDefs = include("LuaRules/Configs/burrow_defs.lua")
  if (not burrowDefs) then
    gadgetHandler:RemoveGadget()
    return
  end
  gadgetHandler:RegisterCMDID(CMD_BURROW)

  burrowDefs = ValidateBurrowDefs(burrowDefs)

  -- add the Burrow command to existing units
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local unitDefID = Spring.GetUnitDefID(unitID)
    local burrowDef = burrowDefs[unitDefID]
    if (burrowDef) then
      AddBurrowUnit(unitID, burrowDef)
    end
  end
end


function gadget:Shutdown()
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local ud = UnitDefs[Spring.GetUnitDefID(unitID)]
    -- Spring.SetUnitBurrow(unitID, ud.burrow)
    Spring.CallCOBScript(unitID, "SetBurrow", 0, ud.burrow)
    local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_BURROW)
    if (cmdDescID) then
      Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
    end
  end
end


--------------------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
  local burrowDef = burrowDefs[unitDefID]
  if (not burrowDef) then
    return
  end
  AddBurrowUnit(unitID, burrowDef)
end


function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
  burrowUnits[unitID] = nil
  wantingUnits[unitID] = nil
  SendToUnsynced(SYNCSTR, unitID, false)
end


function gadget:UnitTaken(unitID, unitDefID, unitTeam)
  local burrowUnit = burrowUnits[unitID]
  if (burrowUnit) then
    local burrowDef = burrowUnit.def
    if (burrowDef.init) then
      wantingUnits[unitID] = burrowData
      SetUnitRulesParam(unitID, "burrow", 2)
      if (burrowDef.draw) then
        SendToUnsynced(SYNCSTR, unitID, true)
      end
    else
      wantingUnits[unitID] = nil
      SetUnitRulesParam(unitID, "burrow", 0)
    end
    SendToUnsynced(SYNCSTR, unitID, burrowDef.init)
  end
end


--------------------------------------------------------------------------------

function gadget:GameFrame()
  for unitID, burrowData in pairs(wantingUnits) do
    if (burrowData.delay) then
      burrowData.delay = burrowData.delay - 1
      if (burrowData.delay <= 0) then
        burrowData.delay = nil
      end
    else
      local newState
      if (Spring.GetUnitIsStunned(unitID)) then
        newState = false
      else
        newState = true
      end
      if (burrowData.active ~= newState) then
        burrowData.active = newState
        -- SetUnitBurrow(unitID, burrowData.active)
        Spring.CallCOBScript(unitID, "SetBurrow", 0, burrowData.active)
        if (newState) then
          SetUnitRulesParam(unitID, "burrow", 2)
        else
          SetUnitRulesParam(unitID, "burrow", 1)
          burrowData.delay = burrowData.def.delay
        end
        if (burrowData.draw) then
          SendToUnsynced(SYNCSTR, unitID, newState)
        end
      end
    end
  end
end


--------------------------------------------------------------------------------

function BurrowCommand(unitID, cmdParams)
  if (type(cmdParams[1]) ~= 'number') then
    return false
  end
  local burrowData = burrowUnits[unitID]
  if (not burrowData) then
    return false
  end

  local state = (cmdParams[1] == 1)
  if (state) then
    wantingUnits[unitID] = burrowData
    SetUnitRulesParam(unitID, "burrow", 2)
  else
    wantingUnits[unitID] = nil
    SetUnitRulesParam(unitID, "burrow", 0)
  end
  if (burrowData.draw) then
    SendToUnsynced(SYNCSTR, unitID, state)
  end

  burrowData.active = state
  -- SetUnitBurrow(unitID, state)
  Spring.CallCOBScript(unitID, "SetBurrow", 0, state)
  local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_BURROW)
  if (cmdDescID) then
    burrowCmdDesc.params[1] = (state and '1') or '0'
    Spring.EditUnitCmdDesc(unitID, cmdDescID, { params = burrowCmdDesc.params})
  end
end


function gadget:AllowCommand(unitID, unitDefID, teamID,
                             cmdID, cmdParams, cmdOptions)
  if (cmdID ~= CMD_BURROW) then
    return true  -- command was not used
  end
  BurrowCommand(unitID, cmdParams)  
  return false  -- command was used
end


function gadget:CommandFallback(unitID, unitDefID, teamID,
                                cmdID, cmdParams, cmdOptions)
  if (cmdID ~= CMD_BURROW) then
    return false  -- command was not used
  end
  BurrowCommand(unitID, cmdParams)  
  return true, true  -- command was used, remove it
end


--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
