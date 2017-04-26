--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- C Window.
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local lang = Spring.GetModOptions()["language"] -- get the language
local white = "\255\255\255\255"
local gray = "\255\50\50\50"
local purple = "\255\143\006\255"
local orange = "\255\255\130\108"
local red = "\255\142\068\085"

local function setInactiveColor (tab)
	tab.isAboveColors = {
		bottomLeft  = {0.3, 0.3, 0.3, 0.3},
		topLeft     = {0.3, 0.3, 0.3, 0.3},
		topRight    = {0.3, 0.3, 0.3, 0.3},
		bottomRight = {0.3, 0.3, 0.3, 0.3}
	}
	tab.topLeftColor     = {0.3, 0.3, 0.3, 0.3}
	tab.topRightColor    = {0.3, 0.3, 0.3, 0.3}
	tab.bottomLeftColor  = {0.3, 0.3, 0.3, 0.3}
	tab.bottomRightColor = {0.3, 0.3, 0.3, 0.3}
	tab.title = gray..tab.title2..white
end

local function setParentColor (tab)
	if tab.isAbove then
		tab.isAboveColors = {
		    bottomLeft  = tab.parent.bottomLeftColor,
		    topLeft     = tab.parent.topLeftColor,
		    topRight    = tab.parent.topRightColor,
		    bottomRight = tab.parent.bottomRightColor,
		}
		tab.topLeftColor = {0.3, 0.3, 0.3,   1}
		tab.topRightColor = {0.3, 0.3, 0.3,   1}
		tab.bottomLeftColor = {  0,   0,   0,   1}
		tab.bottomRightColor = {0.5, 0.5, 0.5,   1}
	else
		tab.isAboveColors = {
		    bottomLeft  = {  0,   0,   0,   1},
		    topLeft     = {0.3, 0.3, 0.3,   1},
		    topRight    = {0.3, 0.3, 0.3,   1},
		    bottomRight = {0.5, 0.5, 0.5,   1},
		}
		tab.topLeftColor  = tab.parent.topLeftColor
		tab.topRightColor = tab.parent.topRightColor
		tab.bottomLeftColor = tab.parent.bottomLeftColor
		tab.bottomRightColor = tab.parent.bottomRightColor
	end
	tab.title = tab.title2
end

local currentPage = 1

local function setBackgroundColor (tab, pos)
	local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/Python")
	if currentPage == 1 then
		if pos == "previous" then
			setInactiveColor(tab)
		else
			setParentColor (tab)
		end
	elseif currentPage == n then
		if pos == "next" then
			setInactiveColor(tab)
		else
			setParentColor (tab)
		end
	else
		setParentColor (tab)
	end
end

local function getText ()
	if currentPage == 1 then
		if lang == "fr" then
			return "Etape 1 : Vous devez commencer par initialiser la bibliothèque Prog&Play. Ceci doit être fait à l'aide de la fonction \"PP_Open\". Enfin, pensez toujours à appeler, avant la fin de votre programme, la fonction \"PP_Close\" pour fermer proprement la bibliothèque Prog&Play. A noter que les fonctions de la bibliothèque Prog&Play sont définies dans le fichier \"pp.py\". Vous devez donc inclure ce module à l'aide de la directive : "..orange.."from"..white.." ...  "..orange.."import"..white.." ... "
		else
			return "Step 1 : You have to start by initializing the Prog&Play library. This can be done with the \"PP_Open\" function. Then, don't forget to call the \"PP_Close\" function in order to properly close the Prog&Play library. Functions of the Prog&Play library are defined into the \"pp.py\" file. You have to include this module with the \""..orange.."from"..white.." ...  "..orange.."import"..white.." ...\" directive. "
		end
	elseif currentPage == 2 then
		if lang == "fr" then
			return "Etape 2 : Après avoir initialisé la bibliothèque Prog&Play, vous pouvez vous attacher à tenter de résoudre le problème qui vous est posé. Dans ce tutoriel, l'objectif consiste à déplacer votre unité à une position particulière. Pour agir sur votre unité, vous devez dans un premier temps la récupérer dans le contexte de votre programme. Ceci peut être fait à l'aide de la fonction \"PP_GetUnitAt\". Dans l'exemple ci-dessous, les paramètres indiquent que vous souhaitez récupérer la première unité (indice 0) que vous possédez (constante MY_COALITION). L'unité ainsi retournée est stockée dans une variable (ici nommée \"u\"). "
		else
			return "Step 2: When you have initialized the Prog&Play library, you can try to resolve game objective. In this tutorial, objective consists in moving a unit to a target position. In order to control the unit, you have to get it into the program context. You can do it with the \"PP_GetUnitAt\" function. In example below, you get the first unit (index 0) you control (MY_COALITION constant). The unit returned is stored into a variable named \"u\". "
		end
	elseif currentPage == 3 then
		if lang == "fr" then
			return "Etape 3 : Après avoir récupéré votre unité, vous devez définir la position à laquelle vous souhaitez l'envoyer. Déclarez une variable \"p\" et initialisez la avec les coordonnées \"1250\" et \"1048\". A noter que l'origine de la carte de jeu se trouve en haut à gauche. "
		else
			return "Step 3: When you have got the unit, you have to define the position where you want move it. Define the \"p\" variable with \"1250\" and \"1048\" coordinates. Note: the map origin is on the top left corner. "
		end
	elseif currentPage == 4 then
		if lang == "fr" then
			return "Etape 4 : Après avoir défini la position à atteindre, vous pouvez donner l'ordre à votre unité de s'y déplacer. Ceci peut être fait à l'aide de la fonction \"PP_Unit_ActionOnPosition\" qui prend comme paramètre l'unité à commander (\"u\"), l'ordre à réaliser (\"MOVE\") et la position (\"p\") où effectuer l'action. La constante \"MOVE\" ainsi que d'autres ordres sont définis dans le fichier \"constantList_KP4_1.py\". Vous devez donc inclure ce module à l'aide de la directive "..orange.."from"..white.." ... "..orange.."import"..white.." ... "
		else
			return "Step 4: When you have defined the target position, you can order your unit to move to it. Use the \"PP_Unit_ActionOnPosition\" function that commands a unit (\"u\") to carry out action (\"MOVE\") on a specified position (\"p\"). The \"MOVE\" constant and others are defined into the  \"constantList_KP4_1.py\" file. You have to include it with the \""..orange.."from"..white.." ... "..orange.."import"..white.." ...\" directive. "
		end
	elseif currentPage == 5 then
		if lang == "fr" then
			return "Etape 5 : Maintenant que vous avez écrit votre premier programme, il ne vous reste plus qu'à l'exécuter pour observer son influence dans le jeu. N'hésitez pas à consulter les fichiers \"pp.py\" et \"constantList_KP4_1.py\", vous y trouverez de nombreuses informations sur les fonctionalités de la bibliothèque Prog&Play qui vous seront utiles pour terminer la campagne à venir. "
		else
			return "Step 5: When you have written your first program, you have to compile and execute it in order to observe consequences into the game. Do not hesitate to take a look of \"pp.py\" and \"constantList_KP4_1.py\" files, you will find a lot of informations on Prog&Play functionalities. "
		end
	else
		return "Page not found "
	end
