/* This file is part of the Spring engine (GPL v2 or later), see LICENSE.html */

// Muratet (Implement class CProgAndPlay) ---

#include "StdAfx.h"
#include "mmgr.h"

#include "ProgAndPlay.h"
#include "lib/pp/PP_Supplier.h"
#include "lib/pp/PP_Error.h"
#include "lib/pp/PP_Error_Private.h"

#include "System/NetProtocol.h"
#include "Game/Game.h"
#include "Game/GameSetup.h"
#include "Sim/Misc/GlobalConstants.h" // needed for MAX_UNITS
#include "Sim/Misc/TeamHandler.h"
#include "Sim/Misc/LosHandler.h"
#include "Sim/Features/FeatureHandler.h"
#include "Sim/Features/FeatureSet.h"
#include "Sim/Units/Groups/GroupHandler.h"
#include "Sim/Units/Groups/Group.h"
#include "Sim/Units/CommandAI/Command.h"
#include "Sim/Units/CommandAI/CommandAI.h"
#include "Sim/Units/CommandAI/FactoryCAI.h"
#include "FileSystem/FileHandler.h"
#include "FileSystem/FileSystem.h"
#include "FileSystem/FileSystemHandler.h"
#include "GlobalUnsynced.h"
#include "LogOutput.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <fstream>
#include <sstream>
#include <iostream>
#include <map>
#include <ctime>

const std::string tracesDirname = "traces";
std::ofstream logFile("log.txt", std::ios::out | std::ofstream::trunc);
std::ofstream ppTraces;

void log(std::string msg){
	logFile << msg << std::endl;
	logOutput.Print(msg.c_str());
}

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CProgAndPlay* pp;

CProgAndPlay::CProgAndPlay() {
	log("ProgAndPLay constructor begin");
	
	loaded = false;
	updated = false;
	missionEnded = false;
	
	// initialisation of Prog&Play
	if (PP_Init(tracePlayer) == -1) {
		std::string tmp(PP_GetError());
		log(tmp.c_str());
	}
	else{
		log("Prog&Play initialized");
		loaded = true;
	}
	
	// delete mission_ended.conf file if it exists => this file could be created
	// by mods if lua mission is ended.
	CFileHandler * tmpFile = new CFileHandler("mission_ended.conf");
	bool del = tmpFile->FileExists();
	// free CFileHandler before deleting the file, otherwise it is blocking on Windows
	delete tmpFile;
	if (del)
		FileSystemHandler::DeleteFile(filesystem.LocateFile("mission_ended.conf"));
		
	openTracesFile();
	
	log("ProgAndPLay constructor end");
}

CProgAndPlay::~CProgAndPlay() {
  log("ProgAndPLay destructor begin");
  if (loaded){
	if (PP_Quit() == -1){
		std::string tmp(PP_GetError());
		log(tmp.c_str());
	}
	else
		log("Prog&Play shut down and cleaned up");
  }
  logFile.close();
  if (ppTraces.is_open())
	ppTraces.close();
  log("ProgAndPLay destructor end");
}

void CProgAndPlay::Update(void) {
	log("ProgAndPLay::Update begin");
		
	// Store log messages
	if (ppTraces.is_open())
		logMessages();
	
	// Execute pending commands
	int nbCmd = execPendingCommands();
	if (nbCmd == -1){
		std::string tmp(PP_GetError());
		log(tmp.c_str());
	}
	// Limit update if commands was executed or every 4 frames
	if (updatePP() == -1){
		std::string tmp(PP_GetError());
		log(tmp.c_str());
	}
		
	log("ProgAndPLay::Update end");
}

void CProgAndPlay::GamePaused(bool paused) {
	int ret = PP_SetGamePaused(paused);
	if (ppTraces.is_open()) {
		if (paused)
			ppTraces << "game_paused" << std::endl;
		else
			ppTraces << "game_unpaused" << std::endl;
	}
	if (ret == -1)
		return;
}

