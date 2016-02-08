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

#include "Map.h"

#include "IncludesSources.h"

springai::Map::Map(AICallback* clb) {

	this->clb = clb;
}


springai::Map* springai::Map::GetInstance(AICallback* clb) {

	Map* _ret = NULL;
	_ret = new Map(clb);
	return _ret;
}

unsigned int springai::Map::GetChecksum() {
		unsigned int _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getChecksum(clb->GetTeamId());
		return _ret;
	}
struct SAIFloat3 springai::Map::GetStartPos() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getStartPos(clb->GetTeamId());
		return _ret;
	}
struct SAIFloat3 springai::Map::GetMousePos() {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getMousePos(clb->GetTeamId());
		return _ret;
	}
bool springai::Map::IsPosInCamera(struct SAIFloat3 pos, float radius) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_isPosInCamera(clb->GetTeamId(), pos, radius);
		return _ret;
	}
int springai::Map::GetWidth() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getWidth(clb->GetTeamId());
		return _ret;
	}
int springai::Map::GetHeight() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getHeight(clb->GetTeamId());
		return _ret;
	}
std::vector<float> springai::Map::GetHeightMap() {
		std::vector<float> _ret;

		int size = clb->GetInnerCallback()->Clb_Map_0ARRAY1SIZE0getHeightMap(clb->GetTeamId());
		float* tmpArr = new float[size];
		clb->GetInnerCallback()->Clb_Map_0ARRAY1VALS0getHeightMap(clb->GetTeamId(), tmpArr, size);
		std::vector<float> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
std::vector<float> springai::Map::GetCornersHeightMap() {
		std::vector<float> _ret;

		int size = clb->GetInnerCallback()->Clb_Map_0ARRAY1SIZE0getCornersHeightMap(clb->GetTeamId());
		float* tmpArr = new float[size];
		clb->GetInnerCallback()->Clb_Map_0ARRAY1VALS0getCornersHeightMap(clb->GetTeamId(), tmpArr, size);
		std::vector<float> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
float springai::Map::GetMinHeight() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getMinHeight(clb->GetTeamId());
		return _ret;
	}
float springai::Map::GetMaxHeight() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getMaxHeight(clb->GetTeamId());
		return _ret;
	}
