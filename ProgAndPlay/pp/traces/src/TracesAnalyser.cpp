#include "TracesAnalyser.h"
#include "TracesParser.h"

// TracesAnalyser::feedback_type_bm TracesAnalyser::feedbackTypeBimap;
TracesAnalyser::left_fbt_map TracesAnalyser::leftFbtMap;
TracesAnalyser::right_fbt_map TracesAnalyser::rightFbtMap;

TracesAnalyser::TracesAnalyser(bool in_game) : in_game(in_game) {
	expert_traces_dirname = (in_game) ? IN_GAME_EXPERT_TRACES_DIRNAME : EXPERT_TRACES_DIRNAME;
	init();
}

void TracesAnalyser::init() {
	// Initialise feedbackTypeBimap
	// TracesAnalyser::feedbackTypeBimap.insert(feedback_type_bm::value_type(SEQ_EXTRA,"seq_extra"));
	// TracesAnalyser::feedbackTypeBimap.insert(feedback_type_bm::value_type(SEQ_LACK,"seq_lack"));
	// TracesAnalyser::feedbackTypeBimap.insert(feedback_type_bm::value_type(SEQ_NUM,"seq_num"));
	// TracesAnalyser::feedbackTypeBimap.insert(feedback_type_bm::value_type(CALL_EXTRA,"call_extra"));
	// TracesAnalyser::feedbackTypeBimap.insert(feedback_type_bm::value_type(CALL_LACK,"call_lack"));
	// TracesAnalyser::feedbackTypeBimap.insert(feedback_type_bm::value_type(CALL_PARAMS,"call_params"));
	
	// Initialise leftFbtMap
	TracesAnalyser::leftFbtMap.insert(std::make_pair<FeedbackType,std::string>(USEFUL_CALL,"useful_call"));
	TracesAnalyser::leftFbtMap.insert(std::make_pair<FeedbackType,std::string>(USELESS_CALL,"useless_call"));
	TracesAnalyser::leftFbtMap.insert(std::make_pair<FeedbackType,std::string>(SEQ_EXTRA,"seq_extra"));
	TracesAnalyser::leftFbtMap.insert(std::make_pair<FeedbackType,std::string>(SEQ_LACK,"seq_lack"));
	TracesAnalyser::leftFbtMap.insert(std::make_pair<FeedbackType,std::string>(SEQ_NUM,"seq_num"));
	TracesAnalyser::leftFbtMap.insert(std::make_pair<FeedbackType,std::string>(CALL_EXTRA,"call_extra"));
	TracesAnalyser::leftFbtMap.insert(std::make_pair<FeedbackType,std::string>(CALL_LACK,"call_lack"));
	TracesAnalyser::leftFbtMap.insert(std::make_pair<FeedbackType,std::string>(CALL_PARAMS,"call_params"));
	
	// Initialise rightFbtMap
	TracesAnalyser::rightFbtMap.insert(std::make_pair<std::string,FeedbackType>("useful_call",USEFUL_CALL));
	TracesAnalyser::rightFbtMap.insert(std::make_pair<std::string,FeedbackType>("useless_call",USELESS_CALL));
	TracesAnalyser::rightFbtMap.insert(std::make_pair<std::string,FeedbackType>("seq_extra",SEQ_EXTRA));
	TracesAnalyser::rightFbtMap.insert(std::make_pair<std::string,FeedbackType>("seq_lack",SEQ_LACK));
	TracesAnalyser::rightFbtMap.insert(std::make_pair<std::string,FeedbackType>("seq_num",SEQ_NUM));
	TracesAnalyser::rightFbtMap.insert(std::make_pair<std::string,FeedbackType>("call_extra",CALL_EXTRA));
	TracesAnalyser::rightFbtMap.insert(std::make_pair<std::string,FeedbackType>("call_lack",CALL_LACK));
	TracesAnalyser::rightFbtMap.insert(std::make_pair<std::string,FeedbackType>("call_params",CALL_PARAMS));
	
	// Fill feedbacks_ref
	importFeedbacksFromXml();
	importFeedbacksFromExperts();
	std::cout << "num feedbacks : " << feedbacks_ref.size() << std::endl;
	std::sort(feedbacks_ref.begin(), feedbacks_ref.end());
}

