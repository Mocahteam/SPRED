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

#include "Point.h"

#include "IncludesSources.h"

springai::Point::Point(AICallback* clb, int pointId) {

	this->clb = clb;
	this->pointId = pointId;
}

int springai::Point::GetPointId() {
	return pointId;
}


springai::Point* springai::Point::GetInstance(AICallback* clb, int pointId) {

	if (pointId < 0) {
		return NULL;
	}

	Point* _ret = NULL;
	_ret = new Point(clb, pointId);
	return _ret;
}

struct SAIFloat3 springai::Point::GetPosition() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_Point_getPosition(clb->GetTeamId(), pointId);
		return _ret;
	}
struct SAIFloat3 springai::Point::GetColor() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_Point_getColor(clb->GetTeamId(), pointId);
		return _ret;
	}
const char* springai::Point::GetLabel() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_Point_getLabel(clb->GetTeamId(), pointId);
		return _ret;
	}
