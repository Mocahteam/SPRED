/* This file is part of the Spring engine (GPL v2 or later), see LICENSE.html */

#ifndef __PROG_AND_PLAY_H__
#define __PROG_AND_PLAY_H__

// used to define a delay to detect if player's program is endless or if units are idled
#define UPDATE_RATE_MULTIPLIER 4

// Muratet (Define Class CProgAndPlay) ---

#include "Sim/Units/Unit.h"
#include "Sim/Misc/GlobalConstants.h"
#include <ctime>
#include "lib/pp/traces/TracesParser.h"
#include "lib/pp/traces/TracesAnalyser.h"
#include "Lua/LuaHandle.h"
#include "System/FileSystem/VFSHandler.h"
#include "System/FileSystem/ArchiveScanner.h"
#include "System/ConfigHandler.h"
#include <boost/thread.hpp>
#include <windows.h>
#include <boost/asio.hpp>

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
	bool archiveLoaded;
	std::string photoFilename;
	std::string archivePath;
	std::string missionName;
	std::string lang;
	std::time_t startTime;
	boost::thread tracesThread;
	TracesParser tp;
	TracesAnalyser ta;
	
	int updatePP(); // update Prog&Play data if necessary
	int execPendingCommands(); // execute pending command from Prog&Play
	void logMessages(bool unitsIdled); // log messages from Prog&Play
	void openTracesFile(); // open the appropriate traces file based on the current mission
	bool allUnitsIdled(); // returns true if all units' command queues are empty (units of the player)
	bool allUnitsDead(); // returns true if the player has no units left in the game
	
	const std::string loadFile(std::string full_path);
	const std::string loadFileFromArchive(std::string full_path);
	void publishOnFacebook();
	void sendRequestToServer();
	void openFacebookUrl();
};

static int endless_loop_frame_counter = -1;
static int units_idled_frame_counter = -1;

extern CProgAndPlay* pp;

// ---

#endif // __PROG_AND_PLAY_H__
