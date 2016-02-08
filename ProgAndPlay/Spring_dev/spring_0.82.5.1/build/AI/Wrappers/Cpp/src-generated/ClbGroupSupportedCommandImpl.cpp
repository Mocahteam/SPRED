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

#include "ClbGroupSupportedCommandImpl.h"

#include "IncludesSources.h"

springai::ClbGroupSupportedCommandImpl::ClbGroupSupportedCommandImpl(AICallback* clb, int groupId) {

	this->clb = clb;
	this->groupId = groupId;
}

int springai::ClbGroupSupportedCommandImpl::GetGroupId() {
	return groupId;
}


springai::ClbGroupSupportedCommandImpl* springai::ClbGroupSupportedCommandImpl::GetInstance(AICallback* clb, int groupId) {

	if (groupId < 0) {
		return NULL;
	}

	ClbGroupSupportedCommandImpl* _ret = NULL;
	_ret = new ClbGroupSupportedCommandImpl(clb, groupId);
	return _ret;
}

int springai::ClbGroupSupportedCommandImpl::GetId(int commandId) {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_SupportedCommand_getId(clb->GetTeamId(), groupId, commandId);
		return _ret;
	}
const char* springai::ClbGroupSupportedCommandImpl::GetName(int commandId) {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_SupportedCommand_getName(clb->GetTeamId(), groupId, commandId);
		return _ret;
	}
const char* springai::ClbGroupSupportedCommandImpl::GetToolTip(int commandId) {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_SupportedCommand_getToolTip(clb->GetTeamId(), groupId, commandId);
		return _ret;
	}
bool springai::ClbGroupSupportedCommandImpl::IsShowUnique(int commandId) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_SupportedCommand_isShowUnique(clb->GetTeamId(), groupId, commandId);
		return _ret;
	}
bool springai::ClbGroupSupportedCommandImpl::IsDisabled(int commandId) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_SupportedCommand_isDisabled(clb->GetTeamId(), groupId, commandId);
		return _ret;
	}
std::vector<const char*> springai::ClbGroupSupportedCommandImpl::GetParams(int commandId) {
		std::vector<const char*> _ret;

		int size = clb->GetInnerCallback()->Clb_Group_SupportedCommand_0ARRAY1SIZE0getParams(clb->GetTeamId(), groupId, commandId);
		const char** tmpArr = new const char*[size];
		clb->GetInnerCallback()->Clb_Group_SupportedCommand_0ARRAY1VALS0getParams(clb->GetTeamId(), groupId, commandId, tmpArr, size);
		std::vector<const char*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