PP_ShortUnit buildShortUnit(CUnit *unit, PP_Coalition c){
log("ProgAndPLay::buildShortUnit begin");
	PP_ShortUnit tmpUnit;
	tmpUnit.id = unit->id;
	tmpUnit.coalition = c;
	if (unit->unitDef)
		tmpUnit.type = unit->unitDef->id;
	else
		tmpUnit.type = -1;
	tmpUnit.pos.x = unit->midPos.x;
	tmpUnit.pos.y = unit->midPos.z;
	tmpUnit.health = unit->health;
	tmpUnit.maxHealth = unit->maxHealth;
	// write command queue and group
	if (c != ENEMY_COALITION){
		if (unit->group)
			tmpUnit.group = unit->group->id;
		else
			tmpUnit.group = -1;
		std::vector<PP_Command> tmpCommandQueue;
		const CCommandAI* commandAI = unit->commandAI;
		if (commandAI != NULL) {
			const CCommandQueue* queue;
			queue = &commandAI->commandQue;
			CCommandQueue::const_iterator it;
			for (it = queue->begin(); it != queue->end(); it++) {
				if (it->id != CMD_SET_WANTED_MAX_SPEED){
					PP_Command tmpCmd;
					tmpCmd.code = it->id;
					tmpCmd.nbParam = it->params.size();
					tmpCmd.param = (float*)malloc(tmpCmd.nbParam*sizeof(float));
					if (tmpCmd.param != NULL){
						for (int i = 0 ; i < tmpCmd.nbParam ; i++){
							tmpCmd.param[i] = it->params.at(i);
						}
					}
					else
						tmpCmd.nbParam = 0;
					tmpCommandQueue.push_back(tmpCmd);
				}
			}
		}
		tmpUnit.commandQueue =
			(PP_Command*)malloc(tmpCommandQueue.size()*sizeof(PP_Command));
		if (tmpUnit.commandQueue != NULL){
			tmpUnit.nbCommandQueue = tmpCommandQueue.size();
			for (int i = 0 ; i < tmpUnit.nbCommandQueue ; i++)
				tmpUnit.commandQueue[i] = tmpCommandQueue.at(i);
		}
		else
			tmpUnit.nbCommandQueue = 0;
	}
	else{
		tmpUnit.group = -1;
		tmpUnit.commandQueue = NULL;
		tmpUnit.nbCommandQueue = 0;
	}
	
log("ProgAndPLay::buildShortUnit end");
	return tmpUnit;
}

void freeShortUnit (PP_ShortUnit unit){
log("ProgAndPLay::freeShortUnit begin");
	if (unit.commandQueue != NULL){
		for (int i = 0 ; i < unit.nbCommandQueue ; i++){
			if (unit.commandQueue[i].param != NULL)
				free(unit.commandQueue[i].param);
		}
		free (unit.commandQueue);
		unit.commandQueue = NULL;
		unit.nbCommandQueue = 0;
	}
log("ProgAndPLay::freeShortUnit end");
}

void doUpdate(CUnit* unit, PP_Coalition c){
std::stringstream str;
str << "ProgAndPLay::doUpdate begin : " << unit->id;
log(str.str());
	PP_ShortUnit shortUnit = buildShortUnit(unit, c);
	if (PP_UpdateUnit(shortUnit) == -1){
		std::string tmp(PP_GetError());
		log(tmp.c_str());
	}
	freeShortUnit(shortUnit);
log("ProgAndPLay::doUpdate end");
}

void doAdding(CUnit* unit, PP_Coalition c){
std::stringstream str;
str << "ProgAndPLay::doAdding begin : " << unit->id;
log(str.str());
	PP_ShortUnit shortUnit = buildShortUnit(unit, c);
	if (PP_AddUnit(shortUnit) == -1){
		std::string tmp(PP_GetError());
		log(tmp.c_str());
	}
	freeShortUnit(shortUnit);
log("ProgAndPLay::doAdding end");
}

void doRemoving (int unitId){
std::stringstream ss;
ss << "ProgAndPLay::doRemoving begin : " << unitId;
log(ss.str());
	if (PP_RemoveUnit(unitId) == -1){
		std::string tmp(PP_GetError());
		log(tmp.c_str());
	}
log("ProgAndPLay::doRemoving end");
}

