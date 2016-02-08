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

#include "OrderPreview.h"

#include "IncludesSources.h"

springai::OrderPreview::OrderPreview(AICallback* clb, int groupId) {

	this->clb = clb;
	this->groupId = groupId;
}

int springai::OrderPreview::GetGroupId() {
	return groupId;
}


springai::OrderPreview* springai::OrderPreview::GetInstance(AICallback* clb, int groupId) {

	if (groupId < 0) {
		return NULL;
	}

	OrderPreview* _ret = NULL;
	_ret = new OrderPreview(clb, groupId);
	return _ret;
}

int springai::OrderPreview::GetId() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_OrderPreview_getId(clb->GetTeamId(), groupId);
		return _ret;
	}
unsigned char springai::OrderPreview::GetOptions() {
		unsigned char _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_OrderPreview_getOptions(clb->GetTeamId(), groupId);
		return _ret;
	}
unsigned int springai::OrderPreview::GetTag() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_OrderPreview_getTag(clb->GetTeamId(), groupId);
		return _ret;
	}
int springai::OrderPreview::GetTimeOut() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_OrderPreview_getTimeOut(clb->GetTeamId(), groupId);
		return _ret;
	}
std::vector<float> springai::OrderPreview::GetParams() {
		std::vector<float> _ret;

		int size = clb->GetInnerCallback()->Clb_Group_OrderPreview_0ARRAY1SIZE0getParams(clb->GetTeamId(), groupId);
		float* tmpArr = new float[size];
		clb->GetInnerCallback()->Clb_Group_OrderPreview_0ARRAY1VALS0getParams(clb->GetTeamId(), groupId, tmpArr, size);
		std::vector<float> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
