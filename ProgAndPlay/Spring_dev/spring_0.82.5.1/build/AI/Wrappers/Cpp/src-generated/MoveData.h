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

#ifndef _CPPWRAPPER_MOVEDATA_H
#define _CPPWRAPPER_MOVEDATA_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class MoveData {

private:
	AICallback* clb;
	int unitDefId;

	MoveData(AICallback* clb, int unitDefId);

public:
	virtual int GetUnitDefId();

	static MoveData* GetInstance(AICallback* clb, int unitDefId);

public:
	float GetMaxAcceleration();

public:
	float GetMaxBreaking();

public:
	float GetMaxSpeed();

public:
	short GetMaxTurnRate();

public:
	int GetSize();

public:
	float GetDepth();

public:
	float GetMaxSlope();

public:
	float GetSlopeMod();

public:
	float GetDepthMod();

public:
	int GetPathType();

public:
	float GetCrushStrength();

public:
	/**
	 * enum MoveType { Ground_Move=0, Hover_Move=1, Ship_Move=2 };
	 */
	int GetMoveType();

public:
	/**
	 * enum MoveFamily { Tank=0, KBot=1, Hover=2, Ship=3 };
	 */
	int GetMoveFamily();

public:
	int GetTerrainClass();

public:
	bool GetFollowGround();

public:
	bool IsSubMarine();

public:
	const char* GetName();
}; // class MoveData
} // namespace springai

#endif // _CPPWRAPPER_MOVEDATA_H

