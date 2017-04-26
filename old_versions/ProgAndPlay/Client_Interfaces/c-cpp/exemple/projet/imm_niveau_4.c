/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 02/04/2012                                                  */
/* La recherche des pions adverses est réalisée de manière aléatoire (à      */
/* chaque pion du joueur inactif - sans ordre de commande en attente -       */
/* définir une position aléatoire sur la carte). L'orsque un ou plusieurs    */
/* pions adverses sont détectés, ordonner à chaque pion d'attaquer le pion   */
/* adverse le plus proche.                                                   */
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
	int i, j;
	PP_Pos pos;
	PP_Pion old, select;
	bool attaquer;
	float distance, dx, dy;
	
	Groupe mesPions;
	Groupe pionsEnnemis;
	
	/* Initialisation de la bibliothèque Prog&Play */
	PP_Initialisation();
	
	while (!PP_PartieTerminee()){
		/* Obtenir les pions du jeu */
		PP_ObtenirPions(mesPions.membres, &mesPions.nbMembres,
		                pionsEnnemis.membres, &pionsEnnemis.nbMembres);
		
		if (pionsEnnemis.nbMembres > 0){
			/* Ordonner à chaque pion d'attaque le pion ennemi le plus proche de lui
			   */
			for (i = 0 ; i < mesPions.nbMembres ; i++){
				/* Récupérer la position de mon ième pion */
				pos = PP_Position(mesPions.membres[i]);
				/* Calcul de la distance au premier octet */
				dx = pos.x - PP_Position(pionsEnnemis.membres[0]).x;
				dy = pos.y - PP_Position(pionsEnnemis.membres[0]).y;
				distance = dx*dx+dy*dy;
				/* Sélectionner le premier pion ennemi */
				select = pionsEnnemis.membres[0];
				/* Rechercher s'il y en a un de plus proche */
				for (j = 1 ; j < pionsEnnemis.nbMembres ; j++){
					dx = pos.x - PP_Position(pionsEnnemis.membres[j]).x;
					dy = pos.y - PP_Position(pionsEnnemis.membres[j]).y;
					if (dx*dx+dy*dy < distance){
						distance = dx*dx+dy*dy;
						select = pionsEnnemis.membres[j];
					}
				}
				/* Déterminer si l'attaque est necessaire (c'est inutile d'ordonner à un
				   pion d'attaquer un pion ennemi s'il l'attaque déjà) */
				attaquer = true;
				if (PP_EnAttaque(mesPions.membres[i], &old))
					if (old == select)
						attaquer = false;
				/* Ordonner l'attaque à proprement dit si besoin */
				if (attaquer)
					PP_Attaquer(mesPions.membres[i], select);
			}
		}
		else{
			/* Faire une recherche aléatoire des pions adverses */
			for (i = 0 ; i < mesPions.nbMembres ; i++)
				if (PP_EnAttente(mesPions.membres[i])){
					pos.x = PP_NombreAleatoire(CARTE_L);
					pos.y = PP_NombreAleatoire(CARTE_H);
					PP_Deplacer(mesPions.membres[i], pos);
				}
		}
	}
	/* Fermer le jeu */
	PP_Fin();
	return 0;
}
