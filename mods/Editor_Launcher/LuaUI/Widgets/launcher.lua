function widget:GetInfo()
	return {
		name = "Launcher for Prog&Play Level Editor",
		desc = "Launcher for Prog&Play Level Editor",
		author = "zigaroula",
		version = "1.0",
		date = "May 03, 2016",
		license = "Public Domain",
		layer = 250,
		enabled = true,
		handler = true
	}
end

VFS.Include("LuaUI/Widgets/libs/RestartScript.lua")

local Chili, Screen0

function InitializeChili() 
	if not WG.Chili then
		widgetHandler:RemoveWidget()
		return
	end
	Chili = WG.Chili
	Screen0 = Chili.Screen0
end

function InitializeMenu()
	local MainWindow = Chili.Window:New{
		parent = Screen0,
		x = "0%",
		y = "0%",
		width = "100%",
		height = "100%"
	}
	Chili.Label:New{
		parent = MainWindow,
		x = "0%",
		y = "10%",
		width = "100%",
		height = "10%",
		caption = "Choose a game",
		align = "center",
		valign = "center",
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 60,
			color = { 0.2, 0.6, 0.8, 1 }
		}
	}
	local sp = Chili.ScrollPanel:New{
		parent = MainWindow,
		x = "20%",
		y = "20%",
		width = "60%",
		height = "60%"
	}
	local gameList = {}
	if Game.version == "0.82.5.1" then
		gameList = VFS.DirList("mods/", "*.sd*", VFS.RAW)
		for i, g in ipairs(gameList) do
			g = string.gsub(g, "mods\\", "")
			g = string.gsub(g, "%.sd.*", "")
			gameList[i] = g
		end
	else
		gameList = VFS.GetGames()
	end
	local count = 0
	for i, game in ipairs(gameList) do
		if not string.match(game, "Prog & Play") then
			Chili.Button:New{
				parent = sp,
				x = '0%',
				y = count * 80,
				width = '100%',
				height = 80,
				caption = game,
				OnClick = { function() Launch(game) end },
				font = {
					font = "LuaUI/Fonts/Asimov.otf",
					size = 40,
					color = { 0, 0.2, 0.8, 1 }
				}
			}
			count = count + 1
		end
	end
	ErrorMessage1 = Chili.Label:New{
		parent = MainWindow,
		x = "0%",
		y = "85%",
		width = "100%",
		height = "5%",
		caption = "",
		align = "center",
		valign = "center",
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 30,
			color = { 1, 0.2, 0.2, 1 }
		}
	}
	ErrorMessage2 = Chili.Label:New{
		parent = MainWindow,
		x = "0%",
		y = "90%",
		width = "100%",
		height = "5%",
		caption = "",
		align = "center",
		valign = "center",
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 25,
			color = { 1, 0.6, 0.2, 1 }
		}
	}
	Chili.Button:New{
		parent = MainWindow,
		x = "90%",
		y = "90%",
		width = "10%",
		height = "10%",
		caption = "Quit",
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 0.8, 0.6, 0.2, 1 }
		},
		backgroundColor = { 0.8, 0, 0.2, 1 },
		focusColor= { 0.8, 0.6, 0.2, 1 },
		OnClick = { Quit }
	}
end

