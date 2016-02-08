/*
	Copyright (c) 2010 Matthias Ableitner <spam@abma.de>

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

	@author Andreas Löscher
	@author Matthias Ableitner <spam@abma.de>
*/


/* This file was generated 2016-2-8 10:10:57 */

#undef _DEBUG /* Link with python24.lib and not python24_d.lib */
#include <Python.h>
#include "ai.h"


#include "CUtils/SimpleLog.h"
#include "CUtils/SharedLibrary.h"

#include "ExternalAI/Interface/AISCommands.h"
#include "ExternalAI/Interface/SAIFloat3.h"
#include "ExternalAI/Interface/AISEvents.h"
#include "ExternalAI/Interface/SSkirmishAICallback.h"

#include "InterfaceDefines.h"
#include "InterfaceExport.h"

PyObject* PyAICallback_New(const struct SSkirmishAICallback* callback);


// Python functions pointers
void*  (*PYDICT_GETITEMSTRING)(void*, const char*)=NULL;
void*  (*PY_BUILDVALUE)(char*, ...)=NULL;
int    (*PYDICT_SETITEM)(void*, void*, void*)=NULL;
void   (*PYERR_PRINT)(void)=NULL;
double (*PYFLOAT_ASDOUBLE)(void*)=NULL;
void*  (*PYFLOAT_FROMDOUBLE)(double)=NULL;
void*  (*PYIMPORT_IMPORT)(void*)=NULL;
void*  (*PYINT_FROMLONG)(long)=NULL;
int    (*PYLIST_APPEND)(void *, void*)=NULL;
void*  (*PYLIST_GETITEM)(void *,Py_ssize_t)=NULL;
void*  (*PYLIST_NEW)(Py_ssize_t)=NULL;
int    (*PYLIST_SETITEM)(void*, Py_ssize_t, void*)=NULL;
void*  (*PYOBJECT_CALLOBJECT)(void*, void*)=NULL;
void*  (*PYOBJECT_GETATTRSTRING)(void*, const char*)=NULL;
void*  (*PYSTRING_FROMSTRING)(const char*)=NULL;
void*  (*PYTUPLE_GETITEM)(void*, Py_ssize_t)=NULL;
int    (*PYTYPE_READY)(void*)=NULL;
void   (*PY_FINALIZE)(void)=NULL;
const char* (*PY_GETVERSION)(void)=NULL;
void   (*PY_INITIALIZE)(void)=NULL;
PyObject *_PY_NONESTRUCT=NULL;


void* findAddressEx(void *handle, const char *name){
	void* res;
	res=sharedLib_findAddress(handle, name);
	if (res==NULL)
		simpleLog_log("Unable to find adress for %s %p",name, handle);
	return res;
}

void
bindPythonFunctions(void *hPython)
{
	PYDICT_GETITEMSTRING=findAddressEx(hPython, "PyDict_GetItemString");
	PY_BUILDVALUE=findAddressEx(hPython, "Py_BuildValue");
	PYDICT_SETITEM=findAddressEx(hPython, "PyDict_SetItem");
	PYERR_PRINT=findAddressEx(hPython, "PyErr_Print");
	PYFLOAT_ASDOUBLE=findAddressEx(hPython, "PyFloat_AsDouble");
	PYFLOAT_FROMDOUBLE=findAddressEx(hPython, "PyFloat_FromDouble");
	PYIMPORT_IMPORT=findAddressEx(hPython, "PyImport_Import");
	PYINT_FROMLONG=findAddressEx(hPython, "PyLong_FromLong");
	PYLIST_APPEND=findAddressEx(hPython, "PyList_Append");
	PYLIST_GETITEM=findAddressEx(hPython, "PyList_GetItem");
	PYLIST_NEW=findAddressEx(hPython, "PyList_New");
	PYLIST_SETITEM=findAddressEx(hPython, "PyList_SetItem");
	PYOBJECT_CALLOBJECT=findAddressEx(hPython, "PyObject_CallObject");
	PYOBJECT_GETATTRSTRING=findAddressEx(hPython, "PyObject_GetAttrString");
	PYSTRING_FROMSTRING=findAddressEx(hPython, "PyString_FromString");
	PYTUPLE_GETITEM=findAddressEx(hPython, "PyTuple_GetItem");
	PYTYPE_READY=findAddressEx(hPython, "PyType_Ready");
	PY_FINALIZE=findAddressEx(hPython, "Py_Finalize");
	PY_GETVERSION=findAddressEx(hPython, "Py_GetVersion");
	PY_INITIALIZE=findAddressEx(hPython, "Py_Initialize");
	_PY_NONESTRUCT=findAddressEx(hPython, "_Py_NoneStruct");

	if (PYSTRING_FROMSTRING==NULL) //Python 3
		PYSTRING_FROMSTRING=findAddressEx(hPython, "PyUnicode_InternFromString");

}

//Python functions
#define PyDict_GetItemString   PYDICT_GETITEMSTRING
#define Py_BuildValue          PY_BUILDVALUE
#define PyDict_SetItem         PYDICT_SETITEM
#define PyErr_Print            PYERR_PRINT
#define PyFloat_AsDouble       PYFLOAT_ASDOUBLE
#define PyFloat_FromDouble     PYFLOAT_FROMDOUBLE
#define PyImport_Import        PYIMPORT_IMPORT
#define PyInt_FromLong         PYINT_FROMLONG
#define PyList_Append          PYLIST_APPEND
#define PyList_GetItem         PYLIST_GETITEM
#define PyList_New             PYLIST_NEW
#define PyList_SetItem         PYLIST_SETITEM
#define PyObject_CallObject    PYOBJECT_CALLOBJECT
#define PyObject_GetAttrString PYOBJECT_GETATTRSTRING
#define PyString_FromString    PYSTRING_FROMSTRING
#define PyTuple_GetItem        PYTUPLE_GETITEM
#define PyType_Ready           PYTYPE_READY
#define Py_Finalize            PY_FINALIZE
#define Py_GetVersion          PY_GETVERSION
#define Py_Initialize          PY_INITIALIZE
#undef Py_None
#define Py_None		       _PY_NONESTRUCT



	static int*
build_intarray(PyObject* list)
{
  Py_ssize_t n=PyList_GET_SIZE(list);
  int* array=malloc(sizeof(int)*(long)n);
  Py_ssize_t i;
  for (i=0;i<n;i++)
  {
    array[i]=(int)PyInt_AS_LONG(PyList_GetItem(list, i));
  }
  return array;
}

static PyObject* 
convert_SAIFloat3(struct SAIFloat3* value)
{
  return Py_BuildValue("(fff)", value->x,
                                value->y,
                                value->z);
}

static PyObject*
convert_intarray(int* unitIds, int numUnitIds)
{
  int i;
  PyObject* list=PyList_New(numUnitIds);
  for (i=0;i<numUnitIds;i++)
  {
    PyList_SetItem(list, i, PyInt_FromLong((long)unitIds[i]));
  }
  return list;
}



	static PyObject* 
event_convert(int topic, void* data)
{
  switch (topic) {
    
    case EVENT_UNIT_IDLE:
      return Py_BuildValue("{si}","unit",((struct SUnitIdleEvent*)data)->unit);
    
    case EVENT_ENEMY_ENTER_LOS:
      return Py_BuildValue("{si}","enemy",((struct SEnemyEnterLOSEvent*)data)->enemy);
    
    case EVENT_UNIT_CREATED:
      return Py_BuildValue("{sisi}","unit",((struct SUnitCreatedEvent*)data)->unit,"builder",((struct SUnitCreatedEvent*)data)->builder);
    
    case EVENT_UNIT_GIVEN:
      return Py_BuildValue("{sisisi}","unitId",((struct SUnitGivenEvent*)data)->unitId,"oldTeamId",((struct SUnitGivenEvent*)data)->oldTeamId,"newTeamId",((struct SUnitGivenEvent*)data)->newTeamId);
    
    case EVENT_SAVE:
      return Py_BuildValue("{ss}","file",((struct SSaveEvent*)data)->file);
    
    case EVENT_ENEMY_LEAVE_LOS:
      return Py_BuildValue("{si}","enemy",((struct SEnemyLeaveLOSEvent*)data)->enemy);
    
    case EVENT_RELEASE:
      return Py_BuildValue("{si}","reason",((struct SReleaseEvent*)data)->reason);
    
    case EVENT_PLAYER_COMMAND:
      return Py_BuildValue("{sOsisisi}","unitIds",convert_intarray(((struct SPlayerCommandEvent*)data)->unitIds, ((struct SPlayerCommandEvent*)data)->numUnitIds),"numUnitIds",((struct SPlayerCommandEvent*)data)->numUnitIds,"commandTopic",((struct SPlayerCommandEvent*)data)->commandTopic,"playerId",((struct SPlayerCommandEvent*)data)->playerId);
    
    case EVENT_UNIT_CAPTURED:
      return Py_BuildValue("{sisisi}","unitId",((struct SUnitCapturedEvent*)data)->unitId,"oldTeamId",((struct SUnitCapturedEvent*)data)->oldTeamId,"newTeamId",((struct SUnitCapturedEvent*)data)->newTeamId);
    
    case EVENT_ENEMY_CREATED:
      return Py_BuildValue("{si}","enemy",((struct SEnemyCreatedEvent*)data)->enemy);
    
    case EVENT_UNIT_FINISHED:
      return Py_BuildValue("{si}","unit",((struct SUnitFinishedEvent*)data)->unit);
    
    case EVENT_ENEMY_LEAVE_RADAR:
      return Py_BuildValue("{si}","enemy",((struct SEnemyLeaveRadarEvent*)data)->enemy);
    
    case EVENT_ENEMY_ENTER_RADAR:
      return Py_BuildValue("{si}","enemy",((struct SEnemyEnterRadarEvent*)data)->enemy);
    
    case EVENT_UPDATE:
      return Py_BuildValue("{si}","frame",((struct SUpdateEvent*)data)->frame);
    
    case EVENT_MESSAGE:
      return Py_BuildValue("{siss}","player",((struct SMessageEvent*)data)->player,"message",((struct SMessageEvent*)data)->message);
    
    case EVENT_UNIT_MOVE_FAILED:
      return Py_BuildValue("{si}","unit",((struct SUnitMoveFailedEvent*)data)->unit);
    
    case EVENT_LOAD:
      return Py_BuildValue("{ss}","file",((struct SLoadEvent*)data)->file);
    
    case EVENT_ENEMY_DAMAGED:
      return Py_BuildValue("{sisisfsOsisi}","enemy",((struct SEnemyDamagedEvent*)data)->enemy,"attacker",((struct SEnemyDamagedEvent*)data)->attacker,"damage",((struct SEnemyDamagedEvent*)data)->damage,"dir",convert_SAIFloat3(&(((struct SEnemyDamagedEvent*)data)->dir)),"weaponDefId",((struct SEnemyDamagedEvent*)data)->weaponDefId,"paralyzer",((struct SEnemyDamagedEvent*)data)->paralyzer);
    
    case EVENT_INIT:
      return Py_BuildValue("{sisO}","team",((struct SInitEvent*)data)->team,"callback",PyAICallback_New(((struct SInitEvent*)data)->callback));
    
    case EVENT_ENEMY_FINISHED:
      return Py_BuildValue("{si}","enemy",((struct SEnemyFinishedEvent*)data)->enemy);
    
    case EVENT_ENEMY_DESTROYED:
      return Py_BuildValue("{sisi}","enemy",((struct SEnemyDestroyedEvent*)data)->enemy,"attacker",((struct SEnemyDestroyedEvent*)data)->attacker);
    
    case EVENT_UNIT_DAMAGED:
      return Py_BuildValue("{sisisfsOsisi}","unit",((struct SUnitDamagedEvent*)data)->unit,"attacker",((struct SUnitDamagedEvent*)data)->attacker,"damage",((struct SUnitDamagedEvent*)data)->damage,"dir",convert_SAIFloat3(&(((struct SUnitDamagedEvent*)data)->dir)),"weaponDefId",((struct SUnitDamagedEvent*)data)->weaponDefId,"paralyzer",((struct SUnitDamagedEvent*)data)->paralyzer);
    
    case EVENT_UNIT_DESTROYED:
      return Py_BuildValue("{sisi}","unit",((struct SUnitDestroyedEvent*)data)->unit,"attacker",((struct SUnitDestroyedEvent*)data)->attacker);
    
    case EVENT_WEAPON_FIRED:
      return Py_BuildValue("{sisi}","unitId",((struct SWeaponFiredEvent*)data)->unitId,"weaponDefId",((struct SWeaponFiredEvent*)data)->weaponDefId);
    
    case EVENT_SEISMIC_PING:
      return Py_BuildValue("{sOsf}","pos",convert_SAIFloat3(&(((struct SSeismicPingEvent*)data)->pos)),"strength",((struct SSeismicPingEvent*)data)->strength);
    
    case EVENT_COMMAND_FINISHED:
      return Py_BuildValue("{sisisi}","unitId",((struct SCommandFinishedEvent*)data)->unitId,"commandId",((struct SCommandFinishedEvent*)data)->commandId,"commandTopicId",((struct SCommandFinishedEvent*)data)->commandTopicId);
    
  }
  return NULL;
}
/* End Event Wrapper */

	/* wrapper for command struct's */

static struct SAIFloat3*
build_SAIFloat3(PyObject* tpl)
{
	struct SAIFloat3* data=malloc(sizeof(struct SAIFloat3));
	data->x=PyFloat_AsDouble(PyTuple_GetItem(tpl, 0));
	data->y=PyFloat_AsDouble(PyTuple_GetItem(tpl, 1));
	data->z=PyFloat_AsDouble(PyTuple_GetItem(tpl, 2));
	return data;
}

