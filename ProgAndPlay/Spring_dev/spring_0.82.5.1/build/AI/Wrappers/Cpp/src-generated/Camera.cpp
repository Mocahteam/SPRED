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

#include "Camera.h"

#include "IncludesSources.h"

springai::Camera::Camera(AICallback* clb) {

	this->clb = clb;
}


springai::Camera* springai::Camera::GetInstance(AICallback* clb) {

	Camera* _ret = NULL;
	_ret = new Camera(clb);
	return _ret;
}

struct SAIFloat3 springai::Camera::GetDirection() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Gui_Camera_getDirection(clb->GetTeamId());
		return _ret;
	}
struct SAIFloat3 springai::Camera::GetPosition() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Gui_Camera_getPosition(clb->GetTeamId());
		return _ret;
	}
