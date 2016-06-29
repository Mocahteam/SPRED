/* This file is part of the Spring engine (GPL v2 or later), see LICENSE.html */

// Muratet (Implement class CProgAndPlay) ---

#include <fstream>
#include <sstream>
#include <iostream>
#include <map>
#include <cmath>

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

const std::string archiveExpertPath = "traces\\expert\\";
const std::string archiveParamsPath = "traces\\params.json";

const std::string springTracesPath = "traces\\";
const std::string springDataPath = "traces\\data\\";
const std::string springParamsPath = "traces\\data\\params.json";
const std::string springFeedbacksPath = "traces\\data\\feedbacks.xml";
const std::string springExpertPath = "traces\\data\\expert\\";
const std::string springFeedbackPath = "traces\\data\\feedback.json";

std::ofstream logFile("log.txt", std::ios::out | std::ofstream::trunc);
std::ofstream ppTraces;

void log(std::string msg) {
	logFile << msg << std::endl;
	//logOutput.Print(msg.c_str());
}

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CProgAndPlay* pp;

CProgAndPlay::CProgAndPlay() : loaded(false), updated(false), missionEnded(false), tracePlayer(false), archiveLoaded(false), tp(true), ta() {
	log("ProgAndPLay constructor begin");
		
	// initialisation of Prog&Play
	if (PP_Init() == -1) {
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
	
	archivePath = "mods\\" + archiveScanner->ArchiveFromName(gameSetup->modName);
		
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
  if (ppTraces.is_open()) {
	if (!missionEnded) {
		tp.setEnd();
		tracesThread.join();
	}
	ppTraces.close();
  }
  logFile.close();
  log("ProgAndPLay destructor end");
}

void CProgAndPlay::Update(void) {
	log("ProgAndPLay::Update begin");
		
	// Store log messages
	if (ppTraces.good()) {
		std::stringstream ss;
		
		bool unitsIdled = allUnitsIdled();
		logMessages(unitsIdled);
		
		if (!unitsIdled) {
			if (endless_loop_frame_counter != 0)
				endless_loop_frame_counter = 0;
			if (units_idled_frame_counter != 0)
				units_idled_frame_counter = 0;
		}
		else if (units_idled_frame_counter > -1)
			units_idled_frame_counter++;
		
		bool endlessLoop = endless_loop_frame_counter > UPDATE_RATE_MULTIPLIER * UNIT_SLOWUPDATE_RATE;
		unitsIdled = units_idled_frame_counter > UPDATE_RATE_MULTIPLIER * UNIT_SLOWUPDATE_RATE;
		
		if (!tp.getProceed() && unitsIdled)
			tp.setProceed(true);
		
		ss << "endless loop : " << endlessLoop << std::endl;
		log(ss.str());
		ss.str("");
		ss << "unitsIdled : " << unitsIdled << std::endl;
		log(ss.str());
		ss.str("");
		ss << "endless_loop_frame_counter : " << endless_loop_frame_counter << std::endl;
		log(ss.str());
		ss.str("");
		ss << "units_idled_frame_counter : " << units_idled_frame_counter << std::endl;
		log(ss.str());
		ss.str("");
		ss << "mission_ended : " << missionEnded << std::endl;
		log(ss.str());
		ss.str("");
		ss << "proceed : " << tp.getProceed() << std::endl;
		log(ss.str());
		ss.str("");

		if (tp.compressionDone()) {
			log("compression done");
			tp.setProceed(false);
			endless_loop_frame_counter = -1;
			units_idled_frame_counter = -1;
			
			if (missionEnded) {
				tp.setEnd();
				tracesThread.join();
				ppTraces.close();
			}
			
			ss << "feedbacksWidgetEnabled : " << configHandler->GetString("Feedbacks Widget", "disabled") << std::endl;
			log(ss.str());
			ss.str("");

			const std::map<std::string,std::string>& modOpts = gameSetup->modOptions;
			if ((modOpts.find("testmap") == modOpts.end() || modOpts.at("testmap").compare("0") == 0) && configHandler->GetString("Feedbacks Widget", "disabled").compare("enabled") == 0) {
				// The feedback widget is enabled : launch analysis of player's traces
				ta.setEndlessLoop(endlessLoop);
				
				const std::string learner_xml = loadFile(springTracesPath + missionName + "_compressed.xml");
				std::vector<std::string> experts_xml;
				if (archiveLoaded) {
					std::vector<std::string> files = vfsHandler->GetFilesInDir(archiveExpertPath + missionName);
					for (unsigned int i = 0; i < files.size(); i++) {
						if (files.at(i).find(".xml") != std::string::npos)
							experts_xml.push_back(loadFileFromArchive(archiveExpertPath + missionName + "\\" + files.at(i)));
					}
				}
				
				std::string feedback = ta.constructFeedback(learner_xml, experts_xml, -1, -1, logFile);
				
				log("feedback determined");
				// Write into file
				std::ofstream jsonFile;
				jsonFile.open(springFeedbackPath.c_str());
				if (jsonFile.good()) {
					jsonFile << feedback;
					jsonFile.close();
				}
				
				// Add prefix to json string
				feedback.insert(0,"Feedback_");
				// Send feedback to Lua (SendLuaRulesMsg function in LuaUnsyncedCtrl)
				std::vector<boost::uint8_t> data(feedback.size());
				std::copy(feedback.begin(), feedback.end(), data.begin());
				net->Send(CBaseNetProtocol::Get().SendLuaMsg(gu->myPlayerNum, LUA_HANDLE_ORDER_RULES, 0, data));
			}
			
			
			if (missionEnded && modOpts.find("testmap") != modOpts.end() && modOpts.at("testmap").compare("1") == 0) {
				// TEST MOD : generating an expert solution for a mission
				// move traces and compressed traces files to directory 'traces\data\expert\missionName'
				bool dirExists = FileSystemHandler::mkdir(springDataPath);
				dirExists = FileSystemHandler::mkdir(springExpertPath);
				if (dirExists) {
					std::string path = springExpertPath + missionName;
					dirExists = FileSystemHandler::mkdir(path);
					if (dirExists) {
						// renommage avec le plus entier entier non utilisé dans le repertoire
						int num = 1;
						DIR *pdir;
						struct dirent *pent;
						pdir = opendir(path.c_str());
						if (pdir) {
							while ((pent = readdir(pdir))) {
								std::string name = pent->d_name;
								if (name.find(".xml") != std::string::npos) {
									name.replace(name.find(".xml"), 4, "");
									int file_num = strtol(name.c_str(),NULL,10);
									if (file_num > 0)
										num = file_num + 1;
								}
							}
						}
						closedir(pdir);
						
						ss << "smallest int non used : " << num << std::endl;
						log(ss.str());
						ss.str("");
						
						std::string oldName = springTracesPath + missionName + ".log";
						std::string newName = path + "\\" + boost::lexical_cast<std::string>(num) + ".log";
						if (rename(oldName.c_str(), newName.c_str()) == 0)
							log("brute traces successfully renamed");
						else
							log("brute traces rename operation failed");
						
						oldName = springTracesPath + missionName + "_compressed.xml";
						newName = path + "\\" + boost::lexical_cast<std::string>(num) + ".xml";
						if (rename(oldName.c_str(), newName.c_str()) == 0)
							log("compressed traces successfully renamed");
						else
							log("compressed traces rename operation failed");
					}
				}
			}
		}
		
		// check if the player has click on the publish tab. It can happen only if the mission is ended.
		if (configHandler->GetString("publish", "false").compare("true") == 0) {
			configHandler->SetString("publish", "false", true);
			publishOnFacebook();
		}
	}
		
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

/*
 * Returns the content of the file identified by full_path as a string
 */
const std::string CProgAndPlay::loadFile(std::string full_path) {
	std::string res;
	std::ifstream in(full_path.c_str());
	if (in.good()) {
		std::string line;
		while(std::getline(in,line))
			res += line;
	}
	return res;
}

/*
 * Returns the content of the file located in the mod archive and identified by full_path as a string. The mod archive has to be loaded when the function is called.
 */
const std::string CProgAndPlay::loadFileFromArchive(std::string full_path) {
	std::string res;
	if (archiveLoaded) {
		std::vector<boost::uint8_t> data;
		if (vfsHandler->LoadFile(full_path, data))
			res.assign(data.begin(), data.end());
	}
	return res;
}

void CProgAndPlay::GamePaused(bool paused) {
	int ret = PP_SetGamePaused(paused);
	if (ret == -1)
		return;
	if (ppTraces.is_open()) {
		if (paused)
			ppTraces << "game_paused" << std::endl;
		else
			ppTraces << "game_unpaused" << std::endl;
	}
}

// this function is called in Game.cpp when the play starts
void CProgAndPlay::TracePlayer() {
	if (tracePlayer)
		PP_SetTracePlayer();
}

void CProgAndPlay::UpdateTimestamp() {
	PP_UpdateTimestamp(startTime + (int)std::floor(gu->PP_modGameTime));
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

bool CProgAndPlay::allUnitsIdled() {
	CUnitSet *tmp = &(teamHandler->Team(gu->myTeam)->units);
	CUnitSet::iterator it = tmp->begin();
	while (it != tmp->end()) {
		const CCommandAI* commandAI = (*it)->commandAI;
		if (commandAI != NULL) {
			const CCommandQueue* queue = &commandAI->commandQue;
			if (queue->size() > 0)
				return false;
		}
		it++;
	}
	return true;
}

void CProgAndPlay::logMessages(bool unitsIdled) {
	log("ProgAndPLay::logMessages begin");
	int i = 0;
	if (!missionEnded) {
		CFileHandler *tmpFile = new CFileHandler("mission_ended.conf");
		bool res = tmpFile->FileExists();
		delete tmpFile;
		if (res) {
			//mission ended
			std::ifstream ifs("mission_ended.conf");
			std::string val;
			getline(ifs, val);
			if (val.compare("won") == 0 || val.compare("loss") == 0) {
				ppTraces << "mission_end_time " << startTime + (int)std::floor(gu->PP_modGameTime) << std::endl;
				ppTraces << "end " << val << " " << missionName << std::endl;
				i += 2;
				missionEnded = true;
			}
		}
	}
	// Get next message
	char * msg = PP_PopMessage();
	if (msg != NULL && (missionEnded || (unitsIdled && endless_loop_frame_counter > -1)))
		endless_loop_frame_counter++;
	while (msg != NULL) {
		if (!missionEnded || endless_loop_frame_counter <= UPDATE_RATE_MULTIPLIER * UNIT_SLOWUPDATE_RATE) {
			if (missionEnded)
				ppTraces << "delayed ";
			// Write this message on traces file
			ppTraces << msg << std::endl;
			i++;
		}
		// free memory storing this message
		delete[] msg;
		// Get next message
		msg = PP_PopMessage();
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
	log("ProgAndPLay::openTracesFile begin");
	const std::map<std::string,std::string>& modOpts = gameSetup->modOptions;
	if (modOpts.find("activetraces") != modOpts.end() && modOpts.at("activetraces").compare("1") == 0 && modOpts.find("missionname") != modOpts.end()) {
		bool dirExists = FileSystemHandler::mkdir(springTracesPath);
		if (dirExists) {
			missionName = modOpts.at("missionname");
			
			if (vfsHandler->AddArchive(archivePath, false)) {
				log("mod archive successfully loaded");
				archiveLoaded = true;
				
				// compression parameters loading from JSON for TracesParser
				// first check is in the archive. second check is in Spring directory.
				std::string params_json = loadFileFromArchive(archiveParamsPath);
				if (params_json.compare("") != 0)
					log("compression params loaded from mod archive");
				else {
					params_json = loadFile(springParamsPath);
					if (params_json.compare("") != 0)
						log("compression params loaded from spring directory");
				}
				if (params_json.compare("") != 0)
					tp.initParamsMap(params_json);
				else
					log("default compression params will be used");
					
				if (modOpts.find("testmap") != modOpts.end() && modOpts.at("testmap").compare("0") == 0) {
					log("feedbacks loading");
					// feedbacks loading from XML for TracesAnalyser
					const std::string feedbacks_xml = loadFile(springFeedbacksPath);
					std::string mission_feedbacks_xml;
					std::vector<std::string> files = vfsHandler->GetFilesInDir(archiveExpertPath + missionName);
					for (unsigned int i = 0; i < files.size(); i++) {
						if (files.at(i).compare("feedbacks.xml") == 0) {
							log("mission feedbacks loading from mod archive");
							mission_feedbacks_xml = loadFileFromArchive(archiveExpertPath + missionName + "\\" + files.at(i));
						}
					}
					if (feedbacks_xml.compare("") != 0)
						ta.loadXmlInfos(feedbacks_xml,mission_feedbacks_xml);
				}
			}
			else
				log("mod archive loading has failed");
			
			ta.setLang((modOpts.find("language") != modOpts.end()) ? modOpts.at("language") : "en");
			std::stringstream ss;
			ss << springTracesPath << missionName << ".log";
			ppTraces.open(ss.str().c_str(), std::ios::out | std::ios::app | std::ios::ate);
			if (ppTraces.is_open()) {
				tracePlayer = true;
				startTime = std::time(NULL);
				ppTraces << "start " << missionName << std::endl;
				ppTraces << "mission_start_time " << startTime << std::endl;
				// thread creation
				std::string dirName = springTracesPath;
				dirName.erase(dirName.end()-1);
				std::cout << "dirName : " << dirName << std::endl;
				tracesThread = boost::thread(&TracesParser::parseTraceFileOffline, &tp, dirName, missionName+".log");
			}
		}
		else {
			PP_SetError("ProgAndPlay::cannot create traces directory");
			log(PP_GetError());
		}
	}
	log("ProgAndPLay::openTracesFile end");
}

// Publish on facebook functions

void openFacebookUrl(std::string photoId) {
	const std::string appId = "1199712723374964";
	const std::string caption = "Essaye de faire mieux. Clique ici pour en savoir plus sur ProgAndPlay";
	const std::string description = "ProgAndPlay est une bibliotheque de fonctions pour les jeux de Strategie Temps Reel (STR). Elle permet au joueur de programmer de maniere simple et interactive les entites virtuelles d'un STR. Actuellement...";
	const std::string link = "https://www.irit.fr/ProgAndPlay/";
	const std::string redirect_uri = "https://www.facebook.com/";
	const std::string pictureUrl = "localhost/test/images/generated/";
	std::string url = "https://www.facebook.com/dialog/share?app_id=";
	url += appId;
	url += "&display=page&caption=";
	url += caption;
	url += "&description=";
	url += description;
	url += "&link=";
	url += link;
	url += "&href=";
	url += link;
	url += "&redirect_uri=";
	url += redirect_uri;
	url += "&picture=";
	url += pictureUrl + photoId + ".png";
	std::cout << "url : " << url;

	#ifdef __linux__
		std::string cmd = "x-www-browser " + url; 
		system(cmd.c_str());
	#elif _WIN32
		ShellExecuteA(NULL, "open", url.c_str(), NULL, NULL, SW_SHOWNORMAL);
	#endif
}

std::string sendIdRequest(bool post_request) {
	using boost::asio::ip::tcp;
	const std::string server_name = "localhost";
	const std::string server_path = "/test/build_image.php";
	const std::string img_filename = "Capture.png";
	try {
		boost::asio::io_service io_service;

		// Get a list of endpoints corresponding to the server name.
		tcp::resolver resolver(io_service);
		tcp::resolver::query query(server_name, "http");
		tcp::resolver::iterator endpoint_iterator = resolver.resolve(query);
		tcp::resolver::iterator end;

		// Try each endpoint until we successfully establish a connection.
		tcp::socket socket(io_service);
		boost::system::error_code error = boost::asio::error::host_not_found;
		while (error && endpoint_iterator != end) {
			socket.close();
			socket.connect(*endpoint_iterator++, error);
		}
		if (error)
			throw boost::system::system_error(error);

		boost::asio::streambuf request;
		std::ostream request_stream(&request);

		if (post_request)  {
			std::string boundary("MD5_0be63cda3bf42193e4303db2c5ac3138");
			std::fstream f(img_filename.c_str(), std::ios::in | std::ios::binary);

			//------------------------------------------------------------------------
			// Create Disposition in a stringstream, because we need Content-Length...
			std::ostringstream oss;
			oss << "--" << boundary << "\r\n";
			oss << "Content-Disposition: form-data; name=\"" << "image" << "\"; filename=\"" << img_filename << "\"\r\n";
			//oss << "Content-Type: text/plain\r\n";
			oss << "Content-Type: application/octet-stream\r\n";
			oss << "Content-Transfer-Encoding: binary\r\n";
			oss << "\r\n";

			if (f.good()) {
				char* content;
				std::streambuf *pbuf = f.rdbuf();
				std::streamsize fsize = pbuf->pubseekoff(0,f.end);
				pbuf->pubseekoff(0,f.beg);
				content = new char[fsize];
				pbuf->sgetn(content,fsize);
				f.close();
				for (size_t i=0; i<fsize; i++)
					oss << content[i];
			}
		  
			oss << "\r\n--" << boundary << "--\r\n";
			//------------------------------------------------------------------------

			request_stream << "POST " << server_path << "" << " HTTP/1.1\r\n";
			request_stream << "Content-Type: multipart/form-data; boundary=" << boundary << "\r\n";
			request_stream << "User-Agent: OpenWebGlobe/1.0\r\n";
			request_stream << "Host: " << server_name << "\r\n";   // The domain name of the server (for virtual hosting), mandatory since HTTP/1.1
			request_stream << "Accept: */*\r\n";
			request_stream << "Connection: Close\r\n";
			//request_stream << "Cache-Control: no-cache\r\n";
			request_stream << "Content-Length: " << oss.str().size() << "\r\n";
			request_stream << "\r\n";
			request_stream << oss.str();

			std::cout << request_stream.rdbuf() << std::endl;
		}
		else {
			request_stream << "GET " << server_path << " HTTP/1.0\r\n";
			request_stream << "Host: " << server_name << "\r\n";
			request_stream << "Accept: */*\r\n";
			request_stream << "Connection: close\r\n\r\n";
		}

		boost::asio::write(socket, request);

		// Read the response status line. The response streambuf will automatically
		// grow to accommodate the entire line. The growth may be limited by passing
		// a maximum size to the streambuf constructor.
		boost::asio::streambuf response;
		boost::asio::read_until(socket, response, "\r\n");

		// Check that response is OK.
		std::istream response_stream(&response);
		std::string http_version;
		response_stream >> http_version;
		unsigned int status_code;
		response_stream >> status_code;
		std::string status_message;
		std::getline(response_stream, status_message);
		if (!response_stream || http_version.substr(0, 5) != "HTTP/") {
		  std::cout << "Invalid response\n";
		  return "";
		}
		if (status_code != 200) {
		  std::cout << "Response returned with status code " << status_code << "\n";
		  return "";
		}
		// Read the response headers, which are terminated by a blank line.
		boost::asio::read_until(socket, response, "\r\n\r\n");
		// Process the response headers.
		std::string header;
		while (std::getline(response_stream, header) && header != "\r");
		// Write whatever content we already have to output.
		if (response.size() > 0) {
		  std::ostringstream oss;
		  oss << &response;
		  return oss.str();
		}
		// Read until EOF, writing data to output as we go.
		while (boost::asio::read(socket, response, boost::asio::transfer_at_least(1), error))
			std::cout << &response;
		if (error != boost::asio::error::eof)
			throw boost::system::system_error(error);
	}
	catch (std::exception& e) {
		std::cout << "Exception: " << e.what() << "\n";
	}
	return "";
}

void publishOnFacebook() {
	std::string id = sendIdRequest(false);
	if (id != "")
		openFacebookUrl(id);
}

// ---
