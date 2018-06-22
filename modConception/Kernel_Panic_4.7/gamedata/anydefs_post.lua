--------------------------------------------------------------------------------
-- Don't crash unitsync
--------------------------------------------------------------------------------
local ModOptionsAvailable = Spring and Spring.GetModOptions and Spring.GetModOptions()

--------------------------------------------------------------------------------
-- Remove the shields from the FBIs when not using ONS mode
--------------------------------------------------------------------------------
if ModOptionsAvailable and (Spring.GetModOptions()["ons"]==nil or Spring.GetModOptions()["ons"]=="0") then
  for name, ud in pairs(UnitDefs) do
    if ud.weapons then
      local fakeWeapon=nil
      if ud.weapons[1] and ud.weapons[1].name=="BuildLaser" then
        fakeWeapon=ud.weapons[1]
      end
      for n,wd in pairs(ud.weapons) do
        if ud.weapons[n] and (
            ud.weapons[n].name=="homebaseshieldgood" or ud.weapons[n].name=="homebaseshieldbad"
            or ud.weapons[n].name=="minifacshieldgood" or ud.weapons[n].name=="minifacshieldbad"
            ) then
          --Spring.Echo("removing "..ud.weapons[n].name.." from "..ud.name)
          ud.weapons[n]=fakeWeapon
          -- Spring allows to have nil in weapon 1-3 (while checking for subsequent weapons) but only 1-3
          -- However, the number used when cob emit a weapon would be changed
        end
      end
    end
  end
end


--------------------------------------------------------------------------------
-- Create Heroes units
--------------------------------------------------------------------------------
if ModOptionsAvailable then
	local homf_from={["bit"]=true,["bug"]=true,["bugold"]=true,["packet"]=true,["virus"]="Super Virus",["exploit"]=true,["fairy"]="Cirno"}
	local homf_speed=tonumber(Spring.GetModOptions()["homf_speed"]) or 2
	local homf_hp=tonumber(Spring.GetModOptions()["homf_hp"]) or 20
	local homf_regen=tonumber(Spring.GetModOptions()["homf_regen"]) or 30
	local homf_dmg=tonumber(Spring.GetModOptions()["homf_dmg"]) or 10
	local homf_range=tonumber(Spring.GetModOptions()["homf_range"]) or 1.2
	local homf_impulsefactor=tonumber(Spring.GetModOptions()["homf_impulsefactor"]) or 3
	local homf_aoe=tonumber(Spring.GetModOptions()["homf_aoe"]) or 32
	local homf_hugground=tonumber(Spring.GetModOptions()["homf_hugground"]) or 1
	local homf_collidefriendly=tonumber(Spring.GetModOptions()["homf_collidefriendly"]) or 1
	for n,ud in pairs(UnitDefs) do
		if homf_from[n] then
			local hero={}
			for key,value in pairs(ud) do
				--Spring.Echo(key,value)
				hero[key]=value
			end
			hero.unitname="mega"..hero.unitname -- Internal Name
			hero.name=type(homf_from[n])=="string" and homf_from[n] or "Mega"..hero.name -- Human Readable Name
			hero.description="hero"
			hero.script=n..".cob"
			--hero.unitrestricted=1
			hero.mass=5000
			hero.buildtime=4*hero.buildtime
			hero.maxdamage=homf_hp*hero.maxdamage
			hero.autoheal=(homf_regen~=0 and hero.maxdamage/(4*homf_regen) or 0)
			hero.idleautoheal=0
			hero.sightdistance=2*hero.sightdistance
			if hero.turnrate then
				hero.turnrate=4096
				hero.turninplace=0
			end
			if hero.maxvelocity then
				hero.maxvelocity=homf_speed*hero.maxvelocity
				if true then-- Game.version not available at this stage
					-- Because in 0.82 SetUnitMoveGoal makes unit brake before accelerating
					hero.acceleration=0.5*hero.maxvelocity -- If acceleration is over 50% maxvelocity, then it vibrates horribly
					hero.brakerate=0.7*hero.maxvelocity
				end
			end
			hero.weapons={}
			for UnitWeaponNum,UnitWeaponTable in pairs(ud.weapons) do
				-- Create the intermediate weapon table (cone of fire, target preference, and link to weapon)
				local NewUnitWeapon={}
				for key,value in pairs(UnitWeaponTable) do
					--Spring.Echo(key,value)
					if key~="maindir" and key~="maxangledif" then
						NewUnitWeapon[key]=value
					end
				end
				NewUnitWeapon.name="Heroic"..NewUnitWeapon.name
				hero.weapons[UnitWeaponNum]=NewUnitWeapon
				-- Create the new weapon
				local HeroicWeapon={}
				for key,value in pairs(WeaponDefs[string.lower(UnitWeaponTable.name)]) do
					--Spring.Echo(key,value)
					HeroicWeapon[key]=value
				end
				HeroicWeapon.name="Heroic"..HeroicWeapon.name
				HeroicWeapon.areaofeffect=homf_aoe
				HeroicWeapon.collisionsize=homf_aoe/2
				HeroicWeapon.edgeeffectiveness=1
				HeroicWeapon.impulseboost=0 -- Seem to do naught anyway
				HeroicWeapon.impulsefactor=homf_impulsefactor
				HeroicWeapon.noselfdamage=1
				HeroicWeapon.collidefriendly=homf_collidefriendly
				HeroicWeapon.avoidfriendly=0
				HeroicWeapon.avoidfeature=0
				HeroicWeapon.range=homf_range*HeroicWeapon.range
				if homf_hugground~=0 then
					HeroicWeapon.GroundBounce=1
					HeroicWeapon.BounceRebound=0.2
					HeroicWeapon.BounceSlip=1
				end
				local damage={}
				for key,value in pairs(HeroicWeapon.damage) do
					--Spring.Echo(key,value)
					damage[key]=homf_dmg*value
				end
				HeroicWeapon.damage=damage
				WeaponDefs[string.lower("Heroic"..UnitWeaponTable.name)]=HeroicWeapon
			end
			UnitDefs[hero.unitname]=hero
		end
	end
