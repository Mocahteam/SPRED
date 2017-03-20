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
	local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/C")
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
			return "Etape 1 : Vous devez d�finir en tout premier lieu la fonction principale de votre programme. En langage C cette fonction doit imp�rativement s'appeler \"main\" et retourner un code d'erreur d'ex�cution du programme, le type de ce code est "..purple.."int"..white..". La valeur "..orange.."0"..white.." retourn�e par la fonction \"main\" indique que tout s'est d�roul� correctement. "
		else
			return "Step 1: Define the main function of your program. With C language, this function is named \"main\" and returns the program error code. This code is an "..purple.."int"..white..". "..orange.."0"..white.." means that no error occurs. "
		end
	elseif currentPage == 2 then
		if lang == "fr" then
			return "Etape 2 : Apr�s avoir d�fini la fonction \"main\", vous devez initialiser la biblioth�que Prog&Play. Ceci doit �tre fait � l'aide de la fonction \"PP_Open\". Enfin, pensez toujours � appeler, avant la fin de votre programme, la fonction \"PP_Close\" pour fermer proprement la biblioth�que Prog&Play. A noter que les fonctions de la biblioth�que Prog&Play sont d�finies dans le fichier \"PP_Client.h\". Vous devez donc l'inclure � l'aide de la directive de pr�processeur "..red.."#include"..white..". "
		else
			return "Step 2 : When the main procedure is defined, you have to initialize the Prog&Play library. This can be done with the \"PP_Open\" function. Then, don't forget to call the \"PP_Close\" function in order to properly close the Prog&Play library. Functions of the Prog&Play library are defined into the \"PP_Client.h\" file. You have to include it with the "..red.."#include"..white.." directive. "
		end
	elseif currentPage == 3 then
		if lang == "fr" then
			return "Etape 3 : Apr�s avoir initialis� la biblioth�que Prog&Play, vous pouvez vous attacher � tenter de r�soudre le probl�me qui vous est pos�. Dans ce tutoriel, l'objectif consiste � d�placer votre unit� � une position particuli�re. Pour agir sur votre unit�, vous devez dans un premier temps la r�cup�rer dans le contexte de votre programme. Ceci peut �tre fait � l'aide de la fonction \"PP_GetUnitAt\". Dans l'exemple ci-dessous, les param�tres indiquent que vous souhaitez r�cup�rer la premi�re unit� (indice "..orange.."0"..white..") que vous poss�dez (constante MY_COALITION). L'unit� ainsi retourn�e est stock�e dans une variable (ici nomm�e \"u\") de type PP_Unit. "
		else
			return "Step 3: When you have initialized the Prog&Play library, you can try to resolve game objective. In this tutorial, objective consists in moving a unit to a target position. In order to control the unit, you have to get it into the program context. You can do it with the \"PP_GetUnitAt\" function. In example below, you get the first unit (index "..orange.."0"..white..") you control (MY_COALITION constant). The unit returned is stored into a \"PP_Unit\" variable named \"u\". "
		end
	elseif currentPage == 4 then
		if lang == "fr" then
			return "Etape 4 : Apr�s avoir r�cup�r� votre unit�, vous devez d�finir la position � laquelle vous souhaitez l'envoyer. D�clarez une variable \"p\" de type PP_Pos et renseignez les champs x et y de type "..purple.."float"..white..". A noter que l'origine de la carte de jeu se trouve en haut � gauche. "
		else
			return "Step 4: When you have got the unit, you have to define the position where you want move it. Define the \"p\" variable as a \"PP_Pos\" and set x field and y field. Note: the map origin is on the top left corner. "
		end
	elseif currentPage == 5 then
		if lang == "fr" then
			return "Etape 5 : Apr�s avoir d�fini la position � atteindre, vous pouvez donner l'ordre � votre unit� de s'y d�placer. Ceci peut �tre fait � l'aide de la fonction \"PP_Unit_ActionOnPosition\" qui prend comme param�tre l'unit� � commander (\"u\"), l'ordre � r�aliser (\"MOVE\"), la position (\"p\") o� effectuer l'action et une valeur binaire indiquant si l'appel est bloquant ou pas. La constante \"MOVE\" ainsi que d'autres ordres sont d�finis dans le fichier \"constantList_KP4.1.h\". Vous devez donc l'inclure � l'aide de la directive de pr�processeur "..red.."#include"..white..". "
		else
			return "Step 5: When you have defined the target position, you can order your unit to move to it. Use the \"PP_Unit_ActionOnPosition\" function that commands a unit (\"u\") to carry out action (\"MOVE\") on a specified position (\"p\"). The last parameter is a boolean that defines if the call is blocking or not. The \"MOVE\" constant and others are defined into the  \"constantList_KP4.1.h\" file. You have to include it with the "..red.."#include"..white.." directive. "
		end
	elseif currentPage == 6 then
		if lang == "fr" then
			return "Etape 6 : Maintenant que vous avez �crit votre premier programme, il ne vous reste plus qu'� le compiler et l'ex�cuter pour observer son influence dans le jeu. N'h�sitez pas � consulter les fichiers \"PP_Client.h\" et \"constantList_KP4.1.h\", vous y trouverez de nombreuses informations sur les fonctionalit�s de la biblioth�que Prog&Play qui vous seront utiles pour terminer la campagne � venir. "
		else
			return "Step 6: When you have written your first program, you have to compile and execute it in order to observe consequences into the game. Do not hesitate to take a look of \"PP_Client.h\" and \"constantList_KP4.1.h\" files, you will find a lot of informations on Prog&Play functionalities. "
		end
	else
		return "Page not found "
	end
