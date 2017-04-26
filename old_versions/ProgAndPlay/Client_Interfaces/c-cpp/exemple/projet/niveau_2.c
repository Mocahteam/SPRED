/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 02/04/2012                                                  */
/* Simplement avancer mes pions et leur demander d'attaquer l'ennemi dès     */
/* qu'il est visible                                                         */
/*****************************************************************************/

#include "PP_Client.h"
#include "constantList_KP4.1.h"
#include <stdio.h>

int main (){
	int i;
	PP_Unit u, e;
	PP_Pos pos;
	pos.x = 1648.0;
	pos.y = 1024.0;
	
	// ouverture du jeu
	PP_Open();
	
	// lancer la marche
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
		u = PP_GetUnitAt(MY_COALITION, i);
		PP_Unit_ActionOnPosition(u, MOVE, pos);
	}
	
	/* attendre de découvrir l'ennemi */
	while (PP_GetNumUnits(ENEMY_COALITION) == 0)
		printf("Attendre decouverte ennemi\n");
		
	/* lancer l'attaque */
	e = PP_GetUnitAt(ENEMY_COALITION, 0);
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
		u = PP_GetUnitAt(MY_COALITION, i);
		PP_Unit_ActionOnUnit(u, ATTACK, e);
	}
	
	// fermer le jeu
	PP_Close();
	return 0;
}
