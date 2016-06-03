#ifndef __TRACES_ANALYSER_H__
#define __TRACES_ANALYSER_H__

#include <iostream>
#include <cstdlib>
#include <ctime>
#include <dirent.h>
#include <vector>
#include <map>
#include <stack>
#include <limits>
#include <algorithm>
#include <rapidxml-1.13/rapidxml.hpp>
// #include <boost/bimap.hpp>

#include "Trace.h"
#include "Call.h"
#include "Sequence.h"
#include "Event.h"
#include "EventDef.h"

#define EXPERT_TRACES_DIRNAME "xml\\expert"
#define IN_GAME_EXPERT_TRACES_DIRNAME "traces\\data\\expert"

#define FEEDBACKS_FILENAME "feedbacks.xml"

#define USELESS_FREQ 0
#define USEFUL_FREQ 1

// scores used for alignment
#define ALIGN_MATCH_SCORE 1
#define ALIGN_MISMATCH_SCORE -1
#define ALIGN_GAP_SCORE 0

// macro for change score range from [0,1] to [INF,SUP]
#define INF -1
#define SUP 1
#define TRANSFORM_SCORE(val) ((SUP - INF) * val + INF)

class TracesAnalyser {
	
public:

	enum FeedbackType {
		NONE,
		USEFUL_CALL, 	// most experts have used this call but the player hasn't
		USELESS_CALL, 	// the player has used this call but only a few expert has used it
		SEQ_EXTRA, 		// the player has a sequence than the chosen expert hasn't
		SEQ_LACK, 		// the chosen expert has a sequence than the player hasn't
		SEQ_NUM,		// notable difference between the num maps of the aligned sequences
		CALL_EXTRA,		// the player has a call than the chosen expert hasn't
		CALL_LACK,		// the chosen expert has a call than the player hasn't
		CALL_PARAMS		// notable difference between the parameters of the aligned calls
	};
	
	typedef std::vector< std::pair<int,int> > path;
	// typedef boost::bimap<FeedbackType,std::string> feedback_type_bm;
	typedef std::map<FeedbackType,std::string> left_fbt_map;
	typedef std::map<std::string,FeedbackType> right_fbt_map;
	
	// static feedback_type_bm feedbackTypeBimap;
	static left_fbt_map leftFbtMap;
	static right_fbt_map rightFbtMap;
	
	
	struct Feedback {
		FeedbackType type;
		std::string info;
		Trace::sp_trace learner_spt;
		Trace::sp_trace expert_spt;
		int priority;
		
		bool operator<(const Feedback& f) const {
			return priority < f.priority || (learner_spt && f.learner_spt && learner_spt->getLevel() < f.learner_spt->getLevel()) || (expert_spt && f.expert_spt && expert_spt->getLevel() < f.expert_spt->getLevel()) || ((learner_spt || expert_spt) && !f.learner_spt && !f.expert_spt);
		}
		
		//used to affect a priority level to a new feedback
		double getScore(const Feedback& f) const {
			Trace::sp_trace t[2] = {learner_spt,expert_spt};
			Trace::sp_trace ft[2] = {f.learner_spt,f.expert_spt};
			double score[2] = {0,0};
			for (unsigned int i = 0; i < 2; i++) {
				if (t[i] && ft[i]) {
					if (t[i]->isCall() && ft[i]->isCall()) {
						Call *c = dynamic_cast<Call*>(t[i].get());
						Call *fc = dynamic_cast<Call*>(ft[i].get());
						score[i] = 1 - c->getEditDistance(fc);
					}
					else if (t[i]->isSequence() && ft[i]->isSequence()) {
						Sequence *s = dynamic_cast<Sequence*>(t[i].get());
						Sequence *fs = dynamic_cast<Sequence*>(ft[i].get());
						score[i] = TracesAnalyser::findBestAlignment(s->getTraces(),fs->getTraces(),false) / std::max(Trace::getLength(s->getTraces()),Trace::getLength(fs->getTraces()));
					}
				}
			}
			return std::max(score[0],score[1]);
		}
		
