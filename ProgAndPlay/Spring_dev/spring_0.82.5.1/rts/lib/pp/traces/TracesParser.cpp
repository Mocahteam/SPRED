#include "TracesParser.h"

#define MIN_SEQ_SIZE 1
#define MAX_SEQ_SIZE 100000
#define MAX_END_SEARCH 10

#define DEBUG_
#define LOG_IN_FILE

int TracesParser::lineNum = 0;
int TracesParser::mission_end_time = 0;
std::string TracesParser::mission_name = "";
sp_trace TracesParser::spe_eme;

#ifdef DEBUG
	#ifdef LOG_IN_FILE
		std::ofstream debugOfs("debug.log", std::ofstream::out);
		std::ostream& os = debugOfs;
	#else
		std::ostream& os = std::cout;
	#endif
#endif

TracesParser::TracesParser(): launched(false), compress(false), end(false), start(0), pt(0) {
	
}

/*
 * Destructor of the class. All the opened files are closed. Thanks to boost::shared_ptr, no need to call delete on dynamically allocated objects. 
 *
 */
TracesParser::~TracesParser() {
	endParse();
}

bool TracesParser::beginParse(const std::string& dir_path, const std::string& filename) {
	if (launched) {
		std::cout << "parsing of traces file already launched" << std::endl;
		return false;
	}
	if (!traces.empty())
		traces.clear();
	this->dir_path = dir_path;
	this->filename = filename;
	std::string s = dir_path + "\\" + filename;
	if (!ifs.is_open()) {
		if (filename.find(".log") == std::string::npos) {
			std::cout << "not a log file" << std::endl;
			return false;
		}
		ifs.open(s.c_str(), std::ios::in | std::ios::binary);
	}
	if (ifs.good())
		launched = true;
	else
		std::cout << "error opening file : " << strerror(errno) << std::endl;
	return launched;
}

void TracesParser::endParse() {
	start = 0;
	launched = false;
	end = false;
	compress = false;
	if (ifs.is_open())
		ifs.close();
	#ifdef DEBUG
		#ifdef LOG_IN_FILE
			if (debugOfs.is_open())
				debugOfs.close();
		#endif
	#endif
}

void TracesParser::writeFiles(bool online) {
	if (online)
		Sequence::removeRedundancies(traces);
	display();
	std::string s = "\\" + filename;
	s.replace(s.find(".log"), 4, "_compressed.txt");
	s.insert(0, dir_path);
	std::ofstream ofs(s.c_str(), std::ofstream::out | std::ofstream::trunc);
	if (ofs.good()) {
		display(ofs);
		ofs.close();
	}
	exportTraceToXml();
	compress = true;
}

/* 
 * Starts the parsing of the traces file 'filename' which is located in 'dir_path' with online algorithm
 *
 * online: true if the parsing has to be done while the file is written (during the game), false otherwise (the file is already filled).
 */
void TracesParser::parseTraceFileOnline(const std::string& dir_path, const std::string& filename, bool on_writing) {
	if (beginParse(dir_path,filename)) {
		if (on_writing && reachLastStart())
			readTracesOnlineOnWriting();
		else {
			readTracesOnline();
			writeFiles(true);
		}
		endParse();
	}
}

/* 
 * Starts the parsing of the traces file 'filename' which is located in 'dir_path' with offline algorithm (the file have to be already filled with the traces).
 *
 */
void TracesParser::parseTraceFileOffline(const std::string& dir_path, const std::string& filename, bool on_writing) {
	if (beginParse(dir_path,filename)) {
		if (on_writing && reachLastStart())
			readTracesOfflineOnWriting();
		else {
			readTracesOffline();
			writeFiles(false);
		}
		endParse();
	}
}

/*
 * Parse the file 'filename' which is located in 'dir_path' without compression.
 *
 */
void TracesParser::parseTraceFile(const std::string& dir_path, const std::string& filename) {
	if (beginParse(dir_path,filename)) {
		std::string line;
		Event *e = NULL;
		while (std::getline(ifs, line)) {
			lineNum++;
			// std::cout << "line : " << lineNum << std::endl;
			sp_trace spt = handleLine(line);
			if (spt) {
				e = (spt->isEvent()) ? dynamic_cast<Event*>(spt.get()) : NULL;
				if (e != NULL && Trace::inArray(e->getLabel().c_str(), Event::noConcatEventsArr) > -1) {
					if (e->getLabel().compare("end_execution") == 0)
						traces.push_back(spt);
					if (spe_eme && e->getLabel().compare("new_execution") != 0) {
						traces.push_back(spe_eme);
						spe_eme.reset();
					}
					if (e->getLabel().compare("end_execution") != 0)
						traces.push_back(spt);
				}
				else
					traces.push_back(spt);
			}
		}
	}
	exportTraceToXml();
	endParse();
}

/*
 * Handles all traces contained in the file with the online algorithm.
 *
 */
void TracesParser::readTracesOnline() {
	std::string line;
	while (std::getline(ifs, line)) {
		lineNum++;
		// std::cout << "line : " << lineNum << std::endl;
		sp_trace spt = handleLine(line);
		while (spt && !handleTraceOnline(spt));
	}
	ifs.clear();
	sp_trace spt = boost::make_shared<Event>("eof");
	while (!handleTraceOnline(spt));
}

/*
 * Reads traces in the file while the writing and handles these with the online algorithm.
 *
 */
void TracesParser::readTracesOnlineOnWriting() {
	std::string line;
	while (!end) {
		while (std::getline(ifs, line)) {
			lineNum++;
			// std::cout << "line : " << lineNum << std::endl;
			sp_trace spt = handleLine(line);
			while (spt && !handleTraceOnline(spt,true));
		}
		if (!ifs.eof())
			end = true; // Ensure end of read was EOF.
		else
			Sleep(100);
		ifs.clear();
	}
	sp_trace spt = boost::make_shared<Event>("eof");
	while (!handleTraceOnline(spt,true));
}

