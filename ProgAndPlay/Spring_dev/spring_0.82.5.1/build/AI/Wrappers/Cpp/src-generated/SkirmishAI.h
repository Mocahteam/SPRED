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

#ifndef _CPPWRAPPER_SKIRMISHAI_H
#define _CPPWRAPPER_SKIRMISHAI_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class SkirmishAI {

private:
	AICallback* clb;

	SkirmishAI(AICallback* clb);

public:

	static SkirmishAI* GetInstance(AICallback* clb);
public:
	Info* GetInfo();
public:
	OptionValues* GetOptionValues();
}; // class SkirmishAI
} // namespace springai

#endif // _CPPWRAPPER_SKIRMISHAI_H

