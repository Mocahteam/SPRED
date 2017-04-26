/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 12/10/2010                                                  */
/* Cet algorithme ordonne à toute l'armée d'aller à l'autre bout de la       */
/* carte en concervant la formation de départ. Si aucun adversaire n'est     */
/* détecter, la recherche des unités adverses est réalisée d'une manière     */
/* aléatoire sur la carte (à chaque unité inactive - sans ordre de commande  */
/* en attente - définir une position aléatoire sur la carte). L'orsque un ou */
/* plusieurs unités sont détectées, ordonner à chaque unité d'attaquer       */
/* l'unité la plus proche si celle-ci n'est pas déjà engagée dans un autre   */
/* combat                                                                    */
/*****************************************************************************/

#include "PP_Client.h"
#include "PP_Error.h"
#include "constantList_KP4.1.h"
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

// retourne vrai si toutes les unités du jeu sont mobiles
bool mobile(){
	int i;
	PP_PendingCommands cmd;
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
		if (PP_Unit_GetPendingCommands(PP_GetUnitAt(MY_COALITION, i), &cmd) != -1)
			if (cmd.nbCmds == 0)
				return false;
	}
	return true;
}

int main (){
	int i, j, sens;
	PP_Pos pos;
	PP_Unit u, select, tmp;
	bool attaque;
	float distance, dx, dy;
	PP_PendingCommands cmd;
	
	// ouverture du jeu
	PP_Open();
	
	// determination de la direction de l'attaque
	if (PP_GetStartPosition().x < PP_GetMapSize().x/2)
		sens = 1;
	else
		sens = -1;
	
	// lancer la marche
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
		pos = PP_Unit_GetPosition(PP_GetUnitAt(MY_COALITION, i));
		if (sens == -1)
			pos.x = 10;
		else
			pos.x = PP_GetMapSize().x - 10;
		PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, i), MOVE, pos);
	}
	// attendre le départ de l'armée
	while (!mobile())
		printf("Attente depart armee\n");
	
	// ordonner d'attaquer les bytes ennemis
	while (!PP_IsGameOver()){
		if (PP_GetNumUnits(ENEMY_COALITION) == 0){
			// faire une recherche aléatoire
			for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
				u = PP_GetUnitAt(MY_COALITION, i);
				if (PP_Unit_GetPendingCommands(u, &cmd) != -1){
					if (cmd.nbCmds == 0){
						pos.x = rand() % (int)PP_GetMapSize().x + 1;
						pos.y = rand() % (int)PP_GetMapSize().y + 1;
						PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, i), MOVE, pos);
					}
				}
			}
		}
		else{
			// ordonner aux unités qui n'attaquent pas de cibler l'unité ennemie la plus proche d'elle
			for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
				printf(" %d", i);
				u = PP_GetUnitAt(MY_COALITION, i);
				if (PP_Unit_GetPendingCommands(u, &cmd) != -1){
					attaque = false;
					if (cmd.nbCmds == 0)
						attaque = true;
					else if (cmd.nbCmds > 0)
						if (cmd.cmd[0].code != ATTACK)
							attaque = true;
					if (attaque){
						pos = PP_Unit_GetPosition(u);
						// calcul de la distance max pour cette carte
						distance = PP_GetMapSize().x*PP_GetMapSize().x+PP_GetMapSize().y*PP_GetMapSize().y;
						select = -1;
						for (j = 0 ; j < PP_GetNumUnits(ENEMY_COALITION) ; j++){
							tmp = PP_GetUnitAt(ENEMY_COALITION, j);
							dx = pos.x - PP_Unit_GetPosition(tmp).x;
							dy = pos.y - PP_Unit_GetPosition(tmp).y;
							if (dx*dx+dy*dy < distance){
								distance = dx*dx+dy*dy;
								select = tmp;
							}
						}
						if (select != -1)
							PP_Unit_ActionOnUnit(u, ATTACK, select);
					}
				}
				else{
					printf("%s", PP_GetError());
				}
			}
			printf("\n");
		}
	}
	// fermer le jeu
	PP_Close();
	return 0;
}
