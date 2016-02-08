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

#include "WeaponMount.h"

#include "IncludesSources.h"

springai::WeaponMount::WeaponMount(AICallback* clb, int unitDefId, int weaponMountId) {

	this->clb = clb;
	this->unitDefId = unitDefId;
	this->weaponMountId = weaponMountId;
}

int springai::WeaponMount::GetUnitDefId() {
	return unitDefId;
}

int springai::WeaponMount::GetWeaponMountId() {
	return weaponMountId;
}


springai::WeaponMount* springai::WeaponMount::GetInstance(AICallback* clb, int unitDefId, int weaponMountId) {

	if (weaponMountId < 0) {
		return NULL;
	}

	WeaponMount* _ret = NULL;
	_ret = new WeaponMount(clb, unitDefId, weaponMountId);
	return _ret;
}

const char* springai::WeaponMount::GetName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_WeaponMount_getName(clb->GetTeamId(), unitDefId, weaponMountId);
		return _ret;
	}
springai::WeaponDef* springai::WeaponMount::GetWeaponDef() {
		WeaponDef* _ret;

		int innerRet = clb->GetInnerCallback()->Clb_UnitDef_WeaponMount_0SINGLE1FETCH2WeaponDef0getWeaponDef(clb->GetTeamId(), unitDefId, weaponMountId);
		_ret = WeaponDef::GetInstance(clb, innerRet);
		return _ret;
	}
int springai::WeaponMount::GetSlavedTo() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_WeaponMount_getSlavedTo(clb->GetTeamId(), unitDefId, weaponMountId);
		return _ret;
	}
struct SAIFloat3 springai::WeaponMount::GetMainDir() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_WeaponMount_getMainDir(clb->GetTeamId(), unitDefId, weaponMountId);
		return _ret;
	}
float springai::WeaponMount::GetMaxAngleDif() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_WeaponMount_getMaxAngleDif(clb->GetTeamId(), unitDefId, weaponMountId);
		return _ret;
	}
float springai::WeaponMount::GetFuelUsage() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_WeaponMount_getFuelUsage(clb->GetTeamId(), unitDefId, weaponMountId);
		return _ret;
	}
unsigned int springai::WeaponMount::GetBadTargetCategory() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_WeaponMount_getBadTargetCategory(clb->GetTeamId(), unitDefId, weaponMountId);
		return _ret;
	}
unsigned int springai::WeaponMount::GetOnlyTargetCategory() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_UnitDef_WeaponMount_getOnlyTargetCategory(clb->GetTeamId(), unitDefId, weaponMountId);
		return _ret;
	}
