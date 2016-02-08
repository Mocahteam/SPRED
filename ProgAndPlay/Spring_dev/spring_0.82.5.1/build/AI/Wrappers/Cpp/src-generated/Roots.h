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

#ifndef _CPPWRAPPER_ROOTS_H
#define _CPPWRAPPER_ROOTS_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Roots {

private:
	AICallback* clb;

	Roots(AICallback* clb);

public:

	static Roots* GetInstance(AICallback* clb);

public:
	/**
	 * Returns the number of springs data dirs.
	 */
	int GetSize();

public:
	/**
	 * Returns the data dir at dirIndex, which is valid between 0 and (DataDirs_Roots_getSize() - 1).
	 */
	bool GetDir(char* path, int path_sizeMax, int dirIndex);

public:
	/**
	 * Returns an absolute path which consists of:
	 * data-dir + relative-path.
	 * 
	 * example:
	 * input:  "AI/Skirmish", writeable, create, dir
	 * output: "/home/userX/.spring/AI/Skirmish/"
	 * The path "/home/userX/.spring/AI/Skirmish/" is created,
	 * if it does not yet exist.
	 * 
	 * @see DataDirs_locatePath
	 * @param   path          store for the resulting absolute path
	 * @param   path_sizeMax  storage size of the above
	 * @param   relPath    the relative path to find
	 * @param   writeable  if true, only the writeable data-dir is considered
	 * @param   create     if true, and realPath is not found, its dir structure
	 *                     is created recursively under the writeable data-dir
	 * @param   dir        if true, realPath specifies a dir, which means if
	 *                     create is true, the whole path will be created,
	 *                     including the last part
	 * @return  whether the locating process was successfull
	 *          -> the path exists and is stored in an absolute form in path
	 */
	bool LocatePath(char* path, int path_sizeMax, const char* const relPath, bool writeable, bool create, bool dir);

public:
	char* AllocatePath(const char* const relPath, bool writeable, bool create, bool dir);
}; // class Roots
} // namespace springai

#endif // _CPPWRAPPER_ROOTS_H

