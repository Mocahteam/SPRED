#include "PP_Client.h"
#include "constantList_KP4.1.h"

int main () {
	PP_Open(); /* open the Prog&Play API */
	while(PP_GetNumUnits(ENEMY_COALITION) > 0)
		PP_Unit_ActionOnUnit(PP_GetUnitAt(MY_COALITION, 0), ATTACK, PP_GetUnitAt(ENEMY_COALITION, 0));
	/* close the Prog&Play API */
	PP_Close();
	return 0;
}


//int main () {
//	PP_Open(); /* open the Prog&Play API */
//	PP_Unit_ActionOnUnit(PP_GetUnitAt(MY_COALITION, 0), ATTACK, PP_GetUnitAt(ENEMY_COALITION, 0));
//	/* close the Prog&Play API */
//	PP_Close();
//	return 0;
//}