/*
 * Handles all traces contained in the file with the offline algorithm.
 *
 */
void TracesParser::readTracesOffline() {
	std::string line;
	Event *e = NULL;
	while (std::getline(ifs, line)) {
		lineNum++;
		// std::cout << "line : " << lineNum << std::endl;
		sp_trace spt = handleLine(line);
		if (spt) {
			e = (spt->isEvent()) ? dynamic_cast<Event*>(spt.get()) : NULL;
			if (e != NULL && Trace::inArray(e->getLabel().c_str(), Event::noConcatEventsArr) > -1) {
				detectSequences();
				if (e->getLabel().compare("end_execution") == 0)
					handleTraceOffline(spt);
				if (spe_eme && e->getLabel().compare("new_execution") != 0) {
					traces.push_back(spe_eme);
					spe_eme.reset();
				}
				if (e->getLabel().compare("end_execution") != 0)
					handleTraceOffline(spt);
				start = traces.size();
			}
			else
				handleTraceOffline(spt);
		}
	}
	detectSequences();
	if (spe_eme) {
		traces.push_back(spe_eme);
		spe_eme.reset();
	}
}

void TracesParser::readTracesOfflineOnWriting() {
	std::string line;
	Event *e = NULL;
	while (!end) {
		while (std::getline(ifs, line)) {
			lineNum++;
			// std::cout << "line : " << lineNum << std::endl;
			sp_trace spt = handleLine(line);
			if (spt) {
				e = (spt->isEvent()) ? dynamic_cast<Event*>(spt.get()) : NULL;
				if (e != NULL && Trace::inArray(e->getLabel().c_str(), Event::noConcatEventsArr) > -1) {
					detectSequences();
					if (e->getLabel().compare("end_execution") == 0)
						handleTraceOffline(spt);
					if (spe_eme && e->getLabel().compare("new_execution") != 0) {
						traces.push_back(spe_eme);
						spe_eme.reset();
					}
					if (e->getLabel().compare("end_execution") != 0)
						handleTraceOffline(spt);
					start = traces.size();
					writeFiles(false);
				}
				else
					handleTraceOffline(spt);
			}
		}
		if (!ifs.eof())
			end = true; // Ensure end of read was EOF.
		else
			Sleep(100);
		ifs.clear();
	}
	detectSequences();
	if (spe_eme) {
		traces.push_back(spe_eme);
		spe_eme.reset();
	}
	writeFiles(false);
}

sp_trace TracesParser::handleLine(const std::string& s) {
	Trace *t = NULL;
	std::vector<std::string> tokens = splitLine(s);
	if (tokens[0].compare("start") == 0) {
		TracesParser::mission_name = tokens[1];
	}
	else if (tokens[0].compare("mission_start_time") == 0) {
		t = new StartMissionEvent(TracesParser::mission_name, stoi(tokens[1]));
	}
	else if (tokens[0].compare("mission_end_time") == 0) {
		TracesParser::mission_end_time = stoi(tokens[1]);
	}
	else if (tokens[0].compare("end") == 0) {
		spe_eme = boost::make_shared<EndMissionEvent>(tokens[1], TracesParser::mission_end_time);
	}
	else {
		int ind = 0;
		bool delayed = false;
		if (tokens[ind].compare("delayed") == 0) {
			delayed = true;
			ind++;
		}
		if (tokens[ind].compare("execution_start_time") == 0) {
			t = new NewExecutionEvent(stoi(tokens[ind+1]));
		}
		else if (tokens[ind].compare("execution_end_time") == 0) {
			t = new EndExecutionEvent(stoi(tokens[ind+1]));
		}
		else if (Trace::inArray(tokens[ind].c_str(), Event::concatEventsArr) > -1) {
			t = new Event(tokens[ind]);
		}
		else if (tokens.size() == 1 || (tokens.size() == 2 && delayed)) {
			t = new NoParamCall(tokens[ind]);
		}
		else {
			Call::ErrorType err = Call::getErrorType(tokens[ind].c_str());
			if (err != Call::NONE) {
				t = handleError(err, tokens, ++ind);
			}
			else if (tokens[ind].compare("PP_GetSpecialAreaPosition") == 0) {
				t = new GetSpecialAreaPositionCall(stoi(tokens[ind+1]));
			}
			else if (tokens[ind].compare("PP_GetResource") == 0) {
				t = new GetResourceCall(stoi(tokens[ind+1]));
			}
			else if (tokens[ind].compare("PP_GetNumUnits") == 0) {
				t = new GetNumUnitsCall(static_cast<CallMisc::Coalition>(stoi(tokens[ind+1])));
			}
			else if (tokens[ind].compare("PP_GetUnitAt") == 0) {
				t = new GetUnitAtCall(static_cast<CallMisc::Coalition>(stoi(tokens[ind+1])), stoi(tokens[ind+2]));
			}
			else {
				std::vector<std::string> unitParamTokens = splitLine(tokens[ind+1], '_');
				if (tokens[ind].compare("PP_Unit_SetGroup") == 0) {
					t = new SetGroupCall(stoi(unitParamTokens[0]), stoi(unitParamTokens[1]), stoi(tokens[ind+2]));
				}
				else if (tokens[ind].compare("PP_Unit_ActionOnUnit") == 0) {
					std::vector<std::string> targetParamTokens = splitLine(tokens[ind+3], '_');
					t = new ActionOnUnitCall(stoi(unitParamTokens[0]), stoi(unitParamTokens[1]), stoi(tokens[ind+2]), stoi(targetParamTokens[0]), stoi(targetParamTokens[1]));
				}
				else if (tokens[ind].compare("PP_Unit_ActionOnPosition") == 0) {
					t = new ActionOnPositionCall(stoi(unitParamTokens[0]), stoi(unitParamTokens[1]), stoi(tokens[ind+2]), stof(tokens[ind+3]), stof(tokens[ind+4]));
				}
				else if (tokens[ind].compare("PP_Unit_UntargetedAction") == 0) {
					t = new UntargetedActionCall(stoi(unitParamTokens[0]), stoi(unitParamTokens[1]), stoi(tokens[ind+2]), stof(tokens[ind+3]));
				}
				else if (tokens[ind].compare("PP_Unit_PdgCmd_GetCode") == 0) {
					t = new GetCodePdgCmdCall(stoi(unitParamTokens[0]), stoi(unitParamTokens[1]), stoi(tokens[ind+2]));
				}
				else if (tokens[ind].compare("PP_Unit_PdgCmd_GetNumParams") == 0) {
					t = new GetNumParamsPdgCmdCall(stoi(unitParamTokens[0]), stoi(unitParamTokens[1]), stoi(tokens[ind+2]));
				}
				else if (tokens[ind].compare("PP_Unit_PdgCmd_GetParam") == 0) {
					t = new GetParamPdgCmdCall(stoi(unitParamTokens[0]), stoi(unitParamTokens[1]), stoi(tokens[ind+2]), stof(tokens[ind+3]));
				}
				else {
					t = new UnitCall(tokens[ind], stoi(unitParamTokens[0]), stoi(unitParamTokens[1]));
				}
			}
		}
		if (t != NULL) {
			if (delayed)
				t->setDelayed();
			if (t->isCall()) {
				Call *c = dynamic_cast<Call*>(t);
				std::vector<std::string>::iterator it = std::find(tokens.begin(), tokens.end(), "-");
				if (it != tokens.end()) {
					while (++it != tokens.end())
						//***
						if ((*it).compare("?") == 0)
							c->setIndRet(); // il y a peut etre une meilleure facon de faire ici
						else
						//***
							c->addReturnCode(stof(*it));
				}
			}
		}
	}
	sp_trace spt(t);
	return spt;
}

