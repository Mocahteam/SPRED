#ifndef __CALL_H__
#define __CALL_H__

#include "Trace.h"
#include "Sequence.h"

#include <iostream>

class Call : public Trace {
	
public:

	enum ErrorType {
		NONE = -1,
		OUT_OF_RANGE,
		WRONG_COALITION,
		WRONG_UNIT,
		WRONG_TARGET,
		WRONG_POSITION
	};
		
	Call(std::string label, ErrorType err = NONE);
	
	static const char* errorsArr[6];
	static ErrorType getErrorType(const char *ch);
	static const char* getErrorLabel(ErrorType err);
	
	virtual unsigned int length() const;
	virtual bool operator==(Trace* t);
	virtual void display(std::ostream &os = std::cout) const;
	virtual std::string getParams() const = 0;
	
	std::string getLabel() const;
	ErrorType getError() const;
	
protected:

	virtual bool compare(Call *c) const = 0;
	
	std::string label;
	ErrorType error;
		
};

#endif