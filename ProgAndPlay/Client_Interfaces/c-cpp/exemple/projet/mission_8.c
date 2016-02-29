#include "PP_Client.h"
#include "constantList_KP4.1.h"
#include "stdio.h"

/* Move all units to a specific position */
int main () {
	int i;
	/* define target position */
	PP_Pos p,p_1;
	p.x = 1792.0;
	p.y = 256.0;
	p_1.x = 1000.0;
	p_1.y = 350.0;
	PP_Unit assembler = -1, u, minUnit = -1;
	PP_PendingCommands cmd;
	PP_Open(); /* open the Prog&Play API */
	/* iterate all units */
	int cpt = 0;
	for (i = 0; i < PP_GetNumUnits(MY_COALITION); i++) {
		u = PP_GetUnitAt(MY_COALITION, i);
		if (assembler == -1 && PP_Unit_GetType(u) == ASSEMBLER)
			assembler = u;
	}
	PP_Unit_ActionOnPosition(assembler, MOVE, p_1);
	while (PP_IsGameOver() == 0) {
		minUnit = -1;
		for (i = 1; i < PP_GetNumUnits(MY_COALITION); i++) {
			u = PP_GetUnitAt(MY_COALITION,i);
			PP_Unit_GetPendingCommands(u, &cmd);
			int type = PP_Unit_GetType(u);
			if (type == BYTE) {
				if (minUnit == -1 || PP_Unit_GetHealth(u) < PP_Unit_GetHealth(minUnit)) {
					minUnit = u;
					if (minUnit == -1)
						cpt = 0;
				}
				if (cmd.nbCmds == 0 && PP_GetNumUnits(ENEMY_COALITION) == 0)
					PP_Unit_ActionOnPosition(u, MOVE, p);
				else if (cmd.nbCmds != 0 && PP_GetNumUnits(ENEMY_COALITION) != 0) {
					if (cmd.cmd[0].code == MOVE) {
						PP_Unit_UntargetedAction(u, STOP, -1);
						PP_Unit_ActionOnUnit(u, ATTACK, PP_GetUnitAt(ENEMY_COALITION, 0));
						printf("command attack\n");
					}
				}
			}
		}
		int health = PP_Unit_GetHealth(minUnit);
		int maxHealth = PP_Unit_GetMaxHealth(minUnit);
		if (cpt == 0) {
			if (health < maxHealth) {
				PP_Unit_ActionOnUnit(assembler, REPAIR, minUnit);
				printf("command repair\n");
				cpt++;
			}
		}
		else if (cpt > 500)
			cpt = 0;
		else
			cpt++;
	}
	/* close the Prog&Play API */
	PP_Close();
	return 0;
}
