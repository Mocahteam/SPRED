/* This file is part of the Spring engine (GPL v2 or later), see LICENSE.html */

#include "StdAfx.h"

#include <set>
#include <list>
#include <cctype>
#include <limits.h>
#include <boost/regex.hpp>
using namespace std;

#include "mmgr.h"

#include "LuaVFS.h"

#include "LuaInclude.h"

#include "LuaHandle.h"
#include "LuaHashString.h"
#include "LuaIO.h"
#include "LuaUtils.h"
#include "LogOutput.h"
#include "FileSystem/FileHandler.h"
#include <FileSystem/ArchiveScanner.h>
#include "FileSystem/VFSHandler.h"
#include "FileSystem/FileSystem.h"
#include "Util.h"

// Muratet (Bontemps) ---
#include "lib/minizip/zip.h"
#include "lib/minizip/unzip.h"
#include "FileSystem/FileSystemHandler.h"
#include <boost/algorithm/string.hpp>

#include <fstream>
#include <sstream>
#include <streambuf>
std::ofstream LogDBGFile("log.txt");

void LogDBG(std::string msg){
	LogDBGFile << msg << std::endl;
}
// ---


/******************************************************************************/
/******************************************************************************/

bool LuaVFS::PushCommon(lua_State* L)
{
	HSTR_PUSH_STRING(L, "RAW",       SPRING_VFS_RAW);
	HSTR_PUSH_STRING(L, "MOD",       SPRING_VFS_MOD);
	HSTR_PUSH_STRING(L, "MAP",       SPRING_VFS_MAP);
	HSTR_PUSH_STRING(L, "BASE",      SPRING_VFS_BASE);
	HSTR_PUSH_STRING(L, "ZIP",       SPRING_VFS_ZIP);
	HSTR_PUSH_STRING(L, "RAW_FIRST", SPRING_VFS_RAW_FIRST);
	HSTR_PUSH_STRING(L, "ZIP_FIRST", SPRING_VFS_ZIP_FIRST);
	HSTR_PUSH_STRING(L, "RAW_ONLY",  SPRING_VFS_RAW); // backwards compatibility
	HSTR_PUSH_STRING(L, "ZIP_ONLY",  SPRING_VFS_ZIP); // backwards compatibility

	HSTR_PUSH_CFUNC(L, "PackU8",    PackU8);
	HSTR_PUSH_CFUNC(L, "PackU16",   PackU16);
	HSTR_PUSH_CFUNC(L, "PackU32",   PackU32);
	HSTR_PUSH_CFUNC(L, "PackS8",    PackS8);
	HSTR_PUSH_CFUNC(L, "PackS16",   PackS16);
	HSTR_PUSH_CFUNC(L, "PackS32",   PackS32);
	HSTR_PUSH_CFUNC(L, "PackF32",   PackF32);
	HSTR_PUSH_CFUNC(L, "UnpackU8",  UnpackU8);
	HSTR_PUSH_CFUNC(L, "UnpackU16", UnpackU16);
	HSTR_PUSH_CFUNC(L, "UnpackU32", UnpackU32);
	HSTR_PUSH_CFUNC(L, "UnpackS8",  UnpackS8);
	HSTR_PUSH_CFUNC(L, "UnpackS16", UnpackS16);
	HSTR_PUSH_CFUNC(L, "UnpackS32", UnpackS32);
	HSTR_PUSH_CFUNC(L, "UnpackF32", UnpackF32);

	HSTR_PUSH_CFUNC(L, "ZlibDecompress", ZlibDecompress);

	return true;
}


bool LuaVFS::PushSynced(lua_State* L)
{
	PushCommon(L);

	HSTR_PUSH_CFUNC(L, "Include",    SyncInclude);
	HSTR_PUSH_CFUNC(L, "LoadFile",   SyncLoadFile);
	HSTR_PUSH_CFUNC(L, "FileExists", SyncFileExists);
	HSTR_PUSH_CFUNC(L, "DirList",    SyncDirList);
	HSTR_PUSH_CFUNC(L, "SubDirs",    SyncSubDirs);

	return true;
}