void CProgAndPlay::AddUnit(CUnit* unit){
	log("ProgAndPLay::AddUnit begin");
	PP_Coalition c;
	if (unit->team == gu->myTeam)
		c = MY_COALITION;
	else if (teamHandler->AlliedTeams(unit->team, gu->myTeam))
		c = ALLY_COALITION;
	else 
		c = ENEMY_COALITION;
	if (c != ENEMY_COALITION || loshandler->InLos(unit, gu->myAllyTeam)){
		doAdding(unit, c);
	}
	log("ProgAndPLay::AddUnit end");
}

void CProgAndPlay::UpdateUnit(CUnit* unit){
log("ProgAndPLay::UpdateUnit begin");
	PP_Coalition c;
	if (unit->team == gu->myTeam)
		c = MY_COALITION;
	else if (teamHandler->AlliedTeams(unit->team, gu->myTeam))
		c = ALLY_COALITION;
	else 
		c = ENEMY_COALITION;
	if (c != ENEMY_COALITION){
		doUpdate(unit, c);
	}
	else {
		int isStored = PP_IsStored(unit->id);
		if (isStored == -1){
			std::string tmp(PP_GetError());
			log(tmp.c_str());
		}
		else {
			if (loshandler->InLos(unit, gu->myAllyTeam)){
				if (isStored){
					doUpdate(unit, c);
				}
				else{
					doAdding(unit, c);
				}
			}
			else {
				if (isStored){
					doRemoving(unit->id);
				}
			}
		}
	}
log("ProgAndPLay::UpdateUnit end");
}

void CProgAndPlay::RemoveUnit(CUnit* unit){
log("ProgAndPLay::RemoveUnit begin");
	doRemoving(unit->id);
log("ProgAndPLay::RemoveUnit end");
}

int CProgAndPlay::updatePP(void){
log("ProgAndPLay::updatePP begin");
	if (!updated) {
		updated = true;
		// store map size
		PP_Pos mapSize;
		mapSize.x = gs->mapx*SQUARE_SIZE;
		mapSize.y = gs->mapy*SQUARE_SIZE;
		// store starting position
		PP_Pos startPos;
		startPos.x = teamHandler->Team(gu->myTeam)->startPos.x;
		startPos.y = teamHandler->Team(gu->myTeam)->startPos.z;
		// store all geothermals
		PP_Positions specialAreas;
		specialAreas.size = 0;
		specialAreas.pos = NULL;
		if (featureHandler){
			CFeatureSet fset = featureHandler->GetActiveFeatures();
			if (fset.size() > 0){
				specialAreas.pos = (PP_Pos*) malloc(fset.size()*sizeof(PP_Pos));
				if (specialAreas.pos == NULL){
					PP_SetError("Spring : specialAres allocation error");
					return -1;
				}
				CFeatureSet::const_iterator fIt;
				for (fIt = fset.begin() ; fIt != fset.end(); ++fIt){
					if (!(*fIt)->def) continue;
					if ((*fIt)->def->geoThermal){
						specialAreas.pos[specialAreas.size].x = (*fIt)->pos.x;
						specialAreas.pos[specialAreas.size].y = (*fIt)->pos.z;
						specialAreas.size++;
					}
				}
				PP_Pos *tmp = (PP_Pos*)
					realloc(specialAreas.pos, specialAreas.size*sizeof(PP_Pos));
				if (tmp == NULL){
					PP_SetError("Spring : specialAres reallocation error");
					free(specialAreas.pos);
					specialAreas.size = 0;
					specialAreas.pos = NULL;
					return -1;
				}
				else
					specialAreas.pos = tmp;
			}
		}
		int ret = PP_SetStaticData(mapSize, startPos, specialAreas);
		free(specialAreas.pos);
		if (ret == -1)
			return -1;
	}
	
	// store resources
	PP_Resources resources;
	resources.size = 2;
	resources.resource = (int*) malloc(sizeof(int)*2);
	if (resources.resource == NULL){
		PP_SetError("Spring : Ressources allocation error");
		return -1;
	}
	resources.resource[0] = teamHandler->Team(gu->myTeam)->metal;
	resources.resource[1] = teamHandler->Team(gu->myTeam)->energy;
	int ret = PP_SetRessources(resources);
	free(resources.resource);
	if (ret == -1)
		return -1;
	
	// set game over. This depends on engine state (game->gameOver) and/or
	// missions state (tmpFile->FileExists() => this file is created by mod if 
	// lua mission is ended)
	CFileHandler * tmpFile = new CFileHandler("mission_ended.conf");
	ret = PP_SetGameOver(game->gameOver || tmpFile->FileExists());
	delete tmpFile;
	if (ret == -1)
		return -1;

log("ProgAndPLay::updatePP end");
	return 0;
}

