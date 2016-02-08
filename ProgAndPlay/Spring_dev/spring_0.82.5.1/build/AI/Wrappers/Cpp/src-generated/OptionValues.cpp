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

#include "OptionValues.h"

#include "IncludesSources.h"

springai::OptionValues::OptionValues(AICallback* clb) {

	this->clb = clb;
}


springai::OptionValues* springai::OptionValues::GetInstance(AICallback* clb) {

	OptionValues* _ret = NULL;
	_ret = new OptionValues(clb);
	return _ret;
}

int springai::OptionValues::GetSize() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_SkirmishAI_OptionValues_getSize(clb->GetTeamId());
		return _ret;
	}
const char* springai::OptionValues::GetKey(int optionIndex) {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_SkirmishAI_OptionValues_getKey(clb->GetTeamId(), optionIndex);
		return _ret;
	}
const char* springai::OptionValues::GetValue(int optionIndex) {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_SkirmishAI_OptionValues_getValue(clb->GetTeamId(), optionIndex);
		return _ret;
	}
const char* springai::OptionValues::GetValueByKey(const char* const key) {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_SkirmishAI_OptionValues_getValueByKey(clb->GetTeamId(), key);
		return _ret;
	}
