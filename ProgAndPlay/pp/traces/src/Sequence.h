#ifndef __SEQUENCE_H__
#define __SEQUENCE_H__

#include "Trace.h"

#include <iostream>
#include <stack>
#include <vector>
#include <algorithm>

class Sequence : public Trace {
	
public:
	
	Sequence(unsigned int num = 1, bool shared = false);
	
	virtual unsigned int length() const;
	virtual bool operator==(Trace* t);
	virtual void display(std::ostream &os = std::cout) const;
	
	unsigned int getNum() const;
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
	void resetValid(bool v);
	bool checkValid();
	
	bool isUniform() const;
	bool checkDelayed();
	
	void removeRedundancies();

protected:

	std::vector<sp_trace> traces;
	unsigned int num;
	unsigned int pt;
	bool valid;
	bool endReached;
	bool shared;
	
};

typedef boost::shared_ptr<Sequence> sp_sequence;

#endif