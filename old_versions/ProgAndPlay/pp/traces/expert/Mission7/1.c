#include "PP_Client.h"
#include "../constantList_KP4.1.h"
#include "stdio.h"

// réparer toutes les unités endommagées
int main () {
	int i; // compteur de boucle
	PP_Unit u, assembleur; // unités de traitement
	
	// ouverture du jeu
	PP_Open();
	// recherche de l'assembleur
	i = 0;
	u = PP_GetUnitAt(MY_COALITION, i);
	while (i < PP_GetNumUnits(MY_COALITION) && PP_Unit_GetType(u) != ASSEMBLER){
		// passer à l'unité suivante
		i = i + 1;
		u = PP_GetUnitAt(MY_COALITION, i);
	}
	if (PP_Unit_GetType(u) == ASSEMBLER){
		assembleur = u;
		// réparation des unités
		i = 0;
		while (i < PP_GetNumUnits(MY_COALITION)){
			u = PP_GetUnitAt(MY_COALITION, i);
			if (PP_Unit_GetHealth(u) < PP_Unit_GetMaxHealth(u)){
				PP_Unit_ActionOnUnit(assembleur, REPAIR, u);
				while (PP_Unit_GetHealth(u) < PP_Unit_GetMaxHealth(u));
			}
			// passer à l'unité suivante
			i = i + 1;
		}
	}
	// fermer le jeu
	PP_Close();
}
