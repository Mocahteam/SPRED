--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- OCaml Window.
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
	local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/OCaml")
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
			return "Etape 1 : Vous devez initialiser la bibliothèque Prog&Play. Ceci doit être fait à l'aide de la fonction \"openConnexion\" du module \"Pp\" (vous devez avoir chargé au préalable le fichier \"pp.cma\" contenant ce module). Pensez toujours à appeler, avant la fin de votre programme, la fonction \"closeConnexion\" pour fermer proprement la bibliothèque Prog&Play."
		else
			return "Step 1: You have to initialize the Prog&Play library. This can be done with the \"openConnexion\" function from the \"Pp\" module (first you have to load the \"pp.cma\" file). Don't forget to call the \"closeConnexion\" function in order to properly close the Prog&Play library."
		end
	elseif currentPage == 2 then
		if lang == "fr" then
			return "Etape 2 : Pour déplacer une unité, il vous suffit d'appeler la fonction \"actionOnPosition\". Cette fonction prend trois paramètres, l'unité à commander, l'ordre à réaliser et la position où effectuer l'action. "
		else
			return "Step 2: In order to move a unit, simply call the \"actionOnPosition\" function. This function takes three parameters: the unit to command, the order to carry out and the position where to process the action. "
		end
	elseif currentPage == 3 then
		if lang == "fr" then
			return "Etape 3 : Pour obtenir le premier paramètre vous pouvez exploiter la liste d'unités retournée par la fonction \"getEntities\". Dans notre example, le paramètre (MyCoalition) de cette fonction indique que vous souhaitez obtenir la liste des unités en votre possession dans le jeu. "
		else
			return "Step 3: In order to get the first parameter you can use the unit list returned by the \"getEntities\" function. In this exemple, sets \"MyCoalition\" to get your units. "
		end
	elseif currentPage == 4 then
		if lang == "fr" then
			return "Etape 4 : Pour extraire votre unité de la liste, vous pouvez utiliser la fonction \"hd\" du module \"List\" qui permet de renvoyer le premier élément d'une liste. De cette manière votre fonction \"actionOnPosition\" recevra comme premier paramètre la première unité en votre possession. "
		else
			return "Step 4: In order to extract your unit from the list, use the \"hd\" function from the \"list\" module. This function returns the first element of the given list. Then the \"actionOnPosition\" function will get the first unit you control in parameter."
		end
	elseif currentPage == 5 then
		if lang == "fr" then
			return "Etape 5 : Le deuxième paramètre est l'action à réaliser. Cette constante, ainsi que de nombreuses autres sont définies dans le fichier \"constantlistKP41.ml\". Pensez à le charger à l'aide de l'instruction \"#use\". "
		else
			return "Step 5: The second parameter is the action to carry out. This constant and others are defined into the \"constantlistKP41.ml\" file. Remember to load the file with the \"use\" instruction. "
		end
	elseif currentPage == 6 then
		if lang == "fr" then
			return "Etape 6 : Le troixième paramètre exprime une position représentée sous la forme d'un couple de réels. A noter que l'origine de la carte de jeu se trouve en haut à gauche. "
		else
			return "Step 6: The third parameter is the position where to carry out action. A position is a pair of float value. Note: the map origin is on the top left corner. "
		end
	elseif currentPage == 7 then
		if lang == "fr" then
			return "Etape 7 : Le dernier paramètre exprime sous la forme d'un booléen si l'appel est bloquant ou non. "
		else
			return "Step 7: The last parameter defines as a boolean if the call is blocking or not. "
		end
	elseif currentPage == 8 then
		if lang == "fr" then
			return "Etape 8 : Maintenant que vous avez écrit votre premier fonction, il ne vous reste plus qu'à l'exécuter pour observer son influence dans le jeu. N'hésitez pas à consulter les fichiers relatifs aux différents modules, vous y trouverez de nombreuses informations sur les fonctionalités de la bibliothèque Prog&Play qui vous seront utiles pour terminer la campagne à venir. "
		else
			return "Step 8: When you have written your first function, you have to execute it in order to observe consequences into the game. Do not hesitate to take a look of module files, you will find a lot of informations on Prog&Play functionalities. "
		end
	else
		return "Page not found "
	end
end

local function getTextHeight ()
	if lang == "fr" then
		return 140
	else
		return 100
	end
end

local template_OCamlPages_Text = {
	group = "tutorial",
	closed = true,
	text = getText(),
	x = 0,
	y = 0,
	x2 = 450,
	y2 = getTextHeight (),
}

local template_OCamlPages = {
  group = "tutorial",
  closed = true,
  backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/OCaml/OCaml1.jpg",
  x = 0,
  y = 0,
  x2 = 450,
  y2 = 254,
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
						OCamlPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/OCaml/OCaml"..currentPage..".jpg"
						OCamlPages.son.lineArray = WordWrap(getText(), OCamlPages.son.textWidth)
					end
					setBackgroundColor (tab, "previous")
					setBackgroundColor (OCamlPages.tabData[2], "next")
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
					local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/OCaml")
					if currentPage < n then
						currentPage = currentPage + 1
						OCamlPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/OCaml/OCaml"..currentPage..".jpg"
						OCamlPages.son.lineArray = WordWrap(getText(), OCamlPages.son.textWidth)
					end
					setBackgroundColor (OCamlPages.tabData[1], "previous")
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
					OCamlPages:Close()
					MainMenu:Open()
					TutoView = MainMenu
				end
			end
		}
	}
}

local function CreateOCamlPagesCentered ()
	template_OCamlPages.son = Window:CreateCentered(template_OCamlPages_Text)
	local win = Window:CreateCentered(template_OCamlPages)
	local winHeight = win.y2 - win.y1
	local sonHeight = win.son.y2 - win.son.y1
	win.son.dy = win.son.dy + (winHeight+sonHeight)/2
	win.son.dy = math.floor(win.son.dy - sonHeight/2)
	win.dy = math.floor(win.dy - sonHeight/2)
	return win
end

OCamlPages = CreateOCamlPagesCentered ()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------