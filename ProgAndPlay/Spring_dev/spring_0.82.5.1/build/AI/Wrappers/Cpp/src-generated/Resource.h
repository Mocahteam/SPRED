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

#ifndef _CPPWRAPPER_RESOURCE_H
#define _CPPWRAPPER_RESOURCE_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Resource {

private:
	AICallback* clb;
	int resourceId;

	Resource(AICallback* clb, int resourceId);

public:
	virtual int GetResourceId();

	static Resource* GetInstance(AICallback* clb, int resourceId);

public:
	const char* GetName();

public:
	float GetOptimum();
}; // class Resource
} // namespace springai

#endif // _CPPWRAPPER_RESOURCE_H

