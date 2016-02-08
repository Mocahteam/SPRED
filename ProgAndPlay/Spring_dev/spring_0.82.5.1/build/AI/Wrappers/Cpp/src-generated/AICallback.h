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

#ifndef _CPPWRAPPER_AICALLBACK_H
#define _CPPWRAPPER_AICALLBACK_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class AICallback {

private:
	const SSkirmishAICallback* innerCallback;
	int teamId;

	AICallback(const SSkirmishAICallback* innerCallback, int teamId);

public:

	static AICallback* GetInstance(const SSkirmishAICallback* innerCallback, int teamId);
	const SSkirmishAICallback* GetInnerCallback();
	int GetTeamId();
public:
	Engine* GetEngine();
public:
	Teams* GetTeams();
public:
	SkirmishAIs* GetSkirmishAIs();
public:
	SkirmishAI* GetSkirmishAI();
public:
	Log* GetLog();
public:
	DataDirs* GetDataDirs();
public:
	Game* GetGame();
public:
	Gui* GetGui();
public:
	Cheats* GetCheats();
public:
	std::vector<Resource*> GetResources();
public:
	Economy* GetEconomy();
	/**
	 * A UnitDef contains all properties of a unit that are specific to its type,
	 * for example the number and type of weapons or max-speed.
	 * These properties are usually fixed, and not meant to change during a game.
	 * The unitId is a unique id for this type of unit.
	 */
public:
	std::vector<UnitDef*> GetUnitDefs();
	/**
	 * Returns all units that are not in this teams ally-team nor neutral and are
	 * in LOS.
	 */
public:
	std::vector<Unit*> GetEnemyUnits();
	/**
	 * Returns all units that are not in this teams ally-team nor neutral and are
	 * in LOS plus they have to be located in the specified area of the map.
	 */
public:
	std::vector<Unit*> GetEnemyUnitsIn(struct SAIFloat3 pos, float radius);
	/**
	 * Returns all units that are not in this teams ally-team nor neutral and are in
	 * some way visible (sight or radar).
	 */
public:
	std::vector<Unit*> GetEnemyUnitsInRadarAndLos();
	/**
	 * Returns all units that are in this teams ally-team, including this teams
	 * units.
	 */
public:
	std::vector<Unit*> GetFriendlyUnits();
	/**
	 * Returns all units that are in this teams ally-team, including this teams
	 * units plus they have to be located in the specified area of the map.
	 */
public:
	std::vector<Unit*> GetFriendlyUnitsIn(struct SAIFloat3 pos, float radius);
	/**
	 * Returns all units that are neutral and are in LOS.
	 */
public:
	std::vector<Unit*> GetNeutralUnits();
	/**
	 * Returns all units that are neutral and are in LOS plus they have to be
	 * located in the specified area of the map.
	 */
public:
	std::vector<Unit*> GetNeutralUnitsIn(struct SAIFloat3 pos, float radius);
	/**
	 * Returns all units that are of the team controlled by this AI instance. This
	 * list can also be created dynamically by the AI, through updating a list on
	 * each unit-created and unit-destroyed event.
	 */
public:
	std::vector<Unit*> GetTeamUnits();
	/**
	 * Returns all units that are currently selected
	 * (usually only contains units if a human payer
	 * is controlling this team as well).
	 */
public:
	std::vector<Unit*> GetSelectedUnits();
public:
	std::vector<Group*> GetGroups();
public:
	Mod* GetMod();
public:
	Map* GetMap();
public:
	std::vector<FeatureDef*> GetFeatureDefs();
	/**
	 * Returns all features currently in LOS, or all features on the map
	 * if cheating is enabled.
	 */
public:
	std::vector<Feature*> GetFeatures();
	/**
	 * Returns all features in a specified area that are currently in LOS,
	 * or all features in this area if cheating is enabled.
	 */
public:
	std::vector<Feature*> GetFeaturesIn(struct SAIFloat3 pos, float radius);
public:
	std::vector<WeaponDef*> GetWeaponDefs();
public:
	Debug* GetDebug();
}; // class AICallback
} // namespace springai

#endif // _CPPWRAPPER_AICALLBACK_H

