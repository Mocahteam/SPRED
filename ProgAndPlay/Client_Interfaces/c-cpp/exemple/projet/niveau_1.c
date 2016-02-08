/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 02/04/2012                                                  */
/* Simplement récupérer les pions du jeu et demander à tous mes pions        */
/* d'attaquer le pion ennemi                                                 */
/*****************************************************************************/

#include "PP_Client.h"
#include "constantList_KP4.1.h"

int main (){
	int i;
	PP_Unit u, e;
	
	// ouverture du jeu
	PP_Open();
	
	// lancer l'attaque
	e = PP_GetUnitAt(ENEMY_COALITION, 0);
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++){
		u = PP_GetUnitAt(MY_COALITION, i);
		PP_Unit_ActionOnUnit(u, ATTACK, e);
	}
	
	// fermer le jeu
	PP_Close();
	return 0;
}