		void display() {
			std::cout << "feedback : " << info << std::endl;
			std::cout << "type : " << TracesAnalyser::leftFbtMap.at(type) << std::endl;
			if (learner_spt) {
				std::cout << "learner : " << std::endl;
				learner_spt->display();
			}
			if (expert_spt) {
				std::cout << "expert : " << std::endl;
				expert_spt->display();
			}
			std::cout << "priority : " << priority << std::endl;
		}

	};

	struct GameInfos {
		StartMissionEvent *sme;
		EndMissionEvent *eme;
		NewExecutionEvent *nee;
		EndExecutionEvent *eee;
		std::vector<Trace::sp_trace> mission_traces;
		std::vector<Trace::sp_trace> exec_traces;
		
		GameInfos() : sme(NULL), eme(NULL), nee(NULL), eee(NULL) {}
		
		void clearMission() { 
			sme = NULL;
			eme = NULL;
			mission_traces.clear();
			clearExecution();
		}
		
		void clearExecution() {
			nee = NULL;
			eee = NULL;
			exec_traces.clear();
		}
		
		int getResolutionTime() {
			int time = std::numeric_limits<int>::max();
			if (sme != NULL && eme != NULL && eme->getStatus().compare("won") == 0)
				time = eme->getEndTime() - sme->getStartTime();
			return time;
		}
		
		int getExecutionTime() {
			int time = std::numeric_limits<int>::max();
			if (nee != NULL && eee != NULL)
				time = eee->getEndTime() - nee->getStartTime();
			return time;
		}
		
		int getNumExecutions() {
			int num = 0;
			for (unsigned int i = 0; i < mission_traces.size(); i++) {
				if (mission_traces.at(i)->isEvent() && dynamic_cast<Event*>(mission_traces.at(i).get())->getLabel().compare("new_execution") == 0)
					num++;
			}
			return num;
		}
		
		double getAverageWaitTime() {
			EndExecutionEvent *eee = NULL;
			double avg = 0;
			int cpt = 0;
			bool in = false;
			for (unsigned int i = 0; i < mission_traces.size(); i++) {
				if (mission_traces.at(i)->isEvent()) {
					Event *e = dynamic_cast<Event*>(mission_traces.at(i).get());
					if (e->getLabel().compare("new_execution") == 0) {
						if (!in) {
							in = true;
							cpt++;
							if (eee != NULL) {
								avg += dynamic_cast<NewExecutionEvent*>(e)->getStartTime() - eee->getEndTime();
								eee = NULL;
							}
						}
						else
							return -1;
					}
					else if (e->getLabel().compare("end_execution") == 0) {
						in = false;
						eee = dynamic_cast<EndExecutionEvent*>(e);
					}
				}
			}
			if (--cpt == 0)
				return -1;
			else
				return avg / cpt;
		}
		
	};

	TracesAnalyser(bool in_game);

	std::string getFeedback(const std::string& dir_path, const std::string& filename, int ind_mission = -1, int ind_execution = -1);
	
	static int getRandomIntInRange(int min, int max);
	
private:

	bool in_game;
	std::string expert_traces_dirname;
	GameInfos learner_gi, expert_gi;
	std::vector<Feedback> feedbacks_ref;
	std::map<std::string,double> experts_calls_freq;
	
	void init();
	void importFeedbacksFromXml();
	void importFeedbacksFromExperts();
	
	bool getInfosOnMission(const std::vector<Trace::sp_trace>& traces, GameInfos& gi, int ind_mission = -1);
	bool getInfosOnExecution(GameInfos& gi, int ind_execution = -1);
	std::vector<std::string> findExpertTracesFilenames();
	
	static bool addImplicitSequences(std::vector<Trace::sp_trace>& mod, const std::vector<Trace::sp_trace>& ref);
	static std::vector<Call::call_vector> getPatterns(const std::vector<Trace::sp_trace>& traces, const Call::call_vector& pattern);
	static const Sequence::sp_sequence getClosestCommonParent(const Call::call_vector& pattern);
	
	static double findBestAlignment(const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e, bool align = true);
	static void displayAlignment(const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e);
	
	void listFeedbacks(const std::vector<Trace::sp_trace>& l, const std::vector<Trace::sp_trace>& e, std::vector<Feedback>& feedbacks);
	void sortFeedbacks(std::vector<Feedback>& feedbacks);
	static void setFeedbackInfo(Feedback &f, const Feedback &f_ref);
	
};

#endif