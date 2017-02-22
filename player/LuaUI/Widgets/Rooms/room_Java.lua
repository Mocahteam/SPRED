--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Java Window.
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
	local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/Java")
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
			return "Etape 1 : Vous devez d�finir en tout premier lieu la m�thode principale de votre programme. En langage Java cette m�thode est un membre d'une classe que nous nommons \"Tutorial\" dans notre example. Cette m�thode est caract�ris�e par les mots cl�s "..purple.."public"..white.." et "..purple.."static"..white.." pour qu'elle puisse servir de point de d�part � votre programme. A noter que nous pla�ons la classe \"Tutorial\" dans le package \"exemple\". "
		else
			return "Step 1: Define the main method of your program. With Java language, this method is a member of the class named \"Tutorial\" in this example. This method is defined by code "..purple.."public"..white.." and "..purple.."static"..white.." key words. Note: The \"Tutorial\" class is included into the \"exemple\" package. "
		end
	elseif currentPage == 2 then
		if lang == "fr" then
			return "Etape 2 : Apr�s avoir d�fini la m�thode \"main\", vous devez instancier un objet de type \"PP\" (Prog&play) de mani�re � utiliser ces fonctionnalit�s. Vous devez donc importer la classe \"PP\" du package \"pp\", d�clarer une variable et l'instancier � l'aide de l'op�rateur "..blue.."new"..white..". "
		else
			return "Step 2 : When the main method is defined, you have to instanciate a \"PP\" object in order to use its functionalities.You have to import the \"PP\" class from the \"pp\" package. Define a new variable and instanciate it with the "..blue.."new"..white.." operator. "
		end
	elseif currentPage == 3 then
		if lang == "fr" then
			return "Etape 3 : Apr�s avoir instanci� un objet de type \"PP\", vous devez initialiser la biblioth�que Prog&Play. Ceci doit �tre fait � l'aide de la m�thode \"open\". Enfin, pensez toujours � appeler, avant la fin de votre programme, la m�thode \"close\" pour fermer proprement la biblioth�que Prog&Play. "
		else
			return "Step 3 : When you have instanciate a \"PP\" object, you have to initialize the Prog&Play library. This can be done with the \"open\" method. Then, don't forget to call the \"close\" method in order to properly close the Prog&Play library. "
		end
	elseif currentPage == 4 then
		if lang == "fr" then
			return "Etape 4 : Apr�s avoir initialis� la biblioth�que Prog&Play, vous pouvez vous attacher � tenter de r�soudre le probl�me qui vous est pos�. Dans ce tutoriel, l'objectif consiste � d�placer votre unit� � une position particuli�re. Pour agir sur votre unit�, vous devez dans un premier temps la r�cup�rer dans le contexte de votre programme. Ceci peut �tre fait � l'aide de la m�thode \"getUnitAt\". Dans l'exemple ci-dessous, les param�tres indiquent que vous souhaitez r�cup�rer la premi�re unit� (indice "..orange.."0"..white..") que vous poss�dez (constante MY_COALITION). L'unit� ainsi retourn�e est stock�e dans un objet (ici nomm�e \"u\") de type Unit. Importez cette classe depuis le package \"pp\". "
		else
			return "Step 4: When you have initialized the Prog&Play library, you can try to resolve game objective. In this tutorial, objective consists in moving a unit to a target position. In order to control the unit, you have to get it into the program context. You can do it with the \"getUnitAt\" method. In example below, you get the first unit (index "..orange.."0"..white..") you control (MY_COALITION constant). The unit returned is stored into a \"Unit\" object named \"u\". Import this class from the \"pp\" package. "
		end
	elseif currentPage == 5 then
		if lang == "fr" then
			return "Etape 5 : Apr�s avoir r�cup�r� votre unit�, vous devez d�finir la position � laquelle vous souhaitez l'envoyer. Dans cette example, une position est repr�sent� par la classe Point2D. Importez donc cette classe et d�clarez un objet \"p\" de type \"Point2D.Float\" et instanciez-le avec les bonnes coordonn�es. A noter que l'origine de la carte de jeu se trouve en haut � gauche."
		else
			return "Step 5: When you have got the unit, you have to define the position where you want move it. In this example, a position is defined with the \"Point2D\" class. Import this class and define the \"p\" object as a \"Point2D.Float\" and instanciate it with appropriated coordinates. Note: the map origin is on the top left corner. "
		end
	elseif currentPage == 6 then
		if lang == "fr" then
			return "Etape 6 : Apr�s avoir d�fini la position � atteindre, vous pouvez donner l'ordre � votre unit� de s'y d�placer. Ceci peut �tre fait � l'aide de la m�thode \"command\" de la classe \"Unit\" qui prend comme param�tre l'ordre � r�aliser (\"MOVE\"), la position (\"p\") o� effectuer l'action et un bool�en indiquant si l'appel est bloquant ou pas. La constante \"MOVE\" ainsi que d'autres ordres sont d�finis dans la classe \"ConstantList_KP_4_1\". Vous devez donc importer cette classe. "
		else
			return "Step 6: When you have defined the target position, you can order your unit to move to it. Use the \"command\" method that commands the unit to carry out action (\"MOVE\") on a specified position (\"p\"). The last parameter is a boolean that defines if the call is blocking or not. The \"MOVE\" constant and others are defined into the  \"ConstantList_KP_4_1\" class. You have to include this class. "
		end
	elseif currentPage == 7 then
		if lang == "fr" then
			return "Etape 7 : Maintenant que vous avez �crit votre premier programme, il ne vous reste plus qu'� le compiler et l'ex�cuter pour observer son influence dans le jeu. N'h�sitez pas � consulter la documentation relative au package \"pp\", vous y trouverez de nombreuses informations sur les fonctionalit�s des diff�rentes classes qui vous seront utiles pour terminer la campagne � venir. "
		else
			return "Step 7: When you have written your first program, you have to compile and execute it in order to observe consequences into the game. Do not hesitate to take a look of \"pp\" package, you will find a lot of informations on Prog&Play functionalities. "
		end
	else
		return "Page not found "
	end
