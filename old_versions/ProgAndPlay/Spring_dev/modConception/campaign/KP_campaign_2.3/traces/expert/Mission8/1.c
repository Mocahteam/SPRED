#include "PP_Client.h"
#include "../constantList_KP4.1.h"

#include "stdio.h"

#define NBBYTES 3

// trie l'ensemble des unités du joueur
void trierUnites (PP_Pos raliementBytes, PP_Pos raliementBits){
	int i;
	PP_Unit unite;
	
	i = 0;
	while (i < PP_GetNumUnits(MY_COALITION)){
		unite = PP_GetUnitAt(MY_COALITION, i);
		if (PP_Unit_GetType(unite) != BYTE)
			PP_Unit_ActionOnPosition(unite, MOVE, raliementBits);
		else
			PP_Unit_ActionOnPosition(unite, MOVE, raliementBytes);
		i++;
	}
}

// attendre qu'au moin une unité ai commencé soit en activité
void attendreDepart (){
	PP_Unit u;
	int i;
	bool fini;
	
	fini = false;
	while (!fini){
		i = 0;
		while (i < PP_GetNumUnits(MY_COALITION) && !fini){
			u = PP_GetUnitAt(MY_COALITION, i);
			PP_PendingCommands pdgCmds;
			PP_Unit_GetPendingCommands(u, &pdgCmds);
			if (pdgCmds.nbCmds > 0)
				fini = true;
			i++;
		}
	}
}

// attendre la fin du rassemblement
void attendreRassemblement (){
	PP_Unit u;
	int i;
	bool fini;
	
	fini = false;
	while (!fini){
		fini = true;
		i = 0;
		while (i < PP_GetNumUnits(MY_COALITION) && fini){
			u = PP_GetUnitAt(MY_COALITION, i);
			PP_PendingCommands pdgCmds;
			PP_Unit_GetPendingCommands(u, &pdgCmds);
			if (pdgCmds.nbCmds > 0)
				fini = false;
			i++;
		}
	}
}

// lance l'attaque sur la position pos
void lancerAttaque (PP_Pos pos){
	int i, j, urgent, urgencePrecedente, cpt;
	PP_Unit unite, assembleur;
	PP_Unit bytes [NBBYTES];
	bool assembleurToujoursVivant, assembleurNonTrouve;
	
	// récupérer le premier assembleur et les octets
	i = 0;
	cpt = 0;
	assembleurNonTrouve = true;
	while (i < PP_GetNumUnits(MY_COALITION)){
		unite = PP_GetUnitAt(MY_COALITION, i);
		if (assembleurNonTrouve && PP_Unit_GetType(unite) == ASSEMBLER){
			assembleurNonTrouve = false;
			assembleur = unite;
		}
		if (cpt < NBBYTES && PP_Unit_GetType(unite) == BYTE){
			bytes[cpt] = unite;
			cpt++;
		}
		i++;
	}
	// lancer la marche
	i = 0;
	while (i < PP_GetNumUnits(MY_COALITION)){
		unite = PP_GetUnitAt(MY_COALITION, i);
		if (PP_Unit_GetType(unite) == BYTE)
			PP_Unit_ActionOnPosition(unite, FIGHT, pos);
		else
			PP_Unit_ActionOnUnit(unite, GUARD, bytes[0]);
		i++;
	}
	
	// avancer jusqu'à trouver l'ennemie
	while (PP_GetNumUnits (ENEMY_COALITION) == 0){
		printf ("Avancer jusqu'a trouver l'ennemi\n");
	}
	
	// tout lacher (sauf l'assembleur)
	i = 0;
	while (i < PP_GetNumUnits(MY_COALITION)){
		unite = PP_GetUnitAt(MY_COALITION, i);
		if (PP_Unit_GetType(unite) != ASSEMBLER)
			PP_Unit_ActionOnPosition(unite, FIGHT, pos);
		i++;
	}
	
	// réparer les bytes endommagés
	urgencePrecedente = -1;
	assembleurToujoursVivant = PP_Unit_GetType(assembleur) > 0;
	while (!PP_IsGameOver() && assembleurToujoursVivant){
		// tester si l'assembleur est toujours vivant
		assembleurToujoursVivant = PP_Unit_GetType(assembleur) > 0;
		if (assembleurToujoursVivant){
			// supprimer les octets détruits
			i = 0;
			while (i < cpt){
				if (PP_Unit_GetType(bytes[i]) == -1){
					// supprimer cet octet
					j = i;
					while (j+1 < cpt){
						bytes[j] = bytes[j+1];
						j++;
					}
					cpt--;
				}
				else
					i++;
			}
			// recherche de l'octet le plus endomagé
			i = 0;
			urgent = -1;
			while (i < cpt){
				// vérifier si l'octet courant est plus prioritaire que la précédente
				// urgence
				if (urgent == -1)
					urgent = i;
				if (i != urgent)
					if (PP_Unit_GetHealth(bytes[i]) < PP_Unit_GetHealth(bytes[urgent]))
						urgent = i;
				i++;
			}
			if (urgent != -1){
				PP_PendingCommands asmPdgCmds;
				PP_Unit_GetPendingCommands(assembleur, &asmPdgCmds);
				if (urgent != urgencePrecedente || asmPdgCmds.nbCmds == 0){
					PP_Unit_ActionOnUnit(assembleur, REPAIR, bytes[urgent]);
					urgencePrecedente = urgent;
				}
			}
		}
	}
}

int main (){
	PP_Pos attaque = {1792.0, 256.0};
	PP_Pos bytes = {478.0, 255.0};
	PP_Pos bits = {255.0, 255.0};
	
	// ouvrir le jeu
	PP_Open();
	
	trierUnites(bytes, bits);
	
	attendreDepart ();
	
	attendreRassemblement ();
	
	lancerAttaque (attaque);
	
	// fermer le jeu
	PP_Close();
}
