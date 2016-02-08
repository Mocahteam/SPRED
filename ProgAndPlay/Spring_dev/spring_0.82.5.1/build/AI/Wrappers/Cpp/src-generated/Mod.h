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

#ifndef _CPPWRAPPER_MOD_H
#define _CPPWRAPPER_MOD_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Mod {

private:
	AICallback* clb;

	Mod(AICallback* clb);

public:

	static Mod* GetInstance(AICallback* clb);

public:
	/**
	 * Returns the mod archive file name.
	 * CAUTION:
	 * Never use this as reference in eg. cache- or config-file names,
	 * as one and the same mod can be packaged in different ways.
	 * Use the human name instead.
	 * @see getHumanName()
	 * @deprecated
	 */
	const char* GetFileName();

public:
	/**
	 * Returns the archive hash of the mod.
	 * Use this for reference to the mod, eg. in a cache-file, wherever human
	 * readability does not matter.
	 * This value will never be the same for two mods not having equal content.
	 * Tip: convert to 64 Hex chars for use in file names.
	 * @see getHumanName()
	 */
	int GetHash();

public:
	/**
	 * Returns the human readable name of the mod, which includes the version.
	 * Use this for reference to the mod (including version), eg. in cache- or
	 * config-file names which are mod related, and wherever humans may come
	 * in contact with the reference.
	 * Be aware though, that this may contain special characters and spaces,
	 * and may not be used as a file name without checks and replaces.
	 * Alternatively, you may use the short name only, or the short name plus
	 * version. You should generally never use the file name.
	 * Tip: replace every char matching [^0-9a-zA-Z_-.] with '_'
	 * @see getHash()
	 * @see getShortName()
	 * @see getFileName()
	 * @see getVersion()
	 */
	const char* GetHumanName();

public:
	/**
	 * Returns the short name of the mod, which does not include the version.
	 * Use this for reference to the mod in general, eg. as version independent
	 * reference.
	 * Be aware though, that this still contain special characters and spaces,
	 * and may not be used as a file name without checks and replaces.
	 * Tip: replace every char matching [^0-9a-zA-Z_-.] with '_'
	 * @see getVersion()
	 * @see getHumanName()
	 */
	const char* GetShortName();

public:
	const char* GetVersion();

public:
	const char* GetMutator();

public:
	const char* GetDescription();

public:
	bool GetAllowTeamColors();

public:
	/**
	 * Should constructions without builders decay?
	 */
	bool GetConstructionDecay();

public:
	/**
	 * How long until they start decaying?
	 */
	int GetConstructionDecayTime();

public:
	/**
	 * How fast do they decay?
	 */
	float GetConstructionDecaySpeed();

public:
	/**
	 * 0 = 1 reclaimer per feature max, otherwise unlimited
	 */
	int GetMultiReclaim();

public:
	/**
	 * 0 = gradual reclaim, 1 = all reclaimed at end, otherwise reclaim in reclaimMethod chunks
	 */
	int GetReclaimMethod();

public:
	/**
	 * 0 = Revert to wireframe, gradual reclaim, 1 = Subtract HP, give full metal at end, default 1
	 */
	int GetReclaimUnitMethod();

public:
	/**
	 * How much energy should reclaiming a unit cost, default 0.0
	 */
	float GetReclaimUnitEnergyCostFactor();

public:
	/**
	 * How much metal should reclaim return, default 1.0
	 */
	float GetReclaimUnitEfficiency();

public:
	/**
	 * How much should energy should reclaiming a feature cost, default 0.0
	 */
	float GetReclaimFeatureEnergyCostFactor();

public:
	/**
	 * Allow reclaiming enemies? default true
	 */
	bool GetReclaimAllowEnemies();

public:
	/**
	 * Allow reclaiming allies? default true
	 */
	bool GetReclaimAllowAllies();

public:
	/**
	 * How much should energy should repair cost, default 0.0
	 */
	float GetRepairEnergyCostFactor();

public:
	/**
	 * How much should energy should resurrect cost, default 0.5
	 */
	float GetResurrectEnergyCostFactor();

public:
	/**
	 * How much should energy should capture cost, default 0.0
	 */
	float GetCaptureEnergyCostFactor();

public:
	/**
	 * 0 = all ground units cannot be transported, 1 = all ground units can be transported (mass and size restrictions still apply). Defaults to 1.
	 */
	int GetTransportGround();

public:
	/**
	 * 0 = all hover units cannot be transported, 1 = all hover units can be transported (mass and size restrictions still apply). Defaults to 0.
	 */
	int GetTransportHover();

public:
	/**
	 * 0 = all naval units cannot be transported, 1 = all naval units can be transported (mass and size restrictions still apply). Defaults to 0.
	 */
	int GetTransportShip();

public:
	/**
	 * 0 = all air units cannot be transported, 1 = all air units can be transported (mass and size restrictions still apply). Defaults to 0.
	 */
	int GetTransportAir();

public:
	/**
	 * 1 = units fire at enemies running Killed() script, 0 = units ignore such enemies
	 */
	int GetFireAtKilled();

public:
	/**
	 * 1 = units fire at crashing aircrafts, 0 = units ignore crashing aircrafts
	 */
	int GetFireAtCrashing();

public:
	/**
	 * 0=no flanking bonus;  1=global coords, mobile;  2=unit coords, mobile;  3=unit coords, locked
	 */
	int GetFlankingBonusModeDefault();

public:
	/**
	 * miplevel for los
	 */
	int GetLosMipLevel();

public:
	/**
	 * miplevel to use for airlos
	 */
	int GetAirMipLevel();

public:
	/**
	 * units sightdistance will be multiplied with this, for testing purposes
	 */
	float GetLosMul();

public:
	/**
	 * units airsightdistance will be multiplied with this, for testing purposes
	 */
	float GetAirLosMul();

public:
	/**
	 * when underwater, units are not in LOS unless also in sonar
	 */
	bool GetRequireSonarUnderWater();
}; // class Mod
} // namespace springai

#endif // _CPPWRAPPER_MOD_H