end

local function getTextHeight ()
	if lang == "fr" then
		return 220
	else
		return 160
	end
end

local template_CPages_Text = {
	group = "tutorial",
	closed = true,
	text = getText(),
	x = 0,
	y = 0,
	x2 = 470,
	y2 = getTextHeight (),
}

local template_CPages = {
  group = "tutorial",
  closed = true,
  backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/C/C1.jpg",
  x = 0,
  y = 0,
  x2 = 470,
  y2 = 302,
  tabs = {
		{preset = function(tab)
				if lang == "fr" then
					tab.title = "Page pr�c�dente"
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
						CPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/C/C"..currentPage..".jpg"
						CPages.son.lineArray = WordWrap(getText(), CPages.son.textWidth)
					end
					setBackgroundColor (tab, "previous")
					setBackgroundColor (CPages.tabData[2], "next")
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
						CPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/C/C"..currentPage..".jpg"
						CPages.son.lineArray = WordWrap(getText(), CPages.son.textWidth)
					end
					setBackgroundColor (CPages.tabData[1], "previous")
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
					CPages:Close()
					MainMenu:Open()
					TutoView = MainMenuc
				end
			end
		}
	}
}

local function CreateCPagesCentered ()
	template_CPages.OnViewResized = function ()
		local needToBeOpenAgain = CPages and not CPages.closed
		if needToBeOpenAgain then CPages:Close() end
		CPages = CreateCPagesCentered()
		CPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/C/C"..currentPage..".jpg"
		CPages.son.lineArray = WordWrap(getText(), CPages.son.textWidth)
		if needToBeOpenAgain then
			TutoView = CPages
			TutoView:Open()
		end
	end
	template_CPages.son = Window:CreateCentered(template_CPages_Text)
	local win = Window:CreateCentered(template_CPages)
	local winHeight = win.y2 - win.y1
	local sonHeight = win.son.y2 - win.son.y1
	win.son.dy = win.son.dy + (winHeight+sonHeight)/2
	win.son.dy = math.floor(win.son.dy - sonHeight/2)
	win.dy = math.floor(win.dy - sonHeight/2)
	return win
end

CPages = CreateCPagesCentered ()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------