bool LuaVFS::PushUnsynced(lua_State* L)
{
	PushCommon(L);

	HSTR_PUSH_CFUNC(L, "Include",    UnsyncInclude);
	HSTR_PUSH_CFUNC(L, "LoadFile",   UnsyncLoadFile);
	HSTR_PUSH_CFUNC(L, "FileExists", UnsyncFileExists);
	HSTR_PUSH_CFUNC(L, "DirList",    UnsyncDirList);
	HSTR_PUSH_CFUNC(L, "SubDirs",    UnsyncSubDirs);
	HSTR_PUSH_CFUNC(L, "UseArchive", UseArchive);
	HSTR_PUSH_CFUNC(L, "MapArchive", MapArchive);

	HSTR_PUSH_CFUNC(L, "ZlibCompress", ZlibCompress);
	// Muratet (Bontemps) ---
	HSTR_PUSH_CFUNC(L, "BuildPPEditor", BuildPPEditor);
	HSTR_PUSH_CFUNC(L, "BuildPPGame", BuildPPGame);
	HSTR_PUSH_CFUNC(L, "GetGames", GetGames);
	HSTR_PUSH_CFUNC(L, "GetMaps", GetMaps);
	HSTR_PUSH_CFUNC(L, "GetArchiveDependencies", GetArchiveDependencies);
	HSTR_PUSH_CFUNC(L, "GetArchiveInfo", GetArchiveInfo);
	// ---

	return true;
}


/******************************************************************************/
/******************************************************************************/

const string LuaVFS::GetModes(lua_State* L, int index, bool synced)
{
	const int args = lua_gettop(L);
	if (index < 0) {
		index = (args + index + 1);
	}
	if ((index < 1) || (index > args)) {
		if (synced && !CLuaHandle::GetDevMode()) {
			return SPRING_VFS_ZIP;
		}
		return SPRING_VFS_RAW_FIRST;
	}

	if (!lua_israwstring(L, index)) {
		luaL_error(L, "Bad VFS access mode");
	}

	string modes = lua_tostring(L, index);
	if (synced && !CLuaHandle::GetDevMode()) {
		modes = CFileHandler::ForbidModes(modes, SPRING_VFS_RAW);
	}

	return modes;
}


/******************************************************************************/

static bool LoadFileWithModes(const string& filename, string& data,
                             const string& modes)
{
	CFileHandler fh(filename, modes);
	if (!fh.FileExists()) {
		return false;
	}
	data.clear();
	if (!fh.LoadStringData(data)) {
		return false;
	}
	return true;
}


/******************************************************************************/
/******************************************************************************/

int LuaVFS::Include(lua_State* L, bool synced)
{
	const int args = lua_gettop(L);
	if ((args < 1) || !lua_isstring(L, 1) ||
	    ((args >= 2) && !lua_istable(L, 2) && !lua_isnil(L, 2))) {
		luaL_error(L, "Incorrect arguments to Include()");
	}

	const string filename = lua_tostring(L, 1);
	if (!LuaIO::IsSimplePath(filename)) {
//FIXME		return 0;
	}

	const string modes = GetModes(L, 3, synced);

	string code;
	if (!LoadFileWithModes(filename, code, modes)) {
		char buf[1024];
		SNPRINTF(buf, sizeof(buf),
		         "Include() could not load '%s'", filename.c_str());
		lua_pushstring(L, buf);
 		lua_error(L);
	}

	int error = luaL_loadbuffer(L, code.c_str(), code.size(), filename.c_str());
	if (error != 0) {
		char buf[1024];
		SNPRINTF(buf, sizeof(buf), "error = %i, %s, %s",
		         error, filename.c_str(), lua_tostring(L, -1));
		lua_pushstring(L, buf);
		lua_error(L);
	}

	// set the chunk's fenv to the current fenv, or a user table
	if ((args >= 2) && lua_istable(L, 2)) {
		lua_pushvalue(L, 2); // user fenv
	} else {
		LuaUtils::PushCurrentFuncEnv(L, __FUNCTION__);
	}

	// set the include fenv to the current function's fenv
	if (lua_setfenv(L, -2) == 0) {
		luaL_error(L, "Include(): error with setfenv");
	}

	const int paramTop = lua_gettop(L) - 1;

	error = lua_pcall(L, 0, LUA_MULTRET, 0);

	if (error != 0) {
		char buf[1024];
		SNPRINTF(buf, sizeof(buf), "error = %i, %s, %s",
		         error, filename.c_str(), lua_tostring(L, -1));
		lua_pushstring(L, buf);
		lua_error(L);
	}

	// FIXME -- adjust stack?

	return lua_gettop(L) - paramTop;
}


