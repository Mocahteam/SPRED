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

#include "Debug.h"

#include "IncludesSources.h"

springai::Debug::Debug(AICallback* clb) {

	this->clb = clb;
}


springai::Debug* springai::Debug::GetInstance(AICallback* clb) {

	Debug* _ret = NULL;
	_ret = new Debug(clb);
	return _ret;
}

springai::Drawer* springai::Debug::GetDrawer() {

		Drawer* _ret;
		_ret = Drawer::GetInstance(clb);
		return _ret;
	}
