#ifndef __CALL_H__
#define __CALL_H__

#define MAX_SIZE_PARAMS 2

#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <vector>
#include <algorithm>
#include <stdexcept>
#include <rapidjson/document.h>
#include <boost/lexical_cast.hpp>

#include "Trace.h"
#include "Sequence.h"

typedef std::vector<std::string> string_vector;

class ParamsMap {
	
	std::map<std::string,string_vector> map;
		
public:

	ParamsMap() {
		std::ifstream ifs("params.json", std::ios::binary);
		if (ifs.good()) {
			std::stringstream ss;
			ss << ifs.rdbuf();
			rapidjson::Document doc;
			doc.Parse(ss.str().c_str());
			if (doc.IsObject()) {
				for (rapidjson::Value::ConstMemberIterator it = doc.MemberBegin(); it != doc.MemberEnd(); it++) {
					string_vector v;
					for (rapidjson::Value::ConstMemberIterator _it = it->value.MemberBegin(); _it != it->value.MemberEnd(); _it++) {
						if (_it->value.GetType() == 2) {
							//_it->value.GetType() is equal to true
							v.push_back(_it->name.GetString());
						}
					}
					map.insert(std::make_pair<std::string,string_vector>(it->name.GetString(),v));
				}
			}
		}
		else
			throw std::runtime_error("cannot open JSON params file");
	}
	
	bool contains(std::string label, std::string param) const {
		return map.find(label) != map.end() && std::find(map.at(label).begin(), map.at(label).end(), param) != map.at(label).end();
	}
	
};

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
	static const ParamsMap paramsMap;
	
	static ErrorType getErrorType(const char *ch);
	static const char* getErrorLabel(ErrorType err);
	
	virtual unsigned int length() const;
	virtual bool operator==(Trace* t);
	virtual void display(std::ostream &os = std::cout) const;
	virtual std::string getParams() const = 0;
	
	std::string getLabel() const;
	ErrorType getError() const;
	bool addReturnCode(float code);
	std::string getReturn() const;
	bool compareReturn(Call *c) const;
	void setIndRet();
	
protected:

	virtual bool compare(Call *c) = 0;
	
	std::string label;
	ErrorType error;
	int ind_ret;
	float ret[MAX_SIZE_PARAMS];
		
};

#endif