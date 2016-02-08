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

#include "DataDirs.h"

#include "IncludesSources.h"

springai::DataDirs::DataDirs(AICallback* clb) {

	this->clb = clb;
}


springai::DataDirs* springai::DataDirs::GetInstance(AICallback* clb) {

	DataDirs* _ret = NULL;
	_ret = new DataDirs(clb);
	return _ret;
}

char springai::DataDirs::GetPathSeparator() {
		char _ret;
		_ret = clb->GetInnerCallback()->Clb_DataDirs_getPathSeparator(clb->GetTeamId());
		return _ret;
	}
const char* springai::DataDirs::GetConfigDir() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_DataDirs_getConfigDir(clb->GetTeamId());
		return _ret;
	}
const char* springai::DataDirs::GetWriteableDir() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_DataDirs_getWriteableDir(clb->GetTeamId());
		return _ret;
	}
bool springai::DataDirs::LocatePath(char* path, int path_sizeMax, const char* const relPath, bool writeable, bool create, bool dir, bool common) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_DataDirs_locatePath(clb->GetTeamId(), path, path_sizeMax, relPath, writeable, create, dir, common);
		return _ret;
	}
char* springai::DataDirs::AllocatePath(const char* const relPath, bool writeable, bool create, bool dir, bool common) {
		char* _ret;
		_ret = clb->GetInnerCallback()->Clb_DataDirs_allocatePath(clb->GetTeamId(), relPath, writeable, create, dir, common);
		return _ret;
	}
springai::Roots* springai::DataDirs::GetRoots() {

		Roots* _ret;
		_ret = Roots::GetInstance(clb);
		return _ret;
	}
