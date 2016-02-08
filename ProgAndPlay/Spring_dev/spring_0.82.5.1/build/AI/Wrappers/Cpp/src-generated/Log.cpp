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

#include "Log.h"

#include "IncludesSources.h"

springai::Log::Log(AICallback* clb) {

	this->clb = clb;
}


springai::Log* springai::Log::GetInstance(AICallback* clb) {

	Log* _ret = NULL;
	_ret = new Log(clb);
	return _ret;
}

void springai::Log::log(const char* const msg) {
		clb->GetInnerCallback()->Clb_Log_log(clb->GetTeamId(), msg);
	}
void springai::Log::Exception(const char* const msg, int severety, bool die) {
		clb->GetInnerCallback()->Clb_Log_exception(clb->GetTeamId(), msg, severety, die);
	}