// Add new feedbacks in the feedbacks list from xml file
void TracesAnalyser::importFeedbacksFromXml() {
	std::string filename = FEEDBACKS_FILENAME;
	if (in_game)
		filename.insert(0,IN_GAME_DATA_DIRNAME);
	rapidxml::file<> xmlFile(filename.c_str());
    rapidxml::xml_document<> doc;
    doc.parse<0>(xmlFile.data());
	rapidxml::xml_node<> *root_node = doc.first_node("feedbacks");
	if (root_node != 0) {
		for (rapidxml::xml_node<> *feedback_node = root_node->first_node(); feedback_node; feedback_node = feedback_node->next_sibling()) {
			Feedback f;
			f.type = rightFbtMap.at(std::string(feedback_node->first_attribute("type")->value()));
			f.priority = std::atoi(feedback_node->first_attribute("priority")->value());
			rapidxml::xml_node<> *node = feedback_node->first_node("infos");
			if (node != 0) {
				int r = getRandomIntInRange(0,TracesParser::getNodeChildCount(node));
				for (rapidxml::xml_node<> *info_node = node->first_node(); info_node; info_node = info_node->next_sibling(), r--) {
					if (r == 0)
						f.info = info_node->value();
				}
			}
			node = feedback_node->first_node("learner");
			if (node != 0) {
				if (TracesParser::getNodeChildCount(node) == 1) {
					std::vector<Trace::sp_trace> traces;
					TracesParser::importTraceFromNode(node->first_node(),traces);
					f.learner_spt = traces.at(0);
				}
				else
					throw std::runtime_error("learner node can have only one trace");
			}
			node = feedback_node->first_node("expert");
			if (node != 0) {
				if (TracesParser::getNodeChildCount(node) == 1) {
					std::vector<Trace::sp_trace> traces;
					TracesParser::importTraceFromNode(node->first_node(),traces);
					f.expert_spt = traces.at(0);
				}
				else
					throw std::runtime_error("expert node can have only one trace");
			}
			feedbacks_ref.push_back(f);
		}
	}
}

int TracesAnalyser::getRandomIntInRange(int min, int max) {
	if (min > max)
		return 0;
	if (min == max)
		return min;
	srand(time(NULL));
	return rand() % max + min;
}

void TracesAnalyser::importFeedbacksFromExperts() {
	
}

