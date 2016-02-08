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

#ifndef _CPPWRAPPER_LOG_H
#define _CPPWRAPPER_LOG_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Log {

private:
	AICallback* clb;

	Log(AICallback* clb);

public:

	static Log* GetInstance(AICallback* clb);

public:
	/**
	 * This will end up in infolog
	 */
	void log(const char* const msg);

public:
	/**
	 * Inform the engine of an error that happend in the interface.
	 * @param   msg       error message
	 * @param   severety  from 10 for minor to 0 for fatal
	 * @param   die       if this is set to true, the engine assumes
	 *                    the interface is in an irreparable state, and it will
	 *                    unload it immediately.
	 */
	void Exception(const char* const msg, int severety, bool die);
}; // class Log
} // namespace springai

#endif // _CPPWRAPPER_LOG_H

