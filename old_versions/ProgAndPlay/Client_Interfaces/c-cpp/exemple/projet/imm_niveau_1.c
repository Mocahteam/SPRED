/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 02/04/2012                                                  */
/* Simplement récupérer les pions du jeu et demander à tous mes pions        */
/* d'attaquer le pion ennemi                                                 */
/*****************************************************************************/

#include "PP_IMM.h"

#define CARTE_L 4096
#define CARTE_H 2048

int main (){
	int i;
	
	PP_Pion mesPions [NB_MAX_PIONS];
	int nbMesPions;
	PP_Pion pionsEnnemis [NB_MAX_PIONS];
	int nbPionsEnnemis;
	
	/* Initialisation de la bibliothèque Prog&Play */
	PP_Initialisation();
	
	/* Obtenir les pions du jeu */
	PP_ObtenirPions(mesPions, &nbMesPions, pionsEnnemis, &nbPionsEnnemis);
	/* Lancer l'attaque */
	for (i = 0 ; i < nbMesPions ; i++)
		PP_Attaquer(mesPions[i], pionsEnnemis[0]);
	
	/* Fermer la bibliothèque Prog&Play */
	PP_Fin();
	return 0;
}
