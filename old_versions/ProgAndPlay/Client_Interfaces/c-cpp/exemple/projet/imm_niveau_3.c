/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 02/04/2012                                                  */
/* La recherche des pions adverses est réalisée de manière aléatoire (à      */
/* chaque pion du joueur inactif - sans ordre de commande en attente -       */
/* définir une position aléatoire sur la carte). L'orsque un ou plusieurs    */
/* pions adverses sont détectés, ordonner à tous les pions du joueur qui     */
/* n'attaquent pas de cibler le premier pion ennemi.                         */
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

/* retourne vrai si tous les pions du groupe sont innactifs */
bool inactifs(Groupe g){
	int i;
	for (i = 0 ; i < g.nbMembres ; i++){
		if (!PP_EnAttente(g.membres[i]))
			return false;
	}
	return true;
}

int main (){
	int i;
	PP_Pos pos;
	
	Groupe mesPions;
	Groupe pionsEnnemis;
	
	/* Initialisation de la bibliothèque Prog&Play */
	PP_Initialisation();
	
	while (!PP_PartieTerminee()){
		/* Obtenir les pions du jeu */
		PP_ObtenirPions(mesPions.membres, &mesPions.nbMembres,
		                pionsEnnemis.membres, &pionsEnnemis.nbMembres);
		printf("%d\n", pionsEnnemis.nbMembres);
		if (pionsEnnemis.nbMembres > 0){
			/* Ordonner aux pions qui n'attaquent pas d'attaquer le premier pion
			   ennemi */
			for (i = 0 ; i < mesPions.nbMembres ; i++)
				if (!PP_EnAttaque(mesPions.membres[i], NULL))
					PP_Attaquer(mesPions.membres[i], pionsEnnemis.membres[0]);
		}
		else{
			/* Ordonner à chaque pion en attente de commande de se déplacer vers une
			   position aléatoire sur la carte */
			for (i = 0 ; i < mesPions.nbMembres ; i++)
				if (PP_EnAttente(mesPions.membres[i])){
					pos.x = PP_NombreAleatoire(CARTE_L);
					pos.y = PP_NombreAleatoire(CARTE_H);
					PP_Deplacer(mesPions.membres[i], pos);
				}
		}
	}
	/* Fermer la bibliothèque Prog&Play */
	PP_Fin();
	return 0;
}