/* 
 * This function has to be called when an error has been detected on the line. 
 * Returns a specific type of trace which contains the suitable parameter, based on the label and the error type of the trace.
 * 
 * err : type of the detected error
 * tokens : vector containing the tokens of the last parsed line
 * ind : index to be used for reading values in tokens
 */
WrongCall* TracesParser::handleError(Call::ErrorType err, const std::vector<std::string>& tokens, int ind) {
	WrongCall *c;
	//***
	if (tokens[ind+1].compare("?") == 0)
		c = new WrongCall(tokens[ind], err, -1);
	//***
	else if (tokens[ind].compare("PP_GetUnitAt") == 0 || (tokens[ind].compare("PP_Unit_ActionOnPosition") == 0 && err == Call::WRONG_POSITION))
		c = new WrongCall(tokens[ind], err, 2, stof(tokens[ind+1]), stof(tokens[ind+2]));
	else
		c = new WrongCall(tokens[ind], err, 1, stof(tokens[ind+1]));
	return c;
}

bool TracesParser::doCheckOnline(sp_trace spt) {
	cur_seq = seqStack.top();
	if (pt < tracesSave.size()) {
		#ifdef DEBUG
			os << "compare with save call (pt : " << pt << ")" << std::endl;
		#endif
		spt = tracesSave.at(pt);
	}
	sp_trace spt_seq = cur_seq->next();
	if (!spt->isSequence()) {
		while (spt_seq->isSequence()) {
			sp_sequence sps_seq = boost::dynamic_pointer_cast<Sequence>(spt_seq);
			seqStack.push(sps_seq);
			cur_seq = sps_seq;
			spt_seq = sps_seq->next();
			sp_sequence hist_sps;
			histStack.push(hist_sps);
		}
	}
	#ifdef DEBUG
		os << "doCheck : " << std::endl;
		spt->display(os);
		os << std::endl;
		spt_seq->display(os);
		os << std::endl;
		cur_seq->display(os);
		os << std::endl;
	#endif
	return spt->operator==(spt_seq.get());
}

