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

#ifndef _CPPWRAPPER_OPTIONVALUES_H
#define _CPPWRAPPER_OPTIONVALUES_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class OptionValues {

private:
	AICallback* clb;

	OptionValues(AICallback* clb);

public:

	static OptionValues* GetInstance(AICallback* clb);

public:
	/**
	 * Returns the number of option key-value pairs in the options map
	 * for this Skirmish AI.
	 */
	int GetSize();

public:
	/**
	 * Returns the key at index optionIndex in the options map
	 * for this Skirmish AI, or NULL if the optionIndex is invalid.
	 */
	const char* GetKey(int optionIndex);

public:
	/**
	 * Returns the value at index optionIndex in the options map
	 * for this Skirmish AI, or NULL if the optionIndex is invalid.
	 */
	const char* GetValue(int optionIndex);

public:
	/**
	 * Returns the value associated with the given key in the options map
	 * for this Skirmish AI, or NULL if not found.
	 */
	const char* GetValueByKey(const char* const key);
}; // class OptionValues
} // namespace springai

#endif // _CPPWRAPPER_OPTIONVALUES_H

