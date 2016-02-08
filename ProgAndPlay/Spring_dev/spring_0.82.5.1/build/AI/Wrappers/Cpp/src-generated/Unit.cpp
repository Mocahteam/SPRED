// WARNING: This file is machine generated,
// please do not edit directly!

/*
	Copyright (c) 2008 Robin Vobruba <hoijui.quaero@gmail.com>

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "Unit.h"

#include "IncludesSources.h"

springai::Unit::Unit(AICallback* clb, int unitId) {

	this->clb = clb;
	this->unitId = unitId;
}

int springai::Unit::GetUnitId() {
	return unitId;
}


springai::Unit* springai::Unit::GetInstance(AICallback* clb, int unitId) {

	if (unitId <= 0) {
		return NULL;
	}

	Unit* _ret = NULL;
	_ret = new Unit(clb, unitId);
	return _ret;
}

springai::UnitDef* springai::Unit::GetDef() {
		UnitDef* _ret;

		int innerRet = clb->GetInnerCallback()->Clb_Unit_0SINGLE1FETCH2UnitDef0getDef(clb->GetTeamId(), unitId);
		_ret = UnitDef::GetInstance(clb, innerRet);
		return _ret;
	}
int springai::Unit::GetTeam() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getTeam(clb->GetTeamId(), unitId);
		return _ret;
	}
int springai::Unit::GetAllyTeam() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getAllyTeam(clb->GetTeamId(), unitId);
		return _ret;
	}
int springai::Unit::GetLineage() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getLineage(clb->GetTeamId(), unitId);
		return _ret;
	}
int springai::Unit::GetAiHint() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getAiHint(clb->GetTeamId(), unitId);
		return _ret;
	}
int springai::Unit::GetStockpile() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getStockpile(clb->GetTeamId(), unitId);
		return _ret;
	}
int springai::Unit::GetStockpileQueued() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getStockpileQueued(clb->GetTeamId(), unitId);
		return _ret;
	}
float springai::Unit::GetCurrentFuel() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getCurrentFuel(clb->GetTeamId(), unitId);
		return _ret;
	}
float springai::Unit::GetMaxSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getMaxSpeed(clb->GetTeamId(), unitId);
		return _ret;
	}
float springai::Unit::GetMaxRange() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getMaxRange(clb->GetTeamId(), unitId);
		return _ret;
	}
float springai::Unit::GetMaxHealth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getMaxHealth(clb->GetTeamId(), unitId);
		return _ret;
	}
float springai::Unit::GetExperience() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getExperience(clb->GetTeamId(), unitId);
		return _ret;
	}
int springai::Unit::GetGroup() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getGroup(clb->GetTeamId(), unitId);
		return _ret;
	}
float springai::Unit::GetHealth() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getHealth(clb->GetTeamId(), unitId);
		return _ret;
	}
float springai::Unit::GetSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getSpeed(clb->GetTeamId(), unitId);
		return _ret;
	}
float springai::Unit::GetPower() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getPower(clb->GetTeamId(), unitId);
		return _ret;
	}
float springai::Unit::GetResourceUse(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_0REF1Resource2resourceId0getResourceUse(clb->GetTeamId(), unitId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::Unit::GetResourceMake(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_0REF1Resource2resourceId0getResourceMake(clb->GetTeamId(), unitId, c_resourceId.GetResourceId());
		return _ret;
	}
struct SAIFloat3 springai::Unit::GetPos() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getPos(clb->GetTeamId(), unitId);
		return _ret;
	}
struct SAIFloat3 springai::Unit::GetVel() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getVel(clb->GetTeamId(), unitId);
		return _ret;
	}
bool springai::Unit::IsActivated() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_isActivated(clb->GetTeamId(), unitId);
		return _ret;
	}
bool springai::Unit::IsBeingBuilt() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_isBeingBuilt(clb->GetTeamId(), unitId);
		return _ret;
	}
bool springai::Unit::IsCloaked() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_isCloaked(clb->GetTeamId(), unitId);
		return _ret;
	}
bool springai::Unit::IsParalyzed() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_isParalyzed(clb->GetTeamId(), unitId);
		return _ret;
	}
bool springai::Unit::IsNeutral() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_isNeutral(clb->GetTeamId(), unitId);
		return _ret;
	}
int springai::Unit::GetBuildingFacing() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getBuildingFacing(clb->GetTeamId(), unitId);
		return _ret;
	}
int springai::Unit::GetLastUserOrderFrame() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Unit_getLastUserOrderFrame(clb->GetTeamId(), unitId);
		return _ret;
	}
std::vector<springai::ModParam*> springai::Unit::GetModParams() {

		std::vector<ModParam*> _ret;
		int size = clb->GetInnerCallback()->Clb_Unit_0MULTI1SIZE0ModParam(clb->GetTeamId(), unitId);
		std::vector<ModParam*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(ModParam::GetInstance(clb, unitId, i));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::CurrentCommand*> springai::Unit::GetCurrentCommands() {

		std::vector<CurrentCommand*> _ret;
		int size = clb->GetInnerCallback()->Clb_Unit_0MULTI1SIZE1Command0CurrentCommand(clb->GetTeamId(), unitId);
		std::vector<CurrentCommand*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(CurrentCommand::GetInstance(clb, unitId, i));
		}
		_ret = arrList;
		return _ret;
	}
springai::SupportedCommand* springai::Unit::GetSupportedCommand() {

		SupportedCommand* _ret;
		_ret = ClbUnitSupportedCommandImpl::GetInstance(clb, unitId);
		return _ret;
	}
