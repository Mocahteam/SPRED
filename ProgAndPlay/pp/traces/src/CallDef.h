#ifndef __CALL_DEF_H__
#define __CALL_DEF_H__

#include <stdarg.h>
#include <cmath>
#include <boost/lexical_cast.hpp>

#include "Call.h"

namespace CallMisc {

	enum Coalition {
		NONE = -1,
		MY_COALITION,
		ALLY_COALITION,
		ENEMY_COALITION
	};

	struct Unit {
		int id;
		int type;
		
		bool operator!=(const Unit& u) const {
			return id != u.id;
		}
	};

	struct Pos {
		float x;
		float y;
		
		bool operator!=(const Pos& p) const {
			return x != p.x || y != p.y;
		}
	};

}

class WrongCall : public Call {
	
public:
	
	WrongCall(std::string label, ErrorType err, int num_args, ...): Call(label,err) {
		va_list args;
		this->num_args = std::min(num_args, MAX_SIZE_PARAMS);
		va_start(args, num_args);
		for(int i = 0; i < num_args; i++)
            error_params[i] = va_arg(args, double);
		va_end(args);
	}

private:

	int num_args;
	float error_params[MAX_SIZE_PARAMS];

	virtual bool compare(Call *c) {
		WrongCall *cc = dynamic_cast<WrongCall*>(c);
		bool equal = num_args == cc->num_args;
		if (equal) {
			for (int i = 0; i < num_args; i++) {
				if (error_params[i] != cc->error_params[i])
					equal = false;
			}
		}
		if (!equal) {
			if (Call::paramsMap.contains("WrongCall","params"))
				return false;
			if (num_args > -1)
				num_args = -1;
			if (cc->num_args > -1)
				cc->num_args = -1;
		}
		return true;
	}

	virtual std::string getParams() const {
		if (num_args > -1) {
			std::string s = "";
			for (int i = 0; i < num_args; i++) {
				if (i > 0)
					s += " ";
				s += boost::lexical_cast<std::string>(error_params[i]);
			}
			return s;
		}
		return "?";
	}
	
};

class NoParamCall : public Call {
	
public:
		
	NoParamCall(std::string label): Call(label) {}
	
private:

	virtual bool compare(Call *c) {
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
	
	virtual bool compare(Call *c) {
		GetSpecialAreaPositionCall *cc = dynamic_cast<GetSpecialAreaPositionCall*>(c);
		if (specialAreaId != cc->specialAreaId) {
			if (Call::paramsMap.contains(label,"specialAreaId"))
				return false;
			if (specialAreaId != -1)
				specialAreaId = -1;
			if (cc->specialAreaId != -1)
				cc->specialAreaId = -1;
		}
		return true;
	}
	
	virtual std::string getParams() const {
		if (specialAreaId == -1)
			return "?";
		return boost::lexical_cast<std::string>(specialAreaId);
	}
	
};

class GetResourceCall : public Call {
	
public:

	GetResourceCall(int resourceId): Call("PP_GetResource"), resourceId(resourceId) {}
	
private:
	
	int resourceId;
	
	virtual bool compare(Call *c) {
		GetResourceCall *cc = dynamic_cast<GetResourceCall*>(c);
		if (resourceId != cc->resourceId) {
			if (Call::paramsMap.contains(label,"resourceId"))
				return false;
			if (resourceId > -1)
				resourceId = -1;
			if (cc->resourceId > -1)
				cc->resourceId = -1;
		}
		return true;
	}
	
	virtual std::string getParams() const {
		if (resourceId == -1)
			return "?";
		return boost::lexical_cast<std::string>(resourceId);
	}
	
};

class GetNumUnitsCall : public Call {

public:

	GetNumUnitsCall(CallMisc::Coalition coalition): Call("PP_GetNumUnits"), coalition(coalition) {}
	
private:

	CallMisc::Coalition coalition;
	
