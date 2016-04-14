--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Scratch Window.
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
	local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/Scratch")
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
			return "Etape 1 : Vous devez placer en tout premier les briques de contrôle qui vous permettront de gérer l'exécution de votre programme. "
		else
			return "Step 1: You have to drag and drop control blocks in order to manage your program execution."
		end
	elseif currentPage == 2 then
		if lang == "fr" then
			return "Etape 2 : Après avoir positionné les briques de contrôle, vous devez initialiser la bibliothèque Prog&Play. Ceci doit être fait à l'aide de la brique \"open Prog&Play\". Enfin, pensez toujours à utiliser, avant la fin de votre programme, la brique \"close Prog&Play\" pour fermer proprement la bibliothèque Prog&Play. "
		else
			return "Step 2 : When you have drag and drop first blocks, you have to initialize the Prog&Play library. This can be done with the \"open Prog&Play\" block. Then, don't forget to use the \"close Prog&Play\" block in order to properly close the Prog&Play library. "
		end
	elseif currentPage == 3 then
		if lang == "fr" then
			return "Etape 3 : Après avoir initialisé la bibliothèque Prog&Play, vous pouvez vous attacher à tenter de résoudre le problème qui vous est posé. Dans ce tutoriel, l'objectif consiste à déplacer votre unité à une position particulière. Pour agir sur votre unité, vous devez dans un premier temps la récupérer dans le contexte de votre programme. Ceci peut être fait à l'aide de la brique \"unit [num] of [constant] coalition\". Dans l'exemple ci-dessous, les paramètres indiquent que vous souhaitez récupérer la première unité (indice 0) que vous possédez (constante MY). L'unité ainsi retournée est stockée dans une variable (ici nommée \"u\"). "
		else
			return "Step 3: When you have initialized the Prog&Play library, you can try to resolve game objective. In this tutorial, objective consists in moving a unit to a target position. In order to control the unit, you have to get it into the program context. You can do it with the \"unit [num] of [constant] coalition\" block. In example below, you get the first unit (index "..orange.."0"..white..") you control (MY constant). The unit returned is stored into a variable named \"u\". "
		end
	elseif currentPage == 4 then
		if lang == "fr" then
			return "Etape 4 : Après avoir récupéré votre unité, vous pouvez lui donner l'ordre de se déplacer. Ceci peut être fait à l'aide de la brique \"command unit id [num] to [action] to x: [int] y: [int]\" qui prend comme paramètre l'unité à commander (\"u\"), l'ordre à réaliser (\"MOVE\") et la position où effectuer l'action sous la forme de coordonnées x et y. A noter que l'origine de la carte de jeu se trouve en haut à gauche. "
		else
			return "Step 4: When you have got the unit, you can order it to move to a position. You can do it with the \"command unit id [num] to [action] to x: [int] y: [int]\" block that takes as parameter the unit to command (\"u\"), the order (\"MOVE\") and the position where to carry out action. Note: the map origin is on the top left corner. "
		end
	elseif currentPage == 5 then
		if lang == "fr" then
			return "Etape 5 : Maintenant que vous avez écrit votre premier programme, il ne vous reste plus qu'à l'exécuter pour observer son influence dans le jeu. "
		else
			return "Step 5: When you have written your first program, you have to execute it in order to observe consequences into the game. "
		end
	else
		return "Page not found "
	end
end

local function getTextHeight ()
	if lang == "fr" then
		return 200
	else
		return 140
	end
end

local template_ScratchPages_Text = {
	group = "tutorial",
	closed = true,
	text = getText(),
	x = 0,
	y = 0,
	x2 = 533,
	y2 = getTextHeight (),
}

local template_ScratchPages = {
  group = "tutorial",
  closed = true,
  backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Scratch/Scratch1.jpg",
  x = 0,
  y = 0,
  x2 = 334,
  y2 = 155,
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
						ScratchPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Scratch/Scratch"..currentPage..".jpg"
						ScratchPages.son.lineArray = WordWrap(getText(), ScratchPages.son.textWidth)
					end
					setBackgroundColor (tab, "previous")
					setBackgroundColor (ScratchPages.tabData[2], "next")
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
					local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/Scratch")
					if currentPage < n then
						currentPage = currentPage + 1
						ScratchPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Scratch/Scratch"..currentPage..".jpg"
						ScratchPages.son.lineArray = WordWrap(getText(), ScratchPages.son.textWidth)
					end
					setBackgroundColor (ScratchPages.tabData[1], "previous")
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
					ScratchPages:Close()
					MainMenu:Open()
					TutoView = MainMenu
				end
			end
		}
	}
}

local function CreateScratchPagesCentered ()
	template_ScratchPages.son = Window:CreateCentered(template_ScratchPages_Text)
	local win = Window:CreateCentered(template_ScratchPages)
	local winHeight = win.y2 - win.y1
	local sonHeight = win.son.y2 - win.son.y1
	win.son.dy = win.son.dy + (winHeight+sonHeight)/2
	win.son.dy = math.floor(win.son.dy - sonHeight/2)
	win.dy = math.floor(win.dy - sonHeight/2)
	return win
end

ScratchPages = CreateScratchPagesCentered ()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------