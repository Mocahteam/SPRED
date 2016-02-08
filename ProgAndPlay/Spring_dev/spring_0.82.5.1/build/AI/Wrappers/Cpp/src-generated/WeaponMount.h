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

#ifndef _CPPWRAPPER_WEAPONMOUNT_H
#define _CPPWRAPPER_WEAPONMOUNT_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class WeaponMount {

private:
	AICallback* clb;
	int unitDefId;
	int weaponMountId;

	WeaponMount(AICallback* clb, int unitDefId, int weaponMountId);

public:
	virtual int GetUnitDefId();
	virtual int GetWeaponMountId();

	static WeaponMount* GetInstance(AICallback* clb, int unitDefId, int weaponMountId);

public:
	const char* GetName();

public:
	WeaponDef* GetWeaponDef();

public:
	int GetSlavedTo();

public:
	struct SAIFloat3 GetMainDir();

public:
	float GetMaxAngleDif();

public:
	/**
	 * How many seconds of fuel it costs for the owning unit to fire this weapon.
	 */
	float GetFuelUsage();

public:
	unsigned int GetBadTargetCategory();

public:
	unsigned int GetOnlyTargetCategory();
}; // class WeaponMount
} // namespace springai

#endif // _CPPWRAPPER_WEAPONMOUNT_H