bool TracesParser::handleTraceOnline(const sp_trace& spt, bool onWriting) {
	#ifdef DEBUG
		os << "seq stack size : " << seqStack.size() << std::endl;
		os << "tracesSave : " << std::endl;
		for (unsigned int i = 0; i < tracesSave.size(); i++)
			tracesSave.at(i)->display(os);
		os << "new call : ";
		spt->display(os);
		os << std::endl;
	#endif
	bool res = true;
	Event *e = NULL;
	if (spt->isEvent())
		e = dynamic_cast<Event*>(spt.get());
	if (e != NULL && seqStack.empty() && tracesSave.empty() && Trace::inArray(e->getLabel().c_str(), Event::noConcatEventsArr) > -1) {
		if (e->getLabel().compare("end_execution") == 0)
			traces.push_back(spt);
		if (spe_eme && e->getLabel().compare("new_execution") != 0) {
			traces.push_back(spe_eme);
			spe_eme.reset();
		}
		if (e->getLabel().compare("end_execution") != 0 && e->getLabel().compare("eof") != 0)
			traces.push_back(spt);
		start = traces.size();
		if (onWriting)
			writeFiles(true);
	}
	else if (!seqStack.empty()) {
		if (doCheckOnline(spt)) {
			#ifdef DEBUG
				os << "match" << std::endl;
			#endif
			if (pt == tracesSave.size())
				tracesSave.push_back(spt);
			else
				res = false;
			pt++;
			if (cur_seq->isEndReached()) {
				if (seqStack.size() > 1)
					findSequence();
				else if (seqStack.size() == 1 && cur_seq->checkValid())
					sequenceDetected();
			}
		}
		else {
			#ifdef DEBUG
				os << "no match" << std::endl;
			#endif
			if (seqStack.size() > 1) {
				if (!cur_seq->isValid()) {
					#ifdef DEBUG
						os << "no match && sequence not valid" << std::endl;
					#endif
					while(seqStack.size() > 1) {
						cur_seq->reset();
						seqStack.pop();
						histStack.pop();
						ind_start = 0;
					}
				}
				else if (pt == tracesSave.size() && cur_seq->getPt() != 1) {
					#ifdef DEBUG
						os << "no match && change mod" << std::endl;
					#endif
					if (cur_seq->getPt() == 0)
						pt -= cur_seq->size() - 1;
					else
						pt -= cur_seq->getPt() - 1;
				}
			}
			cur_seq = seqStack.top();
			cur_seq->reset();
			seqStack.pop();
			histStack.pop();
			ind_start = 0;
			if (seqStack.empty()) {
				if (cur_seq->getNum() == 1) {
					#ifdef DEBUG
						os << "false sequence" << std::endl;
					#endif
					tracesSave.at(0)->endSearch++;
				}
				cur_seq->setValid(false);
			}
			else {
				cur_seq = seqStack.top();
				if (cur_seq->isEndReached()) {
					if (seqStack.size() > 1)
						findSequence();
					else if (seqStack.size() == 1 && cur_seq->checkValid())
						sequenceDetected();
				}
			}
			res = false;
		}
	}
	else {
		if (tracesSave.empty()) {
			tracesSave.push_back(spt);
			#ifdef DEBUG
				os << "search : use new call" << std::endl;
			#endif
		}
		else {
			res = false;
			#ifdef DEBUG
				os << "search : use save call" << std::endl;
			#endif
		}
		sp_trace first_spt = tracesSave.at(0);
		if (!searchSequence(first_spt)) {
			traces.push_back(first_spt);
			tracesSave.erase(tracesSave.begin());
			#ifdef DEBUG
				os << "no (more) possible sequence from this trace" << std::endl;
			#endif
		}
	}
	return res;
}

bool TracesParser::searchSequence(const sp_trace& spt) {
	#ifdef DEBUG
		os << "search sequence from : " << std::endl;
		spt->display(os);
	#endif
	bool found = false;
	if (spt->endSearch < MAX_END_SEARCH) {
		if (spt->indSearch == -1)
			spt->indSearch = traces.size();
		spt->indSearch--;
		while (!found && /*spt->lenSearch <= MAX_SEQ_SIZE &&*/ spt->indSearch >= start) {
			if (spt->operator==(traces.at(spt->indSearch).get()) /*&& spt->lenSearch >= MIN_SEQ_SIZE*/)
				found = true;
			else {
				spt->indSearch--;
				spt->lenSearch++;
			}
		}
		if (found) {
			cur_seq = boost::make_shared<Sequence>(1);
			unsigned int j = spt->indSearch;
			while (j < traces.size())
				cur_seq->addTrace(traces.at(j++));
			// the sequence must contain at least two different types of traces
			if (!cur_seq->isUniform()) {
				#ifdef DEBUG
					os << "potential sequence has been found : " << std::endl;
					cur_seq->display(os);
					os << std::endl;
				#endif
				seqStack.push(cur_seq);
				sp_sequence hist_sps;
				histStack.push(hist_sps);
				cur_seq->next();
				pt = 1;
				if (spt->isSequence())
					boost::dynamic_pointer_cast<Sequence>(cur_seq->at(0))->setValid(true);
			}
			else {
				#ifdef DEBUG
					os << "uniform sequence" << std::endl;
				#endif
				spt->endSearch++;
				return searchSequence(spt);
			}
		}
	}
	return found;
}

void TracesParser::sequenceDetected() {
	cur_seq->addOne();
	if (cur_seq->getNum() == 2) {
		#ifdef DEBUG
			os << "true sequence" << std::endl;
		#endif
		for (unsigned int i = 0; i < cur_seq->size(); i++)
			traces.pop_back();
		cur_seq->checkDelayed();
		tracesSave.insert(tracesSave.begin(),cur_seq);
	}
	tracesSave.erase(tracesSave.begin() + 1, tracesSave.begin() + 1 + cur_seq->size());
	pt = 1;
	cur_seq->setValid(false);
	#ifdef DEBUG
		os << "num seq ++" << std::endl;
	#endif
}

void TracesParser::findSequence() {
	unsigned int i = 0, ind = 0, cpt = 0;
	bool inSeq = false, valid = false;
	if (histStack.top())
		i = ind_start;
	while(i < tracesSave.size()) {
		sp_trace spt = cur_seq->at(ind);
		if (spt->operator==(tracesSave.at(i).get())) {
			if (!inSeq) {
				ind_start = i;
				inSeq = true;
			}
			if (++ind == cur_seq->size()) {
				ind = 0;
				if (++cpt == 2 || histStack.top()) {
					valid = true;
					compactHistory();
				}
			}
			i++;
		}
		else if (inSeq) {
			inSeq = false;
			valid = false;
			ind = 0;
			cpt = 0;
		}
		else
			i++;
	}
	if (!cur_seq->isValid() && valid) {
		cur_seq->setValid(true);
		#ifdef DEBUG
			os << "sequence validated" << std::endl;
		#endif
	}
}

void TracesParser::compactHistory() {
	unsigned int i;
	sp_sequence hist_sps;
	if (!histStack.top()) {
		#ifdef DEBUG
			os << "compact history : create seq" << std::endl;
		#endif
		hist_sps = boost::make_shared<Sequence>(2);
		for (i = ind_start; i < ind_start + cur_seq->size(); i++)
			hist_sps->addTrace(tracesSave.at(i));
		tracesSave.erase(tracesSave.begin() + ind_start, tracesSave.begin() + ind_start + 2 * hist_sps->size());
		tracesSave.insert(tracesSave.begin() + ind_start, hist_sps);
		ind_start++;
		histStack.pop();
		histStack.push(hist_sps);
	}
	else {
		#ifdef DEBUG
			os << "compact history : add one" << std::endl;
		#endif
		histStack.top()->addOne();
		tracesSave.erase(tracesSave.begin() + ind_start, tracesSave.begin() + ind_start + histStack.top()->size());
	}
	pt = ind_start;
}

