/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 02/04/2012                                                  */
/* Simplement récupérer les pions du jeu et demander à tous mes pions        */
/* d'attaquer le pion ennemi                                                 */
/*****************************************************************************/

#include "PP_Client.h"
#include "constantList_KP4.1.h"
#include <stdio.h>

int main (){
	int i;
	PP_Unit u, e;
	PP_PendingCommands cmd;
	
	// ouverture du jeu
	PP_Open();
	
	// lancer l'attaque
	e = PP_GetUnitAt(ENEMY_COALITION, 0);
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
		u = PP_GetUnitAt(MY_COALITION, i);
		//PP_Unit_ActionOnUnit(u, ATTACK, e);
	}
	
	while (!PP_IsGameOver()) {
		PP_Unit_GetPendingCommands(u,&cmd);
		if (cmd.nbCmds == 5) {
			printf("num commands : %d\n", cmd.nbCmds);
			for (int i = 0; i < cmd.nbCmds; i++) {
				printf ("\tcode : %d\n",cmd.cmd[i].code);
				for (int j = 0; j < cmd.cmd[i].nbParams; j++) {
					printf ("\tparam %d : %f\n",j,cmd.cmd[i].param[j]);
				}
			}
		}
	}
	
	// fermer le jeu
	PP_Close();
	return 0;
}
