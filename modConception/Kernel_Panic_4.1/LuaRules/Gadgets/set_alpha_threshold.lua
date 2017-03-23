function gadget:GetInfo()
	return {
		name = "set Alpha Threshold",
		desc = "A LUA replacement for the bos/cob command set ALPHA_THRESHOLD to alpha;",
		author = "jK & lurker & zwzsg",
		date = "9th March, 2009",
		license = "Public Domain",
		layer = 10,
		enabled = true
	}
end

GL_COLOR_BUFFER_BIT = 0x4000

if (gadgetHandler:IsSyncedCode()) then

	local function Synced_Set_Alpha_Threshold(UnitID,Alpha)
		SendToUnsynced("Unsynced_Set_Alpha_Threshold", UnitID, Alpha)
	end
	GG.Synced_Set_Alpha_Threshold = Synced_Set_Alpha_Threshold
	-- LuaCOB.lua wraps it into SetAlphaThreshold then registers it

	function gadget:UnitDestroyed(UnitID)
		SendToUnsynced("Unsynced_UnitDestroyed",UnitID)
	end

else

	local GL_COLOR_BUFFER_BIT = 0x4000

	local Alpha_List={}

	function gadget:DrawUnit(UnitID)
		if Alpha_List[UnitID] then
			gl.PushAttrib(GL_COLOR_BUFFER_BIT)
			gl.AlphaTest(GL.GREATER, Alpha_List[UnitID])
			gl.UnitRaw(UnitID,true)
			gl.PopAttrib()
		end
	end

	local function Unsynced_Set_Alpha_UnitDestroyed(name,UnitID)
		Spring.UnitRendering.SetUnitLuaDraw(UnitID,false)
		Alpha_List[UnitID]=nil;
	end

	local function Unsynced_Set_Alpha_Threshold(name,UnitID,Alpha)
		if Alpha==0 then
			Spring.UnitRendering.SetUnitLuaDraw(UnitID,false)
			Alpha_List[UnitID]=nil
		else
			Spring.UnitRendering.SetUnitLuaDraw(UnitID,true)
			Alpha_List[UnitID]=Alpha
		end
	end

	function gadget:Initialize()
		-- Since Spring 0.81.0 unit texture alpha transparency is used even without AdvUnitShading
		--if(tonumber(Spring.GetConfigInt("AdvUnitShading"))==0) then
		--	gadgetHandler:RemoveGadget()
		--	return
		--else
			gadgetHandler:AddSyncAction("Unsynced_Set_Alpha_Threshold",Unsynced_Set_Alpha_Threshold)
			gadgetHandler:AddSyncAction("Unsynced_Set_Alpha_UnitDestroyed",Unsynced_UnitDestroyed)
		--end
	end
 
end
