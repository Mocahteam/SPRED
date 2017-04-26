/*****************************************************************************/
/* Auteur : Muratet Mathieu                                                  */
/* Mise à jour : 12/10/2010                                                  */
/* Pour l'attaque, des groupes de 8 bytes sont constitués. le premier assaut */
/* s'effectue en concervant la formation initiale. Par la suite la recherche */
/* des unités adverse est réalisée par une recherche aléatoire sur la carte. */
/* Lorsque des unités adverses sont visibles, à chaque groupe est affecté    */
/* une cible qui se trouve être l'unité adverse la plus proche.              */
/*****************************************************************************/

#include "PP_Client.h"
#include "constantList_KP4.1.h"
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

#define NB_GROUPES 6
// 48 Bytes + 64 logic bombs == 112
#define MAX_UNITS 112

// pour définir un critère de tri selon X ou Y
enum CRITERE
{
	X,
	Y 
};

// définition d'un groupe
typedef struct {
	PP_Unit membres [MAX_UNITS]; // liste des unités affectées à ce groupe
	int nbMembres; // nombre d'unités dans le groupe
} Groupe;

// retourne vrai si toutes les unités du jeu sont mobiles
bool mobile(Groupe g){
	int i;
	PP_PendingCommands cmd;
	for (i = 0 ; i < g.nbMembres ; i++){
		if (PP_Unit_GetPendingCommands(g.membres[i], &cmd) != -1){
			if (cmd.nbCmds == 0)
				return false;
		}
	}
	return true;
}
// initialise un groupe avec tous les bytes présents dans le jeu
void initialiseBytes(Groupe *g){
	int i, cpt;
	cpt = 0;
	for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) && cpt < MAX_UNITS ; i++){
		if (PP_Unit_GetType(PP_GetUnitAt(MY_COALITION, i)) == BYTE){
			g->membres[cpt] = PP_GetUnitAt(MY_COALITION, i);
			cpt++;
		}
	}
	g->nbMembres = cpt;
}

// détermine si une unité est supérieure ou inférieure à une autre en fonction
// d'un critère (X ou Y)
int sup(PP_Unit u1, PP_Unit u2, CRITERE c){
	if (c == X)
		return PP_Unit_GetPosition(u1).x > PP_Unit_GetPosition(u2).x;
	else
		return PP_Unit_GetPosition(u1).y > PP_Unit_GetPosition(u2).y;
}

// trie les membres du groupe selon un certain critère (X ou Y)
void trierSelon(Groupe *g, CRITERE c){
	int i, j;
	PP_Unit u;
	
	// réalisation du tri (tri par insertion)
	for (i = 1 ; i < g->nbMembres ; i++){
		u = g->membres[i];
		j = i;
		while (j > 0 && sup(g->membres[j-1], u, c)){
			g->membres[j] = g->membres[j - 1];
			j = j-1;
		}
		g->membres[j] = u;
	}
}

// supprime du groupe les unités détruites
void traiterUnitesDetruites(Groupe *g){
	int i, j;
	j = 0;
	for (i = 0 ; i < g->nbMembres ; i++){
		if (j != i && PP_Unit_GetType(g->membres[i]) != -1)
			g->membres[j] = g->membres[i];
		if (PP_Unit_GetType(g->membres[i]) != -1)
			j++;
	}
	g->nbMembres = j;
}

