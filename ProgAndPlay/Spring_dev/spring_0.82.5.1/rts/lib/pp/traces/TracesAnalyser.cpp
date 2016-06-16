#include "TracesAnalyser.h"
#include "TracesParser.h"
#include "constantList_KP4.4.h"

const char* TracesAnalyser::feedbackTypesArr[] = {"useful_call", "useless_call", "seq_extra", "seq_lack", "ind_seq_num", "dist_seq_num", "call_extra", "call_lack", "call_params", "include_call_in_seq", "exclude_call_from_seq", NULL};
std::map<int,std::string> TracesAnalyser::units_id_map;
std::map<int,std::string> TracesAnalyser::orders_map;
std::map<int,std::string> TracesAnalyser::resources_map;
std::map<std::string,std::string> TracesAnalyser::messages_map;

TracesAnalyser::TracesAnalyser(bool in_game, bool endless_loop, std::string lang) : in_game(in_game), endless_loop(endless_loop), lang(lang) {
	expert_traces_dirname = (in_game) ? IN_GAME_EXPERT_TRACES_DIRNAME : EXPERT_TRACES_DIRNAME;
	
	//Initialise units_id_map
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(ASSEMBLER,(lang == "fr") ? "ASSEMBLEUR" : "ASSEMBLER"));
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(BADBLOCK,"BADBLOCK"));
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(BIT,"BIT"));
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(BYTE,(lang == "fr") ? "OCTET" : "BYTE"));
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(KERNEL,(lang == "fr") ? "NOYAU" : "KERNEL"));
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(LOGIC_BOMB,(lang == "fr") ? "BOMBE LOGIQUE" : "LOGIC BOMB"));
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(POINTER,(lang == "fr") ? "POINTEUR" : "POINTER"));
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(SIGNAL,"SIGNAL"));
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(SOCKET,"SOCKET"));
	TracesAnalyser::units_id_map.insert(std::make_pair<int,std::string>(TERMINAL,"TERMINAL"));
	
	//Initialise orders_map
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(WAIT,(lang == "fr") ? "ATTENTE" : "WAIT"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(FIRE_STATE,"FIRE STATE"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(SELF_DESTRUCTION,(lang == "fr") ? "AUTODESTRUCTION" : "SELF DESTRUCTION"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(REPEAT,(lang == "fr") ? "REPETER" : "REPEAT"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(MOVE,(lang == "fr") ? "DEPLACEMENT" : "MOVE"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(PATROL,(lang == "fr") ? "PATROUILLER" : "PATROL"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(FIGHT,(lang == "fr") ? "COMBATTRE" : "FIGHT"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(GUARD,(lang == "fr") ? "DEFENDRE" : "GUARD"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(MOVE_STATE,"MOVE_STATE"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(ATTACK,(lang == "fr") ? "ATTAQUER" : "ATTACK"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(REPAIR,(lang == "fr") ? "REPARER" : "REPAIR"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(RECLAIM,(lang == "fr") ? "RECUPERER" : "RECLAIM"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(RESTORE,(lang == "fr") ? "RESTAURER" : "RESTORE"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(BUILD_BADBLOCK,(lang == "fr") ? "CONSTRUIRE BADBLOCK" : "BUILD BADBLOCK"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(BUILD_LOGIC_BOMB,(lang == "fr") ? "CONSTRUIRE BOMBE LOGIQUE" : "BUILD LOGIC BOMB"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(BUILD_SOCKET,(lang == "fr") ? "CONSTRUIRE SOCKET" : "BUILD SOCKET"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(BUILD_TERMINAL,(lang == "fr") ? "CONSTRUIRE TERMINAL" : "BUILD TERMINAL"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(DEBUG,"DEBUG"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(BUILD_ASSEMBLER,(lang == "fr") ? "CONSTRUIRE ASSEMBLEUR" : "BUILD ASSEMBLER"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(BUILD_BYTE,(lang == "fr") ? "CONSTRUIRE OCTET" : "BUILD BYTE"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(BUILD_POINTER,(lang == "fr") ? "CONSTRUIRE POINTEUR" : "BUILD POINTER"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(BUILD_BIT,(lang == "fr") ? "CONSTRUIRE BIT" : "BUILD BIT"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(STOP_BUILDING,(lang == "fr") ? "STOP CONSTRUCTION" : "STOP BUILD"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(LAUNCH_MINE,(lang == "fr") ? "LANCER MINE" : "LAUNCH MINE"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(NX_FLAG,"NX_FLAG"));
	TracesAnalyser::orders_map.insert(std::make_pair<int,std::string>(SIGTERM,"SIGTERM"));
	
	//Initialise units_id_map
	TracesAnalyser::resources_map.insert(std::make_pair<int,std::string>(METAL,"METAL"));
	TracesAnalyser::resources_map.insert(std::make_pair<int,std::string>(ENERGY,"ENERGY"));
	
	//Parse feedbacks.xml
	std::string filename = FEEDBACKS_FILENAME;
	if (in_game)
		filename.insert(0,IN_GAME_DATA_DIRNAME);
	rapidxml::file<> xmlFile(filename.c_str());
    doc.parse<0>(xmlFile.data());
	// Initialise messages_map
	importMessagesFromXml();
	// Fill ref_feedbacks
	importFeedbacksFromXml();
	std::cout << "num ref feedbacks : " << ref_feedbacks.size() << std::endl;
	std::sort(ref_feedbacks.begin(), ref_feedbacks.end());
}

// import one or all reference feedbacks from xml file to ref_feedbacks vector
void TracesAnalyser::importFeedbacksFromXml(int ind_feedback) {
	std::cout << "import feedbacks from xml" << std::endl;
	rapidxml::xml_node<> *root_node = doc.first_node("root")->first_node("feedbacks");
	if (root_node != 0 && ind_feedback >= -1 && ind_feedback < (int)ref_feedbacks.size()) {
		if (!ref_feedbacks.empty()) {
			if (ind_feedback == -1)
				ref_feedbacks.clear();
			else
				ref_feedbacks.erase(ref_feedbacks.begin() + ind_feedback);
		}
		int i = 0;
		for (rapidxml::xml_node<> *feedback_node = root_node->first_node(); feedback_node; feedback_node = feedback_node->next_sibling(), i++) {
			if (ind_feedback == -1 || ind_feedback == i) {
				Feedback f;
				f.type = Call::getEnumType<FeedbackType>(feedback_node->first_attribute("type")->value(),feedbackTypesArr);
				f.priority = std::atoi(feedback_node->first_attribute("priority")->value());
				rapidxml::xml_node<> *node = feedback_node->first_node("infos");
				while(node && node->first_attribute("lang") != 0 && std::string(node->first_attribute("lang")->value()).compare(lang) != 0)
					node = node->next_sibling();
				if (node) {
					int r = getRandomIntInRange(0,TracesParser::getNodeChildCount(node));
					for (rapidxml::xml_node<> *info_node = node->first_node("info"); info_node; info_node = info_node->next_sibling(), r--) {
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
				ref_feedbacks.insert(ref_feedbacks.begin() + i, f);
			}
		}
	}
}

void TracesAnalyser::importMessagesFromXml() {
	std::cout << "import messages from xml" << std::endl;
	rapidxml::xml_node<> *root_node = doc.first_node("root")->first_node("messages");
	if (root_node != 0) {
		for (rapidxml::xml_node<> *message_node = root_node->first_node(); message_node; message_node = message_node->next_sibling()) {
			if (message_node->first_attribute("id") != 0) {
				rapidxml::xml_node<> *node = message_node->first_node("infos");
				while(node && node->first_attribute("lang") != 0 && std::string(node->first_attribute("lang")->value()).compare(lang) != 0)
					node = node->next_sibling();
				if (node) {
					std::string value;
					int r = getRandomIntInRange(0,TracesParser::getNodeChildCount(node));
					for (rapidxml::xml_node<> *info_node = node->first_node("info"); info_node; info_node = info_node->next_sibling(), r--) {
						if (r == 0)
							value = info_node->value();
					}
					messages_map.insert(std::make_pair<std::string,std::string>(message_node->first_attribute("id")->value(),value));
				}
			}
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

std::string TracesAnalyser::getFeedback(const std::string& dir_path, const std::string& filename, int ind_mission, int ind_execution) {
	rapidjson::Document doc;
	rapidjson::Document::AllocatorType& allocator = doc.GetAllocator();
	doc.SetObject();	
	int ind_best = -1;
	double best_score = 0;
	std::vector<Trace::sp_trace> learner_traces = TracesParser::importTraceFromXml(dir_path, filename);
	if (getInfosOnMission(learner_traces, learner_gi, ind_mission) && getInfosOnExecution(learner_gi, ind_execution)) {
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
					std::pair<double,double> res = findBestAlignment(learner_gi.exec_traces, expert_gi.exec_traces);
					double score = res.first / res.second;
					std::cout << "norm : " << res.second << std::endl;
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
				if (reimport) {
					learner_traces = TracesParser::importTraceFromXml(dir_path, filename);
					getInfosOnMission(learner_traces, learner_gi, ind_mission);
					getInfosOnExecution(learner_gi, ind_execution);
				}
				addImplicitSequences(learner_gi.exec_traces, expert_gi.exec_traces);
				addImplicitSequences(expert_gi.exec_traces, learner_gi.exec_traces);
				findBestAlignment(learner_gi.exec_traces, expert_gi.exec_traces);
				displayAlignment(learner_gi.exec_traces, expert_gi.exec_traces);

				int num_attempts = learner_gi.getNumExecutions();
				doc.AddMember("num_attempts", num_attempts, allocator); // nombre de tentatives
				if (learner_gi.eee != NULL) {
					doc.AddMember("execution_time", learner_gi.getExecutionTime(), allocator); // temps d'execution de la derniere tentative
					doc.AddMember("ref_execution_time", expert_gi.getExecutionTime(), allocator); // temps d'execution reference
				}
				if (learner_gi.eme != NULL) {
					double wait_time = learner_gi.getAverageWaitTime();
					if (wait_time != -1)
						doc.AddMember("exec_mean_wait_time", wait_time, allocator); // temps d'attente moyen entre deux tentatives
					doc.AddMember("resolution_time", learner_gi.getResolutionTime(), allocator); // temps de resolution de la mission
					doc.AddMember("ref_resolution_time", expert_gi.getResolutionTime(), allocator); // temps de resolution reference
					doc.AddMember("won", learner_gi.eme->getStatus().compare("won") == 0, allocator); // victoire / defaite
				}
				if (endless_loop && messages_map.find("endless_loop") != messages_map.end()) {
					rapidjson::Value arrWarnings(rapidjson::kArrayType);
					std::string msg = messages_map.at("endless_loop");
					rapidjson::Value f(msg.c_str(), msg.size(), allocator);
					arrWarnings.PushBack(f, allocator);
					doc.AddMember("warnings", arrWarnings, allocator);
				}
				else if (!endless_loop) {
					doc.AddMember("score", std::floor(best_score * 100), allocator);
					std::vector<Feedback> feedbacks;
					if (!ref_feedbacks.empty()) {
						listAlignmentFeedbacks(learner_gi.exec_traces, expert_gi.exec_traces, feedbacks);
						listGlobalFeedbacks(learner_gi.exec_traces, feedbacks);
						sortFeedbacks(feedbacks);
						filterFeedbacks(feedbacks, learner_gi.exec_traces, expert_gi.exec_traces);
					}
					unsigned int num_downgrads = num_attempts / NUM_DOWNGRADS, cpt_downgrads = 0;
					rapidjson::Value arrInfos(rapidjson::kArrayType);
					std::cout << "complete list of feedbacks" << std::endl;
					std::cout << "_________" << std::endl;
					for(unsigned int i = 0; i < feedbacks.size(); i++) {
						if (i > 1 && feedbacks.at(i).priority > feedbacks.at(i-1).priority)
							cpt_downgrads++;
						if (cpt_downgrads <= num_downgrads) {
							rapidjson::Value f(feedbacks.at(i).info.c_str(), feedbacks.at(i).info.size(), allocator);
							arrInfos.PushBack(f, allocator);
						}
						feedbacks.at(i).display();
					}
					std::cout << "_________" << std::endl;
					doc.AddMember("feedbacks", arrInfos, allocator);
					//doc.AddMember("publish", false, allocator);
				}
			}
		}
	}
	rapidjson::StringBuffer s;
	rapidjson::PrettyWriter<rapidjson::StringBuffer> writer(s);
	doc.Accept(writer);
	return s.GetString();
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

bool TracesAnalyser::addImplicitSequences(std::vector<Trace::sp_trace>& mod, const std::vector<Trace::sp_trace>& ref) const {
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

std::vector<Call::call_vector> TracesAnalyser::getPatterns(const std::vector<Trace::sp_trace>& mod, const Call::call_vector& pattern) const {
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

const Sequence::sp_sequence TracesAnalyser::getClosestCommonParent(const Call::call_vector& pattern) const {
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

std::pair<double,double> TracesAnalyser::findBestAlignment(const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e, bool align) const {
	int cpt_path = 0;
	unsigned int lsize = l.size()+1, esize = e.size()+1;
	double score = 0, norm = 0;
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
				Call::sp_call learner_spc = boost::dynamic_pointer_cast<Call>(l.at(i-1));
				Call::sp_call expert_spc = boost::dynamic_pointer_cast<Call>(e.at(j-1));
				match_score = 1 - learner_spc->getEditDistance(expert_spc.get());
				val[i][j].second = match_score;
				match_score = TRANSFORM_SCORE(match_score);
			}
			else if (l.at(i-1)->isSequence() && e.at(j-1)->isSequence()) {
				Sequence::sp_sequence learner_sps = boost::dynamic_pointer_cast<Sequence>(l.at(i-1));
				Sequence::sp_sequence expert_sps = boost::dynamic_pointer_cast<Sequence>(e.at(j-1));
				std::pair<double,double> res = findBestAlignment(learner_sps->getTraces(),expert_sps->getTraces(),align);
				match_score = res.first;
				double mean_dis = learner_sps->getNumMapMeanDistance(expert_sps);
				val[i][j].second = match_score + (1 - mean_dis) * (res.second / IND_SEQ_NUM_CONST);
				match_score /= res.second;
				match_score = TRANSFORM_SCORE(match_score);
			}
			else
				match_score = ALIGN_MISMATCH_SCORE;
			val[i][j].first = val[i-1][j-1].first + match_score;
			help[i][j] = 'd';
			if (val[i-1][j].first + ALIGN_GAP_SCORE > val[i][j].first && val[i-1][j].first + ALIGN_GAP_SCORE > val[i][j-1].first + ALIGN_GAP_SCORE) {
				val[i][j].first = val[i-1][j].first + ALIGN_GAP_SCORE;
				val[i][j].second = 0;
				ind[i][j].second++;
				help[i][j] = 'h';
			}
			else if (val[i][j-1].first + ALIGN_GAP_SCORE > val[i][j].first) {
				val[i][j].first = val[i][j-1].first + ALIGN_GAP_SCORE;
				val[i][j].second = 0;
				ind[i][j].first++;
				help[i][j] = 'g';
			}
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
	
	for (unsigned int i = 0; i < p.size(); i++) {
		double norm_val = 1;
		int indi = p.at(i).first, indj = p.at(i).second;
		if ((i < p.size()-1 && indi == p.at(i+1).first) || indi >= (int)l.size()) {
			if (align)
				e.at(indj)->resetAligned();
		}
		else if ((i < p.size()-1 && indj == p.at(i+1).second) || indj >= (int)e.size())	{
			if (align)
				l.at(indi)->resetAligned();
		}
		else {
			if (l.at(indi)->isSequence() && e.at(indj)->isSequence()) {
				std::pair<double,double> res = findBestAlignment(dynamic_cast<Sequence*>(l.at(indi).get())->getTraces(), dynamic_cast<Sequence*>(e.at(indj).get())->getTraces(),align);
				norm_val = res.second + (res.second / IND_SEQ_NUM_CONST);
			}
			if (align) {
				l.at(indi)->setAligned(e.at(indj));
				e.at(indj)->setAligned(l.at(indi));
			}
		}
		norm += norm_val;
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
	return std::make_pair<double,double>(score,norm);
}

void TracesAnalyser::displayAlignment(const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e) const {
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
	for (unsigned int i = 0; i < feedbacks.size(); i++) {
		int ind_max = -1;
		double max_score = 0;
		for (unsigned int j = 0; j < ref_feedbacks.size(); j++) {
			if (feedbacks.at(i).type == ref_feedbacks.at(j).type) {
				double score = getFeedbackScore(feedbacks.at(i),j);
				if (score >= max_score) {
					max_score = score;
					ind_max = j;
				}
				std::cout << "---" << std::endl;
				feedbacks.at(i).display();
				std::cout << std::endl;
				ref_feedbacks.at(j).display();
				std::cout << std::endl;
				std::cout << "score :" << score << std::endl;
				std::cout << "---" << std::endl;
			}
		}
		//Set feedback priority
		feedbacks.at(i).priority = ref_feedbacks.at(ind_max).priority;
		//Set Feedback info
		setFeedbackInfo(feedbacks.at(i),ref_feedbacks.at(ind_max));
		// Set defined to true if the feedback is a personnalised feedback (and not a default one)
		feedbacks.at(i).defined = ref_feedbacks.at(ind_max).learner_spt || ref_feedbacks.at(ind_max).expert_spt;
	}
	std::sort(feedbacks.begin(), feedbacks.end());
	for (unsigned int i = 0; i < feedbacks.size(); i++) {
		std::cout << "[" << std::endl;
		feedbacks.at(i).display();
		std::cout << "]" << std::endl;
	}
}

double TracesAnalyser::getFeedbackScore(const Feedback& f, int j) {
	double score[2] = {0,0};
	Trace::sp_trace t[2] = {f.learner_spt,f.expert_spt};
	Trace::sp_trace ref_t[2] = {ref_feedbacks.at(j).learner_spt,ref_feedbacks.at(j).expert_spt};
	for (unsigned int i = 0; i < 2; i++) {
		if (t[i] && ref_t[i]) {
			if (t[i]->isCall() && ref_t[i]->isCall()) {
				Call::sp_call spc = boost::dynamic_pointer_cast<Call>(t[i]);
				Call::sp_call ref_spc = boost::dynamic_pointer_cast<Call>(ref_t[i]);
				score[i] = 1 - spc->getEditDistance(ref_spc.get());
			}
			else if (t[i]->isSequence() && ref_t[i]->isSequence()) {
				Sequence::sp_sequence sps = boost::dynamic_pointer_cast<Sequence>(t[i]);
				Sequence::sp_sequence ref_sps = boost::dynamic_pointer_cast<Sequence>(ref_t[i]);
				bool reimport = addImplicitSequences(ref_sps->getTraces(),sps->getTraces());
				if (feedbackSequencesMatch(sps,ref_sps)) {
					std::pair<double,double> res = findBestAlignment(sps->getTraces(),ref_sps->getTraces(),false);
					score[i] = res.first / res.second;
				}
				if (reimport) 
					importFeedbacksFromXml(j); //we have to reload the specific feedback_ref
			}
		}
	}
	return std::max(score[0],score[1]);
}

bool TracesAnalyser::feedbackSequencesMatch(const Sequence::sp_sequence& sps, const Sequence::sp_sequence& ref_sps) const {
	unsigned int sps_size = 0, ref_sps_size = 0;
	for (unsigned int i = 0; i < sps->size(); i++) {
		if (!sps->at(i)->isEvent())
			sps_size++;
	}
	for (unsigned int i = 0; i < ref_sps->size(); i++) {
		if (!ref_sps->at(i)->isEvent())
			ref_sps_size++;
	}
	if (sps_size == ref_sps_size) {
		for (unsigned int i = 0, j = 0; i < sps->size() && j < ref_sps->size();) {
			if (sps->at(i)->isEvent()) {
				i++;
				continue;
			}
			if (ref_sps->at(j)->isEvent()) {
				j++;
				continue;
			}
			if (sps->at(i)->isSequence() && ref_sps->at(j)->isSequence() && !feedbackSequencesMatch(boost::dynamic_pointer_cast<Sequence>(sps->at(i)),boost::dynamic_pointer_cast<Sequence>(ref_sps->at(j))))
				return false;
			if (sps->at(i)->isCall() && ref_sps->at(j)->isCall()) {
				Call::sp_call spc = boost::dynamic_pointer_cast<Call>(sps->at(i));
				Call::sp_call ref_spc = boost::dynamic_pointer_cast<Call>(ref_sps->at(j));
				if (spc->getLabel().compare(ref_spc->getLabel()) != 0 || spc->getError() != ref_spc->getError())
					return false;
			}
			i++;
			j++;
		}
		return true;
	}
	return false;
}

void TracesAnalyser::filterFeedbacks(std::vector<Feedback>& feedbacks, const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e) const {
	std::cout << "start filter feedbacks [" << feedbacks.size() << " feedbacks]" << std::endl;
	// Find redundancies with useful\useless call and eliminate the feedback which is given less priority 
	std::vector<Feedback*> to_del;
	std::vector<Feedback>::iterator it = feedbacks.begin();
	while (it != feedbacks.end()) {
		Feedback& f = *it;
		if (f.type == USEFUL_CALL || f.type == USELESS_CALL) {
			Call::sp_call spc = (f.type == USEFUL_CALL) ? boost::dynamic_pointer_cast<Call>(f.expert_spt) : boost::dynamic_pointer_cast<Call>(f.learner_spt);
			std::vector<Feedback>::iterator _it = feedbacks.begin();
			while (_it != feedbacks.end()) {
				Feedback& _f = *_it;
				if (std::find(to_del.begin(),to_del.end(),&_f) == to_del.end()) {
					Call::call_vector calls;
					if (_f.type == CALL_LACK)
						calls.push_back(boost::dynamic_pointer_cast<Call>(_f.expert_spt));
					else if (_f.type == CALL_EXTRA)
						calls.push_back(boost::dynamic_pointer_cast<Call>(_f.learner_spt));
					else if (_f.type == SEQ_LACK)
						calls = Call::getCalls(boost::dynamic_pointer_cast<Sequence>(_f.expert_spt)->getTraces(),true);
					else if (_f.type == SEQ_EXTRA)
						calls = Call::getCalls(boost::dynamic_pointer_cast<Sequence>(_f.learner_spt)->getTraces(),true);
					for (unsigned int j = 0; j < calls.size(); j++) {
						if (calls.at(j)->getLabel().compare(spc->getLabel()) == 0) {
							if (f.priority <= _f.priority) {
								to_del.push_back(&_f);
								_f.display();
							}
							else {
								to_del.push_back(&f);
								f.display();
							}
							std::cout << "filter 1" << std::endl;
							break;
						}
					}
					if (std::find(to_del.begin(),to_del.end(),&f) != to_del.end())
						break;
				}
				_it++;
			}
		}
		it++;
	}
	for (unsigned int i = 0; i < feedbacks.size(); i++) {
		if (std::find(to_del.begin(), to_del.end(), &feedbacks.at(i)) == to_del.end()) {
			// Remove not defined feedbacks with sequence of length 1
			if (!feedbacks.at(i).defined && (feedbacks.at(i).type == SEQ_LACK || feedbacks.at(i).type == SEQ_EXTRA)) {
				Sequence::sp_sequence sps;
				if (feedbacks.at(i).type == SEQ_LACK)
					sps = boost::dynamic_pointer_cast<Sequence>(feedbacks.at(i).expert_spt);
				else
					sps = boost::dynamic_pointer_cast<Sequence>(feedbacks.at(i).learner_spt);
				if (sps->length() == 1) {
					to_del.push_back(&feedbacks.at(i));
					feedbacks.at(i).display();
					std::cout << "filter 2" << std::endl;
				}
			}
			// Remove call feedbacks when the call is too much present in the trace
			if (!feedbacks.at(i).defined && (feedbacks.at(i).type == CALL_EXTRA || feedbacks.at(i).type == CALL_LACK)) {
				Call::sp_call spc = (feedbacks.at(i).type == CALL_EXTRA) ? boost::dynamic_pointer_cast<Call>(feedbacks.at(i).learner_spt) : boost::dynamic_pointer_cast<Call>(feedbacks.at(i).expert_spt);
				if (feedbacks.at(i).type != CALL_EXTRA || spc->getError() == Call::NONE) {
					unsigned int cpt = 0;					
					Call::call_vector calls = (feedbacks.at(i).type == CALL_EXTRA) ? Call::getCalls(l) : Call::getCalls(e);
					for (unsigned int j = 0; j < calls.size(); j++) {
						if (calls.at(j)->getLabel().compare(spc->getLabel()) == 0)
							cpt++;
					}
					if (cpt >= NUM_CALL_APPEARS_THRES) {
						to_del.push_back(&feedbacks.at(i));
						feedbacks.at(i).display();
						std::cout << "filter 3" << std::endl;
					}
				}
			}
			// Detect and remove loop's termination condition last call
			// if (!feedbacks.at(i).defined && feedbacks.at(i).type == CALL_LACK) {}
		}
	}
	// Do the delete
	std::cout << to_del.size() << " feedbacks are deleted with filter operations" << std::endl;
	std::cout << "_________" << std::endl;
	for (unsigned int i = 0; i < to_del.size(); i++) {
		std::vector<Feedback>::iterator it = feedbacks.begin();
		while (it != feedbacks.end()) {
			if (to_del.at(i) == &(*it)) {
				feedbacks.erase(it);
				break;
			}
			it++;
		}
	}
	std::cout << "_________" << std::endl;
	std::cout << "end filter feedbacks [" << feedbacks.size() << " feedbacks]" << std::endl;
}

void TracesAnalyser::setFeedbackInfo(Feedback& f, Feedback& ref_f) const {
	// if f is a CALL_EXTRA feedback and the call has an associated error
	if (f.type == CALL_EXTRA) {
		Call::sp_call spc = boost::dynamic_pointer_cast<Call>(f.learner_spt);
		if (spc->getError() != Call::NONE) {
			ref_f.info = messages_map.at(Call::getEnumLabel<Call::ErrorType>(spc->getError(),Call::errorsArr));
			f.priority = 0;
		}
	}
	// we can replace parts of the info (surrounded by * characters) with the appropriate string
	std::vector<std::string> tokens = TracesParser::splitLine(ref_f.info,'*');
	for (unsigned int i = 0; i < tokens.size(); i++) {
		std::string& s = tokens.at(i);
		if (s.compare("learner_call") == 0 && (f.type == CALL_EXTRA || f.type == CALL_PARAMS || f.type == USELESS_CALL)) {
			Call::sp_call spc = boost::dynamic_pointer_cast<Call>(f.learner_spt);
			s = spc->getLabel() + spc->getReadableParams();
		}
		else if (s.compare("expert_call") == 0 && (f.type == CALL_LACK || f.type == CALL_PARAMS || f.type == USEFUL_CALL)) {
			Call::sp_call spc = boost::dynamic_pointer_cast<Call>(f.expert_spt);
			s = spc->getLabel() + spc->getReadableParams();
		}
		else if (s.compare("label") == 0 && (f.type == CALL_EXTRA || f.type == CALL_LACK || f.type == CALL_PARAMS || f.type == USEFUL_CALL || f.type == USELESS_CALL)) {
			Call::sp_call spc = f.learner_spt ? boost::dynamic_pointer_cast<Call>(f.learner_spt) : boost::dynamic_pointer_cast<Call>(f.expert_spt);
			s = spc->getLabel();
		}
		else if (s.compare("diff_params") == 0 && f.type == CALL_PARAMS) {
			Call::sp_call learner_spc = boost::dynamic_pointer_cast<Call>(f.learner_spt);
			Call::sp_call expert_spc = boost::dynamic_pointer_cast<Call>(f.expert_spt);
			std::vector<std::string> ids = learner_spc->getListIdWrongParams(expert_spc.get());
			s = "";
			for (unsigned int j = 0; j < ids.size(); j++)
				s += "\t" + messages_map.at(ids.at(j)) + "\n";
		}
		else if (s.compare("list_calls") == 0) {
			if (f.type == SEQ_EXTRA || f.type == IND_SEQ_NUM || f.type == DIST_SEQ_NUM) {
				Sequence::sp_sequence sps = boost::dynamic_pointer_cast<Sequence>(f.learner_spt);
				Call::call_vector calls = Call::getCalls(sps->getTraces(),true);
				s = "";
				for (Call::call_vector::const_iterator it = calls.begin(); it != calls.end(); it++) {
					s += (*it)->getLabel();
					if (it != calls.end())
						s += ", ";
				}
			}
			else if (f.type == SEQ_LACK) {
				Sequence::sp_sequence sps = boost::dynamic_pointer_cast<Sequence>(f.expert_spt);
				Call::call_vector calls = Call::getCalls(sps->getTraces(),true);
				unsigned int nb = std::max(2,(int)(calls.size() * SEQ_LACK_INFO_RATIO));
				s = "";
				for (unsigned int j = 0; j < nb; j++) {
					s += calls.at(j)->getLabel();
					if (j < nb - 1)
						s += ", ";
				}
			}
		}
		else if (s.compare("learner_ind_seq_num") == 0 && f.type == IND_SEQ_NUM) {
			Sequence::sp_sequence learner_sps = boost::dynamic_pointer_cast<Sequence>(f.learner_spt);
			s = boost::lexical_cast<std::string>(learner_sps->getNumMap().begin()->first);
		}
		else if (s.compare("expert_ind_seq_num") == 0 && f.type == IND_SEQ_NUM) {
			Sequence::sp_sequence expert_sps = boost::dynamic_pointer_cast<Sequence>(f.expert_spt);
			s = boost::lexical_cast<std::string>(expert_sps->getNumMap().begin()->first);
		}
		else if (s.compare("seq_info") == 0 && (f.type == SEQ_LACK || f.type == INCLUDE_CALL_IN_SEQ || f.type == EXCLUDE_CALL_FROM_SEQ)) {
			// we can use the info added by the expert to the sequence
			if (f.expert_spt) {
				Sequence::sp_sequence sps = boost::dynamic_pointer_cast<Sequence>(f.expert_spt);
				if (!sps->getInfo().empty()) {
					s = "(" + sps->getInfo() + ")";
				}
			}
		}
		else if (s.compare("out_of_range_param") == 0 && f.type == CALL_EXTRA) {
			Call::sp_call learner_spc = boost::dynamic_pointer_cast<Call>(f.learner_spt);
			std::vector<std::string> ids = learner_spc->getListIdWrongParams();
			if (!ids.empty())
				s = ids.at(0);
		}
		else if (s.compare("n") == 0) {
			s = "\n";
		}
		else if (s.compare("t") == 0) {
			s = "\t";
		}
		f.info += tokens.at(i);
	}
}

void TracesAnalyser::listGlobalFeedbacks(const std::vector<Trace::sp_trace>& l, std::vector<Feedback>& feedbacks) const {
	// add useful/useless call feedbacks
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
	// add include call feedbacks - a revoir avec l'algo
	// for (unsigned int i = 0; i < feedbacks.size(); i++) {
		// if (feedbacks.at(i).type == SEQ_LACK && feedbacks.at(i).learner_spt && feedbacks.at(i).learner_spt->isSequence()) {
			// Sequence::sp_sequence learner_sps = boost::dynamic_pointer_cast<Sequence>(feedbacks.at(i).learner_spt);
			// Sequence::sp_sequence expert_sps = boost::dynamic_pointer_cast<Sequence>(feedbacks.at(i).expert_spt);
			// if (learner_sps->isImplicit() && learner_sps->size() > 1 && learner_sps->at(0)->isCall() && feedbackSequencesMatch(learner_sps,expert_sps)) {
				// feedbacks.at(i).type = CALL_INCLUDE;
				// feedbacks.at(i).learner_spt = boost::dynamic_pointer_cast<Call>(learner_sps->at(0));
				// feedbacks.at(i).expert_spt.reset();
			// }
		// }
	// }
	// for (unsigned int i = 0; i < feedbacks.size(); i++) {
		// if (feedbacks.at(i).type == SEQ_EXTRA && feedbacks.at(i).expert_spt) {
			// Sequence::sp_sequence learner_sps = boost::dynamic_pointer_cast<Sequence>(feedbacks.at(i).learner_spt);
			// learner_sps->reset();
			// while (!learner_sps->isEndReached()) {
				// Trace::sp_trace spt = learner_sps->next();
				// if (spt->isSequence()) {
					// Sequence::sp_sequence sec_learner_sps = dynamic_pointer_cast<Sequence>(spt);
					// if (sec_learner_sps->isImplicit()) {
						
					// }
				// }
			// }
		// }
	// }
}

void TracesAnalyser::listAlignmentFeedbacks(const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e, std::vector<Feedback>& feedbacks) const {
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
				else if (learner_sps->getLevel() == 0 && expert_sps->getLevel() == 0) {
					std::map<unsigned int,unsigned int> learner_numMap = learner_sps->getNumMap();
					std::map<unsigned int, unsigned int> expert_numMap = expert_sps->getNumMap();
					if (learner_numMap.size() == 1 && expert_numMap.size() == 1 && expert_numMap.find(learner_numMap.begin()->first) == expert_numMap.end())
						f.type = IND_SEQ_NUM;
				}
				else if (learner_sps->getNumMapMeanDistance(expert_sps) >= DIST_SEQ_NUM_THRES)
					f.type = DIST_SEQ_NUM;
				listAlignmentFeedbacks(learner_sps->getTraces(), expert_sps->getTraces(), feedbacks);
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
}