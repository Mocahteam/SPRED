
function gadget:GetInfo()
	return {
		name = "Game Over",
		desc = "Manage Game Over",
		author = "zwzsg",
		date = "2nd of July 2011",
		license = "Free",
		layer = 0,
		enabled = true
	}
end

local mokey="gamemode" -- Mod Option Key

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

	local RemainingTeamList={}
	local LifeSustainerDefIdList={}
	local CheckForGameOver=false
	local GameModeKey=1
	-- 0: Kill everything
	-- 1: Kill all factories
	-- 2: Kill homebase
	-- 3: Never ends

	VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
	-- The file kpunittypes.lua is included only to get the tables isMiniFac and isHomeBase
	-- Remove that VFS.Include ... line if you have other ways to detect MiniFac and HomeBase units

	local function isFactoryFunc(UnitDef)
		--return UnitDef.isCommander -- isCommander tag was removed since 85.0
		return isMiniFac[UnitDef.id] or isHomeBase[UnitDef.id] -- Change this to adapt to your own game
	end

	local function isHomeBaseFunc(UnitDef)
		--return UnitDef.isCommander and math.max(UnitDef.xsize,UnitDef.zsize)>=12 -- isCommander tag was removed since 85.0
		return isHomeBase[UnitDef.id] -- Change this to adapt to your own game
	end

	function gadget:Initialize()
		if not Spring.GameOver then
			gadgetHandler:RemoveGadget()
			return
		else
			if Spring.GetModOptions and Spring.GetModOptions() then
				GameModeKey=tonumber(Spring.GetModOptions()[mokey] or 1) or 1
				if GameModeKey~=0 and GameModeKey~=1 and GameModeKey~=2 and GameModeKey~=3 then
					GameModeKey=1
				end
			end
			if GameModeKey==3 then
				gadgetHandler:RemoveGadget()
				return
			elseif GameModeKey==1 or GameModeKey==2 then
				local isLifeSustainerFunc = GameModeKey==1 and isFactoryFunc or isHomeBaseFunc
				LifeSustainerDefIdList={}
				for _,ud in pairs(UnitDefs) do
					if isLifeSustainerFunc(ud) then
						table.insert(LifeSustainerDefIdList,ud.id)
					end
				end
			end
			RemainingTeamList={}
			for _,team in ipairs(Spring.GetTeamList()) do
				if team~=Spring.GetGaiaTeamID() then
					table.insert(RemainingTeamList,team)
				end
			end
		end
	end

	function gadget:GameFrame(f)
		-- Every second (don't do at first frame, cause no units then)
		if f%30==25 then
			-- Check game over condition
			if CheckForGameOver then
				--Spring.Echo("Checking if game is over")
				CheckForGameOver=false
				-- Check if there's a pair of opposing team
				areEnemiesAlive=false
				for _,team in ipairs(RemainingTeamList) do
					for _,otherTeam in ipairs(RemainingTeamList) do
						if (not Spring.AreTeamsAllied(team,otherTeam)) and (not Spring.AreTeamsAllied(otherTeam,team)) then
							areEnemiesAlive=true
						end
					end
				end
				-- If no, list the winning ally team and declare game to be over
				if not areEnemiesAlive then
					local WinningAllies={}
					local isWinningAlly={}
					for _,team in ipairs(RemainingTeamList) do
						local _,_,_,_,_,allyTeam=Spring.GetTeamInfo(team)
						--Spring.Echo("team["..team.."] of allegiance["..allyTeam.."] is amongst the winners!")
						if not isWinningAlly[team] then
							isWinningAlly[allyTeam]=true
							table.insert(WinningAllies,allyTeam)
						end
					end
					--Spring.Echo("WinningAllies={"..table.concat(WinningAllies).."}")
					Spring.GameOver(WinningAllies)
				end
			end
			-- Check if teams are still alive
			for idx,team in ipairs(RemainingTeamList) do
				if (GameModeKey==0 and #Spring.GetTeamUnits(team) or #Spring.GetTeamUnitsByDefs(team,LifeSustainerDefIdList))==0 then
					Spring.KillTeam(team)
					table.remove(RemainingTeamList,idx)
					CheckForGameOver=true
				end
			end
		end
	end

end
