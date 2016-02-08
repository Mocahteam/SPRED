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

#ifndef _CPPWRAPPER_FEATUREDEF_H
#define _CPPWRAPPER_FEATUREDEF_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class FeatureDef {

private:
	AICallback* clb;
	int featureDefId;

	FeatureDef(AICallback* clb, int featureDefId);

public:
	virtual int GetFeatureDefId();

	static FeatureDef* GetInstance(AICallback* clb, int featureDefId);

public:
	const char* GetName();

public:
	const char* GetDescription();

public:
	const char* GetFileName();

public:
	float GetContainedResource(Resource c_resourceId);

public:
	float GetMaxHealth();

public:
	float GetReclaimTime();

public:
	/**
	 * Used to see if the object can be overrun by units of a certain heavyness
	 */
	float GetMass();

public:
	bool IsUpright();

public:
	int GetDrawType();

public:
	const char* GetModelName();

public:
	/**
	 * Used to determine whether the feature is resurrectable.
	 * 
	 * @return  -1: (default) only if it is the 1st wreckage of
	 *              the UnitDef it originates from
	 *           0: no, never
	 *           1: yes, always
	 */
	int GetResurrectable();

public:
	int GetSmokeTime();

public:
	bool IsDestructable();

public:
	bool IsReclaimable();

public:
	bool IsBlocking();

public:
	bool IsBurnable();

public:
	bool IsFloating();

public:
	bool IsNoSelect();

public:
	bool IsGeoThermal();

public:
	/**
	 * Name of the FeatureDef that this turns into when killed (not reclaimed).
	 */
	const char* GetDeathFeature();

public:
	/**
	 * Size of the feature along the X axis - in other words: height.
	 * each size is 8 units
	 */
	int GetXSize();

public:
	/**
	 * Size of the feature along the Z axis - in other words: width.
	 * each size is 8 units
	 */
	int GetZSize();

public:
	std::map<const char*, const char*> GetCustomParams();
}; // class FeatureDef
} // namespace springai

#endif // _CPPWRAPPER_FEATUREDEF_H

