#include "PP_Client.h"
#include "../constantList_KP4.1.h"

// déplacer le bit et le byte à leurs coordonnées respectives
int main (){
	// définition des positions
	PP_Pos bits;
	bits.x = 1400.0;
	bits.y = 1371.0;
	PP_Pos bytes;
	bytes.x = 479.0;
	bytes.y = 1825.0;
	// ouverture du jeu
	PP_Open();
	// récupérer la première unité
	PP_Unit u = PP_GetUnitAt(MY_COALITION, 0);
	if (PP_Unit_GetType(u) == BIT){
		// ordonner à mon unité courante de se déplacer
		PP_Unit_ActionOnPosition(u, MOVE, bits);
		// passer à l'unité suivante
		u = PP_GetUnitAt(MY_COALITION, 1);
		// lui ordonner de rejoindre sa position
		PP_Unit_ActionOnPosition(u, MOVE, bytes);
	}
	else {
		// ordonner à mon unité courante de se déplacer
		PP_Unit_ActionOnPosition(u, MOVE, bytes);
		// passer à l'unité suivante
		u = PP_GetUnitAt(MY_COALITION, 1);
		// lui ordonner de rejoindre sa position
		PP_Unit_ActionOnPosition(u, MOVE, bits);
	}
	// fermer le jeu
	PP_Close();
}