int CProgAndPlay::execPendingCommands(){
log("ProgAndPLay::execPendingCommands begin");
	int nbCmd = 0;
	PP_PendingCommands* pendingCommands = PP_GetPendingCommands();
	if (pendingCommands == NULL) return -1;
	else{
		nbCmd = pendingCommands->size;
		for (int i = 0 ; i < pendingCommands->size ; i++){
			PP_PendingCommand pc = pendingCommands->pendingCommand[i];
			// Check for affecting group
			if (pc.group != -2){
				// Check if unit exists
				CUnit* tmp = uh->GetUnit(pc.unitId);
				if (tmp != NULL){
					if (tmp->team == gu->myTeam){
						// Check the grouphandlers for my team
						if (grouphandlers[gu->myTeam]){
							// Check if it's a command to withdraw unit from its current group
							if (pc.group == -1){
								// suppression de l'unité de sons groupe
								tmp->SetGroup(NULL);
							}
							else{
								// Check if the number of groups is being enough
								while (pc.group >= grouphandlers[gu->myTeam]->groups.size()){
									// add a new group
									grouphandlers[gu->myTeam]->CreateNewGroup();
								}
								// Check if the group exists
								if (!grouphandlers[gu->myTeam]->groups[pc.group]){
									// recreate all groups until recreate this group
									CGroup * gTmp;
									do {
										// création d'un groupe intermédiaire manquant
										gTmp = grouphandlers[gu->myTeam]->CreateNewGroup();
									}
									while (gTmp->id != pc.group);
								}
								if (pc.group >= 0){
									// devote the unit to this group
									tmp->SetGroup(grouphandlers[gu->myTeam]->groups[pc.group]);
								}
							}
						}
					}
				}
			}
			// Check if a command must be executed
			bool ok = true, found = false;
			switch (pc.commandType){
				case -1 : // the command is invalid => do not execute this command
					ok = false;
					break;
				case 0 : // the command target a position
					// indicates the y value
					pc.command.param[1] = 
						ground->GetHeight(pc.command.param[0], pc.command.param[2]);
					break;
				case 1 : // the command targets a unit
					// Find targeted unit
					for (int t = 0 ; t < teamHandler->ActiveTeams() && !found ; t++){
						CUnit* tmp = uh->GetUnit((int)pc.command.param[0]);
						if (tmp != NULL){
							if (tmp->team == t){
								// check if this unit is visible by the player
								if (!loshandler->InLos(tmp, gu->myAllyTeam))
									ok = false;
								found = true;
							}
						}
					}
					break;
				case 2 : // the command is untargeted
					// nothing to do
					break;
				default :
					PP_SetError("Spring : commandType unknown");
					PP_FreePendingCommands(pendingCommands);
					return -1;
			}
			// send command
			if (ok){
				if (pc.command.code == -7658){ // This code is a Prog&Play reserved code defined in constantList files
					// Clear CommandQueue of factory
					CUnit* fact = uh->GetUnit(pc.unitId);
					if (fact){
						CFactoryCAI* facAI = dynamic_cast<CFactoryCAI*>(fact->commandAI);
						if (facAI) {
							Command c;
							c.options = RIGHT_MOUSE_KEY; // Set RIGHT_MOUSE_KEY option in order to decrement building order
							CCommandQueue& buildCommands = facAI->commandQue;
							CCommandQueue::iterator it;
							std::vector<Command> clearCommands;
							clearCommands.reserve(buildCommands.size());
							for (it = buildCommands.begin(); it != buildCommands.end(); ++it) {
								c.id = it->id;
								clearCommands.push_back(c);
							}
							for (int i = 0; i < (int)clearCommands.size(); i++) {
								facAI->GiveCommand(clearCommands[i]);
							}
						}
					}
				} else{
					// Copy pc.command.param in a vector to pass it at SendAICommand
					std::vector<float> stdParam;
					for (int j = 0 ; j < pc.command.nbParam ; j++)
						stdParam.push_back(pc.command.param[j]);
					net->Send(CBaseNetProtocol::Get().SendAICommand(gu->myPlayerNum, pc.unitId,
						pc.command.code, 0, stdParam));
/*					// Permet de gérer les commandes plus correctement mais produit des
					// erreurs de synchronisation (à utiliser en SYNCED_MODE)
					CUnitSet *tmp = &(gs->Team(gu->myTeam)->units);
					CUnitSetConstIterator it = tmp->find(pc.unitId);
					if (it != tmp->end() && (*it)->commandAI){
						Command cTmp;
						cTmp.id = pc.command.code;
						cTmp.params = stdParam;
						(*it)->commandAI->GiveCommand(cTmp);
					}*/
				}
			}
		}
	}
	PP_FreePendingCommands(pendingCommands);
log("ProgAndPLay::execPendingCommands end");
	return nbCmd;
}

