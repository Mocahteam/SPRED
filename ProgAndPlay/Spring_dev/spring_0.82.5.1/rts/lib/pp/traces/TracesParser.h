#ifndef __TRACES_PARSER_H__
#define __TRACES_PARSER_H__

#include <iostream>
#include <string>
#include <vector>
#include <stack>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <windows.h>
#include <boost/lexical_cast.hpp>
#include <rapidxml-1.13/rapidxml.hpp>
#include <rapidxml-1.13/rapidxml_print.hpp>
#include <rapidxml-1.13/rapidxml_utils.hpp>

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
	
	void parseTraceFileOnline(const std::string& dir_path, const std::string& filename, bool on_writing = false);
	void parseTraceFileOffline(const std::string& dir_path, const std::string& filename, bool on_writing = false);
	void parseTraceFile(const std::string& dir_path, const std::string& filename);
	void display(std::ostream &os = std::cout);
	void setEnd();
	bool compressionDone();
	const std::vector<sp_trace>& getTraces() const;
	
	static sp_sequence mergeSequences(sp_sequence sps_up, sp_sequence sps_down);
	static std::vector<sp_trace> importTraceFromXml(const std::string& dir_path, const std::string& filename);
	static std::vector<std::string> splitLine(const std::string& s, char delim = ' ');
	static int stoi(const std::string& s);
	static float stof(const std::string& s);
	
private:

	static std::string mission_name;
	static int mission_end_time;
	static sp_trace spe_eme;

	bool launched;
	bool compress;
	bool end;
	
	int start;
	unsigned int pt;
	unsigned int ind_start;
	
	std::ifstream ifs;
	std::string dir_path;
	std::string filename;
	
	std::vector<sp_trace> traces;
	
	std::vector<sp_trace> tracesSave;
	std::stack<sp_sequence> seqStack;
	std::stack<sp_sequence> histStack;
	sp_sequence cur_seq;
	
	bool beginParse(const std::string& dir_path, const std::string& filename);
	void endParse();
	void writeFiles(bool online);
	
	void readTracesOnline();
	void readTracesOnlineOnWriting();
	void readTracesOffline();
	void readTracesOfflineOnWriting();
	void exportTraceToXml();
	bool reachLastStart();
	
	static sp_trace handleLine(const std::string& s);
	static WrongCall* handleError(Call::ErrorType err, const std::vector<std::string>& tokens, int ind);
	
	//Online
	bool doCheckOnline(sp_trace spt);
	bool handleTraceOnline(const sp_trace& spt, bool onWriting = false);
	void sequenceDetected();
	bool searchSequence(const sp_trace& spt);
	void findSequence();
	void compactHistory();
	
	//Offline
	void handleTraceOffline(const sp_trace& spt);
	bool checkFeasibility(unsigned int min_length, unsigned int ind_start);
	void detectSequences();

};

#endif