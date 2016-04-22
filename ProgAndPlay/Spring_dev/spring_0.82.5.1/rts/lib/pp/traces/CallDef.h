#ifndef __CALL_DEF_H__
#define __CALL_DEF_H__

#include <stdarg.h>
#include <cmath>
#include <boost/lexical_cast.hpp>

namespace CallMisc {

	enum Coalition {
		MY_COALITION,
		ALLY_COALITION,
		ENEMY_COALITION
	};

	struct Unit {
		int id;
		int type;
		
		bool operator==(const Unit& u) const {
			return id == u.id;
		}
	};

	struct Pos {
		float x;
		float y;
		
		bool operator==(const Pos& p) const {
			return x == p.x && y == p.y;
		}
	};

}

class WrongCall : public Call {
	
public:
	
	WrongCall(std::string label, ErrorType err, int num_args, ...): Call(label,err) {
		va_list args;
		num_args = std::min(num_args, MAX_SIZE_PARAMS);
		va_start(args, num_args);
		for(int i = 0; i < num_args; i++)
            error_params[i] = va_arg(args, double);
		num_args_ = num_args;
		va_end(args);
	}

private:

	unsigned int num_args_;
	float error_params[MAX_SIZE_PARAMS];

	virtual bool compare(Call *c) const {
		return true;
	}

	virtual std::string getParams() const {
		std::string s = "";
		for (unsigned int i = 0; i < num_args_; i++) {
			s += boost::lexical_cast<std::string>(error_params[i]);
			if (i < num_args_-1)
				s += " ";
		}
		return s;
	}
	
};

class NoParamCall : public Call {
	
public:
		
	NoParamCall(std::string label): Call(label) {}
	
private:

	virtual bool compare(Call *c) const {
		return true;
	}
	
	virtual std::string getParams() const {
		return "";
	}
	
};

class GetSpecialAreaPositionCall : public Call {

public:

	GetSpecialAreaPositionCall(int specialAreaId): Call("PP_GetSpecialAreaPosition"), specialAreaId(specialAreaId) {}
	
private:
	
	int specialAreaId;
	
	virtual bool compare(Call *c) const {
		GetSpecialAreaPositionCall *cc = dynamic_cast<GetSpecialAreaPositionCall*>(c);
		return specialAreaId == cc->specialAreaId;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(specialAreaId);
	}
	
};

class GetResourceCall : public Call {
	
public:

	GetResourceCall(int resourceId): Call("PP_GetResource"), resourceId(resourceId) {}
	
private:
	
	int resourceId;
	
	virtual bool compare(Call *c) const {
		GetResourceCall *cc = dynamic_cast<GetResourceCall*>(c);
		return resourceId == cc->resourceId;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(resourceId);
	}
	
};

class GetNumUnitsCall : public Call {

public:

	GetNumUnitsCall(CallMisc::Coalition coalition): Call("PP_GetNumUnits"), coalition(coalition) {}
	
private:

	CallMisc::Coalition coalition;
	
	virtual bool compare(Call *c) const {
		GetNumUnitsCall *cc = dynamic_cast<GetNumUnitsCall*>(c);
		return coalition == cc->coalition; 
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(static_cast<int>(coalition));
	}

};

class GetUnitAtCall : public Call {
	
public:

	GetUnitAtCall(CallMisc::Coalition coalition, int index): Call("PP_GetUnitAt"), coalition(coalition), index(index) {}
	
private:

	CallMisc::Coalition coalition;
	int index;
	
	virtual bool compare(Call *c) const {
		GetUnitAtCall *cc = dynamic_cast<GetUnitAtCall*>(c);
		return coalition == cc->coalition;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(static_cast<int>(coalition)) + " " + boost::lexical_cast<std::string>(index);
	}
	
};

class GetCoalitionCall : public Call {

public:

	GetCoalitionCall(int unitId, int unitType): Call("PP_Unit_GetCoalition") {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(Call *c) const {
		GetCoalitionCall *cc = dynamic_cast<GetCoalitionCall*>(c);
		return unit == cc->unit;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type);
	}

};

class GetTypeCall : public Call {

public:

	GetTypeCall(int unitId, int unitType): Call("PP_Unit_GetType") {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(Call *c) const {
		//GetTypeCall *cc = dynamic_cast<GetTypeCall*>(c);
		//return unit == cc->unit;
		return true;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type);
	}

};

class GetPositionCall : public Call {

public:

	GetPositionCall(int unitId, int unitType): Call("PP_Unit_GetPosition") {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(Call *c) const {
		GetPositionCall *cc = dynamic_cast<GetPositionCall*>(c);
		return unit == cc->unit;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type);
	}

};

class GetHealthCall : public Call {

public:

	GetHealthCall(int unitId, int unitType): Call("PP_Unit_GetHealth") {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(Call *c) const {
		//GetHealthCall *cc = dynamic_cast<GetHealthCall*>(c);
		//return unit == cc->unit;
		return true;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type);
	}

};

class GetMaxHealthCall : public Call {

public:

	GetMaxHealthCall(int unitId, int unitType): Call("PP_Unit_GetMaxHealth") {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(Call *c) const {
		//GetMaxHealthCall *cc = dynamic_cast<GetMaxHealthCall*>(c);
		//return unit == cc->unit;
		return true;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type);
	}

};

class GetPendingCommandsCall : public Call {

public:

