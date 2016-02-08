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

#include "WeaponDef.h"

#include "IncludesSources.h"

springai::WeaponDef::WeaponDef(AICallback* clb, int weaponDefId) {

	this->clb = clb;
	this->weaponDefId = weaponDefId;
}

int springai::WeaponDef::GetWeaponDefId() {
	return weaponDefId;
}


springai::WeaponDef* springai::WeaponDef::GetInstance(AICallback* clb, int weaponDefId) {

	if (weaponDefId < 0) {
		return NULL;
	}

	WeaponDef* _ret = NULL;
	_ret = new WeaponDef(clb, weaponDefId);
	return _ret;
}

const char* springai::WeaponDef::GetName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getName(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
const char* springai::WeaponDef::GetType() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getType(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
const char* springai::WeaponDef::GetDescription() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getDescription(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
const char* springai::WeaponDef::GetFileName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getFileName(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
const char* springai::WeaponDef::GetCegTag() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getCegTag(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetRange() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getRange(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetHeightMod() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getHeightMod(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetAccuracy() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getAccuracy(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetSprayAngle() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getSprayAngle(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetMovingAccuracy() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getMovingAccuracy(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetTargetMoveError() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getTargetMoveError(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetLeadLimit() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getLeadLimit(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetLeadBonus() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getLeadBonus(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetPredictBoost() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getPredictBoost(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetAreaOfEffect() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getAreaOfEffect(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsNoSelfDamage() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isNoSelfDamage(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetFireStarter() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getFireStarter(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetEdgeEffectiveness() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getEdgeEffectiveness(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetSize() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getSize(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetSizeGrowth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getSizeGrowth(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetCollisionSize() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getCollisionSize(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetSalvoSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getSalvoSize(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetSalvoDelay() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getSalvoDelay(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetReload() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getReload(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetBeamTime() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getBeamTime(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsBeamBurst() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isBeamBurst(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsWaterBounce() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isWaterBounce(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsGroundBounce() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isGroundBounce(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetBounceRebound() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getBounceRebound(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetBounceSlip() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getBounceSlip(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetNumBounce() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getNumBounce(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetMaxAngle() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getMaxAngle(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetRestTime() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getRestTime(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetUpTime() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getUpTime(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetFlightTime() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getFlightTime(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetCost(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_0REF1Resource2resourceId0getCost(clb->GetTeamId(), weaponDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::WeaponDef::GetSupplyCost() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getSupplyCost(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetProjectilesPerShot() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getProjectilesPerShot(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsTurret() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isTurret(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsOnlyForward() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isOnlyForward(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsFixedLauncher() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isFixedLauncher(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsWaterWeapon() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isWaterWeapon(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsFireSubmersed() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isFireSubmersed(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsSubMissile() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isSubMissile(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsTracks() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isTracks(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsDropped() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isDropped(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsParalyzer() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isParalyzer(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsImpactOnly() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isImpactOnly(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsNoAutoTarget() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isNoAutoTarget(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsManualFire() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isManualFire(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetInterceptor() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getInterceptor(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetTargetable() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getTargetable(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsStockpileable() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isStockpileable(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetCoverageRange() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getCoverageRange(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetStockpileTime() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getStockpileTime(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetIntensity() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getIntensity(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetThickness() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getThickness(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetLaserFlareSize() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getLaserFlareSize(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetCoreThickness() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getCoreThickness(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetDuration() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getDuration(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetLodDistance() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getLodDistance(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetFalloffRate() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getFalloffRate(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetGraphicsType() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getGraphicsType(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsSoundTrigger() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isSoundTrigger(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsSelfExplode() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isSelfExplode(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsGravityAffected() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isGravityAffected(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetHighTrajectory() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getHighTrajectory(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetMyGravity() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getMyGravity(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsNoExplode() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isNoExplode(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetStartVelocity() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getStartVelocity(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetWeaponAcceleration() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getWeaponAcceleration(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetTurnRate() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getTurnRate(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetMaxVelocity() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getMaxVelocity(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetProjectileSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getProjectileSpeed(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetExplosionSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getExplosionSpeed(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
unsigned int springai::WeaponDef::GetOnlyTargetCategory() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getOnlyTargetCategory(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetWobble() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getWobble(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetDance() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getDance(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetTrajectoryHeight() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getTrajectoryHeight(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsLargeBeamLaser() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isLargeBeamLaser(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsShield() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isShield(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsShieldRepulser() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isShieldRepulser(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsSmartShield() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isSmartShield(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsExteriorShield() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isExteriorShield(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsVisibleShield() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isVisibleShield(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsVisibleShieldRepulse() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isVisibleShieldRepulse(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::WeaponDef::GetVisibleShieldHitFrames() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getVisibleShieldHitFrames(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
unsigned int springai::WeaponDef::GetInterceptedByShieldType() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getInterceptedByShieldType(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsAvoidFriendly() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isAvoidFriendly(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsAvoidFeature() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isAvoidFeature(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsAvoidNeutral() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isAvoidNeutral(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetTargetBorder() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getTargetBorder(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetCylinderTargetting() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getCylinderTargetting(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetMinIntensity() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getMinIntensity(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetHeightBoostFactor() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getHeightBoostFactor(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetProximityPriority() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getProximityPriority(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
unsigned int springai::WeaponDef::GetCollisionFlags() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getCollisionFlags(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsSweepFire() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isSweepFire(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsAbleToAttackGround() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isAbleToAttackGround(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetCameraShake() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getCameraShake(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetDynDamageExp() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getDynDamageExp(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetDynDamageMin() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getDynDamageMin(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::WeaponDef::GetDynDamageRange() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_getDynDamageRange(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
bool springai::WeaponDef::IsDynDamageInverted() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_isDynDamageInverted(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
std::map<const char*, const char*> springai::WeaponDef::GetCustomParams() {
		std::map<const char*, const char*> _ret;

		int size = clb->GetInnerCallback()->Clb_WeaponDef_0MAP1SIZE0getCustomParams(clb->GetTeamId(), weaponDefId);
		const char** tmpKeysArr = new const char*[size];
		clb->GetInnerCallback()->Clb_WeaponDef_0MAP1KEYS0getCustomParams(clb->GetTeamId(), weaponDefId, tmpKeysArr);
		const char** tmpValsArr = new const char*[size];
		clb->GetInnerCallback()->Clb_WeaponDef_0MAP1VALS0getCustomParams(clb->GetTeamId(), weaponDefId, tmpValsArr);
		std::map<const char*, const char*> retMap;
		for (int i=0; i < size; i++) {
			retMap[tmpKeysArr[i]] = tmpValsArr[i];
		}
		delete [] tmpKeysArr;
		delete [] tmpValsArr;
		_ret = retMap;
		return _ret;
	}
springai::Damage* springai::WeaponDef::GetDamage() {

		Damage* _ret;
		_ret = Damage::GetInstance(clb, weaponDefId);
		return _ret;
	}
springai::Shield* springai::WeaponDef::GetShield() {

		Shield* _ret;
		_ret = Shield::GetInstance(clb, weaponDefId);
		return _ret;
	}
