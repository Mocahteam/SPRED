#include "PP_Client.h"
#include "PP_Error.h"
#include "../constantList_KP4.1.h"

#include <stdlib.h>
#include <time.h>
#include <stdio.h>

int main (){
	int cpt, found;
	PP_Pos pos, size;
	PP_Unit u;
	
	srand (time(NULL));
	
	found = 0;
	PP_Open();
	
	size = PP_GetMapSize();
	printf ("%f, %f\n", size.x, size.y);
	while (!found && !PP_IsGameOver()){
		if (PP_GetNumUnits(ENEMY_COALITION) > 0){
			for (cpt = 0 ; cpt < PP_GetNumUnits(MY_COALITION) ; cpt ++){
				u = PP_GetUnitAt(MY_COALITION, cpt);
				if (PP_Unit_GetType(u) == BIT)
					PP_Unit_UntargetedAction(u, STOP, -1.0);
			}
			found = 1;
	    }
	    else{
		    for (cpt = 0 ; cpt < PP_GetNumUnits(MY_COALITION) ; cpt ++){
				u = PP_GetUnitAt(MY_COALITION, cpt);
				PP_PendingCommands pdgCmds;
				PP_Unit_GetPendingCommands(u, &pdgCmds);
				if (pdgCmds.nbCmds == 0 && PP_Unit_GetType(u) == BIT){
					pos.x = rand() % (int)size.x + 1;
					pos.y = rand() % (int)size.y + 1;
					PP_Unit_ActionOnPosition(u, MOVE, pos);
				}
			}
	    }
	}
	printf ("%d, %d, %d\n", found, PP_IsGameOver(), PP_GetNumUnits(ENEMY_COALITION));
	PP_Close();
}
