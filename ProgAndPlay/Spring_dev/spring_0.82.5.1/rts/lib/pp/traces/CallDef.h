#ifndef __CALL_DEF_H__
#define __CALL_DEF_H__

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

class NoParamCall : public Call {
	
public:
		
	NoParamCall(std::string label): Call(label,Call::NONE) {}
	
private:

	virtual bool compare(const Call *c) const {
		return true;
	}
	
	virtual void filter(const Call *c) {}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		return std::make_pair<int,int>(0,0);
	}
	
	virtual std::string getParams() const {
		return "";
	}
	
};

class GetSpecialAreaPositionCall : public Call {

public:

	GetSpecialAreaPositionCall(ErrorType err, int specialAreaId): Call("PP_GetSpecialAreaPosition",err), specialAreaId(specialAreaId) {}
	
private:
	
	int specialAreaId;
	
	virtual bool compare(const Call *c) const {
		const GetSpecialAreaPositionCall *cc = dynamic_cast<const GetSpecialAreaPositionCall*>(c);
		if (Call::paramsMap.contains(label,"specialAreaId") && specialAreaId != cc->specialAreaId)
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const GetSpecialAreaPositionCall *cc = dynamic_cast<const GetSpecialAreaPositionCall*>(c);
		if (!Call::paramsMap.contains(label,"specialAreaId") && specialAreaId != cc->specialAreaId && specialAreaId != -1)
			specialAreaId = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const GetSpecialAreaPositionCall *cc = dynamic_cast<const GetSpecialAreaPositionCall*>(c);
		if (specialAreaId == cc->specialAreaId)
			return std::make_pair<int,int>(0,1);
		return std::make_pair<int,int>(1,1);
	}
	
	virtual std::string getParams() const {
		if (specialAreaId == -1)
			return "?";
		return boost::lexical_cast<std::string>(specialAreaId);
	}
	
};

class GetResourceCall : public Call {
	
public:

	GetResourceCall(ErrorType err, int resourceId): Call("PP_GetResource",err), resourceId(resourceId) {}
	
private:
	
	int resourceId;
	
	virtual bool compare(const Call *c) const {
		const GetResourceCall *cc = dynamic_cast<const GetResourceCall*>(c);
		if (Call::paramsMap.contains(label,"resourceId") && resourceId != cc->resourceId)
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const GetResourceCall *cc = dynamic_cast<const GetResourceCall*>(c);
		if (!Call::paramsMap.contains(label,"resourceId") && resourceId != cc->resourceId && resourceId != -1)
			resourceId = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const GetResourceCall *cc = dynamic_cast<const GetResourceCall*>(c);
		if (resourceId == cc->resourceId)
			return std::make_pair<int,int>(0,1);
		return std::make_pair<int,int>(1,1);
	}
	
	virtual std::string getParams() const {
		if (resourceId == -1)
			return "?";
		return boost::lexical_cast<std::string>(resourceId);
	}
	
};

class GetNumUnitsCall : public Call {

public:

	GetNumUnitsCall(ErrorType err, CallMisc::Coalition coalition): Call("PP_GetNumUnits",err), coalition(coalition) {}
	
private:

	CallMisc::Coalition coalition;
	
	virtual bool compare(const Call *c) const {
		const GetNumUnitsCall *cc = dynamic_cast<const GetNumUnitsCall*>(c);
		if (Call::paramsMap.contains(label,"coalition") && coalition != cc->coalition)
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const GetNumUnitsCall *cc = dynamic_cast<const GetNumUnitsCall*>(c);
		if (!Call::paramsMap.contains(label,"coalition") && coalition != cc->coalition && coalition != CallMisc::NONE)
			coalition = CallMisc::NONE;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const GetNumUnitsCall *cc = dynamic_cast<const GetNumUnitsCall*>(c);
		if (coalition == cc->coalition)
			return std::make_pair<int,int>(0,1);
		return std::make_pair<int,int>(1,1);
	}
	
