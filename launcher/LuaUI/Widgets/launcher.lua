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
VFS.Include("LuaUI/Widgets/libs/Locale.lua")

local Chili, Screen0
local UI = {} -- Contains each UI element
local gameFolder = "games"
-- Screen width in pixels
local vsx = 0
-- Screen height in pixels
local vsy = 0
-- Selected language
local language = "en"

if Game.version == "0.82.5.1" then gameFolder = "mods" end

function ChangeLanguage(lang) -- Load strings corresponding to lang and update captions/texts
	if UI.Warning then
		UI.Warning:Dispose()
	end

	GetLauncherStrings(lang)
	UI.Title:SetCaption (LAUNCHER_TITLE)
	UI.Help:SetText (LAUNCHER_HELP)
	UI.QuitButton:SetCaption (LAUNCHER_QUIT)
	language = lang
end

function InitializeChili()
	if not WG.Chili then
		widgetHandler:RemoveWidget()
		return
	end
	Chili = WG.Chili
	Screen0 = Chili.Screen0
end

function InitializeMenu()
	UI.MainWindow = Chili.Window:New{
		parent = Screen0,
		x = "0%",
		y = "0%",
		width = "100%",
		height = "100%",
		resizable = false,
		draggable = false
	}
	UI.LanguageComboBox = Chili.ComboBox:New{
		parent = UI.MainWindow,
		x = "85%",
		y = "0%",
		width = "15%",
		height = "7%",
		items = { "English", "Français" },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 20,
		  autoAdjust = true,
		  maxSize = 20,
			color = { 0.2, 1, 0.8, 1 }
		}
	}
	UI.LanguageComboBox.OnSelect = { -- Change language to the newly selected language
		function()
			if UI.LanguageComboBox.selected == 1 then
				ChangeLanguage("en")
			elseif UI.LanguageComboBox.selected == 2 then
				ChangeLanguage("fr")
			end
		end
	}
	UI.Title = Chili.Label:New{
		parent = UI.MainWindow,
		x = "0%",
		y = "5%",
		width = "100%",
		height = "10%",
		caption = LAUNCHER_TITLE,
		align = "center",
		valign = "linecenter",
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
		  autoAdjust = true,
		  maxSize = 40,
			color = { 0.2, 0.6, 0.8, 1 }
		}
	}
	UI.Help = Chili.TextBox:New{
		parent = UI.MainWindow,
		x = "10%",
		y = "15%",
		width = "80%",
		height = "15%",
		text = LAUNCHER_HELP,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 18,
		  autoAdjust = true,
		  maxSize = 18,
			color = { 0.6, 0.6, 0.8, 1 }
		}
	}
	local sp = Chili.ScrollPanel:New{
		parent = UI.MainWindow,
		x = "20%",
		y = "30%",
		width = "60%",
		height = "50%",
	}
	local gameList = {}
	gameList = VFS.GetGames()
	local cpt = 0
	for i, game in ipairs(gameList) do
		local infos = VFS.GetArchiveInfo(game)
		if not string.find(infos.description, "SPRED module") then
			Chili.Button:New{
				parent = sp,
				x = '0%',
				y = (cpt*15).."%",
				width = '100%',
				height = "15%",
				caption = game,
				OnClick = { function() Launch(game) end },
				font = {
					font = "LuaUI/Fonts/Asimov.otf",
					size = 30,
					autoAdjust = true,
					maxSize = 30,
					color = { 0, 0.2, 0.8, 1 }
				}
			}
			cpt = cpt + 1
		end
	end
	UI.QuitButton = Chili.Button:New{
		parent = UI.MainWindow,
		x = "90%",
		y = "90%",
		width = "10%",
		height = "10%",
		caption = LAUNCHER_QUIT,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 30,
		  autoAdjust = true,
		  maxSize = 30,
			color = { 0.8, 0.6, 0.2, 1 }
		},
		backgroundColor = { 0.8, 0, 0.2, 1 },
		focusColor= { 0.8, 0.6, 0.2, 1 },
		OnClick = { Quit }
	}
end

--- Shows a warning message
-- @tparam msg message to display as warning
function FrameWarning(msg)
	UI.Warning = Chili.Window:New{
		parent = UI.MainWindow,
		x = '15%',
		y = '45%',
		width = '70%',
		height = '20%',
		draggable = false,
		resizable = false
	}
	Chili.Label:New{
		parent = UI.Warning,
		x = '2%',
		y = '0%',
		width = '96%',
		height = '60%',
		align = "center",
		valign = "linecenter",
		caption = msg,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 25,
			autoAdjust = true,
			maxSize = 25,
			-- avoid transparent artifact on windows superposition
			outlineWidth = 0,
			outlineWeight = 0,
			outline = true
		}
	}
	Chili.Button:New{
		parent = UI.Warning,
		x = '33%',
		y = '50%',
		width = '33%',
		height = '40%',
		caption = "OK",
		OnClick = { function () UI.Warning:Dispose() end },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 25,
			autoAdjust = true,
			maxSize = 25,
			-- avoid transparent artifact on windows superposition
			outlineWidth = 0,
			outlineWeight = 0,
			outline = true
		}
	}
	Chili.Image:New{
		parent = UI.Warning,
		x = '0%',
		y = '0%',
		width = '100%',
		height = '100%',
		keepAspect = false,
		file = "bitmaps/launcher/blank.png",
		color = { 0, 0, 0, 1 }
	}
end

function Launch(game)
	if not VFS.FileExists(gameFolder.."/SPRED for "..game..".sdz") then
		if Game.isPPEnabled then
			if VFS.BuildPPEditor and not VFS.FileExists(gameFolder.."/SPRED for "..game..".sdz") then
			 	VFS.BuildPPEditor(game)
			else
				FrameWarning(LAUNCHER_ERROR)
			end
		else
			local modInfo = "return { game='SPRED for "..game.."', shortGame='SPRED for "..game.."', name='SPRED for "..game.."', shortName='SPRED for "..game.."', mutator='official', version='1.0', description='SPRED module. SPRED for "..game.."', url='http://www.irit.fr/ProgAndPlay/index_en.php', modtype=0, depend= { \""..game.."\" },}"
			local file = io.open("SPRED/editor/ModInfo.lua", "w")
			file:write(modInfo)
			file:close()
			-- Compress Archive
			VFS.CompressFolder("SPRED/editor")
			os.rename("SPRED/editor.sdz", "games/SPRED for "..game..".sdz")
		end
	end

	if VFS.FileExists(gameFolder.."/SPRED for "..game..".sdz") then
		local operations = {
			["MODOPTIONS"] = {
				["maingame"] = game,
				["language"] = language
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
	if (dse_vsx ~= vsx or dse_vsy ~= vsy) then
		vsx, vsy = dse_vsx, dse_vsy
	end
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
	ChangeLanguage("en")
end