end

local function getTextHeight ()
	if lang == "fr" then
		return 180
	else
		return 140
	end
end

local template_JavaPages_Text = {
	group = "tutorial",
	closed = true,
	text = getText(),
	x = 0,
	y = 0,
	x2 = 606,
	y2 = getTextHeight (),
}

local template_JavaPages = {
  group = "tutorial",
  closed = true,
  backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Java/Java1.jpg",
  x = 0,
  y = 0,
  x2 = 606,
  y2 = 392,
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
						JavaPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Java/Java"..currentPage..".jpg"
						JavaPages.son.lineArray = WordWrap(getText(), JavaPages.son.textWidth)
					end
					setBackgroundColor (tab, "previous")
					setBackgroundColor (JavaPages.tabData[2], "next")
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
					local n=#VFS.DirList("LuaUI/Widgets/Rooms/Pictures/Java")
					if currentPage < n then
						currentPage = currentPage + 1
						JavaPages.backGroundTextureString = ":n:LuaUI/Widgets/Rooms/Pictures/Java/Java"..currentPage..".jpg"
						JavaPages.son.lineArray = WordWrap(getText(), JavaPages.son.textWidth)
					end
					setBackgroundColor (JavaPages.tabData[1], "previous")
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
					JavaPages:Close()
					MainMenu:Open()
					TutoView = MainMenu
				end
			end
		}
	}
}

local function CreateJavaPagesCentered ()
	template_JavaPages.son = Window:CreateCentered(template_JavaPages_Text)
	local win = Window:CreateCentered(template_JavaPages)
	local winHeight = win.y2 - win.y1
	local sonHeight = win.son.y2 - win.son.y1
	win.son.dy = win.son.dy + (winHeight+sonHeight)/2
	win.son.dy = math.floor(win.son.dy - sonHeight/2)
	win.dy = math.floor(win.dy - sonHeight/2)
	return win
end

JavaPages = CreateJavaPagesCentered ()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------