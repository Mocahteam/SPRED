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

#include "ClbUnitSupportedCommandImpl.h"

#include "IncludesSources.h"

springai::ClbUnitSupportedCommandImpl::ClbUnitSupportedCommandImpl(AICallback* clb, int unitId) {

	this->clb = clb;
	this->unitId = unitId;
}

int springai::ClbUnitSupportedCommandImpl::GetUnitId() {
	return unitId;
}


springai::ClbUnitSupportedCommandImpl* springai::ClbUnitSupportedCommandImpl::GetInstance(AICallback* clb, int unitId) {

	if (unitId < 0) {
		return NULL;
	}

	ClbUnitSupportedCommandImpl* _ret = NULL;
	_ret = new ClbUnitSupportedCommandImpl(clb, unitId);
	return _ret;
}

int springai::ClbUnitSupportedCommandImpl::GetId(int commandId) {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_SupportedCommand_getId(clb->GetTeamId(), unitId, commandId);
		return _ret;
	}
const char* springai::ClbUnitSupportedCommandImpl::GetName(int commandId) {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_SupportedCommand_getName(clb->GetTeamId(), unitId, commandId);
		return _ret;
	}
const char* springai::ClbUnitSupportedCommandImpl::GetToolTip(int commandId) {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_SupportedCommand_getToolTip(clb->GetTeamId(), unitId, commandId);
		return _ret;
	}
bool springai::ClbUnitSupportedCommandImpl::IsShowUnique(int commandId) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_SupportedCommand_isShowUnique(clb->GetTeamId(), unitId, commandId);
		return _ret;
	}
bool springai::ClbUnitSupportedCommandImpl::IsDisabled(int commandId) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_SupportedCommand_isDisabled(clb->GetTeamId(), unitId, commandId);
		return _ret;
	}
std::vector<const char*> springai::ClbUnitSupportedCommandImpl::GetParams(int commandId) {
		std::vector<const char*> _ret;

		int size = clb->GetInnerCallback()->Clb_Unit_SupportedCommand_0ARRAY1SIZE0getParams(clb->GetTeamId(), unitId, commandId);
		const char** tmpArr = new const char*[size];
		clb->GetInnerCallback()->Clb_Unit_SupportedCommand_0ARRAY1VALS0getParams(clb->GetTeamId(), unitId, commandId, tmpArr, size);
		std::vector<const char*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
