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

#include "Group.h"

#include "IncludesSources.h"

springai::Group::Group(AICallback* clb, int groupId) {

	this->clb = clb;
	this->groupId = groupId;
}

int springai::Group::GetGroupId() {
	return groupId;
}


springai::Group* springai::Group::GetInstance(AICallback* clb, int groupId) {

	if (groupId < 0) {
		return NULL;
	}

	Group* _ret = NULL;
	_ret = new Group(clb, groupId);
	return _ret;
}

bool springai::Group::IsSelected() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Group_isSelected(clb->GetTeamId(), groupId);
		return _ret;
	}
springai::SupportedCommand* springai::Group::GetSupportedCommand() {

		SupportedCommand* _ret;
		_ret = ClbGroupSupportedCommandImpl::GetInstance(clb, groupId);
		return _ret;
	}
springai::OrderPreview* springai::Group::GetOrderPreview() {

		OrderPreview* _ret;
		_ret = OrderPreview::GetInstance(clb, groupId);
		return _ret;
	}