std::vector<float> springai::Map::GetSlopeMap() {
		std::vector<float> _ret;

		int size = clb->GetInnerCallback()->Clb_Map_0ARRAY1SIZE0getSlopeMap(clb->GetTeamId());
		float* tmpArr = new float[size];
		clb->GetInnerCallback()->Clb_Map_0ARRAY1VALS0getSlopeMap(clb->GetTeamId(), tmpArr, size);
		std::vector<float> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
std::vector<unsigned short> springai::Map::GetLosMap() {
		std::vector<unsigned short> _ret;

		int size = clb->GetInnerCallback()->Clb_Map_0ARRAY1SIZE0getLosMap(clb->GetTeamId());
		unsigned short* tmpArr = new unsigned short[size];
		clb->GetInnerCallback()->Clb_Map_0ARRAY1VALS0getLosMap(clb->GetTeamId(), tmpArr, size);
		std::vector<unsigned short> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
std::vector<unsigned short> springai::Map::GetRadarMap() {
		std::vector<unsigned short> _ret;

		int size = clb->GetInnerCallback()->Clb_Map_0ARRAY1SIZE0getRadarMap(clb->GetTeamId());
		unsigned short* tmpArr = new unsigned short[size];
		clb->GetInnerCallback()->Clb_Map_0ARRAY1VALS0getRadarMap(clb->GetTeamId(), tmpArr, size);
		std::vector<unsigned short> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
std::vector<unsigned short> springai::Map::GetJammerMap() {
		std::vector<unsigned short> _ret;

		int size = clb->GetInnerCallback()->Clb_Map_0ARRAY1SIZE0getJammerMap(clb->GetTeamId());
		unsigned short* tmpArr = new unsigned short[size];
		clb->GetInnerCallback()->Clb_Map_0ARRAY1VALS0getJammerMap(clb->GetTeamId(), tmpArr, size);
		std::vector<unsigned short> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
std::vector<unsigned char> springai::Map::GetResourceMapRaw(Resource c_resourceId) {
		std::vector<unsigned char> _ret;

		int size = clb->GetInnerCallback()->Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapRaw(clb->GetTeamId(), c_resourceId.GetResourceId());
		unsigned char* tmpArr = new unsigned char[size];
		clb->GetInnerCallback()->Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapRaw(clb->GetTeamId(), c_resourceId.GetResourceId(), tmpArr, size);
		std::vector<unsigned char> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
std::vector<struct SAIFloat3> springai::Map::GetResourceMapSpotsPositions(Resource c_resourceId, struct SAIFloat3* spots) {
		std::vector<struct SAIFloat3> _ret;

		int size = clb->GetInnerCallback()->Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapSpotsPositions(clb->GetTeamId(), c_resourceId.GetResourceId());
		struct SAIFloat3* tmpArr = new struct SAIFloat3[size];
		clb->GetInnerCallback()->Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapSpotsPositions(clb->GetTeamId(), c_resourceId.GetResourceId(), tmpArr, size);
		std::vector<struct SAIFloat3> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(tmpArr[i]);
		}
		delete [] tmpArr;
		_ret = arrList;
		return _ret;
	}
int springai::Map::GetHash() {
		int _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getHash(clb->GetTeamId());
		return _ret;
	}
const char* springai::Map::GetName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getName(clb->GetTeamId());
		return _ret;
	}
const char* springai::Map::GetHumanName() {
		const char* _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getHumanName(clb->GetTeamId());
		return _ret;
	}
float springai::Map::GetElevationAt(float x, float z) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getElevationAt(clb->GetTeamId(), x, z);
		return _ret;
	}
float springai::Map::GetMaxResource(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_0REF1Resource2resourceId0getMaxResource(clb->GetTeamId(), c_resourceId.GetResourceId());
		return _ret;
	}
float springai::Map::GetExtractorRadius(Resource c_resourceId) {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_0REF1Resource2resourceId0getExtractorRadius(clb->GetTeamId(), c_resourceId.GetResourceId());
		return _ret;
	}
float springai::Map::GetMinWind() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getMinWind(clb->GetTeamId());
		return _ret;
	}
float springai::Map::GetMaxWind() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getMaxWind(clb->GetTeamId());
		return _ret;
	}
float springai::Map::GetCurWind() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getCurWind(clb->GetTeamId());
		return _ret;
	}
float springai::Map::GetTidalStrength() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getTidalStrength(clb->GetTeamId());
		return _ret;
	}
float springai::Map::GetGravity() {
		float _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_getGravity(clb->GetTeamId());
		return _ret;
	}
bool springai::Map::IsPossibleToBuildAt(UnitDef c_unitDefId, struct SAIFloat3 pos, int facing) {
		bool _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_0REF1UnitDef2unitDefId0isPossibleToBuildAt(clb->GetTeamId(), c_unitDefId.GetUnitDefId(), pos, facing);
		return _ret;
	}
struct SAIFloat3 springai::Map::FindClosestBuildSite(UnitDef c_unitDefId, struct SAIFloat3 pos, float searchRadius, int minDist, int facing) {
		struct SAIFloat3 _ret;
		_ret = clb->GetInnerCallback()->Clb_Map_0REF1UnitDef2unitDefId0findClosestBuildSite(clb->GetTeamId(), c_unitDefId.GetUnitDefId(), pos, searchRadius, minDist, facing);
		return _ret;
	}
std::vector<springai::Point*> springai::Map::GetPoints(bool includeAllies) {

		std::vector<Point*> _ret;
		int size = clb->GetInnerCallback()->Clb_Map_0MULTI1SIZE0Point(clb->GetTeamId(), includeAllies);
		std::vector<Point*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Point::GetInstance(clb, i));
		}
		_ret = arrList;
		return _ret;
	}
std::vector<springai::Line*> springai::Map::GetLines(bool includeAllies) {

		std::vector<Line*> _ret;
		int size = clb->GetInnerCallback()->Clb_Map_0MULTI1SIZE0Line(clb->GetTeamId(), includeAllies);
		std::vector<Line*> arrList;
		for (int i=0; i < size; i++) {
			arrList.push_back(Line::GetInstance(clb, i));
		}
		_ret = arrList;
		return _ret;
	}
