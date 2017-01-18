--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Ada Window.
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
local blue = "\255\050\050\255"

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
	local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/Ada")
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
			return "Etape 1 : Définissez la procédure principale de votre programme. En langage Ada cette procédure est définie à l'aide des mots clés "..blue.."procedure"..white..", "..blue.."is"..white..", "..blue.."begin"..white.." et "..blue.."end"..white..". N'oubliez pas le dernier \";\". "
		else
			return "Step 1: Define the main procedure of your program. With Ada language, this procedure is defined with the "..blue.."procedure"..white..", "..blue.."is"..white..", "..blue.."begin"..white.." and "..blue.."end"..white.." key words. Don't forget the last \";\". "
		end
	elseif currentPage == 2 then
		if lang == "fr" then
			return "Etape 2 : Après avoir défini la procédure principale, vous devez initialiser la bibliothèque Prog&Play. Ceci doit être fait à l'aide de la fonction \"Open\". Enfin, pensez toujours à appeler, avant la fin de votre programme, la fonction \"Close\" pour fermer proprement la bibliothèque Prog&Play. A noter que les fonctions de la bibliothèque Prog&Play sont définies dans le package \"PP\". Vous devez donc l'inclure à l'aide des mots clés "..blue.."with"..white.." et "..blue.."use"..white..". "
		else
			return "Step 2 : When the main procedure is defined, you have to initialize the Prog&Play library. This can be done with the \"Open\" function. Then, don't forget to call the \"Close\" function in order to properly close the Prog&Play library. Functions of the Prog&Play library are defined into the \"PP\" package. You have to include it with the "..blue.."with"..white.." and "..blue.."use"..white.." key words. "
		end
	elseif currentPage == 3 then
		if lang == "fr" then
			return "Etape 3 : Après avoir initialisé la bibliothèque Prog&Play, vous pouvez vous attacher à tenter de résoudre le problème qui vous est posé. Dans ce tutoriel, l'objectif consiste à déplacer votre unité à une position particulière. Pour agir sur votre unité, vous devez dans un premier temps la récupérer dans le contexte de votre programme. Ceci peut être fait à l'aide de la fonction \"GetUnitAt\". Dans l'exemple ci-dessous, les paramètres indiquent que vous souhaitez récupérer la première unité (indice "..orange.."0"..white..") que vous possédez (constante MyCoalition). L'unité ainsi retournée est stockée dans une variable (ici nommée \"u\") de type \"Unit\". "
		else
			return "Step 3: When you have initialized the Prog&Play library, you can try to resolve game objective. In this tutorial, objective consists in moving a unit to a target position. In order to control the unit, you have to get it into the program context. You can do it with the \"GetUnitAt\" function. In example below, you get the first unit (index "..orange.."0"..white..") you control (MyCoalition constant). The unit returned is stored into a \"Unit\" variable named \"u\". "
		end
	elseif currentPage == 4 then
		if lang == "fr" then
			return "Etape 4 : Après avoir récupéré votre unité, vous devez définir la position à laquelle vous souhaitez l'envoyer. Déclarez une variable \"p\" de type \"Position\" et renseignez les champs x et y de type \"Float\". A noter que l'origine de la carte de jeu se trouve en haut à gauche. "
		else
			return "Step 4: When you have got the unit, you have to define the position where you want move it. Define the \"p\" variable as a \"Position\" and set x field and y field. Note: the map origin is on the top left corner. "
		end
	elseif currentPage == 5 then
		if lang == "fr" then
			return "Etape 5 : Après avoir défini la position à atteindre, vous pouvez donner l'ordre à votre unité de s'y déplacer. Ceci peut être fait à l'aide de la fonction \"CarryOutCommand\" qui prend comme paramètre l'unité à commander (\"u\"), l'ordre à réaliser (\"Move\") et la position (\"p\") où effectuer l'action. La constante \"Move\" ainsi que d'autres ordres sont définis dans le package \"ConstantListKP41\". Vous devez donc l'inclure à l'aide des mots clés "..blue.."with"..white.." et "..blue.."use"..white..". "
		else
			return "Step 5: When you have defined the target position, you can order your unit to move to it. Use the \"CarryOutCommand\" function that commands a unit (\"u\") to carry out action (\"Move\") on a specified position (\"p\"). The \"Move\" constant and others are defined into the  \"ConstantListKP41\" package. You have to include it with the "..blue.."with"..white.." and "..blue.."use"..white.." key words. "
		end
	elseif currentPage == 6 then
		if lang == "fr" then
			return "Etape 6 : Maintenant que vous avez écrit votre premier programme, il ne vous reste plus qu'à le compiler et l'exécuter pour observer son influence dans le jeu. N'hésitez pas à consulter les packages \"PP\" et \"ConstantListKP41\", vous y trouverez de nombreuses informations sur les fonctionalités de la bibliothèque Prog&Play qui vous seront utiles pour terminer la campagne à venir. "
		else
			return "Step 6: When you have written your first program, you have to compile and execute it in order to observe consequences into the game. Do not hesitate to take a look of \"PP\" and \"ConstantListKP41\" packages, you will find a lot of informations on Prog&Play functionalities. "
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

local template_AdaPages_Text = {
	group = "tutorial",
	closed = true,
	text = getText(),
	x = 0,
	y = 0,
	x2 = 534,
	y2 = getTextHeight (),
}

local template_AdaPages = {
  group = "tutorial",
  closed = true,
  backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Ada/Ada1.jpg",
  x = 0,
  y = 0,
  x2 = 534,
  y2 = 376,
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
						AdaPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Ada/Ada"..currentPage..".jpg"
						AdaPages.son.lineArray = WordWrap(getText(), AdaPages.son.textWidth)
					end
					setBackgroundColor (tab, "previous")
					setBackgroundColor (AdaPages.tabData[2], "next")
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
					local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/Ada")
					if currentPage < n then
						currentPage = currentPage + 1
						AdaPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Ada/Ada"..currentPage..".jpg"
						AdaPages.son.lineArray = WordWrap(getText(), AdaPages.son.textWidth)
					end
					setBackgroundColor (AdaPages.tabData[1], "previous")
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
					AdaPages:Close()
					MainMenu:Open()
					TutoView = MainMenu
				end
			end
		}
	}
}

local function CreateAdaPagesCentered ()
	template_AdaPages.son = Window:CreateCentered(template_AdaPages_Text)
	local win = Window:CreateCentered(template_AdaPages)
	local winHeight = win.y2 - win.y1
	local sonHeight = win.son.y2 - win.son.y1
	win.son.dy = win.son.dy + (winHeight+sonHeight)/2
	win.son.dy = math.floor(win.son.dy - sonHeight/2)
	win.dy = math.floor(win.dy - sonHeight/2)
	return win
end

AdaPages = CreateAdaPagesCentered ()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------