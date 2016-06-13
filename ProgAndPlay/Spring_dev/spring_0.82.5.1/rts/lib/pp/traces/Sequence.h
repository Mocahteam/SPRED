#ifndef __SEQUENCE_H__
#define __SEQUENCE_H__

#include <iostream>
#include <sstream>
#include <stack>
#include <vector>
#include <algorithm>
#include <map>
#include <cmath>
#include <boost/lexical_cast.hpp>

#include "Trace.h"
#include "Event.h"

class Sequence : public Trace {
	
public:

	typedef boost::shared_ptr<Sequence> sp_sequence;
	
	Sequence(std::string info);
	Sequence(unsigned int num);
	Sequence(sp_sequence sps);
	Sequence(sp_sequence sps_up, sp_sequence sps_down);
	
	virtual unsigned int length() const;
	virtual bool operator==(Trace *t) const;
	virtual void display(std::ostream &os = std::cout) const;
	virtual void resetAligned();
	bool compare(Trace *t);
	
	template<typename T>
	static std::string getNumMapString(const std::map<unsigned int,T>& numMap) {
		std::stringstream ss;
		typename std::map<unsigned int,T>::const_iterator it = numMap.begin();
		while (it != numMap.end()) {
			if (it != numMap.begin())
				ss << " ";
			ss << it->first << ":" << it->second;
			it++;
		}
		return ss.str();
	}
	
	std::vector<Trace::sp_trace>& getTraces();
	unsigned int getNum() const;
	std::string getInfo() const;
	const std::map<unsigned int,unsigned int>& getNumMap() const;
	unsigned int getPt() const;
	bool isEndReached() const;
	bool isShared() const;
	void addOne();
	unsigned int size() const;
	void addTrace(const Trace::sp_trace& spt);
	const Trace::sp_trace& at(unsigned int i) const;
	const Trace::sp_trace& next();
	void reset();
	
	bool isValid() const;
	void setValid(bool v);
	bool checkValid();
	bool isUniform() const;
	bool checkDelayed();
	
	void updateNumMap(unsigned int num, int update = 1);
	void updateNumMap(const std::map<unsigned int,unsigned int>& numMap);
	void completeNumMap(const sp_sequence& sps);
	std::map<unsigned int,double> getPercentageNumMap() const;
	double getNumMapMeanDistance(const sp_sequence& sps) const;
	bool isImplicit();
	
protected:

	std::string info;
	std::vector<Trace::sp_trace> traces;
	unsigned int num;
	std::map<unsigned int,unsigned int> numMap;
	unsigned int pt;
	bool valid;
	bool endReached;
	bool shared;
	
};

#endif