#include "PP_Client.h"
#include "constantList_KP4.1.h"

/* Move all units to a specific position */
int main (){
	int i;
	/* define target position */
	PP_Pos p;
	p.x = 256.0;
	p.y = 1034.0;
	PP_Open(); /* open the Prog&Play API */
	int num_units = PP_GetNumUnits (MY_COALITION);
	/* iterate all units */
	for (i = 0 ; i < num_units-1; i++){
		/* order the current unit to move to the target position */
		PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, i), MOVE, p);
	}
	return 0;
}
