// WARNING: This file is machine generated,
// please do not edit directly!

/*
	Copyright (c) 2008 Robin Vobruba <hoijui.quaero@gmail.com>

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _CPPWRAPPER_UNITDEF_H
#define _CPPWRAPPER_UNITDEF_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class UnitDef {

private:
	AICallback* clb;
	int unitDefId;

	UnitDef(AICallback* clb, int unitDefId);

public:
	virtual int GetUnitDefId();

	static UnitDef* GetInstance(AICallback* clb, int unitDefId);

public:
	/**
	 * Forces loading of the unit model
	 */
	float GetHeight();

public:
	/**
	 * Forces loading of the unit model
	 */
	float GetRadius();

public:
	const char* GetName();

public:
	const char* GetHumanName();

public:
	const char* GetFileName();

public:
	int GetAiHint();

public:
	int GetCobId();

public:
	int GetTechLevel();

public:
	const char* GetGaia();

public:
	float GetUpkeep(Resource c_resourceId);

public:
	/**
	 * This amount of the resource will always be created.
	 */
	float GetResourceMake(Resource c_resourceId);

public:
	/**
	 * This amount of the resource will be created when the unit is on and enough
	 * energy can be drained.
	 */
	float GetMakesResource(Resource c_resourceId);

public:
	float GetCost(Resource c_resourceId);

public:
	float GetExtractsResource(Resource c_resourceId);

public:
	float GetResourceExtractorRange(Resource c_resourceId);

public:
	float GetWindResourceGenerator(Resource c_resourceId);

public:
	float GetTidalResourceGenerator(Resource c_resourceId);

public:
	float GetStorage(Resource c_resourceId);

public:
	bool IsSquareResourceExtractor(Resource c_resourceId);

public:
	float GetBuildTime();

public:
	/**
	 * This amount of auto-heal will always be applied.
	 */
	float GetAutoHeal();

public:
	/**
	 * This amount of auto-heal will only be applied while the unit is idling.
	 */
	float GetIdleAutoHeal();

public:
	/**
	 * Time a unit needs to idle before it is considered idling.
	 */
	int GetIdleTime();

public:
	float GetPower();

public:
	float GetHealth();

public:
	unsigned int GetCategory();

public:
	float GetSpeed();

public:
	float GetTurnRate();

public:
	bool IsTurnInPlace();

public:
	/**
	 * Units above this distance to goal will try to turn while keeping
	 * some of their speed.
	 * 0 to disable
	 */
	float GetTurnInPlaceDistance();

public:
	/**
	 * Units below this speed will turn in place regardless of their
	 * turnInPlace setting.
	 */
	float GetTurnInPlaceSpeedLimit();

public:
	bool IsUpright();

public:
	bool IsCollide();

public:
	float GetControlRadius();

public:
	float GetLosRadius();

public:
	float GetAirLosRadius();

public:
	float GetLosHeight();

public:
	int GetRadarRadius();

public:
	int GetSonarRadius();

public:
	int GetJammerRadius();

public:
	int GetSonarJamRadius();

public:
	int GetSeismicRadius();

public:
	float GetSeismicSignature();

public:
	bool IsStealth();

public:
	bool IsSonarStealth();

public:
	bool IsBuildRange3D();

public:
	float GetBuildDistance();

public:
	float GetBuildSpeed();

public:
	float GetReclaimSpeed();

public:
	float GetRepairSpeed();

public:
	float GetMaxRepairSpeed();

public:
	float GetResurrectSpeed();

public:
	float GetCaptureSpeed();

public:
	float GetTerraformSpeed();

public:
	float GetMass();

public:
	bool IsPushResistant();

public:
	/**
	 * Should the unit move sideways when it can not shoot?
	 */
	bool IsStrafeToAttack();

public:
	float GetMinCollisionSpeed();

public:
	float GetSlideTolerance();

