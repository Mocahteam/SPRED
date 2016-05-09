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
	local window = Chili.Window:New{
		parent = Screen0,
		x = "0%",
		y = "0%",
		width = "100%",
		height = "100%"
	}
	Chili.Label:New{
		parent = window,
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
		parent = window,
		x = "20%",
		y = "20%",
		width = "60%",
		height = "60%"
	}
	local gameList = VFS.GetGames()
	for i, game in ipairs(gameList) do
		if not string.match(game, "Prog & Play") then
			Chili.Button:New{
				parent = sp,
				x = '0%',
				y = (i - 1) * 80,
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
		end
	end
end

function Launch(game)
	--if not VFS.FileExists("games/"..game.." (Prog&Play Level Editor).sdz") then
		local modInfo = "return { game='PPLE', shortGame='PPLE', name='Prog & Play Level Editor', shortName='PPLE', mutator='official', version='0.1', description='A level editor for Prog & Play.', url='http://www.irit.fr/ProgAndPlay/index_en.php', modtype=0, depend= { \""..game.."\" },}"
		local file = io.open("games/editor/ModInfo.lua", "w")
		file:write(modInfo)
		file:close()
		VFS.CompressFolder("games/editor")
		os.rename("games/editor.sdz", "games/Prog & Play Level Editor.sdz")
	--end
	local operations = {
		["GAME"] = {
			["Gametype"] = "Prog & Play Level Editor 0.1"
		}
	}
	DoTheRestart("Editor.txt", operations)
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