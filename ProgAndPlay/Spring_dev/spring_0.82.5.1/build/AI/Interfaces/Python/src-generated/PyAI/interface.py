# -*- coding: utf-8 -*-

# This file was generated 2016-6-28 15:15:25

import PyAI.team as teamModule

def dict_helper(vals, keys):
	i = len(vals)
	assert i==len(keys)
	for i, v in enumerate(vals):
		yield (keys[i],v)

def check_float3(value):
	assert isinstance(value, tuple)
	assert reduce(lambda x,y: x and y, [isinstance(i, float) for i in value])


COMMAND_PATH_INIT=16

COMMAND_UNIT_BUILD=35

COMMAND_UNIT_MOVE=42

COMMAND_UNIT_UNLOAD_UNIT=61

COMMAND_UNIT_ATTACK_AREA=46

COMMAND_UNIT_WAIT_DEATH=39

COMMAND_UNIT_RESTORE_AREA=69

COMMAND_DEBUG_DRAWER_ADD_OVERLAY_TEXTURE=88

COMMAND_UNIT_LOAD_ONTO=59

COMMAND_UNIT_RECLAIM=63

COMMAND_SEND_UNITS=9

COMMAND_DRAWER_PATH_FINISH=25

COMMAND_UNIT_WAIT_SQUAD=40

COMMAND_DEBUG_DRAWER_SET_GRAPH_POS=84

COMMAND_DEBUG_DRAWER_SET_OVERLAY_TEXTURE_POS=91

COMMAND_UNIT_GROUP_CLEAR=50

COMMAND_GROUP_ERASE=13

COMMAND_UNIT_STOP=36

COMMAND_UNIT_SET_MOVE_STATE=53

COMMAND_UNIT_UNLOAD_UNITS_AREA=60

COMMAND_PAUSE=81

COMMAND_DRAWER_ADD_NOTIFICATION=22

COMMAND_UNIT_SELF_DESTROY=55

COMMAND_UNIT_SET_AUTO_REPAIR_LEVEL=76

COMMAND_PATH_GET_NEXT_WAYPOINT=18

COMMAND_CHEATS_GIVE_ME_RESOURCE=20

COMMAND_UNIT_RESURRECT=72

COMMAND_UNIT_D_GUN=67

COMMAND_CALL_LUA_RULES=21

COMMAND_CHEATS_SET_MY_HANDICAP=5

COMMAND_GROUP_REMOVE_UNIT=15

COMMAND_DRAWER_POINT_ADD=1

COMMAND_UNIT_ATTACK=45

COMMAND_UNIT_SET_WANTED_MAX_SPEED=56

COMMAND_DRAWER_POINT_REMOVE=3

COMMAND_UNUSED_1=11

COMMAND_UNUSED_0=10

COMMAND_GROUP_CREATE=12

COMMAND_UNIT_CAPTURE=74

COMMAND_DEBUG_DRAWER_ADD_GRAPH_POINT=82

COMMAND_UNIT_SET_TRAJECTORY=71

COMMAND_UNIT_SET_BASE=54

COMMAND_TRACE_RAY=80

COMMAND_UNIT_RECLAIM_AREA=64

COMMAND_UNIT_RESURRECT_AREA=73

COMMAND_GROUP_ADD_UNIT=14

COMMAND_UNIT_SET_REPEAT=70

COMMAND_SET_LAST_POS_MESSAGE=7

COMMAND_UNIT_CAPTURE_AREA=75

COMMAND_DRAWER_DRAW_UNIT=23

COMMAND_UNIT_WAIT_GATHER=41

COMMAND_SEND_TEXT_MESSAGE=6

COMMAND_UNIT_FIGHT=44

COMMAND_SEND_RESOURCES=8

COMMAND_DRAWER_FIGURE_SET_COLOR=33

COMMAND_UNIT_LOAD_UNITS=57

COMMAND_DRAWER_LINE_ADD=2

COMMAND_UNIT_REPAIR=51

COMMAND_UNIT_STOCKPILE=66

COMMAND_UNIT_D_GUN_POS=68

COMMAND_DEBUG_DRAWER_SET_GRAPH_LINE_LABEL=87

COMMAND_UNIT_WAIT_TIME=38

COMMAND_UNIT_SET_ON_OFF=62

COMMAND_DEBUG_DRAWER_SET_OVERLAY_TEXTURE_SIZE=92

COMMAND_NULL=0

COMMAND_UNIT_CLOAK=65

COMMAND_DEBUG_DRAWER_DEL_OVERLAY_TEXTURE=90

COMMAND_UNIT_GUARD=47

COMMAND_PATH_GET_APPROXIMATE_LENGTH=17

COMMAND_DRAWER_FIGURE_CREATE_LINE=32

COMMAND_DEBUG_DRAWER_UPDATE_OVERLAY_TEXTURE=89

COMMAND_UNIT_SET_IDLE_MODE=77

COMMAND_DEBUG_DRAWER_SET_OVERLAY_TEXTURE_LABEL=93

COMMAND_DRAWER_PATH_DRAW_LINE_AND_ICON=27

COMMAND_DRAWER_PATH_RESTART=30

COMMAND_DEBUG_DRAWER_SET_GRAPH_SIZE=85

COMMAND_UNIT_AI_SELECT=48

COMMAND_UNIT_LOAD_UNITS_AREA=58

COMMAND_DRAWER_FIGURE_CREATE_SPLINE=31

COMMAND_CHEATS_GIVE_ME_NEW_UNIT=79

COMMAND_DRAWER_FIGURE_DELETE=34

COMMAND_UNIT_GROUP_ADD=49

COMMAND_DRAWER_PATH_DRAW_ICON_AT_LAST_POS=28

COMMAND_DRAWER_PATH_DRAW_LINE=26

COMMAND_DRAWER_PATH_START=24

COMMAND_DRAWER_PATH_BREAK=29

COMMAND_DEBUG_DRAWER_DELETE_GRAPH_POINTS=83

COMMAND_UNIT_WAIT=37

COMMAND_UNIT_PATROL=43

COMMAND_UNIT_CUSTOM=78

COMMAND_DEBUG_DRAWER_SET_GRAPH_LINE_COLOR=86

COMMAND_PATH_FREE=19

COMMAND_UNIT_SET_FIRE_STATE=52

COMMAND_SEND_START_POS=4


NUM_CMD_TOPICS = 94


EVENT_UNIT_IDLE=7

EVENT_ENEMY_ENTER_LOS=13

EVENT_NULL=0

EVENT_UNIT_CREATED=5

EVENT_UNIT_GIVEN=11

EVENT_SAVE=24

EVENT_ENEMY_LEAVE_LOS=14

EVENT_RELEASE=2

EVENT_PLAYER_COMMAND=20

EVENT_UNIT_CAPTURED=12

EVENT_ENEMY_CREATED=25

EVENT_UNIT_FINISHED=6

EVENT_ENEMY_LEAVE_RADAR=16

EVENT_ENEMY_ENTER_RADAR=15

EVENT_UPDATE=3

EVENT_MESSAGE=4

EVENT_UNIT_MOVE_FAILED=8

EVENT_LOAD=23

EVENT_ENEMY_DAMAGED=17

EVENT_INIT=1

EVENT_ENEMY_FINISHED=26

EVENT_ENEMY_DESTROYED=18

EVENT_UNIT_DAMAGED=9

EVENT_UNIT_DESTROYED=10

EVENT_WEAPON_FIRED=19

EVENT_SEISMIC_PING=21

EVENT_COMMAND_FINISHED=22


NUM_EVENTS = 27


