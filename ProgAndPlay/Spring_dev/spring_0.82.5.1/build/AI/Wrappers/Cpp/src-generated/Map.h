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

#ifndef _CPPWRAPPER_MAP_H
#define _CPPWRAPPER_MAP_H

#include "IncludesHeaders.h"

namespace springai {

/**
 * Lets C++ Skirmish AIs call back to the Spring engine.
 *
 * @author	AWK wrapper script
 * @version	GENERATED
 */
class Map {

private:
	AICallback* clb;

	Map(AICallback* clb);

public:

	static Map* GetInstance(AICallback* clb);

public:
	unsigned int GetChecksum();

public:
	struct SAIFloat3 GetStartPos();

public:
	struct SAIFloat3 GetMousePos();

public:
	bool IsPosInCamera(struct SAIFloat3 pos, float radius);

public:
	/**
	 * Returns the maps center heightmap width
	 * 
	 * @see getHeightMap()
	 */
	int GetWidth();

public:
	/**
	 * Returns the maps center heightmap height
	 * 
	 * @see getHeightMap()
	 */
	int GetHeight();

public:
	/**
	 * Returns the height for the center of the squares.
	 * This differs slightly from the drawn map, since
	 * that one uses the height at the corners.
	 * Note that the actual map is 8 times larger (in each dimension) and
	 * all other maps (slope, los, resources, etc.) are relative to the
	 * size of the heightmap.
	 * 
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - each data position is 8*8 in size
	 * - the value for the full resolution position (x, z) is at index (z * width + x)
	 * - the last value, bottom right, is at index (width * height - 1)
	 * 
	 * @see getCornersHeightMap()
	 */
	std::vector<float> GetHeightMap();

public:
	/**
	 * Returns the height for the corners of the squares.
	 * This is the same like the drawn map.
	 * It is one unit wider and one higher then the centers height map.
	 * 
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - 4 points mark the edges of an area of 8*8 in size
	 * - the value for upper left corner of the full resolution position (x, z) is at index (z * width + x)
	 * - the last value, bottom right, is at index ((width+1) * (height+1) - 1)
	 * 
	 * @see getHeightMap()
	 */
	std::vector<float> GetCornersHeightMap();

public:
	float GetMinHeight();

public:
	float GetMaxHeight();

public:
	/**
	 * @brief the slope map
	 * The values are 1 minus the y-component of the (average) facenormal of the square.
	 * 
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - each data position is 2*2 in size
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / 2)
	 * - the last value, bottom right, is at index (width/2 * height/2 - 1)
	 */
	std::vector<float> GetSlopeMap();

public:
	/**
	 * @brief the level of sight map
	 * gs->mapx >> losMipLevel
	 * A square with value zero means you do not have LOS coverage on it.
	 * Clb_Mod_getLosMipLevel
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - resolution factor (res) is min(1, 1 << Clb_Mod_getLosMipLevel())
	 *   examples:
	 *   	+ losMipLevel(0) -> res(1)
	 *   	+ losMipLevel(1) -> res(2)
	 *   	+ losMipLevel(2) -> res(4)
	 *   	+ losMipLevel(3) -> res(8)
	 * - each data position is res*res in size
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / res)
	 * - the last value, bottom right, is at index (width/res * height/res - 1)
	 */
	std::vector<unsigned short> GetLosMap();

public:
	/**
	 * @brief the radar map
	 * A square with value 0 means you do not have radar coverage on it.
	 * 
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - each data position is 8*8 in size
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / 8)
	 * - the last value, bottom right, is at index (width/8 * height/8 - 1)
	 */
	std::vector<unsigned short> GetRadarMap();

public:
	/**
	 * @brief the radar jammer map
	 * A square with value 0 means you do not have radar jamming coverage.
	 * 
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - each data position is 8*8 in size
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / 8)
	 * - the last value, bottom right, is at index (width/8 * height/8 - 1)
	 */
	std::vector<unsigned short> GetJammerMap();

public:
	/**
	 * @brief resource maps
	 * This map shows the resource density on the map.
	 * 
	 * - do NOT modify or delete the height-map (native code relevant only)
	 * - index 0 is top left
	 * - each data position is 2*2 in size
	 * - the value for the full resolution position (x, z) is at index ((z * width + x) / 2)
	 * - the last value, bottom right, is at index (width/2 * height/2 - 1)
	 */
	std::vector<unsigned char> GetResourceMapRaw(Resource c_resourceId);

public:
	/**
	 * Returns positions indicating where to place resource extractors on the map.
	 * Only the x and z values give the location of the spots, while the y values
	 * represents the actual amount of resource an extractor placed there can make.
	 * You should only compare the y values to each other, and not try to estimate
	 * effective output from spots.
	 */
	std::vector<struct SAIFloat3> GetResourceMapSpotsPositions(Resource c_resourceId, struct SAIFloat3* spots);

public:
	/**
	 * Returns the archive hash of the map.
	 * Use this for reference to the map, eg. in a cache-file, wherever human
	 * readability does not matter.
	 * This value will never be the same for two maps not having equal content.
	 * Tip: convert to 64 Hex chars for use in file names.
	 * @see getName()
	 */
	int GetHash();

public:
	/**
	 * Returns the name of the map.
	 * Use this for reference to the map, eg. in cache- or config-file names
	 * which are map related, wherever humans may come in contact with the reference.
	 * Be aware though, that this may contain special characters and spaces,
	 * and may not be used as a file name without checks and replaces.
	 * Tip: replace every char matching [^0-9a-zA-Z_-.] with '_'
	 * @see getHash()
	 * @see getHumanName()
	 */
	const char* GetName();

public:
	/**
	 * Returns the human readbale name of the map.
	 * @see getName()
	 */
	const char* GetHumanName();

public:
	/**
	 * Gets the elevation of the map at position (x, z)
	 */
	float GetElevationAt(float x, float z);

public:
	/**
	 * Returns what value 255 in the resource map is worth
	 */
	float GetMaxResource(Resource c_resourceId);

public:
	/**
	 * Returns extraction radius for resource extractors
	 */
	float GetExtractorRadius(Resource c_resourceId);

public:
	float GetMinWind();

public:
	float GetMaxWind();

public:
	float GetCurWind();

public:
	float GetTidalStrength();

public:
	float GetGravity();

public:
	bool IsPossibleToBuildAt(UnitDef c_unitDefId, struct SAIFloat3 pos, int facing);

public:
	struct SAIFloat3 FindClosestBuildSite(UnitDef c_unitDefId, struct SAIFloat3 pos, float searchRadius, int minDist, int facing);
	/**
	 * Returns all points drawn with this AIs team color,
	 * and additionally the ones drawn with allied team colors,
	 * if <code>includeAllies</code> is true.
	 */
public:
	std::vector<Point*> GetPoints(bool includeAllies);
	/**
	 * Returns all lines drawn with this AIs team color,
	 * and additionally the ones drawn with allied team colors,
	 * if <code>includeAllies</code> is true.
	 */
public:
	std::vector<Line*> GetLines(bool includeAllies);
}; // class Map
} // namespace springai

#endif // _CPPWRAPPER_MAP_H

