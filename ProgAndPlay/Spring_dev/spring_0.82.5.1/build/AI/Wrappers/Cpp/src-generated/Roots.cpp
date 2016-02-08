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

#include "Roots.h"

#include "IncludesSources.h"

springai::Roots::Roots(AICallback* clb) {

	this->clb = clb;
}


springai::Roots* springai::Roots::GetInstance(AICallback* clb) {

	Roots* _ret = NULL;
	_ret = new Roots(clb);
	return _ret;
}

int springai::Roots::GetSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_DataDirs_Roots_getSize(clb->GetTeamId());
		return _ret;
	}
bool springai::Roots::GetDir(char* path, int path_sizeMax, int dirIndex) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_DataDirs_Roots_getDir(clb->GetTeamId(), path, path_sizeMax, dirIndex);
		return _ret;
	}
bool springai::Roots::LocatePath(char* path, int path_sizeMax, const char* const relPath, bool writeable, bool create, bool dir) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_DataDirs_Roots_locatePath(clb->GetTeamId(), path, path_sizeMax, relPath, writeable, create, dir);
		return _ret;
	}
char* springai::Roots::AllocatePath(const char* const relPath, bool writeable, bool create, bool dir) {
		char* _ret;
		_ret = clb->GetInnerCallback()->Clb_DataDirs_Roots_allocatePath(clb->GetTeamId(), relPath, writeable, create, dir);
		return _ret;
	}
