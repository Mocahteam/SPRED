#include "../PP_ALGO.h"

// Mission 5
Debut
	OUVRIR_JEU;
	PREMIERE_UNITE;
	TantQue current_unit != DERNIERE_UNITE Faire
		DEPLACER_VERS(256, 1024);
		UNITE_SUIVANTE;
	FinTantQue
	DEPLACER_VERS(256, 1024);
	FERMER_JEU;
Fin
