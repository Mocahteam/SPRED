#include "PP_Client.h"
#include "constantList_KP4.1.h"

int main () {
	PP_Open(); /* open the Prog&Play API */
	for (int i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++) {
		PP_Pos p;
		int type = PP_Unit_GetType(PP_GetUnitAt(MY_COALITION,i));
		if (type == BYTE) {
			p.x = 479.0;
			p.y = 1825.0;
		}
		else if (type == BIT) {
			p.x = 1400.0;
			p.y = 1371.0;
		}		
		PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, i), MOVE, p);
	}
	/* close the Prog&Play API */
	PP_Close();
	return 0;
}