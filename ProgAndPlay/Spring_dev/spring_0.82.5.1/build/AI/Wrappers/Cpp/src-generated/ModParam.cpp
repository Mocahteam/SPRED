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

#include "ModParam.h"

#include "IncludesSources.h"

springai::ModParam::ModParam(AICallback* clb, int unitId, int modParamId) {

	this->clb = clb;
	this->unitId = unitId;
	this->modParamId = modParamId;
}

int springai::ModParam::GetUnitId() {
	return unitId;
}

int springai::ModParam::GetModParamId() {
	return modParamId;
}


springai::ModParam* springai::ModParam::GetInstance(AICallback* clb, int unitId, int modParamId) {

	if (modParamId < 0) {
		return NULL;
	}

	ModParam* _ret = NULL;
	_ret = new ModParam(clb, unitId, modParamId);
	return _ret;
}

const char* springai::ModParam::GetName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_ModParam_getName(clb->GetTeamId(), unitId, modParamId);
		return _ret;
	}
float springai::ModParam::GetValue() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_ModParam_getValue(clb->GetTeamId(), unitId, modParamId);
		return _ret;
	}