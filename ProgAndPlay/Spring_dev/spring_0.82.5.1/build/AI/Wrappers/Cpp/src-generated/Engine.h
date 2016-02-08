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

#ifndef _CPPWRAPPER_ENGINE_H
#define _CPPWRAPPER_ENGINE_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Engine {

private:
	AICallback* clb;

	Engine(AICallback* clb);

public:

	static Engine* GetInstance(AICallback* clb);

public:
	/**
	 * Whenever an AI wants to change the engine state in any way,
	 * it has to call this method.
	 * In other words, all commands from AIs to the engine (and other AIs)
	 * go through this method.
	 * 
	 * @param teamId       the team number of the AI that sends the command
	 * @param toId         the team number of the AI that should receive
	 *                     the command, or COMMAND_TO_ID_ENGINE if it is addressed
	 *                     to the engine
	 * @param commandId    used on asynchronous commands, this allows the AI to
	 *                     identify a possible result event, which would come
	 *                     with the same id
	 * @param commandTopic unique identifier of a command
	 *                     (see COMMAND_* defines in AISCommands.h)
	 * @param commandData  a commandTopic specific struct, which contains
	 *                     the data associated with the command
	 *                     (see *Command structs)
	 * @return     0: if command handling ok
	 *          != 0: something else otherwise
	 */
	int HandleCommand(int toId, int commandId, int commandTopic, void* commandData);
public:
	Version* GetVersion();
}; // class Engine
} // namespace springai

#endif // _CPPWRAPPER_ENGINE_H