	GetPendingCommandsCall(int unitId, int unitType): Call("PP_Unit_GetPendingCommands") {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(Call *c) const {
		//GetPendingCommandsCall *cc = dynamic_cast<GetPendingCommandsCall*>(c);
		return true;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type);
	}

};

class GetGroupCall : public Call {

public:

	GetGroupCall(int unitId, int unitType): Call("PP_Unit_GetGroup") {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(Call *c) const {
		GetGroupCall *cc = dynamic_cast<GetGroupCall*>(c);
		return unit == cc->unit;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type);
	}

};

class SetGroupCall : public Call {

public:

	SetGroupCall(int unitId, int unitType, int groupId): Call("PP_Unit_SetGroup"), groupId(groupId) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	int groupId;
	
	virtual bool compare(Call *c) const {
		SetGroupCall *cc = dynamic_cast<SetGroupCall*>(c);
		return unit == cc->unit && groupId == cc->groupId;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type) + " " + boost::lexical_cast<std::string>(groupId);
	}
	
};

class ActionOnUnitCall : public Call {
	
public:
		
	ActionOnUnitCall(int unitId, int unitType, int action, int targetId, int targetType): Call("PP_Unit_ActionOnUnit"), action(action) {
		unit.id = unitId;
		unit.type = unitType;
		target.id = targetId;
		target.type = targetType;
	}
	
private:
		
	CallMisc::Unit unit;
	int action;
	CallMisc::Unit target;
	
	virtual bool compare(Call *c) const {
		ActionOnUnitCall *cc = dynamic_cast<ActionOnUnitCall*>(c);
		return action == cc->action;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type) + " " + boost::lexical_cast<std::string>(action) + " " + boost::lexical_cast<std::string>(target.id) + "_" + boost::lexical_cast<std::string>(target.type);
	}

};

class ActionOnPositionCall : public Call {

public:
		
	ActionOnPositionCall(int unitId, int unitType, int action, float x, float y): Call("PP_Unit_ActionOnPosition"), action(action) {
		unit.id = unitId;
		unit.type = unitType;
		pos.x = x;
		pos.y = y;
	}
	
private:
		
	CallMisc::Unit unit;
	int action;
	CallMisc::Pos pos;
	
	virtual bool compare(Call *c) const {
		ActionOnPositionCall *cc = dynamic_cast<ActionOnPositionCall*>(c);
		return action == cc->action;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type) + " " + boost::lexical_cast<std::string>(action) + " " + boost::lexical_cast<std::string>(pos.x) + " " + boost::lexical_cast<std::string>(pos.y);
	}

};

class UntargetedActionCall : public Call {

public:
		
	UntargetedActionCall(int unitId, int unitType, int action, float param): Call("PP_Unit_UntargetedAction"), action(action), param(param) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:
		
	CallMisc::Unit unit;
	int action;
	float param;
	
	virtual bool compare(Call *c) const {
		UntargetedActionCall *cc = dynamic_cast<UntargetedActionCall*>(c);
		return action == cc->action;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type) + " " + boost::lexical_cast<std::string>(action) + " " + boost::lexical_cast<std::string>(param);
	}

};

class GetNumPdgCmdsCall : public Call {

public:

	GetNumPdgCmdsCall(int unitId, int unitType): Call("PP_Unit_GetNumPdgCmds") {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(Call *c) const {
		GetNumPdgCmdsCall *cc = dynamic_cast<GetNumPdgCmdsCall*>(c);
		return unit == cc->unit;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type);
	}

};

class GetCodePdgCmdCall : public Call {

public:
		
	GetCodePdgCmdCall(int unitId, int unitType, int idCmd): Call("PP_Unit_PdgCmd_GetCode"), idCmd(idCmd) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:
		
	CallMisc::Unit unit;
	int idCmd;
	
	virtual bool compare(Call *c) const {
		GetCodePdgCmdCall *cc = dynamic_cast<GetCodePdgCmdCall*>(c);
		return unit == cc->unit && idCmd == cc->idCmd;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type) + " " + boost::lexical_cast<std::string>(idCmd);
	}
	
};

class GetNumParamsPdgCmdCall : public Call {

public:
		
	GetNumParamsPdgCmdCall(int unitId, int unitType, int idCmd): Call("PP_Unit_PdgCmd_GetNumParams"), idCmd(idCmd) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:
		
	CallMisc::Unit unit;
	int idCmd;
	
	virtual bool compare(Call *c) const {
		GetNumParamsPdgCmdCall *cc = dynamic_cast<GetNumParamsPdgCmdCall*>(c);
		return unit == cc->unit && idCmd == cc->idCmd;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type) + " " + boost::lexical_cast<std::string>(idCmd);
	}

};

class GetParamPdgCmdCall : public Call {

public:
		
	GetParamPdgCmdCall(int unitId, int unitType, int idCmd, int idParam): Call("PP_Unit_PdgCmd_GetParam"), idCmd(idCmd), idParam(idParam) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:
		
	CallMisc::Unit unit;
	int idCmd;
	int idParam;
	
	virtual bool compare(Call *c) const {
		GetParamPdgCmdCall *cc = dynamic_cast<GetParamPdgCmdCall*>(c);
		return unit == cc->unit && idCmd == cc->idCmd && idParam == cc->idParam;
	}
	
	virtual std::string getParams() const {
		return boost::lexical_cast<std::string>(unit.id) + "_" + boost::lexical_cast<std::string>(unit.type) + " " + boost::lexical_cast<std::string>(idCmd) + " " + boost::lexical_cast<std::string>(idParam);
	}
	
};

#endif