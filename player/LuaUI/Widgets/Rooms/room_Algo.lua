--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Algo Window.
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
	local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/Algo")
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
			return "Etape 1 : En langage Algo votre programme doit imp�rativement contenir les mots cl�s \"Debut\" et \"Fin\" qui d�limittent le d�but et la fin de votre programme. "
		else
			return "Step 1: With Algo language, your program are structured around \"Debut\" and \"Fin\" key words. "
		end
	elseif currentPage == 2 then
		if lang == "fr" then
			return "Etape 2 : Apr�s avoir d�fini le cadre de votre programme, vous devez initialiser la biblioth�que Prog&Play. Ceci doit �tre fait � l'aide de l'op�rateur \"OUVRIR_JEU\". Pensez toujours � appeler, avant la fin de votre programme, l'op�rateur \"FERMER_JEU\" pour fermer proprement la biblioth�que Prog&Play. A noter que les op�rateurs de la biblioth�que Prog&Play sont d�finies dans le fichier \"PP_ALGO.h\". Vous devez donc l'inclure � l'aide du mot cl� "..red.."#include"..white..". "
		else
			return "Step 2 : When you have define the frame of your program, you have to initialize the Prog&Play library. This can be done with the \"OUVRIR_JEU\" operator. Then, don't forget to call the \"FERMER_JEU\" operator in order to properly close the Prog&Play library. Operators of the Prog&Play library are defined into the \"PP_ALGO.h\" file. You have to include it with the "..red.."#include"..white.." directive. "
		end
	elseif currentPage == 3 then
		if lang == "fr" then
			return "Etape 3 : Apr�s avoir initialis� la biblioth�que Prog&Play, vous pouvez vous attacher � tenter de r�soudre le probl�me qui vous est pos�. Dans ce tutoriel, l'objectif consiste � d�placer votre unit� � une position particuli�re. Pour agir sur votre unit�, vous devez dans un premier temps la charger dans le contexte de votre programme. Ceci peut �tre fait � l'aide de l'op�rateur \"PREMIERE_UNITE\". "
		else
			return "Step 3: When you have initialized the Prog&Play library, you can try to resolve game objective. In this tutorial, objective consists in moving a unit to a target position. In order to control the unit, you have to get it into the program context. You can do it with the \"PREMIERE_UNITE\" operator. "
		end
	elseif currentPage == 4 then
		if lang == "fr" then
			return "Etape 4 : Apr�s avoir charg� votre unit�, vous pouvez lui donner un ordre de d�placement. Ceci peut �tre fait � l'aide de l'op�rateur \"DEPLACER_VERS\" qui prend comme param�tre les coordonn�es de la position � atteindre. A noter que l'origine de la carte de jeu se trouve en haut � gauche. "
		else
			return "Step 4: When you have got the unit, you can give a move order to it. Use the \"DEPLACER_VERS\" operator with target coordinates. Note: the map origin is on the top left corner. "
		end
	elseif currentPage == 5 then
		if lang == "fr" then
			return "Etape 5 : Maintenant que vous avez �crit votre premier programme, il ne vous reste plus qu'� le compiler et l'ex�cuter pour observer son influence dans le jeu. N'h�sitez pas � consulter le fichier \"PP_ALGO.h\" vous y trouverez de nombreuses informations sur les fonctionalit�s de la biblioth�que Prog&Play qui vous seront utiles pour terminer la campagne � venir. "
		else
			return "Step 5: When you have written your first program, you have to compile and execute it in order to observe consequences into the game. Do not hesitate to take a look of \"PP_ALGO.h\" file, you will find a lot of informations on Prog&Play functionalities. "
		end
	else
		return "Page not found "
	end
end

local function getTextHeight ()
	if lang == "fr" then
		return 220
	else
		return 180
	end
end

local template_AlgoPages_Text = {
	group = "tutorial",
	closed = true,
	text = getText(),
	x = 0,
	y = 0,
	x2 = 363,
	y2 = getTextHeight (),
}

local template_AlgoPages = {
  group = "tutorial",
  closed = true,
  backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Algo/Algo1.jpg",
  x = 0,
  y = 0,
  x2 = 363,
  y2 = 215,
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
						AlgoPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Algo/Algo"..currentPage..".jpg"
						AlgoPages.son.lineArray = WordWrap(getText(), AlgoPages.son.textWidth)
					end
					setBackgroundColor (tab, "previous")
					setBackgroundColor (AlgoPages.tabData[2], "next")
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
					local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/Algo")
					if currentPage < n then
						currentPage = currentPage + 1
						AlgoPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Algo/Algo"..currentPage..".jpg"
						AlgoPages.son.lineArray = WordWrap(getText(), AlgoPages.son.textWidth)
					end
					setBackgroundColor (AlgoPages.tabData[1], "previous")
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
					AlgoPages:Close()
					MainMenu:Open()
					TutoView = MainMenu
				end
			end
		}
	}
}

local function CreateAlgoPagesCentered ()
	template_AlgoPages.OnViewResized = function ()
		local needToBeOpenAgain = AlgoPages and not AlgoPages.closed
		if needToBeOpenAgain then AlgoPages:Close() end
		AlgoPages = CreateAlgoPagesCentered()
		AlgoPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Algo/Algo"..currentPage..".jpg"
		AlgoPages.son.lineArray = WordWrap(getText(), AlgoPages.son.textWidth)
		if needToBeOpenAgain then
			TutoView = AlgoPages
			TutoView:Open()
		end
	end
	template_AlgoPages.son = Window:CreateCentered(template_AlgoPages_Text)
	local win = Window:CreateCentered(template_AlgoPages)
	local winHeight = win.y2 - win.y1
	local sonHeight = win.son.y2 - win.son.y1
	win.son.dy = win.son.dy + (winHeight+sonHeight)/2
	win.son.dy = math.floor(win.son.dy - sonHeight/2)
	win.dy = math.floor(win.dy - sonHeight/2)
	return win
end

AlgoPages = CreateAlgoPagesCentered ()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------