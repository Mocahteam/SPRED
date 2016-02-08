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

#include "Economy.h"

#include "IncludesSources.h"

springai::Economy::Economy(AICallback* clb) {

	this->clb = clb;
}


springai::Economy* springai::Economy::GetInstance(AICallback* clb) {

	Economy* _ret = NULL;
	_ret = new Economy(clb);
	return _ret;
}

float springai::Economy::GetCurrent(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Economy_0REF1Resource2resourceId0getCurrent(clb->GetTeamId(), c_resourceId.GetResourceId());
		return _ret;
	}
float springai::Economy::GetIncome(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Economy_0REF1Resource2resourceId0getIncome(clb->GetTeamId(), c_resourceId.GetResourceId());
		return _ret;
	}
float springai::Economy::GetUsage(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Economy_0REF1Resource2resourceId0getUsage(clb->GetTeamId(), c_resourceId.GetResourceId());
		return _ret;
	}
float springai::Economy::GetStorage(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Economy_0REF1Resource2resourceId0getStorage(clb->GetTeamId(), c_resourceId.GetResourceId());
		return _ret;
	}