void TracesParser::detectSequences() {
	unsigned int i, j, seq_start, seq_end, max_size = 2, sps_up_len;
    bool found, climb = false;
	sp_sequence sps_up, sps_down, sps_res;
	while(max_size < traces.size() - start) {
		#ifdef DEBUG
			os << "max size : " << max_size << std::endl;
		#endif
		i = start;
		seq_end = start;
		while (i < traces.size()) {
			if (traces.at(i)->isEvent()) {
				i++;
				continue;
			}
			if (traces.at(i)->indSearch == -1) {
				traces.at(i)->indSearch = i-1;
				traces.at(i)->lenSearch = traces.at(i-1)->length();
			}
			#ifdef DEBUG
				os << "search from : " << std::endl;
				traces.at(i)->display(os);
				os << std::endl;
			#endif
			while (i < traces.size() && traces.at(i)->lenSearch <= max_size && traces.at(i)->indSearch >= (int)seq_end && traces.at(i)->endSearch < MAX_END_SEARCH) {
				if (traces.at(i)->lenSearch >= 2) {
					sps_up = boost::make_shared<Sequence>(1);
					seq_start = traces.at(i)->indSearch;
					j = seq_start;
					while(j < i)
						sps_up->addTrace(traces.at(j++));
					sps_up_len = sps_up->length();
					if (checkFeasibility(sps_up_len,j)) {
						#ifdef DEBUG
							os << "sps_up : " << std::endl;
							sps_up->display(os);
							os << std::endl;
						#endif
						found = true;
						while (found) {
							sps_down = boost::make_shared<Sequence>(1);
							while(j < traces.size() && sps_down->length() < sps_up_len)
								sps_down->addTrace(traces.at(j++));
							#ifdef DEBUG
								os << "sps_down : " << std::endl;
								sps_down->display(os);
								os << std::endl;
							#endif
							sps_res = mergeSequences(sps_up, sps_down);
							if (sps_res) {
								sps_up = sps_res;
								seq_end = j;
							}
							else
								found = false;
						}
						if (sps_up->getNum() >= 2) {
							#ifdef DEBUG
								os << "seq_start : " << seq_start << std::endl;
								os << "seq_end : " << seq_end << std::endl;
								// os << "sps_up" << std::endl;
								// sps_up->display(os);
								// os << std::endl;
							#endif
							sps_up->checkDelayed();
							traces.erase(traces.begin() + seq_start, traces.begin() + seq_end);
							traces.insert(traces.begin() + seq_start, sps_up);
							seq_end = seq_start + 1;
							std::vector<sp_trace>::iterator it = traces.begin() + seq_end;
							while(it != traces.end())
								(*it++)->indSearch = -1;
							i = seq_start + max_size;
							// #ifdef DEBUG
								// os << "seq_end : " << seq_end << std::endl;
								// os << "i : " << i << std::endl;
								// it = traces.begin();
								// while (it != traces.end())
									// (*it++)->display(os);
								// os << std::endl;
							// #endif
						}
						else {
							#ifdef DEBUG
								os << "false sequence" << std::endl;
							#endif
							climb = true;
						}
					}
					else {
						#ifdef DEBUG
							os << "not enough traces for sequence" << std::endl;
						#endif
						traces.at(i)->endSearch = MAX_END_SEARCH;
						break;
					}
				}
				else {
					climb = true;
				}
				if (climb && traces.at(i)->indSearch > 0) {
					traces.at(i)->indSearch--;
					traces.at(i)->lenSearch += traces.at(traces.at(i)->indSearch)->length();
					climb = false;
				}
			}
			i++;
		}
		max_size++;
	}
}

bool TracesParser::checkFeasibility(unsigned int min_length, unsigned int ind_start) {
	unsigned int len = 0;
	for (unsigned int i = ind_start; len < min_length && i < traces.size(); i++) {
		if (traces.at(i)->isEvent() && Trace::inArray(boost::dynamic_pointer_cast<Event>(traces.at(i))->getLabel().c_str(), Event::noConcatEventsArr) > -1)
			break;
		len += traces.at(i)->length();
	}
	return len >= min_length;
}

/*
 * Constructs the most generalised sequence from seq_up and seq_down. seq_up and seq_down must have the same length and must be equals.
 *
 * Returns a shared_ptr object which contains a pointer to the new sequence if the construction has succeeded, or a NULL pointer otherwise.
 *
 */
