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

#ifndef _CPPWRAPPER_SHIELD_H
#define _CPPWRAPPER_SHIELD_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Shield {

private:
	AICallback* clb;
	int weaponDefId;

	Shield(AICallback* clb, int weaponDefId);

public:
	virtual int GetWeaponDefId();

	static Shield* GetInstance(AICallback* clb, int weaponDefId);

public:
	/**
	 * Amount of the resource used per shot or per second,
	 * depending on the type of projectile.
	 */
	float GetResourceUse(Resource c_resourceId);

public:
	/**
	 * Size of shield covered area
	 */
	float GetRadius();

public:
	/**
	 * Shield acceleration on plasma stuff.
	 * How much will plasma be accelerated into the other direction
	 * when it hits the shield.
	 */
	float GetForce();

public:
	/**
	 * Maximum speed to which the shield can repulse plasma.
	 */
	float GetMaxSpeed();

public:
	/**
	 * Amount of damage the shield can reflect. (0=infinite)
	 */
	float GetPower();

public:
	/**
	 * Amount of power that is regenerated per second.
	 */
	float GetPowerRegen();

public:
	/**
	 * How much of a given resource is needed to regenerate power
	 * with max speed per second.
	 */
	float GetPowerRegenResource(Resource c_resourceId);

public:
	/**
	 * How much power the shield has when it is created.
	 */
	float GetStartingPower();

public:
	/**
	 * Number of frames to delay recharging by after each hit.
	 */
	int GetRechargeDelay();

public:
	/**
	 * The color of the shield when it is at full power.
	 */
	struct SAIFloat3 GetGoodColor();

public:
	/**
	 * The color of the shield when it is empty.
	 */
	struct SAIFloat3 GetBadColor();

public:
	/**
	 * The shields alpha value.
	 */
	float GetAlpha();

public:
	/**
	 * The type of the shield (bitfield).
	 * Defines what weapons can be intercepted by the shield.
	 * 
	 * @see  getInterceptedByShieldType()
	 */
	unsigned int GetInterceptType();
}; // class Shield
} // namespace springai

#endif // _CPPWRAPPER_SHIELD_H

