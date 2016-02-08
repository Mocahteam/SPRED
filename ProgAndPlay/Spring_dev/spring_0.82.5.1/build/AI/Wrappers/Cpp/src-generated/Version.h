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

#ifndef _CPPWRAPPER_VERSION_H
#define _CPPWRAPPER_VERSION_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Version {

private:
	AICallback* clb;

	Version(AICallback* clb);

public:

	static Version* GetInstance(AICallback* clb);

public:
	/**
	 * Returns the major engine revision number (e.g. 0.77)
	 */
	const char* GetMajor();

public:
	/**
	 * Returns the minor engine revision
	 */
	const char* GetMinor();

public:
	/**
	 * Clients that only differ in patchset can still play together.
	 * Also demos should be compatible between patchsets.
	 */
	const char* GetPatchset();

public:
	/**
	 * Returns additional information (compiler flags, svn revision etc.)
	 */
	const char* GetAdditional();

public:
	/**
	 * Returns the time of build
	 */
	const char* GetBuildTime();

public:
	/**
	 * Returns "Major.Minor"
	 */
	const char* GetNormal();

public:
	/**
	 * Returns "Major.Minor.Patchset (Additional)"
	 */
	const char* GetFull();
}; // class Version
} // namespace springai

#endif // _CPPWRAPPER_VERSION_H

