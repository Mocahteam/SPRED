#ifndef __EVENT_H__
#define __EVENT_H__

#define NUM_CONCAT_EVENTS 2
#define NUM_NO_CONCAT_EVENTS 5

#include <iostream>

#include "Trace.h"
#include "Sequence.h"

class Event : public Trace {
	
public:
		
	Event(std::string label);
	
	static const char* concatEventsArr[NUM_CONCAT_EVENTS+1];
	static const char* noConcatEventsArr[NUM_NO_CONCAT_EVENTS+1];
	
	virtual unsigned int length() const;
	virtual bool operator==(Trace* t);
	virtual void display(std::ostream &os = std::cout) const;
	virtual std::string getParams() const;
	
	std::string getLabel() const;
	
protected:
	
	std::string label;

};

typedef boost::shared_ptr<Event> sp_event;

#endif