int LuaVFS::SyncInclude(lua_State* L)
{
	return Include(L, true);
}


int LuaVFS::UnsyncInclude(lua_State* L)
{
	return Include(L, false);
}


/******************************************************************************/

int LuaVFS::LoadFile(lua_State* L, bool synced)
{
	const int args = lua_gettop(L); // number of arguments
	if ((args < 1) || !lua_isstring(L, 1)) {
		luaL_error(L, "Incorrect arguments to LoadFile()");
	}

	const string filename = lua_tostring(L, 1);
	if (!LuaIO::IsSimplePath(filename)) {
//FIXME		return 0;
	}

	const string modes = GetModes(L, 2, synced);

	string data;
	if (LoadFileWithModes(filename, data, modes)) {
		lua_pushlstring(L, data.c_str(), data.size());
		return 1;
	}
	return 0;
}


int LuaVFS::SyncLoadFile(lua_State* L)
{
	return LoadFile(L, true);
}


int LuaVFS::UnsyncLoadFile(lua_State* L)
{
	return LoadFile(L, false);
}


/******************************************************************************/

int LuaVFS::FileExists(lua_State* L, bool synced)
{
	const int args = lua_gettop(L); // number of arguments
	if ((args < 1) || !lua_isstring(L, 1)) {
		luaL_error(L, "Incorrect arguments to FileExists()");
	}

	const string filename = lua_tostring(L, 1);
	if (!LuaIO::IsSimplePath(filename)) {
//FIXME		return 0;
	}

	const string modes = GetModes(L, 2, synced);

	CFileHandler fh(filename, modes);
	lua_pushboolean(L, fh.FileExists());
	return 1;
}


int LuaVFS::SyncFileExists(lua_State* L)
{
	return FileExists(L, true);
}


int LuaVFS::UnsyncFileExists(lua_State* L)
{
	return FileExists(L, false);
}


/******************************************************************************/

int LuaVFS::DirList(lua_State* L, bool synced)
{
	const int args = lua_gettop(L); // number of arguments
	if ((args < 1) || !lua_isstring(L, 1) ||
	    ((args >= 2) && !lua_isstring(L, 2))) {
		luaL_error(L, "Incorrect arguments to DirList()");
	}

	const string dir = lua_tostring(L, 1);
	// keep searches within the Spring directory
	if (!LuaIO::IsSimplePath(dir)) {
//FIXME		return 0;
	}
	const string pattern = luaL_optstring(L, 2, "*");
	const string modes = GetModes(L, 3, synced);

	LuaUtils::PushStringVector(L, CFileHandler::DirList(dir, pattern, modes));
	return 1;
}


int LuaVFS::SyncDirList(lua_State* L)
{
	return DirList(L, true);
}


int LuaVFS::UnsyncDirList(lua_State* L)
{
	return DirList(L, false);
}


/******************************************************************************/

int LuaVFS::SubDirs(lua_State* L, bool synced)
{
	const int args = lua_gettop(L); // number of arguments
	if ((args < 1) || !lua_isstring(L, 1) ||
	    ((args >= 2) && !lua_isstring(L, 2)) ||
	    ((args >= 4) && !lua_isstring(L, 4))) {
		luaL_error(L, "Incorrect arguments to SubDirs()");
	}

	const string dir = lua_tostring(L, 1);
	// keep searches within the Spring directory
	if (!LuaIO::IsSimplePath(dir)) {
//FIXME		return 0;
	}
	const string pattern = luaL_optstring(L, 2, "*");
	const string modes = GetModes(L, 3, synced);

	LuaUtils::PushStringVector(L, CFileHandler::SubDirs(dir, pattern, modes));
	return 1;
}