std::string TracesAnalyser::getFeedback(const std::string& dir_path, const std::string& filename, int ind_mission, int ind_execution) {
	int ind_best = -1;
	double best_score = 0;
	std::vector<Trace::sp_trace> learner_traces = TracesParser::importTraceFromXml(dir_path, filename);
	if (!getInfosOnMission(learner_traces, learner_gi, ind_mission) || !getInfosOnExecution(learner_gi, ind_execution))
		return "";
	std::vector<std::string> files = findExpertTracesFilenames();
	bool reimport = false;
	for(unsigned int i = 0; i < files.size(); i++) {
		if (reimport) {
			learner_traces = TracesParser::importTraceFromXml(dir_path, filename);
			getInfosOnMission(learner_traces, learner_gi, ind_mission);
			getInfosOnExecution(learner_gi, ind_execution);
		}
		std::vector<Trace::sp_trace> expert_traces = TracesParser::importTraceFromXml(expert_traces_dirname + "\\" + learner_gi.sme->getMissionName(), files.at(i));
		if (getInfosOnMission(expert_traces, expert_gi) && getInfosOnExecution(expert_gi)) {
			if (!learner_gi.exec_traces.empty() && !expert_gi.exec_traces.empty()) {
				Call::call_vector expert_calls = Call::getCalls(expert_gi.exec_traces,true);
				for (unsigned int j = 0; j < expert_calls.size(); j++) {
					if (experts_calls_freq.find(expert_calls.at(j)->getLabel()) != experts_calls_freq.end())
						experts_calls_freq.at(expert_calls.at(j)->getLabel())++;
					else
						experts_calls_freq.insert(std::make_pair<std::string,double>(expert_calls.at(j)->getLabel(),1));
				}
				reimport = addImplicitSequences(learner_gi.exec_traces, expert_gi.exec_traces);
				if (reimport) {
					std::cout << "learner traces have been modified" << std::endl;
					for (unsigned int j = 0; j < learner_gi.exec_traces.size(); j++)
						learner_gi.exec_traces.at(j)->display();
				}
				else
					std::cout << "learner traces have not been modified" << std::endl;
				if (addImplicitSequences(expert_gi.exec_traces, learner_gi.exec_traces)) {
					std::cout << "expert traces have been modified" << std::endl;
					for (unsigned int j = 0; j < expert_gi.exec_traces.size(); j++)
						expert_gi.exec_traces.at(j)->display();
				}
				else
					std::cout << "expert traces have not been modified" << std::endl;
				double score = findBestAlignment(learner_gi.exec_traces, expert_gi.exec_traces) / std::max(Trace::getLength(learner_gi.exec_traces),Trace::getLength(expert_gi.exec_traces));
				displayAlignment(learner_gi.exec_traces, expert_gi.exec_traces);
				std::cout << "similarity score : " << score << std::endl;
				if (score >= best_score) {
					best_score = score;
					ind_best = i;
				}
			}
		}
	}
	if (ind_best > -1) {
		std::map<std::string,double>::iterator it = experts_calls_freq.begin();
		while (it != experts_calls_freq.end())
			(it++)->second /= files.size();
		std::cout << files.at(ind_best) << " has been chosen for alignment with learner traces" << std::endl;
		std::cout << "similarity score : " << best_score << std::endl;
		std::vector<Trace::sp_trace> expert_traces = TracesParser::importTraceFromXml(expert_traces_dirname + "\\" + learner_gi.sme->getMissionName(), files.at(ind_best));
		if (getInfosOnMission(expert_traces, expert_gi) && getInfosOnExecution(expert_gi)) {
			addImplicitSequences(learner_gi.exec_traces, expert_gi.exec_traces);
			addImplicitSequences(expert_gi.exec_traces, learner_gi.exec_traces);
			findBestAlignment(learner_gi.exec_traces, expert_gi.exec_traces);
			displayAlignment(learner_gi.exec_traces, expert_gi.exec_traces);
			if (learner_gi.eee != NULL) {
				std::cout << "Temps d'execution de la derniere tentative : " << learner_gi.getExecutionTime() << "s" << std::endl;
				std::cout << "Temps d'execution reference : " << expert_gi.getExecutionTime() << "s" << std::endl;
			}
			if (learner_gi.eme != NULL) {
				std::cout << "Nombre de tentatives : " << learner_gi.getNumExecutions() << std::endl;
				double wait_time = learner_gi.getAverageWaitTime();
				if (wait_time != -1)
					std::cout << "Temps d'attente moyen entre deux tentatives : " << wait_time << "s" << std::endl;
				std::cout << "Temps de resolution de la mission : " << learner_gi.getResolutionTime() << "s" << std::endl;
				std::cout << "Temps de resolution reference : " << expert_gi.getResolutionTime() << "s" << std::endl;
				if (learner_gi.eme->getStatus().compare("won") == 0)
					std::cout << "Mission accomplie" << std::endl;
				else
					std::cout << "Echec de la mission" << std::endl;
			}
			std::cout << "Score : " << best_score * 100 << "/100" << std::endl << std::endl;
			std::map<std::string,double>::const_iterator it = experts_calls_freq.begin();
			while (it != experts_calls_freq.end()) {
				std::cout << "label : " << it->first << std::endl;
				std::cout << "freq : " << it->second << std::endl;
				it++;
			}
			std::cout << std::endl;
			std::vector<Feedback> feedbacks;
			listFeedbacks(learner_gi.exec_traces, expert_gi.exec_traces, feedbacks);
			sortFeedbacks(feedbacks);
			if (!feedbacks.empty()) {
				feedbacks.at(0).display();
				return feedbacks.at(0).info;
			}
			else
				std::cout << "no feedback" << std::endl;
		}
	}
	return "";
}

bool TracesAnalyser::getInfosOnMission(const std::vector<Trace::sp_trace>& traces, GameInfos& gi, int ind_mission) {
	if (!traces.empty()) {
		unsigned int i;
		int ind_start = 1, ind_end, cpt_mission = 0;
		for (i = 1; i < traces.size(); i++) {
			if (traces.at(i)->isEvent() && dynamic_cast<Event*>(traces.at(i).get())->getLabel().compare("start_mission") == 0) {
				ind_end = i;
				if (cpt_mission == ind_mission)
					break;
				else {
					cpt_mission++;
					ind_start = i+1;
				}
			}
		}
		if (cpt_mission == ind_mission || ind_mission == -1) {
			gi.clearMission();
			if (i == traces.size())
				ind_end = traces.size();
			gi.sme = dynamic_cast<StartMissionEvent*>(traces.at(ind_start-1).get());
			if (traces.at(ind_end-1)->isEvent() && dynamic_cast<Event*>(traces.at(ind_end-1).get())->getLabel().compare("end_mission") == 0) {
				ind_end--;
				gi.eme = dynamic_cast<EndMissionEvent*>(traces.at(ind_end).get());
			}
			if (ind_start < ind_end)
				gi.mission_traces.assign(traces.begin() + ind_start, traces.begin() + ind_end);
			return true;
		}
	}
	return false;
}