	virtual std::string getParams() const {
		if (coalition == CallMisc::NONE)
			return "?";
		return boost::lexical_cast<std::string>(static_cast<int>(coalition));
	}

};

class GetUnitAtCall : public Call {
	
public:

	GetUnitAtCall(ErrorType err, CallMisc::Coalition coalition, int index): Call("PP_GetUnitAt",err), coalition(coalition), index(index) {}
	
private:

	CallMisc::Coalition coalition;
	int index;
	
	virtual bool compare(const Call *c) const {
		const GetUnitAtCall *cc = dynamic_cast<const GetUnitAtCall*>(c);
		if ((Call::paramsMap.contains(label,"coalition") && coalition != cc->coalition) || (Call::paramsMap.contains(label,"index") && index != cc->index))
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const GetUnitAtCall *cc = dynamic_cast<const GetUnitAtCall*>(c);
		if (!Call::paramsMap.contains(label,"coalition") && coalition != cc->coalition && coalition != CallMisc::NONE)
			coalition = CallMisc::NONE;
		if (!Call::paramsMap.contains(label,"index") && index != cc->index && index != -1)
			index = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const GetUnitAtCall *cc = dynamic_cast<const GetUnitAtCall*>(c);
		int sc = 0;
		if (coalition != cc->coalition)
			sc++;
		if (index != cc->index)
			sc++;
		return std::make_pair<int,int>(sc,2);
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

	UnitCall(ErrorType err, std::string label, int unitId, int unitType): Call(label,err) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	
	virtual bool compare(const Call *c) const {
		const UnitCall *cc = dynamic_cast<const UnitCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type))
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const UnitCall *cc = dynamic_cast<const UnitCall*>(c);
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id && unit.id != -1)
			unit.id = -1;
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type && unit.type != -1)
			unit.type = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const UnitCall *cc = dynamic_cast<const UnitCall*>(c);
		if (unit.type == cc->unit.type)
			return std::make_pair<int,int>(0,1);
		return std::make_pair<int,int>(1,1);
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

	SetGroupCall(ErrorType err, int unitId, int unitType, int groupId): Call("PP_Unit_SetGroup",err), groupId(groupId) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:

	CallMisc::Unit unit;
	int groupId;
	
	virtual bool compare(const Call *c) const {
		const SetGroupCall *cc = dynamic_cast<const SetGroupCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"groupId") && groupId != cc->groupId))
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const SetGroupCall *cc = dynamic_cast<const SetGroupCall*>(c);
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id && unit.id != -1)
			unit.id = -1;
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type && unit.type != -1)
			unit.type = -1;
		if (!Call::paramsMap.contains(label,"groupId") && groupId != cc->groupId && groupId != -1)
			groupId = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const SetGroupCall *cc = dynamic_cast<const SetGroupCall*>(c);
		int sc = 0;
		if (unit.type != cc->unit.type)
			sc++;
		if (groupId != cc->groupId)
			sc++;
		return std::make_pair<int,int>(sc,2);
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
		
	ActionOnUnitCall(ErrorType err, int unitId, int unitType, int action, int targetId, int targetType): Call("PP_Unit_ActionOnUnit",err), action(action) {
		unit.id = unitId;
		unit.type = unitType;
		target.id = targetId;
		target.type = targetType;
	}
	
