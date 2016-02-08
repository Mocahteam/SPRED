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

#ifndef _CPPWRAPPER_FLANKINGBONUS_H
#define _CPPWRAPPER_FLANKINGBONUS_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class FlankingBonus {

private:
	AICallback* clb;
	int unitDefId;

	FlankingBonus(AICallback* clb, int unitDefId);

public:
	virtual int GetUnitDefId();

	static FlankingBonus* GetInstance(AICallback* clb, int unitDefId);

public:
	/**
	 * The flanking bonus indicates how much additional damage you can inflict to
	 * a unit, if it gets attacked from different directions.
	 * See the spring source code if you want to know it more precisely.
	 * 
	 * @return  0: no flanking bonus
	 *          1: global coords, mobile
	 *          2: unit coords, mobile
	 *          3: unit coords, locked
	 */
	int GetMode();

public:
	/**
	 * The unit takes less damage when attacked from this direction.
	 * This encourage flanking fire.
	 */
	struct SAIFloat3 GetDir();

public:
	/**
	 * Damage factor for the least protected direction
	 */
	float GetMax();

public:
	/**
	 * Damage factor for the most protected direction
	 */
	float GetMin();

public:
	/**
	 * How much the ability of the flanking bonus direction to move builds up each
	 * frame.
	 */
	float GetMobilityAdd();
}; // class FlankingBonus
} // namespace springai

#endif // _CPPWRAPPER_FLANKINGBONUS_H

