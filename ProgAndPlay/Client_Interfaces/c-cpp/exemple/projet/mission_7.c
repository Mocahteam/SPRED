#include "PP_Client.h"
#include "constantList_KP4.1.h"

/* Move all units to a specific position */
int main (){
	int i;
	/* define target position */
	PP_Unit assembler,u;
	PP_Open(); /* open the Prog&Play API */
	/* iterate all units */
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
		if (PP_Unit_GetType(PP_GetUnitAt(MY_COALITION,i)) == ASSEMBLER)
			assembler = PP_GetUnitAt(MY_COALITION,i);
	}
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
		u = PP_GetUnitAt(MY_COALITION,i);
		if (u != assembler) {
			PP_Unit_ActionOnUnit(assembler, REPAIR, u);
			while(PP_Unit_GetHealth(u) != PP_Unit_GetMaxHealth(u));
		}
	}
	/* close the Prog&Play API */
	PP_Close();
	return 0;
}
