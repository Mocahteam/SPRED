#include "PP_Client.h"
#include "constantList_KP4.1.h"

int main () {
	/* define target position */
	PP_Pos p;
	p.x = 1983.0;
	p.y = 1279.0;
	PP_Open(); /* open the Prog&Play API */
	while(true)
		PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, 0), MOVE, p);
	/* close the Prog&Play API */
	PP_Close();
	return 0;
}