public:
	/**
	 * Build location relevant maximum steepness of the underlaying terrain.
	 * Used to calculate the maxHeightDif.
	 */
	float GetMaxSlope();

public:
	/**
	 * Maximum terra-form height this building allows.
	 * If this value is 0.0, you can only build this structure on
	 * totally flat terrain.
	 */
	float GetMaxHeightDif();

public:
	float GetMinWaterDepth();

public:
	float GetWaterline();

public:
	float GetMaxWaterDepth();

public:
	float GetArmoredMultiple();

public:
	int GetArmorType();

public:
	float GetMaxWeaponRange();

public:
	const char* GetType();

public:
	const char* GetTooltip();

public:
	const char* GetWreckName();

public:
	const char* GetDeathExplosion();

public:
	const char* GetSelfDExplosion();

public:
	const char* GetCategoryString();

public:
	bool IsAbleToSelfD();

public:
	int GetSelfDCountdown();

public:
	bool IsAbleToSubmerge();

public:
	bool IsAbleToFly();

public:
	bool IsAbleToMove();

public:
	bool IsAbleToHover();

public:
	bool IsFloater();

public:
	bool IsBuilder();

public:
	bool IsActivateWhenBuilt();

public:
	bool IsOnOffable();

public:
	bool IsFullHealthFactory();

public:
	bool IsFactoryHeadingTakeoff();

public:
	bool IsReclaimable();

public:
	bool IsCapturable();

public:
	bool IsAbleToRestore();

public:
	bool IsAbleToRepair();

public:
	bool IsAbleToSelfRepair();

public:
	bool IsAbleToReclaim();

public:
	bool IsAbleToAttack();

public:
	bool IsAbleToPatrol();

public:
	bool IsAbleToFight();

public:
	bool IsAbleToGuard();

public:
	bool IsAbleToAssist();

public:
	bool IsAssistable();

public:
	bool IsAbleToRepeat();

public:
	bool IsAbleToFireControl();

public:
	int GetFireState();

public:
	int GetMoveState();

public:
	float GetWingDrag();

public:
	float GetWingAngle();

public:
	float GetDrag();

public:
	float GetFrontToSpeed();

public:
	float GetSpeedToFront();

public:
	float GetMyGravity();

public:
	float GetMaxBank();

public:
	float GetMaxPitch();

public:
	float GetTurnRadius();

public:
	float GetWantedHeight();

public:
	float GetVerticalSpeed();

public:
	bool IsAbleToCrash();

public:
	bool IsHoverAttack();

public:
	bool IsAirStrafe();

public:
	/**
	 * @return  < 0:  it can land
	 *          >= 0: how much the unit will move during hovering on the spot
	 */
	float GetDlHoverFactor();

public:
	float GetMaxAcceleration();

public:
	float GetMaxDeceleration();

public:
	float GetMaxAileron();

public:
	float GetMaxElevator();

public:
	float GetMaxRudder();

public:
	int GetXSize();

public:
	int GetZSize();

public:
	int GetBuildAngle();

public:
	float GetLoadingRadius();

public:
	float GetUnloadSpread();

public:
	int GetTransportCapacity();

public:
	int GetTransportSize();

public:
	int GetMinTransportSize();

public:
	bool IsAirBase();

public:
	bool IsFirePlatform();

public:
	float GetTransportMass();

public:
	float GetMinTransportMass();

public:
	bool IsHoldSteady();

public:
	bool IsReleaseHeld();

public:
	bool IsNotTransportable();

public:
	bool IsTransportByEnemy();

public:
	/**
	 * @return  0: land unload
	 *          1: fly-over drop
	 *          2: land flood
	 */
	int GetTransportUnloadMethod();

public:
	/**
	 * Dictates fall speed of all transported units.
	 * This only makes sense for air transports,
	 * if they an drop units while in the air.
	 */
	float GetFallSpeed();

