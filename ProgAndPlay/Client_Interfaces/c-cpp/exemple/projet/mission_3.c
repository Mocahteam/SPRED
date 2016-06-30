#include "PP_Client.h"
#include "constantList_KP4.1.h"

/*
int main () {
	PP_Open();
	while(PP_GetNumUnits(ENEMY_COALITION) > 0)
		PP_Unit_ActionOnUnit(PP_GetUnitAt(MY_COALITION, 0), ATTACK, PP_GetUnitAt(ENEMY_COALITION, 0));
	PP_Close();
	return 0;
}
*/

/*
int main () {
	PP_Open();
	PP_Unit_ActionOnUnit(PP_GetUnitAt(MY_COALITION, 0), ATTACK, PP_GetUnitAt(ENEMY_COALITION, 0));
	PP_Close();
	return 0;
}
*/

// int main () {
	// PP_Open();
	// PP_Pos pos;
	// PP_Unit enemy = PP_GetUnitAt(ENEMY_COALITION, 0);
	// PP_Unit me = PP_GetUnitAt(MY_COALITION, 0);
	// PP_GetSpecialAreaPosition(1000);
	// PP_Unit_GetCoalition(-1);
	// PP_GetUnitAt(MY_COALITION,1000);
	// while(1) {
		// pos = PP_Unit_GetPosition(enemy);
		// PP_Unit_ActionOnPosition(me, ATTACK, pos);
	// }
	// /* close the Prog&Play API */
	// PP_Close();
	// return 0;
// }

int main () {
	// ouverture du jeu
	PP_Open();
	// récupérer la première unité
	PP_Unit u = PP_GetUnitAt(MY_COALITION, 0);
	// récupérer l'unité ennemie
	PP_Unit e = PP_GetUnitAt(ENEMY_COALITION, 0);
	// ordonner à mon unité courante d'attaquer l'ennemi
	PP_Unit_ActionOnUnit(u, FIGHT, e);
	// fermer le jeu
	PP_Close();
}

//g++ -o monProgramme monProgramme.c -I. -I../../pp -L. -lpp-client