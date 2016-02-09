#include "PP_Client.h"
#include "constantList_KP4.1.h"

/* Move all units to a specific position */
int main (){
	int i;
	/* define target position */
	PP_Pos p,p_1;
	p.x = 1792.0;
	p.y = 256.0;
	p_1.x = 1000.0;
	p_1.y = 256.0;
	PP_Unit assembler = -1, u, minUnit;
	PP_Open(); /* open the Prog&Play API */
	/* iterate all units */
	int cpt = 0;
	while (PP_IsGameOver() == 0) {
		int minHealth = 100000;
		cpt++;
		for (i = 0 ; i < PP_GetNumUnits(MY_COALITION) ; i++) {
			u = PP_GetUnitAt(MY_COALITION,i);
			if (assembler == -1 && PP_Unit_GetType(u) == ASSEMBLER)
				assembler = u;
			else if (PP_Unit_GetType(u) == BYTE) {
				if (cpt > 100 && PP_Unit_GetHealth(u) < minHealth) {
					minHealth = PP_Unit_GetHealth(u);
					minUnit = u;
				}
				if (PP_GetNumUnits(ENEMY_COALITION) == 0)
					PP_Unit_ActionOnPosition(u, ATTACK, p);
				else
					PP_Unit_ActionOnUnit(u, ATTACK, PP_GetUnitAt(ENEMY_COALITION, 0));
			}
		}
		if (cpt > 100 & PP_Unit_GetHealth(minUnit) < PP_Unit_GetMaxHealth(minUnit)) {
			PP_Unit_ActionOnUnit(assembler, REPAIR, minUnit);
			cpt = 0;
		}
		else if (PP_Unit_GetHealth(minUnit) == PP_Unit_GetMaxHealth(minUnit))
			PP_Unit_ActionOnPosition(assembler, MOVE, p_1);
	}
	/* close the Prog&Play API */
	PP_Close();
	return 0;
}
