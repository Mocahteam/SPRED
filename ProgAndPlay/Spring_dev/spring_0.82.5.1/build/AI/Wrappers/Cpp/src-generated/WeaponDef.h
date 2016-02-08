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

#ifndef _CPPWRAPPER_WEAPONDEF_H
#define _CPPWRAPPER_WEAPONDEF_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class WeaponDef {

private:
	AICallback* clb;
	int weaponDefId;

	WeaponDef(AICallback* clb, int weaponDefId);

public:
	virtual int GetWeaponDefId();

	static WeaponDef* GetInstance(AICallback* clb, int weaponDefId);

public:
	const char* GetName();

public:
	const char* GetType();

public:
	const char* GetDescription();

public:
	const char* GetFileName();

public:
	const char* GetCegTag();

public:
	float GetRange();

public:
	float GetHeightMod();

public:
	/**
	 * Inaccuracy of whole burst
	 */
	float GetAccuracy();

public:
	/**
	 * Inaccuracy of individual shots inside burst
	 */
	float GetSprayAngle();

public:
	/**
	 * Inaccuracy while owner moving
	 */
	float GetMovingAccuracy();

public:
	/**
	 * Fraction of targets move speed that is used as error offset
	 */
	float GetTargetMoveError();

public:
	/**
	 * Maximum distance the weapon will lead the target
	 */
	float GetLeadLimit();

public:
	/**
	 * Factor for increasing the leadLimit with experience
	 */
	float GetLeadBonus();

public:
	/**
	 * Replaces hardcoded behaviour for burnblow cannons
	 */
	float GetPredictBoost();

public:
	float GetAreaOfEffect();

public:
	bool IsNoSelfDamage();

public:
	float GetFireStarter();

public:
	float GetEdgeEffectiveness();

public:
	float GetSize();

public:
	float GetSizeGrowth();

public:
	float GetCollisionSize();

public:
	int GetSalvoSize();

public:
	float GetSalvoDelay();

public:
	float GetReload();

public:
	float GetBeamTime();

public:
	bool IsBeamBurst();

public:
	bool IsWaterBounce();

public:
	bool IsGroundBounce();

public:
	float GetBounceRebound();

public:
	float GetBounceSlip();

public:
	int GetNumBounce();

public:
	float GetMaxAngle();

public:
	float GetRestTime();

public:
	float GetUpTime();

public:
	int GetFlightTime();

public:
	float GetCost(Resource c_resourceId);

public:
	float GetSupplyCost();

public:
	int GetProjectilesPerShot();

public:
	bool IsTurret();

public:
	bool IsOnlyForward();

public:
	bool IsFixedLauncher();

public:
	bool IsWaterWeapon();

public:
	bool IsFireSubmersed();

public:
	/**
	 * Lets a torpedo travel above water like it does below water
	 */
	bool IsSubMissile();

public:
	bool IsTracks();

public:
	bool IsDropped();

public:
	/**
	 * The weapon will only paralyze, not do real damage.
	 */
	bool IsParalyzer();

public:
	/**
	 * The weapon damages by impacting, not by exploding.
	 */
	bool IsImpactOnly();

public:
	/**
	 * Can not target anything (for example: anti-nuke, D-Gun)
	 */
	bool IsNoAutoTarget();

public:
	/**
	 * Has to be fired manually (by the player or an AI, example: D-Gun)
	 */
	bool IsManualFire();

public:
	/**
	 * Can intercept targetable weapons shots.
	 * 
	 * example: anti-nuke
	 * 
	 * @see  getTargetable()
	 */
	int GetInterceptor();

public:
	/**
	 * Shoots interceptable projectiles.
	 * Shots can be intercepted by interceptors.
	 * 
	 * example: nuke
	 * 
	 * @see  getInterceptor()
	 */
	int GetTargetable();

public:
	bool IsStockpileable();

public:
	/**
	 * Range of interceptors.
	 * 
	 * example: anti-nuke
	 * 
	 * @see  getInterceptor()
	 */
	float GetCoverageRange();

public:
	/**
	 * Build time of a missile
	 */
	float GetStockpileTime();

public:
	float GetIntensity();

public:
	float GetThickness();

public:
	float GetLaserFlareSize();

