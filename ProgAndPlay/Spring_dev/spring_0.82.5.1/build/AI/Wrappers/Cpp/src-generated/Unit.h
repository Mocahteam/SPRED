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

#ifndef _CPPWRAPPER_UNIT_H
#define _CPPWRAPPER_UNIT_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Unit {

private:
	AICallback* clb;
	int unitId;

	Unit(AICallback* clb, int unitId);

public:
	virtual int GetUnitId();

	static Unit* GetInstance(AICallback* clb, int unitId);

public:
	/**
	 * Returns the unit's unitdef struct from which you can read all
	 * the statistics of the unit, do NOT try to change any values in it.
	 */
	UnitDef* GetDef();

public:
	int GetTeam();

public:
	int GetAllyTeam();

public:
	/**
	 * The unit's origin lies in this team.
	 * 
	 * example:
	 * It was created by a factory that was created by a builder
	 * from a factory built by a commander of this team.
	 * It does not matter at all, to which team
	 * the commander/builder/factories were shared.
	 * Only capturing can break the chain.
	 */
	int GetLineage();

public:
	/**
	 * Indicates the units main function.
	 * This can be used as help for (skirmish) AIs.
	 * 
	 * example:
	 * A unit can shoot, build and transport other units.
	 * To human players, it is obvious that transportation is the units
	 * main function, as it can transport a lot of units,
	 * but has only weak build- and fire-power.
	 * Instead of letting the AI developers write complex
	 * algorithms to find out the same, mod developers can set this value.
	 * 
	 * @return  0: ???
	 *          1: ???
	 *          2: ???
	 *          ...
	 */
	int GetAiHint();

public:
	int GetStockpile();

public:
	int GetStockpileQueued();

public:
	float GetCurrentFuel();

public:
	/**
	 * The unit's max speed
	 */
	float GetMaxSpeed();

public:
	/**
	 * The furthest any weapon of the unit can fire
	 */
	float GetMaxRange();

public:
	/**
	 * The unit's max health
	 */
	float GetMaxHealth();

public:
	/**
	 * How experienced the unit is (0.0f-1.0f)
	 */
	float GetExperience();

public:
	/**
	 * Returns the group a unit belongs to, -1 if none
	 */
	int GetGroup();

public:
	/**
	 * The unit's current health
	 */
	float GetHealth();

public:
	float GetSpeed();

public:
	/**
	 * Indicate the relative power of the unit,
	 * used for experience calulations etc.
	 * This is sort of the measure of the units overall power.
	 */
	float GetPower();

public:
	float GetResourceUse(Resource c_resourceId);

public:
	float GetResourceMake(Resource c_resourceId);

public:
	struct SAIFloat3 GetPos();

public:
	struct SAIFloat3 GetVel();

public:
	bool IsActivated();

public:
	/**
	 * Returns true if the unit is currently being built
	 */
	bool IsBeingBuilt();

public:
	bool IsCloaked();

public:
	bool IsParalyzed();

public:
	bool IsNeutral();

public:
	/**
	 * Returns the unit's build facing (0-3)
	 */
	int GetBuildingFacing();

public:
	/**
	 * Number of the last frame this unit received an order from a player.
	 */
	int GetLastUserOrderFrame();
	/**
	 * This is a set of parameters that is initialized
	 * in CreateUnitRulesParams() and may change during the game.
	 * Each parameter is uniquely identified only by its id
	 * (which is the index in the vector).
	 * Parameters may or may not have a name.
	 */
public:
	std::vector<ModParam*> GetModParams();
public:
	std::vector<CurrentCommand*> GetCurrentCommands();
public:
	SupportedCommand* GetSupportedCommand();
}; // class Unit
} // namespace springai

#endif // _CPPWRAPPER_UNIT_H