function Launch(game)
	if not VFS.FileExists("games/Prog & Play Level Editor for "..game..".sdz") then
		if Game.version == "0.82.5.1" then
			if VFS.BuildPPEditor and not VFS.FileExists("mods/Prog & Play Level Editor for "..game..".sdz") then
				VFS.BuildPPEditor(game)
			else
				ErrorMessage1:SetCaption("The editor does not work on the version of Spring you are using.")
				ErrorMessage2:SetCaption("Please use the tweaked 0.82.5.1 or a 98+ version.")
			end
		else
			local modInfo = "return { game='PPLE', shortGame='PPLE', name='Prog & Play Level Editor for "..game.."', shortName='PPLE', mutator='official', version='1.0', description='A level editor for Prog & Play.', url='http://www.irit.fr/ProgAndPlay/index_en.php', modtype=0, depend= { \""..game.."\" },}"
			local file = io.open("pp_editor/editor_files/ModInfo.lua", "w")
			file:write(modInfo)
			file:close()
			-- Move game files
			os.rename("pp_editor/game_files/MissionPlayer_Editor.lua", "pp_editor/editor_files/MissionPlayer_Editor.lua")
			os.rename("pp_editor/game_files/editorTxtGenerator.lua", "pp_editor/editor_files/editorTxtGenerator.lua")
			os.rename("pp_editor/game_files/LuaRules/Gadgets/mission_runner.lua", "pp_editor/editor_files/LuaRules/Gadgets/mission_runner.lua")
			os.rename("pp_editor/game_files/LuaUI/Widgets/pp_cameraAuto.lua", "pp_editor/editor_files/LuaUI/Widgets/pp_cameraAuto.lua")
			os.rename("pp_editor/game_files/LuaUI/Widgets/pp_display_message.lua", "pp_editor/editor_files/LuaUI/Widgets/pp_display_message.lua")
			os.rename("pp_editor/game_files/LuaUI/Widgets/pp_gui_rooms.lua", "pp_editor/editor_files/LuaUI/Widgets/pp_gui_rooms.lua")
			os.rename("pp_editor/game_files/LuaUI/Widgets/pp_mission_gui.lua", "pp_editor/editor_files/LuaUI/Widgets/pp_mission_gui.lua")
			os.rename("pp_editor/game_files/LuaUI/Widgets/pp_mission_messenger.lua", "pp_editor/editor_files/LuaUI/Widgets/pp_mission_messenger.lua")
			-- Compress Archive
			if not VFS.FileExists("pp_editor/editor_files.sdz") then
				VFS.CompressFolder("pp_editor/editor_files")
				os.rename("pp_editor/editor_files.sdz", "games/Prog & Play Level Editor for "..game..".sdz")
			end
			-- Move game files
			os.rename("pp_editor/editor_files/MissionPlayer_Editor.lua", "pp_editor/game_files/MissionPlayer_Editor.lua")
			os.rename("pp_editor/editor_files/editorTxtGenerator.lua", "pp_editor/game_files/editorTxtGenerator.lua")
			os.rename("pp_editor/editor_files/LuaRules/Gadgets/mission_runner.lua", "pp_editor/game_files/LuaRules/Gadgets/mission_runner.lua")
			os.rename("pp_editor/editor_files/LuaUI/Widgets/pp_cameraAuto.lua", "pp_editor/game_files/LuaUI/Widgets/pp_cameraAuto.lua")
			os.rename("pp_editor/editor_files/LuaUI/Widgets/pp_display_message.lua", "pp_editor/game_files/LuaUI/Widgets/pp_display_message.lua")
			os.rename("pp_editor/editor_files/LuaUI/Widgets/pp_gui_rooms.lua", "pp_editor/game_files/LuaUI/Widgets/pp_gui_rooms.lua")
			os.rename("pp_editor/editor_files/LuaUI/Widgets/pp_mission_gui.lua", "pp_editor/game_files/LuaUI/Widgets/pp_mission_gui.lua")
			os.rename("pp_editor/editor_files/LuaUI/Widgets/pp_mission_messenger.lua", "pp_editor/game_files/LuaUI/Widgets/pp_mission_messenger.lua")
		end
	end
	
	if VFS.FileExists("games/Prog & Play Level Editor for "..game..".sdz") or (VFS.FileExists("mods/Prog & Play Level Editor for "..game..".sdz") and Game.version == "0.82.5.1") then
		local operations = {
			["MODOPTIONS"] = {
				["maingame"] = game
			},
			["GAME"] = {
				["Gametype"] = "Prog & Play Level Editor for "..game.." 1.0"
			}
		}
		DoTheRestart("Editor.txt", operations)
	end
end

function Quit() -- Close spring
	Spring.SendCommands("quit")
	Spring.SendCommands("quitforce")
end

function EitherDrawScreen()
	if not vsx or not vsy then
		return
	end
	
	local bgText = "bitmaps/editor/blank.png"
	gl.Blending(false)
	gl.Color(0, 0, 0, 0)
	gl.Texture(bgText)
	gl.TexRect(vsx, vsy, 0, 0, 0, 0, 1, 1)
	gl.Texture(false)
	gl.Blending(true)
end

function widget:DrawScreenEffects(dse_vsx, dse_vsy)
	vsx, vsy = dse_vsx, dse_vsy
	if Spring.IsGUIHidden() then
		EitherDrawScreen()
	end
end

function widget:DrawScreen()
	if not Spring.IsGUIHidden() then
		EitherDrawScreen()
	end
end

function widget:Initialize()
	InitializeChili()
	InitializeMenu()
end