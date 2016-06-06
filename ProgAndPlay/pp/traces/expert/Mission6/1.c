#include "PP_Client.h"
#include "../constantList_KP4.1.h"

// déplacer l'assembleur et uniquement lui à une coordonnée précise
int main (){
	int i; // compteur de boucle
	PP_Unit u; // unité courante
	// définition de la cible
	PP_Pos pos;
	pos.x = 256.0;
	pos.y = 811.0;
	// ouverture du jeu
	PP_Open();
	// parcourir toutes les unités
	i = 0;
	while (i < PP_GetNumUnits(MY_COALITION)){
		// récupérer l'unité courante
		u = PP_GetUnitAt(MY_COALITION, i);
		// donner l'ordre de déplacement
		if (PP_Unit_GetType(u) == ASSEMBLER)
			PP_Unit_ActionOnPosition(u, MOVE, pos);
		i++;
	}
	// fermer le jeu
	PP_Close();
}
