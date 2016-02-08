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

#include "Shield.h"

#include "IncludesSources.h"

springai::Shield::Shield(AICallback* clb, int weaponDefId) {

	this->clb = clb;
	this->weaponDefId = weaponDefId;
}

int springai::Shield::GetWeaponDefId() {
	return weaponDefId;
}


springai::Shield* springai::Shield::GetInstance(AICallback* clb, int weaponDefId) {

	if (weaponDefId < 0) {
		return NULL;
	}

	Shield* _ret = NULL;
	_ret = new Shield(clb, weaponDefId);
	return _ret;
}

float springai::Shield::GetResourceUse(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_0REF1Resource2resourceId0getResourceUse(clb->GetTeamId(), weaponDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::Shield::GetRadius() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getRadius(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Shield::GetForce() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getForce(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Shield::GetMaxSpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getMaxSpeed(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Shield::GetPower() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getPower(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Shield::GetPowerRegen() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getPowerRegen(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Shield::GetPowerRegenResource(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_0REF1Resource2resourceId0getPowerRegenResource(clb->GetTeamId(), weaponDefId, c_resourceId.GetResourceId());
		return _ret;
	}
float springai::Shield::GetStartingPower() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getStartingPower(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
int springai::Shield::GetRechargeDelay() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getRechargeDelay(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
struct SAIFloat3 springai::Shield::GetGoodColor() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getGoodColor(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
struct SAIFloat3 springai::Shield::GetBadColor() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getBadColor(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
float springai::Shield::GetAlpha() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getAlpha(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
unsigned int springai::Shield::GetInterceptType() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_WeaponDef_Shield_getInterceptType(clb->GetTeamId(), weaponDefId);
		return _ret;
	}