bool TracesAnalyser::getInfosOnExecution(GameInfos& gi, int ind_execution) {
	const std::vector<Trace::sp_trace>& m_traces = gi.mission_traces;
	if (!m_traces.empty()) {
		unsigned int i;
		int ind_start = 0, ind_end = 0, cpt_execution = 0;
		for (i = 0; i < m_traces.size(); i++) {
			if (m_traces.at(i)->isEvent() && dynamic_cast<Event*>(m_traces.at(i).get())->getLabel().compare("new_execution") == 0) {
				ind_end = i;
				if (gi.eme == NULL || dynamic_cast<NewExecutionEvent*>(m_traces.at(i).get())->getStartTime() < gi.eme->getEndTime()) {
					if (cpt_execution == ind_execution && i != 0)
						break;
					else {
						if (i != 0)
							cpt_execution++;
						ind_start = i+1;
					}
				}
				else
					break;
			}
		}
		if (ind_start != 0 && (cpt_execution == ind_execution || ind_execution == -1)) {
			gi.clearExecution();
			if (i == m_traces.size())
				ind_end = m_traces.size();
			gi.nee = dynamic_cast<NewExecutionEvent*>(m_traces.at(ind_start-1).get());
			if (m_traces.at(ind_end-1)->isEvent() && dynamic_cast<Event*>(m_traces.at(ind_end-1).get())->getLabel().compare("end_execution") == 0) {
				ind_end--;
				gi.eee = dynamic_cast<EndExecutionEvent*>(m_traces.at(ind_end).get());
			}
			if (ind_start < ind_end)
				gi.exec_traces.assign(m_traces.begin() + ind_start, m_traces.begin() + ind_end);
			return true;
		}
	}
	return false;
}

std::vector<std::string> TracesAnalyser::findExpertTracesFilenames() {
	std::vector<std::string> files;
	std::string s = expert_traces_dirname + "\\" + learner_gi.sme->getMissionName();
	DIR *pdir;
	struct dirent *pent;
	pdir = opendir(s.c_str());
	if (pdir) {
		while ((pent = readdir(pdir))) {
			s = pent->d_name;
			if (s.find(".xml") != std::string::npos)
				files.push_back(s);
		}
	}
	closedir(pdir);
	return files;
}

bool TracesAnalyser::addImplicitSequences(std::vector<Trace::sp_trace>& mod, const std::vector<Trace::sp_trace>& ref) {
	std::cout << "mod : " << std::endl;
	for (unsigned int i = 0; i < mod.size(); i++)
		mod.at(i)->display();
	std::cout << std::endl;
	std::cout << "ref : " << std::endl;
	for (unsigned int i = 0; i < ref.size(); i++)
		ref.at(i)->display();
	std::cout << std::endl;
	std::stack<Sequence::sp_sequence> stack;
	Trace::sp_trace spt;
	Sequence::sp_sequence sps;
	unsigned int i = 0;
	bool pass = false, change = false;
	while(i < ref.size() || !stack.empty()) {
		if (!stack.empty()) {
			while (!stack.empty() && sps->isEndReached()) {
				stack.pop();
				if (!stack.empty())
					sps = stack.top();
			}
			if (!sps->isEndReached()) {
				spt = sps->next();
				if (spt->isSequence())
					pass = true;
			}
		}
		if (stack.empty() && i < ref.size()) {
			spt = ref.at(i++);
			if (spt->isSequence())
				pass = true;
		}
		if (pass) {
			pass = false;
			sps = boost::dynamic_pointer_cast<Sequence>(spt);
			stack.push(sps);
			std::cout << "sps" << std::endl;
			sps->display();
			Call::call_vector pattern = Call::getCalls(sps->getTraces());
			std::vector<Call::call_vector> patterns = getPatterns(mod,pattern);
			std::cout << "patterns size : " << patterns.size() << std::endl;
			for (unsigned int j = 0; j < patterns.size(); j++) {
				const Sequence::sp_sequence common_parent = getClosestCommonParent(patterns.at(j));
				std::vector<Trace::sp_trace> *t = &mod;
				if (common_parent) {
					std::cout << "common parent is a sequence" << std::endl;
					common_parent->display();
				}
				else
					std::cout << "common parent is root" << std::endl;
				if (common_parent && common_parent->getLevel() == sps->getLevel()-1 && common_parent->length() > sps->length()) {
					t = &common_parent->getTraces();
					pass = true;
				}
				else if (!common_parent && sps->getLevel() == 0)
					pass = true;
				if (pass) {
					std::cout << "pass : " << std::endl;
					pass = false;
					change = true;
					Sequence::sp_sequence new_sps = boost::make_shared<Sequence>(1);		
					std::vector<Trace::sp_trace> adds;
					for (unsigned int p = 0; p < patterns.at(j).size(); p++) {
						Trace::sp_trace add = patterns.at(j).at(p);
						Sequence::sp_sequence parent = boost::dynamic_pointer_cast<Sequence>(add->getParent());
						while (parent != common_parent) {
							add = parent;
							parent = boost::dynamic_pointer_cast<Sequence>(parent->getParent());
						}
						if (std::find(adds.begin(), adds.end(), add) == adds.end())
							adds.push_back(add);
					}
					for (unsigned int p = 0, h = 0; p < adds.size();) {
						if (t->at(h) == adds.at(p)) {
							p++;
							if (!pass)
								pass = true;
						}
						if (pass) {
							new_sps->addTrace(t->at(h));
							t->at(h)->setParent(new_sps);
							t->erase(t->begin()+h);
							if (p == 1) {
								t->insert(t->begin()+h,new_sps);
								if (common_parent)
									new_sps->setParent(common_parent);
								h++;
							}
						}
						else
							h++;
					}
					pass = false;
					std::cout << "new t : " << std::endl;
					for (unsigned int p = 0; p < t->size(); p++)
						t->at(p)->display();
					if (common_parent) {
						std::cout << "common_parent traces -> must be same as t : " << std::endl;
						for (unsigned int p = 0; p < common_parent->getTraces().size(); p++)
							common_parent->getTraces().at(p)->display();
					}
				}
			}
		}
	}
	return change;
}

