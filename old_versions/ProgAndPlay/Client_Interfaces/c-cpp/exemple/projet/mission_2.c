#include "PP_Client.h"
#include "constantList_KP4.1.h"

int main () {
	PP_Open(); /* open the Prog&Play API */
	PP_Unit u = PP_GetUnitAt(MY_COALITION, 0);
	PP_Pos p = PP_Unit_GetPosition(u);
	p.x += 927;
	p.y -= 513;
	PP_Unit_ActionOnPosition(u, MOVE, p);
	/* close the Prog&Play API */
	PP_Close();
	return 0;
}