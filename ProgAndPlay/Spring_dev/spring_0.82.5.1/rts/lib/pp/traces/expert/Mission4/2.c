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
	if (PP_Unit_GetType(PP_GetUnitAt(MY_COALITION, 0)) == BIT){
		PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, 0), MOVE, bits);
		PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, 1), MOVE, bytes);
	}
	else {
		PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, 0), MOVE, bytes);
		PP_Unit_ActionOnPosition(PP_GetUnitAt(MY_COALITION, 1), MOVE, bits);
	}
	// fermer le jeu
	PP_Close();
}