std::vector<Call::call_vector> TracesAnalyser::getPatterns(const std::vector<Trace::sp_trace>& mod, const Call::call_vector& pattern) {
	std::vector<Call::call_vector> patterns;
	Call::call_vector vc = Call::getCalls(mod);
	for (unsigned int i = 0; i < vc.size(); i++) {
		int ind = (int)i;
		for (unsigned int j = 0; ind > -1 && j < pattern.size(); j++) {
			double match_score = 1 - vc.at(ind)->getEditDistance(pattern.at(j).get());
			match_score = TRANSFORM_SCORE(match_score);
			ind = (match_score <= 0) ? -1 : ind + 1;
		}
		if (ind > -1) {
			std::cout << "new pattern found in mod at ind " << i << std::endl;
			Call::call_vector v;
			for (unsigned int j = i; j < i + pattern.size(); j++)
				v.push_back(vc.at(j));
			patterns.push_back(v);
			i += pattern.size()-1;
		}
	}
	return patterns;
}

const Sequence::sp_sequence TracesAnalyser::getClosestCommonParent(const Call::call_vector& pattern) {
	Sequence::sp_sequence parents[pattern.size()];
	bool same = true;
	for (unsigned int i = 0; i < pattern.size(); i++) {
		parents[i] = boost::dynamic_pointer_cast<Sequence>(pattern.at(i)->getParent());
		if (!parents[i])
			return parents[i]; //root is the closest common parent
		if (i > 0 && parents[i] != parents[i-1])
			same = false;
	}
	while (!same) {
		unsigned int ind_max = 0, max_level = parents[0]->getLevel();
		for (unsigned int i = 1; i < pattern.size(); i++) {
			//parents[i] cannot be NULL here
			unsigned int level = parents[i]->getLevel();
			if (level > max_level) {
				max_level = level;
				ind_max = i;
			}
		}
		parents[ind_max] = boost::dynamic_pointer_cast<Sequence>(parents[ind_max]->getParent());
		if (!parents[ind_max])
			return parents[ind_max]; //root is the closest common parent
		same = true;
		for (unsigned int i = 0; i < pattern.size()-1; i++) {
			if (parents[i] != parents[i+1])
				same = false;
		}
	}
	return parents[0];
}