int LuaVFS::SyncSubDirs(lua_State* L)
{
	return SubDirs(L, true);
}


int LuaVFS::UnsyncSubDirs(lua_State* L)
{
	return SubDirs(L, false);
}


/******************************************************************************/
/******************************************************************************/

int LuaVFS::UseArchive(lua_State* L)
{
	const string filename = luaL_checkstring(L, 1);
	if (!LuaIO::IsSimplePath(filename)) {
		//FIXME		return 0;
	}

	int funcIndex = 2;
	if (CLuaHandle::GetActiveHandle()->GetSynced()) {
		return 0;
	}

	if (!lua_isfunction(L, funcIndex)) {
		return 0;
	}

	string fileData;
	CFileHandler f(filename, SPRING_VFS_RAW);
	if (!f.FileExists()) {
		return 0;
	}

	CVFSHandler* oldHandler = vfsHandler;
	vfsHandler = new CVFSHandler;
	vfsHandler->AddArchive(filename, false);

	const int error = lua_pcall(L, lua_gettop(L) - funcIndex, LUA_MULTRET, 0);

	delete vfsHandler;
	vfsHandler = oldHandler;

	if (error != 0) {
		lua_error(L);
	}

	return lua_gettop(L) - funcIndex + 1;
}

int LuaVFS::MapArchive(lua_State* L)
{
	if (CLuaHandle::GetActiveHandle()->GetSynced()) // only from unsynced
	{
		return 0;
	}

	const int args = lua_gettop(L); // number of arguments
	const string filename = archiveScanner->ArchiveFromName(luaL_checkstring(L, 1));
	if (!LuaIO::IsSimplePath(filename))
	{
		//FIXME		return 0;
	}

	CFileHandler f(filename, SPRING_VFS_RAW);
	if (!f.FileExists())
	{
		std::ostringstream buf;
		buf << "Achive not found: " << filename;
		lua_pushboolean(L, false);
		lua_pushstring(L, buf.str().c_str());
		return 0;
	}

	if (args >= 2)
	{
		const std::string checksumBuf = lua_tostring(L, 2);
		int checksum = 0;
		std::istringstream buf(checksumBuf);
		buf >> checksum;
		const int realchecksum = archiveScanner->GetSingleArchiveChecksum(filename);
		if (checksum != realchecksum)
		{
			std::ostringstream buf;
			buf << "Bad archive checksum, got: " << realchecksum << " expected: " << checksum;
			lua_pushboolean(L, false);
			lua_pushstring(L, buf.str().c_str());
			return 0;
		}
	}
	if (!vfsHandler->AddArchive(filename, false))
	{
		std::ostringstream buf;
		buf << "Failed to load archive: " << filename;
		lua_pushboolean(L, false);
		lua_pushstring(L, buf.str().c_str());
	}
	else
	{
		lua_pushboolean(L, true);
	}
	return 0;
}

/******************************************************************************/
/******************************************************************************/
//
//  Zlib compression
//

int LuaVFS::ZlibCompress(lua_State* L)
{
	return LuaUtils::ZlibCompress(L);
}

int LuaVFS::ZlibDecompress(lua_State* L)
{
	return LuaUtils::ZlibDecompress(L);
}

// Muratet (Bontemps) ---
/******************************************************************************/
/******************************************************************************/
//
//  Build PP functions
//

