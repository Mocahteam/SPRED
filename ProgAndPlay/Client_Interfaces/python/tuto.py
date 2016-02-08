from pp import *
from constantList_KP4_1 import *

PP_Open()
p = PP_Pos (1250.0, 1048.0)
u = PP_GetUnitAt(MY_COALITION, 0)
PP_Unit_ActionOnPosition(u, MOVE, p)
PP_Close()