private:
		
	CallMisc::Unit unit;
	int action;
	CallMisc::Unit target;
	
	virtual bool compare(const Call *c) const {
		const ActionOnUnitCall *cc = dynamic_cast<const ActionOnUnitCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"action") && action != cc->action) || (Call::paramsMap.contains(label,"targetId") && target.id != cc->target.id) || (Call::paramsMap.contains(label,"targetType") && target.type != cc->target.type))
			return false;
		return true;	
	}
	
	virtual void filter(const Call *c) {
		const ActionOnUnitCall *cc = dynamic_cast<const ActionOnUnitCall*>(c);
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id && unit.id != -1)
			unit.id = -1;
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type && unit.type != -1)
			unit.type = -1;
		if (!Call::paramsMap.contains(label,"action") && action != cc->action && action != -1)
			action = -1;
		if (!Call::paramsMap.contains(label,"targetId") && target.id != cc->target.id && target.id != -1)
			target.id = -1;
		if (!Call::paramsMap.contains(label,"targetType") && target.type != cc->target.type && target.type != -1)
			target.type = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const ActionOnUnitCall *cc = dynamic_cast<const ActionOnUnitCall*>(c);
		int sc = 0;
		if (unit.type != cc->unit.type)
			sc++;
		if (action != cc->action)
			sc++;
		if (target.type != cc->target.type)
			sc++;
		return std::make_pair<int,int>(sc,3);
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
		
	ActionOnPositionCall(ErrorType err, int unitId, int unitType, int action, float x, float y): Call("PP_Unit_ActionOnPosition",err), action(action) {
		unit.id = unitId;
		unit.type = unitType;
		pos.x = x;
		pos.y = y;
	}
	
private:
		
	CallMisc::Unit unit;
	int action;
	CallMisc::Pos pos;
	
	virtual bool compare(const Call *c) const {
		const ActionOnPositionCall *cc = dynamic_cast<const ActionOnPositionCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"action") && action != cc->action) || (Call::paramsMap.contains(label,"position") && pos != cc->pos))
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const ActionOnPositionCall *cc = dynamic_cast<const ActionOnPositionCall*>(c);
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id && unit.id != -1)
			unit.id = -1;
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type && unit.type != -1)
			unit.type = -1;
		if (!Call::paramsMap.contains(label,"action") && action != cc->action && action != -1)
			action = -1;
		if (!Call::paramsMap.contains(label,"position") && pos.x != cc->pos.x && pos.x != -1)
			pos.x = -1;
		if (!Call::paramsMap.contains(label,"position") && pos.y != cc->pos.y && pos.y != -1)
			pos.y = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const ActionOnPositionCall *cc = dynamic_cast<const ActionOnPositionCall*>(c);
		int sc = 0;
		if (unit.type != cc->unit.type)
			sc++;
		if (action != cc->action)
			sc++;
		if (pos != cc->pos)
			sc++;
		return std::make_pair<int,int>(sc,3);
	}
	
	virtual std::string getParams() const {
		std::string s = "";
		s += (unit.id == -1) ? "?" : boost::lexical_cast<std::string>(unit.id);
		s += "_";
		s += (unit.type == -1) ? "?" : boost::lexical_cast<std::string>(unit.type);
		s += " ";
		s += (action == -1) ? "?" : boost::lexical_cast<std::string>(action);
		s += " ";
		s += (pos.x == -1) ? "?" : boost::lexical_cast<std::string>(pos.x);
		s += " ";
		s += (pos.y == -1) ? "?" : boost::lexical_cast<std::string>(pos.y);
		return s;
	}

};

class UntargetedActionCall : public Call {

public:
		
	UntargetedActionCall(ErrorType err, int unitId, int unitType, int action, float param): Call("PP_Unit_UntargetedAction",err), action(action), param(param) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:
		
	CallMisc::Unit unit;
	int action;
	float param;
	
