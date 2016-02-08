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

#include "FeatureDef.h"

#include "IncludesSources.h"

springai::FeatureDef::FeatureDef(AICallback* clb, int featureDefId) {

	this->clb = clb;
	this->featureDefId = featureDefId;
}

int springai::FeatureDef::GetFeatureDefId() {
	return featureDefId;
}


springai::FeatureDef* springai::FeatureDef::GetInstance(AICallback* clb, int featureDefId) {

	if (featureDefId < 0) {
		return NULL;
	}

	FeatureDef* _ret = NULL;
	_ret = new FeatureDef(clb, featureDefId);
	return _ret;
}

const char* springai::FeatureDef::GetName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getName(clb->GetTeamId(), featureDefId);
		return _ret;
	}
const char* springai::FeatureDef::GetDescription() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getDescription(clb->GetTeamId(), featureDefId);
		return _ret;
	}
const char* springai::FeatureDef::GetFileName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getFileName(clb->GetTeamId(), featureDefId);
		return _ret;
	}
float springai::FeatureDef::GetContainedResource(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_0REF1Resource2resourceId0getContainedResource(clb->GetTeamId(), featureDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::FeatureDef::GetMaxHealth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getMaxHealth(clb->GetTeamId(), featureDefId);
		return _ret;
	}
float springai::FeatureDef::GetReclaimTime() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getReclaimTime(clb->GetTeamId(), featureDefId);
		return _ret;
	}
float springai::FeatureDef::GetMass() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getMass(clb->GetTeamId(), featureDefId);
		return _ret;
	}
bool springai::FeatureDef::IsUpright() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_isUpright(clb->GetTeamId(), featureDefId);
		return _ret;
	}
int springai::FeatureDef::GetDrawType() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getDrawType(clb->GetTeamId(), featureDefId);
		return _ret;
	}
const char* springai::FeatureDef::GetModelName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getModelName(clb->GetTeamId(), featureDefId);
		return _ret;
	}
int springai::FeatureDef::GetResurrectable() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getResurrectable(clb->GetTeamId(), featureDefId);
		return _ret;
	}
int springai::FeatureDef::GetSmokeTime() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getSmokeTime(clb->GetTeamId(), featureDefId);
		return _ret;
	}
bool springai::FeatureDef::IsDestructable() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_isDestructable(clb->GetTeamId(), featureDefId);
		return _ret;
	}
bool springai::FeatureDef::IsReclaimable() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_isReclaimable(clb->GetTeamId(), featureDefId);
		return _ret;
	}
bool springai::FeatureDef::IsBlocking() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_isBlocking(clb->GetTeamId(), featureDefId);
		return _ret;
	}
bool springai::FeatureDef::IsBurnable() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_isBurnable(clb->GetTeamId(), featureDefId);
		return _ret;
	}
bool springai::FeatureDef::IsFloating() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_isFloating(clb->GetTeamId(), featureDefId);
		return _ret;
	}
bool springai::FeatureDef::IsNoSelect() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_isNoSelect(clb->GetTeamId(), featureDefId);
		return _ret;
	}
bool springai::FeatureDef::IsGeoThermal() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_isGeoThermal(clb->GetTeamId(), featureDefId);
		return _ret;
	}
const char* springai::FeatureDef::GetDeathFeature() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getDeathFeature(clb->GetTeamId(), featureDefId);
		return _ret;
	}
int springai::FeatureDef::GetXSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getXSize(clb->GetTeamId(), featureDefId);
		return _ret;
	}
int springai::FeatureDef::GetZSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_FeatureDef_getZSize(clb->GetTeamId(), featureDefId);
		return _ret;
	}
std::map<const char*, const char*> springai::FeatureDef::GetCustomParams() {
		std::map<const char*, const char*> _ret;

		int size = clb->GetInnerCallback()->Clb_FeatureDef_0MAP1SIZE0getCustomParams(clb->GetTeamId(), featureDefId);
		const char** tmpKeysArr = new const char*[size];
		clb->GetInnerCallback()->Clb_FeatureDef_0MAP1KEYS0getCustomParams(clb->GetTeamId(), featureDefId, tmpKeysArr);
		const char** tmpValsArr = new const char*[size];
		clb->GetInnerCallback()->Clb_FeatureDef_0MAP1VALS0getCustomParams(clb->GetTeamId(), featureDefId, tmpValsArr);
		std::map<const char*, const char*> retMap;
		for (int i=0; i < size; i++) {
			retMap[tmpKeysArr[i]] = tmpValsArr[i];
		}
		delete [] tmpKeysArr;
		delete [] tmpValsArr;
		_ret = retMap;
		return _ret;
	}
