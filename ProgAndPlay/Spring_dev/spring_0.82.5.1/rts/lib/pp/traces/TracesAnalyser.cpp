#include "TracesAnalyser.h"

#define SCORE_MATCH 0
#define SCORE_MISMATCH 1
#define SCORE_GAP 1

#define ALIGN_MATCH 1
#define ALIGN_MISMATCH -1
#define ALIGN_GAP 0

#define SIM_THRES 0.5

std::string exp_traces_dirname = "xml\\expert";

TracesAnalyser::TracesAnalyser(const std::vector<sp_trace>& learner_traces) {
	this->learner_traces = learner_traces;
}

void TracesAnalyser::compareExecutionTrace(int ind_mission, int ind_execution) {
	int maxI = -1;
	float maxi = 0;
	GameInfos learner_gi, expert_gi;
	std::vector<sp_trace> exp_traces;
	if (getInfosOnMission(learner_traces, learner_gi, ind_mission) && getInfosOnExecution(learner_gi, ind_execution)) {
		std::vector<std::string> files = findExpertTracesFilenames(learner_gi.sme->getMissionName());
		for(unsigned int i = 0; i < files.size(); i++) {
			exp_traces = TracesParser::importTraceFromXml(exp_traces_dirname + "\\" + learner_gi.sme->getMissionName(), files.at(i));
			if (getInfosOnMission(exp_traces, expert_gi) && getInfosOnExecution(expert_gi)) {
				if (!learner_gi.exec_traces.empty() && !expert_gi.exec_traces.empty()) {
					std::cout << "---" << std::endl;
					float score = getSimilarityScore(learner_gi.exec_traces, expert_gi.exec_traces);
					std::cout << "---" << std::endl;
					if (score > maxi) {
						maxi = score;
						maxI = i;
					}
				}
			}
		}
		if (maxI > -1) {
			std::cout << files.at(maxI) << " has been chosen for alignment with learner traces" << std::endl;
			exp_traces = TracesParser::importTraceFromXml(exp_traces_dirname + "\\" + learner_gi.sme->getMissionName(), files.at(maxI));
			if (getInfosOnMission(exp_traces, expert_gi) && getInfosOnExecution(expert_gi))
				findBestAlignment(learner_gi.exec_traces, expert_gi.exec_traces);
				displayAlignment(learner_gi.exec_traces, expert_gi.exec_traces);
		}
	}
}