end

local function getTextHeight ()
	if lang == "fr" then
		return 280
	else
		return 200
	end
end

local template_PythonPages_Text = {
	group = "tutorial",
	closed = true,
	text = getText(),
	x = 0,
	y = 0,
	x2 = 367,
	y2 = getTextHeight (),
}

local template_PythonPages = {
  group = "tutorial",
  closed = true,
  backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Python/Python1.jpg",
  x = 0,
  y = 0,
  x2 = 367,
  y2 = 168,
  tabs = {
		{preset = function(tab)
				if lang == "fr" then
					tab.title = "Page précédente"
					tab.title2 = tab.title
				else
					tab.title = "Previous page"
					tab.title2 = tab.title
				end
				tab.position = "left"
				setBackgroundColor(tab, "previous")
				tab.OnMouseReleaseAction = function()
					if currentPage > 1 then
						currentPage = currentPage - 1
						PythonPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Python/Python"..currentPage..".jpg"
						PythonPages.son.lineArray = WordWrap(getText(), PythonPages.son.textWidth)
					end
					setBackgroundColor (tab, "previous")
					setBackgroundColor (PythonPages.tabData[2], "next")
					tab:UpdateParentDisplayList()
				end
			end
		},
		{preset = function(tab)
				if lang == "fr" then
					tab.title = "Page suivante"
					tab.title2 = tab.title
				else
					tab.title = "Next page"
					tab.title2 = tab.title
				end
				tab.position = "right"
				setBackgroundColor(tab, "next")
				tab.OnMouseReleaseAction = function()
					local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/C")
					if currentPage < n then
						currentPage = currentPage + 1
						PythonPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Python/Python"..currentPage..".jpg"
						PythonPages.son.lineArray = WordWrap(getText(), PythonPages.son.textWidth)
					end
					setBackgroundColor (PythonPages.tabData[1], "previous")
					setBackgroundColor (tab, "next")
					tab:UpdateParentDisplayList()
				end
			end
		},
		{preset = function(tab)
				if lang == "fr" then
					tab.title = "Retour"
				else
					tab.title = "Back"
				end
				tab.position = "left"
				tab.OnMouseReleaseAction = function()
					PythonPages:Close()
					MainMenu:Open()
					TutoView = MainMenu
				end
			end
		}
	}
}

local function CreatePythonPagesCentered ()
	template_PythonPages.son = Window:CreateCentered(template_PythonPages_Text)
	local win = Window:CreateCentered(template_PythonPages)
	local winHeight = win.y2 - win.y1
	local sonHeight = win.son.y2 - win.son.y1
	win.son.dy = win.son.dy + (winHeight+sonHeight)/2
	win.son.dy = math.floor(win.son.dy - sonHeight/2)
	win.dy = math.floor(win.dy - sonHeight/2)
	return win
end

PythonPages = CreatePythonPagesCentered ()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------