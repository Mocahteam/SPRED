-- $Id: room_unitInfo.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Complete Annihilation unit and weapon statistics interface.
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Constants
--


local unitPicSize = 96


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Locals
--

local function GetDPS(weaponDef)
  
  local damage      = weaponDef.damages[0] or 0
  local reloadTime  = weaponDef.reload                  
  local salvoSize   = weaponDef.salvoSize
  local salvoDelay  = weaponDef.salvoDelay
  local projectiles = 1 -- not accessible from Lua
  return  salvoSize * damage * projectiles / reloadTime
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Unit Selection Request Window
--


pleaseSelect = Window:Create{
  x = 208,
  y = 100,
  closed = true,
  text = "Please select a unit.",
  tabs = {
    {title = "OK",
       position = "left",
       OnMouseReleaseAction = function()
          pleaseSelect:Close()
          MakeInfoWindow()
       end
    },
    {title = "Cancel",
     position = "right",
     OnMouseReleaseAction = function()
        pleaseSelect:Close()
        if (mainMenu.closed) then
          mainButton:Open()
        end
      end
    },
  }
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Unit Information Window Builder
--


function MakeInfoWindow(unitDefID, previousGroup)
  
  local lineArray = {}
  local group = tostring(lineArray) -- Make a string that is unique as long as
  local unitID                      -- the window exists.
  
  if not(unitDefID) then
    unitID = Spring.GetSelectedUnits()[1]
    if (not unitID) then
      pleaseSelect:Open()
      return
    end
    unitDefID = Spring.GetUnitDefID(unitID)
  end
  
  local unitDef = UnitDefs[unitDefID]
  
  local function Line(lineString)
    table.insert(lineArray, lineString)
  end
  
  Line(unitDef.humanName)
   -- Commander tooltips are "Commander".
  if (unitDef.name ~= "armcom" and unitDef.name ~= "corcom") then
    Line(unitDef.tooltip)
  end
  Line""

  
-- Resources -------------------------------------------------------------------


  local energyMake     = unitDef.energyMake
  local metalMake      = unitDef.metalMake
  local energyStorage  = unitDef.energyStorage
  local metalStorage   = unitDef.metalStorage
  local energyUpkeep   = unitDef.energyUpkeep
  local metalUpkeep    = unitDef.metalUpkeep
  local extractRange   = unitDef.extractRange
  local tidalGenerator = unitDef.tidalGenerator
  local windGenerator  = unitDef.windGenerator
  
  Line"Resources"
  
  -- CA's windmills are scripted in Lua and have no windmill fbi tags.
  if (unitDef.name == "armwin" or unitDef.name == "corwin") then
    Line"- Wind generator"
  end
  
  Line("- Energy cost: "..ToSI(unitDef.energyCost))
  Line("- Metal cost: "..ToSI(unitDef.metalCost))
  Line("- Build time: "..ToSI(unitDef.buildTime))
  
  
  if (energyMake > 0.001) then
    Line("- Energy production: "..ToSI(unitDef.energyMake))
  end  
  
  
  if (metalMake > 0.001) then
    Line("- Metal production: "..ToSI(unitDef.metalMake))
  end
  
  
  if (energyStorage and energyStorage > 0.1) then
    Line("- Energy storage: "..ToSI(energyStorage))
  end
  
  
  if (metalStorage > 0.1) then
    Line("- Metal storage: "..ToSI(metalStorage))
  end
  
  
  if (energyUpkeep > 0.1) then
    Line("- Energy upkeep: "..ToSI(energyUpkeep))
  elseif (energyUpkeep < -0.1) then -- Solars use negative upkeep.
    Line("- Energy production: "..ToSI(-energyUpkeep))
  end
  
  
  if (metalUpkeep > 0.1) then
    Line("- Metal upkeep: "..ToSI(metalUpkeep))
  end
  
  local extractsMetal = unitDef.extractsMetal
  if (extractsMetal > 0.0000001) then
    Line("- Metal extraction rate: "..ToSI(extractsMetal))
  end
  
  if (extractRange > 0.1) then
    Line("- Extract range: "..ToSI(extractRange))
  end
  
  
  if (tidalGenerator > 0.001) then
    Line("- Tidal energy output: "..ToSI(tidalGenerator))
  end
  
  if (windGenerator > 0.001) then
    Line("- Eolian energy output: "..ToSI(windGenerator))
  end
  
  
-- Movement --------------------------------------------------------------------

  
  if (unitDef.canMove) then
    Line""
    Line"Movement"
    
    if (unitDef.canFly) then
      Line"- Can Fly"
    end
    
    if (unitDef.canSubmerge) then
      Line"- Can submerge"
    end
    
    if (not unitDef.transportByEnemy) then
      Line"- Can't be transported by enemy"
    end
    
    if (unitDef.hoverAttack) then
      Line"- Gunship"
    end
    
    if (unitDef.isBomber) then
      Line"- Bomber"
    end
    
    if (unitDef.isFighter) then
      Line"- Fighter"
    end
    
    Line("- Speed: "..ToSI(unitDef.speed/30)) -- So it's same unit as in FBI.
    Line("- Turn rate: "..ToSI(unitDef.turnRate))
    Line("- Acceleration: "..ToSI(unitDef.maxAcc))
    Line("- Deceleration: "..ToSI(unitDef.maxDec)) -- TODO: check if brakerate 
    Line("- Mass: "..ToSI(unitDef.mass))           -- is really divided by 10.
    
    local maxFuel = unitDef.maxFuel
    if (maxFuel > 0.01) then
      Line("- Fuel capacity: "..maxFuel)
    end
    
  end
  
  
-- Weapons and Defense --------------------------------------------------------- 
  
  
  local armoredMultiple = unitDef.armoredMultiple
  local maxWeaponRange  = unitDef.maxWeaponRange
  local autoHeal        = unitDef.autoHeal
  local idleAutoHeal    = unitDef.idleAutoHeal
  
  Line""
  Line"Weapons and defense"

  if (unitDef.canKamikaze) then
    Line"- Kamikaze"
  end
  
  if (unitDef.canDropFlare) then
    Line"- Can drop flare"
  end
  
  if (unitDef.noAutoFire) then
    Line"- Does not fire automatically"
  end
  
  if (not unitDef.reclaimable) then
    Line"- Can't be reclaimed"
  end
  
  if (unitDef.hasShield) then
    Line"- Has shield"
  end
  
  Line("- Health: "..ToSI(unitDef.health))
  if (armoredMultiple < 0.99) then
    Line("- Health while closed: "..ToSI(1/armoredMultiple*unitDef.health))
  end
  
  if (maxWeaponRange and maxWeaponRange > 0.1) then
    Line("- Maximum range: "..ToSI(maxWeaponRange))
  end
  
  if (unitDef.weapons[1]) then
    local totalDPS = 0
    for i, weapon in ipairs(unitDef.weapons) do
      local weaponID = weapon.weaponDef
      local weaponDef = WeaponDefs[weaponID]
      local DPS = GetDPS(weaponDef)
      totalDPS = totalDPS + DPS
    end
    Line("- Damage per second: "..ToSI(totalDPS))    
  end
  
  if (unitDef.canDropFlare) then
    Line("- Flare efficiency: "..ToSI(unitDef.flareEfficiency))
    Line("- Flare reload time: "..ToSI(unitDef.flareReloadTime))
    Line("- Flares dropped per salvo: "..ToSI(unitDef.flareSalvoSize))
    Line("- Flare lifetime: "..ToSI(unitDef.flareTime))
  end

  if (autoHeal > 0.1) then
    Line("- Autoheal: "..ToSI(autoHeal))
  end

  if (idleAutoHeal > 0.1) then
    local a = ToSI(idleAutoHeal+autoHeal)
    local t = ToSI(unitDef.idleTime/100)
    Line("- Autoheal is "..a.." after "..t)
    Line("  seconds of inactivity.")
  end

  
-- Builder Attributes ----------------------------------------------------------
  
  
  local buildDistance = unitDef.buildDistance
  local buildSpeed    = unitDef.buildSpeed
  local repairSpeed   = unitDef.repairSpeed
  
  if (unitDef.builder or unitDef.isFactory) then
    Line""
    Line"Builder Attributes"
    
    if (not unitDef.canBuild) then
      Line"- Can't build"
    end
    
    if (unitDef.isFactory) then
      Line"- Factory"
    end
    
    if (unitDef.needGeo) then
      Line"- Geothermal plant"
    end
    
    if (not unitDef.canAssist) then
      Line"- Can't assist"
    end
    
    if (unitDef.canCapture) then
      Line"- Can capture"
    end
    
    if (not unitDef.canReclaim) then
      Line"- Can't reclaim"
    end
    
    if (not unitDef.canRepair) then
      Line"- Can't repair"
    end
    
    if (unitDef.canResurrect) then
      Line"- Can resurrect"
    end
    
    if (unitDef.canSelfRepair) then
      Line"- Can self repair"
    end
    
    if (not unitDef.canRestore) then
      Line"- Can't restore ground"
    end
    
    if (buildDistance > 0.1) then
      Line("- Build distance: "..ToSI(buildDistance))
    end
    
    if (buildSpeed > 0.1) then
      Line("- Build speed: "..ToSI(buildSpeed))
    end
    
    if (repairSpeed > 0.1) then
      Line("- Repair speed: "..ToSI(repairSpeed))
    end
    
    if (unitDef.canCapture) then
      Line("- Capture speed: "..ToSI(unitDef.captureSpeed))
    end
    
    if (unitDef.canRestore) then
      Line("- Terraform speed: "..ToSI(unitDef.terraformSpeed))
    end
  end
  
  
-- Sensors and Dissimulation ---------------------------------------------------
  
  
  local radarRadius      = unitDef.radarRadius
  local sonarRadius      = unitDef.sonarRadius
  local jammerRadius     = unitDef.jammerRadius
  local sonarJamRadius   = unitDef.sonarJamRadius
  local seismicRadius    = unitDef.seismicRadius
  local seismicSignature = unitDef.seismicSignature
  
  Line""
  Line"Sensors and Dissimulation"
  
  if (unitDef.canCloak) then
    Line"- Can cloak"
  end
  
  if (unitDef.stealth) then
    Line"- Is stealthy"
  end
  
  if (unitDef.hideDamage) then
    Line"- Damage is hidden"
  end
  
  if (not unitDef.decloakOnFire) then
    Line"- Can fire while cloaked"
  end
  
  Line("- Line of sight radius: "..ToSI(unitDef.losRadius * 32))
  
  if (radarRadius > 0.1) then
    Line("- Radar range: "..ToSI(radarRadius))
  end
  
  if (sonarRadius > 0.1) then
    Line("- Sonar range: "..ToSI(sonarRadius))
  end
  
  if (seismicRadius > 0.1) then
    Line("- Seismic detector range: "..ToSI(seismicRadius))
  end
  
  if (jammerRadius > 0.1) then
    Line("- Jammer range: "..ToSI(jammerRadius))
  end
  
  if (sonarJamRadius > 0.1) then
    Line("- Sonar jammer range: "..ToSI(sonarJamRadius))
  end
  
  
  if (seismicSignature > 0.1) then
    Line("- Seismic signature: "..ToSI(seismicSignature))
  end
  
  if (unitDef.canCloak) then
    Line("- Stationary cloak cost: "..ToSI(unitDef.cloakCost))
    Line("- Moving cloak cost: "..ToSI(unitDef.cloakCostMoving))
    Line("- Decloak distance: "..ToSI(unitDef.decloakDistance))
  end
  
  
-- Transport -------------------------------------------------------------------
  
  
  local transportCapacity = unitDef.transportCapacity
  if (unitDef.transportCapacity > 0.1) then
    
    Line""
    Line"Transport"
    
    if (unitDef.isFirePlatform) then
      Line"- Transported units can fire"
    end
    Line("- Transport unit capacity: "..ToSI(unitDef.transportCapacity))
    Line("- Transport mass capacity: "..ToSI(unitDef.transportMass))
    Line("- Maximum transported unit size: "..ToSI(unitDef.transportSize))
    Line("- Loading radius: "..ToSI(unitDef.loadingRadius))

  end
  
  
-- Other -----------------------------------------------------------------------

    
  Line""
  Line"Other"
  Line("- Unit size: "..ToSI(unitDef.xsize * unitDef.ysize))
  Line("- Unit code: "..unitDef.name)
  
  
-- Unit information window creation -------------------------------------------- 


  local windowParams = {
    x = 208,
    y = 100,
    lineArray = lineArray,
    group = group,
    font = "FreeMonoBold_12",
    tabs = {
      {title = "Unit Information: "..unitDef.humanName},
      {title = "Close",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
        end
      },
      {title = "Ratios",
        position = "left",
        OnMouseReleaseAction = function()
          CloseGroup(group)
          MakeRatiosWindow(unitDefID, group)
        end,
      },
        
    }
  }
  
  if (previousGroup) then
    table.insert(windowParams.tabs, {
        title = "Back",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
          OpenGroup(previousGroup)
        end,
      }
    )
  end
  
  if (#unitDef.buildOptions > 0) then
    table.insert(windowParams.tabs, {
        title = "Build Options",
        position = "left",
        OnMouseReleaseAction = function()
          CloseGroup(group)
          MakeBuildOptionsWindow(unitDefID, group)
        end,
      }
    )
  end
  
  if (unitDef.weapons[1]) then
    table.insert(windowParams.tabs, {
      title = "Weapon Overview",
      position = "left",
      OnMouseReleaseAction = function()
        CloseGroup(group)
        MakeWeaponsOverview(unitDefID, group)
      end}
    )
  end
  
  local function MakeWeaponInfoTab(weaponID, previousGroup, weaponNumber)
    return {
    title = "Weapon "..weaponNumber,
    position = "left",
    OnMouseReleaseAction = function()
      MakeWeaponWindow(weaponID, previousGroup)
    end,
    }
  end
  
  for i, weapon in ipairs(unitDef.weapons) do
    local weaponID = weapon.weaponDef

    local weaponInfoTab = MakeWeaponInfoTab(weaponID, group, i)
    table.insert(windowParams.tabs, weaponInfoTab)
  end
  
  local window = Window:Create(windowParams)
  
  
-- Unit Picture Window Prototype -----------------------------------------------
 
 
  window.unitPicWindow = Window:Create{
    x1 = 100, 
    y1 = 100, 
    x2 = 100 + unitPicSize, 
    y2 = 100 + unitPicSize,
    group = group,
    unitPicByID = unitDefID,
  }
  
  return window, group
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Weapon Information Window Builder
--


function MakeWeaponWindow(weaponID, previousGroup)
      
  CloseGroup(previousGroup) -- FIXME: pointless?
  
  local lineArray = {}
  local group = tostring(lineArray) -- Make a string that is unique as long as
                                    -- the window exists.
  local weaponDef = WeaponDefs[weaponID]
  
  local function Line(lineString)
    table.insert(lineArray, lineString)
  end
 
  Line("Type: "..weaponDef.type)
  
  if (not (weaponDef.type == "AircraftBomb")) then
    Line("Range: "..ToSI(weaponDef.range))
    -- Line("Height advantage: "..ToSI(weaponDef.heightmod)) FIXME
    Line("Accuracy")
    if (weaponDef.accuracy == 0) then
      Line" - while stationary: perfect."
    else
      Line(" - while stationary: ".. string.format("%.2f deg", 180 / math.pi * math.asin(weaponDef.accuracy)))
    end
    if (weaponDef.movingAccuracy == 0) then
      Line" - while moving: perfect."
    else
      Line(" - while moving: ".. string.format("%.2f deg", 180 / math.pi * math.asin(weaponDef.movingAccuracy)))
    end
    if (weaponDef.sprayAngle == 0) then
      Line" - of salvo: perfect."
    else
      Line(" - of salvo: ".. string.format("%.2f deg", 180 / math.pi * math.asin(weaponDef.sprayAngle)))
    end
  end
  
  if (weaponDef.targetMoveError and weaponDef.targetMoveError > 0) then
    local s = "Error in targeting moving units: %.2f"
    Line(string.format(s, weaponDef.targetMoveError))
  end
  
  Line("Reload time: "..ToSI(weaponDef.reload))
  
  if (weaponDef.salvoSize > 1) then
    Line(string.format("Salvo size: %d", weaponDef.salvoSize))
    Line("Salvo delay: "..ToSI(weaponDef.salvoDelay))
  end
  
  local salvoSize = weaponDef.salvoSize
  local salvoDelay = weaponDef.salvoSize
  local reload = weaponDef.reload
  local damage = weaponDef.damages[0] or 0
  local dps = GetDPS(weaponDef)
  
  Line(string.format("Damage per shot: %d", damage))
  Line(string.format("Damage per second: %d", dps))
  
  Line("Area of effect: "..ToSI(weaponDef.areaOfEffect))
  Line("Shockwave speed: "..ToSI(weaponDef.explosionSpeed))
  
  if (weaponDef.edgeEffectiveness and weaponDef.edgeEffectiveness > 0) then
    local s = "Damage factor at the edge of the area of effect: %.2f"
    Line(string.format(s, weaponDef.edgeEffectiveness))
  end
  
  if (weaponDef.coverageRange > 0) then
    Line("Anti-nuke protection range "..ToSI(weaponDef.coverageRange))
  end
  
  if (weaponDef.damages.impulseFactor ~= 1 and 
      weaponDef.damages.impulseFactor ~= 0) then
    Line("Impulse factor: "..ToSI(weaponDef.damages.impulseFactor))
    Line("Impulse boost: "..ToSI(weaponDef.damages.impulseBoost))
    Line"N.B. Impulse = (Damage + Impulse Boost) * Impulse Factor" -- Check
  end
  
  if (weaponDef.type == "MissileLauncher" or
      weaponDef.type == "StarburstLauncher") then
    if (weaponDef.startVelocity) then
      Line("Missile start velocity: "..ToSI(weaponDef.startVelocity))
      Line("Missile acceleration: "..ToSI(weaponDef.weaponAcceleration))
      Line("Missile maximum velocity: "..ToSI(weaponDef.maxVelocity))
    else
      Line("Missile velocity: "..ToSI(weaponDef.maxVelocity))
    end
    
    if (weaponDef.trajectoryHeight > 0) then
      Line("Missile trajectory height: "..ToSI(weaponDef.trajectoryHeight))
    end 
    
    if (weaponDef.wobble > 0) then
      Line("Missile wobble factor: "..ToSI(weaponDef.wobble))
    end
  end
  
  if (weaponDef.projectileSpeed) then
    Line("Projectile speed: "..ToSI(weaponDef.projectileSpeed))
  end
  
  if (weaponDef.type == "BeamLaser") then
    Line("Projectile speed: "..ToSI(weaponDef.maxVelocity))
  end
  
  if (not weaponDef.canAttackGround) then
    Line"Can't be forced to fire on groud spot."
  end
  
  if (weaponDef.stockpile) then
    Line"Ammunition must be stockpiled."
  end
  
  if (weaponDef.collisionNoFeature) then
    Line"Doesn't collide with terrain features or wrecks."
  end
  
  if (weaponDef.collisionNoFriendly) then
    Line"Doesn't collide with friendly units."
  end
  
  if (not weaponDef.avoidFriendly) then
    Line"Doesn't try to avoid hitting friendlies."
  end  
  
  if (weaponDef.tracks) then
    Line"Tracks."  -- FIXME: Explain
  end
  
  if (weaponDef.guided) then
    Line"Is guided."
  end
  
  if (weaponDef.vlaunch) then
    Line"Is launched vertically."
  end
  
  if (weaponDef.paralyzer) then
    Line"Deals paralyze damage."
    local s = "Paralyze time: %d"
    Line(string.format(s, weaponDef.damages.paralyzeDamageTime))
  end
  
  if (weaponDef.noSelfDamage) then
    Line"No self damage."
  end
  
  if (weaponDef.gravityAffected) then
    Line"Ballistic trajectory."
  end
  
  
-- Weapon Information Window Creation ------------------------------------------

  
  local window = Window:Create{
    x = 208,
    y = 100,
    lineArray = lineArray,
    group = group,
    font = "FreeMonoBold_12",
    tabs = {
      {title = "Weapon Information: "..weaponDef.name},
      {title = "Close",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
        end
      },
      {title = "Back",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
          OpenGroup(previousGroup)
        end
      },
      {title = "Detailed Damage",
        position = "left",
        OnMouseReleaseAction = function()
        MakeDamageWindow(weaponID, group)
      end
      },      
    }
  }
  
  
  return window, group
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Detailed Damage Window Builder
--


function MakeDamageWindow(weaponID, previousGroup)
      
  CloseGroup(previousGroup)
  
  local lineArray = {}
  local group = tostring(lineArray) -- Make a string that is unique as long as
                                    -- the window exists. 
  local weaponDef = WeaponDefs[weaponID]
  local damages = weaponDef.damages or {} -- damage table
  
  local function Line(lineString)
    table.insert(lineArray, lineString)
  end
  
  Line(string.rep("-", 1+14+9+9))
  Line(string.format("|%-13s|%8s|%8s|", "Category", "Damage","DpS*"))
  Line(string.rep("-", 1+14+9+9))
  
  for category, damage in pairs(damages) do
    local category = Game.armorTypes[category] or 0
    local dps = GetDPS(weaponDef)
    Line(string.format("|%-13s|%8d|%8d|", category, damage, dps))
  end
  
  Line(string.rep("-", 1+14+9+9))
  
  Line"* DpS: Damage per Second, estimated."


-- Detailed Damage Window Creation ------------------------------------------

  
  local window = Window:Create{
    x = 208,
    y = 100,
    lineArray = lineArray,
    group = group,
    font = "FreeMonoBold_12",
    tabs = {
      {title = "Detailed Damage: "..weaponDef.name},
      {title = "Close",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
        end
      },
      {title = "Back",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
          OpenGroup(previousGroup)
        end
      },
    }
  }
  
  
  return window, group
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Build Options Window Builder
--


local function MakeBuildMatrix(unitDefID) -- makes as square a matrix of build 
                                          -- option unitDefIDs as possible.
  local unitDef = UnitDefs[unitDefID]
  local buildOptions = unitDef.buildOptions
  local Counter = MakeCounter()
  local buildMatrix = {}
  local a, b, c, d = buildOptions.n
  
  if ( a > 5) then -- Get matrix sizes.
    b = a^0.5
    c = math.floor(b) -- sides
    d = a - c^2 -- last row    
  end

  for i=1, c do -- Make a square matrix.
    for j = 1, c do
      if (j == 1) then
        buildMatrix[i] = {}
      end
      buildMatrix[i][j] = buildOptions[Counter()] -- Fill the matrix with build
    end                                           -- option unitDefIDs.
  end
  
  if (d > 0) then -- Fill last row.
    for i=1, d do
      if (i == 1) then
        buildMatrix[c+1] = {}
      end
      buildMatrix[c+1][i] = buildOptions[Counter()]
    end
  end
  
  -- for k, v in ipairs(buildMatrix) do
    -- print(unpack(v))
  -- end
  
  return buildMatrix
end


function MakeBuildOptionsWindow(unitDefID, previousGroup)
  
  local lineArray = {}
  local group = tostring(lineArray) -- Make a string that is unique as long as
                                    -- the window exists.  
  local unitDef = UnitDefs[unitDefID]
  
  local corner = 100
  local border = 4
  
  local buildMatrix = MakeBuildMatrix(unitDefID)
  
  
  -- Background window prototype -----------------------------------------------
  
  
  local window = Window:Create{
    group = group,
    -- Dirty hack to prevent lineArray from being collected as garbage as long 
    -- as the window exists, in order to keep the "group" string unique.
    -- FIXME: maybe unnecessary: is lineArray kept as an upvalue anyway?
    _ = lineArray, 
    x1 = corner - border,
    y1 = corner - border,
    x2 = corner + (#buildMatrix[1])*(unitPicSize + border),
    y2 = corner + (#buildMatrix   )*(unitPicSize + border),
    tabs = {
      {title = unitDef.humanName.." Build Options"},
      {title = "Close",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
        end
      },
      {title = "Back",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
          OpenGroup(previousGroup)
        end
      },
    },
  }
  
  
  -- Unit picture buttons creation ---------------------------------------------
  
  
  local function MakeUnitPicWindow(unitDefID, x, y)
    local unitPicWindow = Window:Create{
      x1 = x, 
      y1 = y, 
      x2 = x + unitPicSize, 
      y2 = y + unitPicSize,
      group = group,
      unitPicByID = unitDefID,
      OnMousePressAction = function()
        window[unitDefID]  = MakeTimer()
        return true
      end,
      OnMouseReleaseAction = function()
        if (window[unitDefID]()  < 0.2) then
          CloseGroup(group)
          MakeInfoWindow(unitDefID, group)
        end
      end,
    }
  end  
  
  for column, rowArray in ipairs(buildMatrix) do
    for row, optionID in ipairs(rowArray) do
      MakeUnitPicWindow(
        optionID, 
        (unitPicSize + border)*row, 
        (unitPicSize + border)*column
      )
    end
  end
  
  
  return window, group
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Ratios Window Builder
--


function MakeRatiosWindow(unitDefID, previousGroup)
  
  local lineArray = {}
  local group = tostring(lineArray) -- Make a string that is unique as long as
                                    -- the window exists.  
  local unitDef = UnitDefs[unitDefID]
  local weapons =  unitDef.weapons
  
  local function Line(lineString)
    table.insert(lineArray, lineString)
  end
  
  local MC  = unitDef.metalCost
  local EC  = unitDef.energyCost
  local BT  = unitDef.buildTime
  local GC  = EC+MC
  local HP  = unitDef.health
  local AH  = unitDef.autoHeal
  local IAH = unitDef.idleAutoHeal
  local BS  = unitDef.buildSpeed
  
  Line"Cost"
  Line("- Metal Cost (MC): "..ToSI(MC))
  Line("- Energy Cost (EC): "..ToSI(EC))
  Line("- Build Time (BT): "..ToSI(BT))
  Line("- Metal Drain (MC/BT): "..ToSI(MC/BT))
  Line("- Energy Drain (EC/BT): "..ToSI(EC/BT))
  Line("- Energy to Metal Ratio (EC/MC): "..ToSI(EC/MC))
  Line("- Adjusted Cost (GC = EC+MC): "..ToSI(GC))
  Line(string.format("- Energy part of cost (EC/GC): %.2f", EC/GC))
  Line""
  
  Line"Defense"
  Line("- Health (HP): "..ToSI(HP))
  Line("- HP/MC: "..ToSI(HP/MC))
  Line("- HP/GC: "..ToSI(HP/MC))
  Line("- Complete regeneration time: "..ToSI(HP/(AH+IAH)).."s")
  Line""
  
  if (unitDef.canBuild) then
    Line"Build Ratios"
    Line("- Build Speed (BS): "..ToSI(BS))
    Line("- BS/MC: "..ToSI(BS/MC))
    Line("- BS/GC: "..ToSI(BS/GC))
    Line""
  end
  
  if (unitDef.energyMake > 0.1) then
    Line"Resource Production"
    Line("- Energy production: "..ToSI(unitDef.energyMake))
    Line("- Break-even time: "..ToSI(GC/unitDef.energyMake).."s")
    Line""
  end
  
  if (unitDef.energyUpkeep < -0.1) then
    Line"Resource Production"
    Line("- Energy production: "..ToSI(-unitDef.energyUpkeep))
    Line("- Break-even time: "..ToSI(-GC/unitDef.energyUpkeep).."s")
    Line""
  end
  
  if (unitDef.weapons[1]) then
    Line"Weapons"
    local totalDPS = 0
    local width = 1+21+9+9+9+9
    local s = "  |%-20s|%8s|%8s|%8s|%8s|"
    
    Line("  "..string.rep("-", width))
    Line(string.format(s, "Weapon", "DpS", "DpS/MC", "DpS/EC", "DpS/GC"))
    Line("  "..string.rep("-", width))
    
    for i, weapon in ipairs(unitDef.weapons) do
      
      local weaponID  = weapon.weaponDef
      local weaponDef = WeaponDefs[weaponID]
      local damage    = weaponDef.damages[0] or 0
      local reload    = weaponDef.reload
      local salvo     = weaponDef.salvoSize
      local name      = weaponDef.name
      local DPS       = GetDPS(weaponDef)
      totalDPS        = totalDPS + DPS
      
      local s = "  |%-20s|%8d|%8s|%8s|%8s| "
      s = string.format(s, name, DPS, ToSI(DPS/MC), ToSI(DPS/EC), ToSI(DPS/GC))
      Line(s)
    
    end
    Line("  "..string.rep("-", width))
    
    local function f(n)
      return ToSI(totalDPS/n)
    end
    s = "  |%-20s|%8s|%8s|%8s|%8s|"
    s = string.format(s, "Total", ToSI(totalDPS), f(MC), f(EC), f(GC))
    Line(s)
    Line("  "..string.rep("-", width))
    
  end
    
  
  -- Window Prototype ----------------------------------------------------------
  
  
  local windowParams = {
    x = 208,
    y = 100,
    lineArray = lineArray,
    group = group,
    font = "FreeMonoBold_12",
    tabs = {
      {title = "Ratios: "..unitDef.humanName},
      {title = "Close",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
        end,
      },
      {title = "Back",
       position = "right",
       OnMouseReleaseAction = function()
         CloseGroup(group)
         OpenGroup(previousGroup)
       end,
      },
    },
  }
  
  local window = Window:Create(windowParams)
  
  
  return window, group
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Weapons Overview Builder
--


function MakeWeaponsOverview(unitDefID, previousGroup)
  
  local lineArray = {}
  local group = tostring(lineArray) -- Make a string that is unique as long as
                                    -- the window exists.  
  local unitDef = UnitDefs[unitDefID]
  local weapons =  unitDef.weapons
  
  local function Line(lineString)
    table.insert(lineArray, lineString)
  end

  local width = 1+21+8+9+12+13+10+7+7+10
  
  Line(" "..string.rep("-", width))
  local s = " |%-20s|%7s|%8s|%11s|%12s|%9s|%6s|%6s|%9s| "
  s = string.format(s, 
    "Weapon", 
    "Range",
    "Damage",
    "Salvo size",
    "Reload Time",
    "Accuracy",
    "AoE",
    "DpS",
    "DpS/cost"      
  )
  Line(s)
  Line(" "..string.rep("-", width))
  
  for i, weapon in ipairs(unitDef.weapons) do
    
    local weaponID = weapon.weaponDef
    local weaponDef = WeaponDefs[weaponID]
    
    local damage = weaponDef.damages[0] or 0
    local DpS = GetDPS(weaponDef)
    
    local function GetDefaultDmg()
      return weaponDef.damages[0] or 0
    end
    local s = " |%-20s|%7s|%8d|%11d|%12s|%9s|%6s|%6s|%9s| "
    s = string.format(s, 
      weaponDef.name, 
      ToSI(weaponDef.range),
      GetDefaultDmg(),
      weaponDef.salvoSize,
      ToSI(weaponDef.reload),
      string.format("%.2f deg", 180 / math.pi * (math.asin(weaponDef.accuracy) + math.asin(weaponDef.sprayAngle))),
      ToSI(weaponDef.areaOfEffect),
      ToSI(DpS),
      ToSI(DpS/(weaponDef.energyCost+weaponDef.metalCost))
    )
      
    Line(s)
  
  end
  
  Line(" "..string.rep("-", width))

  local windowParams = {
    x = 208,
    y = 100,
    lineArray = lineArray,
    font = "FreeMonoBold_12",
    group = group,
    tabs = {
      {title = "Weapon Overview: "..unitDef.humanName},
      {title = "Close",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group)
        end,
      },
      {title = "Back",
       position = "right",
       OnMouseReleaseAction = function()
         CloseGroup(group)
         OpenGroup(previousGroup)
       end,
      },
    },
  }
  
  local window = Window:Create(windowParams)
  
  
  return window, group
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Notes
--
  
-- energy Break even
-- Show BuildOptions
-- Show Weapon
-- Save to file
-- Handle shields correctly
-- % function
-- Add selfD and death weapons
-- for k, v in WeaponDefs[weaponID]:pairs() do print(k, v) end
-- table.foreach(WeaponDefs[weaponID].damages.damages, print)
-- MakeWeaponsOverview(Spring.GetUnitDefID(Spring.GetSelectedUnits()[1]), "mainMenu")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------