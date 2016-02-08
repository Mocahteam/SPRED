/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 02/04/2012                                                  */
/* Simplement avancer mes pions et leur demander d'attaquer l'ennemi dès     */
/* qu'il est visible                                                         */
/*****************************************************************************/

#include "PP_IMM.h"

#define CARTE_L 4096
#define CARTE_H 2048

int main (){
	int i;
	PP_Pos pos;
	pos.x = 1648.0;
	pos.y = 1024.0;
	
	PP_Pion mesPions [NB_MAX_PIONS];
	int nbMesPions;
	PP_Pion pionsEnnemis [NB_MAX_PIONS];
	int nbPionsEnnemis;
	
	/* Initialisation de la bibliothèque Prog&Play */
	PP_Initialisation();
	
	/* Obtenir les pions du jeu */
	PP_ObtenirPions(mesPions, &nbMesPions, pionsEnnemis, &nbPionsEnnemis);
	
	/* Lancer le déplacement */
	for (i = 0 ; i < nbMesPions ; i++)
		PP_Deplacer(mesPions[i], pos);
	
	/* attendre de découvrir l'ennemi */
	while (nbPionsEnnemis == 0)
		PP_ObtenirPions(mesPions, &nbMesPions, pionsEnnemis, &nbPionsEnnemis);
	
	/* Lancer l'attaque */
	for (i = 0 ; i < nbMesPions ; i++)
		PP_Attaquer(mesPions[i], pionsEnnemis[0]);
	
	/* Fermer la bibliothèque Prog&Play */
	PP_Fin();
	return 0;
}