void*
command_convert(int commandTopic, PyObject* command)
{
	void *data=NULL;
	switch (commandTopic) {
	
		case COMMAND_PATH_INIT:
		
		
        data = malloc(sizeof(struct SInitPathCommand));









        ((struct SInitPathCommand*)data)->start = *(build_SAIFloat3(PyDict_GetItemString(command, "start")));











        ((struct SInitPathCommand*)data)->end = *(build_SAIFloat3(PyDict_GetItemString(command, "end")));







        ((struct SInitPathCommand*)data)->pathType = PyInt_AS_LONG(PyDict_GetItemString(command, "pathType"));





















        ((struct SInitPathCommand*)data)->ret_pathId = PyInt_AS_LONG(PyDict_GetItemString(command, "ret_pathId"));







		break;
	
		case COMMAND_UNIT_BUILD:
		
		
        data = malloc(sizeof(struct SBuildUnitCommand));





        ((struct SBuildUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SBuildUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SBuildUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SBuildUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SBuildUnitCommand*)data)->toBuildUnitDefId = PyInt_AS_LONG(PyDict_GetItemString(command, "toBuildUnitDefId"));















        ((struct SBuildUnitCommand*)data)->buildPos = *(build_SAIFloat3(PyDict_GetItemString(command, "buildPos")));







        ((struct SBuildUnitCommand*)data)->facing = PyInt_AS_LONG(PyDict_GetItemString(command, "facing"));







		break;
	
		case COMMAND_UNIT_MOVE:
		
		
        data = malloc(sizeof(struct SMoveUnitCommand));





        ((struct SMoveUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SMoveUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SMoveUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SMoveUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SMoveUnitCommand*)data)->toPos = *(build_SAIFloat3(PyDict_GetItemString(command, "toPos")));



		break;
	
		case COMMAND_DEBUG_DRAWER_SET_GRAPH_LINE_COLOR:
		
		
        data = malloc(sizeof(struct SDebugDrawerSetGraphLineColorCommand));





        ((struct SDebugDrawerSetGraphLineColorCommand*)data)->lineId = PyInt_AS_LONG(PyDict_GetItemString(command, "lineId"));















        ((struct SDebugDrawerSetGraphLineColorCommand*)data)->color = *(build_SAIFloat3(PyDict_GetItemString(command, "color")));



		break;
	
		case COMMAND_UNIT_ATTACK_AREA:
		
		
        data = malloc(sizeof(struct SAttackAreaUnitCommand));





        ((struct SAttackAreaUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SAttackAreaUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SAttackAreaUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SAttackAreaUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SAttackAreaUnitCommand*)data)->toAttackPos = *(build_SAIFloat3(PyDict_GetItemString(command, "toAttackPos")));













		break;
	
		case COMMAND_UNIT_WAIT_DEATH:
		
		
        data = malloc(sizeof(struct SDeathWaitUnitCommand));





        ((struct SDeathWaitUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SDeathWaitUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SDeathWaitUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SDeathWaitUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SDeathWaitUnitCommand*)data)->toDieUnitId = PyInt_AS_LONG(PyDict_GetItemString(command, "toDieUnitId"));







		break;
	
		case COMMAND_UNIT_RESTORE_AREA:
		
		
        data = malloc(sizeof(struct SRestoreAreaUnitCommand));





        ((struct SRestoreAreaUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SRestoreAreaUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SRestoreAreaUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SRestoreAreaUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SRestoreAreaUnitCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));













		break;
	
		case COMMAND_UNIT_LOAD_ONTO:
		
		
        data = malloc(sizeof(struct SLoadOntoUnitCommand));





        ((struct SLoadOntoUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SLoadOntoUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SLoadOntoUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SLoadOntoUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SLoadOntoUnitCommand*)data)->transporterUnitId = PyInt_AS_LONG(PyDict_GetItemString(command, "transporterUnitId"));







		break;
	
		case COMMAND_UNIT_RECLAIM:
		
		
        data = malloc(sizeof(struct SReclaimUnitCommand));





        ((struct SReclaimUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SReclaimUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SReclaimUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SReclaimUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SReclaimUnitCommand*)data)->toReclaimUnitIdOrFeatureId = PyInt_AS_LONG(PyDict_GetItemString(command, "toReclaimUnitIdOrFeatureId"));







		break;
	
		case COMMAND_SEND_UNITS:
		
		
        data = malloc(sizeof(struct SSendUnitsCommand));



        ((struct SSendUnitsCommand*)data)->unitIds = build_intarray(PyDict_GetItemString(command, "unitIds"));













        ((struct SSendUnitsCommand*)data)->numUnitIds = PyInt_AS_LONG(PyDict_GetItemString(command, "numUnitIds"));











        ((struct SSendUnitsCommand*)data)->receivingTeam = PyInt_AS_LONG(PyDict_GetItemString(command, "receivingTeam"));











        ((struct SSendUnitsCommand*)data)->ret_sentUnits = PyInt_AS_LONG(PyDict_GetItemString(command, "ret_sentUnits"));







		break;
	
		case COMMAND_DRAWER_PATH_FINISH:
		
		
        data = malloc(sizeof(struct SFinishPathDrawerCommand));

		break;
	
		case COMMAND_UNIT_WAIT_SQUAD:
		
		
        data = malloc(sizeof(struct SSquadWaitUnitCommand));





        ((struct SSquadWaitUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSquadWaitUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSquadWaitUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSquadWaitUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SSquadWaitUnitCommand*)data)->numUnits = PyInt_AS_LONG(PyDict_GetItemString(command, "numUnits"));







		break;
	
		case COMMAND_DEBUG_DRAWER_SET_GRAPH_POS:
		
		
        data = malloc(sizeof(struct SDebugDrawerSetGraphPositionCommand));





















		break;
	
		case COMMAND_DEBUG_DRAWER_SET_OVERLAY_TEXTURE_POS:
		
		
        data = malloc(sizeof(struct SDebugDrawerSetOverlayTexturePosCommand));





        ((struct SDebugDrawerSetOverlayTexturePosCommand*)data)->texHandle = PyInt_AS_LONG(PyDict_GetItemString(command, "texHandle"));



























		break;
	
		case COMMAND_UNIT_GROUP_CLEAR:
		
		
        data = malloc(sizeof(struct SGroupClearUnitCommand));





        ((struct SGroupClearUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SGroupClearUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SGroupClearUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SGroupClearUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));







		break;
	
		case COMMAND_GROUP_ERASE:
		
		
        data = malloc(sizeof(struct SEraseGroupCommand));





        ((struct SEraseGroupCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));







		break;
	
		case COMMAND_UNIT_STOP:
		
		
        data = malloc(sizeof(struct SStopUnitCommand));





        ((struct SStopUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SStopUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SStopUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SStopUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));







		break;
	
		case COMMAND_UNIT_SET_MOVE_STATE:
		
		
        data = malloc(sizeof(struct SSetMoveStateUnitCommand));





        ((struct SSetMoveStateUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSetMoveStateUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSetMoveStateUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSetMoveStateUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SSetMoveStateUnitCommand*)data)->moveState = PyInt_AS_LONG(PyDict_GetItemString(command, "moveState"));







		break;
	
		case COMMAND_UNIT_UNLOAD_UNITS_AREA:
		
		
        data = malloc(sizeof(struct SUnloadUnitsAreaUnitCommand));





        ((struct SUnloadUnitsAreaUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SUnloadUnitsAreaUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SUnloadUnitsAreaUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SUnloadUnitsAreaUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SUnloadUnitsAreaUnitCommand*)data)->toPos = *(build_SAIFloat3(PyDict_GetItemString(command, "toPos")));













		break;
	
		case COMMAND_PAUSE:
		
		
        data = malloc(sizeof(struct SPauseCommand));








        ((struct SPauseCommand*)data)->enable = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "enable"));










        ((struct SPauseCommand*)data)->reason = PyString_AS_STRING(PyDict_GetItemString(command, "reason"));





		break;
	
		case COMMAND_DRAWER_ADD_NOTIFICATION:
		
		
        data = malloc(sizeof(struct SAddNotificationDrawerCommand));









        ((struct SAddNotificationDrawerCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));











        ((struct SAddNotificationDrawerCommand*)data)->color = *(build_SAIFloat3(PyDict_GetItemString(command, "color")));













		break;
	
		case COMMAND_UNIT_UNLOAD_UNIT:
		
		
        data = malloc(sizeof(struct SUnloadUnitCommand));





        ((struct SUnloadUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SUnloadUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SUnloadUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SUnloadUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SUnloadUnitCommand*)data)->toPos = *(build_SAIFloat3(PyDict_GetItemString(command, "toPos")));







        ((struct SUnloadUnitCommand*)data)->toUnloadUnitId = PyInt_AS_LONG(PyDict_GetItemString(command, "toUnloadUnitId"));







		break;
	
		case COMMAND_UNIT_SET_AUTO_REPAIR_LEVEL:
		
		
        data = malloc(sizeof(struct SSetAutoRepairLevelUnitCommand));





        ((struct SSetAutoRepairLevelUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSetAutoRepairLevelUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSetAutoRepairLevelUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSetAutoRepairLevelUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SSetAutoRepairLevelUnitCommand*)data)->autoRepairLevel = PyInt_AS_LONG(PyDict_GetItemString(command, "autoRepairLevel"));







		break;
	
		case COMMAND_PATH_GET_NEXT_WAYPOINT:
		
		
        data = malloc(sizeof(struct SGetNextWaypointPathCommand));





        ((struct SGetNextWaypointPathCommand*)data)->pathId = PyInt_AS_LONG(PyDict_GetItemString(command, "pathId"));















        ((struct SGetNextWaypointPathCommand*)data)->ret_nextWaypoint = *(build_SAIFloat3(PyDict_GetItemString(command, "ret_nextWaypoint")));



		break;
	
		case COMMAND_CHEATS_GIVE_ME_RESOURCE:
		
		
        data = malloc(sizeof(struct SGiveMeResourceCheatCommand));





        ((struct SGiveMeResourceCheatCommand*)data)->resourceId = PyInt_AS_LONG(PyDict_GetItemString(command, "resourceId"));

















		break;
	
		case COMMAND_UNIT_RESURRECT:
		
		
        data = malloc(sizeof(struct SResurrectUnitCommand));





        ((struct SResurrectUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SResurrectUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SResurrectUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SResurrectUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SResurrectUnitCommand*)data)->toResurrectFeatureId = PyInt_AS_LONG(PyDict_GetItemString(command, "toResurrectFeatureId"));







		break;
	
		case COMMAND_UNIT_D_GUN:
		
		
        data = malloc(sizeof(struct SDGunUnitCommand));





        ((struct SDGunUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SDGunUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SDGunUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SDGunUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SDGunUnitCommand*)data)->toAttackUnitId = PyInt_AS_LONG(PyDict_GetItemString(command, "toAttackUnitId"));







		break;
	
		case COMMAND_CALL_LUA_RULES:
		
		
        data = malloc(sizeof(struct SCallLuaRulesCommand));







        ((struct SCallLuaRulesCommand*)data)->data = PyString_AS_STRING(PyDict_GetItemString(command, "data"));









        ((struct SCallLuaRulesCommand*)data)->inSize = PyInt_AS_LONG(PyDict_GetItemString(command, "inSize"));









        ((struct SCallLuaRulesCommand*)data)->outSize = build_intarray(PyDict_GetItemString(command, "outSize"));















        ((struct SCallLuaRulesCommand*)data)->ret_outData = PyString_AS_STRING(PyDict_GetItemString(command, "ret_outData"));





		break;
	
		case COMMAND_CHEATS_SET_MY_HANDICAP:
		
		
        data = malloc(sizeof(struct SSetMyHandicapCheatCommand));











		break;
	
		case COMMAND_GROUP_REMOVE_UNIT:
		
		
        data = malloc(sizeof(struct SRemoveUnitFromGroupCommand));





        ((struct SRemoveUnitFromGroupCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));














        ((struct SRemoveUnitFromGroupCommand*)data)->ret_isExecuted = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "ret_isExecuted"));




		break;
	
		case COMMAND_DRAWER_PATH_DRAW_LINE:
		
		
        data = malloc(sizeof(struct SDrawLinePathDrawerCommand));









        ((struct SDrawLinePathDrawerCommand*)data)->endPos = *(build_SAIFloat3(PyDict_GetItemString(command, "endPos")));











        ((struct SDrawLinePathDrawerCommand*)data)->color = *(build_SAIFloat3(PyDict_GetItemString(command, "color")));













		break;
	
		case COMMAND_UNIT_ATTACK:
		
		
        data = malloc(sizeof(struct SAttackUnitCommand));





        ((struct SAttackUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SAttackUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SAttackUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SAttackUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SAttackUnitCommand*)data)->toAttackUnitId = PyInt_AS_LONG(PyDict_GetItemString(command, "toAttackUnitId"));







		break;
	
		case COMMAND_UNIT_SET_WANTED_MAX_SPEED:
		
		
        data = malloc(sizeof(struct SSetWantedMaxSpeedUnitCommand));





        ((struct SSetWantedMaxSpeedUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSetWantedMaxSpeedUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSetWantedMaxSpeedUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSetWantedMaxSpeedUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));

















		break;
	
		case COMMAND_DRAWER_POINT_REMOVE:
		
		
        data = malloc(sizeof(struct SRemovePointDrawCommand));









        ((struct SRemovePointDrawCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));



		break;
	
		case COMMAND_DEBUG_DRAWER_ADD_OVERLAY_TEXTURE:
		
		
        data = malloc(sizeof(struct SDebugDrawerAddOverlayTextureCommand));





        ((struct SDebugDrawerAddOverlayTextureCommand*)data)->texHandle = PyInt_AS_LONG(PyDict_GetItemString(command, "texHandle"));





















        ((struct SDebugDrawerAddOverlayTextureCommand*)data)->w = PyInt_AS_LONG(PyDict_GetItemString(command, "w"));











        ((struct SDebugDrawerAddOverlayTextureCommand*)data)->h = PyInt_AS_LONG(PyDict_GetItemString(command, "h"));







		break;
	
		case COMMAND_UNIT_SELF_DESTROY:
		
		
        data = malloc(sizeof(struct SSelfDestroyUnitCommand));





        ((struct SSelfDestroyUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSelfDestroyUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSelfDestroyUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSelfDestroyUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));







		break;
	
		case COMMAND_GROUP_CREATE:
		
		
        data = malloc(sizeof(struct SCreateGroupCommand));





        ((struct SCreateGroupCommand*)data)->ret_groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "ret_groupId"));







		break;
	
		case COMMAND_UNIT_CAPTURE:
		
		
        data = malloc(sizeof(struct SCaptureUnitCommand));





        ((struct SCaptureUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SCaptureUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SCaptureUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SCaptureUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SCaptureUnitCommand*)data)->toCaptureUnitId = PyInt_AS_LONG(PyDict_GetItemString(command, "toCaptureUnitId"));







		break;
	
		case COMMAND_DEBUG_DRAWER_ADD_GRAPH_POINT:
		
		
        data = malloc(sizeof(struct SDebugDrawerAddGraphPointCommand));

























        ((struct SDebugDrawerAddGraphPointCommand*)data)->lineId = PyInt_AS_LONG(PyDict_GetItemString(command, "lineId"));







		break;
	
		case COMMAND_UNIT_SET_TRAJECTORY:
		
		
        data = malloc(sizeof(struct SSetTrajectoryUnitCommand));





        ((struct SSetTrajectoryUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSetTrajectoryUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSetTrajectoryUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSetTrajectoryUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SSetTrajectoryUnitCommand*)data)->trajectory = PyInt_AS_LONG(PyDict_GetItemString(command, "trajectory"));







		break;
	
		case COMMAND_UNIT_SET_BASE:
		
		
        data = malloc(sizeof(struct SSetBaseUnitCommand));





        ((struct SSetBaseUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSetBaseUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSetBaseUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSetBaseUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SSetBaseUnitCommand*)data)->basePos = *(build_SAIFloat3(PyDict_GetItemString(command, "basePos")));



		break;
	
		case COMMAND_TRACE_RAY:
		
		
        data = malloc(sizeof(struct STraceRayCommand));









        ((struct STraceRayCommand*)data)->rayPos = *(build_SAIFloat3(PyDict_GetItemString(command, "rayPos")));











        ((struct STraceRayCommand*)data)->rayDir = *(build_SAIFloat3(PyDict_GetItemString(command, "rayDir")));

















        ((struct STraceRayCommand*)data)->srcUID = PyInt_AS_LONG(PyDict_GetItemString(command, "srcUID"));











        ((struct STraceRayCommand*)data)->hitUID = PyInt_AS_LONG(PyDict_GetItemString(command, "hitUID"));











        ((struct STraceRayCommand*)data)->flags = PyInt_AS_LONG(PyDict_GetItemString(command, "flags"));







		break;
	
		case COMMAND_UNIT_RECLAIM_AREA:
		
		
        data = malloc(sizeof(struct SReclaimAreaUnitCommand));





        ((struct SReclaimAreaUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SReclaimAreaUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SReclaimAreaUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SReclaimAreaUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SReclaimAreaUnitCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));













		break;
	
		case COMMAND_UNIT_RESURRECT_AREA:
		
		
        data = malloc(sizeof(struct SResurrectAreaUnitCommand));





        ((struct SResurrectAreaUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SResurrectAreaUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SResurrectAreaUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SResurrectAreaUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SResurrectAreaUnitCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));













		break;
	
		case COMMAND_GROUP_ADD_UNIT:
		
		
        data = malloc(sizeof(struct SAddUnitToGroupCommand));





        ((struct SAddUnitToGroupCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SAddUnitToGroupCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));














        ((struct SAddUnitToGroupCommand*)data)->ret_isExecuted = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "ret_isExecuted"));




		break;
	
		case COMMAND_UNIT_SET_REPEAT:
		
		
        data = malloc(sizeof(struct SSetRepeatUnitCommand));





        ((struct SSetRepeatUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSetRepeatUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSetRepeatUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSetRepeatUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));














        ((struct SSetRepeatUnitCommand*)data)->repeat = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "repeat"));




		break;
	
		case COMMAND_SET_LAST_POS_MESSAGE:
		
		
        data = malloc(sizeof(struct SSetLastPosMessageCommand));









        ((struct SSetLastPosMessageCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));



		break;
	
		case COMMAND_UNIT_CAPTURE_AREA:
		
		
        data = malloc(sizeof(struct SCaptureAreaUnitCommand));





        ((struct SCaptureAreaUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SCaptureAreaUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SCaptureAreaUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SCaptureAreaUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SCaptureAreaUnitCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));













		break;
	
		case COMMAND_DRAWER_DRAW_UNIT:
		
		
        data = malloc(sizeof(struct SDrawUnitDrawerCommand));





        ((struct SDrawUnitDrawerCommand*)data)->toDrawUnitDefId = PyInt_AS_LONG(PyDict_GetItemString(command, "toDrawUnitDefId"));















        ((struct SDrawUnitDrawerCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));

















        ((struct SDrawUnitDrawerCommand*)data)->lifeTime = PyInt_AS_LONG(PyDict_GetItemString(command, "lifeTime"));











        ((struct SDrawUnitDrawerCommand*)data)->teamId = PyInt_AS_LONG(PyDict_GetItemString(command, "teamId"));














        ((struct SDrawUnitDrawerCommand*)data)->transparent = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "transparent"));











        ((struct SDrawUnitDrawerCommand*)data)->drawBorder = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "drawBorder"));








        ((struct SDrawUnitDrawerCommand*)data)->facing = PyInt_AS_LONG(PyDict_GetItemString(command, "facing"));







		break;
	
		case COMMAND_UNIT_WAIT_GATHER:
		
		
        data = malloc(sizeof(struct SGatherWaitUnitCommand));





        ((struct SGatherWaitUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SGatherWaitUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SGatherWaitUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SGatherWaitUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));







		break;
	
		case COMMAND_SEND_TEXT_MESSAGE:
		
		
        data = malloc(sizeof(struct SSendTextMessageCommand));







        ((struct SSendTextMessageCommand*)data)->text = PyString_AS_STRING(PyDict_GetItemString(command, "text"));









        ((struct SSendTextMessageCommand*)data)->zone = PyInt_AS_LONG(PyDict_GetItemString(command, "zone"));







		break;
	
		case COMMAND_UNIT_FIGHT:
		
		
        data = malloc(sizeof(struct SFightUnitCommand));





        ((struct SFightUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SFightUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SFightUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SFightUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SFightUnitCommand*)data)->toPos = *(build_SAIFloat3(PyDict_GetItemString(command, "toPos")));



		break;
	
		case COMMAND_SEND_RESOURCES:
		
		
        data = malloc(sizeof(struct SSendResourcesCommand));





        ((struct SSendResourcesCommand*)data)->resourceId = PyInt_AS_LONG(PyDict_GetItemString(command, "resourceId"));





















        ((struct SSendResourcesCommand*)data)->receivingTeam = PyInt_AS_LONG(PyDict_GetItemString(command, "receivingTeam"));














        ((struct SSendResourcesCommand*)data)->ret_isExecuted = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "ret_isExecuted"));




		break;
	
		case COMMAND_DRAWER_FIGURE_SET_COLOR:
		
		
        data = malloc(sizeof(struct SSetColorFigureDrawerCommand));





        ((struct SSetColorFigureDrawerCommand*)data)->figureGroupId = PyInt_AS_LONG(PyDict_GetItemString(command, "figureGroupId"));















        ((struct SSetColorFigureDrawerCommand*)data)->color = *(build_SAIFloat3(PyDict_GetItemString(command, "color")));













		break;
	
		case COMMAND_UNIT_LOAD_UNITS:
		
		
        data = malloc(sizeof(struct SLoadUnitsUnitCommand));





        ((struct SLoadUnitsUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SLoadUnitsUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SLoadUnitsUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SLoadUnitsUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));









        ((struct SLoadUnitsUnitCommand*)data)->toLoadUnitIds = build_intarray(PyDict_GetItemString(command, "toLoadUnitIds"));













        ((struct SLoadUnitsUnitCommand*)data)->numToLoadUnits = PyInt_AS_LONG(PyDict_GetItemString(command, "numToLoadUnits"));







		break;
	
		case COMMAND_DRAWER_LINE_ADD:
		
		
        data = malloc(sizeof(struct SAddLineDrawCommand));









        ((struct SAddLineDrawCommand*)data)->posFrom = *(build_SAIFloat3(PyDict_GetItemString(command, "posFrom")));











        ((struct SAddLineDrawCommand*)data)->posTo = *(build_SAIFloat3(PyDict_GetItemString(command, "posTo")));



		break;
	
		case COMMAND_UNIT_REPAIR:
		
		
        data = malloc(sizeof(struct SRepairUnitCommand));





        ((struct SRepairUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SRepairUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SRepairUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SRepairUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SRepairUnitCommand*)data)->toRepairUnitId = PyInt_AS_LONG(PyDict_GetItemString(command, "toRepairUnitId"));







		break;
	
		case COMMAND_UNIT_STOCKPILE:
		
		
        data = malloc(sizeof(struct SStockpileUnitCommand));





        ((struct SStockpileUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SStockpileUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SStockpileUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SStockpileUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));







		break;
	
		case COMMAND_UNIT_D_GUN_POS:
		
		
        data = malloc(sizeof(struct SDGunPosUnitCommand));





        ((struct SDGunPosUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SDGunPosUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SDGunPosUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SDGunPosUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SDGunPosUnitCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));



		break;
	
		case COMMAND_DEBUG_DRAWER_SET_GRAPH_LINE_LABEL:
		
		
        data = malloc(sizeof(struct SDebugDrawerSetGraphLineLabelCommand));





        ((struct SDebugDrawerSetGraphLineLabelCommand*)data)->lineId = PyInt_AS_LONG(PyDict_GetItemString(command, "lineId"));













        ((struct SDebugDrawerSetGraphLineLabelCommand*)data)->label = PyString_AS_STRING(PyDict_GetItemString(command, "label"));





		break;
	
		case COMMAND_UNIT_WAIT_TIME:
		
		
        data = malloc(sizeof(struct STimeWaitUnitCommand));





        ((struct STimeWaitUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct STimeWaitUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct STimeWaitUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct STimeWaitUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct STimeWaitUnitCommand*)data)->time = PyInt_AS_LONG(PyDict_GetItemString(command, "time"));







		break;
	
		case COMMAND_UNIT_SET_ON_OFF:
		
		
        data = malloc(sizeof(struct SSetOnOffUnitCommand));





        ((struct SSetOnOffUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSetOnOffUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSetOnOffUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSetOnOffUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));














        ((struct SSetOnOffUnitCommand*)data)->on = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "on"));




		break;
	
		case COMMAND_DEBUG_DRAWER_SET_OVERLAY_TEXTURE_SIZE:
		
		
        data = malloc(sizeof(struct SDebugDrawerSetOverlayTextureSizeCommand));





        ((struct SDebugDrawerSetOverlayTextureSizeCommand*)data)->texHandle = PyInt_AS_LONG(PyDict_GetItemString(command, "texHandle"));



























		break;
	
		case COMMAND_UNIT_CUSTOM:
		
		
        data = malloc(sizeof(struct SCustomUnitCommand));





        ((struct SCustomUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SCustomUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SCustomUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SCustomUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SCustomUnitCommand*)data)->cmdId = PyInt_AS_LONG(PyDict_GetItemString(command, "cmdId"));





















        ((struct SCustomUnitCommand*)data)->numParams = PyInt_AS_LONG(PyDict_GetItemString(command, "numParams"));







		break;
	
		case COMMAND_UNIT_CLOAK:
		
		
        data = malloc(sizeof(struct SCloakUnitCommand));





        ((struct SCloakUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SCloakUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SCloakUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SCloakUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));














        ((struct SCloakUnitCommand*)data)->cloak = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "cloak"));




		break;
	
		case COMMAND_DEBUG_DRAWER_DEL_OVERLAY_TEXTURE:
		
		
        data = malloc(sizeof(struct SDebugDrawerDelOverlayTextureCommand));





        ((struct SDebugDrawerDelOverlayTextureCommand*)data)->texHandle = PyInt_AS_LONG(PyDict_GetItemString(command, "texHandle"));







		break;
	
		case COMMAND_UNIT_GUARD:
		
		
        data = malloc(sizeof(struct SGuardUnitCommand));





        ((struct SGuardUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SGuardUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SGuardUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SGuardUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SGuardUnitCommand*)data)->toGuardUnitId = PyInt_AS_LONG(PyDict_GetItemString(command, "toGuardUnitId"));







		break;
	
		case COMMAND_PATH_GET_APPROXIMATE_LENGTH:
		
		
        data = malloc(sizeof(struct SGetApproximateLengthPathCommand));









        ((struct SGetApproximateLengthPathCommand*)data)->start = *(build_SAIFloat3(PyDict_GetItemString(command, "start")));











        ((struct SGetApproximateLengthPathCommand*)data)->end = *(build_SAIFloat3(PyDict_GetItemString(command, "end")));







        ((struct SGetApproximateLengthPathCommand*)data)->pathType = PyInt_AS_LONG(PyDict_GetItemString(command, "pathType"));





















        ((struct SGetApproximateLengthPathCommand*)data)->ret_approximatePathLength = PyInt_AS_LONG(PyDict_GetItemString(command, "ret_approximatePathLength"));







		break;
	
		case COMMAND_DRAWER_FIGURE_CREATE_LINE:
		
		
        data = malloc(sizeof(struct SCreateLineFigureDrawerCommand));









        ((struct SCreateLineFigureDrawerCommand*)data)->pos1 = *(build_SAIFloat3(PyDict_GetItemString(command, "pos1")));











        ((struct SCreateLineFigureDrawerCommand*)data)->pos2 = *(build_SAIFloat3(PyDict_GetItemString(command, "pos2")));




















        ((struct SCreateLineFigureDrawerCommand*)data)->arrow = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "arrow"));








        ((struct SCreateLineFigureDrawerCommand*)data)->lifeTime = PyInt_AS_LONG(PyDict_GetItemString(command, "lifeTime"));











        ((struct SCreateLineFigureDrawerCommand*)data)->figureGroupId = PyInt_AS_LONG(PyDict_GetItemString(command, "figureGroupId"));











        ((struct SCreateLineFigureDrawerCommand*)data)->ret_newFigureGroupId = PyInt_AS_LONG(PyDict_GetItemString(command, "ret_newFigureGroupId"));







		break;
	
		case COMMAND_DEBUG_DRAWER_UPDATE_OVERLAY_TEXTURE:
		
		
        data = malloc(sizeof(struct SDebugDrawerUpdateOverlayTextureCommand));





        ((struct SDebugDrawerUpdateOverlayTextureCommand*)data)->texHandle = PyInt_AS_LONG(PyDict_GetItemString(command, "texHandle"));





















        ((struct SDebugDrawerUpdateOverlayTextureCommand*)data)->x = PyInt_AS_LONG(PyDict_GetItemString(command, "x"));











        ((struct SDebugDrawerUpdateOverlayTextureCommand*)data)->y = PyInt_AS_LONG(PyDict_GetItemString(command, "y"));











        ((struct SDebugDrawerUpdateOverlayTextureCommand*)data)->w = PyInt_AS_LONG(PyDict_GetItemString(command, "w"));











        ((struct SDebugDrawerUpdateOverlayTextureCommand*)data)->h = PyInt_AS_LONG(PyDict_GetItemString(command, "h"));







		break;
	
		case COMMAND_UNIT_SET_IDLE_MODE:
		
		
        data = malloc(sizeof(struct SSetIdleModeUnitCommand));





        ((struct SSetIdleModeUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSetIdleModeUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSetIdleModeUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSetIdleModeUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SSetIdleModeUnitCommand*)data)->idleMode = PyInt_AS_LONG(PyDict_GetItemString(command, "idleMode"));







		break;
	
		case COMMAND_DEBUG_DRAWER_SET_OVERLAY_TEXTURE_LABEL:
		
		
        data = malloc(sizeof(struct SDebugDrawerSetOverlayTextureLabelCommand));





        ((struct SDebugDrawerSetOverlayTextureLabelCommand*)data)->texHandle = PyInt_AS_LONG(PyDict_GetItemString(command, "texHandle"));













        ((struct SDebugDrawerSetOverlayTextureLabelCommand*)data)->label = PyString_AS_STRING(PyDict_GetItemString(command, "label"));





		break;
	
		case COMMAND_DRAWER_PATH_DRAW_LINE_AND_ICON:
		
		
        data = malloc(sizeof(struct SDrawLineAndIconPathDrawerCommand));





        ((struct SDrawLineAndIconPathDrawerCommand*)data)->cmdId = PyInt_AS_LONG(PyDict_GetItemString(command, "cmdId"));















        ((struct SDrawLineAndIconPathDrawerCommand*)data)->endPos = *(build_SAIFloat3(PyDict_GetItemString(command, "endPos")));











        ((struct SDrawLineAndIconPathDrawerCommand*)data)->color = *(build_SAIFloat3(PyDict_GetItemString(command, "color")));













		break;
	
		case COMMAND_DRAWER_PATH_RESTART:
		
		
        data = malloc(sizeof(struct SRestartPathDrawerCommand));








        ((struct SRestartPathDrawerCommand*)data)->sameColor = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "sameColor"));




		break;
	
		case COMMAND_DEBUG_DRAWER_SET_GRAPH_SIZE:
		
		
        data = malloc(sizeof(struct SDebugDrawerSetGraphSizeCommand));





















		break;
	
		case COMMAND_UNIT_AI_SELECT:
		
		
        data = malloc(sizeof(struct SAiSelectUnitCommand));





        ((struct SAiSelectUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SAiSelectUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SAiSelectUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SAiSelectUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));







		break;
	
		case COMMAND_UNIT_LOAD_UNITS_AREA:
		
		
        data = malloc(sizeof(struct SLoadUnitsAreaUnitCommand));





        ((struct SLoadUnitsAreaUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SLoadUnitsAreaUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SLoadUnitsAreaUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SLoadUnitsAreaUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SLoadUnitsAreaUnitCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));













		break;
	
		case COMMAND_DRAWER_FIGURE_CREATE_SPLINE:
		
		
        data = malloc(sizeof(struct SCreateSplineFigureDrawerCommand));









        ((struct SCreateSplineFigureDrawerCommand*)data)->pos1 = *(build_SAIFloat3(PyDict_GetItemString(command, "pos1")));











        ((struct SCreateSplineFigureDrawerCommand*)data)->pos2 = *(build_SAIFloat3(PyDict_GetItemString(command, "pos2")));











        ((struct SCreateSplineFigureDrawerCommand*)data)->pos3 = *(build_SAIFloat3(PyDict_GetItemString(command, "pos3")));











        ((struct SCreateSplineFigureDrawerCommand*)data)->pos4 = *(build_SAIFloat3(PyDict_GetItemString(command, "pos4")));




















        ((struct SCreateSplineFigureDrawerCommand*)data)->arrow = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "arrow"));








        ((struct SCreateSplineFigureDrawerCommand*)data)->lifeTime = PyInt_AS_LONG(PyDict_GetItemString(command, "lifeTime"));











        ((struct SCreateSplineFigureDrawerCommand*)data)->figureGroupId = PyInt_AS_LONG(PyDict_GetItemString(command, "figureGroupId"));











        ((struct SCreateSplineFigureDrawerCommand*)data)->ret_newFigureGroupId = PyInt_AS_LONG(PyDict_GetItemString(command, "ret_newFigureGroupId"));







		break;
	
		case COMMAND_CHEATS_GIVE_ME_NEW_UNIT:
		
		
        data = malloc(sizeof(struct SGiveMeNewUnitCheatCommand));





        ((struct SGiveMeNewUnitCheatCommand*)data)->unitDefId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitDefId"));















        ((struct SGiveMeNewUnitCheatCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));







        ((struct SGiveMeNewUnitCheatCommand*)data)->ret_newUnitId = PyInt_AS_LONG(PyDict_GetItemString(command, "ret_newUnitId"));







		break;
	
		case COMMAND_DRAWER_FIGURE_DELETE:
		
		
        data = malloc(sizeof(struct SDeleteFigureDrawerCommand));





        ((struct SDeleteFigureDrawerCommand*)data)->figureGroupId = PyInt_AS_LONG(PyDict_GetItemString(command, "figureGroupId"));







		break;
	
		case COMMAND_UNIT_GROUP_ADD:
		
		
        data = malloc(sizeof(struct SGroupAddUnitCommand));





        ((struct SGroupAddUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SGroupAddUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SGroupAddUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SGroupAddUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SGroupAddUnitCommand*)data)->toGroupId = PyInt_AS_LONG(PyDict_GetItemString(command, "toGroupId"));







		break;
	
		case COMMAND_DRAWER_PATH_DRAW_ICON_AT_LAST_POS:
		
		
        data = malloc(sizeof(struct SDrawIconAtLastPosPathDrawerCommand));





        ((struct SDrawIconAtLastPosPathDrawerCommand*)data)->cmdId = PyInt_AS_LONG(PyDict_GetItemString(command, "cmdId"));







		break;
	
		case COMMAND_DRAWER_POINT_ADD:
		
		
        data = malloc(sizeof(struct SAddPointDrawCommand));









        ((struct SAddPointDrawCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));









        ((struct SAddPointDrawCommand*)data)->label = PyString_AS_STRING(PyDict_GetItemString(command, "label"));





		break;
	
		case COMMAND_DRAWER_PATH_START:
		
		
        data = malloc(sizeof(struct SStartPathDrawerCommand));









        ((struct SStartPathDrawerCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));











        ((struct SStartPathDrawerCommand*)data)->color = *(build_SAIFloat3(PyDict_GetItemString(command, "color")));













		break;
	
		case COMMAND_DRAWER_PATH_BREAK:
		
		
        data = malloc(sizeof(struct SBreakPathDrawerCommand));









        ((struct SBreakPathDrawerCommand*)data)->endPos = *(build_SAIFloat3(PyDict_GetItemString(command, "endPos")));











        ((struct SBreakPathDrawerCommand*)data)->color = *(build_SAIFloat3(PyDict_GetItemString(command, "color")));













		break;
	
		case COMMAND_DEBUG_DRAWER_DELETE_GRAPH_POINTS:
		
		
        data = malloc(sizeof(struct SDebugDrawerDeleteGraphPointsCommand));





        ((struct SDebugDrawerDeleteGraphPointsCommand*)data)->lineId = PyInt_AS_LONG(PyDict_GetItemString(command, "lineId"));











        ((struct SDebugDrawerDeleteGraphPointsCommand*)data)->numPoints = PyInt_AS_LONG(PyDict_GetItemString(command, "numPoints"));







		break;
	
		case COMMAND_UNIT_WAIT:
		
		
        data = malloc(sizeof(struct SWaitUnitCommand));





        ((struct SWaitUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SWaitUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SWaitUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SWaitUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));







		break;
	
		case COMMAND_UNIT_PATROL:
		
		
        data = malloc(sizeof(struct SPatrolUnitCommand));





        ((struct SPatrolUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SPatrolUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SPatrolUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SPatrolUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));















        ((struct SPatrolUnitCommand*)data)->toPos = *(build_SAIFloat3(PyDict_GetItemString(command, "toPos")));



		break;
	
		case COMMAND_PATH_FREE:
		
		
        data = malloc(sizeof(struct SFreePathCommand));





        ((struct SFreePathCommand*)data)->pathId = PyInt_AS_LONG(PyDict_GetItemString(command, "pathId"));







		break;
	
		case COMMAND_UNIT_SET_FIRE_STATE:
		
		
        data = malloc(sizeof(struct SSetFireStateUnitCommand));





        ((struct SSetFireStateUnitCommand*)data)->unitId = PyInt_AS_LONG(PyDict_GetItemString(command, "unitId"));











        ((struct SSetFireStateUnitCommand*)data)->groupId = PyInt_AS_LONG(PyDict_GetItemString(command, "groupId"));











        ((struct SSetFireStateUnitCommand*)data)->options = PyInt_AS_LONG(PyDict_GetItemString(command, "options"));











        ((struct SSetFireStateUnitCommand*)data)->timeOut = PyInt_AS_LONG(PyDict_GetItemString(command, "timeOut"));











        ((struct SSetFireStateUnitCommand*)data)->fireState = PyInt_AS_LONG(PyDict_GetItemString(command, "fireState"));







		break;
	
		case COMMAND_SEND_START_POS:
		
		
        data = malloc(sizeof(struct SSendStartPosCommand));








        ((struct SSendStartPosCommand*)data)->ready = (bool)PyInt_AS_LONG(PyDict_GetItemString(command, "ready"));












        ((struct SSendStartPosCommand*)data)->pos = *(build_SAIFloat3(PyDict_GetItemString(command, "pos")));



		break;
	
	}
	return data;
}

PyObject*
command_reverse(int topic, void* data)
{
	switch (topic) {
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	}
	return Py_None;
}

	typedef struct {
  PyObject_HEAD;
  const struct SSkirmishAICallback* callback; // C Callback Object
} PyAICallbackObject;

static PyTypeObject PyAICallback_Type;

PyObject*
PyAICallback_New(const struct SSkirmishAICallback* callback)
{
  PyAICallbackObject *self;
  self = (PyAICallbackObject *)PyAICallback_Type.tp_alloc(&PyAICallback_Type, 0);
  
  if (self)
  {
    self->callback=callback;
  }
  return (PyObject*)self;
}


