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
	
	TracesParser(bool in_game);
	~TracesParser();
	
	static int lineNum;
	
	void parseTraceFileOnline(const std::string& dir_path, const std::string& filename);
	void parseTraceFileOffline(const std::string& dir_path, const std::string& filename);
	void parseTraceFile(const std::string& dir_path, const std::string& filename);
	void initParamsMap(const std::string& json);
	void display(std::ostream &os = std::cout);
	void setEnd();
	bool compressionDone();
	void setProceed(bool proceed);
	bool getProceed();
	const std::vector<Trace::sp_trace>& getTraces() const;
	
	static Trace::sp_trace handleLine(const std::string& s);
	static Sequence::sp_sequence mergeSequences(Sequence::sp_sequence sps_up, Sequence::sp_sequence sps_down);
	static void removeRedundancies(std::vector<Trace::sp_trace>& traces);
	static std::vector<Trace::sp_trace> importTraceFromXml(const std::string& xml);
	static void importTraceFromNode(rapidxml::xml_node<> *node, std::vector<Trace::sp_trace>& traces);
	static unsigned int getNodeChildCount(rapidxml::xml_node<> *node);
	static std::vector<std::string> splitLine(const std::string& s, char delim = ' ');
	static int stoi(const std::string& s);
	static float stof(const std::string& s);
	
private:

	static std::string mission_name;
	static int mission_end_time;
	static Trace::sp_trace spe_eme;

	bool in_game;
	bool used;
	bool compressed;
	bool end;
	bool proceed;
	
	int start;
	unsigned int pt;
	unsigned int ind_start;
	
	std::ifstream ifs;
	std::string dir_path;
	std::string filename;
	
	std::vector<Trace::sp_trace> traces;
	
	std::vector<Trace::sp_trace> tracesSave;
	std::stack<Sequence::sp_sequence> seqStack;
	std::stack<Sequence::sp_sequence> histStack;
	Sequence::sp_sequence cur_seq;
	
	bool beginParse(const std::string& dir_path, const std::string& filename);
	void endParse();
	void writeFiles(bool online);
	
	void readTracesOnline();
	void readTracesOnlineInGame();
	void readTracesOffline();
	void readTracesOfflineInGame();
	void exportTraceToXml();
	bool reachLastStart();
	
	//Online
	bool doCheckOnline(Trace::sp_trace spt);
	bool handleTraceOnline(const Trace::sp_trace& spt);
	void sequenceDetected();
	bool searchSequence(const Trace::sp_trace& spt);
	void findSequence();
	void compactHistory();
	
	//Offline
	void handleTraceOffline(const Trace::sp_trace& spt);
	bool checkFeasibility(unsigned int min_length, unsigned int ind_start);
	void detectSequences();

};

#endif