	virtual bool compare(Call *c) {
		GetNumUnitsCall *cc = dynamic_cast<GetNumUnitsCall*>(c);
		if (coalition != cc->coalition) {
			if (Call::paramsMap.contains(label,"coalition"))
				return false;
			if (coalition != CallMisc::NONE)
				coalition = CallMisc::NONE;
			if (cc->coalition != CallMisc::NONE)
				cc->coalition = CallMisc::NONE;
		}
		return true;
	}
	
	virtual std::string getParams() const {
		if (coalition == CallMisc::NONE)
			return "?";
		return boost::lexical_cast<std::string>(static_cast<int>(coalition));
	}

};

class GetUnitAtCall : public Call {
	
public:

	GetUnitAtCall(CallMisc::Coalition coalition, int index): Call("PP_GetUnitAt"), coalition(coalition), index(index) {}
	
private:

	CallMisc::Coalition coalition;
	int index;
	
	virtual bool compare(Call *c) {
		GetUnitAtCall *cc = dynamic_cast<GetUnitAtCall*>(c);
		if ((Call::paramsMap.contains(label,"coalition") && coalition != cc->coalition) || (Call::paramsMap.contains(label,"index") && index != cc->index))
			return false;
		if (!Call::paramsMap.contains(label,"coalition") && coalition != cc->coalition) {
			if (coalition != CallMisc::NONE)
				coalition = CallMisc::NONE;
			if (cc->coalition != CallMisc::NONE)
				cc->coalition = CallMisc::NONE;
		}
		if (!Call::paramsMap.contains(label,"index") && index != cc->index) {
			if (index != -1)
				index = -1;
			if (cc->index != -1)
				cc->index = -1;
		}
		return true;
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (coalition == CallMisc::NONE) ? "?" : boost::lexical_cast<std::string>(static_cast<int>(coalition));
		s += " ";
		s += (index == -1) ? "?" : boost::lexical_cast<std::string>(index);
		return s;
	}
	
};

class UnitCall : public Call {

public:

