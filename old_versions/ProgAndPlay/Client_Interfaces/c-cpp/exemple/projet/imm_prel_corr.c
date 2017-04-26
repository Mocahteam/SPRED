/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 13/12/2010                                                  */
/* Solution du travail préliminaire du sujet de TP.                          */
/*****************************************************************************/

#include "PP_IMM.h"
#include <stdio.h>
#include <stdlib.h>

#define CARTE_L 4096
#define CARTE_H 2048

/* Définition du type PP_Pion_t qui représente un tableau de 48 pions maximum */
typedef PP_Pion PP_Pion_t [NB_MAX_PIONS];

/* Définition du type Groupe */
typedef struct {
	PP_Pion_t membres; /* liste des pions affectés à ce groupe */
	int nbMembres; /* nombre de pions dans le groupe */
} Groupe;

/* Affiche les stats d'un pion */
void printStats(PP_Pion pion){
	PP_Pos pos = PP_Position(pion);
	printf("Stats du pion %d :\n", pion);
	printf("  Position : (%f, %f)\n", pos.x, pos.y);
	printf("  Capital sante : %f\n", PP_CapitalSante(pion));
}

/* Retourne "true" si tous les pions du groupe sont innactifs et "false sinon. */
bool inactifs(Groupe g){
	int i;
	for (i = 0 ; i < g.nbMembres ; i++){
		if (!PP_EnAttente(g.membres[i]))
			return false;
	}
	return true;
}

int main (){
	PP_Pos pos;
	
	Groupe mesPions;
	Groupe pionsEnnemis;
	
	/* Initialisation de la bibliothèque Prog&Play */
	PP_Initialisation();
	
	/* Obtenir les pions du jeu */
	PP_ObtenirPions(mesPions.membres, &mesPions.nbMembres,
	                pionsEnnemis.membres, &pionsEnnemis.nbMembres);
	
	/* Afficher les stats du premier pion */
	printStats(mesPions.membres[0]);
	
	/* Déplacement du premier pion au centre de la carte */
	pos.x = CARTE_L/2;
	pos.y = CARTE_H/2;
	PP_Deplacer(mesPions.membres[0], pos);
	
	/* Attendre le début du déplacement */
	while (inactifs(mesPions))
		PP_ObtenirPions(mesPions.membres, &mesPions.nbMembres,
		                pionsEnnemis.membres, &pionsEnnemis.nbMembres);
	/* Attendre la fin du déplacement */
	while (!inactifs(mesPions))
		PP_ObtenirPions(mesPions.membres, &mesPions.nbMembres,
		                pionsEnnemis.membres, &pionsEnnemis.nbMembres);
	
	/* Afficher les stats du premier pion */
	printStats(mesPions.membres[0]);
	
	/* Fermer le jeu */
	PP_Fin();
	return 0;
}
