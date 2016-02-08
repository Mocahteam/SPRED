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

#include "AICallback.h"

#include "IncludesSources.h"

springai::AICallback::AICallback(const SSkirmishAICallback* innerCallback, int teamId) {

	this->innerCallback = innerCallback;
	this->teamId = teamId;
}


springai::AICallback* springai::AICallback::GetInstance(const SSkirmishAICallback* innerCallback, int teamId) {

	if (teamId < 0) {
		return NULL;
	}

	AICallback* _ret = NULL;
	_ret = new AICallback(innerCallback, teamId);
	return _ret;
}

const SSkirmishAICallback* springai::AICallback::GetInnerCallback() {
	return this->innerCallback;
}

int springai::AICallback::GetTeamId() {
	return this->teamId;
}

springai::Engine* springai::AICallback::GetEngine() {

		Engine* _ret;
		_ret = Engine::GetInstance(this);
		return _ret;
	}
springai::Teams* springai::AICallback::GetTeams() {

		Teams* _ret;
		_ret = Teams::GetInstance(this);
		return _ret;
	}
springai::SkirmishAIs* springai::AICallback::GetSkirmishAIs() {

		SkirmishAIs* _ret;
		_ret = SkirmishAIs::GetInstance(this);
		return _ret;
	}
springai::SkirmishAI* springai::AICallback::GetSkirmishAI() {

		SkirmishAI* _ret;
		_ret = SkirmishAI::GetInstance(this);
		return _ret;
	}
springai::Log* springai::AICallback::GetLog() {

		Log* _ret;
		_ret = Log::GetInstance(this);
		return _ret;
	}
springai::DataDirs* springai::AICallback::GetDataDirs() {

		DataDirs* _ret;
		_ret = DataDirs::GetInstance(this);
		return _ret;
	}
springai::Game* springai::AICallback::GetGame() {

		Game* _ret;
		_ret = Game::GetInstance(this);
		return _ret;
	}
springai::Gui* springai::AICallback::GetGui() {

		Gui* _ret;
		_ret = Gui::GetInstance(this);
		return _ret;
	}
springai::Cheats* springai::AICallback::GetCheats() {

		Cheats* _ret;
		_ret = Cheats::GetInstance(this);
		return _ret;
	}
std::vector<springai::Resource*> springai::AICallback::GetResources() {

		std::vector<Resource*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE0Resource(teamId);
		std::vector<Resource*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Resource::GetInstance(this, i));
		}
		_ret = arrList;
		return _ret;
	}
springai::Economy* springai::AICallback::GetEconomy() {

		Economy* _ret;
		_ret = Economy::GetInstance(this);
		return _ret;
	}
std::vector<springai::UnitDef*> springai::AICallback::GetUnitDefs() {

		std::vector<UnitDef*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE0UnitDef(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS0UnitDef(teamId, tmpArr, size);
		std::vector<UnitDef*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(UnitDef::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Unit*> springai::AICallback::GetEnemyUnits() {

		std::vector<Unit*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3EnemyUnits0Unit(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3EnemyUnits0Unit(teamId, tmpArr, size);
		std::vector<Unit*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Unit::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Unit*> springai::AICallback::GetEnemyUnitsIn(struct SAIFloat3 pos, float radius) {

		std::vector<Unit*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3EnemyUnitsIn0Unit(teamId, pos, radius);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3EnemyUnitsIn0Unit(teamId, pos, radius, tmpArr, size);
		std::vector<Unit*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Unit::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Unit*> springai::AICallback::GetEnemyUnitsInRadarAndLos() {

		std::vector<Unit*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3EnemyUnitsInRadarAndLos0Unit(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3EnemyUnitsInRadarAndLos0Unit(teamId, tmpArr, size);
		std::vector<Unit*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Unit::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Unit*> springai::AICallback::GetFriendlyUnits() {

		std::vector<Unit*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3FriendlyUnits0Unit(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3FriendlyUnits0Unit(teamId, tmpArr, size);
		std::vector<Unit*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Unit::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Unit*> springai::AICallback::GetFriendlyUnitsIn(struct SAIFloat3 pos, float radius) {

		std::vector<Unit*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3FriendlyUnitsIn0Unit(teamId, pos, radius);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3FriendlyUnitsIn0Unit(teamId, pos, radius, tmpArr, size);
		std::vector<Unit*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Unit::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Unit*> springai::AICallback::GetNeutralUnits() {

		std::vector<Unit*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3NeutralUnits0Unit(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3NeutralUnits0Unit(teamId, tmpArr, size);
		std::vector<Unit*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Unit::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Unit*> springai::AICallback::GetNeutralUnitsIn(struct SAIFloat3 pos, float radius) {

		std::vector<Unit*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3NeutralUnitsIn0Unit(teamId, pos, radius);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3NeutralUnitsIn0Unit(teamId, pos, radius, tmpArr, size);
		std::vector<Unit*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Unit::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Unit*> springai::AICallback::GetTeamUnits() {

		std::vector<Unit*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3TeamUnits0Unit(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3TeamUnits0Unit(teamId, tmpArr, size);
		std::vector<Unit*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Unit::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Unit*> springai::AICallback::GetSelectedUnits() {

		std::vector<Unit*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3SelectedUnits0Unit(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3SelectedUnits0Unit(teamId, tmpArr, size);
		std::vector<Unit*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Unit::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Group*> springai::AICallback::GetGroups() {

		std::vector<Group*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE0Group(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS0Group(teamId, tmpArr, size);
		std::vector<Group*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Group::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
springai::Mod* springai::AICallback::GetMod() {

		Mod* _ret;
		_ret = Mod::GetInstance(this);
		return _ret;
	}
springai::Map* springai::AICallback::GetMap() {

		Map* _ret;
		_ret = Map::GetInstance(this);
		return _ret;
	}
std::vector<springai::FeatureDef*> springai::AICallback::GetFeatureDefs() {

		std::vector<FeatureDef*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE0FeatureDef(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS0FeatureDef(teamId, tmpArr, size);
		std::vector<FeatureDef*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(FeatureDef::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Feature*> springai::AICallback::GetFeatures() {

		std::vector<Feature*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE0Feature(teamId);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS0Feature(teamId, tmpArr, size);
		std::vector<Feature*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Feature::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Feature*> springai::AICallback::GetFeaturesIn(struct SAIFloat3 pos, float radius) {

		std::vector<Feature*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE3FeaturesIn0Feature(teamId, pos, radius);
		int* tmpArr = new int[size];
		innerCallback->Clb_0MULTI1VALS3FeaturesIn0Feature(teamId, pos, radius, tmpArr, size);
		std::vector<Feature*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Feature::GetInstance(this, tmpArr[i]));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::WeaponDef*> springai::AICallback::GetWeaponDefs() {

		std::vector<WeaponDef*> _ret;
		int size = innerCallback->Clb_0MULTI1SIZE0WeaponDef(teamId);
		std::vector<WeaponDef*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(WeaponDef::GetInstance(this, i));
		}
		_ret = arrList;
		return _ret;
	}
springai::Debug* springai::AICallback::GetDebug() {

		Debug* _ret;
		_ret = Debug::GetInstance(this);
		return _ret;
	}