int LuaVFS::BuildPPEditor(lua_State* L) {
	// Get LUA args
	const string game = luaL_checkstring(L, 1);
	
	// Prepare file
	const string modinfo = "return { game='SPRED', shortGame='SPRED', name='SPRED for " + game + "', shortName='SPRED', mutator='official', version='1.0', description='SPRED Editor.', url='http://www.irit.fr/ProgAndPlay/index_en.php', modtype=1, depend= { \"" + game + "\" },}";
	const string editorName = "mods/SPRED for " + game + ".sdz";
	
	// Locate launcher zip
	const string launcherPath = filesystem.LocateFile("mods/SPRED.sdz");
	
	// Open launcher zip
	unzFile launcherZip = unzOpen(launcherPath.c_str());
	if (launcherZip == NULL) { luaL_error(L, "Couldn't load SPRED.sdz"); return 0; }
	
	// Open editor zip file
	if (UNZ_OK != unzLocateFile(launcherZip, "editor.sdz", 2)) { luaL_error(L, "Couldn't find editor.sdz"); return 0; }
	if (UNZ_OK != unzOpenCurrentFile(launcherZip)) { luaL_error(L, "Couldn't open editor.sdz"); return 0; }
	
	// Extract editor zip
	const int sizeBuffer = 32768;
	char* buffer = new char[sizeBuffer];
	::memset(buffer, 0, sizeBuffer);
	std::ofstream outfile(editorName.c_str(), std::ofstream::binary);
	while(unzReadCurrentFile(launcherZip, buffer, sizeBuffer) > 0) {
		outfile.write(buffer, sizeBuffer);
	}
	if (buffer) {
		delete[] buffer;
		buffer = NULL;
	}
	
	// Close editor zip file
	unzCloseCurrentFile(launcherZip);
	
	// Close launcher zip
	unzClose(launcherZip);
	
	// Initialize file information (to prevent bugs)
	zip_fileinfo* zipfi = new zip_fileinfo();
	zipfi->dosDate = 0;
	zipfi->tmz_date.tm_year = 2016;
	zipfi->tmz_date.tm_mon = 5;
	zipfi->tmz_date.tm_mday = 30;
	zipfi->tmz_date.tm_hour = 10;
	zipfi->tmz_date.tm_min = 30;
	zipfi->tmz_date.tm_sec = 24;
	
	// Locate editor zip
	const string editorPath = filesystem.LocateFile(editorName.c_str());
	
	// Open editor zip
	zipFile editorZip = zipOpen(editorPath.c_str(), APPEND_STATUS_ADDINZIP); // Warning : if the zip file is empty, returns NULL
	if (editorZip == NULL) { luaL_error(L, "Couldn't load extracted archive"); return 0; }
	
	// Write file
	zipOpenNewFileInZip(editorZip, "ModInfo.lua", zipfi, NULL, 0, NULL, 0, NULL, Z_DEFLATED, Z_BEST_COMPRESSION);
	zipWriteInFileInZip(editorZip, modinfo.c_str(), modinfo.length());
	zipCloseFileInZip(editorZip);
	
	// Close editor zip
	zipClose(editorZip, NULL);
	
	return 0;
}

