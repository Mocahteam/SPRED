/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 12/10/2010                                                  */
/* Cet algorithme ordonne à toute l'armée d'aller à l'autre bout de la       */
/* carte. Si aucun adversaire n'est détecter, le rechercher de manière       */
/* aléatoire sur la carte (à chaque unité inactive - sans ordre de commande  */
/* en attente - définir une position aléatoire sur la carte). L'orsque un ou */
/* plusieurs unités sont détectées, ordonner à toutes les unités qui         */
/* n'attaquent pas de cibler la première unité ennemie.                      */
/*****************************************************************************/

#include "PP_Client.h"
#include "constantList_KP4.1.h"
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

// retourne vrai si toutes les unités du jeu sont immobiles
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
	int i;
	PP_Pos pos;
	PP_Unit u;
	bool attaque;
	PP_PendingCommands cmd;
	
	// ouverture du jeu
	PP_Open();
	
	// lancer la marche
	pos.x = PP_GetMapSize().x-PP_GetStartPosition().x;
	pos.y = PP_GetMapSize().y-PP_GetStartPosition().y;
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++)
		PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, i), MOVE, pos);
	// attendre le départ de l'armée
	while (!mobile())
		printf("Attendre depart armee\n");
	
	// ordonner d'attaquer le premier byte ennemis
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
			// ordonner aux unités qui n'attaquent pas de cibler la première unité ennemie
			for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
				u = PP_GetUnitAt(MY_COALITION, i);
				attaque = false;
				if (PP_Unit_GetPendingCommands(u, &cmd) != -1){
					
					if (cmd.nbCmds == 0)
						attaque = true;
					else if (cmd.nbCmds > 0)
						if (cmd.cmd[0].code != ATTACK)
							attaque = true;
					if (attaque){
						PP_Unit_ActionOnUnit(u, ATTACK, PP_GetUnitAt(ENEMY_COALITION, 0));
					}
				}
			}
		}
	}
	// fermer le jeu
	PP_Close();
	return 0;
}
