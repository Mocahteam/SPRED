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

#include "FlankingBonus.h"

#include "IncludesSources.h"

springai::FlankingBonus::FlankingBonus(AICallback* clb, int unitDefId) {

	this->clb = clb;
	this->unitDefId = unitDefId;
}

int springai::FlankingBonus::GetUnitDefId() {
	return unitDefId;
}


springai::FlankingBonus* springai::FlankingBonus::GetInstance(AICallback* clb, int unitDefId) {

	if (unitDefId < 0) {
		return NULL;
	}

	FlankingBonus* _ret = NULL;
	_ret = new FlankingBonus(clb, unitDefId);
	return _ret;
}

int springai::FlankingBonus::GetMode() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_FlankingBonus_getMode(clb->GetTeamId(), unitDefId);
		return _ret;
	}
struct SAIFloat3 springai::FlankingBonus::GetDir() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_FlankingBonus_getDir(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::FlankingBonus::GetMax() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_FlankingBonus_getMax(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::FlankingBonus::GetMin() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_FlankingBonus_getMin(clb->GetTeamId(), unitDefId);
		return _ret;
	}
float springai::FlankingBonus::GetMobilityAdd() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_FlankingBonus_getMobilityAdd(clb->GetTeamId(), unitDefId);
		return _ret;
	}
