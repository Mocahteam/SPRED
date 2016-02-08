--
-- listeConstante.spec
-- liste des constantes valides pour int�ragir avec le mod Kernel_Panic 2.2
-- Div0 compatible avec le moteur Spring
--

----------------
-- Coalitions --
----------------
constante MOI <Entier> = 0 ;      -- code de la coalition du joueur
constante ALLIE <Entier> = 1 ;    -- code de la coalition des alli�s du joueur
constante ENNEMI <Entier> = 2 ;   -- code de la coalition des ennemis du joueur

---------------------
-- Ordres basiques --
---------------------
constante DEPLACER <Entier> = 10 ;       -- code de l'action d�placement
constante PATROUILLER <Entier> = 15 ;    -- code de l'action patrouille
constante COMBATTRE <Entier> = 16 ;      -- code de l'action combat
constante ATTAQUER <Entier> = 20 ;       -- code de l'action attaque
constante GARDER <Entier> = 25 ;         -- code de l'action garde
constante REPARER <Entier> = 40 ;        -- code de l'action r�paration
constante RECLAMER <Entier> = 90 ;       -- code de l'action r�clamation
constante RESTAURER <Entier> = 110 ;      -- code de l'action restauration

---------------------------------------
-- Identifiants des types des unit�s --
---------------------------------------
-- Commun � tout les camps
constante BADBLOCK <Entier> = 2 ;         -- code de l'unit� BADBLOCK
constante LOGICBOMB <Entier> = 18 ;       -- code de l'unit� LOGICBOMB
constante DEBUG <Entier> = 19 ;           -- code de l'unit� DEBUG
-- Pour le camp System
constante KERNEL <Entier> = 17 ;          -- code de l'unit� KERNEL
constante SOCKET <Entier> = 23 ;          -- code de l'unit� SOCKET
constante TERMINAL <Entier> = 24 ;        -- code de l'unit� TERMINAL
constante ASSEMBLER <Entier> = 1 ;        -- code de l'unit� ASSEMBLER
constante BIT <Entier> = 3 ;              -- code de l'unit� BIT
constante BYTE <Entier> = 6 ;             -- code de l'unit� BYTE
constante POINTER <Entier> = 21 ;         -- code de l'unit� POINTER
-- Pour le camp Hacker
constante HOLE <Entier> = 15 ;            -- code de l'unit� HOLE
constante WINDOW <Entier> = 28 ;          -- code de l'unit� WINDOW
constante OBELISK <Entier> = 20 ;         -- code de l'unit� OBELISK
constante TROJAN <Entier> = 25 ;          -- code de l'unit� TROJAN
constante VIRUS <Entier> = 27 ;           -- code de l'unit� VIRUS
constante BUG <Entier> = 4 ;              -- code de l'unit� BUG
constante EXPLOIT <Entier> = 12 ;         -- code de l'unit� EXPLOIT
constante WORM <Entier> = 30 ;            -- code de l'unit� WORM
constante DENIALOFSSERVICE <Entier> = 8 ; -- code de l'unit� DENIALOFSERVICE


---------------------
-- Armes sp�ciales --
---------------------
constante NXFALG <Entier> = 33389 ;        -- code de l'arme sp�ciale du POINTER
constante LAUNCHMINES <Entier> = 33395 ;   -- code de l'arme sp�ciale du BYTE
constante SIGTERM <Entier> = 35126 ;       -- code de l'arme du TERMINAL
constante DEPLOY <Entier> = 33390 ;        -- code de l'action sp�ciale du BUG
constante BOMBARD <Entier> = 33394 ;       -- code de l'arme sp�ciale du BUG
constante UNDEPLOY <Entier> = 33391 ;      -- code de l'action sp�ciale de
                                           -- l'EXPLOIT
constante AUTOHOLD <Entier> = 32103 ;      -- code de l'arme de l'OBELISK
