#ifndef __TRACE_H__
#define __TRACE_H__

#include <vector>
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
	static unsigned int getLength(const std::vector< boost::shared_ptr<Trace> >& traces);
	
	static int numTab;
	int indSearch;
	unsigned int lenSearch;
	unsigned int endSearch;
	
	bool isSequence() const;
	bool isEvent() const;
	bool isCall() const;
	bool isDelayed() const;
	void setDelayed();
	
	boost::shared_ptr<Trace> aligned;
		
protected:

	Trace(TraceType type = CALL);
	TraceType type;
	bool delayed;
	
};

typedef boost::shared_ptr<Trace> sp_trace;

#endif