int LuaVFS::BuildPPGame(lua_State* L) {
	// Get LUA args
	const string name = luaL_checkstring(L, 1);
	const string desc = luaL_checkstring(L, 2);
	const string scenarioFileName = luaL_checkstring(L, 3);
	const string gameName = luaL_checkstring(L, 4);
	const string game = luaL_checkstring(L, 5);
	vector<string> levelList;
	for (lua_pushnil(L) ; lua_next(L, 6) != 0 ; lua_pop(L, 1)) {
		levelList.push_back(luaL_checkstring(L, -1));
	}
	vector<string> tracesList;
	for (lua_pushnil(L) ; lua_next(L, 7) != 0 ; lua_pop(L, 1)) {
		tracesList.push_back(luaL_checkstring(L, -1));
	}
	
	// Prepare file
	const string modinfo = "return { game='SPRED', shortGame='SPRED', name='" + name + "', shortName='SPRED', mutator='official', version='1.0', description='" + desc + "', url='http://www.irit.fr/ProgAndPlay/index_en.php', modtype=1, depend= { \"" + game + "\" },}";
	const string gameFileName = "mods/" + gameName + ".sdz";
	
	// Locate launcher zip
	const string launcherPath = filesystem.LocateFile("mods/SPRED.sdz");
	
	// Open launcher zip
	unzFile launcherZip = unzOpen(launcherPath.c_str());
	if (launcherZip == NULL) { luaL_error(L, "Couldn't load SPRED.sdz"); return 0; }
	
	// Open game zip file
	if (UNZ_OK != unzLocateFile(launcherZip, "game.sdz", 2)) { luaL_error(L, "Couldn't find game.sdz"); return 0; }
	if (UNZ_OK != unzOpenCurrentFile(launcherZip)) { luaL_error(L, "Couldn't open game.sdz"); return 0; }
	
	// Extract game zip
	const int sizeBuffer = 32768;
	char* buffer = new char[sizeBuffer];
	::memset(buffer, 0, sizeBuffer);
	std::ofstream outfile(gameFileName.c_str(), std::ofstream::binary);
	while(unzReadCurrentFile(launcherZip, buffer, sizeBuffer) > 0) {
		outfile.write(buffer, sizeBuffer);
	}
	if (buffer) {
		delete[] buffer;
		buffer = NULL;
	}
	
	// Close game zip file
	unzCloseCurrentFile(launcherZip);
	
	// Close launcher zip
	unzClose(launcherZip);
	
	// Initialize file information (to prevent bugs)
	zip_fileinfo* zipfi = new zip_fileinfo();
	zipfi->dosDate = 0;
	zipfi->tmz_date.tm_year = 2016;
	zipfi->tmz_date.tm_mon = 5;
	zipfi->tmz_date.tm_mday = 30;
	zipfi->tmz_date.tm_hour = 10;
	zipfi->tmz_date.tm_min = 30;
	zipfi->tmz_date.tm_sec = 24;
	
	// Locate game zip
	const string gamePath = filesystem.LocateFile(gameFileName.c_str());
	
	// Open game zip
	zipFile gameZip = zipOpen(gamePath.c_str(), APPEND_STATUS_ADDINZIP);
	if (gameZip == NULL) { luaL_error(L, "Couldn't load extracted archive"); return 0; }
	
	// Write files
	// ModInfo
	zipOpenNewFileInZip(gameZip, "ModInfo.lua", zipfi, NULL, 0, NULL, 0, NULL, Z_DEFLATED, Z_BEST_COMPRESSION);
	zipWriteInFileInZip(gameZip, modinfo.c_str(), modinfo.length());
	zipCloseFileInZip(gameZip);
	// Scenario
	const string scenarioPath = "SPRED/scenarios/" + scenarioFileName + ".xml";
	ifstream scenarioFile(scenarioPath.c_str());
	string scenarioString((istreambuf_iterator<char>(scenarioFile)), istreambuf_iterator<char>());
	zipOpenNewFileInZip(gameZip, "scenario/scenario.xml", zipfi, NULL, 0, NULL, 0, NULL, Z_DEFLATED, Z_BEST_COMPRESSION);
	zipWriteInFileInZip(gameZip, scenarioString.c_str(), scenarioString.length());
	zipCloseFileInZip(gameZip);
	// Missions
	for (int i = 0 ; i < levelList.size() ; i++) {
		const string levelPath = "SPRED/missions/" + levelList[i] + ".editor";
		ifstream levelFile(levelPath.c_str());
		string levelString((istreambuf_iterator<char>(levelFile)), istreambuf_iterator<char>());
		const string levelZipPath = "Missions/" + levelList[i] + ".editor";
		zipOpenNewFileInZip(gameZip, levelZipPath.c_str(), zipfi, NULL, 0, NULL, 0, NULL, Z_DEFLATED, Z_BEST_COMPRESSION);
		zipWriteInFileInZip(gameZip, levelString.c_str(), levelString.length());
		zipCloseFileInZip(gameZip);
	}
	// Traces
	for (int i = 0 ; i < tracesList.size() ; i++) {
		vector<string> trace;
		boost::split(trace, tracesList[i], boost::is_any_of(","));
		// Traces
		const string tracePath = "traces/data/expert/" + trace[0] + "/" + trace[1] + ".xml";
		ifstream traceFile(tracePath.c_str());
		string traceString((istreambuf_iterator<char>(traceFile)), istreambuf_iterator<char>());
		const string traceZipPath = "traces/expert/" + trace[0] + "/" + trace[1] + ".xml";
		zipOpenNewFileInZip(gameZip, traceZipPath.c_str(), zipfi, NULL, 0, NULL, 0, NULL, Z_DEFLATED, Z_BEST_COMPRESSION);
		zipWriteInFileInZip(gameZip, traceString.c_str(), traceString.length());
		zipCloseFileInZip(gameZip);
		// Log
		const string logPath = "traces/data/expert/" + trace[0] + "/" + trace[1] + ".log";
		ifstream logFile(logPath.c_str());
		string logString((istreambuf_iterator<char>(logFile)), istreambuf_iterator<char>());
		const string logZipPath = "traces/expert/" + trace[0] + "/" + trace[1] + ".log";
		zipOpenNewFileInZip(gameZip, logZipPath.c_str(), zipfi, NULL, 0, NULL, 0, NULL, Z_DEFLATED, Z_BEST_COMPRESSION);
		zipWriteInFileInZip(gameZip, logString.c_str(), logString.length());
		zipCloseFileInZip(gameZip);
		// Feedbacks
		const string fbPath = "traces/data/expert/" + trace[0] + "/feedbacks.xml";
		ifstream fbFile(fbPath.c_str());
		string fbString((istreambuf_iterator<char>(fbFile)), istreambuf_iterator<char>());
		const string fbZipPath = "traces/expert/" + trace[0] + "/feedbacks.xml";
		zipOpenNewFileInZip(gameZip, fbZipPath.c_str(), zipfi, NULL, 0, NULL, 0, NULL, Z_DEFLATED, Z_BEST_COMPRESSION);
		zipWriteInFileInZip(gameZip, fbString.c_str(), fbString.length());
		zipCloseFileInZip(gameZip);
	}
	
	// Close game zip
	zipClose(gameZip, NULL);
	
	return 0;
}

