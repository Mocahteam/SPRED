#ifndef __EVENT_H__
#define __EVENT_H__

#include <iostream>

#include "Trace.h"

class Event : public Trace {
	
public:

	typedef boost::shared_ptr<Event> sp_event;
		
	Event(std::string label, std::string info = "");
	Event(const Event *e);
	
	static const char* concatEventsArr[];
	static const char* noConcatEventsArr[];
	
	virtual unsigned int length() const;
	virtual bool operator==(Trace *t) const;
	virtual Trace::sp_trace clone() const;
	virtual void display(std::ostream &os = std::cout) const;
	virtual std::string getParams() const;
	
	std::string getLabel() const;
	
protected:
	
	std::string label;

};

#endif