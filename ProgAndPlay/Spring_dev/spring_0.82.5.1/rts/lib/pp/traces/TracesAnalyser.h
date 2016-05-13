#ifndef __TRACES_ANALYSER_H__
#define __TRACES_ANALYSER_H__

#include <dirent.h>
#include <vector>
#include <iostream>

#include "TracesParser.h"
#include "Sequence.h"
#include "Event.h"
#include "EventDef.h"

typedef std::vector< std::pair<int,int> > path;

class TracesAnalyser {
	
public:

	struct GameInfos {
		StartMissionEvent *sme;
		EndMissionEvent *eme;
		NewExecutionEvent *nee;
		EndExecutionEvent *eee;
		std::vector<sp_trace> mission_traces;
		std::vector<sp_trace> exec_traces;
		
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
		
		void display() {
			if (sme != NULL)
				std::cout << sme->getParams() << std::endl;
			if (eme != NULL)
				std::cout << eme->getParams() << std::endl;
			if (nee != NULL)
				std::cout << nee->getParams() << std::endl;
			if (eee != NULL)
				std::cout << eee->getParams() << std::endl;
			for (unsigned int i = 0; i < mission_traces.size(); i++)
				mission_traces.at(i)->display();
			if (!mission_traces.empty())
				std::cout << std::endl;
			for (unsigned int i = 0; i < exec_traces.size(); i++)
				exec_traces.at(i)->display();
			if (!exec_traces.empty())
				std::cout << std::endl;
		}
	};

	TracesAnalyser(const std::vector<sp_trace>& learner_traces);
	
	static path findBestAlignment(const std::vector<sp_trace>& l, const std::vector<sp_trace>& e);
	static float getSimilarityScore(const std::vector<sp_trace>& l, const std::vector<sp_trace>& e);
	static void displayAlignment(const std::vector<sp_trace>& l, const std::vector<sp_trace>& e);
	static int getEditDistance(const std::vector<sp_trace>& l, const std::vector<sp_trace>& e);
	
	void compareExecutionTrace(int ind_mission = -1, int ind_execution = -1);
	
private:

	std::vector<sp_trace> learner_traces;
	
	bool getInfosOnMission(const std::vector<sp_trace>& traces, GameInfos& gi, int ind_mission = -1);
	bool getInfosOnExecution(GameInfos& gi, int ind_execution = -1);
	std::vector<std::string> findExpertTracesFilenames(const std::string& mission_name);
	
};

#endif