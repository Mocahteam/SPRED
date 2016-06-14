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

#define PARAMS_FILENAME "params.json"
#define IN_GAME_DATA_DIRNAME "traces\\data\\"

#define EDIT_MATCH_SCORE 0
#define EDIT_MISMATCH_SCORE 1
#define EDIT_GAP_SCORE 1

class ParamsMap {
		
public:

	ParamsMap() : loaded(false) {}
	
	void initMap(bool in_game) {
		if (!loaded) {
			std::string filename = PARAMS_FILENAME;
			if (in_game)
				filename.insert(0,IN_GAME_DATA_DIRNAME);
			std::ifstream ifs(filename.c_str(), std::ios::binary);
			if (ifs.good()) {
				std::stringstream ss;
				ss << ifs.rdbuf();
				rapidjson::Document doc;
				doc.Parse(ss.str().c_str());
				if (doc.IsObject()) {
					for (rapidjson::Value::ConstMemberIterator it = doc.MemberBegin(); it != doc.MemberEnd(); it++) {
						string_vector v;
						for (rapidjson::Value::ConstMemberIterator _it = it->value.MemberBegin(); _it != it->value.MemberEnd(); _it++) {
							if (_it->value.IsBool() && _it->value.GetBool())
								v.push_back(_it->name.GetString());
						}
						map.insert(std::make_pair<std::string,string_vector>(it->name.GetString(),v));
					}
					loaded = true;
				}
			}
			else
				throw std::runtime_error("cannot open JSON params file");
		}
	}
	
	bool contains(std::string label, std::string param) const {
		return map.find(label) != map.end() && std::find(map.at(label).begin(), map.at(label).end(), param) != map.at(label).end();
	}
	
private:

	typedef std::vector<std::string> string_vector;
	std::map<std::string,string_vector> map;
	bool loaded;
	
};

class Call : public Trace {
	
public:

	typedef boost::shared_ptr<Call> sp_call;
	typedef std::vector<sp_call> call_vector;

	enum ErrorType {
		NONE = -1,
		OUT_OF_RANGE,
		WRONG_COALITION,
		WRONG_UNIT,
		WRONG_TARGET,
		WRONG_POSITION
	};
		
	Call(std::string label, ErrorType err);
	
	static const char* errorsArr[];
	static const char* coalitionsArr[];
	static const char* noParamCallLabelsArr[];
	static const char* unitCallLabelsArr[];
	static ParamsMap paramsMap;
		
	template<typename E>
	static E getEnumType(const char *ch, const char **arr) {
		return static_cast<E>(Trace::inArray(ch,arr));
	}

	template<typename E>
	static const char* getEnumLabel(E e, const char **arr) {
		int ind = static_cast<int>(e);
		if (ind > -1)
			return arr[ind];
		return NULL;
	}
	
	static call_vector getCalls(const std::vector<Trace::sp_trace>& traces, bool setMod = false);
	
	virtual unsigned int length() const;
	virtual bool operator==(Trace *t) const;
	virtual void filterCall(const Call *c);
	virtual void display(std::ostream &os = std::cout) const;
	virtual std::string getParams() const = 0;
	virtual std::string getReadableParams() const = 0;
	
	double getEditDistance(const Call *c) const;
	
	std::string getLabel() const;
	ErrorType getError() const;
	bool addReturnCode(float code);
	std::string getReturn() const;
	bool compareReturn(const Call *c) const;
	void setReturn();
	bool hasReturn() const;
	
protected:

	virtual bool compare(const Call *c) const = 0;
	virtual void filter(const Call *c) = 0;
	virtual std::pair<int,int> distance(const Call *c) const = 0;
	
	std::string label;
	ErrorType error;
	int ind_ret;
	float ret[MAX_SIZE_PARAMS];
		
};

#endif