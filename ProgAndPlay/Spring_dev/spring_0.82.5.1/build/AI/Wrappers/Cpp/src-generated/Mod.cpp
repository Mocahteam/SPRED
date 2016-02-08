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

#include "Mod.h"

#include "IncludesSources.h"

springai::Mod::Mod(AICallback* clb) {

	this->clb = clb;
}


springai::Mod* springai::Mod::GetInstance(AICallback* clb) {

	Mod* _ret = NULL;
	_ret = new Mod(clb);
	return _ret;
}

const char* springai::Mod::GetFileName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getFileName(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetHash() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getHash(clb->GetTeamId());
		return _ret;
	}
const char* springai::Mod::GetHumanName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getHumanName(clb->GetTeamId());
		return _ret;
	}
const char* springai::Mod::GetShortName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getShortName(clb->GetTeamId());
		return _ret;
	}
const char* springai::Mod::GetVersion() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getVersion(clb->GetTeamId());
		return _ret;
	}
const char* springai::Mod::GetMutator() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getMutator(clb->GetTeamId());
		return _ret;
	}
const char* springai::Mod::GetDescription() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getDescription(clb->GetTeamId());
		return _ret;
	}
bool springai::Mod::GetAllowTeamColors() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getAllowTeamColors(clb->GetTeamId());
		return _ret;
	}
bool springai::Mod::GetConstructionDecay() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getConstructionDecay(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetConstructionDecayTime() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getConstructionDecayTime(clb->GetTeamId());
		return _ret;
	}
float springai::Mod::GetConstructionDecaySpeed() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getConstructionDecaySpeed(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetMultiReclaim() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getMultiReclaim(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetReclaimMethod() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getReclaimMethod(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetReclaimUnitMethod() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getReclaimUnitMethod(clb->GetTeamId());
		return _ret;
	}
float springai::Mod::GetReclaimUnitEnergyCostFactor() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getReclaimUnitEnergyCostFactor(clb->GetTeamId());
		return _ret;
	}
float springai::Mod::GetReclaimUnitEfficiency() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getReclaimUnitEfficiency(clb->GetTeamId());
		return _ret;
	}
float springai::Mod::GetReclaimFeatureEnergyCostFactor() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getReclaimFeatureEnergyCostFactor(clb->GetTeamId());
		return _ret;
	}
bool springai::Mod::GetReclaimAllowEnemies() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getReclaimAllowEnemies(clb->GetTeamId());
		return _ret;
	}
bool springai::Mod::GetReclaimAllowAllies() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getReclaimAllowAllies(clb->GetTeamId());
		return _ret;
	}
float springai::Mod::GetRepairEnergyCostFactor() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getRepairEnergyCostFactor(clb->GetTeamId());
		return _ret;
	}
float springai::Mod::GetResurrectEnergyCostFactor() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getResurrectEnergyCostFactor(clb->GetTeamId());
		return _ret;
	}
float springai::Mod::GetCaptureEnergyCostFactor() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getCaptureEnergyCostFactor(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetTransportGround() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getTransportGround(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetTransportHover() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getTransportHover(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetTransportShip() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getTransportShip(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetTransportAir() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getTransportAir(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetFireAtKilled() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getFireAtKilled(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetFireAtCrashing() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getFireAtCrashing(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetFlankingBonusModeDefault() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getFlankingBonusModeDefault(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetLosMipLevel() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getLosMipLevel(clb->GetTeamId());
		return _ret;
	}
int springai::Mod::GetAirMipLevel() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getAirMipLevel(clb->GetTeamId());
		return _ret;
	}
float springai::Mod::GetLosMul() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getLosMul(clb->GetTeamId());
		return _ret;
	}
float springai::Mod::GetAirLosMul() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getAirLosMul(clb->GetTeamId());
		return _ret;
	}
bool springai::Mod::GetRequireSonarUnderWater() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Mod_getRequireSonarUnderWater(clb->GetTeamId());
		return _ret;
	}
