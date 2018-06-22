
-- In most lobbies it's called "Bonus", and can be set for any player by the host
-- In the startscript, it bears the misleading name of "Handicap"
-- Ingame, it translates into an income multiplier, applied to metal and energy production
-- Since Kernel Panic has no resource management, I use this gadget to translate it into a damage reduction
-- The higher the Bonus for a player, the less damage it takes from others
-- The number you set in lobby is actually the damage reduction, from 0 (full damage) to 100 (total immunity)
-- To be precise, it uses the difference of bonus between the two teams, discarding it when negative
-- For exemple, team 1 has a bonus of 30%, team 2 has a bonus of 50% :
-- then team 1 damage to team 2 is reduced by 20% (deals only 80% of the damage)
-- but team 2 damage to team 1 isn't modified (still deal 100% damage, not 120%)

function gadget:GetInfo()
	return {
		name = "Armor Bonus",
		desc = "Translate Bonus (Handicap in startscript) into a damage reduction",
		author = "zwzsg",
		date = "8 november 2011",
		license = "Free",
		layer = 50,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

	local DamageMultipliers = nil -- Will be a double array, of values beween 0 (no damage) and 1 (full damage)

	function gadget:Initialize()
		local Bonuses={} -- From 0 to 100, as set in the lobbies and startscripts (called Handicap in startscripts)
		local MaxBonus=0
		for _,team in ipairs(Spring.GetTeamList()) do
			local incomeMultiplier = select(8,Spring.GetTeamInfo(team))
			Bonuses[team]=math.floor(((incomeMultiplier or 1)-1)*100+0.5)
			if Bonuses[team]>MaxBonus then
				MaxBonus=Bonuses[team]
			end
		end
		if MaxBonus==0 then
			gadgetHandler:RemoveGadget()
			return
		end
		DamageMultipliers={}
		for _,defender in ipairs(Spring.GetTeamList()) do
			DamageMultipliers[defender]={}
			for _,attacker in ipairs(Spring.GetTeamList()) do
				DamageMultipliers[defender][attacker]=math.min(1,(1-(Bonuses[defender]-Bonuses[attacker])/100))
				Spring.Echo("Team"..attacker.." deals "..math.floor(DamageMultipliers[defender][attacker]*100+0.5).."% dmg to Team"..defender)
				if DamageMultipliers[defender][attacker]==0 then
					Spring.Echo("Warning: Team"..defender.." is immune to Team"..attacker)
				end
			end
		end
		GG.ArmorBonusDamageMultipliers=DamageMultipliers
	end

	-- The addition of a projectile parameter in 94.0 caused the parameters au, aud, ateam to shift
	-- For version prior to 94.0:
	--function gadget:UnitPreDamaged(defenderID, defenderDefID, defenderTeam, damage, paralyzer, weaponDefID, attackerID, attackerDefID, attackerTeam)
	-- For 94.0 and beyond
	function gadget:UnitPreDamaged(defenderID, defenderDefID, defenderTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
		if attackerDefID and not attackerTeam then-- Fix to add retrocompatibility
			attackerID, attackerDefID, attackerTeam = projectileID, attackerID, attackerDefID
		end
		if damage>0.0001 and defenderTeam and attackerTeam then
			return damage*DamageMultipliers[defenderTeam][attackerTeam]
		end
	end

end
