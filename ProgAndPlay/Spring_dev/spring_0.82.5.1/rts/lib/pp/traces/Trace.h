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
	virtual sp_trace clone() const = 0;
	virtual void display(std::ostream &os = std::cout) const = 0;
	virtual void resetAligned();
	
	static int inArray(const char *ch, const char *arr[]);
	static unsigned int getLength(const std::vector<sp_trace>& traces);
	static sp_trace getNeighbour(std::vector<sp_trace>& traces, sp_trace& spt, int add_to_ind);
	
	static int numTab;
	int indSearch;
	unsigned int lenSearch;
	unsigned int endSearch;
	
	bool isSequence() const;
	bool isEvent() const;
	bool isCall() const;
	bool isDelayed() const;
	void setDelayed();
	std::string getInfo() const;
	void setInfo(std::string info);
	const sp_trace& getParent() const;
	const sp_trace& getAligned() const;
	void setParent(const sp_trace& spt);
	void setAligned(const sp_trace& spt);
	unsigned int getLevel() const;
		
protected:

	Trace(TraceType type, std::string info = "");
	
	/// the type of the trace : CALL, EVENT or SEQUENCE
	TraceType type;
	
	/// label added by the expert in the XML file. Is set only if the trace comes from XML import.
	std::string info;
	
	/// [DEPRECATED] is set to true if the trace is delayed 
	bool delayed;
	
	/// contains a pointer to the trace aligned with this trace during the alignment stage.
	sp_trace aligned;
	
	/// Contains the parent sequence which contains this trace. Is null if the trace is located at the root.
	sp_trace parent;
	
};

#endif