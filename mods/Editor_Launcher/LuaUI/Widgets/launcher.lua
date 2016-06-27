function widget:GetInfo()
	return {
		name = "SPRED Launcher",
		desc = "Launcher for SPRED",
		author = "mocahteam",
		version = "1.0",
		date = "June 24, 2016",
		license = "Public Domain",
		layer = 250,
		enabled = true,
		handler = true
	}
end

VFS.Include("LuaUI/Widgets/libs/RestartScript.lua")

local Chili, Screen0
local gameFolder = "games"
if Game.version == "0.82.5.1" then gameFolder = "mods" end

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
		height = "100%",
		resizable = false,
		draggable = false
	}
	Chili.Label:New{
		parent = MainWindow,
		x = "0%",
		y = "5%",
		width = "100%",
		height = "10%",
		caption = "Choose the master game",
		align = "center",
		valign = "center",
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 60,
			color = { 0.2, 0.6, 0.8, 1 }
		}
	}
	Chili.TextBox:New{
		parent = MainWindow,
		x = "10%",
		y = "15%",
		width = "80%",
		height = "10%",
		text = "This game will be the base of the editor : it will define units and their behaviour, and will be required to play the created missions. Once a game has been chosen, a new archive corresponding to the editor for the chosen mod will be created. Spring will restart using this new archive. Afterwards, you will be able to launch the editor using the archive directly from the launcher.",
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 23,
			color = { 0.6, 0.6, 0.8, 1 }
		}
	}
	local sp = Chili.ScrollPanel:New{
		parent = MainWindow,
		x = "20%",
		y = "25%",
		width = "60%",
		height = "50%"
	}
	local gameList = {}
	gameList = VFS.GetGames()
	local count = 0
	for i, game in ipairs(gameList) do
		local infos = VFS.GetArchiveInfo(game)
		if infos.shortname ~= "SPRED" then
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
		y = "90%",
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
		y = "95%",
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
	if not VFS.FileExists(gameFolder.."/SPRED for "..game..".sdz") then
		if Game.isPPEnabled then
			if VFS.BuildPPEditor and not VFS.FileExists(gameFolder.."/SPRED for "..game..".sdz") then
				VFS.BuildPPEditor(game)
			else
				ErrorMessage1:SetCaption("The editor does not work on the version of Spring you are using.")
				ErrorMessage2:SetCaption("Please use the tweaked 0.82.5.1 or a 98+ version.")
			end
		else
			local modInfo = "return { game='SPRED', shortGame='SPRED', name='SPRED for "..game.."', shortName='SPRED', mutator='official', version='1.0', description='SPRED', url='http://www.irit.fr/ProgAndPlay/index_en.php', modtype=0, depend= { \""..game.."\" },}"
			local file = io.open("SPRED/editor_files/ModInfo.lua", "w")
			file:write(modInfo)
			file:close()
			-- Compress Archive
			if not VFS.FileExists("SPRED/editor_files.sdz") then
				VFS.CompressFolder("SPRED/editor_files")
				os.rename("SPRED/editor_files.sdz", "games/SPRED for "..game..".sdz")
			end
		end
	end
	
	if VFS.FileExists(gameFolder.."/SPRED for "..game..".sdz") then
		local operations = {
			["MODOPTIONS"] = {
				["maingame"] = game
			},
			["GAME"] = {
				["Gametype"] = "SPRED for "..game.." 1.0"
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
	widgetHandler:EnableWidget("Chili Framework")
	InitializeChili()
	InitializeMenu()
end