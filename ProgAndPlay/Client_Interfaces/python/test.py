from constantList_KP4_1 import *
from pp import *

PP_Open()
print ("Is game over :", PP_IsGameOver())
mapSize = PP_GetMapSize()
print ("Map size : (", mapSize.x, ", ", mapSize.y, ")", sep="")
startPos = PP_GetStartPosition()
print ("Start position : (", startPos.x, ", ", startPos.y, ")", sep="")
n = PP_GetNumSpecialAreas ()
print ("Nombre de zones spéciales :", n)
i = 0
while i < n:
    pos = PP_GetSpecialAreaPosition (i)
    print ("   Pos zone spéciale ", i, " : (", pos.x, ", ", pos.y, ")", sep="")
    i += 1
print ("Ressources en Métal :", PP_GetResource(METAL))
print ("Ressources en Energie :", PP_GetResource(ENERGY))
coalition = 0
while coalition < 3:
    n = PP_GetNumUnits (coalition)
    print("Nombre d'unités de la coalition", coalition, ":", n)
    i = 0
    while i < n:
        u = PP_GetUnitAt(coalition, i)
        print ("   Id unité", i, ":", u)
        local_coalition = PP_Unit_GetCoalition(u)
        print ("     Coalition :", local_coalition)
        print ("     Type :", PP_Unit_GetType(u))
        pos = PP_Unit_GetPosition(u)
        print ("     Position : (", pos.x, ", ", pos.y, ")", sep="")
        print ("     Health :", PP_Unit_GetHealth(u))
        print ("     Max halth :", PP_Unit_GetMaxHealth(u))
        group = PP_Unit_GetGroup(u)
        print ("     Group :", group)
        if local_coalition == MY_COALITION:
            PP_Unit_SetGroup(u, 1)
            if group != 1:
                print ("Waiting group synchro...")
                while group == PP_Unit_GetGroup(u):
                    tmp = 0
            print ("     Group :", PP_Unit_GetGroup(u))
            print ("     Getting pending commands:")
            cmds = PP_Unit_GetPendingCommands(u)
            print ("         Nb cmds :", len(cmds))
            for cmd in cmds:
                print ("           Code :", cmd.code)
                j = 0
                while j < cmd.nbParams:
                    print ("             Param", j, ":", cmd.param[j])
                    j += 1
            #PP_Unit_ActionOnUnit (u, GUARD, 914) # Change last parameter with valid unit id
            pos = PP_Pos (2448, 1500)
            PP_Unit_ActionOnPosition (u, MOVE, pos)
            PP_Unit_UntargetedAction (u, LAUNCH_MINE)
        i += 1
    coalition += 1

PP_Close()