sp_sequence TracesParser::mergeSequences(sp_sequence sps_up, sp_sequence sps_down) {
	sp_sequence sps;
	if (sps_up->compare(sps_down.get())) {
		#ifdef DEBUG
			os << "starting merge" << std::endl;
			sps_up->display(os);
			sps_down->display(os);
			os << std::endl;
		#endif
		// the two sequences are equals
		sps_up->reset();
		sps_down->reset();
		unsigned int len_up, len_down, pop = 0;
		bool next_up = false, next_down = false;
		sps = boost::make_shared<Sequence>(sps_up);
		sps->addOne();
		std::stack<sp_sequence> newStack;
		newStack.push(sps);
		std::stack<sp_sequence> upStack;
		upStack.push(sps_up);
		std::stack<sp_sequence> downStack;
		downStack.push(sps_down);
		std::vector<sp_trace> events;
		sp_trace spt_up = sps_up->next();
		while (!sps_up->isEndReached() && sps_up->at(sps_up->getPt())->isEvent())
			events.push_back(sps_up->next());
		sp_trace spt_down = sps_down->next();
		while (!sps_down->isEndReached() && sps_down->at(sps_down->getPt())->isEvent())
			events.push_back(sps_down->next());
		while (!upStack.empty() && !downStack.empty()) {
			if (!spt_up->isSequence() && !spt_down->isSequence()) {
				#ifdef DEBUG
					os << "both not sequence" << std::endl;
				#endif
				next_up = true;
				next_down = true;
				sps->addTrace(spt_up);
				if (!events.empty()) {
					for (unsigned int i = 0; i < events.size(); i++)
						sps->addTrace(events.at(i));
					events.clear();
				}
			}
			else {
				if (spt_up->isSequence())
					sps_up = boost::dynamic_pointer_cast<Sequence>(spt_up);
				if (spt_down->isSequence())
					sps_down = boost::dynamic_pointer_cast<Sequence>(spt_down);
				len_up = spt_up->length();
				len_down = spt_down->length();
				if (spt_up->isSequence() && spt_down->isSequence() && len_up == len_down) {
					#ifdef DEBUG
						os << "both sequence and same length" << std::endl;
					#endif
					sps = boost::make_shared<Sequence>(sps_up,sps_down);
					upStack.push(sps_up);
					downStack.push(sps_down);
					next_up = true;
					next_down = true;
				}
				else if ((spt_up->isSequence() && !spt_down->isSequence()) || len_up > len_down) {
					#ifdef DEBUG
						os << "push up" << std::endl;
					#endif
					sps = boost::make_shared<Sequence>(sps_up);
					if (spt_up->isSequence() && !spt_down->isSequence())
						sps->updateNumMap(1,1);
					upStack.push(sps_up);
					next_up = true;
				}
				else if ((!spt_up->isSequence() && spt_down->isSequence()) || len_up < len_down) {
					#ifdef DEBUG
						os << "push down" << std::endl;
					#endif
					sps = boost::make_shared<Sequence>(sps_down);
					if (!spt_up->isSequence() && spt_down->isSequence())
						sps->updateNumMap(1,1);
					downStack.push(sps_down);
					next_down = true;
				}
				newStack.push(sps);
			}
			while (next_up && !upStack.empty() && sps_up->isEndReached()) {
				#ifdef DEBUG
					os << "pop up" << std::endl;
				#endif
				upStack.pop();
				if (!upStack.empty()) {
					sps_up = upStack.top();
					pop++;
				}
			}
			while (next_down && !downStack.empty() && sps_down->isEndReached()) {
				#ifdef DEBUG
					os << "pop down" << std::endl;
				#endif
				downStack.pop();
				if (!downStack.empty()) {
					sps_down = downStack.top();
					pop++;
				}
			}
			#ifdef DEBUG
				os << "pop value : " << pop << std::endl;
			#endif
			while (pop > 0) {
				if (sps->isShared()) {
					pop -= 2;
					#ifdef DEBUG
						os << "pop_new (shared)" << std::endl;
					#endif
				}
				else {
					pop--;
					#ifdef DEBUG
						os << "pop_new" << std::endl;
					#endif
				}
				newStack.pop();
				newStack.top()->addTrace(sps);
				sps = newStack.top();
			}
			if (next_up && !upStack.empty()) {
				spt_up = sps_up->next();
				while (!sps_up->isEndReached() && sps_up->at(sps_up->getPt())->isEvent())
					events.push_back(sps_up->next());
				next_up = false;
			}
			if (next_down && !downStack.empty()) {
				spt_down = sps_down->next();
				while (!sps_down->isEndReached() && sps_down->at(sps_down->getPt())->isEvent())
					events.push_back(sps_down->next());
				next_down = false;
			}
			#ifdef DEBUG
				os << "end" << std::endl;
			#endif
		}
		#ifdef DEBUG
			os << "merge result" << std::endl;
			sps->display(os);
			os << std::endl;
		#endif
	}
	return sps;
}

void TracesParser::handleTraceOffline(const sp_trace& spt) {
	bool add = false;
	if (traces.size() > 0) {
		sp_sequence sps;
		if (traces.back()->isSequence()) {
			sps = boost::dynamic_pointer_cast<Sequence>(traces.back());
			if (sps->at(0)->operator==(spt.get())) {
				sps->addOne();
				add = true;
			}
			else if (spt->isEvent()) {
				sps->addTrace(spt);
				add = true;
			}
		}
		else if (traces.back()->isCall() && traces.back()->operator==(spt.get())) {
			sps = boost::make_shared<Sequence>(2);
			sps->addTrace(traces.back());
			traces.pop_back();
			traces.push_back(sps);
			add = true;
		}
	}
	if (!add)
		traces.push_back(spt);
}

/*
 * Runs trough the file and sets the position of the next line to be extracted from the input stream.
 * 
 * Returns true if at least one 'start' label has been found, false otherwise.
 */
bool TracesParser::reachLastStart() {
	std::string line;
	int pos = 0, start_pos = -1, cpt = 1;
	while (getline(ifs, line)) {
		std::vector<std::string> tokens = splitLine(line);
		if (tokens[0].compare("start") == 0) {
			start_pos = pos;
			lineNum = cpt;
		}
		pos = ifs.tellg();
		cpt++;
	}
	ifs.clear();
	if (start_pos != -1) {
		ifs.seekg(start_pos);
		//just at the begin of the last 'start' of the file (if there is at least one)
		return true;
	}
	return false;
}