double TracesAnalyser::findBestAlignment(const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e, bool align) {
	int cpt_path = 0;
	unsigned int lsize = l.size()+1, esize = e.size()+1;
	double score = 0;
	std::pair<double,double>** val = new std::pair<double,double>*[lsize];
	std::pair<int,int>** ind = new std::pair<int,int>*[lsize];
	char** help = new char*[lsize];
	std::cout << "begin findBestAlignment" << std::endl;
	for (unsigned int i = 0; i < l.size(); i++) {
		l.at(i)->display();
		if (align)
			l.at(i)->resetAligned();
	}
	std::cout << std::endl;
	for (unsigned int j = 0; j < e.size(); j++) {
		e.at(j)->display();
		if (align)
			e.at(j)->resetAligned();
	}
	std::cout << std::endl;
	for (unsigned int i = 0; i < lsize; i++) {
		val[i] = new std::pair<double,double>[esize];
		ind[i] = new std::pair<int,int>[esize];
		help[i] = new char[esize];
	}
	for (unsigned int i = 0; i < lsize; i++) {
		val[i][0] = std::make_pair<double,double>(ALIGN_GAP_SCORE * i, 0);
		ind[i][0] = std::make_pair<int,int>(i-1,0);
		help[i][0] = 'h';
	}
	for (unsigned int j = 1; j < esize; j++) {
		val[0][j] = std::make_pair<double,double>(ALIGN_GAP_SCORE * j, 0);
		ind[0][j] = std::make_pair<int,int>(0,j-1);
		help[0][j] = 'g';
	}
	for (unsigned int i = 1; i < lsize; i++) {
		for (unsigned int j = 1; j < esize; j++) {
			if (l.at(i-1)->isEvent()) {
				val[i][j] = std::make_pair<double,double>(val[i-1][j].first + ALIGN_GAP_SCORE, 0);
				help[i][j] = 'h';
				ind[i][j] = std::make_pair<int,int>(i-1,j);
				continue;
			}
			if (e.at(j-1)->isEvent()) {
				val[i][j] = std::make_pair<double,double>(val[i][j-1].first + ALIGN_GAP_SCORE, 0);
				help[i][j] = 'g';
				ind[i][j] = std::make_pair<int,int>(i,j-1);
				continue;
			}
			val[i][j] = std::make_pair<double,double>(0,0);
			ind[i][j] = std::make_pair<int,int>(i-1,j-1);
			double match_score = 0;
			if (l.at(i-1)->isCall() && e.at(j-1)->isCall()) {
				Call *cl = dynamic_cast<Call*>(l.at(i-1).get());
				Call *ce = dynamic_cast<Call*>(e.at(j-1).get());
				match_score = 1 - cl->getEditDistance(ce);
				val[i][j].second = match_score;
				match_score = TRANSFORM_SCORE(match_score);
			}
			else if (l.at(i-1)->isSequence() && e.at(j-1)->isSequence()) {
				Sequence *sl = dynamic_cast<Sequence*>(l.at(i-1).get());
				Sequence *se = dynamic_cast<Sequence*>(e.at(j-1).get());
				match_score = findBestAlignment(sl->getTraces(),se->getTraces(),align);
				val[i][j].second = match_score;
				match_score /= std::max(sl->length(),se->length());
				match_score = TRANSFORM_SCORE(match_score);
			}
			else
				match_score = ALIGN_MISMATCH_SCORE;
			val[i][j].first = val[i-1][j-1].first + match_score;
			help[i][j] = 'd';
			if (val[i-1][j].first + ALIGN_GAP_SCORE > val[i][j].first && val[i-1][j].first + ALIGN_GAP_SCORE > val[i][j-1].first + ALIGN_GAP_SCORE) {
				val[i][j].first = val[i-1][j].first + ALIGN_GAP_SCORE;
				ind[i][j].second++;
				help[i][j] = 'h';
			}
			else if (val[i][j-1].first + ALIGN_GAP_SCORE > val[i][j].first) {
				val[i][j].first = val[i][j-1].first + ALIGN_GAP_SCORE;
				ind[i][j].first++;
				help[i][j] = 'g';
			}
			if ((ind[i][j].first == (int)i || ind[i][j].second == (int)j) && val[i][j].second > 0)
				val[i][j].second = 0;
			if ((val[i][j].first == val[i-1][j].first + ALIGN_GAP_SCORE && val[i][j].first >= val[i][j-1].first + ALIGN_GAP_SCORE) || (val[i][j].first == val[i][j-1].first + ALIGN_GAP_SCORE && val[i][j].first > val[i-1][j].first + ALIGN_GAP_SCORE) || (val[i-1][j].first + ALIGN_GAP_SCORE == val[i][j-1].first + ALIGN_GAP_SCORE && val[i][j-1].first + ALIGN_GAP_SCORE > val[i][j].first))
				cpt_path++;
		}
	}
	for (unsigned int i = 0; i < lsize; i++) {
		for (unsigned int j = 0; j < esize; j++)
			std::cout << "(" << val[i][j].first << "," << val[i][j].second << ")\t";
		std::cout << std::endl;
	}
	std::cout << std::endl;
	for (unsigned int i = 0; i < lsize; i++) {
		for (unsigned int j = 0; j < esize; j++)
			std::cout << "(" << ind[i][j].first << "," << ind[i][j].second << ")\t";
		std::cout << std::endl;
	}
	std::cout << std::endl;
	for (unsigned int i = 0; i < lsize; i++) {
		for (unsigned int j = 0; j < esize; j++)
			std::cout << help[i][j] << "\t";
		std::cout << std::endl;
	}
	std::cout << std::endl;
	TracesAnalyser::path p;
	std::pair<int,int> pind = ind[lsize-1][esize-1];
	score += val[lsize-1][esize-1].second;
	while(pind.first >= 0 && pind.second >= 0) {
		p.push_back(pind);
		score += val[pind.first][pind.second].second;
		pind = ind[pind.first][pind.second];
	}
	std::reverse(p.begin(),p.end());
	std::cout << "path : ";
	for (unsigned int i = 0; i < p.size(); i++)
		std::cout << "(" << p.at(i).first << "," << p.at(i).second << ") ";
	std::cout << std::endl;
	if (align) {
		std::cout << "path found - final alignment" << std::endl;
		for (unsigned int i = 0; i < p.size(); i++) {
			int indi = p.at(i).first, indj = p.at(i).second;
			if ((i < p.size()-1 && indi == p.at(i+1).first) || indi >= (int)l.size())
				e.at(indj)->resetAligned();
			else if ((i < p.size()-1 && indj == p.at(i+1).second) || indj >= (int)e.size()) 
				l.at(indi)->resetAligned();
			else {
				if (l.at(indi)->isSequence() && e.at(indj)->isSequence())
					findBestAlignment(dynamic_cast<Sequence*>(l.at(indi).get())->getTraces(), dynamic_cast<Sequence*>(e.at(indj).get())->getTraces());
				l.at(indi)->setAligned(e.at(indj));
				e.at(indj)->setAligned(l.at(indi));
			}
		}
	}
	if (cpt_path == 0)
		std::cout << "only one path" << std::endl;
	else
		std::cout << "more than one path" << std::endl;
	for (unsigned int i = 0; i < lsize; i++) {
		delete[] val[i];
		delete[] ind[i];
		delete[] help[i];
	}
	delete[] val;
	delete[] ind;
	delete[] help;
	std::cout << "end findBestAlignment" << std::endl;
	return score;
}

