
function gadget:GetInfo()
  return {
    name      = "Presentation Runner",
    desc      = "Create units for presentation",
    author    = "muratet",
    date      = " 28 mai 2013",
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

function gadget:GameFrame( frameNumber )
	-- initialize mission
	if frameNumber == 10 then
		Spring.CreateUnit("bit", 980, Spring.GetGroundHeight(980, 1792), 1792, "s", 1)
		Spring.CreateUnit("bit", 880, Spring.GetGroundHeight(880, 1692), 1692, "s", 1)
		Spring.CreateUnit("bit", 900, Spring.GetGroundHeight(900, 1810), 1810, "s", 1)
		Spring.CreateUnit("byte", 920, Spring.GetGroundHeight(920, 1920), 1920, "s", 1)
		Spring.CreateUnit("bit", 980, Spring.GetGroundHeight(980, 1632), 1632, "s", 1)
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

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
