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

#include "CurrentCommand.h"

#include "IncludesSources.h"

springai::CurrentCommand::CurrentCommand(AICallback* clb, int unitId, int commandId) {

	this->clb = clb;
	this->unitId = unitId;
	this->commandId = commandId;
}

int springai::CurrentCommand::GetUnitId() {
	return unitId;
}

int springai::CurrentCommand::GetCommandId() {
	return commandId;
}


springai::CurrentCommand* springai::CurrentCommand::GetInstance(AICallback* clb, int unitId, int commandId) {

	if (commandId < 0) {
		return NULL;
	}

	CurrentCommand* _ret = NULL;
	_ret = new CurrentCommand(clb, unitId, commandId);
	return _ret;
}

int springai::CurrentCommand::GetId() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_CurrentCommand_getId(clb->GetTeamId(), unitId, commandId);
		return _ret;
	}
unsigned char springai::CurrentCommand::GetOptions() {
		unsigned char _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_CurrentCommand_getOptions(clb->GetTeamId(), unitId, commandId);
		return _ret;
	}
unsigned int springai::CurrentCommand::GetTag() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_CurrentCommand_getTag(clb->GetTeamId(), unitId, commandId);
		return _ret;
	}
int springai::CurrentCommand::GetTimeOut() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_CurrentCommand_getTimeOut(clb->GetTeamId(), unitId, commandId);
		return _ret;
	}
std::vector<float> springai::CurrentCommand::GetParams() {
		std::vector<float> _ret;

		int size = clb->GetInnerCallback()->Clb_Unit_CurrentCommand_0ARRAY1SIZE0getParams(clb->GetTeamId(), unitId, commandId);
		float* tmpArr = new float[size];
		clb->GetInnerCallback()->Clb_Unit_CurrentCommand_0ARRAY1VALS0getParams(clb->GetTeamId(), unitId, commandId, tmpArr, size);
		std::vector<float> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
