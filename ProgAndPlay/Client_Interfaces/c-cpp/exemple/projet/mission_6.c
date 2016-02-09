#include "PP_Client.h"
#include "constantList_KP4.1.h"

/* Move all units to a specific position */
int main (){
	int i;
	/* define target position */
	PP_Pos p;
	p.x = 256.0;
	p.y = 811.0;
	PP_Open(); /* open the Prog&Play API */
	/* iterate all units */
	for (i = 0 ; i < PP_GetNumUnits (MY_COALITION) ; i++){
		if (PP_Unit_GetType(PP_GetUnitAt(MY_COALITION,i)) == ASSEMBLER)
			PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, i), MOVE, p);
	}
	/* close the Prog&Play API */
	PP_Close();
	return 0;
}