PyObject*
Clb_UnitDef_WeaponMount_getFuelUsage(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_WeaponMount_getFuelUsage(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Game_getSpeedFactor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Game_getSpeedFactor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_CurrentCommand_getTimeOut(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_CurrentCommand_getTimeOut(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0getHeightMap(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float* extra1;
extra1=malloc(sizeof(float)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_Map_0ARRAY1VALS0getHeightMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyFloat_FromDouble(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_UnitDef_MoveData_getSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_MoveData_getSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getDlHoverFactor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getDlHoverFactor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_0MAP1KEYS0getCustomParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char** extra2;
	int size = callback->Clb_UnitDef_0MAP1SIZE0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1))
		);
	extra2=malloc(sizeof(const char*)*size);
	callback->Clb_UnitDef_0MAP1KEYS0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2);
list = PyList_New(size);
for (i=0;i<size;i++) PyList_SetItem(list, i, PyString_FromString(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_Unit_ModParam_getValue(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_ModParam_getValue(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Feature_getReclaimLeft(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Feature_getReclaimLeft(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Map_0REF1Resource2resourceId0getMaxResource(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_0REF1Resource2resourceId0getMaxResource(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_getPower(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_getPower(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getBounceSlip(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getBounceSlip(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_isGeoThermal(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_FeatureDef_isGeoThermal(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Gui_Camera_getPosition(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Gui_Camera_getPosition(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_UnitDef_getSeismicSignature(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getSeismicSignature(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Group_SupportedCommand_getId(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Group_SupportedCommand_getId(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getStartVelocity(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getStartVelocity(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isReleaseHeld(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isReleaseHeld(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_getLineage(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_getLineage(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Group_isSelected(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Group_isSelected(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getSizeGrowth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getSizeGrowth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_0MAP1KEYS0getCustomParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char** extra2;
	int size = callback->Clb_FeatureDef_0MAP1SIZE0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1))
		);
	extra2=malloc(sizeof(const char*)*size);
	callback->Clb_FeatureDef_0MAP1KEYS0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2);
list = PyList_New(size);
for (i=0;i<size;i++) PyList_SetItem(list, i, PyString_FromString(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_Map_Point_getPosition(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Map_Point_getPosition(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_WeaponDef_getMinIntensity(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getMinIntensity(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Shield_getForce(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Shield_getForce(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_isParalyzed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Unit_isParalyzed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Group_SupportedCommand_0ARRAY1VALS0getParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char** extra3;
extra3=malloc(sizeof(const char*)*PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
int retval;
retval = callback->Clb_Group_SupportedCommand_0ARRAY1VALS0getParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)),
	extra3,
	PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyString_FromString(extra3[i]));
FREE(extra3);
return list;
}

PyObject*
Clb_WeaponDef_getCoverageRange(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getCoverageRange(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_getReclaimTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_FeatureDef_getReclaimTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getCategory(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_UnitDef_getCategory(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isAbleToKamikaze(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToKamikaze(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_MoveData_getCrushStrength(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_MoveData_getCrushStrength(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isDynDamageInverted(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isDynDamageInverted(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Game_getTeamSide(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Game_getTeamSide(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getMyGravity(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMyGravity(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getWaterline(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getWaterline(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_getZSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_FeatureDef_getZSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Group_OrderPreview_getId(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Group_OrderPreview_getId(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_MoveData_getFollowGround(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_MoveData_getFollowGround(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getPredictBoost(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getPredictBoost(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getHeightBoostFactor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getHeightBoostFactor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getJammerRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getJammerRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isStrafeToAttack(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isStrafeToAttack(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isAbleToAttack(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToAttack(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_isShieldRepulser(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isShieldRepulser(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0getCornersHeightMap(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float* extra1;
extra1=malloc(sizeof(float)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_Map_0ARRAY1VALS0getCornersHeightMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyFloat_FromDouble(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_WeaponDef_Damage_getImpulseBoost(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Damage_getImpulseBoost(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isCollide(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isCollide(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_CurrentCommand_0ARRAY1SIZE0getParams(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_CurrentCommand_0ARRAY1SIZE0getParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_ModParam_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Unit_ModParam_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_getOnlyTargetCategory(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_WeaponDef_getOnlyTargetCategory(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getSupplyCost(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getSupplyCost(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Game_getPlayerTeam(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Game_getPlayerTeam(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getArmoredMultiple(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getArmoredMultiple(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_MoveData_getTerrainClass(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_MoveData_getTerrainClass(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_0MULTI1SIZE3SelectedUnits0Unit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3SelectedUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getUnloadSpread(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getUnloadSpread(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getWeaponAcceleration(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getWeaponAcceleration(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_DataDirs_allocatePath(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
char* retval;
retval = callback->Clb_DataDirs_allocatePath(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,2)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,3)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,4)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,5)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Unit_getStockpileQueued(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_getStockpileQueued(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getReclaimUnitEnergyCostFactor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Mod_getReclaimUnitEnergyCostFactor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getCaptureSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getCaptureSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getVisibleShieldHitFrames(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getVisibleShieldHitFrames(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isSubMissile(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isSubMissile(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getCategoryString(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getCategoryString(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Mod_getTransportHover(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getTransportHover(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_SupportedCommand_getId(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_SupportedCommand_getId(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_MoveData_getMaxTurnRate(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
short retval;
retval = callback->Clb_UnitDef_MoveData_getMaxTurnRate(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_None;
}

PyObject*
Clb_0MULTI1FETCH3WeaponDefByName0WeaponDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1FETCH3WeaponDefByName0WeaponDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getMaxRepairSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxRepairSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Damage_0ARRAY1SIZE0getTypes(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_Damage_0ARRAY1SIZE0getTypes(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isParalyzer(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isParalyzer(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_SkirmishAIs_getSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_SkirmishAIs_getSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getWantedHeight(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getWantedHeight(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getProjectileSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getProjectileSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Economy_0REF1Resource2resourceId0getIncome(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Economy_0REF1Resource2resourceId0getIncome(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getHighTrajectoryType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getHighTrajectoryType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Group_OrderPreview_getTimeOut(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Group_OrderPreview_getTimeOut(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_FeatureDef_getDescription(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_FeatureDef_getDescription(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_0MULTI1SIZE3EnemyUnitsIn0Unit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3EnemyUnitsIn0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	*(build_SAIFloat3(PyTuple_GetItem(args,1))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Cheats_isEnabled(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Cheats_isEnabled(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Engine_Version_getMinor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Engine_Version_getMinor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getTransportSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getTransportSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_getLastUserOrderFrame(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_getLastUserOrderFrame(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_MoveData_isSubMarine(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_MoveData_isSubMarine(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0getRadarMap(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned short* extra1;
extra1=malloc(sizeof(unsigned short)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_Map_0ARRAY1VALS0getRadarMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_UnitDef_getCloakCost(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getCloakCost(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Shield_0REF1Resource2resourceId0getResourceUse(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Shield_0REF1Resource2resourceId0getResourceUse(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_getTidalStrength(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_getTidalStrength(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getMinAirBasePower(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMinAirBasePower(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getReload(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getReload(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapRaw(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned char* extra2;
extra2=malloc(sizeof(unsigned char)*PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
int retval;
retval = callback->Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapRaw(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2,
	PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_FeatureDef_isBlocking(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_FeatureDef_isBlocking(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Gui_getViewRange(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Gui_getViewRange(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getDrag(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getDrag(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getNoChaseCategory(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_UnitDef_getNoChaseCategory(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_WeaponMount_0SINGLE1FETCH2WeaponDef0getWeaponDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_WeaponMount_0SINGLE1FETCH2WeaponDef0getWeaponDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getCollisionSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getCollisionSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getHash(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getHash(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getFalloffRate(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getFalloffRate(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getSpeedToFront(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getSpeedToFront(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getLosMul(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Mod_getLosMul(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isStealth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isStealth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isAbleToDGun(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToDGun(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Economy_0REF1Resource2resourceId0getCurrent(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Economy_0REF1Resource2resourceId0getCurrent(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getMaxVelocity(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getMaxVelocity(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isExteriorShield(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isExteriorShield(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getAirLosRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getAirLosRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getTurnRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTurnRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getHumanName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getHumanName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_isFeature(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isFeature(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getRadarRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getRadarRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_getGroup(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_getGroup(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getTrajectoryHeight(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getTrajectoryHeight(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getTransportGround(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getTransportGround(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_getTeam(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_getTeam(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isDecloakOnFire(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isDecloakOnFire(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_Shield_getRechargeDelay(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_Shield_getRechargeDelay(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isAbleToCrash(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToCrash(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_MoveData_getSlopeMod(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_MoveData_getSlopeMod(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Group_OrderPreview_getOptions(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned char retval;
retval = callback->Clb_Group_OrderPreview_getOptions(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Unit_getExperience(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_getExperience(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_WeaponDef_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Gui_getScreenX(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Gui_getScreenX(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Gui_getScreenY(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Gui_getScreenY(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_getSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_getSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getFlareDropVector(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_UnitDef_getFlareDropVector(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_Mod_getAllowTeamColors(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Mod_getAllowTeamColors(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getDynDamageExp(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getDynDamageExp(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Group_SupportedCommand_0ARRAY1SIZE0getParams(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Group_SupportedCommand_0ARRAY1SIZE0getParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_getHeight(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_getHeight(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_Line_getFirstPosition(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Map_Line_getFirstPosition(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_File_getContent(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_File_getContent(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)),
	NULL,
	PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapSpotsPositions(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3* extra2;
extra2=malloc(sizeof(struct SAIFloat3)*PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
int retval;
retval = callback->Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapSpotsPositions(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2,
	PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, convert_SAIFloat3(&extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_UnitDef_getMaxElevator(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxElevator(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_FlankingBonus_getDir(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_UnitDef_FlankingBonus_getDir(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_Map_getMaxWind(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_getMaxWind(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_getHash(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_getHash(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_getWidth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_getWidth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0isSquareResourceExtractor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0isSquareResourceExtractor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_FeatureDef_getFileName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_FeatureDef_getFileName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_FeatureDef_0MAP1SIZE0getCustomParams(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_FeatureDef_0MAP1SIZE0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getFlareTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getFlareTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isManualFire(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isManualFire(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_0MULTI1VALS3NeutralUnits0Unit(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS3NeutralUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_WeaponDef_isAvoidNeutral(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isAvoidNeutral(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_SkirmishAI_Info_getDescription(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_SkirmishAI_Info_getDescription(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Map_getMousePos(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Map_getMousePos(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_WeaponDef_getNumBounce(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getNumBounce(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_Point_getColor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Map_Point_getColor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_Unit_getMaxHealth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_getMaxHealth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1SIZE0Group(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE0Group(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_SkirmishAI_Info_getKey(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_SkirmishAI_Info_getKey(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_isTurret(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isTurret(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_0MULTI1FETCH3UnitDefByName0UnitDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1FETCH3UnitDefByName0UnitDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_getMaxRange(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_getMaxRange(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getSonarRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getSonarRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_getElevationAt(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_getElevationAt(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyFloat_AsDouble(PyTuple_GetItem(args, 1)),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_Line_getSecondPosition(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Map_Line_getSecondPosition(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_UnitDef_isAssistable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAssistable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_SupportedCommand_0ARRAY1VALS0getParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char** extra3;
extra3=malloc(sizeof(const char*)*PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
int retval;
retval = callback->Clb_Unit_SupportedCommand_0ARRAY1VALS0getParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)),
	extra3,
	PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyString_FromString(extra3[i]));
FREE(extra3);
return list;
}

PyObject*
Clb_WeaponDef_isLargeBeamLaser(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isLargeBeamLaser(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getMaxHeightDif(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxHeightDif(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_WeaponMount_getMainDir(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_UnitDef_WeaponMount_getMainDir(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_0MULTI1SIZE3EnemyUnits0Unit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3EnemyUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getMinTransportMass(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMinTransportMass(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isFireSubmersed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isFireSubmersed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_FlankingBonus_getMode(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_FlankingBonus_getMode(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getSprayAngle(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getSprayAngle(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getTooltip(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getTooltip(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Unit_getVel(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Unit_getVel(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_Unit_isNeutral(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Unit_isNeutral(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getDance(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getDance(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isAbleToRepair(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToRepair(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_getStartPos(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Map_getStartPos(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_DataDirs_Roots_locatePath(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_DataDirs_Roots_locatePath(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	NULL,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)),
	PyString_AS_STRING(PyTuple_GetItem(args, 3)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,4)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,5)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,6)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0getMakesResource(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0getMakesResource(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_CurrentCommand_getOptions(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned char retval;
retval = callback->Clb_Unit_CurrentCommand_getOptions(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Unit_CurrentCommand_getId(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_CurrentCommand_getId(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Group_SupportedCommand_getToolTip(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Group_SupportedCommand_getToolTip(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Game_isAllied(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Game_isAllied(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_0REF1Resource2resourceId0getResourceMake(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_0REF1Resource2resourceId0getResourceMake(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isSoundTrigger(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isSoundTrigger(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getMaxAcceleration(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxAcceleration(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0getResourceExtractorRange(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0getResourceExtractorRange(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Shield_getMaxSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Shield_getMaxSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0getStorage(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0getStorage(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isReclaimable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isReclaimable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getTurnInPlaceDistance(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTurnInPlaceDistance(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1SIZE0Feature(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE0Feature(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getCegTag(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_WeaponDef_getCegTag(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_0MULTI1SIZE0UnitDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE0UnitDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getVerticalSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getVerticalSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getFireAtCrashing(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getFireAtCrashing(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getEdgeEffectiveness(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getEdgeEffectiveness(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getLeadBonus(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getLeadBonus(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_CurrentCommand_0STATIC0getType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_CurrentCommand_0STATIC0getType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Economy_0REF1Resource2resourceId0getStorage(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Economy_0REF1Resource2resourceId0getStorage(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Group_OrderPreview_getTag(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_Group_OrderPreview_getTag(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsNearest(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsNearest(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	*(build_SAIFloat3(PyTuple_GetItem(args,2))));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_0MULTI1VALS3SelectedUnits0Unit(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS3SelectedUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_DataDirs_Roots_allocatePath(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
char* retval;
retval = callback->Clb_DataDirs_Roots_allocatePath(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,2)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,3)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,4)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_Damage_getCraterMult(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Damage_getCraterMult(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Shield_getPower(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Shield_getPower(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isShield(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isShield(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Feature_getPosition(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Feature_getPosition(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0getCost(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0getCost(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getLosHeight(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getLosHeight(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isAbleToRepeat(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToRepeat(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getCloakCostMoving(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getCloakCostMoving(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getSalvoDelay(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getSalvoDelay(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Game_getMyAllyTeam(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Game_getMyAllyTeam(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_FeatureDef_getMass(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_FeatureDef_getMass(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_getMinWind(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_getMinWind(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getMinCollisionSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMinCollisionSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Game_getCurrentFrame(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Game_getCurrentFrame(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getZSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getZSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Game_getMyTeam(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Game_getMyTeam(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getMultiReclaim(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getMultiReclaim(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_SkirmishAI_Info_getSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_SkirmishAI_Info_getSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_SkirmishAI_Info_getValueByKey(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_SkirmishAI_Info_getValueByKey(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getFireState(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getFireState(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isDontLand(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isDontLand(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_getGravity(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_getGravity(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isTransportByEnemy(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isTransportByEnemy(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isTurnInPlace(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isTurnInPlace(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getReclaimSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getReclaimSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isNoExplode(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isNoExplode(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Cheats_setEnabled(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Cheats_setEnabled(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_MoveData_getMaxAcceleration(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_MoveData_getMaxAcceleration(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_getCurWind(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_getCurWind(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_getResurrectable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_FeatureDef_getResurrectable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_MoveData_getPathType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_MoveData_getPathType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isSonarStealth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isSonarStealth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_FlankingBonus_getMobilityAdd(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_FlankingBonus_getMobilityAdd(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getShortName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Mod_getShortName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getPower(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getPower(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getCollisionFlags(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_WeaponDef_getCollisionFlags(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isWaterBounce(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isWaterBounce(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getLeadLimit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getLeadLimit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_0MULTI1SIZE0ModParam(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_0MULTI1SIZE0ModParam(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_0MULTI1SIZE0FeatureDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE0FeatureDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getHumanName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Mod_getHumanName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getAutoHeal(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getAutoHeal(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getTargetable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getTargetable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isVisibleShieldRepulse(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isVisibleShieldRepulse(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getTrackWidth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTrackWidth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_SkirmishAI_OptionValues_getKey(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_SkirmishAI_OptionValues_getKey(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getTurnRate(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTurnRate(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_0MULTI1SIZE0Point(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0MULTI1SIZE0Point(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isFullHealthFactory(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isFullHealthFactory(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Mod_getReclaimAllowEnemies(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Mod_getReclaimAllowEnemies(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_0MULTI1SIZE3NeutralUnitsIn0Unit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3NeutralUnitsIn0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	*(build_SAIFloat3(PyTuple_GetItem(args,1))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getBuildDistance(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getBuildDistance(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getBuildingDecalType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getBuildingDecalType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isBeamBurst(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isBeamBurst(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_getChecksum(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_Map_getChecksum(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_CurrentCommand_getTag(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_Unit_CurrentCommand_getTag(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isHideDamage(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isHideDamage(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getTransportCapacity(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getTransportCapacity(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_getCurrentFuel(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_getCurrentFuel(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_SkirmishAI_Info_getValue(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_SkirmishAI_Info_getValue(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0getResourceMake(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0getResourceMake(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Engine_Version_getPatchset(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Engine_Version_getPatchset(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_isShowPlayerName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isShowPlayerName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_Damage_getParalyzeDamageTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_Damage_getParalyzeDamageTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getDuration(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getDuration(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_SkirmishAI_OptionValues_getValueByKey(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_SkirmishAI_OptionValues_getValueByKey(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getSelfDExplosion(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getSelfDExplosion(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getMaxWeaponRange(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxWeaponRange(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getConstructionDecaySpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Mod_getConstructionDecaySpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getRepairEnergyCostFactor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Mod_getRepairEnergyCostFactor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_FlankingBonus_getMin(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_FlankingBonus_getMin(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1SIZE3EnemyUnitsInRadarAndLos0Unit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3EnemyUnitsInRadarAndLos0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getDynDamageRange(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getDynDamageRange(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_getAiHint(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_getAiHint(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_getMinHeight(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_getMinHeight(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_getSmokeTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_FeatureDef_getSmokeTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Resource_getOptimum(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Resource_getOptimum(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getCylinderTargetting(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getCylinderTargetting(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getRefuelTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getRefuelTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_0ARRAY1SIZE0getCornersHeightMap(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0ARRAY1SIZE0getCornersHeightMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Game_getMode(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Game_getMode(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getReclaimAllowAllies(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Mod_getReclaimAllowAllies(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isAbleToAssist(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToAssist(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getCoreThickness(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getCoreThickness(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1VALS0FeatureDef(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS0FeatureDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_Map_0ARRAY1SIZE0getRadarMap(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0ARRAY1SIZE0getRadarMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getFallSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getFallSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_getDeathFeature(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_FeatureDef_getDeathFeature(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_getCameraShake(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getCameraShake(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0getUpkeep(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0getUpkeep(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_isDestructable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_FeatureDef_isDestructable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_0MULTI1SIZE0Line(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0MULTI1SIZE0Line(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_0MULTI1SIZE3FeaturesIn0Feature(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3FeaturesIn0Feature(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	*(build_SAIFloat3(PyTuple_GetItem(args,1))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_FeatureDef_getModelName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_FeatureDef_getModelName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_getSalvoSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getSalvoSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_Line_getColor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Map_Line_getColor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0getExtractsResource(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0getExtractsResource(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Teams_getSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Teams_getSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getTransportShip(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getTransportShip(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getFlareReloadTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getFlareReloadTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getDecloakDistance(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getDecloakDistance(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isHoldSteady(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isHoldSteady(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isFloater(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isFloater(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getRange(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getRange(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_SupportedCommand_isShowUnique(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Unit_SupportedCommand_isShowUnique(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_0MULTI1VALS3EnemyUnitsInRadarAndLos0Unit(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS3EnemyUnitsInRadarAndLos0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_WeaponDef_Shield_getStartingPower(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Shield_getStartingPower(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getLosRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getLosRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getXSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getXSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_FeatureDef_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_FeatureDef_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Mod_getAirLosMul(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Mod_getAirLosMul(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_0AVAILABLE0MoveData(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_0AVAILABLE0MoveData(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Group_0MULTI1SIZE0SupportedCommand(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Group_0MULTI1SIZE0SupportedCommand(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_0REF1Resource2resourceId0getContainedResource(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_FeatureDef_0REF1Resource2resourceId0getContainedResource(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_0STATIC0getLimit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_0STATIC0getLimit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapRaw(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapRaw(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getRepairSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getRepairSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Shield_getInterceptType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_WeaponDef_Shield_getInterceptType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isAbleToFight(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToFight(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getTargetBorder(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getTargetBorder(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getInterceptor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getInterceptor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_Shield_getGoodColor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_WeaponDef_Shield_getGoodColor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_Engine_Version_getMajor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Engine_Version_getMajor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_Shield_0REF1Resource2resourceId0getPowerRegenResource(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Shield_0REF1Resource2resourceId0getPowerRegenResource(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_MoveData_getDepthMod(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_MoveData_getDepthMod(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isAbleToSelfRepair(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToSelfRepair(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_0MAP1VALS0getCustomParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char** extra2;
	int size = callback->Clb_WeaponDef_0MAP1SIZE0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1))
		);
	extra2=malloc(sizeof(const char*)*size);
	callback->Clb_WeaponDef_0MAP1VALS0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2);
list = PyList_New(size);
for (i=0;i<size;i++) PyList_SetItem(list, i, PyString_FromString(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_Game_getAiInterfaceVersion(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Game_getAiInterfaceVersion(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_FeatureDef_isReclaimable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_FeatureDef_isReclaimable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_0MULTI1VALS3NeutralUnitsIn0Unit(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra3;
extra3=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
int retval;
retval = callback->Clb_0MULTI1VALS3NeutralUnitsIn0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	*(build_SAIFloat3(PyTuple_GetItem(args,1))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)),
	extra3,
	PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra3[i]));
FREE(extra3);
return list;
}

PyObject*
Clb_UnitDef_getAiHint(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getAiHint(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getReclaimUnitMethod(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getReclaimUnitMethod(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isAvoidFeature(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isAvoidFeature(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getBeamTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getBeamTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_0SINGLE1FETCH2UnitDef0getDecoyDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_0SINGLE1FETCH2UnitDef0getDecoyDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isDropped(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isDropped(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getTargetMoveError(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getTargetMoveError(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isNoSelfDamage(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isNoSelfDamage(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getFlareDelay(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getFlareDelay(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getIdleAutoHeal(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getIdleAutoHeal(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_0MAP1KEYS0getCustomParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char** extra2;
	int size = callback->Clb_WeaponDef_0MAP1SIZE0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1))
		);
	extra2=malloc(sizeof(const char*)*size);
	callback->Clb_WeaponDef_0MAP1KEYS0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2);
list = PyList_New(size);
for (i=0;i<size;i++) PyList_SetItem(list, i, PyString_FromString(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_Resource_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Resource_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_isAbleToFly(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToFly(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getTransportUnloadMethod(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getTransportUnloadMethod(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0getWindResourceGenerator(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0getWindResourceGenerator(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isAbleToMove(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToMove(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_SkirmishAIs_getMax(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_SkirmishAIs_getMax(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_Point_getLabel(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Map_Point_getLabel(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_0STATIC0getNumDamageTypes(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_0STATIC0getNumDamageTypes(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getInterceptedByShieldType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_WeaponDef_getInterceptedByShieldType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getTrackOffset(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTrackOffset(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_FeatureDef_getXSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_FeatureDef_getXSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isFixedLauncher(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isFixedLauncher(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_Shield_getBadColor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_WeaponDef_Shield_getBadColor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_UnitDef_getCobId(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getCobId(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getFlareEfficiency(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getFlareEfficiency(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_0ARRAY1SIZE1UnitDef0getBuildOptions(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_0ARRAY1SIZE1UnitDef0getBuildOptions(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0getLosMap(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned short* extra1;
extra1=malloc(sizeof(unsigned short)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_Map_0ARRAY1VALS0getLosMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_UnitDef_getSeismicRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getSeismicRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isNotTransportable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isNotTransportable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Mod_getReclaimUnitEfficiency(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Mod_getReclaimUnitEfficiency(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1SIZE3FriendlyUnits0Unit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3FriendlyUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getResurrectSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getResurrectSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getHeight(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getHeight(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getWingAngle(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getWingAngle(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isPushResistant(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isPushResistant(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getBuildingDecalSizeY(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getBuildingDecalSizeY(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getBuildingDecalSizeX(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getBuildingDecalSizeX(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_0REF1Resource2resourceId0getExtractorRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_0REF1Resource2resourceId0getExtractorRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getMinWaterDepth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMinWaterDepth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isAirStrafe(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAirStrafe(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_0REF1Resource2resourceId0getResourceUse(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_0REF1Resource2resourceId0getResourceUse(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isAbleToSubmerge(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToSubmerge(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Engine_Version_getNormal(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Engine_Version_getNormal(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_FeatureDef_isBurnable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_FeatureDef_isBurnable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_DataDirs_Roots_getSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_DataDirs_Roots_getSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Group_OrderPreview_0ARRAY1SIZE0getParams(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Group_OrderPreview_0ARRAY1SIZE0getParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_MoveData_getMaxBreaking(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_MoveData_getMaxBreaking(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getCaptureEnergyCostFactor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Mod_getCaptureEnergyCostFactor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getTrackStretch(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTrackStretch(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_0ARRAY1SIZE0getHeightMap(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0ARRAY1SIZE0getHeightMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isSweepFire(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isSweepFire(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_FeatureDef_isFloating(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_FeatureDef_isFloating(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_FeatureDef_isUpright(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_FeatureDef_isUpright(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getMaxDeceleration(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxDeceleration(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_getPos(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Unit_getPos(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_UnitDef_getDeathExplosion(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getDeathExplosion(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Unit_isCloaked(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Unit_isCloaked(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getIdleTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getIdleTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Cheats_isOnlyPassive(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Cheats_isOnlyPassive(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_FeatureDef_getDrawType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_FeatureDef_getDrawType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getWingDrag(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getWingDrag(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Damage_getImpulseFactor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Damage_getImpulseFactor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapSpotsPositions(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapSpotsPositions(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isTargetingFacility(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isTargetingFacility(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_SupportedCommand_getToolTip(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Unit_SupportedCommand_getToolTip(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_isStartCloaked(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isStartCloaked(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getIntensity(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getIntensity(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_MoveData_getDepth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_MoveData_getDepth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1VALS0Feature(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS0Feature(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_UnitDef_isAbleToHover(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToHover(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getFireStarter(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getFireStarter(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getMaxRudder(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxRudder(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getTechLevel(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getTechLevel(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getLoadingRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getLoadingRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_0REF1Resource2resourceId0getCost(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_0REF1Resource2resourceId0getCost(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_SkirmishAI_OptionValues_getValue(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_SkirmishAI_OptionValues_getValue(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_getGraphicsType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getGraphicsType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Engine_Version_getFull(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Engine_Version_getFull(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_isAbleToCloak(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToCloak(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Mod_getVersion(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Mod_getVersion(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_0MULTI1VALS3EnemyUnits0Unit(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS3EnemyUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_WeaponDef_getExplosionSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getExplosionSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_isActivated(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Unit_isActivated(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Economy_0REF1Resource2resourceId0getUsage(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Economy_0REF1Resource2resourceId0getUsage(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getAirMipLevel(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getAirMipLevel(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_WeaponMount_getOnlyTargetCategory(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_UnitDef_WeaponMount_getOnlyTargetCategory(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_WeaponMount_getBadTargetCategory(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned int retval;
retval = callback->Clb_UnitDef_WeaponMount_getBadTargetCategory(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isOnlyForward(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isOnlyForward(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_0ARRAY1SIZE0getSlopeMap(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0ARRAY1SIZE0getSlopeMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getMaxThisUnit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getMaxThisUnit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getResurrectEnergyCostFactor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Mod_getResurrectEnergyCostFactor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getReclaimFeatureEnergyCostFactor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Mod_getReclaimFeatureEnergyCostFactor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Game_isExceptionHandlingEnabled(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Game_isExceptionHandlingEnabled(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getTrackType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getTrackType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isNeedGeo(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isNeedGeo(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isCommander(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isCommander(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isAirBase(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAirBase(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_FlankingBonus_getMax(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_FlankingBonus_getMax(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Log_exception(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
callback->Clb_Log_exception(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,3)));
return Py_None;
}

PyObject*
Clb_UnitDef_isAbleToLoopbackAttack(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToLoopbackAttack(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getProximityPriority(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getProximityPriority(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isLeaveTracks(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isLeaveTracks(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0getJammerMap(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
unsigned short* extra1;
extra1=malloc(sizeof(unsigned short)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_Map_0ARRAY1VALS0getJammerMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_0MULTI1SIZE3FriendlyUnitsIn0Unit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3FriendlyUnitsIn0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	*(build_SAIFloat3(PyTuple_GetItem(args,1))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isCapturable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isCapturable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_SupportedCommand_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Unit_SupportedCommand_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_0ARRAY1VALS1UnitDef0getBuildOptions(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra2;
extra2=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
int retval;
retval = callback->Clb_UnitDef_0ARRAY1VALS1UnitDef0getBuildOptions(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2,
	PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_WeaponDef_getDynDamageMin(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getDynDamageMin(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Damage_0ARRAY1VALS0getTypes(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float* extra2;
extra2=malloc(sizeof(float)*PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
int retval;
retval = callback->Clb_WeaponDef_Damage_0ARRAY1VALS0getTypes(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2,
	PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyFloat_FromDouble(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_WeaponDef_isImpactOnly(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isImpactOnly(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_isAvoidFriendly(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isAvoidFriendly(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Group_SupportedCommand_isShowUnique(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Group_SupportedCommand_isShowUnique(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_getHumanName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Map_getHumanName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_0MAP1SIZE0getCustomParams(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_0MAP1SIZE0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_DataDirs_getConfigDir(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_DataDirs_getConfigDir(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getFlareSalvoDelay(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getFlareSalvoDelay(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isAbleToGuard(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToGuard(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_getAllyTeam(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_getAllyTeam(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_getMaxHeight(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_getMaxHeight(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_0MAP1SIZE0getCustomParams(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_0MAP1SIZE0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getThickness(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getThickness(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isSmartShield(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isSmartShield(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Mod_getRequireSonarUnderWater(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Mod_getRequireSonarUnderWater(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Mod_getLosMipLevel(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getLosMipLevel(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getSelfDCountdown(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getSelfDCountdown(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getMoveState(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getMoveState(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Map_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_0MULTI1SIZE3TeamUnits0Unit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3TeamUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getWobble(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getWobble(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1VALS0Group(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS0Group(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_0MULTI1SIZE0WeaponDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE0WeaponDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Cheats_setEventsEnabled(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Cheats_setEventsEnabled(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isAbleToCapture(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToCapture(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isUseBuildingGroundDecal(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isUseBuildingGroundDecal(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getMaxBank(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxBank(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Game_getTeamColor(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Game_getTeamColor(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_WeaponDef_getStockpileTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getStockpileTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getBuildSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getBuildSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Shield_getAlpha(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Shield_getAlpha(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getTurnInPlaceSpeedLimit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTurnInPlaceSpeedLimit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isStockpileable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isStockpileable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_0MULTI1VALS0UnitDef(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS0UnitDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_Log_log(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
callback->Clb_Log_log(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)));
return Py_None;
}

PyObject*
Clb_WeaponDef_isTracks(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isTracks(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_0MULTI1SIZE1Command0CurrentCommand(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_0MULTI1SIZE1Command0CurrentCommand(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_WeaponMount_getSlavedTo(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_WeaponMount_getSlavedTo(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getBuildingDecalDecaySpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getBuildingDecalDecaySpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Debug_Drawer_isEnabled(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Debug_Drawer_isEnabled(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_isGroundBounce(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isGroundBounce(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getArmorType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getArmorType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_0MULTI1SIZE0SupportedCommand(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_0MULTI1SIZE0SupportedCommand(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isOnOffable(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isOnOffable(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getProjectilesPerShot(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getProjectilesPerShot(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_isBeingBuilt(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Unit_isBeingBuilt(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getMaxSlope(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxSlope(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_DataDirs_getWriteableDir(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_DataDirs_getWriteableDir(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Mod_getFileName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Mod_getFileName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_0MULTI1VALS3TeamUnits0Unit(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS3TeamUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_WeaponDef_Shield_getRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Shield_getRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getHealth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getHealth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getFrontToSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getFrontToSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isAbleToReclaim(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToReclaim(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isLevelGround(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isLevelGround(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getMaxPitch(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxPitch(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isSelfExplode(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isSelfExplode(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_MoveData_getMaxSlope(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_MoveData_getMaxSlope(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getWreckName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getWreckName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_getBounceRebound(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getBounceRebound(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getUnitFallSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getUnitFallSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getFileName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_WeaponDef_getFileName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Mod_getDescription(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Mod_getDescription(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Unit_CurrentCommand_0ARRAY1VALS0getParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float* extra3;
extra3=malloc(sizeof(float)*PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
int retval;
retval = callback->Clb_Unit_CurrentCommand_0ARRAY1VALS0getParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)),
	extra3,
	PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyFloat_FromDouble(extra3[i]));
FREE(extra3);
return list;
}

PyObject*
Clb_WeaponDef_getHeightMod(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getHeightMod(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_0REF1UnitDef2unitDefId0isPossibleToBuildAt(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Map_0REF1UnitDef2unitDefId0isPossibleToBuildAt(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	*(build_SAIFloat3(PyTuple_GetItem(args,2))),
	PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_0MULTI1SIZE3NeutralUnits0Unit(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE3NeutralUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getUpTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getUpTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getSonarJamRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getSonarJamRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_WeaponMount_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_WeaponMount_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Game_getTeamAllyTeam(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Game_getTeamAllyTeam(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Gui_Camera_getDirection(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Gui_Camera_getDirection(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_Engine_handleCommand(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
void* commandData=command_convert((int)PyInt_AS_LONG(PyTuple_GetItem(args, 3)), PyTuple_GetItem(args, 4));
int retval;
retval = callback->Clb_Engine_handleCommand(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 3)),
	commandData);
PyObject *pyreturn=command_reverse((int)PyInt_AS_LONG(PyTuple_GetItem(args, 3)),commandData);
FREE(commandData);
return pyreturn;
}

PyObject*
Clb_WeaponDef_getMaxAngle(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getMaxAngle(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Engine_Version_getAdditional(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Engine_Version_getAdditional(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Unit_getStockpile(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_getStockpile(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getAccuracy(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getAccuracy(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1FETCH3ResourceByName0Resource(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1FETCH3ResourceByName0Resource(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isWaterWeapon(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isWaterWeapon(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_0MULTI1VALS3EnemyUnitsIn0Unit(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra3;
extra3=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
int retval;
retval = callback->Clb_0MULTI1VALS3EnemyUnitsIn0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	*(build_SAIFloat3(PyTuple_GetItem(args,1))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)),
	extra3,
	PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra3[i]));
FREE(extra3);
return list;
}

PyObject*
Clb_UnitDef_getBuildTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getBuildTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_0MAP1VALS0getCustomParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char** extra2;
	int size = callback->Clb_UnitDef_0MAP1SIZE0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1))
		);
	extra2=malloc(sizeof(const char*)*size);
	callback->Clb_UnitDef_0MAP1VALS0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2);
list = PyList_New(size);
for (i=0;i<size;i++) PyList_SetItem(list, i, PyString_FromString(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_WeaponDef_getSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1SIZE0Resource(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_0MULTI1SIZE0Resource(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_SupportedCommand_isDisabled(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Unit_SupportedCommand_isDisabled(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_MoveData_getMoveType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_MoveData_getMoveType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isActivateWhenBuilt(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isActivateWhenBuilt(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isAbleToPatrol(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToPatrol(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getDescription(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_WeaponDef_getDescription(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_getMovingAccuracy(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getMovingAccuracy(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getMinTransportSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getMinTransportSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isAbleToRestore(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToRestore(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0getSlopeMap(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float* extra1;
extra1=malloc(sizeof(float)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_Map_0ARRAY1VALS0getSlopeMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyFloat_FromDouble(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_WeaponDef_isGravityAffected(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isGravityAffected(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getType(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_WeaponDef_getType(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_0MULTI1VALS3FeaturesIn0Feature(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra3;
extra3=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
int retval;
retval = callback->Clb_0MULTI1VALS3FeaturesIn0Feature(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	*(build_SAIFloat3(PyTuple_GetItem(args,1))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)),
	extra3,
	PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra3[i]));
FREE(extra3);
return list;
}

PyObject*
Clb_UnitDef_isHoverAttack(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isHoverAttack(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_MoveData_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_MoveData_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getGaia(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getGaia(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_getLaserFlareSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getLaserFlareSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_WeaponMount_getMaxAngleDif(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_WeaponMount_getMaxAngleDif(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getConstructionDecayTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getConstructionDecayTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getRestTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getRestTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getMass(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMass(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Group_SupportedCommand_isDisabled(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Group_SupportedCommand_isDisabled(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Map_isPosInCamera(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Map_isPosInCamera(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	*(build_SAIFloat3(PyTuple_GetItem(args,1))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_0REF1Resource2resourceId0getTidalResourceGenerator(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_0REF1Resource2resourceId0getTidalResourceGenerator(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isBuilder(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isBuilder(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Mod_getFlankingBonusModeDefault(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getFlankingBonusModeDefault(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_getTransportMass(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTransportMass(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_DataDirs_locatePath(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_DataDirs_locatePath(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	NULL,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)),
	PyString_AS_STRING(PyTuple_GetItem(args, 3)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,4)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,5)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,6)),
	(bool)PyInt_AS_LONG(PyTuple_GetItem(args,7)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Feature_0SINGLE1FETCH2FeatureDef0getDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Feature_0SINGLE1FETCH2FeatureDef0getDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_getMaxSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_getMaxSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getMaxAileron(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxAileron(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getControlRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getControlRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Game_getSetupScript(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Game_getSetupScript(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_SkirmishAI_OptionValues_getSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_SkirmishAI_OptionValues_getSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsAverageIncome(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsAverageIncome(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_DataDirs_Roots_getDir(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_DataDirs_Roots_getDir(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	NULL,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getMaxWaterDepth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxWaterDepth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Map_0ARRAY1SIZE0getLosMap(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0ARRAY1SIZE0getLosMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getAreaOfEffect(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getAreaOfEffect(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_0MULTI1VALS3FriendlyUnits0Unit(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra1;
extra1=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
int retval;
retval = callback->Clb_0MULTI1VALS3FriendlyUnits0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	extra1,
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra1[i]));
FREE(extra1);
return list;
}

PyObject*
Clb_UnitDef_getTrackStrength(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTrackStrength(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getTerraformSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getTerraformSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_Damage_getCraterBoost(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Damage_getCraterBoost(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isAbleToFireControl(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToFireControl(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getTurnRate(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getTurnRate(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Unit_getBuildingFacing(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_getBuildingFacing(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isAbleToSelfD(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToSelfD(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_MoveData_getMaxSpeed(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_MoveData_getMaxSpeed(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_isUpright(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isUpright(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isBuildRange3D(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isBuildRange3D(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_FeatureDef_getMaxHealth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_FeatureDef_getMaxHealth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Game_isPaused(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Game_isPaused(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_isNoAutoTarget(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isNoAutoTarget(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isFirePlatform(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isFirePlatform(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Unit_SupportedCommand_0ARRAY1SIZE0getParams(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_SupportedCommand_0ARRAY1SIZE0getParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getTransportAir(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getTransportAir(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_isVisibleShield(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isVisibleShield(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getBuildAngle(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getBuildAngle(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getReclaimMethod(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getReclaimMethod(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isAbleToDropFlare(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToDropFlare(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_isFactoryHeadingTakeoff(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isFactoryHeadingTakeoff(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Feature_getHealth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Feature_getHealth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Engine_Version_getBuildTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Engine_Version_getBuildTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_0MULTI1VALS3FriendlyUnitsIn0Unit(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int* extra3;
extra3=malloc(sizeof(int)*PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
int retval;
retval = callback->Clb_0MULTI1VALS3FriendlyUnitsIn0Unit(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	*(build_SAIFloat3(PyTuple_GetItem(args,1))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 2)),
	extra3,
	PyInt_AS_LONG(PyTuple_GetItem(args, 4)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyInt_FromLong(extra3[i]));
FREE(extra3);
return list;
}

PyObject*
Clb_File_getSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_File_getSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyString_AS_STRING(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_0MULTI1SIZE0ResourceInfo(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_0MULTI1SIZE0ResourceInfo(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Group_OrderPreview_0ARRAY1VALS0getParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float* extra2;
extra2=malloc(sizeof(float)*PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
int retval;
retval = callback->Clb_Group_OrderPreview_0ARRAY1VALS0getParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2,
	PyInt_AS_LONG(PyTuple_GetItem(args, 3)));
list = PyList_New(retval);
for (i=0;i<retval;i++) PyList_SetItem(list, i, PyFloat_FromDouble(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getStockpileDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getStockpileDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isAbleToResurrect(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isAbleToResurrect(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_DataDirs_getPathSeparator(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
char retval;
retval = callback->Clb_DataDirs_getPathSeparator(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_UnitDef_getFileName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_UnitDef_getFileName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_Unit_getHealth(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_Unit_getHealth(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getConstructionDecay(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Mod_getConstructionDecay(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_getMyGravity(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_getMyGravity(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getRadius(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getRadius(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getFlareSalvoSize(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_getFlareSalvoSize(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_isDecloakSpherical(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_UnitDef_isDecloakSpherical(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getMaxFuel(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getMaxFuel(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_UnitDef_getSlideTolerance(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getSlideTolerance(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_isAbleToAttackGround(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_WeaponDef_isAbleToAttackGround(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_UnitDef_getKamikazeDist(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_UnitDef_getKamikazeDist(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_WeaponDef_getHighTrajectory(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getHighTrajectory(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Mod_getFireAtKilled(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Mod_getFireAtKilled(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_WeaponDef_getFlightTime(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getFlightTime(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_0REF1UnitDef2unitDefId0findClosestBuildSite(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
struct SAIFloat3 retval;
retval = callback->Clb_Map_0REF1UnitDef2unitDefId0findClosestBuildSite(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	*(build_SAIFloat3(PyTuple_GetItem(args,2))),
	PyFloat_AsDouble(PyTuple_GetItem(args, 3)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 4)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 5)));
return Py_BuildValue("O", convert_SAIFloat3(&retval));
}

PyObject*
Clb_UnitDef_MoveData_getMoveFamily(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_MoveData_getMoveFamily(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getShieldDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getShieldDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_FeatureDef_0MAP1VALS0getCustomParams(PyObject* ob, PyObject* args)
{
  PyObject* list;
int i;
const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char** extra2;
	int size = callback->Clb_FeatureDef_0MAP1SIZE0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1))
		);
	extra2=malloc(sizeof(const char*)*size);
	callback->Clb_FeatureDef_0MAP1VALS0getCustomParams(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	extra2);
list = PyList_New(size);
for (i=0;i<size;i++) PyList_SetItem(list, i, PyString_FromString(extra2[i]));
FREE(extra2);
return list;
}

PyObject*
Clb_UnitDef_0MULTI1SIZE0WeaponMount(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_UnitDef_0MULTI1SIZE0WeaponMount(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Unit_0SINGLE1FETCH2UnitDef0getDef(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Unit_0SINGLE1FETCH2UnitDef0getDef(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Map_0ARRAY1SIZE0getJammerMap(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_Map_0ARRAY1SIZE0getJammerMap(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_FeatureDef_isNoSelect(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_FeatureDef_isNoSelect(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_Group_SupportedCommand_getName(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Group_SupportedCommand_getName(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 2)));
return Py_BuildValue("s", retval);
}

PyObject*
Clb_WeaponDef_getLodDistance(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
int retval;
retval = callback->Clb_WeaponDef_getLodDistance(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("i", retval);
}

PyObject*
Clb_Game_isDebugModeEnabled(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
bool retval;
retval = callback->Clb_Game_isDebugModeEnabled(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("i", (int)retval);
}

PyObject*
Clb_WeaponDef_Shield_getPowerRegen(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
float retval;
retval = callback->Clb_WeaponDef_Shield_getPowerRegen(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)),
	PyInt_AS_LONG(PyTuple_GetItem(args, 1)));
return Py_BuildValue("f", retval);
}

PyObject*
Clb_Mod_getMutator(PyObject* ob, PyObject* args)
{
  const struct SSkirmishAICallback* callback = ((PyAICallbackObject*)ob)->callback;
const char* retval;
retval = callback->Clb_Mod_getMutator(
	PyInt_AS_LONG(PyTuple_GetItem(args, 0)));
return Py_BuildValue("s", retval);
}


static PyMethodDef callback_methods[] = {

     {"Clb_UnitDef_WeaponMount_getFuelUsage", (PyCFunction)Clb_UnitDef_WeaponMount_getFuelUsage, METH_VARARGS, "Clb_UnitDef_WeaponMount_getFuelUsage" },

     {"Clb_Game_getSpeedFactor", (PyCFunction)Clb_Game_getSpeedFactor, METH_VARARGS, "Clb_Game_getSpeedFactor" },

     {"Clb_Unit_CurrentCommand_getTimeOut", (PyCFunction)Clb_Unit_CurrentCommand_getTimeOut, METH_VARARGS, "Clb_Unit_CurrentCommand_getTimeOut" },

     {"Clb_Map_0ARRAY1VALS0getHeightMap", (PyCFunction)Clb_Map_0ARRAY1VALS0getHeightMap, METH_VARARGS, "Clb_Map_0ARRAY1VALS0getHeightMap" },

     {"Clb_UnitDef_MoveData_getSize", (PyCFunction)Clb_UnitDef_MoveData_getSize, METH_VARARGS, "Clb_UnitDef_MoveData_getSize" },

     {"Clb_UnitDef_getDlHoverFactor", (PyCFunction)Clb_UnitDef_getDlHoverFactor, METH_VARARGS, "Clb_UnitDef_getDlHoverFactor" },

     {"Clb_UnitDef_0MAP1KEYS0getCustomParams", (PyCFunction)Clb_UnitDef_0MAP1KEYS0getCustomParams, METH_VARARGS, "Clb_UnitDef_0MAP1KEYS0getCustomParams" },

     {"Clb_Unit_ModParam_getValue", (PyCFunction)Clb_Unit_ModParam_getValue, METH_VARARGS, "Clb_Unit_ModParam_getValue" },

     {"Clb_Feature_getReclaimLeft", (PyCFunction)Clb_Feature_getReclaimLeft, METH_VARARGS, "Clb_Feature_getReclaimLeft" },

     {"Clb_UnitDef_getName", (PyCFunction)Clb_UnitDef_getName, METH_VARARGS, "Clb_UnitDef_getName" },

     {"Clb_Map_0REF1Resource2resourceId0getMaxResource", (PyCFunction)Clb_Map_0REF1Resource2resourceId0getMaxResource, METH_VARARGS, "Clb_Map_0REF1Resource2resourceId0getMaxResource" },

     {"Clb_Unit_getPower", (PyCFunction)Clb_Unit_getPower, METH_VARARGS, "Clb_Unit_getPower" },

     {"Clb_WeaponDef_getBounceSlip", (PyCFunction)Clb_WeaponDef_getBounceSlip, METH_VARARGS, "Clb_WeaponDef_getBounceSlip" },

     {"Clb_FeatureDef_isGeoThermal", (PyCFunction)Clb_FeatureDef_isGeoThermal, METH_VARARGS, "Clb_FeatureDef_isGeoThermal" },

     {"Clb_Gui_Camera_getPosition", (PyCFunction)Clb_Gui_Camera_getPosition, METH_VARARGS, "Clb_Gui_Camera_getPosition" },

     {"Clb_UnitDef_getSeismicSignature", (PyCFunction)Clb_UnitDef_getSeismicSignature, METH_VARARGS, "Clb_UnitDef_getSeismicSignature" },

     {"Clb_Group_SupportedCommand_getId", (PyCFunction)Clb_Group_SupportedCommand_getId, METH_VARARGS, "Clb_Group_SupportedCommand_getId" },

     {"Clb_WeaponDef_getStartVelocity", (PyCFunction)Clb_WeaponDef_getStartVelocity, METH_VARARGS, "Clb_WeaponDef_getStartVelocity" },

     {"Clb_UnitDef_isReleaseHeld", (PyCFunction)Clb_UnitDef_isReleaseHeld, METH_VARARGS, "Clb_UnitDef_isReleaseHeld" },

     {"Clb_Unit_getLineage", (PyCFunction)Clb_Unit_getLineage, METH_VARARGS, "Clb_Unit_getLineage" },

     {"Clb_Group_isSelected", (PyCFunction)Clb_Group_isSelected, METH_VARARGS, "Clb_Group_isSelected" },

     {"Clb_WeaponDef_getSizeGrowth", (PyCFunction)Clb_WeaponDef_getSizeGrowth, METH_VARARGS, "Clb_WeaponDef_getSizeGrowth" },

     {"Clb_FeatureDef_0MAP1KEYS0getCustomParams", (PyCFunction)Clb_FeatureDef_0MAP1KEYS0getCustomParams, METH_VARARGS, "Clb_FeatureDef_0MAP1KEYS0getCustomParams" },

     {"Clb_Map_Point_getPosition", (PyCFunction)Clb_Map_Point_getPosition, METH_VARARGS, "Clb_Map_Point_getPosition" },

     {"Clb_WeaponDef_getMinIntensity", (PyCFunction)Clb_WeaponDef_getMinIntensity, METH_VARARGS, "Clb_WeaponDef_getMinIntensity" },

     {"Clb_WeaponDef_Shield_getForce", (PyCFunction)Clb_WeaponDef_Shield_getForce, METH_VARARGS, "Clb_WeaponDef_Shield_getForce" },

     {"Clb_Unit_isParalyzed", (PyCFunction)Clb_Unit_isParalyzed, METH_VARARGS, "Clb_Unit_isParalyzed" },

     {"Clb_Group_SupportedCommand_0ARRAY1VALS0getParams", (PyCFunction)Clb_Group_SupportedCommand_0ARRAY1VALS0getParams, METH_VARARGS, "Clb_Group_SupportedCommand_0ARRAY1VALS0getParams" },

     {"Clb_WeaponDef_getCoverageRange", (PyCFunction)Clb_WeaponDef_getCoverageRange, METH_VARARGS, "Clb_WeaponDef_getCoverageRange" },

     {"Clb_FeatureDef_getReclaimTime", (PyCFunction)Clb_FeatureDef_getReclaimTime, METH_VARARGS, "Clb_FeatureDef_getReclaimTime" },

     {"Clb_UnitDef_getCategory", (PyCFunction)Clb_UnitDef_getCategory, METH_VARARGS, "Clb_UnitDef_getCategory" },

     {"Clb_UnitDef_isAbleToKamikaze", (PyCFunction)Clb_UnitDef_isAbleToKamikaze, METH_VARARGS, "Clb_UnitDef_isAbleToKamikaze" },

     {"Clb_UnitDef_MoveData_getCrushStrength", (PyCFunction)Clb_UnitDef_MoveData_getCrushStrength, METH_VARARGS, "Clb_UnitDef_MoveData_getCrushStrength" },

     {"Clb_WeaponDef_isDynDamageInverted", (PyCFunction)Clb_WeaponDef_isDynDamageInverted, METH_VARARGS, "Clb_WeaponDef_isDynDamageInverted" },

     {"Clb_Game_getTeamSide", (PyCFunction)Clb_Game_getTeamSide, METH_VARARGS, "Clb_Game_getTeamSide" },

     {"Clb_UnitDef_getMyGravity", (PyCFunction)Clb_UnitDef_getMyGravity, METH_VARARGS, "Clb_UnitDef_getMyGravity" },

     {"Clb_UnitDef_getWaterline", (PyCFunction)Clb_UnitDef_getWaterline, METH_VARARGS, "Clb_UnitDef_getWaterline" },

     {"Clb_FeatureDef_getZSize", (PyCFunction)Clb_FeatureDef_getZSize, METH_VARARGS, "Clb_FeatureDef_getZSize" },

     {"Clb_Group_OrderPreview_getId", (PyCFunction)Clb_Group_OrderPreview_getId, METH_VARARGS, "Clb_Group_OrderPreview_getId" },

     {"Clb_UnitDef_MoveData_getFollowGround", (PyCFunction)Clb_UnitDef_MoveData_getFollowGround, METH_VARARGS, "Clb_UnitDef_MoveData_getFollowGround" },

     {"Clb_WeaponDef_getPredictBoost", (PyCFunction)Clb_WeaponDef_getPredictBoost, METH_VARARGS, "Clb_WeaponDef_getPredictBoost" },

     {"Clb_WeaponDef_getHeightBoostFactor", (PyCFunction)Clb_WeaponDef_getHeightBoostFactor, METH_VARARGS, "Clb_WeaponDef_getHeightBoostFactor" },

     {"Clb_UnitDef_getJammerRadius", (PyCFunction)Clb_UnitDef_getJammerRadius, METH_VARARGS, "Clb_UnitDef_getJammerRadius" },

     {"Clb_UnitDef_isStrafeToAttack", (PyCFunction)Clb_UnitDef_isStrafeToAttack, METH_VARARGS, "Clb_UnitDef_isStrafeToAttack" },

     {"Clb_UnitDef_isAbleToAttack", (PyCFunction)Clb_UnitDef_isAbleToAttack, METH_VARARGS, "Clb_UnitDef_isAbleToAttack" },

     {"Clb_WeaponDef_isShieldRepulser", (PyCFunction)Clb_WeaponDef_isShieldRepulser, METH_VARARGS, "Clb_WeaponDef_isShieldRepulser" },

     {"Clb_Map_0ARRAY1VALS0getCornersHeightMap", (PyCFunction)Clb_Map_0ARRAY1VALS0getCornersHeightMap, METH_VARARGS, "Clb_Map_0ARRAY1VALS0getCornersHeightMap" },

     {"Clb_WeaponDef_Damage_getImpulseBoost", (PyCFunction)Clb_WeaponDef_Damage_getImpulseBoost, METH_VARARGS, "Clb_WeaponDef_Damage_getImpulseBoost" },

     {"Clb_UnitDef_isCollide", (PyCFunction)Clb_UnitDef_isCollide, METH_VARARGS, "Clb_UnitDef_isCollide" },

     {"Clb_Unit_CurrentCommand_0ARRAY1SIZE0getParams", (PyCFunction)Clb_Unit_CurrentCommand_0ARRAY1SIZE0getParams, METH_VARARGS, "Clb_Unit_CurrentCommand_0ARRAY1SIZE0getParams" },

     {"Clb_Unit_ModParam_getName", (PyCFunction)Clb_Unit_ModParam_getName, METH_VARARGS, "Clb_Unit_ModParam_getName" },

     {"Clb_WeaponDef_getOnlyTargetCategory", (PyCFunction)Clb_WeaponDef_getOnlyTargetCategory, METH_VARARGS, "Clb_WeaponDef_getOnlyTargetCategory" },

     {"Clb_WeaponDef_getSupplyCost", (PyCFunction)Clb_WeaponDef_getSupplyCost, METH_VARARGS, "Clb_WeaponDef_getSupplyCost" },

     {"Clb_Game_getPlayerTeam", (PyCFunction)Clb_Game_getPlayerTeam, METH_VARARGS, "Clb_Game_getPlayerTeam" },

     {"Clb_UnitDef_getArmoredMultiple", (PyCFunction)Clb_UnitDef_getArmoredMultiple, METH_VARARGS, "Clb_UnitDef_getArmoredMultiple" },

     {"Clb_UnitDef_MoveData_getTerrainClass", (PyCFunction)Clb_UnitDef_MoveData_getTerrainClass, METH_VARARGS, "Clb_UnitDef_MoveData_getTerrainClass" },

     {"Clb_0MULTI1SIZE3SelectedUnits0Unit", (PyCFunction)Clb_0MULTI1SIZE3SelectedUnits0Unit, METH_VARARGS, "Clb_0MULTI1SIZE3SelectedUnits0Unit" },

     {"Clb_UnitDef_getUnloadSpread", (PyCFunction)Clb_UnitDef_getUnloadSpread, METH_VARARGS, "Clb_UnitDef_getUnloadSpread" },

     {"Clb_WeaponDef_getWeaponAcceleration", (PyCFunction)Clb_WeaponDef_getWeaponAcceleration, METH_VARARGS, "Clb_WeaponDef_getWeaponAcceleration" },

     {"Clb_DataDirs_allocatePath", (PyCFunction)Clb_DataDirs_allocatePath, METH_VARARGS, "Clb_DataDirs_allocatePath" },

     {"Clb_Unit_getStockpileQueued", (PyCFunction)Clb_Unit_getStockpileQueued, METH_VARARGS, "Clb_Unit_getStockpileQueued" },

     {"Clb_Mod_getReclaimUnitEnergyCostFactor", (PyCFunction)Clb_Mod_getReclaimUnitEnergyCostFactor, METH_VARARGS, "Clb_Mod_getReclaimUnitEnergyCostFactor" },

     {"Clb_UnitDef_getCaptureSpeed", (PyCFunction)Clb_UnitDef_getCaptureSpeed, METH_VARARGS, "Clb_UnitDef_getCaptureSpeed" },

     {"Clb_WeaponDef_getVisibleShieldHitFrames", (PyCFunction)Clb_WeaponDef_getVisibleShieldHitFrames, METH_VARARGS, "Clb_WeaponDef_getVisibleShieldHitFrames" },

     {"Clb_WeaponDef_isSubMissile", (PyCFunction)Clb_WeaponDef_isSubMissile, METH_VARARGS, "Clb_WeaponDef_isSubMissile" },

     {"Clb_UnitDef_getCategoryString", (PyCFunction)Clb_UnitDef_getCategoryString, METH_VARARGS, "Clb_UnitDef_getCategoryString" },

     {"Clb_Mod_getTransportHover", (PyCFunction)Clb_Mod_getTransportHover, METH_VARARGS, "Clb_Mod_getTransportHover" },

     {"Clb_Unit_SupportedCommand_getId", (PyCFunction)Clb_Unit_SupportedCommand_getId, METH_VARARGS, "Clb_Unit_SupportedCommand_getId" },

     {"Clb_UnitDef_MoveData_getMaxTurnRate", (PyCFunction)Clb_UnitDef_MoveData_getMaxTurnRate, METH_VARARGS, "Clb_UnitDef_MoveData_getMaxTurnRate" },

     {"Clb_0MULTI1FETCH3WeaponDefByName0WeaponDef", (PyCFunction)Clb_0MULTI1FETCH3WeaponDefByName0WeaponDef, METH_VARARGS, "Clb_0MULTI1FETCH3WeaponDefByName0WeaponDef" },

     {"Clb_UnitDef_getMaxRepairSpeed", (PyCFunction)Clb_UnitDef_getMaxRepairSpeed, METH_VARARGS, "Clb_UnitDef_getMaxRepairSpeed" },

     {"Clb_WeaponDef_Damage_0ARRAY1SIZE0getTypes", (PyCFunction)Clb_WeaponDef_Damage_0ARRAY1SIZE0getTypes, METH_VARARGS, "Clb_WeaponDef_Damage_0ARRAY1SIZE0getTypes" },

     {"Clb_WeaponDef_isParalyzer", (PyCFunction)Clb_WeaponDef_isParalyzer, METH_VARARGS, "Clb_WeaponDef_isParalyzer" },

     {"Clb_SkirmishAIs_getSize", (PyCFunction)Clb_SkirmishAIs_getSize, METH_VARARGS, "Clb_SkirmishAIs_getSize" },

     {"Clb_UnitDef_getWantedHeight", (PyCFunction)Clb_UnitDef_getWantedHeight, METH_VARARGS, "Clb_UnitDef_getWantedHeight" },

     {"Clb_WeaponDef_getProjectileSpeed", (PyCFunction)Clb_WeaponDef_getProjectileSpeed, METH_VARARGS, "Clb_WeaponDef_getProjectileSpeed" },

     {"Clb_Economy_0REF1Resource2resourceId0getIncome", (PyCFunction)Clb_Economy_0REF1Resource2resourceId0getIncome, METH_VARARGS, "Clb_Economy_0REF1Resource2resourceId0getIncome" },

     {"Clb_UnitDef_getHighTrajectoryType", (PyCFunction)Clb_UnitDef_getHighTrajectoryType, METH_VARARGS, "Clb_UnitDef_getHighTrajectoryType" },

     {"Clb_Group_OrderPreview_getTimeOut", (PyCFunction)Clb_Group_OrderPreview_getTimeOut, METH_VARARGS, "Clb_Group_OrderPreview_getTimeOut" },

     {"Clb_FeatureDef_getDescription", (PyCFunction)Clb_FeatureDef_getDescription, METH_VARARGS, "Clb_FeatureDef_getDescription" },

     {"Clb_0MULTI1SIZE3EnemyUnitsIn0Unit", (PyCFunction)Clb_0MULTI1SIZE3EnemyUnitsIn0Unit, METH_VARARGS, "Clb_0MULTI1SIZE3EnemyUnitsIn0Unit" },

     {"Clb_Cheats_isEnabled", (PyCFunction)Clb_Cheats_isEnabled, METH_VARARGS, "Clb_Cheats_isEnabled" },

     {"Clb_Engine_Version_getMinor", (PyCFunction)Clb_Engine_Version_getMinor, METH_VARARGS, "Clb_Engine_Version_getMinor" },

     {"Clb_UnitDef_getTransportSize", (PyCFunction)Clb_UnitDef_getTransportSize, METH_VARARGS, "Clb_UnitDef_getTransportSize" },

     {"Clb_Unit_getLastUserOrderFrame", (PyCFunction)Clb_Unit_getLastUserOrderFrame, METH_VARARGS, "Clb_Unit_getLastUserOrderFrame" },

     {"Clb_UnitDef_MoveData_isSubMarine", (PyCFunction)Clb_UnitDef_MoveData_isSubMarine, METH_VARARGS, "Clb_UnitDef_MoveData_isSubMarine" },

     {"Clb_Map_0ARRAY1VALS0getRadarMap", (PyCFunction)Clb_Map_0ARRAY1VALS0getRadarMap, METH_VARARGS, "Clb_Map_0ARRAY1VALS0getRadarMap" },

     {"Clb_UnitDef_getCloakCost", (PyCFunction)Clb_UnitDef_getCloakCost, METH_VARARGS, "Clb_UnitDef_getCloakCost" },

     {"Clb_WeaponDef_Shield_0REF1Resource2resourceId0getResourceUse", (PyCFunction)Clb_WeaponDef_Shield_0REF1Resource2resourceId0getResourceUse, METH_VARARGS, "Clb_WeaponDef_Shield_0REF1Resource2resourceId0getResourceUse" },

     {"Clb_Map_getTidalStrength", (PyCFunction)Clb_Map_getTidalStrength, METH_VARARGS, "Clb_Map_getTidalStrength" },

     {"Clb_UnitDef_getMinAirBasePower", (PyCFunction)Clb_UnitDef_getMinAirBasePower, METH_VARARGS, "Clb_UnitDef_getMinAirBasePower" },

     {"Clb_WeaponDef_getReload", (PyCFunction)Clb_WeaponDef_getReload, METH_VARARGS, "Clb_WeaponDef_getReload" },

     {"Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapRaw", (PyCFunction)Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapRaw, METH_VARARGS, "Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapRaw" },

     {"Clb_FeatureDef_isBlocking", (PyCFunction)Clb_FeatureDef_isBlocking, METH_VARARGS, "Clb_FeatureDef_isBlocking" },

     {"Clb_Gui_getViewRange", (PyCFunction)Clb_Gui_getViewRange, METH_VARARGS, "Clb_Gui_getViewRange" },

     {"Clb_UnitDef_getDrag", (PyCFunction)Clb_UnitDef_getDrag, METH_VARARGS, "Clb_UnitDef_getDrag" },

     {"Clb_UnitDef_getNoChaseCategory", (PyCFunction)Clb_UnitDef_getNoChaseCategory, METH_VARARGS, "Clb_UnitDef_getNoChaseCategory" },

     {"Clb_UnitDef_WeaponMount_0SINGLE1FETCH2WeaponDef0getWeaponDef", (PyCFunction)Clb_UnitDef_WeaponMount_0SINGLE1FETCH2WeaponDef0getWeaponDef, METH_VARARGS, "Clb_UnitDef_WeaponMount_0SINGLE1FETCH2WeaponDef0getWeaponDef" },

     {"Clb_WeaponDef_getCollisionSize", (PyCFunction)Clb_WeaponDef_getCollisionSize, METH_VARARGS, "Clb_WeaponDef_getCollisionSize" },

     {"Clb_Mod_getHash", (PyCFunction)Clb_Mod_getHash, METH_VARARGS, "Clb_Mod_getHash" },

     {"Clb_WeaponDef_getFalloffRate", (PyCFunction)Clb_WeaponDef_getFalloffRate, METH_VARARGS, "Clb_WeaponDef_getFalloffRate" },

     {"Clb_UnitDef_getSpeedToFront", (PyCFunction)Clb_UnitDef_getSpeedToFront, METH_VARARGS, "Clb_UnitDef_getSpeedToFront" },

     {"Clb_Mod_getLosMul", (PyCFunction)Clb_Mod_getLosMul, METH_VARARGS, "Clb_Mod_getLosMul" },

     {"Clb_UnitDef_isStealth", (PyCFunction)Clb_UnitDef_isStealth, METH_VARARGS, "Clb_UnitDef_isStealth" },

     {"Clb_UnitDef_isAbleToDGun", (PyCFunction)Clb_UnitDef_isAbleToDGun, METH_VARARGS, "Clb_UnitDef_isAbleToDGun" },

     {"Clb_Economy_0REF1Resource2resourceId0getCurrent", (PyCFunction)Clb_Economy_0REF1Resource2resourceId0getCurrent, METH_VARARGS, "Clb_Economy_0REF1Resource2resourceId0getCurrent" },

     {"Clb_WeaponDef_getMaxVelocity", (PyCFunction)Clb_WeaponDef_getMaxVelocity, METH_VARARGS, "Clb_WeaponDef_getMaxVelocity" },

     {"Clb_WeaponDef_isExteriorShield", (PyCFunction)Clb_WeaponDef_isExteriorShield, METH_VARARGS, "Clb_WeaponDef_isExteriorShield" },

     {"Clb_UnitDef_getAirLosRadius", (PyCFunction)Clb_UnitDef_getAirLosRadius, METH_VARARGS, "Clb_UnitDef_getAirLosRadius" },

     {"Clb_UnitDef_getTurnRadius", (PyCFunction)Clb_UnitDef_getTurnRadius, METH_VARARGS, "Clb_UnitDef_getTurnRadius" },

     {"Clb_UnitDef_getHumanName", (PyCFunction)Clb_UnitDef_getHumanName, METH_VARARGS, "Clb_UnitDef_getHumanName" },

     {"Clb_UnitDef_isFeature", (PyCFunction)Clb_UnitDef_isFeature, METH_VARARGS, "Clb_UnitDef_isFeature" },

     {"Clb_UnitDef_getRadarRadius", (PyCFunction)Clb_UnitDef_getRadarRadius, METH_VARARGS, "Clb_UnitDef_getRadarRadius" },

     {"Clb_Unit_getGroup", (PyCFunction)Clb_Unit_getGroup, METH_VARARGS, "Clb_Unit_getGroup" },

     {"Clb_WeaponDef_getTrajectoryHeight", (PyCFunction)Clb_WeaponDef_getTrajectoryHeight, METH_VARARGS, "Clb_WeaponDef_getTrajectoryHeight" },

     {"Clb_Mod_getTransportGround", (PyCFunction)Clb_Mod_getTransportGround, METH_VARARGS, "Clb_Mod_getTransportGround" },

     {"Clb_Unit_getTeam", (PyCFunction)Clb_Unit_getTeam, METH_VARARGS, "Clb_Unit_getTeam" },

     {"Clb_UnitDef_isDecloakOnFire", (PyCFunction)Clb_UnitDef_isDecloakOnFire, METH_VARARGS, "Clb_UnitDef_isDecloakOnFire" },

     {"Clb_WeaponDef_Shield_getRechargeDelay", (PyCFunction)Clb_WeaponDef_Shield_getRechargeDelay, METH_VARARGS, "Clb_WeaponDef_Shield_getRechargeDelay" },

     {"Clb_UnitDef_isAbleToCrash", (PyCFunction)Clb_UnitDef_isAbleToCrash, METH_VARARGS, "Clb_UnitDef_isAbleToCrash" },

     {"Clb_UnitDef_MoveData_getSlopeMod", (PyCFunction)Clb_UnitDef_MoveData_getSlopeMod, METH_VARARGS, "Clb_UnitDef_MoveData_getSlopeMod" },

     {"Clb_Group_OrderPreview_getOptions", (PyCFunction)Clb_Group_OrderPreview_getOptions, METH_VARARGS, "Clb_Group_OrderPreview_getOptions" },

     {"Clb_Unit_getExperience", (PyCFunction)Clb_Unit_getExperience, METH_VARARGS, "Clb_Unit_getExperience" },

     {"Clb_WeaponDef_getName", (PyCFunction)Clb_WeaponDef_getName, METH_VARARGS, "Clb_WeaponDef_getName" },

     {"Clb_Gui_getScreenX", (PyCFunction)Clb_Gui_getScreenX, METH_VARARGS, "Clb_Gui_getScreenX" },

     {"Clb_Gui_getScreenY", (PyCFunction)Clb_Gui_getScreenY, METH_VARARGS, "Clb_Gui_getScreenY" },

     {"Clb_Unit_getSpeed", (PyCFunction)Clb_Unit_getSpeed, METH_VARARGS, "Clb_Unit_getSpeed" },

     {"Clb_UnitDef_getFlareDropVector", (PyCFunction)Clb_UnitDef_getFlareDropVector, METH_VARARGS, "Clb_UnitDef_getFlareDropVector" },

     {"Clb_Mod_getAllowTeamColors", (PyCFunction)Clb_Mod_getAllowTeamColors, METH_VARARGS, "Clb_Mod_getAllowTeamColors" },

     {"Clb_WeaponDef_getDynDamageExp", (PyCFunction)Clb_WeaponDef_getDynDamageExp, METH_VARARGS, "Clb_WeaponDef_getDynDamageExp" },

     {"Clb_Group_SupportedCommand_0ARRAY1SIZE0getParams", (PyCFunction)Clb_Group_SupportedCommand_0ARRAY1SIZE0getParams, METH_VARARGS, "Clb_Group_SupportedCommand_0ARRAY1SIZE0getParams" },

     {"Clb_Map_getHeight", (PyCFunction)Clb_Map_getHeight, METH_VARARGS, "Clb_Map_getHeight" },

     {"Clb_Map_Line_getFirstPosition", (PyCFunction)Clb_Map_Line_getFirstPosition, METH_VARARGS, "Clb_Map_Line_getFirstPosition" },

     {"Clb_File_getContent", (PyCFunction)Clb_File_getContent, METH_VARARGS, "Clb_File_getContent" },

     {"Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapSpotsPositions", (PyCFunction)Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapSpotsPositions, METH_VARARGS, "Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0getResourceMapSpotsPositions" },

     {"Clb_UnitDef_getMaxElevator", (PyCFunction)Clb_UnitDef_getMaxElevator, METH_VARARGS, "Clb_UnitDef_getMaxElevator" },

     {"Clb_UnitDef_FlankingBonus_getDir", (PyCFunction)Clb_UnitDef_FlankingBonus_getDir, METH_VARARGS, "Clb_UnitDef_FlankingBonus_getDir" },

     {"Clb_Map_getMaxWind", (PyCFunction)Clb_Map_getMaxWind, METH_VARARGS, "Clb_Map_getMaxWind" },

     {"Clb_Map_getHash", (PyCFunction)Clb_Map_getHash, METH_VARARGS, "Clb_Map_getHash" },

     {"Clb_Map_getWidth", (PyCFunction)Clb_Map_getWidth, METH_VARARGS, "Clb_Map_getWidth" },

     {"Clb_UnitDef_0REF1Resource2resourceId0isSquareResourceExtractor", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0isSquareResourceExtractor, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0isSquareResourceExtractor" },

     {"Clb_FeatureDef_getFileName", (PyCFunction)Clb_FeatureDef_getFileName, METH_VARARGS, "Clb_FeatureDef_getFileName" },

     {"Clb_FeatureDef_0MAP1SIZE0getCustomParams", (PyCFunction)Clb_FeatureDef_0MAP1SIZE0getCustomParams, METH_VARARGS, "Clb_FeatureDef_0MAP1SIZE0getCustomParams" },

     {"Clb_UnitDef_getFlareTime", (PyCFunction)Clb_UnitDef_getFlareTime, METH_VARARGS, "Clb_UnitDef_getFlareTime" },

     {"Clb_WeaponDef_isManualFire", (PyCFunction)Clb_WeaponDef_isManualFire, METH_VARARGS, "Clb_WeaponDef_isManualFire" },

     {"Clb_0MULTI1VALS3NeutralUnits0Unit", (PyCFunction)Clb_0MULTI1VALS3NeutralUnits0Unit, METH_VARARGS, "Clb_0MULTI1VALS3NeutralUnits0Unit" },

     {"Clb_WeaponDef_isAvoidNeutral", (PyCFunction)Clb_WeaponDef_isAvoidNeutral, METH_VARARGS, "Clb_WeaponDef_isAvoidNeutral" },

     {"Clb_SkirmishAI_Info_getDescription", (PyCFunction)Clb_SkirmishAI_Info_getDescription, METH_VARARGS, "Clb_SkirmishAI_Info_getDescription" },

     {"Clb_Map_getMousePos", (PyCFunction)Clb_Map_getMousePos, METH_VARARGS, "Clb_Map_getMousePos" },

     {"Clb_WeaponDef_getNumBounce", (PyCFunction)Clb_WeaponDef_getNumBounce, METH_VARARGS, "Clb_WeaponDef_getNumBounce" },

     {"Clb_Map_Point_getColor", (PyCFunction)Clb_Map_Point_getColor, METH_VARARGS, "Clb_Map_Point_getColor" },

     {"Clb_Unit_getMaxHealth", (PyCFunction)Clb_Unit_getMaxHealth, METH_VARARGS, "Clb_Unit_getMaxHealth" },

     {"Clb_0MULTI1SIZE0Group", (PyCFunction)Clb_0MULTI1SIZE0Group, METH_VARARGS, "Clb_0MULTI1SIZE0Group" },

     {"Clb_SkirmishAI_Info_getKey", (PyCFunction)Clb_SkirmishAI_Info_getKey, METH_VARARGS, "Clb_SkirmishAI_Info_getKey" },

     {"Clb_WeaponDef_isTurret", (PyCFunction)Clb_WeaponDef_isTurret, METH_VARARGS, "Clb_WeaponDef_isTurret" },

     {"Clb_0MULTI1FETCH3UnitDefByName0UnitDef", (PyCFunction)Clb_0MULTI1FETCH3UnitDefByName0UnitDef, METH_VARARGS, "Clb_0MULTI1FETCH3UnitDefByName0UnitDef" },

     {"Clb_Unit_getMaxRange", (PyCFunction)Clb_Unit_getMaxRange, METH_VARARGS, "Clb_Unit_getMaxRange" },

     {"Clb_UnitDef_getSonarRadius", (PyCFunction)Clb_UnitDef_getSonarRadius, METH_VARARGS, "Clb_UnitDef_getSonarRadius" },

     {"Clb_Map_getElevationAt", (PyCFunction)Clb_Map_getElevationAt, METH_VARARGS, "Clb_Map_getElevationAt" },

     {"Clb_Map_Line_getSecondPosition", (PyCFunction)Clb_Map_Line_getSecondPosition, METH_VARARGS, "Clb_Map_Line_getSecondPosition" },

     {"Clb_UnitDef_isAssistable", (PyCFunction)Clb_UnitDef_isAssistable, METH_VARARGS, "Clb_UnitDef_isAssistable" },

     {"Clb_Unit_SupportedCommand_0ARRAY1VALS0getParams", (PyCFunction)Clb_Unit_SupportedCommand_0ARRAY1VALS0getParams, METH_VARARGS, "Clb_Unit_SupportedCommand_0ARRAY1VALS0getParams" },

     {"Clb_WeaponDef_isLargeBeamLaser", (PyCFunction)Clb_WeaponDef_isLargeBeamLaser, METH_VARARGS, "Clb_WeaponDef_isLargeBeamLaser" },

     {"Clb_UnitDef_getMaxHeightDif", (PyCFunction)Clb_UnitDef_getMaxHeightDif, METH_VARARGS, "Clb_UnitDef_getMaxHeightDif" },

     {"Clb_UnitDef_WeaponMount_getMainDir", (PyCFunction)Clb_UnitDef_WeaponMount_getMainDir, METH_VARARGS, "Clb_UnitDef_WeaponMount_getMainDir" },

     {"Clb_0MULTI1SIZE3EnemyUnits0Unit", (PyCFunction)Clb_0MULTI1SIZE3EnemyUnits0Unit, METH_VARARGS, "Clb_0MULTI1SIZE3EnemyUnits0Unit" },

     {"Clb_UnitDef_getMinTransportMass", (PyCFunction)Clb_UnitDef_getMinTransportMass, METH_VARARGS, "Clb_UnitDef_getMinTransportMass" },

     {"Clb_WeaponDef_isFireSubmersed", (PyCFunction)Clb_WeaponDef_isFireSubmersed, METH_VARARGS, "Clb_WeaponDef_isFireSubmersed" },

     {"Clb_UnitDef_FlankingBonus_getMode", (PyCFunction)Clb_UnitDef_FlankingBonus_getMode, METH_VARARGS, "Clb_UnitDef_FlankingBonus_getMode" },

     {"Clb_WeaponDef_getSprayAngle", (PyCFunction)Clb_WeaponDef_getSprayAngle, METH_VARARGS, "Clb_WeaponDef_getSprayAngle" },

     {"Clb_UnitDef_getTooltip", (PyCFunction)Clb_UnitDef_getTooltip, METH_VARARGS, "Clb_UnitDef_getTooltip" },

     {"Clb_Unit_getVel", (PyCFunction)Clb_Unit_getVel, METH_VARARGS, "Clb_Unit_getVel" },

     {"Clb_Unit_isNeutral", (PyCFunction)Clb_Unit_isNeutral, METH_VARARGS, "Clb_Unit_isNeutral" },

     {"Clb_WeaponDef_getDance", (PyCFunction)Clb_WeaponDef_getDance, METH_VARARGS, "Clb_WeaponDef_getDance" },

     {"Clb_UnitDef_isAbleToRepair", (PyCFunction)Clb_UnitDef_isAbleToRepair, METH_VARARGS, "Clb_UnitDef_isAbleToRepair" },

     {"Clb_Map_getStartPos", (PyCFunction)Clb_Map_getStartPos, METH_VARARGS, "Clb_Map_getStartPos" },

     {"Clb_DataDirs_Roots_locatePath", (PyCFunction)Clb_DataDirs_Roots_locatePath, METH_VARARGS, "Clb_DataDirs_Roots_locatePath" },

     {"Clb_UnitDef_0REF1Resource2resourceId0getMakesResource", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0getMakesResource, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0getMakesResource" },

     {"Clb_Unit_CurrentCommand_getOptions", (PyCFunction)Clb_Unit_CurrentCommand_getOptions, METH_VARARGS, "Clb_Unit_CurrentCommand_getOptions" },

     {"Clb_Unit_CurrentCommand_getId", (PyCFunction)Clb_Unit_CurrentCommand_getId, METH_VARARGS, "Clb_Unit_CurrentCommand_getId" },

     {"Clb_Group_SupportedCommand_getToolTip", (PyCFunction)Clb_Group_SupportedCommand_getToolTip, METH_VARARGS, "Clb_Group_SupportedCommand_getToolTip" },

     {"Clb_Game_isAllied", (PyCFunction)Clb_Game_isAllied, METH_VARARGS, "Clb_Game_isAllied" },

     {"Clb_Unit_0REF1Resource2resourceId0getResourceMake", (PyCFunction)Clb_Unit_0REF1Resource2resourceId0getResourceMake, METH_VARARGS, "Clb_Unit_0REF1Resource2resourceId0getResourceMake" },

     {"Clb_WeaponDef_isSoundTrigger", (PyCFunction)Clb_WeaponDef_isSoundTrigger, METH_VARARGS, "Clb_WeaponDef_isSoundTrigger" },

     {"Clb_UnitDef_getMaxAcceleration", (PyCFunction)Clb_UnitDef_getMaxAcceleration, METH_VARARGS, "Clb_UnitDef_getMaxAcceleration" },

     {"Clb_UnitDef_0REF1Resource2resourceId0getResourceExtractorRange", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0getResourceExtractorRange, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0getResourceExtractorRange" },

     {"Clb_WeaponDef_Shield_getMaxSpeed", (PyCFunction)Clb_WeaponDef_Shield_getMaxSpeed, METH_VARARGS, "Clb_WeaponDef_Shield_getMaxSpeed" },

     {"Clb_UnitDef_0REF1Resource2resourceId0getStorage", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0getStorage, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0getStorage" },

     {"Clb_UnitDef_isReclaimable", (PyCFunction)Clb_UnitDef_isReclaimable, METH_VARARGS, "Clb_UnitDef_isReclaimable" },

     {"Clb_UnitDef_getTurnInPlaceDistance", (PyCFunction)Clb_UnitDef_getTurnInPlaceDistance, METH_VARARGS, "Clb_UnitDef_getTurnInPlaceDistance" },

     {"Clb_0MULTI1SIZE0Feature", (PyCFunction)Clb_0MULTI1SIZE0Feature, METH_VARARGS, "Clb_0MULTI1SIZE0Feature" },

     {"Clb_WeaponDef_getCegTag", (PyCFunction)Clb_WeaponDef_getCegTag, METH_VARARGS, "Clb_WeaponDef_getCegTag" },

     {"Clb_0MULTI1SIZE0UnitDef", (PyCFunction)Clb_0MULTI1SIZE0UnitDef, METH_VARARGS, "Clb_0MULTI1SIZE0UnitDef" },

     {"Clb_UnitDef_getVerticalSpeed", (PyCFunction)Clb_UnitDef_getVerticalSpeed, METH_VARARGS, "Clb_UnitDef_getVerticalSpeed" },

     {"Clb_Mod_getFireAtCrashing", (PyCFunction)Clb_Mod_getFireAtCrashing, METH_VARARGS, "Clb_Mod_getFireAtCrashing" },

     {"Clb_WeaponDef_getEdgeEffectiveness", (PyCFunction)Clb_WeaponDef_getEdgeEffectiveness, METH_VARARGS, "Clb_WeaponDef_getEdgeEffectiveness" },

     {"Clb_WeaponDef_getLeadBonus", (PyCFunction)Clb_WeaponDef_getLeadBonus, METH_VARARGS, "Clb_WeaponDef_getLeadBonus" },

     {"Clb_Unit_CurrentCommand_0STATIC0getType", (PyCFunction)Clb_Unit_CurrentCommand_0STATIC0getType, METH_VARARGS, "Clb_Unit_CurrentCommand_0STATIC0getType" },

     {"Clb_Economy_0REF1Resource2resourceId0getStorage", (PyCFunction)Clb_Economy_0REF1Resource2resourceId0getStorage, METH_VARARGS, "Clb_Economy_0REF1Resource2resourceId0getStorage" },

     {"Clb_Group_OrderPreview_getTag", (PyCFunction)Clb_Group_OrderPreview_getTag, METH_VARARGS, "Clb_Group_OrderPreview_getTag" },

     {"Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsNearest", (PyCFunction)Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsNearest, METH_VARARGS, "Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsNearest" },

     {"Clb_0MULTI1VALS3SelectedUnits0Unit", (PyCFunction)Clb_0MULTI1VALS3SelectedUnits0Unit, METH_VARARGS, "Clb_0MULTI1VALS3SelectedUnits0Unit" },

     {"Clb_DataDirs_Roots_allocatePath", (PyCFunction)Clb_DataDirs_Roots_allocatePath, METH_VARARGS, "Clb_DataDirs_Roots_allocatePath" },

     {"Clb_WeaponDef_Damage_getCraterMult", (PyCFunction)Clb_WeaponDef_Damage_getCraterMult, METH_VARARGS, "Clb_WeaponDef_Damage_getCraterMult" },

     {"Clb_WeaponDef_Shield_getPower", (PyCFunction)Clb_WeaponDef_Shield_getPower, METH_VARARGS, "Clb_WeaponDef_Shield_getPower" },

     {"Clb_WeaponDef_isShield", (PyCFunction)Clb_WeaponDef_isShield, METH_VARARGS, "Clb_WeaponDef_isShield" },

     {"Clb_Feature_getPosition", (PyCFunction)Clb_Feature_getPosition, METH_VARARGS, "Clb_Feature_getPosition" },

     {"Clb_UnitDef_0REF1Resource2resourceId0getCost", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0getCost, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0getCost" },

     {"Clb_UnitDef_getLosHeight", (PyCFunction)Clb_UnitDef_getLosHeight, METH_VARARGS, "Clb_UnitDef_getLosHeight" },

     {"Clb_UnitDef_isAbleToRepeat", (PyCFunction)Clb_UnitDef_isAbleToRepeat, METH_VARARGS, "Clb_UnitDef_isAbleToRepeat" },

     {"Clb_UnitDef_getCloakCostMoving", (PyCFunction)Clb_UnitDef_getCloakCostMoving, METH_VARARGS, "Clb_UnitDef_getCloakCostMoving" },

     {"Clb_WeaponDef_getSalvoDelay", (PyCFunction)Clb_WeaponDef_getSalvoDelay, METH_VARARGS, "Clb_WeaponDef_getSalvoDelay" },

     {"Clb_Game_getMyAllyTeam", (PyCFunction)Clb_Game_getMyAllyTeam, METH_VARARGS, "Clb_Game_getMyAllyTeam" },

     {"Clb_FeatureDef_getMass", (PyCFunction)Clb_FeatureDef_getMass, METH_VARARGS, "Clb_FeatureDef_getMass" },

     {"Clb_Map_getMinWind", (PyCFunction)Clb_Map_getMinWind, METH_VARARGS, "Clb_Map_getMinWind" },

     {"Clb_UnitDef_getMinCollisionSpeed", (PyCFunction)Clb_UnitDef_getMinCollisionSpeed, METH_VARARGS, "Clb_UnitDef_getMinCollisionSpeed" },

     {"Clb_Game_getCurrentFrame", (PyCFunction)Clb_Game_getCurrentFrame, METH_VARARGS, "Clb_Game_getCurrentFrame" },

     {"Clb_UnitDef_getZSize", (PyCFunction)Clb_UnitDef_getZSize, METH_VARARGS, "Clb_UnitDef_getZSize" },

     {"Clb_Game_getMyTeam", (PyCFunction)Clb_Game_getMyTeam, METH_VARARGS, "Clb_Game_getMyTeam" },

     {"Clb_Mod_getMultiReclaim", (PyCFunction)Clb_Mod_getMultiReclaim, METH_VARARGS, "Clb_Mod_getMultiReclaim" },

     {"Clb_SkirmishAI_Info_getSize", (PyCFunction)Clb_SkirmishAI_Info_getSize, METH_VARARGS, "Clb_SkirmishAI_Info_getSize" },

     {"Clb_SkirmishAI_Info_getValueByKey", (PyCFunction)Clb_SkirmishAI_Info_getValueByKey, METH_VARARGS, "Clb_SkirmishAI_Info_getValueByKey" },

     {"Clb_UnitDef_getFireState", (PyCFunction)Clb_UnitDef_getFireState, METH_VARARGS, "Clb_UnitDef_getFireState" },

     {"Clb_UnitDef_isDontLand", (PyCFunction)Clb_UnitDef_isDontLand, METH_VARARGS, "Clb_UnitDef_isDontLand" },

     {"Clb_Map_getGravity", (PyCFunction)Clb_Map_getGravity, METH_VARARGS, "Clb_Map_getGravity" },

     {"Clb_UnitDef_isTransportByEnemy", (PyCFunction)Clb_UnitDef_isTransportByEnemy, METH_VARARGS, "Clb_UnitDef_isTransportByEnemy" },

     {"Clb_UnitDef_isTurnInPlace", (PyCFunction)Clb_UnitDef_isTurnInPlace, METH_VARARGS, "Clb_UnitDef_isTurnInPlace" },

     {"Clb_UnitDef_getReclaimSpeed", (PyCFunction)Clb_UnitDef_getReclaimSpeed, METH_VARARGS, "Clb_UnitDef_getReclaimSpeed" },

     {"Clb_WeaponDef_isNoExplode", (PyCFunction)Clb_WeaponDef_isNoExplode, METH_VARARGS, "Clb_WeaponDef_isNoExplode" },

     {"Clb_Cheats_setEnabled", (PyCFunction)Clb_Cheats_setEnabled, METH_VARARGS, "Clb_Cheats_setEnabled" },

     {"Clb_UnitDef_MoveData_getMaxAcceleration", (PyCFunction)Clb_UnitDef_MoveData_getMaxAcceleration, METH_VARARGS, "Clb_UnitDef_MoveData_getMaxAcceleration" },

     {"Clb_Map_getCurWind", (PyCFunction)Clb_Map_getCurWind, METH_VARARGS, "Clb_Map_getCurWind" },

     {"Clb_FeatureDef_getResurrectable", (PyCFunction)Clb_FeatureDef_getResurrectable, METH_VARARGS, "Clb_FeatureDef_getResurrectable" },

     {"Clb_UnitDef_MoveData_getPathType", (PyCFunction)Clb_UnitDef_MoveData_getPathType, METH_VARARGS, "Clb_UnitDef_MoveData_getPathType" },

     {"Clb_UnitDef_isSonarStealth", (PyCFunction)Clb_UnitDef_isSonarStealth, METH_VARARGS, "Clb_UnitDef_isSonarStealth" },

     {"Clb_UnitDef_FlankingBonus_getMobilityAdd", (PyCFunction)Clb_UnitDef_FlankingBonus_getMobilityAdd, METH_VARARGS, "Clb_UnitDef_FlankingBonus_getMobilityAdd" },

     {"Clb_Mod_getShortName", (PyCFunction)Clb_Mod_getShortName, METH_VARARGS, "Clb_Mod_getShortName" },

     {"Clb_UnitDef_getPower", (PyCFunction)Clb_UnitDef_getPower, METH_VARARGS, "Clb_UnitDef_getPower" },

     {"Clb_WeaponDef_getCollisionFlags", (PyCFunction)Clb_WeaponDef_getCollisionFlags, METH_VARARGS, "Clb_WeaponDef_getCollisionFlags" },

     {"Clb_WeaponDef_isWaterBounce", (PyCFunction)Clb_WeaponDef_isWaterBounce, METH_VARARGS, "Clb_WeaponDef_isWaterBounce" },

     {"Clb_WeaponDef_getLeadLimit", (PyCFunction)Clb_WeaponDef_getLeadLimit, METH_VARARGS, "Clb_WeaponDef_getLeadLimit" },

     {"Clb_Unit_0MULTI1SIZE0ModParam", (PyCFunction)Clb_Unit_0MULTI1SIZE0ModParam, METH_VARARGS, "Clb_Unit_0MULTI1SIZE0ModParam" },

     {"Clb_0MULTI1SIZE0FeatureDef", (PyCFunction)Clb_0MULTI1SIZE0FeatureDef, METH_VARARGS, "Clb_0MULTI1SIZE0FeatureDef" },

     {"Clb_Mod_getHumanName", (PyCFunction)Clb_Mod_getHumanName, METH_VARARGS, "Clb_Mod_getHumanName" },

     {"Clb_UnitDef_getAutoHeal", (PyCFunction)Clb_UnitDef_getAutoHeal, METH_VARARGS, "Clb_UnitDef_getAutoHeal" },

     {"Clb_WeaponDef_getTargetable", (PyCFunction)Clb_WeaponDef_getTargetable, METH_VARARGS, "Clb_WeaponDef_getTargetable" },

     {"Clb_WeaponDef_isVisibleShieldRepulse", (PyCFunction)Clb_WeaponDef_isVisibleShieldRepulse, METH_VARARGS, "Clb_WeaponDef_isVisibleShieldRepulse" },

     {"Clb_UnitDef_getTrackWidth", (PyCFunction)Clb_UnitDef_getTrackWidth, METH_VARARGS, "Clb_UnitDef_getTrackWidth" },

     {"Clb_SkirmishAI_OptionValues_getKey", (PyCFunction)Clb_SkirmishAI_OptionValues_getKey, METH_VARARGS, "Clb_SkirmishAI_OptionValues_getKey" },

     {"Clb_UnitDef_getTurnRate", (PyCFunction)Clb_UnitDef_getTurnRate, METH_VARARGS, "Clb_UnitDef_getTurnRate" },

     {"Clb_Map_0MULTI1SIZE0Point", (PyCFunction)Clb_Map_0MULTI1SIZE0Point, METH_VARARGS, "Clb_Map_0MULTI1SIZE0Point" },

     {"Clb_UnitDef_isFullHealthFactory", (PyCFunction)Clb_UnitDef_isFullHealthFactory, METH_VARARGS, "Clb_UnitDef_isFullHealthFactory" },

     {"Clb_Mod_getReclaimAllowEnemies", (PyCFunction)Clb_Mod_getReclaimAllowEnemies, METH_VARARGS, "Clb_Mod_getReclaimAllowEnemies" },

     {"Clb_0MULTI1SIZE3NeutralUnitsIn0Unit", (PyCFunction)Clb_0MULTI1SIZE3NeutralUnitsIn0Unit, METH_VARARGS, "Clb_0MULTI1SIZE3NeutralUnitsIn0Unit" },

     {"Clb_UnitDef_getBuildDistance", (PyCFunction)Clb_UnitDef_getBuildDistance, METH_VARARGS, "Clb_UnitDef_getBuildDistance" },

     {"Clb_UnitDef_getBuildingDecalType", (PyCFunction)Clb_UnitDef_getBuildingDecalType, METH_VARARGS, "Clb_UnitDef_getBuildingDecalType" },

     {"Clb_WeaponDef_isBeamBurst", (PyCFunction)Clb_WeaponDef_isBeamBurst, METH_VARARGS, "Clb_WeaponDef_isBeamBurst" },

     {"Clb_Map_getChecksum", (PyCFunction)Clb_Map_getChecksum, METH_VARARGS, "Clb_Map_getChecksum" },

     {"Clb_Unit_CurrentCommand_getTag", (PyCFunction)Clb_Unit_CurrentCommand_getTag, METH_VARARGS, "Clb_Unit_CurrentCommand_getTag" },

     {"Clb_UnitDef_isHideDamage", (PyCFunction)Clb_UnitDef_isHideDamage, METH_VARARGS, "Clb_UnitDef_isHideDamage" },

     {"Clb_UnitDef_getTransportCapacity", (PyCFunction)Clb_UnitDef_getTransportCapacity, METH_VARARGS, "Clb_UnitDef_getTransportCapacity" },

     {"Clb_Unit_getCurrentFuel", (PyCFunction)Clb_Unit_getCurrentFuel, METH_VARARGS, "Clb_Unit_getCurrentFuel" },

     {"Clb_SkirmishAI_Info_getValue", (PyCFunction)Clb_SkirmishAI_Info_getValue, METH_VARARGS, "Clb_SkirmishAI_Info_getValue" },

     {"Clb_UnitDef_0REF1Resource2resourceId0getResourceMake", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0getResourceMake, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0getResourceMake" },

     {"Clb_Engine_Version_getPatchset", (PyCFunction)Clb_Engine_Version_getPatchset, METH_VARARGS, "Clb_Engine_Version_getPatchset" },

     {"Clb_UnitDef_isShowPlayerName", (PyCFunction)Clb_UnitDef_isShowPlayerName, METH_VARARGS, "Clb_UnitDef_isShowPlayerName" },

     {"Clb_WeaponDef_Damage_getParalyzeDamageTime", (PyCFunction)Clb_WeaponDef_Damage_getParalyzeDamageTime, METH_VARARGS, "Clb_WeaponDef_Damage_getParalyzeDamageTime" },

     {"Clb_WeaponDef_getDuration", (PyCFunction)Clb_WeaponDef_getDuration, METH_VARARGS, "Clb_WeaponDef_getDuration" },

     {"Clb_SkirmishAI_OptionValues_getValueByKey", (PyCFunction)Clb_SkirmishAI_OptionValues_getValueByKey, METH_VARARGS, "Clb_SkirmishAI_OptionValues_getValueByKey" },

     {"Clb_UnitDef_getSelfDExplosion", (PyCFunction)Clb_UnitDef_getSelfDExplosion, METH_VARARGS, "Clb_UnitDef_getSelfDExplosion" },

     {"Clb_UnitDef_getMaxWeaponRange", (PyCFunction)Clb_UnitDef_getMaxWeaponRange, METH_VARARGS, "Clb_UnitDef_getMaxWeaponRange" },

     {"Clb_Mod_getConstructionDecaySpeed", (PyCFunction)Clb_Mod_getConstructionDecaySpeed, METH_VARARGS, "Clb_Mod_getConstructionDecaySpeed" },

     {"Clb_Mod_getRepairEnergyCostFactor", (PyCFunction)Clb_Mod_getRepairEnergyCostFactor, METH_VARARGS, "Clb_Mod_getRepairEnergyCostFactor" },

     {"Clb_UnitDef_FlankingBonus_getMin", (PyCFunction)Clb_UnitDef_FlankingBonus_getMin, METH_VARARGS, "Clb_UnitDef_FlankingBonus_getMin" },

     {"Clb_0MULTI1SIZE3EnemyUnitsInRadarAndLos0Unit", (PyCFunction)Clb_0MULTI1SIZE3EnemyUnitsInRadarAndLos0Unit, METH_VARARGS, "Clb_0MULTI1SIZE3EnemyUnitsInRadarAndLos0Unit" },

     {"Clb_WeaponDef_getDynDamageRange", (PyCFunction)Clb_WeaponDef_getDynDamageRange, METH_VARARGS, "Clb_WeaponDef_getDynDamageRange" },

     {"Clb_Unit_getAiHint", (PyCFunction)Clb_Unit_getAiHint, METH_VARARGS, "Clb_Unit_getAiHint" },

     {"Clb_Map_getMinHeight", (PyCFunction)Clb_Map_getMinHeight, METH_VARARGS, "Clb_Map_getMinHeight" },

     {"Clb_FeatureDef_getSmokeTime", (PyCFunction)Clb_FeatureDef_getSmokeTime, METH_VARARGS, "Clb_FeatureDef_getSmokeTime" },

     {"Clb_Resource_getOptimum", (PyCFunction)Clb_Resource_getOptimum, METH_VARARGS, "Clb_Resource_getOptimum" },

     {"Clb_WeaponDef_getCylinderTargetting", (PyCFunction)Clb_WeaponDef_getCylinderTargetting, METH_VARARGS, "Clb_WeaponDef_getCylinderTargetting" },

     {"Clb_UnitDef_getRefuelTime", (PyCFunction)Clb_UnitDef_getRefuelTime, METH_VARARGS, "Clb_UnitDef_getRefuelTime" },

     {"Clb_Map_0ARRAY1SIZE0getCornersHeightMap", (PyCFunction)Clb_Map_0ARRAY1SIZE0getCornersHeightMap, METH_VARARGS, "Clb_Map_0ARRAY1SIZE0getCornersHeightMap" },

     {"Clb_Game_getMode", (PyCFunction)Clb_Game_getMode, METH_VARARGS, "Clb_Game_getMode" },

     {"Clb_Mod_getReclaimAllowAllies", (PyCFunction)Clb_Mod_getReclaimAllowAllies, METH_VARARGS, "Clb_Mod_getReclaimAllowAllies" },

     {"Clb_UnitDef_isAbleToAssist", (PyCFunction)Clb_UnitDef_isAbleToAssist, METH_VARARGS, "Clb_UnitDef_isAbleToAssist" },

     {"Clb_WeaponDef_getCoreThickness", (PyCFunction)Clb_WeaponDef_getCoreThickness, METH_VARARGS, "Clb_WeaponDef_getCoreThickness" },

     {"Clb_0MULTI1VALS0FeatureDef", (PyCFunction)Clb_0MULTI1VALS0FeatureDef, METH_VARARGS, "Clb_0MULTI1VALS0FeatureDef" },

     {"Clb_Map_0ARRAY1SIZE0getRadarMap", (PyCFunction)Clb_Map_0ARRAY1SIZE0getRadarMap, METH_VARARGS, "Clb_Map_0ARRAY1SIZE0getRadarMap" },

     {"Clb_UnitDef_getFallSpeed", (PyCFunction)Clb_UnitDef_getFallSpeed, METH_VARARGS, "Clb_UnitDef_getFallSpeed" },

     {"Clb_FeatureDef_getDeathFeature", (PyCFunction)Clb_FeatureDef_getDeathFeature, METH_VARARGS, "Clb_FeatureDef_getDeathFeature" },

     {"Clb_WeaponDef_getCameraShake", (PyCFunction)Clb_WeaponDef_getCameraShake, METH_VARARGS, "Clb_WeaponDef_getCameraShake" },

     {"Clb_UnitDef_0REF1Resource2resourceId0getUpkeep", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0getUpkeep, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0getUpkeep" },

     {"Clb_FeatureDef_isDestructable", (PyCFunction)Clb_FeatureDef_isDestructable, METH_VARARGS, "Clb_FeatureDef_isDestructable" },

     {"Clb_Map_0MULTI1SIZE0Line", (PyCFunction)Clb_Map_0MULTI1SIZE0Line, METH_VARARGS, "Clb_Map_0MULTI1SIZE0Line" },

     {"Clb_0MULTI1SIZE3FeaturesIn0Feature", (PyCFunction)Clb_0MULTI1SIZE3FeaturesIn0Feature, METH_VARARGS, "Clb_0MULTI1SIZE3FeaturesIn0Feature" },

     {"Clb_FeatureDef_getModelName", (PyCFunction)Clb_FeatureDef_getModelName, METH_VARARGS, "Clb_FeatureDef_getModelName" },

     {"Clb_WeaponDef_getSalvoSize", (PyCFunction)Clb_WeaponDef_getSalvoSize, METH_VARARGS, "Clb_WeaponDef_getSalvoSize" },

     {"Clb_Map_Line_getColor", (PyCFunction)Clb_Map_Line_getColor, METH_VARARGS, "Clb_Map_Line_getColor" },

     {"Clb_UnitDef_0REF1Resource2resourceId0getExtractsResource", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0getExtractsResource, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0getExtractsResource" },

     {"Clb_Teams_getSize", (PyCFunction)Clb_Teams_getSize, METH_VARARGS, "Clb_Teams_getSize" },

     {"Clb_Mod_getTransportShip", (PyCFunction)Clb_Mod_getTransportShip, METH_VARARGS, "Clb_Mod_getTransportShip" },

     {"Clb_UnitDef_getFlareReloadTime", (PyCFunction)Clb_UnitDef_getFlareReloadTime, METH_VARARGS, "Clb_UnitDef_getFlareReloadTime" },

     {"Clb_UnitDef_getDecloakDistance", (PyCFunction)Clb_UnitDef_getDecloakDistance, METH_VARARGS, "Clb_UnitDef_getDecloakDistance" },

     {"Clb_UnitDef_isHoldSteady", (PyCFunction)Clb_UnitDef_isHoldSteady, METH_VARARGS, "Clb_UnitDef_isHoldSteady" },

     {"Clb_UnitDef_isFloater", (PyCFunction)Clb_UnitDef_isFloater, METH_VARARGS, "Clb_UnitDef_isFloater" },

     {"Clb_WeaponDef_getRange", (PyCFunction)Clb_WeaponDef_getRange, METH_VARARGS, "Clb_WeaponDef_getRange" },

     {"Clb_Unit_SupportedCommand_isShowUnique", (PyCFunction)Clb_Unit_SupportedCommand_isShowUnique, METH_VARARGS, "Clb_Unit_SupportedCommand_isShowUnique" },

     {"Clb_0MULTI1VALS3EnemyUnitsInRadarAndLos0Unit", (PyCFunction)Clb_0MULTI1VALS3EnemyUnitsInRadarAndLos0Unit, METH_VARARGS, "Clb_0MULTI1VALS3EnemyUnitsInRadarAndLos0Unit" },

     {"Clb_WeaponDef_Shield_getStartingPower", (PyCFunction)Clb_WeaponDef_Shield_getStartingPower, METH_VARARGS, "Clb_WeaponDef_Shield_getStartingPower" },

     {"Clb_UnitDef_getLosRadius", (PyCFunction)Clb_UnitDef_getLosRadius, METH_VARARGS, "Clb_UnitDef_getLosRadius" },

     {"Clb_UnitDef_getXSize", (PyCFunction)Clb_UnitDef_getXSize, METH_VARARGS, "Clb_UnitDef_getXSize" },

     {"Clb_FeatureDef_getName", (PyCFunction)Clb_FeatureDef_getName, METH_VARARGS, "Clb_FeatureDef_getName" },

     {"Clb_Mod_getAirLosMul", (PyCFunction)Clb_Mod_getAirLosMul, METH_VARARGS, "Clb_Mod_getAirLosMul" },

     {"Clb_UnitDef_0AVAILABLE0MoveData", (PyCFunction)Clb_UnitDef_0AVAILABLE0MoveData, METH_VARARGS, "Clb_UnitDef_0AVAILABLE0MoveData" },

     {"Clb_Group_0MULTI1SIZE0SupportedCommand", (PyCFunction)Clb_Group_0MULTI1SIZE0SupportedCommand, METH_VARARGS, "Clb_Group_0MULTI1SIZE0SupportedCommand" },

     {"Clb_UnitDef_getSpeed", (PyCFunction)Clb_UnitDef_getSpeed, METH_VARARGS, "Clb_UnitDef_getSpeed" },

     {"Clb_FeatureDef_0REF1Resource2resourceId0getContainedResource", (PyCFunction)Clb_FeatureDef_0REF1Resource2resourceId0getContainedResource, METH_VARARGS, "Clb_FeatureDef_0REF1Resource2resourceId0getContainedResource" },

     {"Clb_Unit_0STATIC0getLimit", (PyCFunction)Clb_Unit_0STATIC0getLimit, METH_VARARGS, "Clb_Unit_0STATIC0getLimit" },

     {"Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapRaw", (PyCFunction)Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapRaw, METH_VARARGS, "Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapRaw" },

     {"Clb_UnitDef_getRepairSpeed", (PyCFunction)Clb_UnitDef_getRepairSpeed, METH_VARARGS, "Clb_UnitDef_getRepairSpeed" },

     {"Clb_WeaponDef_Shield_getInterceptType", (PyCFunction)Clb_WeaponDef_Shield_getInterceptType, METH_VARARGS, "Clb_WeaponDef_Shield_getInterceptType" },

     {"Clb_UnitDef_isAbleToFight", (PyCFunction)Clb_UnitDef_isAbleToFight, METH_VARARGS, "Clb_UnitDef_isAbleToFight" },

     {"Clb_WeaponDef_getTargetBorder", (PyCFunction)Clb_WeaponDef_getTargetBorder, METH_VARARGS, "Clb_WeaponDef_getTargetBorder" },

     {"Clb_WeaponDef_getInterceptor", (PyCFunction)Clb_WeaponDef_getInterceptor, METH_VARARGS, "Clb_WeaponDef_getInterceptor" },

     {"Clb_WeaponDef_Shield_getGoodColor", (PyCFunction)Clb_WeaponDef_Shield_getGoodColor, METH_VARARGS, "Clb_WeaponDef_Shield_getGoodColor" },

     {"Clb_Engine_Version_getMajor", (PyCFunction)Clb_Engine_Version_getMajor, METH_VARARGS, "Clb_Engine_Version_getMajor" },

     {"Clb_WeaponDef_Shield_0REF1Resource2resourceId0getPowerRegenResource", (PyCFunction)Clb_WeaponDef_Shield_0REF1Resource2resourceId0getPowerRegenResource, METH_VARARGS, "Clb_WeaponDef_Shield_0REF1Resource2resourceId0getPowerRegenResource" },

     {"Clb_UnitDef_MoveData_getDepthMod", (PyCFunction)Clb_UnitDef_MoveData_getDepthMod, METH_VARARGS, "Clb_UnitDef_MoveData_getDepthMod" },

     {"Clb_UnitDef_isAbleToSelfRepair", (PyCFunction)Clb_UnitDef_isAbleToSelfRepair, METH_VARARGS, "Clb_UnitDef_isAbleToSelfRepair" },

     {"Clb_WeaponDef_0MAP1VALS0getCustomParams", (PyCFunction)Clb_WeaponDef_0MAP1VALS0getCustomParams, METH_VARARGS, "Clb_WeaponDef_0MAP1VALS0getCustomParams" },

     {"Clb_Game_getAiInterfaceVersion", (PyCFunction)Clb_Game_getAiInterfaceVersion, METH_VARARGS, "Clb_Game_getAiInterfaceVersion" },

     {"Clb_FeatureDef_isReclaimable", (PyCFunction)Clb_FeatureDef_isReclaimable, METH_VARARGS, "Clb_FeatureDef_isReclaimable" },

     {"Clb_0MULTI1VALS3NeutralUnitsIn0Unit", (PyCFunction)Clb_0MULTI1VALS3NeutralUnitsIn0Unit, METH_VARARGS, "Clb_0MULTI1VALS3NeutralUnitsIn0Unit" },

     {"Clb_UnitDef_getAiHint", (PyCFunction)Clb_UnitDef_getAiHint, METH_VARARGS, "Clb_UnitDef_getAiHint" },

     {"Clb_Mod_getReclaimUnitMethod", (PyCFunction)Clb_Mod_getReclaimUnitMethod, METH_VARARGS, "Clb_Mod_getReclaimUnitMethod" },

     {"Clb_WeaponDef_isAvoidFeature", (PyCFunction)Clb_WeaponDef_isAvoidFeature, METH_VARARGS, "Clb_WeaponDef_isAvoidFeature" },

     {"Clb_WeaponDef_getBeamTime", (PyCFunction)Clb_WeaponDef_getBeamTime, METH_VARARGS, "Clb_WeaponDef_getBeamTime" },

     {"Clb_UnitDef_0SINGLE1FETCH2UnitDef0getDecoyDef", (PyCFunction)Clb_UnitDef_0SINGLE1FETCH2UnitDef0getDecoyDef, METH_VARARGS, "Clb_UnitDef_0SINGLE1FETCH2UnitDef0getDecoyDef" },

     {"Clb_WeaponDef_isDropped", (PyCFunction)Clb_WeaponDef_isDropped, METH_VARARGS, "Clb_WeaponDef_isDropped" },

     {"Clb_WeaponDef_getTargetMoveError", (PyCFunction)Clb_WeaponDef_getTargetMoveError, METH_VARARGS, "Clb_WeaponDef_getTargetMoveError" },

     {"Clb_WeaponDef_isNoSelfDamage", (PyCFunction)Clb_WeaponDef_isNoSelfDamage, METH_VARARGS, "Clb_WeaponDef_isNoSelfDamage" },

     {"Clb_UnitDef_getFlareDelay", (PyCFunction)Clb_UnitDef_getFlareDelay, METH_VARARGS, "Clb_UnitDef_getFlareDelay" },

     {"Clb_UnitDef_getIdleAutoHeal", (PyCFunction)Clb_UnitDef_getIdleAutoHeal, METH_VARARGS, "Clb_UnitDef_getIdleAutoHeal" },

     {"Clb_WeaponDef_0MAP1KEYS0getCustomParams", (PyCFunction)Clb_WeaponDef_0MAP1KEYS0getCustomParams, METH_VARARGS, "Clb_WeaponDef_0MAP1KEYS0getCustomParams" },

     {"Clb_Resource_getName", (PyCFunction)Clb_Resource_getName, METH_VARARGS, "Clb_Resource_getName" },

     {"Clb_UnitDef_isAbleToFly", (PyCFunction)Clb_UnitDef_isAbleToFly, METH_VARARGS, "Clb_UnitDef_isAbleToFly" },

     {"Clb_UnitDef_getTransportUnloadMethod", (PyCFunction)Clb_UnitDef_getTransportUnloadMethod, METH_VARARGS, "Clb_UnitDef_getTransportUnloadMethod" },

     {"Clb_UnitDef_0REF1Resource2resourceId0getWindResourceGenerator", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0getWindResourceGenerator, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0getWindResourceGenerator" },

     {"Clb_UnitDef_isAbleToMove", (PyCFunction)Clb_UnitDef_isAbleToMove, METH_VARARGS, "Clb_UnitDef_isAbleToMove" },

     {"Clb_SkirmishAIs_getMax", (PyCFunction)Clb_SkirmishAIs_getMax, METH_VARARGS, "Clb_SkirmishAIs_getMax" },

     {"Clb_Map_Point_getLabel", (PyCFunction)Clb_Map_Point_getLabel, METH_VARARGS, "Clb_Map_Point_getLabel" },

     {"Clb_WeaponDef_0STATIC0getNumDamageTypes", (PyCFunction)Clb_WeaponDef_0STATIC0getNumDamageTypes, METH_VARARGS, "Clb_WeaponDef_0STATIC0getNumDamageTypes" },

     {"Clb_WeaponDef_getInterceptedByShieldType", (PyCFunction)Clb_WeaponDef_getInterceptedByShieldType, METH_VARARGS, "Clb_WeaponDef_getInterceptedByShieldType" },

     {"Clb_UnitDef_getTrackOffset", (PyCFunction)Clb_UnitDef_getTrackOffset, METH_VARARGS, "Clb_UnitDef_getTrackOffset" },

     {"Clb_FeatureDef_getXSize", (PyCFunction)Clb_FeatureDef_getXSize, METH_VARARGS, "Clb_FeatureDef_getXSize" },

     {"Clb_WeaponDef_isFixedLauncher", (PyCFunction)Clb_WeaponDef_isFixedLauncher, METH_VARARGS, "Clb_WeaponDef_isFixedLauncher" },

     {"Clb_UnitDef_getType", (PyCFunction)Clb_UnitDef_getType, METH_VARARGS, "Clb_UnitDef_getType" },

     {"Clb_WeaponDef_Shield_getBadColor", (PyCFunction)Clb_WeaponDef_Shield_getBadColor, METH_VARARGS, "Clb_WeaponDef_Shield_getBadColor" },

     {"Clb_UnitDef_getCobId", (PyCFunction)Clb_UnitDef_getCobId, METH_VARARGS, "Clb_UnitDef_getCobId" },

     {"Clb_UnitDef_getFlareEfficiency", (PyCFunction)Clb_UnitDef_getFlareEfficiency, METH_VARARGS, "Clb_UnitDef_getFlareEfficiency" },

     {"Clb_UnitDef_0ARRAY1SIZE1UnitDef0getBuildOptions", (PyCFunction)Clb_UnitDef_0ARRAY1SIZE1UnitDef0getBuildOptions, METH_VARARGS, "Clb_UnitDef_0ARRAY1SIZE1UnitDef0getBuildOptions" },

     {"Clb_Map_0ARRAY1VALS0getLosMap", (PyCFunction)Clb_Map_0ARRAY1VALS0getLosMap, METH_VARARGS, "Clb_Map_0ARRAY1VALS0getLosMap" },

     {"Clb_UnitDef_getSeismicRadius", (PyCFunction)Clb_UnitDef_getSeismicRadius, METH_VARARGS, "Clb_UnitDef_getSeismicRadius" },

     {"Clb_UnitDef_isNotTransportable", (PyCFunction)Clb_UnitDef_isNotTransportable, METH_VARARGS, "Clb_UnitDef_isNotTransportable" },

     {"Clb_Mod_getReclaimUnitEfficiency", (PyCFunction)Clb_Mod_getReclaimUnitEfficiency, METH_VARARGS, "Clb_Mod_getReclaimUnitEfficiency" },

     {"Clb_0MULTI1SIZE3FriendlyUnits0Unit", (PyCFunction)Clb_0MULTI1SIZE3FriendlyUnits0Unit, METH_VARARGS, "Clb_0MULTI1SIZE3FriendlyUnits0Unit" },

     {"Clb_UnitDef_getResurrectSpeed", (PyCFunction)Clb_UnitDef_getResurrectSpeed, METH_VARARGS, "Clb_UnitDef_getResurrectSpeed" },

     {"Clb_UnitDef_getHeight", (PyCFunction)Clb_UnitDef_getHeight, METH_VARARGS, "Clb_UnitDef_getHeight" },

     {"Clb_UnitDef_getWingAngle", (PyCFunction)Clb_UnitDef_getWingAngle, METH_VARARGS, "Clb_UnitDef_getWingAngle" },

     {"Clb_UnitDef_isPushResistant", (PyCFunction)Clb_UnitDef_isPushResistant, METH_VARARGS, "Clb_UnitDef_isPushResistant" },

     {"Clb_UnitDef_getBuildingDecalSizeY", (PyCFunction)Clb_UnitDef_getBuildingDecalSizeY, METH_VARARGS, "Clb_UnitDef_getBuildingDecalSizeY" },

     {"Clb_UnitDef_getBuildingDecalSizeX", (PyCFunction)Clb_UnitDef_getBuildingDecalSizeX, METH_VARARGS, "Clb_UnitDef_getBuildingDecalSizeX" },

     {"Clb_Map_0REF1Resource2resourceId0getExtractorRadius", (PyCFunction)Clb_Map_0REF1Resource2resourceId0getExtractorRadius, METH_VARARGS, "Clb_Map_0REF1Resource2resourceId0getExtractorRadius" },

     {"Clb_UnitDef_getMinWaterDepth", (PyCFunction)Clb_UnitDef_getMinWaterDepth, METH_VARARGS, "Clb_UnitDef_getMinWaterDepth" },

     {"Clb_UnitDef_isAirStrafe", (PyCFunction)Clb_UnitDef_isAirStrafe, METH_VARARGS, "Clb_UnitDef_isAirStrafe" },

     {"Clb_Unit_0REF1Resource2resourceId0getResourceUse", (PyCFunction)Clb_Unit_0REF1Resource2resourceId0getResourceUse, METH_VARARGS, "Clb_Unit_0REF1Resource2resourceId0getResourceUse" },

     {"Clb_UnitDef_isAbleToSubmerge", (PyCFunction)Clb_UnitDef_isAbleToSubmerge, METH_VARARGS, "Clb_UnitDef_isAbleToSubmerge" },

     {"Clb_Engine_Version_getNormal", (PyCFunction)Clb_Engine_Version_getNormal, METH_VARARGS, "Clb_Engine_Version_getNormal" },

     {"Clb_FeatureDef_isBurnable", (PyCFunction)Clb_FeatureDef_isBurnable, METH_VARARGS, "Clb_FeatureDef_isBurnable" },

     {"Clb_DataDirs_Roots_getSize", (PyCFunction)Clb_DataDirs_Roots_getSize, METH_VARARGS, "Clb_DataDirs_Roots_getSize" },

     {"Clb_Group_OrderPreview_0ARRAY1SIZE0getParams", (PyCFunction)Clb_Group_OrderPreview_0ARRAY1SIZE0getParams, METH_VARARGS, "Clb_Group_OrderPreview_0ARRAY1SIZE0getParams" },

     {"Clb_UnitDef_MoveData_getMaxBreaking", (PyCFunction)Clb_UnitDef_MoveData_getMaxBreaking, METH_VARARGS, "Clb_UnitDef_MoveData_getMaxBreaking" },

     {"Clb_Mod_getCaptureEnergyCostFactor", (PyCFunction)Clb_Mod_getCaptureEnergyCostFactor, METH_VARARGS, "Clb_Mod_getCaptureEnergyCostFactor" },

     {"Clb_UnitDef_getTrackStretch", (PyCFunction)Clb_UnitDef_getTrackStretch, METH_VARARGS, "Clb_UnitDef_getTrackStretch" },

     {"Clb_Map_0ARRAY1SIZE0getHeightMap", (PyCFunction)Clb_Map_0ARRAY1SIZE0getHeightMap, METH_VARARGS, "Clb_Map_0ARRAY1SIZE0getHeightMap" },

     {"Clb_WeaponDef_isSweepFire", (PyCFunction)Clb_WeaponDef_isSweepFire, METH_VARARGS, "Clb_WeaponDef_isSweepFire" },

     {"Clb_FeatureDef_isFloating", (PyCFunction)Clb_FeatureDef_isFloating, METH_VARARGS, "Clb_FeatureDef_isFloating" },

     {"Clb_FeatureDef_isUpright", (PyCFunction)Clb_FeatureDef_isUpright, METH_VARARGS, "Clb_FeatureDef_isUpright" },

     {"Clb_UnitDef_getMaxDeceleration", (PyCFunction)Clb_UnitDef_getMaxDeceleration, METH_VARARGS, "Clb_UnitDef_getMaxDeceleration" },

     {"Clb_Unit_getPos", (PyCFunction)Clb_Unit_getPos, METH_VARARGS, "Clb_Unit_getPos" },

     {"Clb_UnitDef_getDeathExplosion", (PyCFunction)Clb_UnitDef_getDeathExplosion, METH_VARARGS, "Clb_UnitDef_getDeathExplosion" },

     {"Clb_Unit_isCloaked", (PyCFunction)Clb_Unit_isCloaked, METH_VARARGS, "Clb_Unit_isCloaked" },

     {"Clb_UnitDef_getIdleTime", (PyCFunction)Clb_UnitDef_getIdleTime, METH_VARARGS, "Clb_UnitDef_getIdleTime" },

     {"Clb_Cheats_isOnlyPassive", (PyCFunction)Clb_Cheats_isOnlyPassive, METH_VARARGS, "Clb_Cheats_isOnlyPassive" },

     {"Clb_FeatureDef_getDrawType", (PyCFunction)Clb_FeatureDef_getDrawType, METH_VARARGS, "Clb_FeatureDef_getDrawType" },

     {"Clb_UnitDef_getWingDrag", (PyCFunction)Clb_UnitDef_getWingDrag, METH_VARARGS, "Clb_UnitDef_getWingDrag" },

     {"Clb_WeaponDef_Damage_getImpulseFactor", (PyCFunction)Clb_WeaponDef_Damage_getImpulseFactor, METH_VARARGS, "Clb_WeaponDef_Damage_getImpulseFactor" },

     {"Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapSpotsPositions", (PyCFunction)Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapSpotsPositions, METH_VARARGS, "Clb_Map_0ARRAY1SIZE0REF1Resource2resourceId0getResourceMapSpotsPositions" },

     {"Clb_UnitDef_isTargetingFacility", (PyCFunction)Clb_UnitDef_isTargetingFacility, METH_VARARGS, "Clb_UnitDef_isTargetingFacility" },

     {"Clb_Unit_SupportedCommand_getToolTip", (PyCFunction)Clb_Unit_SupportedCommand_getToolTip, METH_VARARGS, "Clb_Unit_SupportedCommand_getToolTip" },

     {"Clb_UnitDef_isStartCloaked", (PyCFunction)Clb_UnitDef_isStartCloaked, METH_VARARGS, "Clb_UnitDef_isStartCloaked" },

     {"Clb_WeaponDef_getIntensity", (PyCFunction)Clb_WeaponDef_getIntensity, METH_VARARGS, "Clb_WeaponDef_getIntensity" },

     {"Clb_UnitDef_MoveData_getDepth", (PyCFunction)Clb_UnitDef_MoveData_getDepth, METH_VARARGS, "Clb_UnitDef_MoveData_getDepth" },

     {"Clb_0MULTI1VALS0Feature", (PyCFunction)Clb_0MULTI1VALS0Feature, METH_VARARGS, "Clb_0MULTI1VALS0Feature" },

     {"Clb_UnitDef_isAbleToHover", (PyCFunction)Clb_UnitDef_isAbleToHover, METH_VARARGS, "Clb_UnitDef_isAbleToHover" },

     {"Clb_WeaponDef_getFireStarter", (PyCFunction)Clb_WeaponDef_getFireStarter, METH_VARARGS, "Clb_WeaponDef_getFireStarter" },

     {"Clb_UnitDef_getMaxRudder", (PyCFunction)Clb_UnitDef_getMaxRudder, METH_VARARGS, "Clb_UnitDef_getMaxRudder" },

     {"Clb_UnitDef_getTechLevel", (PyCFunction)Clb_UnitDef_getTechLevel, METH_VARARGS, "Clb_UnitDef_getTechLevel" },

     {"Clb_UnitDef_getLoadingRadius", (PyCFunction)Clb_UnitDef_getLoadingRadius, METH_VARARGS, "Clb_UnitDef_getLoadingRadius" },

     {"Clb_WeaponDef_0REF1Resource2resourceId0getCost", (PyCFunction)Clb_WeaponDef_0REF1Resource2resourceId0getCost, METH_VARARGS, "Clb_WeaponDef_0REF1Resource2resourceId0getCost" },

     {"Clb_SkirmishAI_OptionValues_getValue", (PyCFunction)Clb_SkirmishAI_OptionValues_getValue, METH_VARARGS, "Clb_SkirmishAI_OptionValues_getValue" },

     {"Clb_WeaponDef_getGraphicsType", (PyCFunction)Clb_WeaponDef_getGraphicsType, METH_VARARGS, "Clb_WeaponDef_getGraphicsType" },

     {"Clb_Engine_Version_getFull", (PyCFunction)Clb_Engine_Version_getFull, METH_VARARGS, "Clb_Engine_Version_getFull" },

     {"Clb_UnitDef_isAbleToCloak", (PyCFunction)Clb_UnitDef_isAbleToCloak, METH_VARARGS, "Clb_UnitDef_isAbleToCloak" },

     {"Clb_Mod_getVersion", (PyCFunction)Clb_Mod_getVersion, METH_VARARGS, "Clb_Mod_getVersion" },

     {"Clb_0MULTI1VALS3EnemyUnits0Unit", (PyCFunction)Clb_0MULTI1VALS3EnemyUnits0Unit, METH_VARARGS, "Clb_0MULTI1VALS3EnemyUnits0Unit" },

     {"Clb_WeaponDef_getExplosionSpeed", (PyCFunction)Clb_WeaponDef_getExplosionSpeed, METH_VARARGS, "Clb_WeaponDef_getExplosionSpeed" },

     {"Clb_Unit_isActivated", (PyCFunction)Clb_Unit_isActivated, METH_VARARGS, "Clb_Unit_isActivated" },

     {"Clb_Economy_0REF1Resource2resourceId0getUsage", (PyCFunction)Clb_Economy_0REF1Resource2resourceId0getUsage, METH_VARARGS, "Clb_Economy_0REF1Resource2resourceId0getUsage" },

     {"Clb_Mod_getAirMipLevel", (PyCFunction)Clb_Mod_getAirMipLevel, METH_VARARGS, "Clb_Mod_getAirMipLevel" },

     {"Clb_UnitDef_WeaponMount_getOnlyTargetCategory", (PyCFunction)Clb_UnitDef_WeaponMount_getOnlyTargetCategory, METH_VARARGS, "Clb_UnitDef_WeaponMount_getOnlyTargetCategory" },

     {"Clb_UnitDef_WeaponMount_getBadTargetCategory", (PyCFunction)Clb_UnitDef_WeaponMount_getBadTargetCategory, METH_VARARGS, "Clb_UnitDef_WeaponMount_getBadTargetCategory" },

     {"Clb_WeaponDef_isOnlyForward", (PyCFunction)Clb_WeaponDef_isOnlyForward, METH_VARARGS, "Clb_WeaponDef_isOnlyForward" },

     {"Clb_Map_0ARRAY1SIZE0getSlopeMap", (PyCFunction)Clb_Map_0ARRAY1SIZE0getSlopeMap, METH_VARARGS, "Clb_Map_0ARRAY1SIZE0getSlopeMap" },

     {"Clb_UnitDef_getMaxThisUnit", (PyCFunction)Clb_UnitDef_getMaxThisUnit, METH_VARARGS, "Clb_UnitDef_getMaxThisUnit" },

     {"Clb_Mod_getResurrectEnergyCostFactor", (PyCFunction)Clb_Mod_getResurrectEnergyCostFactor, METH_VARARGS, "Clb_Mod_getResurrectEnergyCostFactor" },

     {"Clb_Mod_getReclaimFeatureEnergyCostFactor", (PyCFunction)Clb_Mod_getReclaimFeatureEnergyCostFactor, METH_VARARGS, "Clb_Mod_getReclaimFeatureEnergyCostFactor" },

     {"Clb_Game_isExceptionHandlingEnabled", (PyCFunction)Clb_Game_isExceptionHandlingEnabled, METH_VARARGS, "Clb_Game_isExceptionHandlingEnabled" },

     {"Clb_UnitDef_getTrackType", (PyCFunction)Clb_UnitDef_getTrackType, METH_VARARGS, "Clb_UnitDef_getTrackType" },

     {"Clb_UnitDef_isNeedGeo", (PyCFunction)Clb_UnitDef_isNeedGeo, METH_VARARGS, "Clb_UnitDef_isNeedGeo" },

     {"Clb_UnitDef_isCommander", (PyCFunction)Clb_UnitDef_isCommander, METH_VARARGS, "Clb_UnitDef_isCommander" },

     {"Clb_UnitDef_isAirBase", (PyCFunction)Clb_UnitDef_isAirBase, METH_VARARGS, "Clb_UnitDef_isAirBase" },

     {"Clb_UnitDef_FlankingBonus_getMax", (PyCFunction)Clb_UnitDef_FlankingBonus_getMax, METH_VARARGS, "Clb_UnitDef_FlankingBonus_getMax" },

     {"Clb_Log_exception", (PyCFunction)Clb_Log_exception, METH_VARARGS, "Clb_Log_exception" },

     {"Clb_UnitDef_isAbleToLoopbackAttack", (PyCFunction)Clb_UnitDef_isAbleToLoopbackAttack, METH_VARARGS, "Clb_UnitDef_isAbleToLoopbackAttack" },

     {"Clb_WeaponDef_getProximityPriority", (PyCFunction)Clb_WeaponDef_getProximityPriority, METH_VARARGS, "Clb_WeaponDef_getProximityPriority" },

     {"Clb_UnitDef_isLeaveTracks", (PyCFunction)Clb_UnitDef_isLeaveTracks, METH_VARARGS, "Clb_UnitDef_isLeaveTracks" },

     {"Clb_Map_0ARRAY1VALS0getJammerMap", (PyCFunction)Clb_Map_0ARRAY1VALS0getJammerMap, METH_VARARGS, "Clb_Map_0ARRAY1VALS0getJammerMap" },

     {"Clb_0MULTI1SIZE3FriendlyUnitsIn0Unit", (PyCFunction)Clb_0MULTI1SIZE3FriendlyUnitsIn0Unit, METH_VARARGS, "Clb_0MULTI1SIZE3FriendlyUnitsIn0Unit" },

     {"Clb_UnitDef_isCapturable", (PyCFunction)Clb_UnitDef_isCapturable, METH_VARARGS, "Clb_UnitDef_isCapturable" },

     {"Clb_Unit_SupportedCommand_getName", (PyCFunction)Clb_Unit_SupportedCommand_getName, METH_VARARGS, "Clb_Unit_SupportedCommand_getName" },

     {"Clb_UnitDef_0ARRAY1VALS1UnitDef0getBuildOptions", (PyCFunction)Clb_UnitDef_0ARRAY1VALS1UnitDef0getBuildOptions, METH_VARARGS, "Clb_UnitDef_0ARRAY1VALS1UnitDef0getBuildOptions" },

     {"Clb_WeaponDef_getDynDamageMin", (PyCFunction)Clb_WeaponDef_getDynDamageMin, METH_VARARGS, "Clb_WeaponDef_getDynDamageMin" },

     {"Clb_WeaponDef_Damage_0ARRAY1VALS0getTypes", (PyCFunction)Clb_WeaponDef_Damage_0ARRAY1VALS0getTypes, METH_VARARGS, "Clb_WeaponDef_Damage_0ARRAY1VALS0getTypes" },

     {"Clb_WeaponDef_isImpactOnly", (PyCFunction)Clb_WeaponDef_isImpactOnly, METH_VARARGS, "Clb_WeaponDef_isImpactOnly" },

     {"Clb_WeaponDef_isAvoidFriendly", (PyCFunction)Clb_WeaponDef_isAvoidFriendly, METH_VARARGS, "Clb_WeaponDef_isAvoidFriendly" },

     {"Clb_Group_SupportedCommand_isShowUnique", (PyCFunction)Clb_Group_SupportedCommand_isShowUnique, METH_VARARGS, "Clb_Group_SupportedCommand_isShowUnique" },

     {"Clb_Map_getHumanName", (PyCFunction)Clb_Map_getHumanName, METH_VARARGS, "Clb_Map_getHumanName" },

     {"Clb_UnitDef_0MAP1SIZE0getCustomParams", (PyCFunction)Clb_UnitDef_0MAP1SIZE0getCustomParams, METH_VARARGS, "Clb_UnitDef_0MAP1SIZE0getCustomParams" },

     {"Clb_DataDirs_getConfigDir", (PyCFunction)Clb_DataDirs_getConfigDir, METH_VARARGS, "Clb_DataDirs_getConfigDir" },

     {"Clb_UnitDef_getFlareSalvoDelay", (PyCFunction)Clb_UnitDef_getFlareSalvoDelay, METH_VARARGS, "Clb_UnitDef_getFlareSalvoDelay" },

     {"Clb_UnitDef_isAbleToGuard", (PyCFunction)Clb_UnitDef_isAbleToGuard, METH_VARARGS, "Clb_UnitDef_isAbleToGuard" },

     {"Clb_Unit_getAllyTeam", (PyCFunction)Clb_Unit_getAllyTeam, METH_VARARGS, "Clb_Unit_getAllyTeam" },

     {"Clb_Map_getMaxHeight", (PyCFunction)Clb_Map_getMaxHeight, METH_VARARGS, "Clb_Map_getMaxHeight" },

     {"Clb_WeaponDef_0MAP1SIZE0getCustomParams", (PyCFunction)Clb_WeaponDef_0MAP1SIZE0getCustomParams, METH_VARARGS, "Clb_WeaponDef_0MAP1SIZE0getCustomParams" },

     {"Clb_WeaponDef_getThickness", (PyCFunction)Clb_WeaponDef_getThickness, METH_VARARGS, "Clb_WeaponDef_getThickness" },

     {"Clb_WeaponDef_isSmartShield", (PyCFunction)Clb_WeaponDef_isSmartShield, METH_VARARGS, "Clb_WeaponDef_isSmartShield" },

     {"Clb_Mod_getRequireSonarUnderWater", (PyCFunction)Clb_Mod_getRequireSonarUnderWater, METH_VARARGS, "Clb_Mod_getRequireSonarUnderWater" },

     {"Clb_Mod_getLosMipLevel", (PyCFunction)Clb_Mod_getLosMipLevel, METH_VARARGS, "Clb_Mod_getLosMipLevel" },

     {"Clb_UnitDef_getSelfDCountdown", (PyCFunction)Clb_UnitDef_getSelfDCountdown, METH_VARARGS, "Clb_UnitDef_getSelfDCountdown" },

     {"Clb_UnitDef_getMoveState", (PyCFunction)Clb_UnitDef_getMoveState, METH_VARARGS, "Clb_UnitDef_getMoveState" },

     {"Clb_Map_getName", (PyCFunction)Clb_Map_getName, METH_VARARGS, "Clb_Map_getName" },

     {"Clb_0MULTI1SIZE3TeamUnits0Unit", (PyCFunction)Clb_0MULTI1SIZE3TeamUnits0Unit, METH_VARARGS, "Clb_0MULTI1SIZE3TeamUnits0Unit" },

     {"Clb_WeaponDef_getWobble", (PyCFunction)Clb_WeaponDef_getWobble, METH_VARARGS, "Clb_WeaponDef_getWobble" },

     {"Clb_0MULTI1VALS0Group", (PyCFunction)Clb_0MULTI1VALS0Group, METH_VARARGS, "Clb_0MULTI1VALS0Group" },

     {"Clb_0MULTI1SIZE0WeaponDef", (PyCFunction)Clb_0MULTI1SIZE0WeaponDef, METH_VARARGS, "Clb_0MULTI1SIZE0WeaponDef" },

     {"Clb_Cheats_setEventsEnabled", (PyCFunction)Clb_Cheats_setEventsEnabled, METH_VARARGS, "Clb_Cheats_setEventsEnabled" },

     {"Clb_UnitDef_isAbleToCapture", (PyCFunction)Clb_UnitDef_isAbleToCapture, METH_VARARGS, "Clb_UnitDef_isAbleToCapture" },

     {"Clb_UnitDef_isUseBuildingGroundDecal", (PyCFunction)Clb_UnitDef_isUseBuildingGroundDecal, METH_VARARGS, "Clb_UnitDef_isUseBuildingGroundDecal" },

     {"Clb_UnitDef_getMaxBank", (PyCFunction)Clb_UnitDef_getMaxBank, METH_VARARGS, "Clb_UnitDef_getMaxBank" },

     {"Clb_Game_getTeamColor", (PyCFunction)Clb_Game_getTeamColor, METH_VARARGS, "Clb_Game_getTeamColor" },

     {"Clb_WeaponDef_getStockpileTime", (PyCFunction)Clb_WeaponDef_getStockpileTime, METH_VARARGS, "Clb_WeaponDef_getStockpileTime" },

     {"Clb_UnitDef_getBuildSpeed", (PyCFunction)Clb_UnitDef_getBuildSpeed, METH_VARARGS, "Clb_UnitDef_getBuildSpeed" },

     {"Clb_WeaponDef_Shield_getAlpha", (PyCFunction)Clb_WeaponDef_Shield_getAlpha, METH_VARARGS, "Clb_WeaponDef_Shield_getAlpha" },

     {"Clb_UnitDef_getTurnInPlaceSpeedLimit", (PyCFunction)Clb_UnitDef_getTurnInPlaceSpeedLimit, METH_VARARGS, "Clb_UnitDef_getTurnInPlaceSpeedLimit" },

     {"Clb_WeaponDef_isStockpileable", (PyCFunction)Clb_WeaponDef_isStockpileable, METH_VARARGS, "Clb_WeaponDef_isStockpileable" },

     {"Clb_0MULTI1VALS0UnitDef", (PyCFunction)Clb_0MULTI1VALS0UnitDef, METH_VARARGS, "Clb_0MULTI1VALS0UnitDef" },

     {"Clb_Log_log", (PyCFunction)Clb_Log_log, METH_VARARGS, "Clb_Log_log" },

     {"Clb_WeaponDef_isTracks", (PyCFunction)Clb_WeaponDef_isTracks, METH_VARARGS, "Clb_WeaponDef_isTracks" },

     {"Clb_Unit_0MULTI1SIZE1Command0CurrentCommand", (PyCFunction)Clb_Unit_0MULTI1SIZE1Command0CurrentCommand, METH_VARARGS, "Clb_Unit_0MULTI1SIZE1Command0CurrentCommand" },

     {"Clb_UnitDef_WeaponMount_getSlavedTo", (PyCFunction)Clb_UnitDef_WeaponMount_getSlavedTo, METH_VARARGS, "Clb_UnitDef_WeaponMount_getSlavedTo" },

     {"Clb_UnitDef_getBuildingDecalDecaySpeed", (PyCFunction)Clb_UnitDef_getBuildingDecalDecaySpeed, METH_VARARGS, "Clb_UnitDef_getBuildingDecalDecaySpeed" },

     {"Clb_Debug_Drawer_isEnabled", (PyCFunction)Clb_Debug_Drawer_isEnabled, METH_VARARGS, "Clb_Debug_Drawer_isEnabled" },

     {"Clb_WeaponDef_isGroundBounce", (PyCFunction)Clb_WeaponDef_isGroundBounce, METH_VARARGS, "Clb_WeaponDef_isGroundBounce" },

     {"Clb_UnitDef_getArmorType", (PyCFunction)Clb_UnitDef_getArmorType, METH_VARARGS, "Clb_UnitDef_getArmorType" },

     {"Clb_Unit_0MULTI1SIZE0SupportedCommand", (PyCFunction)Clb_Unit_0MULTI1SIZE0SupportedCommand, METH_VARARGS, "Clb_Unit_0MULTI1SIZE0SupportedCommand" },

     {"Clb_UnitDef_isOnOffable", (PyCFunction)Clb_UnitDef_isOnOffable, METH_VARARGS, "Clb_UnitDef_isOnOffable" },

     {"Clb_WeaponDef_getProjectilesPerShot", (PyCFunction)Clb_WeaponDef_getProjectilesPerShot, METH_VARARGS, "Clb_WeaponDef_getProjectilesPerShot" },

     {"Clb_Unit_isBeingBuilt", (PyCFunction)Clb_Unit_isBeingBuilt, METH_VARARGS, "Clb_Unit_isBeingBuilt" },

     {"Clb_UnitDef_getMaxSlope", (PyCFunction)Clb_UnitDef_getMaxSlope, METH_VARARGS, "Clb_UnitDef_getMaxSlope" },

     {"Clb_DataDirs_getWriteableDir", (PyCFunction)Clb_DataDirs_getWriteableDir, METH_VARARGS, "Clb_DataDirs_getWriteableDir" },

     {"Clb_Mod_getFileName", (PyCFunction)Clb_Mod_getFileName, METH_VARARGS, "Clb_Mod_getFileName" },

     {"Clb_0MULTI1VALS3TeamUnits0Unit", (PyCFunction)Clb_0MULTI1VALS3TeamUnits0Unit, METH_VARARGS, "Clb_0MULTI1VALS3TeamUnits0Unit" },

     {"Clb_WeaponDef_Shield_getRadius", (PyCFunction)Clb_WeaponDef_Shield_getRadius, METH_VARARGS, "Clb_WeaponDef_Shield_getRadius" },

     {"Clb_UnitDef_getHealth", (PyCFunction)Clb_UnitDef_getHealth, METH_VARARGS, "Clb_UnitDef_getHealth" },

     {"Clb_UnitDef_getFrontToSpeed", (PyCFunction)Clb_UnitDef_getFrontToSpeed, METH_VARARGS, "Clb_UnitDef_getFrontToSpeed" },

     {"Clb_UnitDef_isAbleToReclaim", (PyCFunction)Clb_UnitDef_isAbleToReclaim, METH_VARARGS, "Clb_UnitDef_isAbleToReclaim" },

     {"Clb_UnitDef_isLevelGround", (PyCFunction)Clb_UnitDef_isLevelGround, METH_VARARGS, "Clb_UnitDef_isLevelGround" },

     {"Clb_UnitDef_getMaxPitch", (PyCFunction)Clb_UnitDef_getMaxPitch, METH_VARARGS, "Clb_UnitDef_getMaxPitch" },

     {"Clb_WeaponDef_isSelfExplode", (PyCFunction)Clb_WeaponDef_isSelfExplode, METH_VARARGS, "Clb_WeaponDef_isSelfExplode" },

     {"Clb_UnitDef_MoveData_getMaxSlope", (PyCFunction)Clb_UnitDef_MoveData_getMaxSlope, METH_VARARGS, "Clb_UnitDef_MoveData_getMaxSlope" },

     {"Clb_UnitDef_getWreckName", (PyCFunction)Clb_UnitDef_getWreckName, METH_VARARGS, "Clb_UnitDef_getWreckName" },

     {"Clb_WeaponDef_getBounceRebound", (PyCFunction)Clb_WeaponDef_getBounceRebound, METH_VARARGS, "Clb_WeaponDef_getBounceRebound" },

     {"Clb_UnitDef_getUnitFallSpeed", (PyCFunction)Clb_UnitDef_getUnitFallSpeed, METH_VARARGS, "Clb_UnitDef_getUnitFallSpeed" },

     {"Clb_WeaponDef_getFileName", (PyCFunction)Clb_WeaponDef_getFileName, METH_VARARGS, "Clb_WeaponDef_getFileName" },

     {"Clb_Mod_getDescription", (PyCFunction)Clb_Mod_getDescription, METH_VARARGS, "Clb_Mod_getDescription" },

     {"Clb_Unit_CurrentCommand_0ARRAY1VALS0getParams", (PyCFunction)Clb_Unit_CurrentCommand_0ARRAY1VALS0getParams, METH_VARARGS, "Clb_Unit_CurrentCommand_0ARRAY1VALS0getParams" },

     {"Clb_WeaponDef_getHeightMod", (PyCFunction)Clb_WeaponDef_getHeightMod, METH_VARARGS, "Clb_WeaponDef_getHeightMod" },

     {"Clb_Map_0REF1UnitDef2unitDefId0isPossibleToBuildAt", (PyCFunction)Clb_Map_0REF1UnitDef2unitDefId0isPossibleToBuildAt, METH_VARARGS, "Clb_Map_0REF1UnitDef2unitDefId0isPossibleToBuildAt" },

     {"Clb_0MULTI1SIZE3NeutralUnits0Unit", (PyCFunction)Clb_0MULTI1SIZE3NeutralUnits0Unit, METH_VARARGS, "Clb_0MULTI1SIZE3NeutralUnits0Unit" },

     {"Clb_WeaponDef_getUpTime", (PyCFunction)Clb_WeaponDef_getUpTime, METH_VARARGS, "Clb_WeaponDef_getUpTime" },

     {"Clb_UnitDef_getSonarJamRadius", (PyCFunction)Clb_UnitDef_getSonarJamRadius, METH_VARARGS, "Clb_UnitDef_getSonarJamRadius" },

     {"Clb_UnitDef_WeaponMount_getName", (PyCFunction)Clb_UnitDef_WeaponMount_getName, METH_VARARGS, "Clb_UnitDef_WeaponMount_getName" },

     {"Clb_Game_getTeamAllyTeam", (PyCFunction)Clb_Game_getTeamAllyTeam, METH_VARARGS, "Clb_Game_getTeamAllyTeam" },

     {"Clb_Gui_Camera_getDirection", (PyCFunction)Clb_Gui_Camera_getDirection, METH_VARARGS, "Clb_Gui_Camera_getDirection" },

     {"Clb_Engine_handleCommand", (PyCFunction)Clb_Engine_handleCommand, METH_VARARGS, "Clb_Engine_handleCommand" },

     {"Clb_WeaponDef_getMaxAngle", (PyCFunction)Clb_WeaponDef_getMaxAngle, METH_VARARGS, "Clb_WeaponDef_getMaxAngle" },

     {"Clb_Engine_Version_getAdditional", (PyCFunction)Clb_Engine_Version_getAdditional, METH_VARARGS, "Clb_Engine_Version_getAdditional" },

     {"Clb_Unit_getStockpile", (PyCFunction)Clb_Unit_getStockpile, METH_VARARGS, "Clb_Unit_getStockpile" },

     {"Clb_WeaponDef_getAccuracy", (PyCFunction)Clb_WeaponDef_getAccuracy, METH_VARARGS, "Clb_WeaponDef_getAccuracy" },

     {"Clb_0MULTI1FETCH3ResourceByName0Resource", (PyCFunction)Clb_0MULTI1FETCH3ResourceByName0Resource, METH_VARARGS, "Clb_0MULTI1FETCH3ResourceByName0Resource" },

     {"Clb_WeaponDef_isWaterWeapon", (PyCFunction)Clb_WeaponDef_isWaterWeapon, METH_VARARGS, "Clb_WeaponDef_isWaterWeapon" },

     {"Clb_0MULTI1VALS3EnemyUnitsIn0Unit", (PyCFunction)Clb_0MULTI1VALS3EnemyUnitsIn0Unit, METH_VARARGS, "Clb_0MULTI1VALS3EnemyUnitsIn0Unit" },

     {"Clb_UnitDef_getBuildTime", (PyCFunction)Clb_UnitDef_getBuildTime, METH_VARARGS, "Clb_UnitDef_getBuildTime" },

     {"Clb_UnitDef_0MAP1VALS0getCustomParams", (PyCFunction)Clb_UnitDef_0MAP1VALS0getCustomParams, METH_VARARGS, "Clb_UnitDef_0MAP1VALS0getCustomParams" },

     {"Clb_WeaponDef_getSize", (PyCFunction)Clb_WeaponDef_getSize, METH_VARARGS, "Clb_WeaponDef_getSize" },

     {"Clb_0MULTI1SIZE0Resource", (PyCFunction)Clb_0MULTI1SIZE0Resource, METH_VARARGS, "Clb_0MULTI1SIZE0Resource" },

     {"Clb_Unit_SupportedCommand_isDisabled", (PyCFunction)Clb_Unit_SupportedCommand_isDisabled, METH_VARARGS, "Clb_Unit_SupportedCommand_isDisabled" },

     {"Clb_UnitDef_MoveData_getMoveType", (PyCFunction)Clb_UnitDef_MoveData_getMoveType, METH_VARARGS, "Clb_UnitDef_MoveData_getMoveType" },

     {"Clb_UnitDef_isActivateWhenBuilt", (PyCFunction)Clb_UnitDef_isActivateWhenBuilt, METH_VARARGS, "Clb_UnitDef_isActivateWhenBuilt" },

     {"Clb_UnitDef_isAbleToPatrol", (PyCFunction)Clb_UnitDef_isAbleToPatrol, METH_VARARGS, "Clb_UnitDef_isAbleToPatrol" },

     {"Clb_WeaponDef_getDescription", (PyCFunction)Clb_WeaponDef_getDescription, METH_VARARGS, "Clb_WeaponDef_getDescription" },

     {"Clb_WeaponDef_getMovingAccuracy", (PyCFunction)Clb_WeaponDef_getMovingAccuracy, METH_VARARGS, "Clb_WeaponDef_getMovingAccuracy" },

     {"Clb_UnitDef_getMinTransportSize", (PyCFunction)Clb_UnitDef_getMinTransportSize, METH_VARARGS, "Clb_UnitDef_getMinTransportSize" },

     {"Clb_UnitDef_isAbleToRestore", (PyCFunction)Clb_UnitDef_isAbleToRestore, METH_VARARGS, "Clb_UnitDef_isAbleToRestore" },

     {"Clb_Map_0ARRAY1VALS0getSlopeMap", (PyCFunction)Clb_Map_0ARRAY1VALS0getSlopeMap, METH_VARARGS, "Clb_Map_0ARRAY1VALS0getSlopeMap" },

     {"Clb_WeaponDef_isGravityAffected", (PyCFunction)Clb_WeaponDef_isGravityAffected, METH_VARARGS, "Clb_WeaponDef_isGravityAffected" },

     {"Clb_WeaponDef_getType", (PyCFunction)Clb_WeaponDef_getType, METH_VARARGS, "Clb_WeaponDef_getType" },

     {"Clb_0MULTI1VALS3FeaturesIn0Feature", (PyCFunction)Clb_0MULTI1VALS3FeaturesIn0Feature, METH_VARARGS, "Clb_0MULTI1VALS3FeaturesIn0Feature" },

     {"Clb_UnitDef_isHoverAttack", (PyCFunction)Clb_UnitDef_isHoverAttack, METH_VARARGS, "Clb_UnitDef_isHoverAttack" },

     {"Clb_UnitDef_MoveData_getName", (PyCFunction)Clb_UnitDef_MoveData_getName, METH_VARARGS, "Clb_UnitDef_MoveData_getName" },

     {"Clb_UnitDef_getGaia", (PyCFunction)Clb_UnitDef_getGaia, METH_VARARGS, "Clb_UnitDef_getGaia" },

     {"Clb_WeaponDef_getLaserFlareSize", (PyCFunction)Clb_WeaponDef_getLaserFlareSize, METH_VARARGS, "Clb_WeaponDef_getLaserFlareSize" },

     {"Clb_UnitDef_WeaponMount_getMaxAngleDif", (PyCFunction)Clb_UnitDef_WeaponMount_getMaxAngleDif, METH_VARARGS, "Clb_UnitDef_WeaponMount_getMaxAngleDif" },

     {"Clb_Mod_getConstructionDecayTime", (PyCFunction)Clb_Mod_getConstructionDecayTime, METH_VARARGS, "Clb_Mod_getConstructionDecayTime" },

     {"Clb_WeaponDef_getRestTime", (PyCFunction)Clb_WeaponDef_getRestTime, METH_VARARGS, "Clb_WeaponDef_getRestTime" },

     {"Clb_UnitDef_getMass", (PyCFunction)Clb_UnitDef_getMass, METH_VARARGS, "Clb_UnitDef_getMass" },

     {"Clb_Group_SupportedCommand_isDisabled", (PyCFunction)Clb_Group_SupportedCommand_isDisabled, METH_VARARGS, "Clb_Group_SupportedCommand_isDisabled" },

     {"Clb_Map_isPosInCamera", (PyCFunction)Clb_Map_isPosInCamera, METH_VARARGS, "Clb_Map_isPosInCamera" },

     {"Clb_UnitDef_0REF1Resource2resourceId0getTidalResourceGenerator", (PyCFunction)Clb_UnitDef_0REF1Resource2resourceId0getTidalResourceGenerator, METH_VARARGS, "Clb_UnitDef_0REF1Resource2resourceId0getTidalResourceGenerator" },

     {"Clb_UnitDef_isBuilder", (PyCFunction)Clb_UnitDef_isBuilder, METH_VARARGS, "Clb_UnitDef_isBuilder" },

     {"Clb_Mod_getFlankingBonusModeDefault", (PyCFunction)Clb_Mod_getFlankingBonusModeDefault, METH_VARARGS, "Clb_Mod_getFlankingBonusModeDefault" },

     {"Clb_UnitDef_getTransportMass", (PyCFunction)Clb_UnitDef_getTransportMass, METH_VARARGS, "Clb_UnitDef_getTransportMass" },

     {"Clb_DataDirs_locatePath", (PyCFunction)Clb_DataDirs_locatePath, METH_VARARGS, "Clb_DataDirs_locatePath" },

     {"Clb_Feature_0SINGLE1FETCH2FeatureDef0getDef", (PyCFunction)Clb_Feature_0SINGLE1FETCH2FeatureDef0getDef, METH_VARARGS, "Clb_Feature_0SINGLE1FETCH2FeatureDef0getDef" },

     {"Clb_Unit_getMaxSpeed", (PyCFunction)Clb_Unit_getMaxSpeed, METH_VARARGS, "Clb_Unit_getMaxSpeed" },

     {"Clb_UnitDef_getMaxAileron", (PyCFunction)Clb_UnitDef_getMaxAileron, METH_VARARGS, "Clb_UnitDef_getMaxAileron" },

     {"Clb_UnitDef_getControlRadius", (PyCFunction)Clb_UnitDef_getControlRadius, METH_VARARGS, "Clb_UnitDef_getControlRadius" },

     {"Clb_Game_getSetupScript", (PyCFunction)Clb_Game_getSetupScript, METH_VARARGS, "Clb_Game_getSetupScript" },

     {"Clb_SkirmishAI_OptionValues_getSize", (PyCFunction)Clb_SkirmishAI_OptionValues_getSize, METH_VARARGS, "Clb_SkirmishAI_OptionValues_getSize" },

     {"Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsAverageIncome", (PyCFunction)Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsAverageIncome, METH_VARARGS, "Clb_Map_0ARRAY1VALS0REF1Resource2resourceId0initResourceMapSpotsAverageIncome" },

     {"Clb_DataDirs_Roots_getDir", (PyCFunction)Clb_DataDirs_Roots_getDir, METH_VARARGS, "Clb_DataDirs_Roots_getDir" },

     {"Clb_UnitDef_getMaxWaterDepth", (PyCFunction)Clb_UnitDef_getMaxWaterDepth, METH_VARARGS, "Clb_UnitDef_getMaxWaterDepth" },

     {"Clb_Map_0ARRAY1SIZE0getLosMap", (PyCFunction)Clb_Map_0ARRAY1SIZE0getLosMap, METH_VARARGS, "Clb_Map_0ARRAY1SIZE0getLosMap" },

     {"Clb_WeaponDef_getAreaOfEffect", (PyCFunction)Clb_WeaponDef_getAreaOfEffect, METH_VARARGS, "Clb_WeaponDef_getAreaOfEffect" },

     {"Clb_0MULTI1VALS3FriendlyUnits0Unit", (PyCFunction)Clb_0MULTI1VALS3FriendlyUnits0Unit, METH_VARARGS, "Clb_0MULTI1VALS3FriendlyUnits0Unit" },

     {"Clb_UnitDef_getTrackStrength", (PyCFunction)Clb_UnitDef_getTrackStrength, METH_VARARGS, "Clb_UnitDef_getTrackStrength" },

     {"Clb_UnitDef_getTerraformSpeed", (PyCFunction)Clb_UnitDef_getTerraformSpeed, METH_VARARGS, "Clb_UnitDef_getTerraformSpeed" },

     {"Clb_WeaponDef_Damage_getCraterBoost", (PyCFunction)Clb_WeaponDef_Damage_getCraterBoost, METH_VARARGS, "Clb_WeaponDef_Damage_getCraterBoost" },

     {"Clb_UnitDef_isAbleToFireControl", (PyCFunction)Clb_UnitDef_isAbleToFireControl, METH_VARARGS, "Clb_UnitDef_isAbleToFireControl" },

     {"Clb_WeaponDef_getTurnRate", (PyCFunction)Clb_WeaponDef_getTurnRate, METH_VARARGS, "Clb_WeaponDef_getTurnRate" },

     {"Clb_Unit_getBuildingFacing", (PyCFunction)Clb_Unit_getBuildingFacing, METH_VARARGS, "Clb_Unit_getBuildingFacing" },

     {"Clb_UnitDef_isAbleToSelfD", (PyCFunction)Clb_UnitDef_isAbleToSelfD, METH_VARARGS, "Clb_UnitDef_isAbleToSelfD" },

     {"Clb_UnitDef_MoveData_getMaxSpeed", (PyCFunction)Clb_UnitDef_MoveData_getMaxSpeed, METH_VARARGS, "Clb_UnitDef_MoveData_getMaxSpeed" },

     {"Clb_UnitDef_isUpright", (PyCFunction)Clb_UnitDef_isUpright, METH_VARARGS, "Clb_UnitDef_isUpright" },

     {"Clb_UnitDef_isBuildRange3D", (PyCFunction)Clb_UnitDef_isBuildRange3D, METH_VARARGS, "Clb_UnitDef_isBuildRange3D" },

     {"Clb_FeatureDef_getMaxHealth", (PyCFunction)Clb_FeatureDef_getMaxHealth, METH_VARARGS, "Clb_FeatureDef_getMaxHealth" },

     {"Clb_Game_isPaused", (PyCFunction)Clb_Game_isPaused, METH_VARARGS, "Clb_Game_isPaused" },

     {"Clb_WeaponDef_isNoAutoTarget", (PyCFunction)Clb_WeaponDef_isNoAutoTarget, METH_VARARGS, "Clb_WeaponDef_isNoAutoTarget" },

     {"Clb_UnitDef_isFirePlatform", (PyCFunction)Clb_UnitDef_isFirePlatform, METH_VARARGS, "Clb_UnitDef_isFirePlatform" },

     {"Clb_Unit_SupportedCommand_0ARRAY1SIZE0getParams", (PyCFunction)Clb_Unit_SupportedCommand_0ARRAY1SIZE0getParams, METH_VARARGS, "Clb_Unit_SupportedCommand_0ARRAY1SIZE0getParams" },

     {"Clb_Mod_getTransportAir", (PyCFunction)Clb_Mod_getTransportAir, METH_VARARGS, "Clb_Mod_getTransportAir" },

     {"Clb_WeaponDef_isVisibleShield", (PyCFunction)Clb_WeaponDef_isVisibleShield, METH_VARARGS, "Clb_WeaponDef_isVisibleShield" },

     {"Clb_UnitDef_getBuildAngle", (PyCFunction)Clb_UnitDef_getBuildAngle, METH_VARARGS, "Clb_UnitDef_getBuildAngle" },

     {"Clb_Mod_getReclaimMethod", (PyCFunction)Clb_Mod_getReclaimMethod, METH_VARARGS, "Clb_Mod_getReclaimMethod" },

     {"Clb_UnitDef_isAbleToDropFlare", (PyCFunction)Clb_UnitDef_isAbleToDropFlare, METH_VARARGS, "Clb_UnitDef_isAbleToDropFlare" },

     {"Clb_UnitDef_isFactoryHeadingTakeoff", (PyCFunction)Clb_UnitDef_isFactoryHeadingTakeoff, METH_VARARGS, "Clb_UnitDef_isFactoryHeadingTakeoff" },

     {"Clb_Feature_getHealth", (PyCFunction)Clb_Feature_getHealth, METH_VARARGS, "Clb_Feature_getHealth" },

     {"Clb_Engine_Version_getBuildTime", (PyCFunction)Clb_Engine_Version_getBuildTime, METH_VARARGS, "Clb_Engine_Version_getBuildTime" },

     {"Clb_0MULTI1VALS3FriendlyUnitsIn0Unit", (PyCFunction)Clb_0MULTI1VALS3FriendlyUnitsIn0Unit, METH_VARARGS, "Clb_0MULTI1VALS3FriendlyUnitsIn0Unit" },

     {"Clb_File_getSize", (PyCFunction)Clb_File_getSize, METH_VARARGS, "Clb_File_getSize" },

     {"Clb_Unit_0MULTI1SIZE0ResourceInfo", (PyCFunction)Clb_Unit_0MULTI1SIZE0ResourceInfo, METH_VARARGS, "Clb_Unit_0MULTI1SIZE0ResourceInfo" },

     {"Clb_Group_OrderPreview_0ARRAY1VALS0getParams", (PyCFunction)Clb_Group_OrderPreview_0ARRAY1VALS0getParams, METH_VARARGS, "Clb_Group_OrderPreview_0ARRAY1VALS0getParams" },

     {"Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getStockpileDef", (PyCFunction)Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getStockpileDef, METH_VARARGS, "Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getStockpileDef" },

     {"Clb_UnitDef_isAbleToResurrect", (PyCFunction)Clb_UnitDef_isAbleToResurrect, METH_VARARGS, "Clb_UnitDef_isAbleToResurrect" },

     {"Clb_DataDirs_getPathSeparator", (PyCFunction)Clb_DataDirs_getPathSeparator, METH_VARARGS, "Clb_DataDirs_getPathSeparator" },

     {"Clb_UnitDef_getFileName", (PyCFunction)Clb_UnitDef_getFileName, METH_VARARGS, "Clb_UnitDef_getFileName" },

     {"Clb_Unit_getHealth", (PyCFunction)Clb_Unit_getHealth, METH_VARARGS, "Clb_Unit_getHealth" },

     {"Clb_Mod_getConstructionDecay", (PyCFunction)Clb_Mod_getConstructionDecay, METH_VARARGS, "Clb_Mod_getConstructionDecay" },

     {"Clb_WeaponDef_getMyGravity", (PyCFunction)Clb_WeaponDef_getMyGravity, METH_VARARGS, "Clb_WeaponDef_getMyGravity" },

     {"Clb_UnitDef_getRadius", (PyCFunction)Clb_UnitDef_getRadius, METH_VARARGS, "Clb_UnitDef_getRadius" },

     {"Clb_UnitDef_getFlareSalvoSize", (PyCFunction)Clb_UnitDef_getFlareSalvoSize, METH_VARARGS, "Clb_UnitDef_getFlareSalvoSize" },

     {"Clb_UnitDef_isDecloakSpherical", (PyCFunction)Clb_UnitDef_isDecloakSpherical, METH_VARARGS, "Clb_UnitDef_isDecloakSpherical" },

     {"Clb_UnitDef_getMaxFuel", (PyCFunction)Clb_UnitDef_getMaxFuel, METH_VARARGS, "Clb_UnitDef_getMaxFuel" },

     {"Clb_UnitDef_getSlideTolerance", (PyCFunction)Clb_UnitDef_getSlideTolerance, METH_VARARGS, "Clb_UnitDef_getSlideTolerance" },

     {"Clb_WeaponDef_isAbleToAttackGround", (PyCFunction)Clb_WeaponDef_isAbleToAttackGround, METH_VARARGS, "Clb_WeaponDef_isAbleToAttackGround" },

     {"Clb_UnitDef_getKamikazeDist", (PyCFunction)Clb_UnitDef_getKamikazeDist, METH_VARARGS, "Clb_UnitDef_getKamikazeDist" },

     {"Clb_WeaponDef_getHighTrajectory", (PyCFunction)Clb_WeaponDef_getHighTrajectory, METH_VARARGS, "Clb_WeaponDef_getHighTrajectory" },

     {"Clb_Mod_getFireAtKilled", (PyCFunction)Clb_Mod_getFireAtKilled, METH_VARARGS, "Clb_Mod_getFireAtKilled" },

     {"Clb_WeaponDef_getFlightTime", (PyCFunction)Clb_WeaponDef_getFlightTime, METH_VARARGS, "Clb_WeaponDef_getFlightTime" },

     {"Clb_Map_0REF1UnitDef2unitDefId0findClosestBuildSite", (PyCFunction)Clb_Map_0REF1UnitDef2unitDefId0findClosestBuildSite, METH_VARARGS, "Clb_Map_0REF1UnitDef2unitDefId0findClosestBuildSite" },

     {"Clb_UnitDef_MoveData_getMoveFamily", (PyCFunction)Clb_UnitDef_MoveData_getMoveFamily, METH_VARARGS, "Clb_UnitDef_MoveData_getMoveFamily" },

     {"Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getShieldDef", (PyCFunction)Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getShieldDef, METH_VARARGS, "Clb_UnitDef_0SINGLE1FETCH2WeaponDef0getShieldDef" },

     {"Clb_FeatureDef_0MAP1VALS0getCustomParams", (PyCFunction)Clb_FeatureDef_0MAP1VALS0getCustomParams, METH_VARARGS, "Clb_FeatureDef_0MAP1VALS0getCustomParams" },

     {"Clb_UnitDef_0MULTI1SIZE0WeaponMount", (PyCFunction)Clb_UnitDef_0MULTI1SIZE0WeaponMount, METH_VARARGS, "Clb_UnitDef_0MULTI1SIZE0WeaponMount" },

     {"Clb_Unit_0SINGLE1FETCH2UnitDef0getDef", (PyCFunction)Clb_Unit_0SINGLE1FETCH2UnitDef0getDef, METH_VARARGS, "Clb_Unit_0SINGLE1FETCH2UnitDef0getDef" },

     {"Clb_Map_0ARRAY1SIZE0getJammerMap", (PyCFunction)Clb_Map_0ARRAY1SIZE0getJammerMap, METH_VARARGS, "Clb_Map_0ARRAY1SIZE0getJammerMap" },

     {"Clb_FeatureDef_isNoSelect", (PyCFunction)Clb_FeatureDef_isNoSelect, METH_VARARGS, "Clb_FeatureDef_isNoSelect" },

     {"Clb_Group_SupportedCommand_getName", (PyCFunction)Clb_Group_SupportedCommand_getName, METH_VARARGS, "Clb_Group_SupportedCommand_getName" },

     {"Clb_WeaponDef_getLodDistance", (PyCFunction)Clb_WeaponDef_getLodDistance, METH_VARARGS, "Clb_WeaponDef_getLodDistance" },

     {"Clb_Game_isDebugModeEnabled", (PyCFunction)Clb_Game_isDebugModeEnabled, METH_VARARGS, "Clb_Game_isDebugModeEnabled" },

     {"Clb_WeaponDef_Shield_getPowerRegen", (PyCFunction)Clb_WeaponDef_Shield_getPowerRegen, METH_VARARGS, "Clb_WeaponDef_Shield_getPowerRegen" },

     {"Clb_Mod_getMutator", (PyCFunction)Clb_Mod_getMutator, METH_VARARGS, "Clb_Mod_getMutator" },

    {NULL}  /* Sentinel */
};

static PyTypeObject PyAICallback_Type = {
    PyObject_HEAD_INIT(NULL)
    0,                         /*ob_size*/
    "PyAICallback",            /*tp_name*/
    sizeof(PyAICallbackObject),/*tp_basicsize*/
    0,                         /*tp_itemsize*/
    0,                         /*tp_dealloc*/
    0,                         /*tp_print*/
    0,                         /*tp_getattr*/
    0,                         /*tp_setattr*/
    0,                         /*tp_compare*/
    0,                         /*tp_repr*/
    0,                         /*tp_as_number*/
    0,                         /*tp_as_sequence*/
    0,                         /*tp_as_mapping*/
    0,                         /*tp_hash */
    0,                         /*tp_call*/
    0,                         /*tp_str*/
    0,                         /*tp_getattro*/
    0,                         /*tp_setattro*/
    0,                         /*tp_as_buffer*/
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE, /*tp_flags*/
    "callback object",           /* tp_doc */
    0,                         /* tp_traverse */
    0,                         /* tp_clear */
    0,                         /* tp_richcompare */
    0,                         /* tp_weaklistoffset */
    0,                         /* tp_iter */
    0,                         /* tp_iternext */
    callback_methods,             /* tp_methods */
};


static PyObject* hWrapper;
static const PyObject* hSysModule;

/*add to search path and load module */
PyObject *pythonLoadModule(const char *modul, const char* path)
{
	PyObject *res=NULL;
	PyObject *tmpname;
	if (path!=NULL){
		simpleLog_log("Including Python search path %s", path);
		PyObject* pathlist = PyObject_GetAttrString((PyObject*)hSysModule, "path");
		PyList_Append(pathlist, PyString_FromString(path));
	}
	tmpname=PyString_FromString(modul);
	res=PyImport_Import(tmpname);
	if (!res){
		simpleLog_log("Could not load python module %s\"%s\"",path,modul);
		PyErr_Print();
		return res;
	}
	if (path==NULL)
		simpleLog_log("Loaded Python Module %s in default search path",modul);
	else
		simpleLog_log("Loaded Python Module %s in %s",modul, path);
	Py_DECREF(tmpname);
	return res;
}
/**
* Through this function, the AI receives events from the engine.
* For details about events that may arrive here, see file AISEvents.h.
*
* @param       teamId  the instance of the AI that the event is addressed to
* @param       topic   unique identifyer of a message
*                                      (see EVENT_* defines in AISEvents.h)
* @param       data    an topic specific struct, which contains the data
*                                      associatedwith the event
*                                      (see S*Event structs in AISEvents.h)
* @return     0: ok
*          != 0: error
*/
int CALLING_CONV python_handleEvent(int teamId, int topic, const void* data)
{
	PyObject * pfunc;
	PyObject * args;
	if (hWrapper==NULL){
	    //FIXME we should return -1 here but spring then doesn't allow an /aireload command
	    return 0;
	}
	pfunc=PyObject_GetAttrString((PyObject*)hWrapper,PYTHON_INTERFACE_HANDLE_EVENT);
	if (!pfunc){
		simpleLog_log("failed to extract function from module");
	return -1;
	}
	args = Py_BuildValue("(iiO)",teamId, topic, event_convert(topic,(void*)data));
	if (!args){
	    simpleLog_log("failed to build args");
	    return -1;
	}
	PyObject_CallObject(pfunc, args);
	Py_DECREF(pfunc);
	return 0;
}

/**
* This function is called, when an AI instance shall be created for teamId.
* It is called before the first call to handleEvent() for teamId.
*
* A typical series of events (engine point of view, conceptual):
* [code]
* KAIK.init(1)
* KAIK.handleEvent(EVENT_INIT, InitEvent(1))
* RAI.init(2)
* RAI.handleEvent(EVENT_INIT, InitEvent(2))
* KAIK.handleEvent(EVENT_UPDATE, UpdateEvent(0))
* RAI.handleEvent(EVENT_UPDATE, UpdateEvent(0))
* KAIK.handleEvent(EVENT_UPDATE, UpdateEvent(1))
* RAI.handleEvent(EVENT_UPDATE, UpdateEvent(1))
* ...
* [/code]
*
* This method exists only for performance reasons, which come into play on
* OO languages. For non-OO language AIs, this method can be ignored,
* because using only EVENT_INIT will cause no performance decrease.
*
* [optional]
* An AI not exporting this function is still valid.
*
* @param       teamId        the teamId this library shall create an instance for
* @param       callback      the callback for this Skirmish AI
* @return     0: ok
*          != 0: error
*/
int CALLING_CONV python_init(int teamId, const struct SSkirmishAICallback* aiCallback)
{
	simpleLog_log("python_init()");
	const char* className = aiCallback->Clb_SkirmishAI_Info_getValueByKey(teamId,
			PYTHON_SKIRMISH_AI_PROPERTY_CLASS_NAME);
	simpleLog_log("Name of the AI: %s",className);
	const char* modName = aiCallback->Clb_SkirmishAI_Info_getValueByKey(teamId,
			PYTHON_SKIRMISH_AI_PROPERTY_MODULE_NAME);
	simpleLog_log("Python Class Name: %s",modName);

	const char* aipath = aiCallback->Clb_DataDirs_getConfigDir(teamId);
	PyObject* aimodule = pythonLoadModule(modName, aipath);	
	if (!aimodule)
		return -1;

	
	PyObject* class = PyObject_GetAttrString(aimodule, className);
	if (!class)
		return -1;
	
	PyObject* classlist = PyObject_GetAttrString((PyObject*)hWrapper, "aiClasses");
	if (!classlist)
		return -1;

	if (PyType_Ready(&PyAICallback_Type) < 0){
		simpleLog_log("Error PyType_Ready()");
		PyErr_Print();
		return -1;
	}
	return PyDict_SetItem(classlist, PyInt_FromLong(teamId), class);
}
/**
* This function is called, when an AI instance shall be deleted.
* It is called after the last call to handleEvent() for teamId.
*
* A typical series of events (engine point of view, conceptual):
* [code]
* ...
* KAIK.handleEvent(EVENT_UPDATE, UpdateEvent(654321))
* RAI.handleEvent(EVENT_UPDATE, UpdateEvent(654321))
* KAIK.handleEvent(EVENT_UPDATE, UpdateEvent(654322))
* RAI.handleEvent(EVENT_UPDATE, UpdateEvent(654322))
* KAIK.handleEvent(EVENT_RELEASE, ReleaseEvent(1))
* KAIK.release(1)
* RAI.handleEvent(EVENT_RELEASE, ReleaseEvent(2))
* RAI.release(2)
* [/code]
*
* This method exists only for performance reasons, which come into play on
* OO languages. For non-OO language AIs, this method can be ignored,
* because using only EVENT_RELEASE will cause no performance decrease.
*
* [optional]
* An AI not exporting this function is still valid.
*
* @param       teamId  the teamId the library shall release the instance of
* @return     0: ok
*          != 0: error
*/
int CALLING_CONV python_release(int teamId)
{
	//TODO: call python-release function
	simpleLog_log("python_release()");
	return 0;
}

/*
 * Initialize the Python Interpreter
 * @return 0 on success
 */
int python_load(const struct SAIInterfaceCallback* callback,const int interfaceId)
{
	simpleLog_log("python_load()");
	//Initalize Python
	Py_Initialize();
	simpleLog_log("Initialized python %s",Py_GetVersion());
	hSysModule=pythonLoadModule("sys", NULL);
	if (!hSysModule)
		return -1;
	hWrapper=pythonLoadModule(PYTHON_INTERFACE_MODULE_NAME,callback->DataDirs_getConfigDir(interfaceId));
	if (!hWrapper)
		return -1;

	return 0;
}

/*
 * Unload the Python Interpreter
 */
void python_unload(void){
	simpleLog_log("python_unload()");
	Py_Finalize();
	hWrapper=NULL;
	hSysModule=NULL;
}
