/* This file is part of the Spring engine (GPL v2 or later), see LICENSE.html */

#ifndef __PROG_AND_PLAY_H__
#define __PROG_AND_PLAY_H__

// Muratet (Define Class CProgAndPlay) ---

#include "Sim/Units/Unit.h"
#include "Sim/Misc/GlobalConstants.h"
#include <ctime>
#include "lib/pp/traces/TracesParser.h"
#include "lib/pp/traces/TracesAnalyser.h"
#include "Lua/LuaHandle.h"
#include <boost/thread.hpp>

class CProgAndPlay
{
public:
	
	CProgAndPlay();
	~CProgAndPlay();
	
	void Update(void);
	void GamePaused(bool paused);
	void TracePlayer();
	void UpdateTimestamp();
	
	void AddUnit(CUnit* unit);
	void UpdateUnit(CUnit* unit);
	void RemoveUnit(CUnit* unit);

private:

	bool loaded;
	bool updated;
	bool missionEnded;
	bool tracePlayer;
	bool launchAnalysis;
	std::string missionName;
	std::time_t startTime;
	boost::thread tracesThread;
	TracesParser tp;
		
	int updatePP(); // update Prog&Play data if necessary
	int execPendingCommands(); // execute pending command from Prog&Play
	void logMessages(); // log messages from Prog&Play
	void openTracesFile(); // open the appropriate traces file based on the current mission
	bool allUnitsIdled(); //returns true if all units' command queues are empty
	
};

static int frame_counter = 0;

extern CProgAndPlay* pp;

// ---

#endif // __PROG_AND_PLAY_H__