/******************************************************************************/
/******************************************************************************/
//
//  Getter functions
//

int LuaVFS::GetGames(lua_State* L) {
	vector<CArchiveScanner::ArchiveData> list = archiveScanner->GetPrimaryMods();
	lua_newtable(L);
	for (int i = 0 ; i < list.size() ; i++) {
		lua_pushnumber(L, i+1);
		lua_pushstring(L, (list[i].name).c_str());
		lua_rawset(L, -3);
	}
	return 1;
}

int LuaVFS::GetMaps(lua_State* L) {
	vector<string> list = archiveScanner->GetMaps();
	lua_newtable(L);
	for (int i = 0 ; i < list.size() ; i++) {
		lua_pushnumber(L, i+1);
		lua_pushstring(L, (list[i]).c_str());
		lua_rawset(L, -3);
	}
	return 1;
}

int LuaVFS::GetArchiveDependencies(lua_State* L) {
	const std::string archiveName = luaL_checkstring(L, 1);
	CArchiveScanner::ArchiveData archiveData = archiveScanner->GetArchiveData(archiveName);
	const std::vector<std::string>& dependencies = archiveData.dependencies;
	lua_createtable(L, dependencies.size(), 0);
	for (int i = 0 ; i < dependencies.size() ; i++) {
		lua_pushnumber(L, i+1);
		lua_pushstring(L, dependencies[i].c_str());
		lua_rawset(L, -3);
	}
	return 1;
}

int LuaVFS::GetArchiveInfo(lua_State* L) {
	const std::string archiveName = luaL_checkstring(L, 1);
	CArchiveScanner::ArchiveData archiveData = archiveScanner->GetArchiveData(archiveName);
	lua_createtable(L, 0, 9);
	
	lua_pushstring(L, "name");
	lua_pushstring(L, archiveData.name.c_str());
	lua_rawset(L, -3);
	lua_pushstring(L, "shortname");
	lua_pushstring(L, archiveData.shortName.c_str());
	lua_rawset(L, -3);
	lua_pushstring(L, "version");
	lua_pushstring(L, archiveData.version.c_str());
	lua_rawset(L, -3);
	lua_pushstring(L, "mutator");
	lua_pushstring(L, archiveData.mutator.c_str());
	lua_rawset(L, -3);
	lua_pushstring(L, "game");
	lua_pushstring(L, archiveData.game.c_str());
	lua_rawset(L, -3);
	lua_pushstring(L, "shortgame");
	lua_pushstring(L, archiveData.shortGame.c_str());
	lua_rawset(L, -3);
	lua_pushstring(L, "description");
	lua_pushstring(L, archiveData.description.c_str());
	lua_rawset(L, -3);
	lua_pushstring(L, "mapfile");
	lua_pushstring(L, archiveData.mapfile.c_str());
	lua_rawset(L, -3);
	lua_pushstring(L, "modtype");
	lua_pushnumber(L, archiveData.modType);
	lua_rawset(L, -3);

	return 1;
}

