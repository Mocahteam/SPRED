#include "PP_Client.h"
#include "../constantList_KP4.4.h"
#include "PP_Error.h"

// déplacer une unité à une position précise
int main (){
	// ouverture du jeu
	PP_Open();
	// récupérer la première unité
	PP_Unit u = PP_GetUnitAt(MY_COALITION, 0);
	// récupération des coordonnées de l'unité
	PP_Pos posDepart = PP_Unit_GetPosition(u);
	// calcul de la coordonnée d'arrivée
	PP_Pos posArrivee;
	posArrivee.x = posDepart.x - 927;
	posArrivee.y = posDepart.y + 513;
	// ordonner à mon unité courante de se déplacer
	PP_Unit_ActionOnPosition(u, MOVE, posArrivee);
	// fermer le jeu
	PP_Close();
}