bool TracesAnalyser::getInfosOnMission(const std::vector<sp_trace>& traces, GameInfos& gi, int ind_mission) {
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
	const std::vector<sp_trace>& m_traces = gi.mission_traces;
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

std::vector<std::string> TracesAnalyser::findExpertTracesFilenames(const std::string& mission_name) {
	std::vector<std::string> files;
	std::string s = exp_traces_dirname + "\\" + mission_name;
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

float TracesAnalyser::getSimilarityScore(const std::vector<sp_trace>& l, const std::vector<sp_trace>& e) {
	int editDis = getEditDistance(l,e);
	float norm = std::max(Trace::getLength(l), Trace::getLength(e));
	float score = 1 - editDis / norm;
	std::cout << "edit distance : " << editDis << std::endl;
	std::cout << "norm factor : " << norm << std::endl;
	std::cout << "similarity score : " << score << std::endl;
	return score;
}

int TracesAnalyser::getEditDistance(const std::vector<sp_trace>& l, const std::vector<sp_trace>& e) {
	unsigned int lsize = l.size()+1, esize = e.size()+1, i, j;
	int val;
	int** sim = new int*[lsize];
	char** help = new char*[lsize];
	sp_sequence spl, spe;
	std::cout << "getEditDistance" << std::endl;
	for (i = 0; i < l.size(); i++)
		l.at(i)->display();
	std::cout << std::endl;
	for (i = 0; i < e.size(); i++)
		e.at(i)->display();
	std::cout << std::endl;
	for (i = 0; i < lsize; i++) {
		sim[i] = new int[esize];
		help[i] = new char[esize];
	}
	for (i = 0; i < lsize; i++) {
		sim[i][0] = SCORE_GAP * i;
		help[i][0] = 'h';
	}
	for (j = 1; j < esize; j++) {
		sim[0][j] = SCORE_GAP * j;
		help[0][j] = 'g';
	}
	for (i = 1; i < lsize; i++) {
		for (j = 1; j < esize; j++) {
			if (l.at(i-1)->operator==(e.at(j-1).get()))
				val = SCORE_MATCH;
			else if (l.at(i-1)->isSequence() || e.at(j-1)->isSequence()) {
				if (l.at(i-1)->isSequence())
					spl = boost::dynamic_pointer_cast<Sequence>(l.at(i-1));
				if (e.at(j-1)->isSequence())
					spe = boost::dynamic_pointer_cast<Sequence>(e.at(j-1));
				if (l.at(i-1)->isSequence() && e.at(j-1)->isSequence())
					val = spl->compare(spe.get()) ? SCORE_MATCH : getEditDistance(spl->getTraces(),spe->getTraces());
				else
					val = ((l.at(i-1)->isSequence() && spl->size() == 1 && spl->at(0)->operator==(e.at(j-1).get())) || (e.at(j-1)->isSequence() && spe->size() == 1 && spe->at(0)->operator==(l.at(i-1).get()))) ? SCORE_MATCH : SCORE_MISMATCH;
			}
			else
				val = SCORE_MISMATCH;
			sim[i][j] = sim[i-1][j-1] + val;
			help[i][j] = 'd';
			if (sim[i-1][j] + SCORE_GAP < sim[i][j] && sim[i-1][j] + SCORE_GAP < sim[i][j-1] + SCORE_GAP) {
				sim[i][j] = sim[i-1][j] + SCORE_GAP;
				help[i][j] = 'h';
			}
			else if (sim[i][j-1] + SCORE_GAP < sim[i][j]) {
				sim[i][j] = sim[i][j-1] + SCORE_GAP;
				help[i][j] = 'g';
			}
		}
	}
	for (i = 0; i < lsize; i++) {
		for (j = 0; j < esize; j++)
			std::cout << sim[i][j] << "\t";
		std::cout << std::endl;
	}
	for (i = 0; i < lsize; i++) {
		for (j = 0; j < esize; j++)
			std::cout << help[i][j] << "\t";
		std::cout << std::endl;
	}
	val = sim[lsize-1][esize-1];
	for (i = 0; i < lsize; i++) {
		delete[] sim[i];
		delete[] help[i];
	}
	delete[] sim;
	delete[] help;
	return val;
}

path TracesAnalyser::findBestAlignment(const std::vector<sp_trace>& l, const std::vector<sp_trace>& e) {
	int indi, indj, val;
	unsigned int lsize = l.size()+1, esize = e.size()+1, i, j;
	int** sim = new int*[lsize];
	std::pair<int,int>** ind = new std::pair<int,int>*[lsize];
	char** help = new char*[lsize];
	sp_sequence spl, spe;
	std::cout << "findBestAlignment" << std::endl;
	for (i = 0; i < l.size(); i++)
		l.at(i)->display();
	std::cout << std::endl;
	for (i = 0; i < e.size(); i++)
		e.at(i)->display();
	std::cout << std::endl;
	for (i = 0; i < lsize; i++) {
		sim[i] = new int[esize];
		ind[i] = new std::pair<int,int>[esize];
		help[i] = new char[esize];
	}
	for (i = 0; i < lsize; i++) {
		sim[i][0] = ALIGN_GAP * i;
		ind[i][0] = std::make_pair(i-1,0);
		help[i][0] = 'h';
	}
	for (j = 1; j < esize; j++) {
		sim[0][j] = ALIGN_GAP * j;
		ind[0][j] = std::make_pair(0,j-1);
		help[0][j] = 'g';
	}
	for (i = 1; i < lsize; i++) {
		for (j = 1; j < esize; j++) {
			indi = i-1;
			indj = j-1;
			if (l.at(i-1)->operator==(e.at(j-1).get()))
				val = ALIGN_MATCH;
			else if (l.at(i-1)->isSequence() || e.at(j-1)->isSequence()) {
				if (l.at(i-1)->isSequence())
					spl = boost::dynamic_pointer_cast<Sequence>(l.at(i-1));
				if (e.at(j-1)->isSequence())
					spe = boost::dynamic_pointer_cast<Sequence>(e.at(j-1));
				if (l.at(i-1)->isSequence() && e.at(j-1)->isSequence()) {
					//le cas spl->compare(spe.get()) est-il géré ici ? 
					if (getSimilarityScore(spl->getTraces(),spe->getTraces()) >= SIM_THRES)
						val = ALIGN_MATCH;
					else
						val = ALIGN_MISMATCH;
				}
				else
					val = ((l.at(i-1)->isSequence() && spl->size() == 1 && spl->at(0)->operator==(e.at(j-1).get())) || (e.at(j-1)->isSequence() && spe->size() == 1 && spe->at(0)->operator==(l.at(i-1).get()))) ? ALIGN_MATCH : ALIGN_MISMATCH;
			}
			else
				val = ALIGN_MISMATCH;
			sim[i][j] = sim[i-1][j-1] + val;
			help[i][j] = 'd';
			if (sim[i-1][j] + ALIGN_GAP > sim[i][j] && sim[i-1][j] + ALIGN_GAP > sim[i][j-1] + ALIGN_GAP) {
				sim[i][j] = sim[i-1][++indj] + ALIGN_GAP;
				help[i][j] = 'h';
			}
			else if (sim[i][j-1] + ALIGN_GAP > sim[i][j]) {
				sim[i][j] = sim[++indi][j-1] + ALIGN_GAP;
				help[i][j] = 'g';
			}
			ind[i][j] = std::make_pair(indi,indj);
		}
	}
	for (i = 0; i < lsize; i++) {
		for (j = 0; j < esize; j++)
			std::cout << sim[i][j] << "\t";
		std::cout << std::endl;
	}
	std::cout << std::endl;
	for (i = 0; i < lsize; i++) {
		for (j = 0; j < esize; j++)
			std::cout << "(" << ind[i][j].first << "," << ind[i][j].second << ")\t";
		std::cout << std::endl;
	}
	std::cout << std::endl;
	for (i = 0; i < lsize; i++) {
		for (j = 0; j < esize; j++)
			std::cout << help[i][j] << "\t";
		std::cout << std::endl;
	}
	std::cout << std::endl;
	path p;
	std::pair<int,int> pind = ind[lsize-1][esize-1];
	while(pind.first >= 0 && pind.second >= 0) {
		p.push_back(pind);
		pind = ind[pind.first][pind.second];
	}
	std::reverse(p.begin(),p.end());
	std::cout << "path : ";
	for (i = 0; i < p.size(); i++)
		std::cout << "(" << p.at(i).first << "," << p.at(i).second << ") ";
	std::cout << std::endl << std::endl;
	for (i = 0; i < p.size(); i++) {
		indi = p.at(i).first;
		indj = p.at(i).second;
		if ((i < p.size()-1 && indi == p.at(i+1).first) || indi >= (int)l.size())
			e.at(indj)->aligned.reset();
		else if ((i < p.size()-1 && indj == p.at(i+1).second) || indj >= (int)e.size()) 
			l.at(indi)->aligned.reset();
		else {
			if (l.at(indi)->isSequence() && e.at(indj)->isSequence())
				findBestAlignment(dynamic_cast<Sequence*>(l.at(indi).get())->getTraces(), dynamic_cast<Sequence*>(e.at(indj).get())->getTraces());
			l.at(indi)->aligned = e.at(indj);
			e.at(indj)->aligned = l.at(indi);
		}
	}
	for (i = 0; i < lsize; i++) {
		delete[] sim[i];
		delete[] ind[i];
		delete[] help[i];
	}
	delete[] sim;
	delete[] ind;
	delete[] help;
	return p;
}

void TracesAnalyser::displayAlignment(const std::vector<sp_trace>& l, const std::vector<sp_trace>& e) {
	unsigned int i = 0, j = 0;
	while (i < l.size() || j < e.size()) {
		if (i < l.size() && j < e.size() && l.at(i)->aligned && e.at(j)->aligned) {
			//l.at(i)->aligned is equal to e.at(j) in this case
			l.at(i)->display();
			std::cout << "with" << std::endl;
			l.at(i)->aligned->display();
			if (l.at(i)->isSequence() && l.at(i)->aligned->isSequence()) {
				std::cout << "enter both sequence" << std::endl;
				displayAlignment(dynamic_cast<Sequence*>(l.at(i).get())->getTraces(), dynamic_cast<Sequence*>(l.at(i)->aligned.get())->getTraces());
				std::cout << "exit both sequence" << std::endl;
			}
			i++;
			j++;
		}
		else if (i < l.size() && !l.at(i)->aligned) {
			l.at(i++)->display();
			std::cout << "with" << std::endl;
			std::cout << "\t-" << std::endl;
		}
		else if (j < e.size() && !e.at(j)->aligned) {
			std::cout << "\t-" << std::endl;
			std::cout << "with" << std::endl;
			e.at(j++)->display();
		}
		std::cout << std::endl;
	}
}