public:
	/**
	 * Sets the transported units FBI, overrides fallSpeed
	 */
	float GetUnitFallSpeed();

public:
	/**
	 * If the unit can cloak
	 */
	bool IsAbleToCloak();

public:
	/**
	 * If the unit wants to start out cloaked
	 */
	bool IsStartCloaked();

public:
	/**
	 * Energy cost per second to stay cloaked when stationary
	 */
	float GetCloakCost();

public:
	/**
	 * Energy cost per second to stay cloaked when moving
	 */
	float GetCloakCostMoving();

public:
	/**
	 * If enemy unit comes within this range, decloaking is forced
	 */
	float GetDecloakDistance();

public:
	/**
	 * Use a spherical, instead of a cylindrical test?
	 */
	bool IsDecloakSpherical();

public:
	/**
	 * Will the unit decloak upon firing?
	 */
	bool IsDecloakOnFire();

public:
	/**
	 * Will the unit self destruct if an enemy comes to close?
	 */
	bool IsAbleToKamikaze();

public:
	float GetKamikazeDist();

public:
	bool IsTargetingFacility();

public:
	bool IsAbleToDGun();

public:
	bool IsNeedGeo();

public:
	bool IsFeature();

public:
	bool IsHideDamage();

public:
	bool IsCommander();

public:
	bool IsShowPlayerName();

public:
	bool IsAbleToResurrect();

public:
	bool IsAbleToCapture();

public:
	/**
	 * Indicates the trajectory types supported by this unit.
	 * 
	 * @return  0: (default) = only low
	 *          1: only high
	 *          2: choose
	 */
	int GetHighTrajectoryType();

public:
	unsigned int GetNoChaseCategory();

public:
	bool IsLeaveTracks();

public:
	float GetTrackWidth();

public:
	float GetTrackOffset();

public:
	float GetTrackStrength();

public:
	float GetTrackStretch();

public:
	int GetTrackType();

public:
	bool IsAbleToDropFlare();

public:
	float GetFlareReloadTime();

public:
	float GetFlareEfficiency();

public:
	float GetFlareDelay();

public:
	struct SAIFloat3 GetFlareDropVector();

public:
	int GetFlareTime();

public:
	int GetFlareSalvoSize();

public:
	int GetFlareSalvoDelay();

public:
	/**
	 * Only matters for fighter aircraft
	 */
	bool IsAbleToLoopbackAttack();

public:
	/**
	 * Indicates whether the ground will be leveled/flattened out
	 * after this building has been built on it.
	 * Only matters for buildings.
	 */
	bool IsLevelGround();

public:
	bool IsUseBuildingGroundDecal();

public:
	int GetBuildingDecalType();

public:
	int GetBuildingDecalSizeX();

public:
	int GetBuildingDecalSizeY();

public:
	float GetBuildingDecalDecaySpeed();

public:
	/**
	 * Maximum flight time in seconds before the aircraft needs
	 * to return to an air repair bay to refuel.
	 */
	float GetMaxFuel();

public:
	/**
	 * Time to fully refuel the unit
	 */
	float GetRefuelTime();

public:
	/**
	 * Minimum build power of airbases that this aircraft can land on
	 */
	float GetMinAirBasePower();

public:
	/**
	 * Number of units of this type allowed simultaneously in the game
	 */
	int GetMaxThisUnit();

public:
	UnitDef* GetDecoyDef();

public:
	bool IsDontLand();

public:
	WeaponDef* GetShieldDef();

public:
	WeaponDef* GetStockpileDef();

public:
	std::vector<UnitDef*> GetBuildOptions();

public:
	std::map<const char*, const char*> GetCustomParams();
public:
	FlankingBonus* GetFlankingBonus();
public:
	MoveData* GetMoveData();
public:
	std::vector<WeaponMount*> GetWeaponMounts();
}; // class UnitDef
} // namespace springai

#endif // _CPPWRAPPER_UNITDEF_H

