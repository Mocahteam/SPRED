/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 02/04/2012                                                  */
/* Cet algorithme ordonne à tous les pions du joueur d'aller à l'autre bout  */
/* de la carte en concervant une formation serrée. Pour l'attaque, des       */
/* groupes de 4 pions sont constitués. Lorsque un ou plusierus pions         */
/* adverses sont détectés, ordonner à chaque groupe d'attaquer le pion       */
/* adverse le plus proche.                                                   */
/*****************************************************************************/

#include "PP_IMM.h"
#include <stdio.h>
#include <stdlib.h>

#define NB_GROUPES 12

#define CARTE_L 4096
#define CARTE_H 2048

#define PROGRESSION 150

/* pour définir un critère de tri selon X ou Y */
typedef enum {
	X,
	Y 
} CRITERE;

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

/* Calcule le centre de bravité d'un groupe de pions */
PP_Pos centreGravite (Groupe g){
	PP_Pos grav = {0., 0.};
	int i;
	if (g.nbMembres != 0){
		for (i = 0 ; i < g.nbMembres ; i++){
			grav.x = grav.x + PP_Position(g.membres[i]).x;
			grav.y = grav.y + PP_Position(g.membres[i]).y;
		}
		grav.x = grav.x / g.nbMembres;
		grav.y = grav.y / g.nbMembres;
	}
	return grav;
}

/* Initialise un groupe avec tous les pions présents dans le jeu */
void majPions(Groupe *mesPions, Groupe *pionsEnnemis){
	PP_ObtenirPions(mesPions->membres, &(mesPions->nbMembres),
	                pionsEnnemis->membres, &(pionsEnnemis->nbMembres));
}

/* Détermine si un pion est supérieure ou inférieure à un autre en fonction
   d'un critère (X ou Y) */
int sup(PP_Pion o1, PP_Pion o2, CRITERE c){
	if (c == X)
		return PP_Position(o1).x > PP_Position(o2).x;
	else
		return PP_Position(o1).y > PP_Position(o2).y;
}

/* Trie les membres d'un groupe selon un certain critère (X ou Y) */
void trierSelon(Groupe *g, CRITERE c){
	int i, j;
	PP_Pion o;
	
	/* réalisation du tri (tri par insertion) */
	for (i = 1 ; i < g->nbMembres ; i++){
		o = g->membres[i];
		j = i;
		while (j > 0 && sup(g->membres[j-1], o, c)){
			g->membres[j] = g->membres[j - 1];
			j = j-1;
		}
		g->membres[j] = o;
	}
}

/* Affecter les octets d'une armee dans les differents groupes */
void affecterGroupes(Groupe armee, Groupe groupes []){
	int i, j, g, tailleGroupes;
	
	/* Initialisation des groupes */
	for (i = 0 ; i < NB_GROUPES ; i++){
		groupes[i].nbMembres = 0;
	}
	/* Affectation des groupes */
	tailleGroupes = armee.nbMembres / NB_GROUPES;
	/* Vérifier s'il ne reste pas des pions en plus. Si tel est le cas, augmenter
	   d'un la taille des groupes */ 
	if (armee.nbMembres % NB_GROUPES > 0)
		tailleGroupes++;
	if (tailleGroupes > 0){
		g = 0;
		for (i = 0 ; i < armee.nbMembres ; i++){
			j = i%tailleGroupes;
			g = i/tailleGroupes;
			if (g < NB_GROUPES){
				groupes[g].membres[j] = armee.membres[i];
				groupes[g].nbMembres++;
			}
		}
	}
}

/* Détermine pour le groupe "g" un pion à attaquer dans le groupe "cible" */
PP_Pion determinerCible (Groupe g, Groupe cible){
	PP_Pion e, tmp;
	PP_Pos bar;
	int i;
	float distance, dx, dy;
	
	/* Récupération du barycentre du groupe */
	bar = centreGravite(g);
	/* Rechercher l'ennemi le plus proche de ce barycentre */
	distance = CARTE_L*CARTE_L + CARTE_H*CARTE_H;
	for (i = 0 ; i < cible.nbMembres ; i++){
		tmp = cible.membres[i];
		dx = bar.x - PP_Position(tmp).x;
		dy = bar.y - PP_Position(tmp).y;
		if (dx*dx+dy*dy < distance){
			distance = dx*dx+dy*dy;
			e = tmp;
		}
	}
	return e;
}

/* Retourne true si le pion "source" attaque le pion "cible " et false sinon */
bool enAttaque(PP_Pion source, PP_Pion cible){
	PP_Pion tmp;
	
	if (PP_EnAttaque(source, &tmp))
		return tmp == cible;
	return false;
}

/* Ordonne à tous les membres du groupe "g" de se déplacer vers la position "p"
   */
void deplacerGroupe(Groupe g, PP_Pos p){
	int i;
	for (i = 0 ; i < g.nbMembres ; i++)
		PP_Deplacer(g.membres[i], p);
}

int main (){
	int i, j, sens;
	PP_Pos pos;
	PP_Pion o;
	Groupe monArmee, ennemis;
	Groupe groupes [NB_GROUPES];
	bool ennemiDejaVu = false;
	
	/* Initialisation de la bibliothèque Prog&Play */
	PP_Initialisation();
	
	/* Obtenir les pions du jeu */
	majPions(&monArmee, &ennemis);
	
	/* Determination de la direction de l'attaque */
	if (centreGravite(monArmee).x < CARTE_L/2)
		sens = 1;
	else
		sens = -1;
	
	while (!PP_PartieTerminee()){
		/* Obtenir les pions du jeu */
		majPions(&monArmee, &ennemis);
		printf("  Taille armee : %d\n", monArmee.nbMembres);
		/* Construire les groupes */
		trierSelon(&monArmee, Y);
		affecterGroupes(monArmee, groupes);
		printf("  Affichage des groupes : \n");
		for (i = 0 ; i < NB_GROUPES ; i++)
			printf("    groupe %d : %d\n", i, groupes[i].nbMembres);
		
		if (ennemis.nbMembres > 0){
			/* Affecter une cible à chaque groupes */
			for (i = 0 ; i < NB_GROUPES ; i++){
				o = determinerCible(groupes[i], ennemis);
				printf("  Cible pour le groupe %d : %d\n", i, o);
				/* Pour chaque membre du groupe, donner l'ordre d'attaque si
				   necessaire */
				for (j = 0 ; j < groupes[i].nbMembres ; j++)
					if (!enAttaque(groupes[i].membres[j], o))
						PP_Attaquer(groupes[i].membres[j], o);
			}
			ennemiDejaVu = true;
		}
		else{
			if (ennemiDejaVu){
				/* Rechercher aléatoirement les pions de l'adversaire */
				for (i = 0 ; i < NB_GROUPES ; i++){
					if (inactifs(groupes[i])){
						pos.x = PP_NombreAleatoire(CARTE_L);
						pos.y = PP_NombreAleatoire(CARTE_H);
						deplacerGroupe(groupes[i], pos);
					}
				}
			}
			else{
				/* Faire avancer le groupes en formation serrée */
				for (i = 0 ; i < NB_GROUPES ; i++){
					pos = centreGravite(groupes[i]);
					pos.x = pos.x + sens*PROGRESSION;
					deplacerGroupe(groupes[i], pos);
				}
			}
		}
	}
	
	/* Fermer le jeu */
	PP_Fin();
	return 0;
}