public:
	float GetCoreThickness();

public:
	float GetDuration();

public:
	int GetLodDistance();

public:
	float GetFalloffRate();

public:
	int GetGraphicsType();

public:
	bool IsSoundTrigger();

public:
	bool IsSelfExplode();

public:
	bool IsGravityAffected();

public:
	/**
	 * Per weapon high trajectory setting.
	 * UnitDef also has this property.
	 * 
	 * @return  0: low
	 *          1: high
	 *          2: unit
	 */
	int GetHighTrajectory();

public:
	float GetMyGravity();

public:
	bool IsNoExplode();

public:
	float GetStartVelocity();

public:
	float GetWeaponAcceleration();

public:
	float GetTurnRate();

public:
	float GetMaxVelocity();

public:
	float GetProjectileSpeed();

public:
	float GetExplosionSpeed();

public:
	unsigned int GetOnlyTargetCategory();

public:
	/**
	 * How much the missile will wobble around its course.
	 */
	float GetWobble();

public:
	/**
	 * How much the missile will dance.
	 */
	float GetDance();

public:
	/**
	 * How high trajectory missiles will try to fly in.
	 */
	float GetTrajectoryHeight();

public:
	bool IsLargeBeamLaser();

public:
	/**
	 * If the weapon is a shield rather than a weapon.
	 */
	bool IsShield();

public:
	/**
	 * If the weapon should be repulsed or absorbed.
	 */
	bool IsShieldRepulser();

public:
	/**
	 * If the shield only affects enemy projectiles.
	 */
	bool IsSmartShield();

public:
	/**
	 * If the shield only affects stuff coming from outside shield radius.
	 */
	bool IsExteriorShield();

public:
	/**
	 * If the shield should be graphically shown.
	 */
	bool IsVisibleShield();

public:
	/**
	 * If a small graphic should be shown at each repulse.
	 */
	bool IsVisibleShieldRepulse();

public:
	/**
	 * The number of frames to draw the shield after it has been hit.
	 */
	int GetVisibleShieldHitFrames();

public:
	/**
	 * The type of shields that can intercept this weapon (bitfield).
	 * The weapon can be affected by shields if:
	 * (shield.getInterceptType() & weapon.getInterceptedByShieldType()) != 0
	 * 
	 * @see  getInterceptType()
	 */
	unsigned int GetInterceptedByShieldType();

public:
	/**
	 * Tries to avoid friendly units while aiming?
	 */
	bool IsAvoidFriendly();

public:
	/**
	 * Tries to avoid features while aiming?
	 */
	bool IsAvoidFeature();

public:
	/**
	 * Tries to avoid neutral units while aiming?
	 */
	bool IsAvoidNeutral();

public:
	/**
	 * If nonzero, targetting units will TryTarget at the edge of collision sphere
	 * (radius*tag value, [-1;1]) instead of its centre.
	 */
	float GetTargetBorder();

public:
	/**
	 * If greater than 0, the range will be checked in a cylinder
	 * (height=range*cylinderTargetting) instead of a sphere.
	 */
	float GetCylinderTargetting();

public:
	/**
	 * For beam-lasers only - always hit with some minimum intensity
	 * (a damage coeffcient normally dependent on distance).
	 * Do not confuse this with the intensity tag, it i completely unrelated.
	 */
	float GetMinIntensity();

public:
	/**
	 * Controls cannon range height boost.
	 * 
	 * default: -1: automatically calculate a more or less sane value
	 */
	float GetHeightBoostFactor();

public:
	/**
	 * Multiplier for the distance to the target for priority calculations.
	 */
	float GetProximityPriority();

public:
	unsigned int GetCollisionFlags();

public:
	bool IsSweepFire();

public:
	bool IsAbleToAttackGround();

public:
	float GetCameraShake();

public:
	float GetDynDamageExp();

public:
	float GetDynDamageMin();

public:
	float GetDynDamageRange();

public:
	bool IsDynDamageInverted();

public:
	std::map<const char*, const char*> GetCustomParams();
public:
	Damage* GetDamage();
public:
	Shield* GetShield();
}; // class WeaponDef
} // namespace springai

#endif // _CPPWRAPPER_WEAPONDEF_H

