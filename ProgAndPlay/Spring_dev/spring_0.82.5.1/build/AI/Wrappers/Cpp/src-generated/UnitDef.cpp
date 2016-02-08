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

#include "UnitDef.h"

#include "IncludesSources.h"

springai::UnitDef::UnitDef(AICallback* clb, int unitDefId) {

	this->clb = clb;
	this->unitDefId = unitDefId;
}

int springai::UnitDef::GetUnitDefId() {
	return unitDefId;
}


springai::UnitDef* springai::UnitDef::GetInstance(AICallback* clb, int unitDefId) {

	if (unitDefId < 0) {
		return NULL;
	}

	UnitDef* _ret = NULL;
	_ret = new UnitDef(clb, unitDefId);
	return _ret;
}

float springai::UnitDef::GetHeight() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getHeight(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetRadius() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getName(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetHumanName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getHumanName(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetFileName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFileName(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetAiHint() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getAiHint(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetCobId() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getCobId(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetTechLevel() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTechLevel(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetGaia() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getGaia(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetUpkeep(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0getUpkeep(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::UnitDef::GetResourceMake(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0getResourceMake(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::UnitDef::GetMakesResource(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0getMakesResource(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::UnitDef::GetCost(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0getCost(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::UnitDef::GetExtractsResource(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0getExtractsResource(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::UnitDef::GetResourceExtractorRange(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0getResourceExtractorRange(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::UnitDef::GetWindResourceGenerator(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0getWindResourceGenerator(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::UnitDef::GetTidalResourceGenerator(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0getTidalResourceGenerator(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::UnitDef::GetStorage(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0getStorage(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
bool springai::UnitDef::IsSquareResourceExtractor(Resource c_resourceId) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_0REF1Resource2resourceId0isSquareResourceExtractor(clb->GetTeamId(), unitDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::UnitDef::GetBuildTime() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getBuildTime(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetAutoHeal() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getAutoHeal(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetIdleAutoHeal() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getIdleAutoHeal(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetIdleTime() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getIdleTime(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetPower() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getPower(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetHealth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getHealth(clb->GetTeamId(), unitDefId);
		return _ret;
	}
unsigned int springai::UnitDef::GetCategory() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getCategory(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTurnRate() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTurnRate(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsTurnInPlace() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isTurnInPlace(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTurnInPlaceDistance() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTurnInPlaceDistance(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTurnInPlaceSpeedLimit() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTurnInPlaceSpeedLimit(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsUpright() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isUpright(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsCollide() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isCollide(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetControlRadius() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getControlRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetLosRadius() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getLosRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetAirLosRadius() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getAirLosRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetLosHeight() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getLosHeight(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetRadarRadius() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getRadarRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetSonarRadius() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getSonarRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetJammerRadius() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getJammerRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetSonarJamRadius() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getSonarJamRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetSeismicRadius() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getSeismicRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetSeismicSignature() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getSeismicSignature(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsStealth() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isStealth(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsSonarStealth() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isSonarStealth(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsBuildRange3D() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isBuildRange3D(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetBuildDistance() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getBuildDistance(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetBuildSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getBuildSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetReclaimSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getReclaimSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetRepairSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getRepairSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxRepairSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxRepairSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetResurrectSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getResurrectSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetCaptureSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getCaptureSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTerraformSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTerraformSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMass() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMass(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsPushResistant() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isPushResistant(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsStrafeToAttack() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isStrafeToAttack(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMinCollisionSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMinCollisionSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetSlideTolerance() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getSlideTolerance(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxSlope() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxSlope(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxHeightDif() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxHeightDif(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMinWaterDepth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMinWaterDepth(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetWaterline() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getWaterline(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxWaterDepth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxWaterDepth(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetArmoredMultiple() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getArmoredMultiple(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetArmorType() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getArmorType(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxWeaponRange() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxWeaponRange(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetType() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getType(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetTooltip() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTooltip(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetWreckName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getWreckName(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetDeathExplosion() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getDeathExplosion(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetSelfDExplosion() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getSelfDExplosion(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::UnitDef::GetCategoryString() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getCategoryString(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToSelfD() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToSelfD(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetSelfDCountdown() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getSelfDCountdown(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToSubmerge() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToSubmerge(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToFly() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToFly(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToMove() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToMove(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToHover() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToHover(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsFloater() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isFloater(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsBuilder() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isBuilder(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsActivateWhenBuilt() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isActivateWhenBuilt(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsOnOffable() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isOnOffable(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsFullHealthFactory() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isFullHealthFactory(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsFactoryHeadingTakeoff() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isFactoryHeadingTakeoff(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsReclaimable() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isReclaimable(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsCapturable() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isCapturable(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToRestore() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToRestore(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToRepair() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToRepair(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToSelfRepair() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToSelfRepair(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToReclaim() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToReclaim(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToAttack() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToAttack(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToPatrol() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToPatrol(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToFight() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToFight(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToGuard() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToGuard(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToAssist() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToAssist(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAssistable() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAssistable(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToRepeat() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToRepeat(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToFireControl() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToFireControl(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetFireState() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFireState(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetMoveState() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMoveState(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetWingDrag() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getWingDrag(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetWingAngle() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getWingAngle(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetDrag() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getDrag(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetFrontToSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFrontToSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetSpeedToFront() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getSpeedToFront(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMyGravity() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMyGravity(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxBank() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxBank(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxPitch() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxPitch(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTurnRadius() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTurnRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetWantedHeight() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getWantedHeight(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetVerticalSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getVerticalSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToCrash() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToCrash(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsHoverAttack() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isHoverAttack(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAirStrafe() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAirStrafe(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetDlHoverFactor() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getDlHoverFactor(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxAcceleration() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxAcceleration(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxDeceleration() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxDeceleration(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxAileron() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxAileron(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxElevator() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxElevator(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxRudder() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxRudder(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetXSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getXSize(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetZSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getZSize(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetBuildAngle() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getBuildAngle(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetLoadingRadius() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getLoadingRadius(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetUnloadSpread() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getUnloadSpread(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetTransportCapacity() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTransportCapacity(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetTransportSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTransportSize(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetMinTransportSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMinTransportSize(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAirBase() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAirBase(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsFirePlatform() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isFirePlatform(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTransportMass() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTransportMass(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMinTransportMass() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMinTransportMass(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsHoldSteady() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isHoldSteady(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsReleaseHeld() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isReleaseHeld(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsNotTransportable() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isNotTransportable(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsTransportByEnemy() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isTransportByEnemy(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetTransportUnloadMethod() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTransportUnloadMethod(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetFallSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFallSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetUnitFallSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getUnitFallSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToCloak() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToCloak(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsStartCloaked() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isStartCloaked(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetCloakCost() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getCloakCost(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetCloakCostMoving() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getCloakCostMoving(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetDecloakDistance() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getDecloakDistance(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsDecloakSpherical() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isDecloakSpherical(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsDecloakOnFire() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isDecloakOnFire(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToKamikaze() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToKamikaze(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetKamikazeDist() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getKamikazeDist(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsTargetingFacility() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isTargetingFacility(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToDGun() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToDGun(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsNeedGeo() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isNeedGeo(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsFeature() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isFeature(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsHideDamage() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isHideDamage(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsCommander() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isCommander(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsShowPlayerName() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isShowPlayerName(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToResurrect() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToResurrect(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToCapture() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToCapture(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetHighTrajectoryType() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getHighTrajectoryType(clb->GetTeamId(), unitDefId);
		return _ret;
	}
unsigned int springai::UnitDef::GetNoChaseCategory() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getNoChaseCategory(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsLeaveTracks() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isLeaveTracks(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTrackWidth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTrackWidth(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTrackOffset() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTrackOffset(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTrackStrength() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTrackStrength(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetTrackStretch() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTrackStretch(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetTrackType() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getTrackType(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToDropFlare() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToDropFlare(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetFlareReloadTime() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFlareReloadTime(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetFlareEfficiency() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFlareEfficiency(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetFlareDelay() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFlareDelay(clb->GetTeamId(), unitDefId);
		return _ret;
	}
struct SAIFloat3 springai::UnitDef::GetFlareDropVector() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFlareDropVector(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetFlareTime() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFlareTime(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetFlareSalvoSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFlareSalvoSize(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetFlareSalvoDelay() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getFlareSalvoDelay(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsAbleToLoopbackAttack() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isAbleToLoopbackAttack(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsLevelGround() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isLevelGround(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::UnitDef::IsUseBuildingGroundDecal() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isUseBuildingGroundDecal(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetBuildingDecalType() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getBuildingDecalType(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetBuildingDecalSizeX() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getBuildingDecalSizeX(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetBuildingDecalSizeY() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getBuildingDecalSizeY(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetBuildingDecalDecaySpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getBuildingDecalDecaySpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMaxFuel() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxFuel(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetRefuelTime() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getRefuelTime(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::UnitDef::GetMinAirBasePower() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMinAirBasePower(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::UnitDef::GetMaxThisUnit() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_getMaxThisUnit(clb->GetTeamId(), unitDefId);
		return _ret;
	}
springai::UnitDef* springai::UnitDef::GetDecoyDef() {
		UnitDef* _ret;

		int innerRet = clb->GetInnerCallback()->Clb_UnitDef_0SINGLE1FETCH2UnitDef0getDecoyDef(clb->GetTeamId(), unitDefId);
		_ret = UnitDef::GetInstance(clb, innerRet);
		return _ret;
	}
bool springai::UnitDef::IsDontLand() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_isDontLand(clb->GetTeamId(), unitDefId);
		return _ret;
	}
springai::WeaponDef* springai::UnitDef::GetShieldDef() {
		WeaponDef* _ret;

		int innerRet = clb->GetInnerCallback()->Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getShieldDef(clb->GetTeamId(), unitDefId);
		_ret = WeaponDef::GetInstance(clb, innerRet);
		return _ret;
	}
springai::WeaponDef* springai::UnitDef::GetStockpileDef() {
		WeaponDef* _ret;

		int innerRet = clb->GetInnerCallback()->Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getStockpileDef(clb->GetTeamId(), unitDefId);
		_ret = WeaponDef::GetInstance(clb, innerRet);
		return _ret;
	}
std::vector<springai::UnitDef*> springai::UnitDef::GetBuildOptions() {
		std::vector<UnitDef*> _ret;

		int size = clb->GetInnerCallback()->Clb_UnitDef_0ARRAY1SIZE1UnitDef0getBuildOptions(clb->GetTeamId(), unitDefId);
		int* tmpArr = new int[size];
		clb->GetInnerCallback()->Clb_UnitDef_0ARRAY1VALS1UnitDef0getBuildOptions(clb->GetTeamId(), unitDefId, tmpArr, size);
		std::vector<UnitDef*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(UnitDef::GetInstance(clb, tmpArr[i]));
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
std::map<const char*, const char*> springai::UnitDef::GetCustomParams() {
		std::map<const char*, const char*> _ret;

		int size = clb->GetInnerCallback()->Clb_UnitDef_0MAP1SIZE0getCustomParams(clb->GetTeamId(), unitDefId);
		const char** tmpKeysArr = new const char*[size];
		clb->GetInnerCallback()->Clb_UnitDef_0MAP1KEYS0getCustomParams(clb->GetTeamId(), unitDefId, tmpKeysArr);
		const char** tmpValsArr = new const char*[size];
		clb->GetInnerCallback()->Clb_UnitDef_0MAP1VALS0getCustomParams(clb->GetTeamId(), unitDefId, tmpValsArr);
		std::map<const char*, const char*> retMap;
		for (int i=0; i < size; i++) {
			retMap[tmpKeysArr[i]] = tmpValsArr[i];
		}
		delete [] tmpKeysArr;
		delete [] tmpValsArr;
		_ret = retMap;
		return _ret;
	}
springai::FlankingBonus* springai::UnitDef::GetFlankingBonus() {

		FlankingBonus* _ret;
		_ret = FlankingBonus::GetInstance(clb, unitDefId);
		return _ret;
	}
springai::MoveData* springai::UnitDef::GetMoveData() {

		MoveData* _ret;
		_ret = MoveData::GetInstance(clb, unitDefId);
		return _ret;
	}
std::vector<springai::WeaponMount*> springai::UnitDef::GetWeaponMounts() {

		std::vector<WeaponMount*> _ret;
		int size = clb->GetInnerCallback()->Clb_UnitDef_0MULTI1SIZE0WeaponMount(clb->GetTeamId(), unitDefId);
		std::vector<WeaponMount*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(WeaponMount::GetInstance(clb, unitDefId, i));
		}
		_ret = arrList;
		return _ret;
	}
