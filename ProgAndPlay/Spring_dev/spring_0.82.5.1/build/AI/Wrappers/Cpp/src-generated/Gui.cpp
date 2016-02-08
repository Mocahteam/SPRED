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

#include "Gui.h"

#include "IncludesSources.h"

springai::Gui::Gui(AICallback* clb) {

	this->clb = clb;
}


springai::Gui* springai::Gui::GetInstance(AICallback* clb) {

	Gui* _ret = NULL;
	_ret = new Gui(clb);
	return _ret;
}

float springai::Gui::GetViewRange() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Gui_getViewRange(clb->GetTeamId());
		return _ret;
	}
float springai::Gui::GetScreenX() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Gui_getScreenX(clb->GetTeamId());
		return _ret;
	}
float springai::Gui::GetScreenY() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Gui_getScreenY(clb->GetTeamId());
		return _ret;
	}
springai::Camera* springai::Gui::GetCamera() {

		Camera* _ret;
		_ret = Camera::GetInstance(clb);
		return _ret;
	}