void TracesAnalyser::displayAlignment(const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e) {
	unsigned int i = 0, j = 0;
	while (i < l.size() || j < e.size()) {
		if (i < l.size() && j < e.size() && l.at(i)->getAligned() && e.at(j)->getAligned()) {
			l.at(i)->display();
			std::cout << "with" << std::endl;
			l.at(i)->getAligned()->display(); //l.at(i)->aligned is equal to e.at(j) in this case
			if (l.at(i)->isSequence() && l.at(i)->getAligned()->isSequence()) {
				std::cout << "enter both sequence" << std::endl;
				displayAlignment(dynamic_cast<Sequence*>(l.at(i).get())->getTraces(), dynamic_cast<Sequence*>(l.at(i)->getAligned().get())->getTraces());
				std::cout << "exit both sequence" << std::endl;
			}
			i++;
			j++;
		}
		else if (i < l.size() && !l.at(i)->getAligned()) {
			l.at(i++)->display();
			std::cout << "with" << std::endl;
			std::cout << "\t-" << std::endl;
		}
		else if (j < e.size() && !e.at(j)->getAligned()) {
			std::cout << "\t-" << std::endl;
			std::cout << "with" << std::endl;
			e.at(j++)->display();
		}
		std::cout << std::endl;
	}
}

void TracesAnalyser::sortFeedbacks(std::vector<Feedback>& feedbacks) {
	std::cout << "sort feedbacks" << std::endl;
	if (!feedbacks.empty()) {
		for (unsigned int i = 0; i < feedbacks.size(); i++) {
			int ind_max = -1;
			double max_score = 0;
			for (unsigned int j = 0; j < feedbacks_ref.size(); j++) {
				if (feedbacks.at(i).type == feedbacks_ref.at(j).type) {
					double score = (feedbacks_ref.at(j).learner_spt || feedbacks_ref.at(j).expert_spt) ? feedbacks.at(i).getScore(feedbacks_ref.at(j)) : 0;
					if (score >= max_score) {
						max_score = score;
						ind_max = j;
					}
				}
				// std::cout << "---" << std::endl;
				// feedbacks.at(i).display();
				// std::cout << std::endl;
				// feedbacks_ref.at(j).display();
				// std::cout << std::endl;
				// std::cout << "score :" << max_score << std::endl;
				// std::cout << "---" << std::endl;
			}
			feedbacks.at(i).priority = feedbacks_ref.at(ind_max).priority;
			setFeedbackInfo(feedbacks.at(i),feedbacks_ref.at(ind_max));
		}
		std::sort(feedbacks.begin(), feedbacks.end());
	}
}

