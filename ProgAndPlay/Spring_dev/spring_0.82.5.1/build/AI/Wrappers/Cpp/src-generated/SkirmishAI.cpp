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

#include "SkirmishAI.h"

#include "IncludesSources.h"

springai::SkirmishAI::SkirmishAI(AICallback* clb) {

	this->clb = clb;
}


springai::SkirmishAI* springai::SkirmishAI::GetInstance(AICallback* clb) {

	SkirmishAI* _ret = NULL;
	_ret = new SkirmishAI(clb);
	return _ret;
}

springai::Info* springai::SkirmishAI::GetInfo() {

		Info* _ret;
		_ret = Info::GetInstance(clb);
		return _ret;
	}
springai::OptionValues* springai::SkirmishAI::GetOptionValues() {

		OptionValues* _ret;
		_ret = OptionValues::GetInstance(clb);
		return _ret;
	}
