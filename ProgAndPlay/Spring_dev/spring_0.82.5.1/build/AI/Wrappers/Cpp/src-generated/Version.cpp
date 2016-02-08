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

#include "Version.h"

#include "IncludesSources.h"

springai::Version::Version(AICallback* clb) {

	this->clb = clb;
}


springai::Version* springai::Version::GetInstance(AICallback* clb) {

	Version* _ret = NULL;
	_ret = new Version(clb);
	return _ret;
}

const char* springai::Version::GetMajor() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Engine_Version_getMajor(clb->GetTeamId());
		return _ret;
	}
const char* springai::Version::GetMinor() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Engine_Version_getMinor(clb->GetTeamId());
		return _ret;
	}
const char* springai::Version::GetPatchset() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Engine_Version_getPatchset(clb->GetTeamId());
		return _ret;
	}
const char* springai::Version::GetAdditional() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Engine_Version_getAdditional(clb->GetTeamId());
		return _ret;
	}
const char* springai::Version::GetBuildTime() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Engine_Version_getBuildTime(clb->GetTeamId());
		return _ret;
	}
const char* springai::Version::GetNormal() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Engine_Version_getNormal(clb->GetTeamId());
		return _ret;
	}
const char* springai::Version::GetFull() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Engine_Version_getFull(clb->GetTeamId());
		return _ret;
	}