void TracesAnalyser::setFeedbackInfo(Feedback& f, const Feedback& f_ref) {
	if (!f_ref.info.empty()) {
		// the referenced feedback has an associated info. we can use it.
		f.info = f_ref.info;
		std::vector<std::string> tokens = TracesParser::splitLine(f.info,'*');
		f.info = "";
		for (unsigned int i = 0; i < tokens.size(); i++) {
			if (tokens.at(i).compare("label") == 0) {
				std::string& s = tokens.at(i);
				Call::sp_call spc; 
				if (f.learner_spt && f.learner_spt->isCall())
					spc = boost::dynamic_pointer_cast<Call>(f.learner_spt);
				else if (f.expert_spt && f.expert_spt->isCall())
					spc = boost::dynamic_pointer_cast<Call>(f.expert_spt);
				if (spc)
					s = spc->getLabel();
			}
			else if (tokens.at(i).compare("diff_params") == 0) {
				
			}
			f.info += tokens.at(i);
		}
	}
}

void TracesAnalyser::listFeedbacks(const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e, std::vector<Feedback>& feedbacks) {
	// feedbacks from all experts
	Call::call_vector learner_calls = Call::getCalls(l,true);
	for (unsigned int i = 0; i < learner_calls.size(); i++) {
		if (experts_calls_freq.find(learner_calls.at(i)->getLabel()) == experts_calls_freq.end() || experts_calls_freq.at(learner_calls.at(i)->getLabel()) <= USELESS_FREQ) {
			Feedback f;
			f.type = USELESS_CALL;
			f.learner_spt = learner_calls.at(i);
			f.priority = -1;
			feedbacks.push_back(f);
		}
	}
	std::map<std::string,double>::const_iterator it = experts_calls_freq.begin();
	while (it != experts_calls_freq.end()) {
		if (it->second >= USEFUL_FREQ) {
			bool found = false;
			for (unsigned int i = 0; !found && i < learner_calls.size(); i++) {
				if (learner_calls.at(i)->getLabel().compare(it->first) == 0)
					found = true;
			}
			if (!found) {
				Feedback f;
				f.type = USEFUL_CALL;
				f.expert_spt = TracesParser::handleLine(it->first);
				f.priority = -1;
				feedbacks.push_back(f);
			}
		}
		it++;
	}
	// feedbacks from alignment with the chosen expert
	for (unsigned int i = 0; i < l.size(); i++) {
		if (!l.at(i)->isEvent()) {
			Feedback f;
			f.type = NONE;
			if (!l.at(i)->getAligned())
				f.type = (l.at(i)->isSequence()) ? SEQ_EXTRA : CALL_EXTRA;
			else if (l.at(i)->isSequence()) {
				Sequence::sp_sequence learner_sps = boost::dynamic_pointer_cast<Sequence>(l.at(i));
				Sequence::sp_sequence expert_sps = boost::dynamic_pointer_cast<Sequence>(l.at(i)->getAligned());
				if (learner_sps->isImplicit())
					f.type = SEQ_LACK;
				else if (expert_sps->isImplicit())
					f.type = SEQ_EXTRA;
				else {
					double cos_dis = Sequence::getNumMapsCosDistance(learner_sps->getPercentageNumMap(),expert_sps->getPercentageNumMap());
					if (cos_dis < 0.5)
						f.type = SEQ_NUM;
				}
				listFeedbacks(learner_sps->getTraces(), expert_sps->getTraces(), feedbacks);
			}
			else {
				Call::sp_call learner_call = boost::dynamic_pointer_cast<Call>(l.at(i));
				Call::sp_call expert_call = boost::dynamic_pointer_cast<Call>(l.at(i)->getAligned());
				double match_score = 1 - learner_call->getEditDistance(expert_call.get());
				if (match_score < 1)
					f.type = CALL_PARAMS;
			}
			if (f.type != NONE) {
				f.learner_spt = l.at(i);
				if (l.at(i)->getAligned())
					f.expert_spt = l.at(i)->getAligned();
				f.priority = -1;
				feedbacks.push_back(f);
			}
		}
	}
	for (unsigned int i = 0; i < e.size(); i++) {
		if (!e.at(i)->getAligned() && !e.at(i)->isEvent()) {
			Feedback f;
			f.expert_spt = e.at(i);
			f.type = (e.at(i)->isSequence()) ? SEQ_LACK : CALL_LACK;
			f.priority = -1;
			feedbacks.push_back(f);
		}
	}
	for (unsigned int i = 0; i < feedbacks.size(); i++) {
		feedbacks.at(i).display();
	}
}