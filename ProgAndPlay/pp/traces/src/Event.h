#ifndef __EVENT_H__
#define __EVENT_H__

#include "Trace.h"
#include "Sequence.h"

#include <iostream>

class Event : public Trace {
	
public:
		
	Event(std::string label);
	
	virtual unsigned int length() const;
	virtual bool operator==(Trace* t);
	virtual void display(std::ostream &os = std::cout) const;
	virtual std::string getParams() const;
	
	std::string getLabel() const;
	
protected:
	
	std::string label;

};

#endif