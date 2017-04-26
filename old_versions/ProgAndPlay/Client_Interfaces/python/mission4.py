from constantList_KP4_1 import *
from pp import *

# définition des positions
bitsPos = PP_Pos(1400.0, 1371.0)
bytesPos = PP_Pos(479.0, 1825.0)
# Ouverture de la connexion avec le jeu
PP_Open()
# Récupérer la première unité
u = PP_GetUnitAt(MY_COALITION, 0)
if PP_Unit_GetType(u) == BIT:
    # Ordonner à mon unité courante de se déplacer
    PP_Unit_ActionOnPosition(u, MOVE, bitsPos)
    # Passer à l'unité suivante
    u = PP_GetUnitAt(MY_COALITION, 1)
    # Lui ordonner de rejoindre sa position
    PP_Unit_ActionOnPosition(u, MOVE, bytesPos)
else:
    # Ordonner à mon unité courante de se déplacer
    PP_Unit_ActionOnPosition(u, MOVE, bytesPos)
    # Passer à l'unité suivante
    u = PP_GetUnitAt(MY_COALITION, 1)
    # Lui ordonner de rejoindre sa position
    PP_Unit_ActionOnPosition(u, MOVE, bitsPos)
# Fermer la connexion avec le jeu
PP_Close()