// ---

/******************************************************************************/
/******************************************************************************/
//
//  NOTE: Endianess should be handled
//

template <typename T>
int PackType(lua_State* L)
{
	vector<T> vals;

	if (lua_istable(L, 1)) {
		for (int i = 1;
		     lua_rawgeti(L, 1, i), lua_isnumber(L, -1);
		     lua_pop(L, 1), i++) {
			vals.push_back((T)lua_tonumber(L, -1));
		}
	}
	else {
		const int args = lua_gettop(L);
		for (int i = 1; i <= args; i++) {
			if (!lua_isnumber(L, i)) {
				break;
			}
			vals.push_back((T)lua_tonumber(L, i));
		}
	}

	if (vals.empty()) {
		return 0;
	}

	const int bufSize = sizeof(T) * vals.size();
	char* buf = new char[bufSize];
	for (int i = 0; i < (int)vals.size(); i++) {
		memcpy(buf + (i * sizeof(T)), &vals[i], sizeof(T));
	}
	lua_pushlstring(L, buf, bufSize);
	delete[] buf;

	return 1;
}


int LuaVFS::PackU8(lua_State*  L) { return PackType<boost::uint8_t>(L);  }
int LuaVFS::PackU16(lua_State* L) { return PackType<boost::uint16_t>(L); }
int LuaVFS::PackU32(lua_State* L) { return PackType<boost::uint32_t>(L); }
int LuaVFS::PackS8(lua_State*  L) { return PackType<boost::int8_t>(L);   }
int LuaVFS::PackS16(lua_State* L) { return PackType<boost::int16_t>(L);  }
int LuaVFS::PackS32(lua_State* L) { return PackType<boost::int32_t>(L);  }
int LuaVFS::PackF32(lua_State* L) { return PackType<float>(L);           }


/******************************************************************************/

template <typename T>
int UnpackType(lua_State* L)
{
	if (!lua_isstring(L, 1)) {
		return 0;
	}
	size_t len;
	const char* str = lua_tolstring(L, 1, &len);

	if (lua_isnumber(L, 2)) {
		const int pos = lua_toint(L, 2);
		if ((pos < 1) || ((size_t)pos >= len)) {
			return 0;
		}
		const int offset = (pos - 1);
		str += offset;
		len -= offset;
	}

	const size_t eSize = sizeof(T);
	if (len < eSize) {
		return 0;
	}

	if (!lua_isnumber(L, 3)) {
		const T value = *((T*)str);
		lua_pushnumber(L, value);
		return 1;
	}
	else {
		const size_t maxCount = (len / eSize);
		int tableCount = lua_toint(L, 3);
		if (tableCount < 0) {
			tableCount = maxCount;
		}
		tableCount = min((int)maxCount, tableCount);
		lua_newtable(L);
		for (int i = 0; i < tableCount; i++) {
			const T value = *(((T*)str) + i);
			lua_pushnumber(L, value);
			lua_rawseti(L, -2, (i + 1));
		}
		lua_pushstring(L, "n");
		lua_pushnumber(L, tableCount);
		lua_rawset(L, -3);
		return 1;
	}

	return 0;
}


int LuaVFS::UnpackU8(lua_State*  L) { return UnpackType<boost::uint8_t>(L);  }
int LuaVFS::UnpackU16(lua_State* L) { return UnpackType<boost::uint16_t>(L); }
int LuaVFS::UnpackU32(lua_State* L) { return UnpackType<boost::uint32_t>(L); }
int LuaVFS::UnpackS8(lua_State*  L) { return UnpackType<boost::int8_t>(L);   }
int LuaVFS::UnpackS16(lua_State* L) { return UnpackType<boost::int16_t>(L);  }
int LuaVFS::UnpackS32(lua_State* L) { return UnpackType<boost::int32_t>(L);  }
int LuaVFS::UnpackF32(lua_State* L) { return UnpackType<float>(L);           }


/******************************************************************************/
/******************************************************************************/