class Group(object):

	@staticmethod
	def isSelected(groupId):
		"""The arguments are:
	groupId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		return teamModule._currentTeam.callback.Clb_Group_isSelected(teamModule._currentTeam.teamId,groupId)


	@staticmethod
	def SupportedCommand(groupId):
		"""The arguments are:
	groupId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		return teamModule._currentTeam.callback.Clb_Group_0MULTI1SIZE0SupportedCommand(teamModule._currentTeam.teamId,groupId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS0Group(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE0Group(teamModule._currentTeam.teamId))




class Log(object):

	@staticmethod
	def exception(msg,severety,die):
		"""The arguments are:
	msg: string
	severety: int
	die: bool
"""
		assert isinstance(msg, str)
		assert isinstance(severety, (int, long))
		severety=int(severety)
		assert isinstance(die, int)
		return teamModule._currentTeam.callback.Clb_Log_exception(teamModule._currentTeam.teamId,msg,severety,die)


	@staticmethod
	def log(msg):
		"""The arguments are:
	msg: string
"""
		assert isinstance(msg, str)
		return teamModule._currentTeam.callback.Clb_Log_log(teamModule._currentTeam.teamId,msg)




class Damage(object):

	@staticmethod
	def getImpulseBoost(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Damage_getImpulseBoost(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCraterMult(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Damage_getCraterMult(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getParalyzeDamageTime(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Damage_getParalyzeDamageTime(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getImpulseFactor(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Damage_getImpulseFactor(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getTypes(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Damage_0ARRAY1VALS0getTypes(teamModule._currentTeam.teamId,weaponDefId,None, teamModule._currentTeam.callback.Clb_WeaponDef_Damage_0ARRAY1SIZE0getTypes(teamModule._currentTeam.teamId,weaponDefId))


	@staticmethod
	def getCraterBoost(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Damage_getCraterBoost(teamModule._currentTeam.teamId,weaponDefId)




class Camera(object):

	@staticmethod
	def getPosition():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Gui_Camera_getPosition(teamModule._currentTeam.teamId)


	@staticmethod
	def getDirection():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Gui_Camera_getDirection(teamModule._currentTeam.teamId)




class Economy(object):

	@staticmethod
	def getIncome(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Economy_0REF1Resource2resourceId0getIncome(teamModule._currentTeam.teamId,resourceId)


	@staticmethod
	def getCurrent(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Economy_0REF1Resource2resourceId0getCurrent(teamModule._currentTeam.teamId,resourceId)


	@staticmethod
	def getStorage(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Economy_0REF1Resource2resourceId0getStorage(teamModule._currentTeam.teamId,resourceId)


	@staticmethod
	def getUsage(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Economy_0REF1Resource2resourceId0getUsage(teamModule._currentTeam.teamId,resourceId)




class WeaponMount(object):

	@staticmethod
	def getFuelUsage(unitDefId,weaponMountId):
		"""The arguments are:
	unitDefId: int
	weaponMountId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(weaponMountId, (int, long))
		weaponMountId=int(weaponMountId)
		return teamModule._currentTeam.callback.Clb_UnitDef_WeaponMount_getFuelUsage(teamModule._currentTeam.teamId,unitDefId,weaponMountId)


	@staticmethod
	def getWeaponDef(unitDefId,weaponMountId):
		"""The arguments are:
	unitDefId: int
	weaponMountId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(weaponMountId, (int, long))
		weaponMountId=int(weaponMountId)
		return teamModule._currentTeam.callback.Clb_UnitDef_WeaponMount_0SINGLE1FETCH2WeaponDef0getWeaponDef(teamModule._currentTeam.teamId,unitDefId,weaponMountId)


	@staticmethod
	def getMainDir(unitDefId,weaponMountId):
		"""The arguments are:
	unitDefId: int
	weaponMountId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(weaponMountId, (int, long))
		weaponMountId=int(weaponMountId)
		return teamModule._currentTeam.callback.Clb_UnitDef_WeaponMount_getMainDir(teamModule._currentTeam.teamId,unitDefId,weaponMountId)


	@staticmethod
	def getOnlyTargetCategory(unitDefId,weaponMountId):
		"""The arguments are:
	unitDefId: int
	weaponMountId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(weaponMountId, (int, long))
		weaponMountId=int(weaponMountId)
		return teamModule._currentTeam.callback.Clb_UnitDef_WeaponMount_getOnlyTargetCategory(teamModule._currentTeam.teamId,unitDefId,weaponMountId)


	@staticmethod
	def getBadTargetCategory(unitDefId,weaponMountId):
		"""The arguments are:
	unitDefId: int
	weaponMountId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(weaponMountId, (int, long))
		weaponMountId=int(weaponMountId)
		return teamModule._currentTeam.callback.Clb_UnitDef_WeaponMount_getBadTargetCategory(teamModule._currentTeam.teamId,unitDefId,weaponMountId)


	@staticmethod
	def getSlavedTo(unitDefId,weaponMountId):
		"""The arguments are:
	unitDefId: int
	weaponMountId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(weaponMountId, (int, long))
		weaponMountId=int(weaponMountId)
		return teamModule._currentTeam.callback.Clb_UnitDef_WeaponMount_getSlavedTo(teamModule._currentTeam.teamId,unitDefId,weaponMountId)


	@staticmethod
	def getName(unitDefId,weaponMountId):
		"""The arguments are:
	unitDefId: int
	weaponMountId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(weaponMountId, (int, long))
		weaponMountId=int(weaponMountId)
		return teamModule._currentTeam.callback.Clb_UnitDef_WeaponMount_getName(teamModule._currentTeam.teamId,unitDefId,weaponMountId)


	@staticmethod
	def getMaxAngleDif(unitDefId,weaponMountId):
		"""The arguments are:
	unitDefId: int
	weaponMountId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(weaponMountId, (int, long))
		weaponMountId=int(weaponMountId)
		return teamModule._currentTeam.callback.Clb_UnitDef_WeaponMount_getMaxAngleDif(teamModule._currentTeam.teamId,unitDefId,weaponMountId)




class Map(object):

	@staticmethod
	def getHeightMap():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0getHeightMap(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0getHeightMap(teamModule._currentTeam.teamId))


	@staticmethod
	def getMaxResource(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Map_0REF1Resource2resourceId0getMaxResource(teamModule._currentTeam.teamId,resourceId)


	@staticmethod
	def getCornersHeightMap():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0getCornersHeightMap(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0getCornersHeightMap(teamModule._currentTeam.teamId))


	@staticmethod
	def getRadarMap():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0getRadarMap(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0getRadarMap(teamModule._currentTeam.teamId))


	@staticmethod
	def getTidalStrength():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getTidalStrength(teamModule._currentTeam.teamId)


	@staticmethod
	def getResourceMapRaw(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapRaw(teamModule._currentTeam.teamId,resourceId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapRaw(teamModule._currentTeam.teamId,resourceId))


	@staticmethod
	def getHeight():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getHeight(teamModule._currentTeam.teamId)


	@staticmethod
	def getResourceMapSpotsPositions(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapSpotsPositions(teamModule._currentTeam.teamId,resourceId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapSpotsPositions(teamModule._currentTeam.teamId,resourceId))


	@staticmethod
	def getMaxWind():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getMaxWind(teamModule._currentTeam.teamId)


	@staticmethod
	def getHash():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getHash(teamModule._currentTeam.teamId)


	@staticmethod
	def getWidth():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getWidth(teamModule._currentTeam.teamId)


	@staticmethod
	def getMousePos():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getMousePos(teamModule._currentTeam.teamId)


	@staticmethod
	def getElevationAt(x,z):
		"""The arguments are:
	x: float
	z: float
"""
		assert isinstance(x, float)
		assert isinstance(z, float)
		return teamModule._currentTeam.callback.Clb_Map_getElevationAt(teamModule._currentTeam.teamId,x,z)


	@staticmethod
	def getStartPos():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getStartPos(teamModule._currentTeam.teamId)


	@staticmethod
	def initResourceMapSpotsNearest():
		"""The arguments are:
	resourceId: int
	pos: (float, float, float)
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		check_float3(pos)
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsNearest(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0initResourceMapSpotsNearest(teamModule._currentTeam.teamId))


	@staticmethod
	def getMinWind():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getMinWind(teamModule._currentTeam.teamId)


	@staticmethod
	def getGravity():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getGravity(teamModule._currentTeam.teamId)


	@staticmethod
	def getCurWind():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getCurWind(teamModule._currentTeam.teamId)


	@staticmethod
	def Point(includeAllies):
		"""The arguments are:
	includeAllies: bool
"""
		assert isinstance(includeAllies, int)
		return teamModule._currentTeam.callback.Clb_Map_0MULTI1SIZE0Point(teamModule._currentTeam.teamId,includeAllies)


	@staticmethod
	def getChecksum():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getChecksum(teamModule._currentTeam.teamId)


	@staticmethod
	def getMinHeight():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getMinHeight(teamModule._currentTeam.teamId)


	@staticmethod
	def Line(includeAllies):
		"""The arguments are:
	includeAllies: bool
"""
		assert isinstance(includeAllies, int)
		return teamModule._currentTeam.callback.Clb_Map_0MULTI1SIZE0Line(teamModule._currentTeam.teamId,includeAllies)


	@staticmethod
	def getLosMap():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0getLosMap(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0getLosMap(teamModule._currentTeam.teamId))


	@staticmethod
	def getExtractorRadius(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Map_0REF1Resource2resourceId0getExtractorRadius(teamModule._currentTeam.teamId,resourceId)


	@staticmethod
	def getJammerMap():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0getJammerMap(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0getJammerMap(teamModule._currentTeam.teamId))


	@staticmethod
	def getHumanName():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getHumanName(teamModule._currentTeam.teamId)


	@staticmethod
	def getMaxHeight():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getMaxHeight(teamModule._currentTeam.teamId)


	@staticmethod
	def getName():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Map_getName(teamModule._currentTeam.teamId)


	@staticmethod
	def isPossibleToBuildAt(unitDefId,pos,facing):
		"""The arguments are:
	unitDefId: int
	pos: (float, float, float)
	facing: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		check_float3(pos)
		assert isinstance(facing, (int, long))
		facing=int(facing)
		return teamModule._currentTeam.callback.Clb_Map_0REF1UnitDef2unitDefId0isPossibleToBuildAt(teamModule._currentTeam.teamId,unitDefId,pos,facing)


	@staticmethod
	def getSlopeMap():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0getSlopeMap(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0getSlopeMap(teamModule._currentTeam.teamId))


	@staticmethod
	def isPosInCamera(pos,radius):
		"""The arguments are:
	pos: (float, float, float)
	radius: float
"""
		check_float3(pos)
		assert isinstance(radius, float)
		return teamModule._currentTeam.callback.Clb_Map_isPosInCamera(teamModule._currentTeam.teamId,pos,radius)


	@staticmethod
	def initResourceMapSpotsAverageIncome():
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsAverageIncome(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0initResourceMapSpotsAverageIncome(teamModule._currentTeam.teamId))


	@staticmethod
	def findClosestBuildSite(unitDefId,pos,searchRadius,minDist,facing):
		"""The arguments are:
	unitDefId: int
	pos: (float, float, float)
	searchRadius: float
	minDist: int
	facing: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		check_float3(pos)
		assert isinstance(searchRadius, float)
		assert isinstance(minDist, (int, long))
		minDist=int(minDist)
		assert isinstance(facing, (int, long))
		facing=int(facing)
		return teamModule._currentTeam.callback.Clb_Map_0REF1UnitDef2unitDefId0findClosestBuildSite(teamModule._currentTeam.teamId,unitDefId,pos,searchRadius,minDist,facing)




class DataDirs(object):

	@staticmethod
	def allocatePath(relPath,writeable,create,dir,common):
		"""The arguments are:
	relPath: string
	writeable: bool
	create: bool
	dir: bool
	common: bool
"""
		assert isinstance(relPath, str)
		assert isinstance(writeable, int)
		assert isinstance(create, int)
		assert isinstance(dir, int)
		assert isinstance(common, int)
		return teamModule._currentTeam.callback.Clb_DataDirs_allocatePath(teamModule._currentTeam.teamId,relPath,writeable,create,dir,common)


	@staticmethod
	def getConfigDir():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_DataDirs_getConfigDir(teamModule._currentTeam.teamId)


	@staticmethod
	def getWriteableDir():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_DataDirs_getWriteableDir(teamModule._currentTeam.teamId)


	@staticmethod
	def locatePath(path,path_sizeMax,relPath,writeable,create,dir,common):
		"""The arguments are:
	path: string
	path_sizeMax: int
	relPath: string
	writeable: bool
	create: bool
	dir: bool
	common: bool
"""
		assert isinstance(path, str)
		assert isinstance(path_sizeMax, (int, long))
		path_sizeMax=int(path_sizeMax)
		assert isinstance(relPath, str)
		assert isinstance(writeable, int)
		assert isinstance(create, int)
		assert isinstance(dir, int)
		assert isinstance(common, int)
		return teamModule._currentTeam.callback.Clb_DataDirs_locatePath(teamModule._currentTeam.teamId,path,path_sizeMax,relPath,writeable,create,dir,common)


	@staticmethod
	def getPathSeparator():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_DataDirs_getPathSeparator(teamModule._currentTeam.teamId)




class MoveData(object):

	@staticmethod
	def getSize(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getSize(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getCrushStrength(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getCrushStrength(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getFollowGround(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getFollowGround(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTerrainClass(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getTerrainClass(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxTurnRate(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getMaxTurnRate(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isSubMarine(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_isSubMarine(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getSlopeMod(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getSlopeMod(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxAcceleration(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getMaxAcceleration(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getPathType(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getPathType(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getDepthMod(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getDepthMod(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxBreaking(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getMaxBreaking(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getDepth(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getDepth(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxSlope(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getMaxSlope(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMoveType(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getMoveType(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getName(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getName(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getMaxSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMoveFamily(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_MoveData_getMoveFamily(teamModule._currentTeam.teamId,unitDefId)




class OptionValues(object):

	@staticmethod
	def getKey(optionIndex):
		"""The arguments are:
	optionIndex: int
"""
		assert isinstance(optionIndex, (int, long))
		optionIndex=int(optionIndex)
		return teamModule._currentTeam.callback.Clb_SkirmishAI_OptionValues_getKey(teamModule._currentTeam.teamId,optionIndex)


	@staticmethod
	def getValueByKey(key):
		"""The arguments are:
	key: string
"""
		assert isinstance(key, str)
		return teamModule._currentTeam.callback.Clb_SkirmishAI_OptionValues_getValueByKey(teamModule._currentTeam.teamId,key)


	@staticmethod
	def getValue(optionIndex):
		"""The arguments are:
	optionIndex: int
"""
		assert isinstance(optionIndex, (int, long))
		optionIndex=int(optionIndex)
		return teamModule._currentTeam.callback.Clb_SkirmishAI_OptionValues_getValue(teamModule._currentTeam.teamId,optionIndex)


	@staticmethod
	def getSize():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_SkirmishAI_OptionValues_getSize(teamModule._currentTeam.teamId)




class SupportedCommand(object):

	@staticmethod
	def getId(groupId,commandId):
		"""The arguments are:
	groupId: int
	commandId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Group_SupportedCommand_getId(teamModule._currentTeam.teamId,groupId,commandId)


	@staticmethod
	def getParams(groupId,commandId):
		"""The arguments are:
	groupId: int
	commandId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Group_SupportedCommand_0ARRAY1VALS0getParams(teamModule._currentTeam.teamId,groupId,commandId,None, teamModule._currentTeam.callback.Clb_Group_SupportedCommand_0ARRAY1SIZE0getParams(teamModule._currentTeam.teamId,groupId,commandId))


	@staticmethod
	def getId(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_SupportedCommand_getId(teamModule._currentTeam.teamId,unitId,commandId)


	@staticmethod
	def getParams(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_SupportedCommand_0ARRAY1VALS0getParams(teamModule._currentTeam.teamId,unitId,commandId,None, teamModule._currentTeam.callback.Clb_Unit_SupportedCommand_0ARRAY1SIZE0getParams(teamModule._currentTeam.teamId,unitId,commandId))


	@staticmethod
	def getToolTip(groupId,commandId):
		"""The arguments are:
	groupId: int
	commandId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Group_SupportedCommand_getToolTip(teamModule._currentTeam.teamId,groupId,commandId)


	@staticmethod
	def isShowUnique(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_SupportedCommand_isShowUnique(teamModule._currentTeam.teamId,unitId,commandId)


	@staticmethod
	def getToolTip(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_SupportedCommand_getToolTip(teamModule._currentTeam.teamId,unitId,commandId)


	@staticmethod
	def getName(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_SupportedCommand_getName(teamModule._currentTeam.teamId,unitId,commandId)


	@staticmethod
	def isShowUnique(groupId,commandId):
		"""The arguments are:
	groupId: int
	commandId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Group_SupportedCommand_isShowUnique(teamModule._currentTeam.teamId,groupId,commandId)


	@staticmethod
	def isDisabled(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_SupportedCommand_isDisabled(teamModule._currentTeam.teamId,unitId,commandId)


	@staticmethod
	def isDisabled(groupId,commandId):
		"""The arguments are:
	groupId: int
	commandId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Group_SupportedCommand_isDisabled(teamModule._currentTeam.teamId,groupId,commandId)


	@staticmethod
	def getName(groupId,commandId):
		"""The arguments are:
	groupId: int
	commandId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Group_SupportedCommand_getName(teamModule._currentTeam.teamId,groupId,commandId)




class Game(object):

	@staticmethod
	def getSpeedFactor():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_getSpeedFactor(teamModule._currentTeam.teamId)


	@staticmethod
	def getTeamSide(otherTeamId):
		"""The arguments are:
	otherTeamId: int
"""
		assert isinstance(otherTeamId, (int, long))
		otherTeamId=int(otherTeamId)
		return teamModule._currentTeam.callback.Clb_Game_getTeamSide(teamModule._currentTeam.teamId,otherTeamId)


	@staticmethod
	def getPlayerTeam(playerId):
		"""The arguments are:
	playerId: int
"""
		assert isinstance(playerId, (int, long))
		playerId=int(playerId)
		return teamModule._currentTeam.callback.Clb_Game_getPlayerTeam(teamModule._currentTeam.teamId,playerId)


	@staticmethod
	def isAllied(firstAllyTeamId,secondAllyTeamId):
		"""The arguments are:
	firstAllyTeamId: int
	secondAllyTeamId: int
"""
		assert isinstance(firstAllyTeamId, (int, long))
		firstAllyTeamId=int(firstAllyTeamId)
		assert isinstance(secondAllyTeamId, (int, long))
		secondAllyTeamId=int(secondAllyTeamId)
		return teamModule._currentTeam.callback.Clb_Game_isAllied(teamModule._currentTeam.teamId,firstAllyTeamId,secondAllyTeamId)


	@staticmethod
	def getMyAllyTeam():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_getMyAllyTeam(teamModule._currentTeam.teamId)


	@staticmethod
	def getCurrentFrame():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_getCurrentFrame(teamModule._currentTeam.teamId)


	@staticmethod
	def getMyTeam():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_getMyTeam(teamModule._currentTeam.teamId)


	@staticmethod
	def getMode():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_getMode(teamModule._currentTeam.teamId)


	@staticmethod
	def getAiInterfaceVersion():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_getAiInterfaceVersion(teamModule._currentTeam.teamId)


	@staticmethod
	def isExceptionHandlingEnabled():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_isExceptionHandlingEnabled(teamModule._currentTeam.teamId)


	@staticmethod
	def getTeamColor(otherTeamId):
		"""The arguments are:
	otherTeamId: int
"""
		assert isinstance(otherTeamId, (int, long))
		otherTeamId=int(otherTeamId)
		return teamModule._currentTeam.callback.Clb_Game_getTeamColor(teamModule._currentTeam.teamId,otherTeamId)


	@staticmethod
	def getTeamAllyTeam(otherTeamId):
		"""The arguments are:
	otherTeamId: int
"""
		assert isinstance(otherTeamId, (int, long))
		otherTeamId=int(otherTeamId)
		return teamModule._currentTeam.callback.Clb_Game_getTeamAllyTeam(teamModule._currentTeam.teamId,otherTeamId)


	@staticmethod
	def getSetupScript():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_getSetupScript(teamModule._currentTeam.teamId)


	@staticmethod
	def isPaused():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_isPaused(teamModule._currentTeam.teamId)


	@staticmethod
	def isDebugModeEnabled():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Game_isDebugModeEnabled(teamModule._currentTeam.teamId)




class SkirmishAIs(object):

	@staticmethod
	def getSize():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_SkirmishAIs_getSize(teamModule._currentTeam.teamId)


	@staticmethod
	def getMax():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_SkirmishAIs_getMax(teamModule._currentTeam.teamId)




class Line(object):

	@staticmethod
	def getFirstPosition(lineId):
		"""The arguments are:
	lineId: int
"""
		assert isinstance(lineId, (int, long))
		lineId=int(lineId)
		return teamModule._currentTeam.callback.Clb_Map_Line_getFirstPosition(teamModule._currentTeam.teamId,lineId)


	@staticmethod
	def getSecondPosition(lineId):
		"""The arguments are:
	lineId: int
"""
		assert isinstance(lineId, (int, long))
		lineId=int(lineId)
		return teamModule._currentTeam.callback.Clb_Map_Line_getSecondPosition(teamModule._currentTeam.teamId,lineId)


	@staticmethod
	def getColor(lineId):
		"""The arguments are:
	lineId: int
"""
		assert isinstance(lineId, (int, long))
		lineId=int(lineId)
		return teamModule._currentTeam.callback.Clb_Map_Line_getColor(teamModule._currentTeam.teamId,lineId)




class Mod(object):

	@staticmethod
	def getReclaimUnitEnergyCostFactor():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getReclaimUnitEnergyCostFactor(teamModule._currentTeam.teamId)


	@staticmethod
	def getTransportHover():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getTransportHover(teamModule._currentTeam.teamId)


	@staticmethod
	def getHash():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getHash(teamModule._currentTeam.teamId)


	@staticmethod
	def getLosMul():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getLosMul(teamModule._currentTeam.teamId)


	@staticmethod
	def getTransportGround():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getTransportGround(teamModule._currentTeam.teamId)


	@staticmethod
	def getAllowTeamColors():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getAllowTeamColors(teamModule._currentTeam.teamId)


	@staticmethod
	def getFireAtCrashing():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getFireAtCrashing(teamModule._currentTeam.teamId)


	@staticmethod
	def getMultiReclaim():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getMultiReclaim(teamModule._currentTeam.teamId)


	@staticmethod
	def getShortName():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getShortName(teamModule._currentTeam.teamId)


	@staticmethod
	def getHumanName():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getHumanName(teamModule._currentTeam.teamId)


	@staticmethod
	def getReclaimAllowEnemies():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getReclaimAllowEnemies(teamModule._currentTeam.teamId)


	@staticmethod
	def getConstructionDecaySpeed():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getConstructionDecaySpeed(teamModule._currentTeam.teamId)


	@staticmethod
	def getRepairEnergyCostFactor():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getRepairEnergyCostFactor(teamModule._currentTeam.teamId)


	@staticmethod
	def getReclaimAllowAllies():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getReclaimAllowAllies(teamModule._currentTeam.teamId)


	@staticmethod
	def getTransportShip():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getTransportShip(teamModule._currentTeam.teamId)


	@staticmethod
	def getAirLosMul():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getAirLosMul(teamModule._currentTeam.teamId)


	@staticmethod
	def getReclaimUnitMethod():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getReclaimUnitMethod(teamModule._currentTeam.teamId)


	@staticmethod
	def getReclaimUnitEfficiency():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getReclaimUnitEfficiency(teamModule._currentTeam.teamId)


	@staticmethod
	def getCaptureEnergyCostFactor():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getCaptureEnergyCostFactor(teamModule._currentTeam.teamId)


	@staticmethod
	def getVersion():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getVersion(teamModule._currentTeam.teamId)


	@staticmethod
	def getAirMipLevel():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getAirMipLevel(teamModule._currentTeam.teamId)


	@staticmethod
	def getResurrectEnergyCostFactor():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getResurrectEnergyCostFactor(teamModule._currentTeam.teamId)


	@staticmethod
	def getReclaimFeatureEnergyCostFactor():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getReclaimFeatureEnergyCostFactor(teamModule._currentTeam.teamId)


	@staticmethod
	def getRequireSonarUnderWater():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getRequireSonarUnderWater(teamModule._currentTeam.teamId)


	@staticmethod
	def getLosMipLevel():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getLosMipLevel(teamModule._currentTeam.teamId)


	@staticmethod
	def getFileName():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getFileName(teamModule._currentTeam.teamId)


	@staticmethod
	def getDescription():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getDescription(teamModule._currentTeam.teamId)


	@staticmethod
	def getConstructionDecayTime():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getConstructionDecayTime(teamModule._currentTeam.teamId)


	@staticmethod
	def getFlankingBonusModeDefault():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getFlankingBonusModeDefault(teamModule._currentTeam.teamId)


	@staticmethod
	def getTransportAir():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getTransportAir(teamModule._currentTeam.teamId)


	@staticmethod
	def getReclaimMethod():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getReclaimMethod(teamModule._currentTeam.teamId)


	@staticmethod
	def getConstructionDecay():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getConstructionDecay(teamModule._currentTeam.teamId)


	@staticmethod
	def getFireAtKilled():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getFireAtKilled(teamModule._currentTeam.teamId)


	@staticmethod
	def getMutator():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Mod_getMutator(teamModule._currentTeam.teamId)




class Info(object):

	@staticmethod
	def getDescription(infoIndex):
		"""The arguments are:
	infoIndex: int
"""
		assert isinstance(infoIndex, (int, long))
		infoIndex=int(infoIndex)
		return teamModule._currentTeam.callback.Clb_SkirmishAI_Info_getDescription(teamModule._currentTeam.teamId,infoIndex)


	@staticmethod
	def getKey(infoIndex):
		"""The arguments are:
	infoIndex: int
"""
		assert isinstance(infoIndex, (int, long))
		infoIndex=int(infoIndex)
		return teamModule._currentTeam.callback.Clb_SkirmishAI_Info_getKey(teamModule._currentTeam.teamId,infoIndex)


	@staticmethod
	def getSize():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_SkirmishAI_Info_getSize(teamModule._currentTeam.teamId)


	@staticmethod
	def getValueByKey(key):
		"""The arguments are:
	key: string
"""
		assert isinstance(key, str)
		return teamModule._currentTeam.callback.Clb_SkirmishAI_Info_getValueByKey(teamModule._currentTeam.teamId,key)


	@staticmethod
	def getValue(infoIndex):
		"""The arguments are:
	infoIndex: int
"""
		assert isinstance(infoIndex, (int, long))
		infoIndex=int(infoIndex)
		return teamModule._currentTeam.callback.Clb_SkirmishAI_Info_getValue(teamModule._currentTeam.teamId,infoIndex)




class WeaponDef(object):

	@staticmethod
	def getBounceSlip(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getBounceSlip(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getStartVelocity(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getStartVelocity(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getSizeGrowth(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getSizeGrowth(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getMinIntensity(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getMinIntensity(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCoverageRange(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getCoverageRange(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isDynDamageInverted(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isDynDamageInverted(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getPredictBoost(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getPredictBoost(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getHeightBoostFactor(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getHeightBoostFactor(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isShieldRepulser(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isShieldRepulser(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getOnlyTargetCategory(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getOnlyTargetCategory(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getSupplyCost(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getSupplyCost(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getWeaponAcceleration(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getWeaponAcceleration(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getVisibleShieldHitFrames(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getVisibleShieldHitFrames(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isSubMissile(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isSubMissile(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getWeaponDefByName(weaponDefName):
		"""The arguments are:
	weaponDefName: string
"""
		assert isinstance(weaponDefName, str)
		return teamModule._currentTeam.callback.Clb_0MULTI1FETCH3WeaponDefByName0WeaponDef(teamModule._currentTeam.teamId,weaponDefName)


	@staticmethod
	def isParalyzer(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isParalyzer(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getProjectileSpeed(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getProjectileSpeed(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getReload(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getReload(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCollisionSize(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getCollisionSize(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getFalloffRate(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getFalloffRate(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getMaxVelocity(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getMaxVelocity(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isExteriorShield(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isExteriorShield(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getTrajectoryHeight(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getTrajectoryHeight(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getName(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getName(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getDynDamageExp(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getDynDamageExp(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isManualFire(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isManualFire(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isAvoidNeutral(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isAvoidNeutral(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getNumBounce(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getNumBounce(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isTurret(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isTurret(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isLargeBeamLaser(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isLargeBeamLaser(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isFireSubmersed(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isFireSubmersed(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getSprayAngle(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getSprayAngle(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getDance(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getDance(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isSoundTrigger(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isSoundTrigger(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCegTag(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getCegTag(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getEdgeEffectiveness(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getEdgeEffectiveness(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getLeadBonus(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getLeadBonus(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isShield(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isShield(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getSalvoDelay(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getSalvoDelay(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isNoExplode(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isNoExplode(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCollisionFlags(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getCollisionFlags(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isWaterBounce(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isWaterBounce(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getLeadLimit(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getLeadLimit(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getTargetable(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getTargetable(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isVisibleShieldRepulse(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isVisibleShieldRepulse(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isBeamBurst(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isBeamBurst(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getDuration(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getDuration(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getDynDamageRange(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getDynDamageRange(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCylinderTargetting(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getCylinderTargetting(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCoreThickness(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getCoreThickness(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCameraShake(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getCameraShake(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getSalvoSize(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getSalvoSize(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getRange(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getRange(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getTargetBorder(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getTargetBorder(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getInterceptor(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getInterceptor(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCustomParams():
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		vals = teamModule._currentTeam.callback.Clb_WeaponDef_0MAP1VALS0getCustomParams(teamModule._currentTeam.teamId,weaponDefId)
		keys = teamModule._currentTeam.callback.Clb_WeaponDef_0MAP1KEYS0getCustomParams(teamModule._currentTeam.teamId,weaponDefId)
		return dict(dict_helper(vals, keys))



	@staticmethod
	def isAvoidFeature(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isAvoidFeature(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getBeamTime(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getBeamTime(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isDropped(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isDropped(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getTargetMoveError(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getTargetMoveError(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isNoSelfDamage(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isNoSelfDamage(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getNumDamageTypes():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_WeaponDef_0STATIC0getNumDamageTypes(teamModule._currentTeam.teamId)


	@staticmethod
	def getInterceptedByShieldType(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getInterceptedByShieldType(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isFixedLauncher(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isFixedLauncher(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isSweepFire(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isSweepFire(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getIntensity(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getIntensity(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getFireStarter(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getFireStarter(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCost(weaponDefId,resourceId):
		"""The arguments are:
	weaponDefId: int
	resourceId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_0REF1Resource2resourceId0getCost(teamModule._currentTeam.teamId,weaponDefId,resourceId)


	@staticmethod
	def getGraphicsType(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getGraphicsType(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getExplosionSpeed(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getExplosionSpeed(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isOnlyForward(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isOnlyForward(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getProximityPriority(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getProximityPriority(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getDynDamageMin(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getDynDamageMin(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isImpactOnly(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isImpactOnly(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isAvoidFriendly(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isAvoidFriendly(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getThickness(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getThickness(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isSmartShield(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isSmartShield(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getWobble(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getWobble(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getCount():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_0MULTI1SIZE0WeaponDef(teamModule._currentTeam.teamId)


	@staticmethod
	def getStockpileTime(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getStockpileTime(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isStockpileable(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isStockpileable(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isTracks(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isTracks(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isGroundBounce(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isGroundBounce(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getProjectilesPerShot(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getProjectilesPerShot(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isSelfExplode(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isSelfExplode(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getBounceRebound(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getBounceRebound(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getFileName(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getFileName(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getHeightMod(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getHeightMod(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getUpTime(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getUpTime(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getMaxAngle(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getMaxAngle(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getAccuracy(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getAccuracy(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isWaterWeapon(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isWaterWeapon(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getSize(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getSize(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getDescription(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getDescription(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getMovingAccuracy(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getMovingAccuracy(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isGravityAffected(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isGravityAffected(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getType(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getType(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getLaserFlareSize(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getLaserFlareSize(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getRestTime(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getRestTime(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getAreaOfEffect(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getAreaOfEffect(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getTurnRate(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getTurnRate(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isNoAutoTarget(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isNoAutoTarget(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isVisibleShield(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isVisibleShield(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getMyGravity(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getMyGravity(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def isAbleToAttackGround(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_isAbleToAttackGround(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getHighTrajectory(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getHighTrajectory(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getFlightTime(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getFlightTime(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getLodDistance(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_getLodDistance(teamModule._currentTeam.teamId,weaponDefId)




class Resource(object):

	@staticmethod
	def getOptimum(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Resource_getOptimum(teamModule._currentTeam.teamId,resourceId)


	@staticmethod
	def getName(resourceId):
		"""The arguments are:
	resourceId: int
"""
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Resource_getName(teamModule._currentTeam.teamId,resourceId)


	@staticmethod
	def getResourceByName(resourceName):
		"""The arguments are:
	resourceName: string
"""
		assert isinstance(resourceName, str)
		return teamModule._currentTeam.callback.Clb_0MULTI1FETCH3ResourceByName0Resource(teamModule._currentTeam.teamId,resourceName)


	@staticmethod
	def getCount():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_0MULTI1SIZE0Resource(teamModule._currentTeam.teamId)




class CurrentCommand(object):

	@staticmethod
	def getTimeOut(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_CurrentCommand_getTimeOut(teamModule._currentTeam.teamId,unitId,commandId)


	@staticmethod
	def getOptions(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_CurrentCommand_getOptions(teamModule._currentTeam.teamId,unitId,commandId)


	@staticmethod
	def getId(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_CurrentCommand_getId(teamModule._currentTeam.teamId,unitId,commandId)


	@staticmethod
	def getType(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_CurrentCommand_0STATIC0getType(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getTag(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_CurrentCommand_getTag(teamModule._currentTeam.teamId,unitId,commandId)


	@staticmethod
	def getParams(unitId,commandId):
		"""The arguments are:
	unitId: int
	commandId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		return teamModule._currentTeam.callback.Clb_Unit_CurrentCommand_0ARRAY1VALS0getParams(teamModule._currentTeam.teamId,unitId,commandId,None, teamModule._currentTeam.callback.Clb_Unit_CurrentCommand_0ARRAY1SIZE0getParams(teamModule._currentTeam.teamId,unitId,commandId))




class Gui(object):

	@staticmethod
	def getViewRange():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Gui_getViewRange(teamModule._currentTeam.teamId)


	@staticmethod
	def getScreenX():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Gui_getScreenX(teamModule._currentTeam.teamId)


	@staticmethod
	def getScreenY():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Gui_getScreenY(teamModule._currentTeam.teamId)




class Feature(object):

	@staticmethod
	def getReclaimLeft(featureId):
		"""The arguments are:
	featureId: int
"""
		assert isinstance(featureId, (int, long))
		featureId=int(featureId)
		return teamModule._currentTeam.callback.Clb_Feature_getReclaimLeft(teamModule._currentTeam.teamId,featureId)


	@staticmethod
	def getPosition(featureId):
		"""The arguments are:
	featureId: int
"""
		assert isinstance(featureId, (int, long))
		featureId=int(featureId)
		return teamModule._currentTeam.callback.Clb_Feature_getPosition(teamModule._currentTeam.teamId,featureId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS0Feature(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE0Feature(teamModule._currentTeam.teamId))


	@staticmethod
	def Ids(pos,radius):
		"""The arguments are:
	pos: (float, float, float)
	radius: float
"""
		check_float3(pos)
		assert isinstance(radius, float)
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3FeaturesIn0Feature(teamModule._currentTeam.teamId,pos,radius,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3FeaturesIn0Feature(teamModule._currentTeam.teamId,pos,radius))


	@staticmethod
	def getDef(featureId):
		"""The arguments are:
	featureId: int
"""
		assert isinstance(featureId, (int, long))
		featureId=int(featureId)
		return teamModule._currentTeam.callback.Clb_Feature_0SINGLE1FETCH2FeatureDef0getDef(teamModule._currentTeam.teamId,featureId)


	@staticmethod
	def getHealth(featureId):
		"""The arguments are:
	featureId: int
"""
		assert isinstance(featureId, (int, long))
		featureId=int(featureId)
		return teamModule._currentTeam.callback.Clb_Feature_getHealth(teamModule._currentTeam.teamId,featureId)




class OrderPreview(object):

	@staticmethod
	def getId(groupId):
		"""The arguments are:
	groupId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		return teamModule._currentTeam.callback.Clb_Group_OrderPreview_getId(teamModule._currentTeam.teamId,groupId)


	@staticmethod
	def getTimeOut(groupId):
		"""The arguments are:
	groupId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		return teamModule._currentTeam.callback.Clb_Group_OrderPreview_getTimeOut(teamModule._currentTeam.teamId,groupId)


	@staticmethod
	def getOptions(groupId):
		"""The arguments are:
	groupId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		return teamModule._currentTeam.callback.Clb_Group_OrderPreview_getOptions(teamModule._currentTeam.teamId,groupId)


	@staticmethod
	def getTag(groupId):
		"""The arguments are:
	groupId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		return teamModule._currentTeam.callback.Clb_Group_OrderPreview_getTag(teamModule._currentTeam.teamId,groupId)


	@staticmethod
	def getParams(groupId):
		"""The arguments are:
	groupId: int
"""
		assert isinstance(groupId, (int, long))
		groupId=int(groupId)
		return teamModule._currentTeam.callback.Clb_Group_OrderPreview_0ARRAY1VALS0getParams(teamModule._currentTeam.teamId,groupId,None, teamModule._currentTeam.callback.Clb_Group_OrderPreview_0ARRAY1SIZE0getParams(teamModule._currentTeam.teamId,groupId))




class Teams(object):

	@staticmethod
	def getSize():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Teams_getSize(teamModule._currentTeam.teamId)




class Shield(object):

	@staticmethod
	def getForce(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getForce(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getResourceUse(weaponDefId,resourceId):
		"""The arguments are:
	weaponDefId: int
	resourceId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_0REF1Resource2resourceId0getResourceUse(teamModule._currentTeam.teamId,weaponDefId,resourceId)


	@staticmethod
	def getRechargeDelay(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getRechargeDelay(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getMaxSpeed(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getMaxSpeed(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getPower(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getPower(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getStartingPower(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getStartingPower(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getInterceptType(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getInterceptType(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getGoodColor(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getGoodColor(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getPowerRegenResource(weaponDefId,resourceId):
		"""The arguments are:
	weaponDefId: int
	resourceId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_0REF1Resource2resourceId0getPowerRegenResource(teamModule._currentTeam.teamId,weaponDefId,resourceId)


	@staticmethod
	def getBadColor(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getBadColor(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getAlpha(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getAlpha(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getRadius(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getRadius(teamModule._currentTeam.teamId,weaponDefId)


	@staticmethod
	def getPowerRegen(weaponDefId):
		"""The arguments are:
	weaponDefId: int
"""
		assert isinstance(weaponDefId, (int, long))
		weaponDefId=int(weaponDefId)
		return teamModule._currentTeam.callback.Clb_WeaponDef_Shield_getPowerRegen(teamModule._currentTeam.teamId,weaponDefId)




class FlankingBonus(object):

	@staticmethod
	def getDir(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_FlankingBonus_getDir(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMode(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_FlankingBonus_getMode(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMobilityAdd(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_FlankingBonus_getMobilityAdd(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMin(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_FlankingBonus_getMin(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMax(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_FlankingBonus_getMax(teamModule._currentTeam.teamId,unitDefId)




class Point(object):

	@staticmethod
	def getPosition(pointId):
		"""The arguments are:
	pointId: int
"""
		assert isinstance(pointId, (int, long))
		pointId=int(pointId)
		return teamModule._currentTeam.callback.Clb_Map_Point_getPosition(teamModule._currentTeam.teamId,pointId)


	@staticmethod
	def getColor(pointId):
		"""The arguments are:
	pointId: int
"""
		assert isinstance(pointId, (int, long))
		pointId=int(pointId)
		return teamModule._currentTeam.callback.Clb_Map_Point_getColor(teamModule._currentTeam.teamId,pointId)


	@staticmethod
	def getLabel(pointId):
		"""The arguments are:
	pointId: int
"""
		assert isinstance(pointId, (int, long))
		pointId=int(pointId)
		return teamModule._currentTeam.callback.Clb_Map_Point_getLabel(teamModule._currentTeam.teamId,pointId)




class FeatureDef(object):

	@staticmethod
	def isGeoThermal(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_isGeoThermal(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getReclaimTime(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getReclaimTime(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getZSize(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getZSize(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getDescription(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getDescription(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def isBlocking(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_isBlocking(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getFileName(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getFileName(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getMass(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getMass(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getResurrectable(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getResurrectable(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getSmokeTime(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getSmokeTime(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS0FeatureDef(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE0FeatureDef(teamModule._currentTeam.teamId))


	@staticmethod
	def getDeathFeature(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getDeathFeature(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def isDestructable(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_isDestructable(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getModelName(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getModelName(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getName(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getName(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getContainedResource(featureDefId,resourceId):
		"""The arguments are:
	featureDefId: int
	resourceId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_0REF1Resource2resourceId0getContainedResource(teamModule._currentTeam.teamId,featureDefId,resourceId)


	@staticmethod
	def isReclaimable(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_isReclaimable(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getXSize(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getXSize(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def isBurnable(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_isBurnable(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def isFloating(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_isFloating(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def isUpright(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_isUpright(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getDrawType(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getDrawType(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getMaxHealth(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_getMaxHealth(teamModule._currentTeam.teamId,featureDefId)


	@staticmethod
	def getCustomParams():
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		vals = teamModule._currentTeam.callback.Clb_FeatureDef_0MAP1VALS0getCustomParams(teamModule._currentTeam.teamId,featureDefId)
		keys = teamModule._currentTeam.callback.Clb_FeatureDef_0MAP1KEYS0getCustomParams(teamModule._currentTeam.teamId,featureDefId)
		return dict(dict_helper(vals, keys))



	@staticmethod
	def isNoSelect(featureDefId):
		"""The arguments are:
	featureDefId: int
"""
		assert isinstance(featureDefId, (int, long))
		featureDefId=int(featureDefId)
		return teamModule._currentTeam.callback.Clb_FeatureDef_isNoSelect(teamModule._currentTeam.teamId,featureDefId)




class UnitDef(object):

	@staticmethod
	def getDlHoverFactor(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getDlHoverFactor(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getName(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getName(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getSeismicSignature(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getSeismicSignature(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isReleaseHeld(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isReleaseHeld(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getCategory(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getCategory(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToKamikaze(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToKamikaze(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMyGravity(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMyGravity(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getWaterline(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getWaterline(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getJammerRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getJammerRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isStrafeToAttack(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isStrafeToAttack(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToAttack(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToAttack(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isCollide(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isCollide(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getArmoredMultiple(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getArmoredMultiple(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getUnloadSpread(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getUnloadSpread(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getCaptureSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getCaptureSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getCategoryString(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getCategoryString(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxRepairSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxRepairSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getWantedHeight(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getWantedHeight(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getHighTrajectoryType(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getHighTrajectoryType(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTransportSize(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTransportSize(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getCloakCost(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getCloakCost(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMinAirBasePower(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMinAirBasePower(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getDrag(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getDrag(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getNoChaseCategory(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getNoChaseCategory(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getSpeedToFront(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getSpeedToFront(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isStealth(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isStealth(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToDGun(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToDGun(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getAirLosRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getAirLosRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTurnRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTurnRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getHumanName(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getHumanName(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isFeature(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isFeature(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getRadarRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getRadarRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isDecloakOnFire(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isDecloakOnFire(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToCrash(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToCrash(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getFlareDropVector(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFlareDropVector(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxElevator(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxElevator(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isSquareResourceExtractor(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0isSquareResourceExtractor(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def getFlareTime(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFlareTime(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getUnitDefByName(unitName):
		"""The arguments are:
	unitName: string
"""
		assert isinstance(unitName, str)
		return teamModule._currentTeam.callback.Clb_0MULTI1FETCH3UnitDefByName0UnitDef(teamModule._currentTeam.teamId,unitName)


	@staticmethod
	def getSonarRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getSonarRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAssistable(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAssistable(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxHeightDif(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxHeightDif(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMinTransportMass(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMinTransportMass(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTooltip(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTooltip(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToRepair(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToRepair(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMakesResource(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0getMakesResource(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def getMaxAcceleration(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxAcceleration(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getResourceExtractorRange(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0getResourceExtractorRange(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def getStorage(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0getStorage(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def isReclaimable(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isReclaimable(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTurnInPlaceDistance(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTurnInPlaceDistance(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getVerticalSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getVerticalSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getCost(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0getCost(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def getLosHeight(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getLosHeight(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToRepeat(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToRepeat(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getCloakCostMoving(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getCloakCostMoving(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMinCollisionSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMinCollisionSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getZSize(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getZSize(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getFireState(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFireState(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isDontLand(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isDontLand(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isTransportByEnemy(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isTransportByEnemy(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isTurnInPlace(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isTurnInPlace(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getReclaimSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getReclaimSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isSonarStealth(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isSonarStealth(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getPower(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getPower(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getAutoHeal(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getAutoHeal(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTrackWidth(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTrackWidth(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTurnRate(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTurnRate(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isFullHealthFactory(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isFullHealthFactory(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getBuildDistance(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getBuildDistance(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getBuildingDecalType(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getBuildingDecalType(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isHideDamage(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isHideDamage(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTransportCapacity(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTransportCapacity(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getResourceMake(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0getResourceMake(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def isShowPlayerName(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isShowPlayerName(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getSelfDExplosion(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getSelfDExplosion(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxWeaponRange(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxWeaponRange(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getRefuelTime(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getRefuelTime(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToAssist(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToAssist(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getFallSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFallSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getUpkeep(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0getUpkeep(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def getExtractsResource(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0getExtractsResource(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def getFlareReloadTime(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFlareReloadTime(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getDecloakDistance(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getDecloakDistance(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isHoldSteady(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isHoldSteady(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isFloater(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isFloater(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getLosRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getLosRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getXSize(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getXSize(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def MoveData(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0AVAILABLE0MoveData(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getRepairSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getRepairSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToFight(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToFight(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToSelfRepair(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToSelfRepair(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getAiHint(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getAiHint(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getDecoyDef(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0SINGLE1FETCH2UnitDef0getDecoyDef(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getFlareDelay(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFlareDelay(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getIdleAutoHeal(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getIdleAutoHeal(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToFly(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToFly(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTransportUnloadMethod(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTransportUnloadMethod(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getWindResourceGenerator(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0getWindResourceGenerator(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def isAbleToMove(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToMove(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTrackOffset(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTrackOffset(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getType(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getType(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getCobId(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getCobId(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getFlareEfficiency(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFlareEfficiency(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getSeismicRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getSeismicRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isNotTransportable(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isNotTransportable(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getResurrectSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getResurrectSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getHeight(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getHeight(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getWingAngle(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getWingAngle(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isPushResistant(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isPushResistant(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getBuildingDecalSizeY(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getBuildingDecalSizeY(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getBuildingDecalSizeX(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getBuildingDecalSizeX(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMinWaterDepth(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMinWaterDepth(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAirStrafe(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAirStrafe(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToSubmerge(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToSubmerge(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTrackStretch(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTrackStretch(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxDeceleration(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxDeceleration(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getDeathExplosion(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getDeathExplosion(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getIdleTime(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getIdleTime(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getWingDrag(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getWingDrag(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isTargetingFacility(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isTargetingFacility(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isStartCloaked(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isStartCloaked(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToHover(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToHover(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxRudder(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxRudder(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTechLevel(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTechLevel(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getLoadingRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getLoadingRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToCloak(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToCloak(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxThisUnit(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxThisUnit(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTrackType(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTrackType(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isNeedGeo(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isNeedGeo(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isCommander(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isCommander(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAirBase(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAirBase(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToLoopbackAttack(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToLoopbackAttack(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isLeaveTracks(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isLeaveTracks(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isCapturable(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isCapturable(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getBuildOptions(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0ARRAY1VALS1UnitDef0getBuildOptions(teamModule._currentTeam.teamId,unitDefId,None, teamModule._currentTeam.callback.Clb_UnitDef_0ARRAY1SIZE1UnitDef0getBuildOptions(teamModule._currentTeam.teamId,unitDefId))


	@staticmethod
	def getFlareSalvoDelay(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFlareSalvoDelay(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToGuard(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToGuard(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getSelfDCountdown(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getSelfDCountdown(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMoveState(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMoveState(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToCapture(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToCapture(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isUseBuildingGroundDecal(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isUseBuildingGroundDecal(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxBank(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxBank(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getBuildSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getBuildSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTurnInPlaceSpeedLimit(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTurnInPlaceSpeedLimit(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS0UnitDef(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE0UnitDef(teamModule._currentTeam.teamId))


	@staticmethod
	def getBuildingDecalDecaySpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getBuildingDecalDecaySpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getArmorType(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getArmorType(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isOnOffable(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isOnOffable(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxSlope(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxSlope(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getHealth(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getHealth(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getFrontToSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFrontToSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToReclaim(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToReclaim(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isLevelGround(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isLevelGround(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxPitch(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxPitch(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getWreckName(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getWreckName(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getUnitFallSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getUnitFallSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getSonarJamRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getSonarJamRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getBuildTime(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getBuildTime(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getCustomParams():
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		vals = teamModule._currentTeam.callback.Clb_UnitDef_0MAP1VALS0getCustomParams(teamModule._currentTeam.teamId,unitDefId)
		keys = teamModule._currentTeam.callback.Clb_UnitDef_0MAP1KEYS0getCustomParams(teamModule._currentTeam.teamId,unitDefId)
		return dict(dict_helper(vals, keys))



	@staticmethod
	def isActivateWhenBuilt(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isActivateWhenBuilt(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToPatrol(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToPatrol(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMinTransportSize(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMinTransportSize(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToRestore(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToRestore(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isHoverAttack(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isHoverAttack(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getGaia(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getGaia(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMass(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMass(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTidalResourceGenerator(unitDefId,resourceId):
		"""The arguments are:
	unitDefId: int
	resourceId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0REF1Resource2resourceId0getTidalResourceGenerator(teamModule._currentTeam.teamId,unitDefId,resourceId)


	@staticmethod
	def isBuilder(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isBuilder(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTransportMass(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTransportMass(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxAileron(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxAileron(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getControlRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getControlRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxWaterDepth(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxWaterDepth(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTrackStrength(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTrackStrength(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getTerraformSpeed(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getTerraformSpeed(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToFireControl(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToFireControl(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToSelfD(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToSelfD(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isUpright(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isUpright(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isBuildRange3D(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isBuildRange3D(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isFirePlatform(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isFirePlatform(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getBuildAngle(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getBuildAngle(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToDropFlare(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToDropFlare(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isFactoryHeadingTakeoff(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isFactoryHeadingTakeoff(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getStockpileDef(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getStockpileDef(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isAbleToResurrect(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isAbleToResurrect(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getFileName(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFileName(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getRadius(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getRadius(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getFlareSalvoSize(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getFlareSalvoSize(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def isDecloakSpherical(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_isDecloakSpherical(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getMaxFuel(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getMaxFuel(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getSlideTolerance(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getSlideTolerance(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getKamikazeDist(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_getKamikazeDist(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def getShieldDef(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getShieldDef(teamModule._currentTeam.teamId,unitDefId)


	@staticmethod
	def WeaponMount(unitDefId):
		"""The arguments are:
	unitDefId: int
"""
		assert isinstance(unitDefId, (int, long))
		unitDefId=int(unitDefId)
		return teamModule._currentTeam.callback.Clb_UnitDef_0MULTI1SIZE0WeaponMount(teamModule._currentTeam.teamId,unitDefId)




class Drawer(object):

	@staticmethod
	def isEnabled():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Debug_Drawer_isEnabled(teamModule._currentTeam.teamId)




class Cheats(object):

	@staticmethod
	def isEnabled():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Cheats_isEnabled(teamModule._currentTeam.teamId)


	@staticmethod
	def setEnabled(enable):
		"""The arguments are:
	enable: bool
"""
		assert isinstance(enable, int)
		return teamModule._currentTeam.callback.Clb_Cheats_setEnabled(teamModule._currentTeam.teamId,enable)


	@staticmethod
	def isOnlyPassive():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Cheats_isOnlyPassive(teamModule._currentTeam.teamId)


	@staticmethod
	def setEventsEnabled(enabled):
		"""The arguments are:
	enabled: bool
"""
		assert isinstance(enabled, int)
		return teamModule._currentTeam.callback.Clb_Cheats_setEventsEnabled(teamModule._currentTeam.teamId,enabled)




class Version(object):

	@staticmethod
	def getMinor():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Engine_Version_getMinor(teamModule._currentTeam.teamId)


	@staticmethod
	def getPatchset():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Engine_Version_getPatchset(teamModule._currentTeam.teamId)


	@staticmethod
	def getMajor():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Engine_Version_getMajor(teamModule._currentTeam.teamId)


	@staticmethod
	def getNormal():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Engine_Version_getNormal(teamModule._currentTeam.teamId)


	@staticmethod
	def getFull():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Engine_Version_getFull(teamModule._currentTeam.teamId)


	@staticmethod
	def getAdditional():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Engine_Version_getAdditional(teamModule._currentTeam.teamId)


	@staticmethod
	def getBuildTime():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Engine_Version_getBuildTime(teamModule._currentTeam.teamId)




class Engine(object):

	@staticmethod
	def handleCommand(toId,commandId,commandTopic,commandData):
		"""This function should not be used directly. Use the Command class instead. If you want to use this function directly, see the command class implementation for documentation."""
		assert isinstance(toId, (int, long))
		toId=int(toId)
		assert isinstance(commandId, (int, long))
		commandId=int(commandId)
		assert isinstance(commandTopic, (int, long))
		commandTopic=int(commandTopic)
		return teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId,toId,commandId,commandTopic,commandData)




class Roots(object):

	@staticmethod
	def locatePath(path,path_sizeMax,relPath,writeable,create,dir):
		"""The arguments are:
	path: string
	path_sizeMax: int
	relPath: string
	writeable: bool
	create: bool
	dir: bool
"""
		assert isinstance(path, str)
		assert isinstance(path_sizeMax, (int, long))
		path_sizeMax=int(path_sizeMax)
		assert isinstance(relPath, str)
		assert isinstance(writeable, int)
		assert isinstance(create, int)
		assert isinstance(dir, int)
		return teamModule._currentTeam.callback.Clb_DataDirs_Roots_locatePath(teamModule._currentTeam.teamId,path,path_sizeMax,relPath,writeable,create,dir)


	@staticmethod
	def allocatePath(relPath,writeable,create,dir):
		"""The arguments are:
	relPath: string
	writeable: bool
	create: bool
	dir: bool
"""
		assert isinstance(relPath, str)
		assert isinstance(writeable, int)
		assert isinstance(create, int)
		assert isinstance(dir, int)
		return teamModule._currentTeam.callback.Clb_DataDirs_Roots_allocatePath(teamModule._currentTeam.teamId,relPath,writeable,create,dir)


	@staticmethod
	def getSize():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_DataDirs_Roots_getSize(teamModule._currentTeam.teamId)


	@staticmethod
	def getDir(path,path_sizeMax,dirIndex):
		"""The arguments are:
	path: string
	path_sizeMax: int
	dirIndex: int
"""
		assert isinstance(path, str)
		assert isinstance(path_sizeMax, (int, long))
		path_sizeMax=int(path_sizeMax)
		assert isinstance(dirIndex, (int, long))
		dirIndex=int(dirIndex)
		return teamModule._currentTeam.callback.Clb_DataDirs_Roots_getDir(teamModule._currentTeam.teamId,path,path_sizeMax,dirIndex)




class File(object):

	@staticmethod
	def getContent(fileName,buffer,bufferLen):
		"""This function should not be used directly. Use the Command class instead. If you want to use this function directly, see the command class implementation for documentation."""
		assert isinstance(fileName, str)
		return teamModule._currentTeam.callback.Clb_File_getContent(teamModule._currentTeam.teamId,fileName,buffer,bufferLen)


	@staticmethod
	def getSize(fileName):
		"""The arguments are:
	fileName: string
"""
		assert isinstance(fileName, str)
		return teamModule._currentTeam.callback.Clb_File_getSize(teamModule._currentTeam.teamId,fileName)




class Unit(object):

	@staticmethod
	def getPower(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getPower(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getLineage(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getLineage(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def isParalyzed(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_isParalyzed(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getStockpileQueued(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getStockpileQueued(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getLastUserOrderFrame(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getLastUserOrderFrame(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getGroup(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getGroup(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getTeam(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getTeam(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getExperience(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getExperience(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getSpeed(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getSpeed(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3NeutralUnits0Unit(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3NeutralUnits0Unit(teamModule._currentTeam.teamId))


	@staticmethod
	def getMaxHealth(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getMaxHealth(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getMaxRange(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getMaxRange(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getVel(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getVel(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def isNeutral(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_isNeutral(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getResourceMake(unitId,resourceId):
		"""The arguments are:
	unitId: int
	resourceId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Unit_0REF1Resource2resourceId0getResourceMake(teamModule._currentTeam.teamId,unitId,resourceId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3SelectedUnits0Unit(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3SelectedUnits0Unit(teamModule._currentTeam.teamId))


	@staticmethod
	def ModParam(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_0MULTI1SIZE0ModParam(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getCurrentFuel(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getCurrentFuel(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getAiHint(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getAiHint(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3EnemyUnitsInRadarAndLos0Unit(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3EnemyUnitsInRadarAndLos0Unit(teamModule._currentTeam.teamId))


	@staticmethod
	def getLimit():
		"""no arguments"""
		return teamModule._currentTeam.callback.Clb_Unit_0STATIC0getLimit(teamModule._currentTeam.teamId)


	@staticmethod
	def Ids(pos,radius):
		"""The arguments are:
	pos: (float, float, float)
	radius: float
"""
		check_float3(pos)
		assert isinstance(radius, float)
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3NeutralUnitsIn0Unit(teamModule._currentTeam.teamId,pos,radius,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3NeutralUnitsIn0Unit(teamModule._currentTeam.teamId,pos,radius))


	@staticmethod
	def getResourceUse(unitId,resourceId):
		"""The arguments are:
	unitId: int
	resourceId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(resourceId, (int, long))
		resourceId=int(resourceId)
		return teamModule._currentTeam.callback.Clb_Unit_0REF1Resource2resourceId0getResourceUse(teamModule._currentTeam.teamId,unitId,resourceId)


	@staticmethod
	def getPos(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getPos(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def isCloaked(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_isCloaked(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3EnemyUnits0Unit(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3EnemyUnits0Unit(teamModule._currentTeam.teamId))


	@staticmethod
	def isActivated(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_isActivated(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getAllyTeam(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getAllyTeam(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def CurrentCommand(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_0MULTI1SIZE1Command0CurrentCommand(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def SupportedCommand(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_0MULTI1SIZE0SupportedCommand(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def isBeingBuilt(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_isBeingBuilt(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3TeamUnits0Unit(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3TeamUnits0Unit(teamModule._currentTeam.teamId))


	@staticmethod
	def getStockpile(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getStockpile(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def Ids(pos,radius):
		"""The arguments are:
	pos: (float, float, float)
	radius: float
"""
		check_float3(pos)
		assert isinstance(radius, float)
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3EnemyUnitsIn0Unit(teamModule._currentTeam.teamId,pos,radius,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3EnemyUnitsIn0Unit(teamModule._currentTeam.teamId,pos,radius))


	@staticmethod
	def getMaxSpeed(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getMaxSpeed(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def Ids():
		"""The arguments are:
"""
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3FriendlyUnits0Unit(teamModule._currentTeam.teamId,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3FriendlyUnits0Unit(teamModule._currentTeam.teamId))


	@staticmethod
	def getBuildingFacing(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getBuildingFacing(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def Ids(pos,radius):
		"""The arguments are:
	pos: (float, float, float)
	radius: float
"""
		check_float3(pos)
		assert isinstance(radius, float)
		return teamModule._currentTeam.callback.Clb_0MULTI1VALS3FriendlyUnitsIn0Unit(teamModule._currentTeam.teamId,pos,radius,None, teamModule._currentTeam.callback.Clb_0MULTI1SIZE3FriendlyUnitsIn0Unit(teamModule._currentTeam.teamId,pos,radius))


	@staticmethod
	def ResourceInfo(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_0MULTI1SIZE0ResourceInfo(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getHealth(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_getHealth(teamModule._currentTeam.teamId,unitId)


	@staticmethod
	def getDef(unitId):
		"""The arguments are:
	unitId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		return teamModule._currentTeam.callback.Clb_Unit_0SINGLE1FETCH2UnitDef0getDef(teamModule._currentTeam.teamId,unitId)




class ModParam(object):

	@staticmethod
	def getValue(unitId,modParamId):
		"""The arguments are:
	unitId: int
	modParamId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(modParamId, (int, long))
		modParamId=int(modParamId)
		return teamModule._currentTeam.callback.Clb_Unit_ModParam_getValue(teamModule._currentTeam.teamId,unitId,modParamId)


	@staticmethod
	def getName(unitId,modParamId):
		"""The arguments are:
	unitId: int
	modParamId: int
"""
		assert isinstance(unitId, (int, long))
		unitId=int(unitId)
		assert isinstance(modParamId, (int, long))
		modParamId=int(modParamId)
		return teamModule._currentTeam.callback.Clb_Unit_ModParam_getName(teamModule._currentTeam.teamId,unitId,modParamId)





class Command(object):
	id = 0

	@staticmethod
	def timeWaitUnit(unitId,groupId,options,timeOut,time):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"time":time}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_WAIT_TIME,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setBaseUnit(unitId,groupId,options,timeOut,basePos):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"basePos":basePos}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SET_BASE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def giveMeResourceCheat(resourceId,amount):
		data = {"resourceId":resourceId,"amount":amount}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_CHEATS_GIVE_ME_RESOURCE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def cloakUnit(unitId,groupId,options,timeOut,cloak):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"cloak":cloak}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_CLOAK,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def moveUnit(unitId,groupId,options,timeOut,toPos):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toPos":toPos}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_MOVE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def drawLineAndIconPathDrawer(cmdId,endPos,color,alpha):
		data = {"cmdId":cmdId,"endPos":endPos,"color":color,"alpha":alpha}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_PATH_DRAW_LINE_AND_ICON,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def unloadUnit(unitId,groupId,options,timeOut,toPos,toUnloadUnitId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toPos":toPos,"toUnloadUnitId":toUnloadUnitId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_UNLOAD_UNIT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def giveMeNewUnitCheat(unitDefId,pos):
		data = {"unitDefId":unitDefId,"pos":pos,"ret_newUnitId":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_CHEATS_GIVE_ME_NEW_UNIT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def pause(enable,reason):
		data = {"enable":enable,"reason":reason}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_PAUSE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setFireStateUnit(unitId,groupId,options,timeOut,fireState):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"fireState":fireState}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SET_FIRE_STATE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerAddGraphPoint(x,y,lineId):
		data = {"x":x,"y":y,"lineId":lineId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_ADD_GRAPH_POINT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def captureAreaUnit(unitId,groupId,options,timeOut,pos,radius):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"pos":pos,"radius":radius}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_CAPTURE_AREA,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerSetOverlayTexturePos(texHandle,x,y):
		data = {"texHandle":texHandle,"x":x,"y":y}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_SET_OVERLAY_TEXTURE_POS,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerUpdateOverlayTexture(texHandle,texData,x,y,w,h):
		data = {"texHandle":texHandle,"texData":texData,"x":x,"y":y,"w":w,"h":h}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_UPDATE_OVERLAY_TEXTURE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def repairUnit(unitId,groupId,options,timeOut,toRepairUnitId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toRepairUnitId":toRepairUnitId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_REPAIR,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerSetGraphSize(w,h):
		data = {"w":w,"h":h}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_SET_GRAPH_SIZE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def createLineFigureDrawer(pos1,pos2,width,arrow,lifeTime,figureGroupId):
		data = {"pos1":pos1,"pos2":pos2,"width":width,"arrow":arrow,"lifeTime":lifeTime,"figureGroupId":figureGroupId,"ret_newFigureGroupId":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_FIGURE_CREATE_LINE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerDelOverlayTexture(texHandle):
		data = {"texHandle":texHandle}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_DEL_OVERLAY_TEXTURE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def createSplineFigureDrawer(pos1,pos2,pos3,pos4,width,arrow,lifeTime,figureGroupId):
		data = {"pos1":pos1,"pos2":pos2,"pos3":pos3,"pos4":pos4,"width":width,"arrow":arrow,"lifeTime":lifeTime,"figureGroupId":figureGroupId,"ret_newFigureGroupId":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_FIGURE_CREATE_SPLINE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def gatherWaitUnit(unitId,groupId,options,timeOut):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_WAIT_GATHER,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setTrajectoryUnit(unitId,groupId,options,timeOut,trajectory):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"trajectory":trajectory}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SET_TRAJECTORY,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def sendStartPos(ready,pos):
		data = {"ready":ready,"pos":pos}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_SEND_START_POS,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def selfDestroyUnit(unitId,groupId,options,timeOut):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SELF_DESTROY,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def fightUnit(unitId,groupId,options,timeOut,toPos):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toPos":toPos}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_FIGHT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def sendTextMessage(text,zone):
		data = {"text":text,"zone":zone}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_SEND_TEXT_MESSAGE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def attackUnit(unitId,groupId,options,timeOut,toAttackUnitId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toAttackUnitId":toAttackUnitId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_ATTACK,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def breakPathDrawer(endPos,color,alpha):
		data = {"endPos":endPos,"color":color,"alpha":alpha}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_PATH_BREAK,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def resurrectUnit(unitId,groupId,options,timeOut,toResurrectFeatureId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toResurrectFeatureId":toResurrectFeatureId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_RESURRECT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerSetGraphPosition(x,y):
		data = {"x":x,"y":y}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_SET_GRAPH_POS,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setMyHandicapCheat(handicap):
		data = {"handicap":handicap}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_CHEATS_SET_MY_HANDICAP,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def sendUnits(unitIds,numUnitIds,receivingTeam):
		data = {"unitIds":unitIds,"numUnitIds":numUnitIds,"receivingTeam":receivingTeam,"ret_sentUnits":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_SEND_UNITS,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def drawUnitDrawer(toDrawUnitDefId,pos,rotation,lifeTime,teamId,transparent,drawBorder,facing):
		data = {"toDrawUnitDefId":toDrawUnitDefId,"pos":pos,"rotation":rotation,"lifeTime":lifeTime,"teamId":teamId,"transparent":transparent,"drawBorder":drawBorder,"facing":facing}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_DRAW_UNIT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def startPathDrawer(pos,color,alpha):
		data = {"pos":pos,"color":color,"alpha":alpha}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_PATH_START,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def attackAreaUnit(unitId,groupId,options,timeOut,toAttackPos,radius):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toAttackPos":toAttackPos,"radius":radius}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_ATTACK_AREA,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def reclaimUnit(unitId,groupId,options,timeOut,toReclaimUnitIdOrFeatureId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toReclaimUnitIdOrFeatureId":toReclaimUnitIdOrFeatureId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_RECLAIM,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def resurrectAreaUnit(unitId,groupId,options,timeOut,pos,radius):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"pos":pos,"radius":radius}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_RESURRECT_AREA,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def loadOntoUnit(unitId,groupId,options,timeOut,transporterUnitId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"transporterUnitId":transporterUnitId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_LOAD_ONTO,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def getApproximateLengthPath(start,end,pathType,goalRadius):
		data = {"start":start,"end":end,"pathType":pathType,"goalRadius":goalRadius,"ret_approximatePathLength":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_PATH_GET_APPROXIMATE_LENGTH,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def drawIconAtLastPosPathDrawer(cmdId):
		data = {"cmdId":cmdId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_PATH_DRAW_ICON_AT_LAST_POS,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setColorFigureDrawer(figureGroupId,color,alpha):
		data = {"figureGroupId":figureGroupId,"color":color,"alpha":alpha}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_FIGURE_SET_COLOR,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def removePointDraw(pos):
		data = {"pos":pos}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_POINT_REMOVE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def captureUnit(unitId,groupId,options,timeOut,toCaptureUnitId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toCaptureUnitId":toCaptureUnitId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_CAPTURE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def aiSelectUnit(unitId,groupId,options,timeOut):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_AI_SELECT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def reclaimAreaUnit(unitId,groupId,options,timeOut,pos,radius):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"pos":pos,"radius":radius}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_RECLAIM_AREA,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def buildUnit(unitId,groupId,options,timeOut,toBuildUnitDefId,buildPos,facing):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toBuildUnitDefId":toBuildUnitDefId,"buildPos":buildPos,"facing":facing}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_BUILD,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def finishPathDrawer():
		data = {}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_PATH_FINISH,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerDeleteGraphPoints(lineId,numPoints):
		data = {"lineId":lineId,"numPoints":numPoints}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_DELETE_GRAPH_POINTS,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def loadUnitsUnit(unitId,groupId,options,timeOut,toLoadUnitIds,numToLoadUnits):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toLoadUnitIds":toLoadUnitIds,"numToLoadUnits":numToLoadUnits}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_LOAD_UNITS,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def addPointDraw(pos,label):
		data = {"pos":pos,"label":label}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_POINT_ADD,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerSetGraphLineLabel(lineId,label):
		data = {"lineId":lineId,"label":label}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_SET_GRAPH_LINE_LABEL,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def eraseGroup(groupId):
		data = {"groupId":groupId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_GROUP_ERASE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def getNextWaypointPath(pathId):
		data = {"pathId":pathId,"ret_nextWaypoint":(0,0,0)}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_PATH_GET_NEXT_WAYPOINT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def deleteFigureDrawer(figureGroupId):
		data = {"figureGroupId":figureGroupId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_FIGURE_DELETE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def addLineDraw(posFrom,posTo):
		data = {"posFrom":posFrom,"posTo":posTo}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_LINE_ADD,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def restoreAreaUnit(unitId,groupId,options,timeOut,pos,radius):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"pos":pos,"radius":radius}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_RESTORE_AREA,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def guardUnit(unitId,groupId,options,timeOut,toGuardUnitId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toGuardUnitId":toGuardUnitId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_GUARD,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def stockpileUnit(unitId,groupId,options,timeOut):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_STOCKPILE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def dGunUnit(unitId,groupId,options,timeOut,toAttackUnitId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toAttackUnitId":toAttackUnitId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_D_GUN,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def loadUnitsAreaUnit(unitId,groupId,options,timeOut,pos,radius):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"pos":pos,"radius":radius}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_LOAD_UNITS_AREA,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def dGunPosUnit(unitId,groupId,options,timeOut,pos):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"pos":pos}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_D_GUN_POS,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def customUnit(unitId,groupId,options,timeOut,cmdId,params,numParams):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"cmdId":cmdId,"params":params,"numParams":numParams}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_CUSTOM,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def restartPathDrawer(sameColor):
		data = {"sameColor":sameColor}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_PATH_RESTART,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerSetOverlayTextureSize(texHandle,w,h):
		data = {"texHandle":texHandle,"w":w,"h":h}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_SET_OVERLAY_TEXTURE_SIZE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def squadWaitUnit(unitId,groupId,options,timeOut,numUnits):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"numUnits":numUnits}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_WAIT_SQUAD,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setLastPosMessage(pos):
		data = {"pos":pos}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_SET_LAST_POS_MESSAGE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def unloadUnitsAreaUnit(unitId,groupId,options,timeOut,toPos,radius):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toPos":toPos,"radius":radius}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_UNLOAD_UNITS_AREA,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def groupClearUnit(unitId,groupId,options,timeOut):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_GROUP_CLEAR,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerSetGraphLineColor(lineId,color):
		data = {"lineId":lineId,"color":color}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_SET_GRAPH_LINE_COLOR,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def traceRay(rayPos,rayDir,rayLen,srcUID,hitUID,flags):
		data = {"rayPos":rayPos,"rayDir":rayDir,"rayLen":rayLen,"srcUID":srcUID,"hitUID":hitUID,"flags":flags}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_TRACE_RAY,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def addNotificationDrawer(pos,color,alpha):
		data = {"pos":pos,"color":color,"alpha":alpha}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_ADD_NOTIFICATION,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def deathWaitUnit(unitId,groupId,options,timeOut,toDieUnitId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toDieUnitId":toDieUnitId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_WAIT_DEATH,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setIdleModeUnit(unitId,groupId,options,timeOut,idleMode):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"idleMode":idleMode}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SET_IDLE_MODE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setRepeatUnit(unitId,groupId,options,timeOut,repeat):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"repeat":repeat}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SET_REPEAT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def sendResources(resourceId,amount,receivingTeam):
		data = {"resourceId":resourceId,"amount":amount,"receivingTeam":receivingTeam,"ret_isExecuted":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_SEND_RESOURCES,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerSetOverlayTextureLabel(texHandle,label):
		data = {"texHandle":texHandle,"label":label}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_SET_OVERLAY_TEXTURE_LABEL,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setWantedMaxSpeedUnit(unitId,groupId,options,timeOut,wantedMaxSpeed):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"wantedMaxSpeed":wantedMaxSpeed}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SET_WANTED_MAX_SPEED,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def initPath(start,end,pathType,goalRadius):
		data = {"start":start,"end":end,"pathType":pathType,"goalRadius":goalRadius,"ret_pathId":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_PATH_INIT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def removeUnitFromGroup(unitId):
		data = {"unitId":unitId,"ret_isExecuted":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_GROUP_REMOVE_UNIT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def drawLinePathDrawer(endPos,color,alpha):
		data = {"endPos":endPos,"color":color,"alpha":alpha}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DRAWER_PATH_DRAW_LINE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def addUnitToGroup(groupId,unitId):
		data = {"groupId":groupId,"unitId":unitId,"ret_isExecuted":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_GROUP_ADD_UNIT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setOnOffUnit(unitId,groupId,options,timeOut,on):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"on":on}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SET_ON_OFF,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def debugDrawerAddOverlayTexture(texHandle,texData,w,h):
		data = {"texHandle":texHandle,"texData":texData,"w":w,"h":h}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_DEBUG_DRAWER_ADD_OVERLAY_TEXTURE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def groupAddUnit(unitId,groupId,options,timeOut,toGroupId):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toGroupId":toGroupId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_GROUP_ADD,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def freePath(pathId):
		data = {"pathId":pathId}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_PATH_FREE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def waitUnit(unitId,groupId,options,timeOut):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_WAIT,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def stopUnit(unitId,groupId,options,timeOut):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_STOP,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setAutoRepairLevelUnit(unitId,groupId,options,timeOut,autoRepairLevel):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"autoRepairLevel":autoRepairLevel}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SET_AUTO_REPAIR_LEVEL,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def createGroup():
		data = {"ret_groupId":0}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_GROUP_CREATE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def setMoveStateUnit(unitId,groupId,options,timeOut,moveState):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"moveState":moveState}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_SET_MOVE_STATE,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def patrolUnit(unitId,groupId,options,timeOut,toPos):
		data = {"unitId":unitId,"groupId":groupId,"options":options,"timeOut":timeOut,"toPos":toPos}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_UNIT_PATROL,data)
		if retval:
			return Command.id, retval
		return Command.id


	@staticmethod
	def callLuaRules(data,inSize,outSize):
		data = {"data":data,"inSize":inSize,"outSize":outSize}
		Command.id+=1
		retval = teamModule._currentTeam.callback.Clb_Engine_handleCommand(teamModule._currentTeam.teamId, -1, Command.id,COMMAND_CALL_LUA_RULES,data)
		if retval:
			return Command.id, retval
		return Command.id




# hard coded variables
UNIT_COMMAND_OPTION_DONT_REPEAT       = (1 << 3)
UNIT_COMMAND_OPTION_RIGHT_MOUSE_KEY   = (1 << 4)
UNIT_COMMAND_OPTION_SHIFT_KEY         = (1 << 5)
UNIT_COMMAND_OPTION_CONTROL_KEY       = (1 << 6)
UNIT_COMMAND_OPTION_ALT_KEY           = (1 << 7)