void TracesParser::display(std::ostream &os) {
	int num_start = 0;
	Event *e = NULL;
	for (unsigned int i = 0; i < traces.size(); i++) {
		e = traces.at(i)->isEvent() ? dynamic_cast<Event*>(traces.at(i).get()) : NULL;
		if (e != NULL && Trace::inArray(e->getLabel().c_str(), Event::noConcatEventsArr) > -1) {
			if (e->getLabel().compare("start_mission") == 0) {
				if (num_start++ > 0)
					os << std::endl;
				StartMissionEvent *sme = dynamic_cast<StartMissionEvent*>(e);
				os << "mission name : " << sme->getMissionName() << std::endl << "mission start time : " << sme->getStartTime() << std::endl;
			}
			else if (e->getLabel().compare("end_mission") == 0) {
				EndMissionEvent *eme = dynamic_cast<EndMissionEvent*>(e);
				os << "status : " << eme->getStatus() << std::endl << "mission end time : " << eme->getEndTime() << std::endl;
			}
			else if (e->getLabel().compare("new_execution") == 0) {
				os << "\texecution start time : " << dynamic_cast<NewExecutionEvent*>(e)->getStartTime() << std::endl;
				e->numTab = 1;
			}
			else if (e->getLabel().compare("end_execution") == 0) {
				os << "\texecution end time : " << dynamic_cast<EndExecutionEvent*>(e)->getEndTime() << std::endl;
				e->numTab = 0;
			}
		}
		else
			traces.at(i)->display(os);
	}
	if (Trace::numTab > 0)
		Trace::numTab = 0;
}

std::vector<sp_trace> TracesParser::importTraceFromXml(const std::string& dir_path, const std::string& filename) {
	std::vector<sp_trace> traces;
	if (filename.find(".xml") == std::string::npos) {
		std::cout << "not a xml file" << std::endl;
		return traces;
	}
	std::stringstream ss;
	ss << dir_path << "\\" << filename;
	rapidxml::file<> xmlFile(ss.str().c_str());
    rapidxml::xml_document<> doc;
    doc.parse<0>(xmlFile.data());
	rapidxml::xml_node<> *root_node = doc.first_node("trace");
	if (root_node == 0)
		return traces;
	std::cout << "begin import from XML file " << ss.str().c_str() << std::endl;
	sp_trace spt;
	sp_sequence sps;
	std::stack<rapidxml::xml_node<> *> node_stack;
	std::stack<sp_sequence> seq_stack;
	rapidxml::xml_node<> *node = root_node->first_node();
	std::string node_name;
	while(node || !node_stack.empty()) {
		while (!node && !node_stack.empty()) {
			node = node_stack.top();
			node_name = node->name();
			if (node_name.compare("mission") == 0 && node->first_attribute("end_time") != 0) {
				spt = boost::make_shared<EndMissionEvent>(node->first_attribute("status")->value(),atoi(node->first_attribute("end_time")->value()));
				traces.push_back(spt);
			}
			else if (node_name.compare("execution") == 0 && node->first_attribute("end_time") != 0) {
				spt = boost::make_shared<EndExecutionEvent>(atoi(node->first_attribute("end_time")->value()));
				traces.push_back(spt);
			}
			else if (node_name.compare("sequence") == 0) {
				seq_stack.pop();
				if (!seq_stack.empty()) {
					seq_stack.top()->addTrace(sps);
					sps = seq_stack.top();
				}
				else
					traces.push_back(sps);
			}
			node = node_stack.top()->next_sibling();
			node_stack.pop();
		}
		if (node) {
			node_name = node->name();
			if (node_name.compare("mission") == 0) {
				spt = boost::make_shared<StartMissionEvent>(node->first_attribute("name")->value(),atoi(node->first_attribute("start_time")->value()));
				traces.push_back(spt);
				node_stack.push(node);
				node = node->first_node();
			}
			else if (node_name.compare("execution") == 0) {
				spt = boost::make_shared<NewExecutionEvent>(atoi(node->first_attribute("start_time")->value()));
				traces.push_back(spt);
				node_stack.push(node);
				node = node->first_node();
			}
			else if (node_name.compare("sequence") == 0) {
				sps = boost::make_shared<Sequence>();
				std::vector<std::string> tokens = splitLine(node->first_attribute("num_map")->value());
				for (unsigned int i = 0; i < tokens.size(); i++) {
					int pos = tokens.at(i).find(":",0);
					sps->updateNumMap(stoi(std::string(tokens.at(i).begin(),tokens.at(i).begin()+pos)),stoi(std::string(tokens.at(i).begin()+pos+1,tokens.at(i).end())));
				}
				seq_stack.push(sps);
				node_stack.push(node);
				node = node->first_node();
			}
			else {
				ss.str("");
				if (node->first_attribute("error") != 0)
					ss << node->first_attribute("error")->value() << " ";
				ss << node->first_attribute("label")->value();
				if (node->first_attribute("params") != 0)
					ss << " " << node->first_attribute("params")->value();
				if (node->first_attribute("return") != 0)
					ss << " - " << node->first_attribute("return")->value();
				sp_trace spt = handleLine(ss.str());
				if (!seq_stack.empty())
					sps->addTrace(spt);
				else
					traces.push_back(spt);
				node = node->next_sibling();
			}
		}
	}
	for (unsigned int i = 0; i < traces.size(); i++)
		traces.at(i)->display();
	std::cout << "end import from XML" << std::endl;
	return traces;
}

