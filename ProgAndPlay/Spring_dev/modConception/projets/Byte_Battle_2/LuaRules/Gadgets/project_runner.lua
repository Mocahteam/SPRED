
function gadget:GetInfo()
  return {
    name      = "Project Runner",
    desc      = "Runs a project",
    author    = "muratet",
    date      = "Jan 18, 2010",
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
	
	local level = Spring.GetModOptions()["level"] -- get the level
	
	function gadget:GameFrame( frameNumber )
		if frameNumber == 0 then
			Spring.Echo ("level : "..level)
			-- Destroy all units to let a free environnment for this project
			local units = Spring.GetAllUnits()
			for i = 1,table.getn(units) do
				Spring.DestroyUnit(units[i], false, true)
			end
			-- units initialisation
			local teamList = Spring.GetTeamList()
			-- for each team
			for i = 1,table.getn(teamList) do
				if teamList[i] ~= Spring.GetGaiaTeamID() then
					-- store startX position
					local startX, startY, startZ = Spring.GetTeamStartPosition(teamList[i])
					-- define units' orientation depending on startX
					local orientation
					local sens
					if startX < Game.mapSizeX/2 then
						orientation = "e"
						sens = 1
					else
						orientation = "w"
						sens = -1
					end
					-- setup units depending on level
					if (level == "1" or level == "2") then
						local _, _, _, isAI = Spring.GetTeamInfo(teamList[i])
						if isAI then
							-- add a unit
							local u = Spring.CreateUnit("byte", startX, Spring.GetGroundHeight(startX, startZ), startZ, orientation, teamList[i])
							-- set FireState to "Return fire" == 1
							Spring.GiveOrderToUnit(u, CMD.FIRE_STATE, {1}, {});
						else
							-- add a fisrt unit
							local u = Spring.CreateUnit("byte", startX, Spring.GetGroundHeight(startX, startZ-100), startZ-100, orientation, teamList[i])
							-- set FireState to "Return fire" == 1
							Spring.GiveOrderToUnit(u, CMD.FIRE_STATE, {1}, {});
							-- add a second unit
							u = Spring.CreateUnit("byte", startX, Spring.GetGroundHeight(startX, startZ+100), startZ+100, orientation, teamList[i])
							-- set FireState to "Return fire" == 1
							Spring.GiveOrderToUnit(u, CMD.FIRE_STATE, {1}, {})
						end
					else
						local nbcol = 4 -- number of units columns
						local colsep = 250 -- separation between columns
						for col = 1,nbcol do
							-- compute x in order to center columns 1 and 2 on startX
							local x = startX+sens*((col-1.5)*colsep)
							local nblig = 12 -- number of units lines
							for lig = 1,nblig do
								z = (lig - 1/2) * (Game.mapSizeZ / nblig)
								-- add a unit
								local u = Spring.CreateUnit("byte", x, Spring.GetGroundHeight(x, z), z, orientation, teamList[i])
								-- set FireState to "Return fire" == 1
								Spring.GiveOrderToUnit(u, CMD.FIRE_STATE, {1}, {});
							end
						end
					end
				end
			end
		end
		
		if level == "2" and frameNumber == 20 then
			-- look for AI start position
			local teamList = Spring.GetTeamList()
			for j = 1,table.getn(teamList) do
				local _, _, _, iAmAI = Spring.GetTeamInfo(teamList[j])
				if iAmAI then
					local AIstartX, AIstartY, AIstartZ = Spring.GetTeamStartPosition(teamList[j])
					Spring.MarkerAddPoint(AIstartX, Spring.GetGroundHeight(AIstartX, AIstartZ), AIstartZ, "AI start position\n("..AIstartX..", "..AIstartZ..")")
				end
			end
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
	
	-- used to disable the mouse
	local mouseDisabled = false

	function gadget:MousePress(x, y, button)
		if mouseDisabled then
			return true
		end
	end
	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
