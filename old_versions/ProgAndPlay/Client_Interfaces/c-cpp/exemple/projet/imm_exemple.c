#include "PP_IMM.h"

int main (void){
	PP_Pos pos;
	
	PP_Pion mesPions [NB_MAX_PIONS];
	int nbMesPions;
	PP_Pion pionsEnnemis [NB_MAX_PIONS];
	int nbPionsEnnemis;
	
	/* Initialisation de la bibliothèque Prog&Play */
	PP_Initialisation();
	
	/* Obtenir les pions du jeu */
	PP_ObtenirPions(mesPions, &nbMesPions, pionsEnnemis, &nbPionsEnnemis);
	
	/* Déplacement du premier pion au centre de la carte */
	pos.x = 2048;
	pos.y = 1024;
	PP_Deplacer(mesPions[0], pos);
	
	/* Fermer le jeu */
	PP_Fin();
	return 0;
}
