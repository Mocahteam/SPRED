#ifndef __SEQUENCE_H__
#define __SEQUENCE_H__

#include <iostream>
#include <stack>
#include <vector>
#include <algorithm>
#include <map>
#include <boost/lexical_cast.hpp>

#include "Trace.h"
#include "Event.h"

class Sequence : public Trace {
	
public:
	
	Sequence();
	Sequence(unsigned int num);
	Sequence(boost::shared_ptr<Sequence> sps);
	Sequence(boost::shared_ptr<Sequence> sps_up, boost::shared_ptr<Sequence> sps_down);
	
	virtual unsigned int length() const;
	virtual bool operator==(Trace* t);
	virtual void display(std::ostream &os = std::cout) const;
	bool compare(Trace *t);
	
	static void removeRedundancies(std::vector<sp_trace>& traces);
	
	std::vector<sp_trace>& getTraces();
	unsigned int getNum() const;
	const std::map<unsigned int,unsigned int>& getNumMap() const;
	std::string getNumMapString() const;
	unsigned int getPt() const;
	bool isEndReached() const;
	bool isShared() const;
	void addOne();
	unsigned int size() const;
	void addTrace(const sp_trace& spt);
	const sp_trace& at(unsigned int i) const;
	const sp_trace& next();
	void reset();
	
	bool isValid() const;
	void setValid(bool v);
	bool checkValid();
	bool isUniform() const;
	bool checkDelayed();
	
	void updateNumMap(unsigned int num, int update = 1);
	void updateNumMap(const std::map<unsigned int,unsigned int>& numMap);
	
protected:

	std::vector<sp_trace> traces;
	unsigned int num;
	std::map<unsigned int,unsigned int> numMap;
	unsigned int pt;
	bool valid;
	bool endReached;
	bool shared;
	
};

typedef boost::shared_ptr<Sequence> sp_sequence;

#endif