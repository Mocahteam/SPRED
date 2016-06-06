#include "PP_Client.h"
#include "../constantList_KP4.1.h"

#include "stdio.h"

// Defendre l'allie
int main (){
	// ouverture du jeu
	PP_Open();
	// récupérer la première unité
	PP_Unit u = PP_GetUnitAt(MY_COALITION, 0);
	// attendre l'arrivée de l'ennemi
	while (PP_GetNumUnits(ENEMY_COALITION) == 0)
		printf("En attente de l'arrivée de l'ennemi\n");
	// récupérer l'unité ennemie
	PP_Unit e = PP_GetUnitAt(ENEMY_COALITION, 0);
	// ordonner à mon unité courante d'attaquer l'ennemi
	PP_Unit_ActionOnUnit(u, ATTACK, e);
	// fermer le jeu
	PP_Close();
}
