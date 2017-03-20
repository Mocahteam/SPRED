--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Tutorial Window.
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--local rooms = WG.rooms -- availabe in all widgets

lang = Spring.GetModOptions()["language"] -- get the language
local gray = "\255\100\100\100"
local white = "\255\255\255\255"

local template_MainMenu = {
	closed = true,
	noMove = false,
	group = "tutorial",
	x = 0,
	y = 0,
	--noAnimation = true,
	tabs = {
		{preset = function(tab)
				tab.title = "ADA"
				tab.position = "bottom"
				tab.OnMouseReleaseAction = function()
					tab.parent:Close()
					AdaPages:Open()
					TutoView = AdaPages
				end
			end
		},
		{preset = function(tab)
				tab.title = "ALGO"
				tab.position = "bottom"
				tab.OnMouseReleaseAction = function()
					tab.parent:Close()
					AlgoPages:Open()
					TutoView = AlgoPages
				end
			end
		},
		{preset = function(tab)
				tab.title = "C"
				tab.position = "bottom"
				tab.OnMouseReleaseAction = function()
					tab.parent:Close()
					CPages:Open()
					TutoView = CPages
				end
			end
		},
		{preset = function(tab)
				tab.title = "Compalgo"
				tab.position = "bottom"
				tab.OnMouseReleaseAction = function()
					tab.parent:Close()
					CompalgoPages:Open()
					TutoView = CompalgoPages
				end
			end
		},
		{preset = function(tab)
				tab.title = "Java"
				tab.position = "bottom"
				tab.OnMouseReleaseAction = function()
					tab.parent:Close()
					JavaPages:Open()
					TutoView = JavaPages
				end
			end
		},
		{preset = function(tab)
				tab.title = "OCaml"
				tab.position = "bottom"
				tab.OnMouseReleaseAction = function()
					tab.parent:Close()
					OCamlPages:Open()
					TutoView = OCamlPages
				end
			end
		},
		{preset = function(tab)
				tab.title = "Python"
				tab.position = "bottom"
				tab.OnMouseReleaseAction = function()
					tab.parent:Close()
					PythonPages:Open()
					TutoView = PythonPages
				end
			end
		},
		{preset = function(tab)
				tab.title = "Scratch"
				tab.position = "bottom"
				tab.OnMouseReleaseAction = function()
					tab.parent:Close()
					ScratchPages:Open()
					TutoView = ScratchPages
				end
			end
		}
	}
}

local function CreateMainMenuCentered ()
	if lang == "fr" then
		template_MainMenu.lineArray = {
			"Didacticiel", "",
			"Objectif du didacticiel :",
			"   Vous familiariser avec l'utilisation de l'API Prog&Play", "",
			"Objectif de la situation de jeu :",
			"   Déplacez votre unité (un BIT) au point de ralliement (1250, 1048)", "", "",
			"Sélectionner le langage de programmation que vous souhaitez utiliser", "", "",
			gray.."Vous pouvez déplacer cette fenêtre"..white
		}
	else
		template_MainMenu.lineArray = {
			"Tutorial", "",
			"Tutorial objective:",
			"   Familiarize yourself with the Prog&Play API", "",
			"Game situation objective:",
			"   Move your unit (a BIT) to the rallying point (1250, 1048)", "", "",
			"Select the programming language that you want use", "", "",
			gray.."You can move this window"..white
		}
	end
	template_MainMenu.OnViewResized = function ()
		local needToBeOpenAgain = MainMenu and not MainMenu.closed
		if needToBeOpenAgain then MainMenu:Close() end
		MainMenu = CreateMainMenuCentered()
		if needToBeOpenAgain then
			TutoView = MainMenu
			TutoView:Open()
		end
	end
	
	return Window:CreateCentered(template_MainMenu)
end

MainMenu = CreateMainMenuCentered()

-- This is the main variable accessible from pp_gui_main_menu.lua. It indicate wich
-- tutorial window is set
TutoView = MainMenu
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------