--
-- listeConstantesKP41.spec
-- liste des constantes valides pour int�ragir avec les unit�s System du mod
-- Kernel_Panic 4.1 compatible avec le moteur Spring
--

----------------
-- Coalitions --
----------------
constante MOI <Entier> = 0;      -- code de la coalition du joueur
constante ALLIE <Entier> = 1;    -- code de la coalition des alli�s du joueur
constante ENNEMI <Entier> = 2;   -- code de la coalition des ennemis du joueur

----------------------------
-- Identifiant des unit�s --
----------------------------
constante ASSEMBLER <Entier> = 2;
constante BADBLOCK <Entier> = 3;
constante BIT <Entier> = 4;
constante BYTE <Entier> = 7;
constante KERNEL <Entier> = 25;
constante LOGICBOMB <Entier> = 26;
constante POINTER <Entier> = 39;
constante SIGNAL <Entier> = 44;
constante SOCKET <Entier> = 45;
constante TERMINAL <Entier> = 46;

-------------------------------------------------------------------------------
-- Ordres valables pour ASSEMBLER, BIT, BYTE, KERNEL, LOGIC_BOMB, POINTER et --
-- SOCKET                                                                    --
-------------------------------------------------------------------------------
constante STOP <Entier> = 0;              -- attend 0 param�tre
constante WAIT <Entier> = 5;              -- attend 0 param�tre
constante FIRESTATE <Entier> = 45;        -- attend 1 param�tre :
                                          --    0.0 => Hold fire
                                          --    1.0 => Return fire
                                          --    2.0 => Fire at will
constante SELFDESTRUCTION <Entier> = 65;  -- attend 0 param�tre
constante REPEAT <Entier> = 115;          -- attend 1 param�tre :
                                          --    0.0 => Repeat off
                                          --    1.0 => Repeat on
---------------------------------------------------------------------------
-- Ordres valables pour ASSEMBLER, BIT, BYTE, KERNEL, POINTER and SOCKET --
---------------------------------------------------------------------------
constante MOVE <Entier> = 10;       -- attend 1 param�tre : une position ou
                                    -- une unit�
constante PATROL <Entier> = 15;     -- attend 1 param�tre : une position ou
                                    -- une unit�
constante FIGHT <Entier> = 16;      -- attend 1 param�tre : une position ou
                                    -- une unit�
constante GUARD <Entier> = 25;      -- attend 1 param�tre : une position ou
                                    -- une unit�
constante MOVESTATE <Entier> = 50;  -- attend 1 param�tre :
                                    --    0.0 => Hold pos
                                    --    1.0 => Maneuver
                                    --    2.0 => Roam
----------------------------------------------------------------------------
-- Ordres valables pour BIT, BYTE, KERNEL, LOGIC_BOMB, POINTER and SOCKET --
----------------------------------------------------------------------------
constante ATTACK <Entier> = 20;   -- attend 1 param�tre : une position ou une
                                  -- unit�
------------------------------------
-- Ordres valables pour ASSEMBLER --
------------------------------------
constante REPAIR <Entier> = 40;          -- attend 1 param�tre : une position
                                         -- ou une unit�
constante RECLAIM <Entier> = 90;         -- attend 1 param�tre : une position
                                         -- ou une unit�
constante RESTORE <Entier> = 110;        -- attend 1 param�tre : une position
                                         -- ou une unit�
constante BUILDBADBLOCK <Entier> = -3;   -- attend 1 param�tre : une position
                                         -- ou une unit�
constante BUILDLOGICBOMB <Entier> = -26; -- attend 1 param�tre : une position
                                         -- ou une unit�
constante BUILDSOCKET <Entier> = -45;    -- attend 1 param�tre : une position
                                         -- ou une unit�
constante BUILDTERMINAL <Entier> = -46;  -- attend 1 param�tre : une position
                                         -- ou une unit�
constante DEBUG <Entier> = -35;          -- attend 1 param�tre : une position
                                         -- ou une unit�
---------------------------------
-- Ordres valables pour KERNEL --
---------------------------------
constante BUILDASSEMBLER <Entier> = -2; -- attend 1 param�tre : une position
                                        -- ou une unit�
constante BUILDBYTE <Entier> = -7;      -- attend 1 param�tre : une position
                                        -- ou une unit�
constante BUILDPOINTER <Entier> = -39;  -- attend 1 param�tre : une position
                                        -- ou une unit�
-------------------------------------------
-- Ordres valables pour KERNEL et SOCKET --
-------------------------------------------
constante BUILDBIT <Entier> = -4;        -- attend 1 param�tre : une position
                                         -- ou une unit�
constante STOPBUILDING <Entier> = -7658; -- attend 0 param�tre
-------------------------------
-- Ordres valables pour BYTE --
-------------------------------
constante LAUNCHMINE <Entier> = 33395; -- attend 0 param�tre
----------------------------------
-- Ordres valables pour POINTER --
----------------------------------
constante NXFLAG <Entier> = 33389; -- attend 1 param�tre : une position ou une
                                   -- unit�
-----------------------------------
-- Ordres valables pour TERMINAL --
-----------------------------------
constante SIGTERM <Entier> = 35126; -- attend 1 param�tre : une position ou
                                    -- une unit�

--------------------------------
-- Identifiant des ressources --
--------------------------------
constante METAL <Entier> = 0;
constante ENERGY <Entier> = 1;
