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

#ifndef _CPPWRAPPER_GAME_H
#define _CPPWRAPPER_GAME_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Game {

private:
	AICallback* clb;

	Game(AICallback* clb);

public:

	static Game* GetInstance(AICallback* clb);

public:
	/**
	 * Returns the current game time measured in frames (the
	 * simulation runs at 30 frames per second at normal speed)
	 * 
	 * This should not be used, as we get the frame from the SUpdateEvent.
	 * @deprecated
	 */
	int GetCurrentFrame();

public:
	int GetAiInterfaceVersion();

public:
	int GetMyTeam();

public:
	int GetMyAllyTeam();

public:
	int GetPlayerTeam(int playerId);

public:
	/**
	 * Returns the name of the side of a team in the game.
	 * 
	 * This should not be used, as it may be "",
	 * and as the AI should rather rely on the units it has,
	 * which will lead to a more stable and versatile AI.
	 * @deprecated
	 * 
	 * @return eg. "ARM" or "CORE"; may be "", depending on how the game was setup
	 */
	const char* GetTeamSide(int otherTeamId);

public:
	/**
	 * Returns the color of a team in the game.
	 * 
	 * This should only be used when drawing stuff,
	 * and not for team-identification.
	 * @return the RGB color of a team, with values in [0, 255]
	 */
	struct SAIFloat3 GetTeamColor(int otherTeamId);

public:
	/**
	 * Returns the ally-team of a team
	 */
	int GetTeamAllyTeam(int otherTeamId);

public:
	/**
	 * Returns true, if the two supplied ally-teams are currently allied
	 */
	bool IsAllied(int firstAllyTeamId, int secondAllyTeamId);

public:
	bool IsExceptionHandlingEnabled();

public:
	bool IsDebugModeEnabled();

public:
	int GetMode();

public:
	bool IsPaused();

public:
	float GetSpeedFactor();

public:
	const char* GetSetupScript();
}; // class Game
} // namespace springai

#endif // _CPPWRAPPER_GAME_H

