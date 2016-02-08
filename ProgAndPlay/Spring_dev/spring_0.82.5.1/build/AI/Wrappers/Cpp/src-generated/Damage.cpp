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

#include "Damage.h"

#include "IncludesSources.h"

springai::Damage::Damage(AICallback* clb, int weaponDefId) {

	this->clb = clb;
	this->weaponDefId = weaponDefId;
}

int springai::Damage::GetWeaponDefId() {
	return weaponDefId;
}


springai::Damage* springai::Damage::GetInstance(AICallback* clb, int weaponDefId) {

	if (weaponDefId < 0) {
		return NULL;
	}

	Damage* _ret = NULL;
	_ret = new Damage(clb, weaponDefId);
	return _ret;
}

int springai::Damage::GetParalyzeDamageTime() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Damage_getParalyzeDamageTime(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Damage::GetImpulseFactor() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Damage_getImpulseFactor(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Damage::GetImpulseBoost() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Damage_getImpulseBoost(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Damage::GetCraterMult() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Damage_getCraterMult(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Damage::GetCraterBoost() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Damage_getCraterBoost(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
std::vector<float> springai::Damage::GetTypes() {
		std::vector<float> _ret;

		int size = clb->GetInnerCallback()->Clb_WeaponDef_Damage_0ARRAY1SIZE0getTypes(clb->GetTeamId(), weaponDefId);
		float* tmpArr = new float[size];
		clb->GetInnerCallback()->Clb_WeaponDef_Damage_0ARRAY1VALS0getTypes(clb->GetTeamId(), weaponDefId, tmpArr, size);
		std::vector<float> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