	UnitCall(std::string label, int unitId, int unitType): Call(label) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(Call *c) {
		UnitCall *cc = dynamic_cast<UnitCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type))
			return false;
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) {
			if (unit.id != -1)
				unit.id = -1;
			if (cc->unit.id != -1)
				cc->unit.id = -1;
		}
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) {
			if (unit.type != -1)
				unit.type = -1;
			if (cc->unit.type != -1)
				cc->unit.type = -1;
		}
		return true;
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (unit.id == -1) ? "?" : boost::lexical_cast<std::string>(unit.id);
		s += "_";
		s += (unit.type == -1) ? "?" : boost::lexical_cast<std::string>(unit.type);
		return s;		
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
	
	virtual bool compare(Call *c) {
		SetGroupCall *cc = dynamic_cast<SetGroupCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"groupId") && groupId != cc->groupId))
			return false;
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) {
			if (unit.id != -1)
				unit.id = -1;
			if (cc->unit.id != -1)
				cc->unit.id = -1;
		}
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) {
			if (unit.type != -1)
				unit.type = -1;
			if (cc->unit.type != -1)
				cc->unit.type = -1;
		}
		if (!Call::paramsMap.contains(label,"groupId") && groupId != cc->groupId) {
			if (groupId != -1)
				groupId = -1;
			if (cc->groupId != -1)
				cc->groupId = -1;
		}
		return true;
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (unit.id == -1) ? "?" : boost::lexical_cast<std::string>(unit.id);
		s += "_";
		s += (unit.type == -1) ? "?" : boost::lexical_cast<std::string>(unit.type);
		s += " ";
		s += (groupId == -1) ? "?" : boost::lexical_cast<std::string>(groupId);
		return s;
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
	
	virtual bool compare(Call *c) {
		ActionOnUnitCall *cc = dynamic_cast<ActionOnUnitCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"action") && action != cc->action) || (Call::paramsMap.contains(label,"targetId") && target.id != cc->target.id) || (Call::paramsMap.contains(label,"targetType") && target.type != cc->target.type))
			return false;
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) {
			if (unit.id != -1)
				unit.id = -1;
			if (cc->unit.id != -1)
				cc->unit.id = -1;
		}
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) {
			if (unit.type != -1)
				unit.type = -1;
			if (cc->unit.type != -1)
				cc->unit.type = -1;
		}
		if (!Call::paramsMap.contains(label,"action") && action != cc->action) {
			if (action != -1)
				action = -1;
			if (cc->action != -1)
				cc->action = -1;
		}
		if (!Call::paramsMap.contains(label,"targetId") && target.id != cc->target.id) {
			if (target.id != -1)
				target.id = -1;
			if (cc->target.id != -1)
				cc->target.id = -1;
		}
		if (!Call::paramsMap.contains(label,"targetType") && target.type != cc->target.type) {
			if (target.type != -1)
				target.type = -1;
			if (cc->target.type != -1)
				cc->target.type = -1;
		}
		return true;	
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (unit.id == -1) ? "?" : boost::lexical_cast<std::string>(unit.id);
		s += "_";
		s += (unit.type == -1) ? "?" : boost::lexical_cast<std::string>(unit.type);
		s += " ";
		s += (action == -1) ? "?" : boost::lexical_cast<std::string>(action);
		s += " ";
		s += (target.id == -1) ? "?" : boost::lexical_cast<std::string>(target.id);
		s += "_";
		s += (target.type == -1) ? "?" : boost::lexical_cast<std::string>(target.type);
		return s;
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
	
	virtual bool compare(Call *c) {
		ActionOnPositionCall *cc = dynamic_cast<ActionOnPositionCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"action") && action != cc->action) || (Call::paramsMap.contains(label,"position") && pos != cc->pos))
			return false;
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) {
			if (unit.id != -1)
				unit.id = -1;
			if (cc->unit.id != -1)
				cc->unit.id = -1;
		}
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) {
			if (unit.type != -1)
				unit.type = -1;
			if (cc->unit.type != -1)
				cc->unit.type = -1;
		}
		if (!Call::paramsMap.contains(label,"action") && action != cc->action) {
			if (action != -1)
				action = -1;
			if (cc->action != -1)
				cc->action = -1;
		}
		if (!Call::paramsMap.contains(label,"position") && pos != cc->pos) {
			if (pos.x != -1 || pos.y != -1) {
				pos.x = -1;
				pos.y = -1;
			}
			if (cc->pos.x != -1 || cc->pos.y != -1) {
				cc->pos.x = -1;
				cc->pos.y = -1;
			}
		}
		return true;
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (unit.id == -1) ? "?" : boost::lexical_cast<std::string>(unit.id);
		s += "_";
		s += (unit.type == -1) ? "?" : boost::lexical_cast<std::string>(unit.type);
		s += " ";
		s += (action == -1) ? "?" : boost::lexical_cast<std::string>(action);
		s += " ";
		s += (pos.x == -1 && pos.y == -1) ? "? ?" : boost::lexical_cast<std::string>(pos.x) + " " + boost::lexical_cast<std::string>(pos.y);
		return s;
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
	
	virtual bool compare(Call *c) {
		UntargetedActionCall *cc = dynamic_cast<UntargetedActionCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"action") && action != cc->action) || (Call::paramsMap.contains(label,"param") && param != cc->param))
			return false;
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) {
			if (unit.id != -1)
				unit.id = -1;
			if (cc->unit.id != -1)
				cc->unit.id = -1;
		}
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) {
			if (unit.type != -1)
				unit.type = -1;
			if (cc->unit.type != -1)
				cc->unit.type = -1;
		}
		if (!Call::paramsMap.contains(label,"action") && action != cc->action) {
			if (action != -1)
				action = -1;
			if (cc->action != -1)
				cc->action = -1;
		}
		if (!Call::paramsMap.contains(label,"param") && param != cc->param) {
			if (param != -1)
				param = -1;
			if (cc->param != -1)
				cc->param = -1;
		}
		return true;
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (unit.id == -1) ? "?" : boost::lexical_cast<std::string>(unit.id);
		s += "_";
		s += (unit.type == -1) ? "?" : boost::lexical_cast<std::string>(unit.type);
		s += " ";
		s += (action == -1) ? "?" : boost::lexical_cast<std::string>(action);
		s += " ";
		s += (param == -1) ? "?" : boost::lexical_cast<std::string>(param);
		return s;
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
	
	virtual bool compare(Call *c) {
		GetCodePdgCmdCall *cc = dynamic_cast<GetCodePdgCmdCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd))
			return false;
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) {
			if (unit.id != -1)
				unit.id = -1;
			if (cc->unit.id != -1)
				cc->unit.id = -1;
		}
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) {
			if (unit.type != -1)
				unit.type = -1;
			if (cc->unit.type != -1)
				cc->unit.type = -1;
		}
		if (!Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd) {
			if (idCmd != -1)
				idCmd = -1;
			if (cc->idCmd != -1)
				cc->idCmd = -1;
		}
		return true;
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (unit.id == -1) ? "?" : boost::lexical_cast<std::string>(unit.id);
		s += "_";
		s += (unit.type == -1) ? "?" : boost::lexical_cast<std::string>(unit.type);
		s += " ";
		s += (idCmd == -1) ? "?" : boost::lexical_cast<std::string>(idCmd);
		return s;
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
	
	virtual bool compare(Call *c) {
		GetNumParamsPdgCmdCall *cc = dynamic_cast<GetNumParamsPdgCmdCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd))
			return false;
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) {
			if (unit.id != -1)
				unit.id = -1;
			if (cc->unit.id != -1)
				cc->unit.id = -1;
		}
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) {
			if (unit.type != -1)
				unit.type = -1;
			if (cc->unit.type != -1)
				cc->unit.type = -1;
		}
		if (!Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd) {
			if (idCmd != -1)
				idCmd = -1;
			if (cc->idCmd != -1)
				cc->idCmd = -1;
		}
		return true;
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (unit.id == -1) ? "?" : boost::lexical_cast<std::string>(unit.id);
		s += "_";
		s += (unit.type == -1) ? "?" : boost::lexical_cast<std::string>(unit.type);
		s += " ";
		s += (idCmd == -1) ? "?" : boost::lexical_cast<std::string>(idCmd);
		return s;
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
	
	virtual bool compare(Call *c) {
		GetParamPdgCmdCall *cc = dynamic_cast<GetParamPdgCmdCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd) || (Call::paramsMap.contains(label,"idParam") && idParam != cc->idParam))
			return false;
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) {
			if (unit.id != -1)
				unit.id = -1;
			if (cc->unit.id != -1)
				cc->unit.id = -1;
		}
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) {
			if (unit.type != -1)
				unit.type = -1;
			if (cc->unit.type != -1)
				cc->unit.type = -1;
		}
		if (!Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd) {
			if (idCmd != -1)
				idCmd = -1;
			if (cc->idCmd != -1)
				cc->idCmd = -1;
		}
		if (!Call::paramsMap.contains(label,"idParam") && idParam != cc->idParam) {
			if (idParam != -1)
				idParam = -1;
			if (cc->idParam != -1)
				cc->idParam = -1;
		}
		return true;	
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (unit.id == -1) ? "?" : boost::lexical_cast<std::string>(unit.id);
		s += "_";
		s += (unit.type == -1) ? "?" : boost::lexical_cast<std::string>(unit.type);
		s += " ";
		s += (idCmd == -1) ? "?" : boost::lexical_cast<std::string>(idCmd);
		s += " ";
		s += (idParam == -1) ? "?" : boost::lexical_cast<std::string>(idParam);
		return s;
	}
	
};

#endif