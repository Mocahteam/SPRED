#ifndef __TRACE_H__
#define __TRACE_H__

#define MAX_SIZE_PARAMS 2

#include <iostream>
#include <string.h>
#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>

class Trace {

public:

	enum TraceType {
		SEQUENCE,
		CALL,
		EVENT
	};

	virtual ~Trace() {}
	virtual unsigned int length() const = 0;
	virtual bool operator==(Trace* t) = 0;
	virtual void display(std::ostream &os = std::cout) const = 0;
	
	static int inArray(const char *ch, const char *arr[]);
	
	static unsigned int numTab;
	int indSearch;
	unsigned int lenSearch;
	unsigned int endSearch;
	
	TraceType getType() const;
	bool isSequence() const;
	bool isDelayed() const;
	void setDelayed();
		
protected:

	Trace(TraceType type = CALL);
	TraceType type;
	bool delayed;
	
};

typedef boost::shared_ptr<Trace> sp_trace;

#endif