end
--------------------------------------------------------------------------------
-- Add Heroes units to homebases
--------------------------------------------------------------------------------
if ModOptionsAvailable and Spring.GetModOptions()["homf"] and Spring.GetModOptions()["homf"]~="0" then
	for n,ud in pairs(UnitDefs) do
		if n=="kernel" then
			UnitDefs[n].buildoptions[1+#ud.buildoptions]="megabit"
		elseif n=="hole" then
			UnitDefs[n].buildoptions[1+#ud.buildoptions]="megabug"
		elseif n=="holeold" then
			UnitDefs[n].buildoptions[1+#ud.buildoptions]="megabugold"
		elseif n=="carrier" then
			UnitDefs[n].buildoptions[1+#ud.buildoptions]="megapacket"
		elseif n=="thbase" then
			UnitDefs[n].buildoptions[1+#ud.buildoptions]="megafairy"
		elseif n=="hand" then
			UnitDefs[n].buildoptions[1+#ud.buildoptions]="megavirus"
		end
	end
end

--------------------------------------------------------------------------------
-- Remove secret units for lobbies
--------------------------------------------------------------------------------
if not ModOptionsAvailable then
	local SecretNames= {
		["holeold"]="Old Mystery Homebase",
		["thbase"]="Magic Mystery Homebase",
		["windowold"]="Old Mystery Minifac",
		["thminifac"]="Magic Mystery Minifac",
		["trojanold"]="Old Mystery Builder",
		["alice"]="Magic Mystery Builder",
		["fairy"]="Magic Mystery Spam",
		["bugold"]="Old Mystery Spam",
		["wormold"]="Old Mystery Heavy",
		["reimu"]="Magic Mystery Heavy",
		["marisa"]="Magic Mystery Arty",
	}
	local c=0
	for n,ud in pairs(UnitDefs) do
		if SecretNames[n] then
			c=c+1
			UnitDefs[n].unitname="U"..c -- Doesn't work: I guess it uses the key and not the unitname field of value
			UnitDefs[n].name=SecretNames[n]
			UnitDefs[n].buildpic="mineblaster.tga"
			--if UnitDefs[n].objectname=="alice.s3o" then
			--	for key,value in pairs(ud) do
			--		Spring.Echo(key,value)
			--	end
			--end
			UnitDefs[n]=nil
		end
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
