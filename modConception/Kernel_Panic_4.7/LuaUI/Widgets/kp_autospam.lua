--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  File:   kp_autospam.lua
--  Brief:   Sets the kernel and hole to repeat from the start, and every socket
--           and window you build will automatically start spamming bits or bug.
--  Authors:  Boirunner, gunblob, zwzsg, Andrej
--
--  License:  Free to do anything with it.
--
--  Changelog:
--    Boirunner:  Initial version
--    gunblob:  Added evil side
--    zwzsg:   Changed UnitCreated to UnitFinished
--             Removed MoveOut
--             Inactivated for allied AI
--             Removed the include header and changed CMD_ to CMD.
--    Andrej:  Helped with getting "repeat" ON, for the first unit, in 75b2
--    KDR_11k: Added Network faction
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Kernel Panic autospam",
    desc      = "Makes sockets or window automatically spam bits or bugs, and sets kernels or holes to repeat on default.",
    author    = "Boirunner, gunblob, zwzsg, Andrej",
    date      = "August 8, 2007",
    license   = "Free",
    layer     = 0,
    enabled   = true  -- loaded by default
  }
end

--------------------------------------------------------------------------------

function widget:Initialize()
  local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
  if spec then
    widgetHandler:RemoveWidget()
    return false
  end
  for i, def in ipairs(UnitDefs) do
    if def.name == "bit" then
      bitID = i
    elseif def.name == "bug" then
      bugID = i
    elseif def.name == "fairy" then
      fairyID = i
    elseif def.name == "bugold" then
      bugoldID = i
    end
  end
end

--------------------------------------------------------------------------------

function widget:UnitCreated(unitID, unitDefID, unitTeam)
 local ud = UnitDefs[unitDefID]
 if(unitTeam ~= Spring.GetMyTeamID()) then
   return false
 end
 if (ud and ud.name == "kernel") then
   Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
 end
 if (ud and ud.name == "socket") then
   Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
   if bitID then 
     Spring.GiveOrderToUnit(unitID, -bitID, {}, {})
   end
 end
 if (ud and ud.name == "hole") then
   Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
 end
 if (ud and ud.name == "window") then
   Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
   if bugID then
     Spring.GiveOrderToUnit(unitID, -bugID, {}, {})
   end
 end
 if (ud and ud.name == "holeold") then
   Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
 end
 if (ud and ud.name == "windowold") then
   Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
   if bugoldID then
     Spring.GiveOrderToUnit(unitID, -bugoldID, {}, {})
   end
 end
 if (ud and ud.name == "carrier") then
   Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
 end
 if (ud and ud.name == "thbase") then
   Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
 end
 if (ud and ud.name == "thminifac") then
   Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
   if fairyID then
     Spring.GiveOrderToUnit(unitID, -fairyID, {}, {})
   end
 end
 if (ud and ud.name == "hand") then
  Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
 end
end


--------------------------------------------------------------------------------
-- During the first frame, UnitCreated is called and do its GiveOrderToUnit
-- But said orders are ignored, and so first starting kernel/hole doesn't start
-- with repeat on. This function fixes that.

local facing,x,z,n=0,0,0,0

-- Count all homebases and set them to repeat
function widget:GameFrame(f)
  if f==2 then
    if Spring.GetTeamUnitCount(Spring.GetMyTeamID()) and Spring.GetTeamUnitCount(Spring.GetMyTeamID())>0 then
      for k,unitID in pairs(Spring.GetTeamUnits(Spring.GetMyTeamID())) do
        local unitDefID=Spring.GetUnitDefID(unitID)
        if unitDefID then
          local ud = UnitDefs[unitDefID]
          if(ud and ((ud.name == "kernel") or (ud.name == "hole") or (ud.name == "holeold") or (ud.name == "carrier") or (ud.name == "thbase") or (ud.name == "hand"))) then
            local ux
            local uz
            ux,_,uz=Spring.GetUnitPosition(unitID)
            x=x+ux
            z=z+uz
            n=n+1
            Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
          end
        end
      end
    end
    x=x/n
    z=z/n
    widget.widgetHandler.RemoveCallIn(widget.widget,"GameFrame")
  end
end

-- Set buildfacing the first time a building is about to be built
function widget:Update()
  local _,cmd=Spring.GetActiveCommand()
  if cmd and cmd<0 then
    if math.abs(Game.mapSizeX - 2*x) > math.abs(Game.mapSizeZ - 2*z) then
      if (2*x>Game.mapSizeX) then
        facing="west"
      else
       facing="east"
      end
    else
      if (2*z>Game.mapSizeZ) then
        facing="north"
      else
        facing="south"
      end
    end
    Spring.SendCommands({"buildfacing "..facing})
    widget.widgetHandler.RemoveCallIn(widget.widget,"Update")
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