void CProgAndPlay::logMessages() {
	log("ProgAndPLay::logMessages begin");
	int i = 0;
	if (!missionEnded) {
		CFileHandler *tmpFile = new CFileHandler("mission_ended.conf");
		bool res = tmpFile->FileExists();
		// free CFileHandler before deleting the file, otherwise it is blocking on Windows
		delete tmpFile;
		if (res) {
			//mission ended
			std::ifstream ifs("mission_ended.conf");
			std::string val;
			getline(ifs, val);
			std::vector<std::string> elems = splitLine(val);
			if (elems.at(0).compare("won") == 0 || elems.at(0).compare("loss") == 0) {
				std::time_t result = std::time(NULL);
				ppTraces << "mission_end_time " << result << std::endl;
				ppTraces << "end " << elems.at(0) << " " << missionName << std::endl;
				i += 2;
				missionEnded = true;
			}
		}
	}
	// Get next message
	char * msg = PP_PopMessage();
	while (msg != NULL) {
		if (missionEnded)
			ppTraces << "delayed ";
		// Write this message on traces file
		ppTraces << msg << std::endl;
		// free memory storing this message
		delete[] msg;
		// Get next message
		msg = PP_PopMessage();
		i++;
	}
	if (i > 0) {
		std::stringstream ss;
		ss << "ProgAndPLay::logMessages end ("  << i << " messages logged)";
		log(ss.str());
	}
	else
		log("ProgAndPLay::logMessages end");
}

void CProgAndPlay::openTracesFile() {
	struct stat info;
	if (stat(tracesDirname.c_str(), &info) < 0) {
		PP_SetError("ProgAndPlay::traces directory does not exist");
		log(PP_GetError());
		//FileSystemHandler::mkdir(tracesDirname);
	}
	else {
		const std::map<std::string, std::string>& modOpts = gameSetup->modOptions;
		std::map<std::string,std::string>::const_iterator it;
		it = modOpts.find("tracesfilename");
		if (it != modOpts.end()) {
			missionName = modOpts.at("tracesfilename");
			std::stringstream ss;
			ss << tracesDirname << "\\" << missionName << ".log";
			ppTraces.open(ss.str().c_str(), std::ios::out | std::ios::app | std::ios::ate);
			if (ppTraces.is_open()) {
				std::time_t result = std::time(NULL);
				ppTraces << "start " << missionName << std::endl;
				ppTraces << "mission_start_time " << result << std::endl;
			}
		}
	}
}

/**
* Renvoie un vecteur de string contenant les tokens de val, le delimiteur etant l'espace
*/
std::vector<std::string> splitLine(std::string val) {
	std::string buf;
	std::vector<std::string> elems;
    std::stringstream ss(val);
    while (ss >> buf)
        elems.push_back(buf);
   	return elems;
}

// ---
