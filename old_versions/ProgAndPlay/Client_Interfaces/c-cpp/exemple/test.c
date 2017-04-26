#include "PP_Client.h"
#include "PP_Error.h"
#include "../constantList_KP4.1.h"

#include <cstdio>

int main (){
	int i;
	PP_Unit u;
	// ouverture du jeu
	if (PP_Open() == -1)
		printf("%s", PP_GetError());
	// récupérer l'état courant du jeu
//	if (PP_Refresh() == -1)
//		printf("%s", PP_GetError());
//	printf("%d\n", PP_GetNumSpecialAreas());
//	printf("metal : %d; energy : %d\n", PP_GetResource(METAL),
//		PP_GetResource(ENERGY));
//	PP_Refresh();
//	printf("metal : %d; energy : %d\n", PP_GetResource(METAL),
//		PP_GetResource(ENERGY));
//	printf("%d\n", PP_GetNumSpecialAreas());
	// recherche de l'unité
	while (!PP_IsGameOver()){
		for (i = 0 ; i < PP_GetNumUnits (MY_COALITION) ; i++){
			u = PP_GetUnitAt(MY_COALITION, i);
			printf("%d - ", u);
			PP_PendingCommands pdgCmds;
			PP_Unit_GetPendingCommands(u, &pdgCmds);
			for (int j = 0 ; j < pdgCmds.nbCmds ; j++){
				printf("%d (", pdgCmds.cmd[j].code);
				for (int k = 0 ; k < pdgCmds.cmd[j].nbParams ; k++)
					printf(" %f", pdgCmds.cmd[j].param[k]);
				printf(")");
			}
			// if (pdgCmds.nbCmds > 8){
				// printf("STOP_BUILDING\n");
				// PP_Unit_UntargetedAction(u, STOP_BUILDING, -1.0);
			// }
			printf("\n");
		}
//		if (PP_Refresh() == -1)
//			printf("%s", PP_GetError());
	}
	// fermer le jeu
	if (PP_Close() == -1)
		printf("%s", PP_GetError());
}