void TracesParser::exportTraceToXml() {
	rapidxml::xml_document<> doc;
	rapidxml::xml_node<>* dec = doc.allocate_node(rapidxml::node_declaration);
	dec->append_attribute(doc.allocate_attribute("version", "1.0"));
	dec->append_attribute(doc.allocate_attribute("encoding", "utf-8"));
	doc.append_node(dec);
	rapidxml::xml_node<>* root_node = doc.allocate_node(rapidxml::node_element, "trace");
	doc.append_node(root_node);
	std::stack<rapidxml::xml_node<> *> node_stack;
	node_stack.push(root_node);
	rapidxml::xml_node<> *node;
	std::stack<sp_sequence> seq_stack;
	sp_sequence sps;
	sp_trace spt;
	std::string s;
	unsigned int i = 0;
	bool pass = false;
	while (i < traces.size() || !seq_stack.empty()) {
		if (!seq_stack.empty()) {
			while (!seq_stack.empty() && sps->isEndReached()) {
				seq_stack.pop();
				node_stack.pop();
				if (!seq_stack.empty())
					sps = seq_stack.top();
			}
			if (!sps->isEndReached()) {
				spt = sps->next();
				pass = true;
			}
		}
		if (seq_stack.empty() && i < traces.size()) {
			spt = traces.at(i++);
			pass = true;
		}
		if (pass) {
			pass = false;
			if (spt->isEvent()) {
				Event *e = dynamic_cast<Event*>(spt.get());
				if (e->getLabel().compare("start_mission") == 0) {
					while (node_stack.size() > 1)
						node_stack.pop();
					StartMissionEvent *sme = dynamic_cast<StartMissionEvent*>(e);
					node = doc.allocate_node(rapidxml::node_element, "mission");
					node->append_attribute(doc.allocate_attribute("name", doc.allocate_string(sme->getMissionName().c_str())));
					node->append_attribute(doc.allocate_attribute("start_time", doc.allocate_string(boost::lexical_cast<std::string>(sme->getStartTime()).c_str())));
					node_stack.top()->append_node(node);
					node_stack.push(node);
				}
				else if (e->getLabel().compare("end_mission") == 0) {
					EndMissionEvent *eme = dynamic_cast<EndMissionEvent*>(e);
					if (node_stack.size() > 2)
						node_stack.pop();
					node_stack.top()->append_attribute(doc.allocate_attribute("end_time", doc.allocate_string(boost::lexical_cast<std::string>(eme->getEndTime()).c_str())));
					node_stack.top()->append_attribute(doc.allocate_attribute("status", doc.allocate_string(eme->getStatus().c_str())));
					node_stack.pop();
				}
				else if (e->getLabel().compare("new_execution") == 0) {
					if (node_stack.size() > 2)
						node_stack.pop();
					node = doc.allocate_node(rapidxml::node_element, "execution");
					node->append_attribute(doc.allocate_attribute("start_time", doc.allocate_string(boost::lexical_cast<std::string>(dynamic_cast<NewExecutionEvent*>(e)->getStartTime()).c_str())));
					node_stack.top()->append_node(node);
					node_stack.push(node);
				}
				else if (e->getLabel().compare("end_execution") == 0) {
					node_stack.top()->append_attribute(doc.allocate_attribute("end_time", doc.allocate_string(boost::lexical_cast<std::string>(dynamic_cast<EndExecutionEvent*>(e)->getEndTime()).c_str())));
					node_stack.pop();
				}
				else {
					node = doc.allocate_node(rapidxml::node_element, "event");
					node->append_attribute(doc.allocate_attribute("label", doc.allocate_string(e->getLabel().c_str())));
					node_stack.top()->append_node(node);
				}
			}
			else if (spt->isCall()) {
				Call *c = dynamic_cast<Call*>(spt.get());
				node = doc.allocate_node(rapidxml::node_element, "call");
				node->append_attribute(doc.allocate_attribute("label", doc.allocate_string(c->getLabel().c_str())));
				if (c->getError() != Call::NONE)
					node->append_attribute(doc.allocate_attribute("error", doc.allocate_string(Call::getErrorLabel(c->getError()))));
				s = c->getParams();
				if (s.compare("") != 0)
					node->append_attribute(doc.allocate_attribute("params", doc.allocate_string(s.c_str())));
				s = c->getReturn();
				if (s.compare("") != 0)
					node->append_attribute(doc.allocate_attribute("return", doc.allocate_string(s.c_str())));
				node_stack.top()->append_node(node);
			}
			else {
				sps = boost::dynamic_pointer_cast<Sequence>(spt);
				sps->reset();
				node = doc.allocate_node(rapidxml::node_element, "sequence");
				// node->append_attribute(doc.allocate_attribute("num", doc.allocate_string(boost::lexical_cast<std::string>(sps->getNum()).c_str())));
				node->append_attribute(doc.allocate_attribute("num_map", doc.allocate_string(sps->getNumMapString().c_str())));
				node_stack.top()->append_node(node);
				node_stack.push(node);
				seq_stack.push(sps);
			}
		}
	}
	s = "\\" + filename;
	s.replace(s.find(".log"), 4, "_compressed.xml");
	s.insert(0, dir_path);
	std::ofstream ofsXml(s.c_str(), std::ofstream::out | std::ofstream::trunc);
	if (ofsXml.good()) {
		ofsXml << doc;
		ofsXml.close();
	}
	doc.clear();
}

void TracesParser::setEnd() {
	end = true;
}

bool TracesParser::compressionDone() {
	if (compress) {
		compress = false;
		return true;
	}
	return false;
}

const std::vector<sp_trace>& TracesParser::getTraces() const {
	return traces;
}

std::vector<std::string> TracesParser::splitLine(const std::string& s, char delim) {
	std::vector<std::string> buf;
	std::stringstream ss(s);
	std::string subs;
	while(std::getline(ss, subs, delim)) {
		if (subs[subs.size()-1] == '\r' || subs[subs.size()-1] == '\n')
			subs.erase(subs.size()-1);
		buf.push_back(subs);
	}
	return buf;
}

int TracesParser::stoi(const std::string& s) {
	int res;
	//***
	if (s.compare("?") == 0)
		return -1;
	//***
	try {
		res = boost::lexical_cast<int>(s);
	}
	catch(const boost::bad_lexical_cast &) {
		std::cout << "error boost::lexical_cast<int>" << std::endl;
		exit(EXIT_FAILURE);
	}
	return res;
}

float TracesParser::stof(const std::string& s) {
	float res;
	//***
	if (s.compare("?") == 0)
		return -1;
	//***
	try {
		res = boost::lexical_cast<float>(s);
	}
	catch(const boost::bad_lexical_cast &) {
		std::cout << "error boost::lexical_cast<float>" << std::endl;
		exit(EXIT_FAILURE);
	}
	return res;
}
