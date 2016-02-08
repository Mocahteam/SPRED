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

#include "Game.h"

#include "IncludesSources.h"

springai::Game::Game(AICallback* clb) {

	this->clb = clb;
}


springai::Game* springai::Game::GetInstance(AICallback* clb) {

	Game* _ret = NULL;
	_ret = new Game(clb);
	return _ret;
}

int springai::Game::GetCurrentFrame() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getCurrentFrame(clb->GetTeamId());
		return _ret;
	}
int springai::Game::GetAiInterfaceVersion() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getAiInterfaceVersion(clb->GetTeamId());
		return _ret;
	}
int springai::Game::GetMyTeam() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getMyTeam(clb->GetTeamId());
		return _ret;
	}
int springai::Game::GetMyAllyTeam() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getMyAllyTeam(clb->GetTeamId());
		return _ret;
	}
int springai::Game::GetPlayerTeam(int playerId) {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getPlayerTeam(clb->GetTeamId(), playerId);
		return _ret;
	}
const char* springai::Game::GetTeamSide(int otherTeamId) {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getTeamSide(clb->GetTeamId(), otherTeamId);
		return _ret;
	}
struct SAIFloat3 springai::Game::GetTeamColor(int otherTeamId) {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getTeamColor(clb->GetTeamId(), otherTeamId);
		return _ret;
	}
int springai::Game::GetTeamAllyTeam(int otherTeamId) {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getTeamAllyTeam(clb->GetTeamId(), otherTeamId);
		return _ret;
	}
bool springai::Game::IsAllied(int firstAllyTeamId, int secondAllyTeamId) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_isAllied(clb->GetTeamId(), firstAllyTeamId, secondAllyTeamId);
		return _ret;
	}
bool springai::Game::IsExceptionHandlingEnabled() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_isExceptionHandlingEnabled(clb->GetTeamId());
		return _ret;
	}
bool springai::Game::IsDebugModeEnabled() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_isDebugModeEnabled(clb->GetTeamId());
		return _ret;
	}
int springai::Game::GetMode() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getMode(clb->GetTeamId());
		return _ret;
	}
bool springai::Game::IsPaused() {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_isPaused(clb->GetTeamId());
		return _ret;
	}
float springai::Game::GetSpeedFactor() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getSpeedFactor(clb->GetTeamId());
		return _ret;
	}
const char* springai::Game::GetSetupScript() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Game_getSetupScript(clb->GetTeamId());
		return _ret;
	}