	virtual bool compare(const Call *c) const {
		const UntargetedActionCall *cc = dynamic_cast<const UntargetedActionCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"action") && action != cc->action) || (Call::paramsMap.contains(label,"param") && param != cc->param))
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const UntargetedActionCall *cc = dynamic_cast<const UntargetedActionCall*>(c);
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id && unit.id != -1)
			unit.id = -1;
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type && unit.type != -1)
			unit.type = -1;
		if (!Call::paramsMap.contains(label,"action") && action != cc->action && action != -1)
			action = -1;
		if (!Call::paramsMap.contains(label,"param") && param != cc->param && param != -1)
			param = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const UntargetedActionCall *cc = dynamic_cast<const UntargetedActionCall*>(c);
		int sc = 0;
		if (unit.type != cc->unit.type)
			sc++;
		if (action != cc->action)
			sc++;
		if (param != cc->param)
			sc++;
		return std::make_pair<int,int>(sc,3);
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
		
	GetCodePdgCmdCall(ErrorType err, int unitId, int unitType, int idCmd): Call("PP_Unit_PdgCmd_GetCode",err), idCmd(idCmd) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:
		
	CallMisc::Unit unit;
	int idCmd;
	
	virtual bool compare(const Call *c) const {
		const GetCodePdgCmdCall *cc = dynamic_cast<const GetCodePdgCmdCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd))
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const GetCodePdgCmdCall *cc = dynamic_cast<const GetCodePdgCmdCall*>(c);
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id && unit.id != -1)
			unit.id = -1;
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type && unit.type != -1)
			unit.type = -1;
		if (!Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd && idCmd != -1)
			idCmd = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const GetCodePdgCmdCall *cc = dynamic_cast<const GetCodePdgCmdCall*>(c);
		int sc = 0;
		if (unit.type != cc->unit.type)
			sc++;
		if (idCmd != cc->idCmd)
			sc++;
		return std::make_pair<int,int>(sc,2);
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
		
	GetNumParamsPdgCmdCall(ErrorType err, int unitId, int unitType, int idCmd): Call("PP_Unit_PdgCmd_GetNumParams",err), idCmd(idCmd) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:
		
	CallMisc::Unit unit;
	int idCmd;
	
	virtual bool compare(const Call *c) const {
		const GetNumParamsPdgCmdCall *cc = dynamic_cast<const GetNumParamsPdgCmdCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd))
			return false;
		return true;
	}
	
	virtual void filter(const Call *c) {
		const GetNumParamsPdgCmdCall *cc = dynamic_cast<const GetNumParamsPdgCmdCall*>(c);
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id && unit.id != -1)
			unit.id = -1;
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type && unit.type != -1)
			unit.type = -1;
		if (!Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd && idCmd != -1)
			idCmd = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const GetNumParamsPdgCmdCall *cc = dynamic_cast<const GetNumParamsPdgCmdCall*>(c);
		int sc = 0;
		if (unit.type != cc->unit.type)
			sc++;
		if (idCmd != cc->idCmd)
			sc++;
		return std::make_pair<int,int>(sc,2);
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
		
	GetParamPdgCmdCall(ErrorType err, int unitId, int unitType, int idCmd, int idParam): Call("PP_Unit_PdgCmd_GetParam",err), idCmd(idCmd), idParam(idParam) {
		unit.id = unitId;
		unit.type = unitType;
	}
	
private:
		
	CallMisc::Unit unit;
	int idCmd;
	int idParam;
	
	virtual bool compare(const Call *c) const {
		const GetParamPdgCmdCall *cc = dynamic_cast<const GetParamPdgCmdCall*>(c);
		if ((Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id) || (Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type) || (Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd) || (Call::paramsMap.contains(label,"idParam") && idParam != cc->idParam))
			return false;
		return true;	
	}
	
	virtual void filter(const Call *c) {
		const GetParamPdgCmdCall *cc = dynamic_cast<const GetParamPdgCmdCall*>(c);
		if (!Call::paramsMap.contains(label,"unitId") && unit.id != cc->unit.id && unit.id != -1)
			unit.id = -1;
		if (!Call::paramsMap.contains(label,"unitType") && unit.type != cc->unit.type && unit.type != -1)
			unit.type = -1;
		if (!Call::paramsMap.contains(label,"idCmd") && idCmd != cc->idCmd && idCmd != -1)
			idCmd = -1;
		if (!Call::paramsMap.contains(label,"idParam") && idParam != cc->idParam && idParam != -1)
			idParam = -1;
	}
	
	virtual std::pair<int,int> distance(const Call *c) const {
		const GetParamPdgCmdCall *cc = dynamic_cast<const GetParamPdgCmdCall*>(c);
		int sc = 0;
		if (unit.type != cc->unit.type)
			sc++;
		if (idCmd != cc->idCmd)
			sc++;
		if (idParam != cc->idParam)
			sc++;
		return std::make_pair<int,int>(sc,3);
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