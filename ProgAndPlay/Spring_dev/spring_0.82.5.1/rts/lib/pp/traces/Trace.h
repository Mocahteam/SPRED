#ifndef __TRACE_H__
#define __TRACE_H__

#include <vector>
#include <iostream>
#include <string.h>
#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>

class Trace {

public:

	typedef boost::shared_ptr<Trace> sp_trace;

	enum TraceType {
		SEQUENCE,
		CALL,
		EVENT
	};

	virtual ~Trace() {}
	virtual unsigned int length() const = 0;
	virtual bool operator==(Trace *t) const = 0;
	virtual void display(std::ostream &os = std::cout) const = 0;
	virtual void resetAligned();
	
	static int inArray(const char *ch, const char *arr[]);
	static unsigned int getLength(const std::vector<sp_trace>& traces);
	
	static int numTab;
	int indSearch;
	unsigned int lenSearch;
	unsigned int endSearch;
	
	bool isSequence() const;
	bool isEvent() const;
	bool isCall() const;
	bool isDelayed() const;
	void setDelayed();
	const sp_trace& getParent() const;
	const sp_trace& getAligned() const;
	void setParent(const sp_trace& spt);
	void setAligned(const sp_trace& spt);
	unsigned int getLevel() const;
		
protected:

	Trace(TraceType type = CALL);
	TraceType type;
	bool delayed;
	// Contains a pointer to the trace aligned with this trace during the alignment stage.
	sp_trace aligned;
	// Contains the parent sequence which contains this trace. Is null if the trace is located at the root.
	sp_trace parent;
	
};

#endif