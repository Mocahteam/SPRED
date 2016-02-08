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

#include "MoveData.h"

#include "IncludesSources.h"

springai::MoveData::MoveData(AICallback* clb, int unitDefId) {

	this->clb = clb;
	this->unitDefId = unitDefId;
}

int springai::MoveData::GetUnitDefId() {
	return unitDefId;
}


springai::MoveData* springai::MoveData::GetInstance(AICallback* clb, int unitDefId) {

	if (unitDefId < 0) {
		return NULL;
	}

	MoveData* _ret = NULL;
	bool isAvailable = clb->GetInnerCallback()->Clb_UnitDef_0AVAILABLE0MoveData(clb->GetTeamId(), unitDefId);
	if (isAvailable) {
		_ret = new MoveData(clb, unitDefId);
	}
	return _ret;
}

float springai::MoveData::GetMaxAcceleration() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getMaxAcceleration(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::MoveData::GetMaxBreaking() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getMaxBreaking(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::MoveData::GetMaxSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getMaxSpeed(clb->GetTeamId(), unitDefId);
		return _ret;
	}
short springai::MoveData::GetMaxTurnRate() {
		short _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getMaxTurnRate(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::MoveData::GetSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getSize(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::MoveData::GetDepth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getDepth(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::MoveData::GetMaxSlope() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getMaxSlope(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::MoveData::GetSlopeMod() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getSlopeMod(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::MoveData::GetDepthMod() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getDepthMod(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::MoveData::GetPathType() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getPathType(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::MoveData::GetCrushStrength() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getCrushStrength(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::MoveData::GetMoveType() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getMoveType(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::MoveData::GetMoveFamily() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getMoveFamily(clb->GetTeamId(), unitDefId);
		return _ret;
	}
int springai::MoveData::GetTerrainClass() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getTerrainClass(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::MoveData::GetFollowGround() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getFollowGround(clb->GetTeamId(), unitDefId);
		return _ret;
	}
bool springai::MoveData::IsSubMarine() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_isSubMarine(clb->GetTeamId(), unitDefId);
		return _ret;
	}
const char* springai::MoveData::GetName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_MoveData_getName(clb->GetTeamId(), unitDefId);
		return _ret;
	}
