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

#include "Resource.h"

#include "IncludesSources.h"

springai::Resource::Resource(AICallback* clb, int resourceId) {

	this->clb = clb;
	this->resourceId = resourceId;
}

int springai::Resource::GetResourceId() {
	return resourceId;
}


springai::Resource* springai::Resource::GetInstance(AICallback* clb, int resourceId) {

	if (resourceId < 0) {
		return NULL;
	}

	Resource* _ret = NULL;
	_ret = new Resource(clb, resourceId);
	return _ret;
}

const char* springai::Resource::GetName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Resource_getName(clb->GetTeamId(), resourceId);
		return _ret;
	}
float springai::Resource::GetOptimum() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Resource_getOptimum(clb->GetTeamId(), resourceId);
		return _ret;
	}
