#ifndef __TRACES_PARSER_H__
#define __TRACES_PARSER_H__

#define NUM_EVENT 2

#include <iostream>
#include <stack>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <windows.h>
#include <boost/lexical_cast.hpp>
#include "rapidxml-1.13/rapidxml.hpp"
#include "rapidxml-1.13/rapidxml_print.hpp"
#include "rapidxml-1.13/rapidxml_utils.hpp"

#include "Trace.h"
#include "Call.h"
#include "CallDef.h"
#include "Event.h"
#include "EventDef.h"
#include "Sequence.h"

class TracesParser {

public:
	
	TracesParser();
	~TracesParser();
	
	static int lineNum;
	static const char* eventsArr[NUM_EVENT+1];
	static std::string mission_name;
	static int mission_end_time;
	
	void parseTraceFileOnline(std::string dir_path, std::string filename, bool on_writing = false);
	void parseTraceFileOffline(std::string dir_path, std::string filename, bool on_writing = false);
	void display(std::ostream &os = std::cout);
	void setEnd();
	bool compressionDone();
	void compressionRead();
	std::vector<sp_trace> getTraces() const;
	
	static sp_sequence mergeSequences(sp_sequence sps_up, sp_sequence sps_down);
	static std::vector<sp_trace> importTraceFromXml(std::string dir_path, std::string filename);
	static std::vector<std::string> splitLine(std::string s, char delim = ' ');
	static int stoi(std::string s);
	static float stof(std::string s);
	
private:

	bool launched;
	bool exec;
	bool compress;
	bool mod;
	bool end;
	int start;
	unsigned int pt;
	
	std::ifstream ifs;
	std::ofstream ofs;
	std::ofstream ofsXml;
	
	std::vector<sp_trace> traces;
	
	std::vector<sp_trace> tracesSave;
	std::stack<Sequence*> seqStack;
	std::stack<Sequence*> histStack;
	Sequence *cur_seq;
	Sequence *hist_seq;
	
	bool beginParse(const std::string& dir_path, const std::string& filename);
	void endParse();
	
	void readTracesOnline();
	void readTracesOnlineOnWriting();
	void readTracesOffline();
	void readTracesOfflineOnWriting();
	void exportTraceToXml();
	bool reachLastStart();
	
	static sp_trace handleLine(std::string s);
	static WrongCall* handleError(Call::ErrorType err, std::vector<std::string> const &tokens, int ind);
	
	//Online
	bool doCheckOnline(Trace* t);
	bool handleTraceOnline(const sp_trace& spt);
	void sequenceDetected();
	bool searchSequence(Trace *t);
	void findSequence();
	void compactHistory(int start);
	void removeRedundancies();
	
	//Offline
	void handleTraceOffline(const sp_trace& spt);
	bool checkFeasibility(unsigned int min_length, unsigned int ind_start);
	void detectSequences();

};

#endif