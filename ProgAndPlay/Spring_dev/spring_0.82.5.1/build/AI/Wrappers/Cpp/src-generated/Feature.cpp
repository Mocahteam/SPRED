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

#include "Feature.h"

#include "IncludesSources.h"

springai::Feature::Feature(AICallback* clb, int featureId) {

	this->clb = clb;
	this->featureId = featureId;
}

int springai::Feature::GetFeatureId() {
	return featureId;
}


springai::Feature* springai::Feature::GetInstance(AICallback* clb, int featureId) {

	if (featureId < 0) {
		return NULL;
	}

	Feature* _ret = NULL;
	_ret = new Feature(clb, featureId);
	return _ret;
}

springai::FeatureDef* springai::Feature::GetDef() {
		FeatureDef* _ret;

		int innerRet = clb->GetInnerCallback()->Clb_Feature_0SINGLE1FETCH2FeatureDef0getDef(clb->GetTeamId(), featureId);
		_ret = FeatureDef::GetInstance(clb, innerRet);
		return _ret;
	}
float springai::Feature::GetHealth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Feature_getHealth(clb->GetTeamId(), featureId);
		return _ret;
	}
float springai::Feature::GetReclaimLeft() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Feature_getReclaimLeft(clb->GetTeamId(), featureId);
		return _ret;
	}
struct SAIFloat3 springai::Feature::GetPosition() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Feature_getPosition(clb->GetTeamId(), featureId);
		return _ret;
	}