// affecter les unités d'une armee dans les differents groupes
void affecterGroupes(Groupe armee, Groupe groupes [], int tailleGroupes){
	int i, j, g;
	
	// initialisation des groupes
	for (i = 0 ; i < NB_GROUPES ; i++){
		groupes[i].nbMembres = 0;
	}
	// affectation des groupes
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

// faire progresser un groupe en ligne droite d'une certaine distance
void progresser (Groupe g, float distance){
	int i;
	PP_Pos pos;
	
	for (i = 0 ; i < g.nbMembres ; i++){
		pos = PP_Unit_GetPosition(g.membres[i]);
		pos.x = pos.x + distance;
		if (pos.x < 0)
			pos.x = 10;
		if (pos.x > PP_GetMapSize().x)
			pos.x = PP_GetMapSize().x - 10;
		PP_Unit_ActionOnPosition(g.membres[i], MOVE, pos);
	}
}

// détermine une cible à attaquer pour le groupe g
PP_Unit determinerCible (Groupe g){
	PP_Unit e, tmp;
	PP_Pos bar;
	int i;
	float distance, dx, dy;
	
	// calcul du barycentre du groupe
	bar.x = 0;
	bar.y = 0;
	for (i = 0 ; i < g.nbMembres ; i++){
		bar.x = bar.x + PP_Unit_GetPosition(g.membres[i]).x;
		bar.y = bar.y + PP_Unit_GetPosition(g.membres[i]).y;
	}
	if (g.nbMembres != 0){
		bar.x = bar.x / g.nbMembres;
		bar.y = bar.y / g.nbMembres;
	}
	// rechercher l'ennemi le plus proche du groupe
	distance = PP_GetMapSize().x*PP_GetMapSize().x+PP_GetMapSize().y*PP_GetMapSize().y;
	for (i = 0 ; i < PP_GetNumUnits(ENEMY_COALITION) ; i++){
		tmp = PP_GetUnitAt(ENEMY_COALITION, i);
		dx = bar.x - PP_Unit_GetPosition(tmp).x;
		dy = bar.y - PP_Unit_GetPosition(tmp).y;
		if (dx*dx+dy*dy < distance){
			distance = dx*dx+dy*dy;
			e = tmp;
		}
	}
	return e;
}

bool enAttaque(PP_Unit source, PP_Unit cible){
	int i;
	PP_PendingCommands cmd;
	PP_Unit_GetPendingCommands(source, &cmd);
	for (i = 0 ; i < cmd.nbCmds ; i++)
		if (cmd.cmd[i].code == ATTACK)
			if (cmd.cmd[i].nbParams == 1)
				if (cmd.cmd[i].param[0] == cible)
					return true;
	return false;
}

int main (){
	int i, j, sens, distance;
	PP_Pos pos;
	PP_Unit u;
	Groupe armee;
	Groupe groupes [NB_GROUPES];
	bool premierLancement;
	
	// ouverture du jeu
	PP_Open();
	// initialisation de l'armée
	initialiseBytes(&armee);
	
	// determination de la direction de l'attaque
	if (PP_GetStartPosition().x < PP_GetMapSize().x/2)
		sens = 1;
	else
		sens = -1;
	
	// lancer l'attaquer
	premierLancement = true;
	while (!PP_IsGameOver()){
		traiterUnitesDetruites(&armee);
		printf("  Taille armee : %d\n", armee.nbMembres);
		// restructurer les groupes
		trierSelon(&armee, Y);
		affecterGroupes(armee, groupes, 8);
		printf("  Affichage des groupes : \n");
		for (i = 0 ; i < NB_GROUPES ; i++)
			printf("    groupe %d : %d\n", i, groupes[i].nbMembres);
		
		if (PP_GetNumUnits(ENEMY_COALITION) == 0){
			// rechercher l'adversaire
			if (premierLancement){
				// si premier lancement, avancer en formation
				printf("  Lancer la marche\n");
				distance = (int)(sens*PP_GetMapSize().x);
				progresser(armee, distance);
				premierLancement = false;
				// attendre que l'armée ai commence a bouger (rester vigilant quand à la
				// présence de l'ennemie)
				while (PP_GetNumUnits(ENEMY_COALITION) == 0 && !mobile(armee))
					printf("Attendre depart armee\n");
			}
			else{
				// rechercher aléatoirement l'adversaire
				for (i = 0 ; i < NB_GROUPES ; i++){
					if (!mobile(groupes[i])){
						pos.x = rand() % (int)PP_GetMapSize().x + 1;
						pos.y = rand() % (int)PP_GetMapSize().y + 1;
						for (j = 0 ; j < groupes[i].nbMembres ; j++)
							PP_Unit_ActionOnPosition(groupes[i].membres[j], MOVE, pos);
					}
				}
			}
		}
		else{
			// Affecter une cible à chaque groupes
			for (i = 0 ; i < NB_GROUPES ; i++){
				u = determinerCible(groupes[i]);
				printf("  Cible pour le groupe %d : %d\n", i, u);
				// pour chaque membre du groupe, donner l'ordre d'attaque si necessaire
				for (j = 0 ; j < groupes[i].nbMembres ; j++)
					if (!enAttaque(groupes[i].membres[j], u))
						PP_Unit_ActionOnUnit(groupes[i].membres[j], ATTACK, u);
			}
		}
	}
	
	// fermer le jeu
	PP_Close();
	return 0;
}
