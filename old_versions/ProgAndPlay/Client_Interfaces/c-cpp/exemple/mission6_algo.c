#include "../PP_ALGO.h"
#include "stdio.h"

// Mission 6
Debut
	OUVRIR_JEU;
	PREMIERE_UNITE;
	TantQue current_unit != DERNIERE_UNITE Faire
		Si EST_UN_ASSEMBLEUR Alors
			DEPLACER_VERS(256, 811);
		FinSi
		UNITE_SUIVANTE;
	FinTantQue
	Si EST_UN_ASSEMBLEUR Alors
		DEPLACER_VERS(256, 811);
	FinSi
	FERMER_JEU;
Fin