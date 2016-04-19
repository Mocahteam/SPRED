function widget:GetInfo()
	return {
		name = "Spring Direct Launch 2 for Prog&Play Level Editor",
		desc = "Show some P&P menu when Spring.exe is run directly.",
		author = "zigaroula",
		version = "0.1",
		date = "Apr 14, 2016",
		license = "Public Domain",
		layer = 250,
		enabled = true,
		handler = true
	}
end

VFS.Include("LuaUI/Widgets/libs/RestartScript.lua")
VFS.Include("LuaUI/Widgets/editor/LauncherStrings.lua")

local json = VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local Chili, Screen0
local IsActive = false
local HideView = false
local Language = "en"
local vsx, vsy
local UI = {}
local MapList = {}
local LevelList = {}
local LevelListNames = {}
local OutputStates = {}
local Links = {}
local selectedInput
local selectedOutputMission
local selectedOutput

function InitializeChili() 
	if not WG.Chili then
		widgetHandler:RemoveWidget()
		return
	end
	Chili = WG.Chili
	Screen0 = Chili.Screen0
end

function InitializeEditor()
	widgetHandler:EnableWidget("Chili Framework")
	widgetHandler:EnableWidget("Hide commands")
	widgetHandler:EnableWidget("Editor Widget List")
	widgetHandler:EnableWidget("Editor User Interface")
end

function InitializeLauncher()
	InitializeMainMenu()
	InitializeMapButtons()
	InitializeLevelButtons()
	InitializeScenarioFrame()
end

function InitializeMainMenu()
	UI.MainWindow = Chili.Window:New{
		parent = Screen0,
		x = "0%",
		y = "0%",
		width  = "100%",
		height = "100%",
		draggable = false,
		resizable = false
	}
	UI.Title = Chili.Label:New{
		parent = UI.MainWindow,
		x = '0%',
		y = '0%',
		width = '100%',
		height = '10%',
		align = "center",
		valign = "center",
		caption = LAUNCHER_TITLE,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 60,
			color = { 0.2, 0.6, 0.8, 1 }
		}
	}
	UI.NewMissionButton = Chili.Button:New{
		parent = UI.MainWindow,
		x = "30%",
		y = "30%",
		width = "40%",
		height = "10%",
		caption = LAUNCHER_NEW_MISSION,
		OnClick = { NewMissionFrame },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 0.2, 1, 0.8, 1 }
		}
	}
	UI.EditMissionButton = Chili.Button:New{
		parent = UI.MainWindow,
		x = "30%",
		y = "40%",
		width = "40%",
		height = "10%",
		caption = LAUNCHER_EDIT_MISSION,
		OnClick = { EditMissionFrame },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 0.2, 1, 0.8, 1 }
		}
	}
	UI.EditScenarioButton = Chili.Button:New{
		parent = UI.MainWindow,
		x = "30%",
		y = "50%",
		width = "40%",
		height = "10%",
		caption = LAUNCHER_SCENARIO,
		OnClick = { EditScenarioFrame },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 0.2, 1, 0.8, 1 }
		}
	}
	UI.LanguageComboBox = Chili.ComboBox:New{
		parent = UI.MainWindow,
		x = "85%",
		y = "0%",
		width = "15%",
		height = "7%",
		items = { "English", "French" },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 0.2, 1, 0.8, 1 }
		}
	}
	UI.LanguageComboBox.OnSelect = {
		function()
			if UI.LanguageComboBox.selected == 1 then
				ChangeLanguage("en")
			elseif UI.LanguageComboBox.selected == 2 then
				ChangeLanguage("fr")
			end
		end
	}
	UI.BackButton = Chili.Button:New{
		parent = UI.MainWindow,
		x = "0%",
		y = "0%",
		width = "10%",
		height = "10%",
		backgroundColor = { 0, 0.2, 0.6, 1 },
		focusColor = { 0, 0.6, 1, 1 },
		OnClick = { MainMenuFrame }
	}
	Chili.Image:New{
		parent = UI.BackButton,
		x = "10%",
		y = "10%",
		width = "80%",
		height = "80%",
		keepAspect = false,
		file = "bitmaps/launcher/arrow.png"
	}
	UI.QuitButton = Chili.Button:New{
		parent = UI.MainWindow,
		x = "90%",
		y = "90%",
		width = "10%",
		height = "10%",
		caption = LAUNCHER_QUIT,
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

function InitializeMapList()
	MapList = VFS.DirList("maps/", "*.sd*", VFS.RAW)
	for i, map in ipairs(MapList) do
		map = string.gsub(map, "maps\\", "")
		map = string.gsub(map, "%.sd.*", "")
		MapList[i] = map
	end
end

function InitializeLevelList()
	LevelListNames = VFS.DirList("CustomLevels/", "*.editor", VFS.RAW)
	for i, level in ipairs(LevelListNames) do
		level = string.gsub(level, "CustomLevels\\", "")
		level = string.gsub(level, ".editor", "")
		LevelListNames[i] = level
		LevelList[i] = json.decode(VFS.LoadFile("CustomLevels/"..level..".editor",  VFS.RAW))
	end
end

function InitializeOutputStates()
	Links[0] = {}
	Links[#LevelList+1] = {}
	for i, level in ipairs(LevelList) do
		OutputStates[i] = {}
		Links[i] = {}
		for ii, e in ipairs(level.events) do
			for iii, a in ipairs(e.actions) do
				if a.type == "win" or a.type == "lose" then
					table.insert(OutputStates[i], a.params.outputState)
				end
			end
		end
	end
end

function InitializeMapButtons()
	InitializeMapList()
	UI.NewLevel = {}
	UI.NewLevel.Title = Chili.Label:New{
		parent = UI.MainWindow,
		x = "20%",
		y = "15%",
		width = "60%",
		height = "5%",
		align = "center",
		valign = "center",
		caption = LAUNCHER_NEW_TITLE,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 0, 0.8, 1, 1 }
		}
	}
	UI.NewLevel.MapScrollPanel = Chili.ScrollPanel:New{
		parent = UI.MainWindow,
		x = "20%",
		y = "20%",
		width = "60%",
		height = "60%"
	}
	UI.NewLevel.NoMapMessage = Chili.TextBox:New{
		parent = UI.NewLevel.MapScrollPanel,
		x = "5%",
		y = "5%",
		width = "90%",
		height = "90%",
		text = LAUNCHER_NEW_NO_MAP_FOUND,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 1, 0, 0, 1 }
		}
	}
	UI.NewLevel.MapButtons = {}
	for i, map in ipairs(MapList) do
		local mapButton = Chili.Button:New{
			parent = UI.NewLevel.MapScrollPanel,
			x = "0%",
			y = 80 * ( i - 1 ),
			width = "100%",
			height = 80,
			caption = map,
			OnClick = { function() NewMission(map) end },
			font = {
				font = "LuaUI/Fonts/Asimov.otf",
				size = 40,
				color = { 0.2, 0.4, 0.8, 1 }
			}
		}
		table.insert(UI.NewLevel.MapButtons, mapButton)
	end
end

function InitializeLevelButtons()
	InitializeLevelList()
	UI.LoadLevel = {}
	UI.LoadLevel.Title = Chili.Label:New{
		parent = UI.MainWindow,
		x = "20%",
		y = "15%",
		width = "60%",
		height = "5%",
		align = "center",
		valign = "center",
		caption = LAUNCHER_EDIT_TITLE,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 0, 0.8, 1, 1 }
		}
	}
	UI.LoadLevel.LevelScrollPanel = Chili.ScrollPanel:New{
		parent = UI.MainWindow,
		x = "20%",
		y = "20%",
		width = "60%",
		height = "60%"
	}
	UI.LoadLevel.NoLevelMessage = Chili.TextBox:New{
		parent = UI.LoadLevel.LevelScrollPanel,
		x = "5%",
		y = "5%",
		width = "90%",
		height = "90%",
		text = LAUNCHER_EDIT_NO_LEVEL_FOUND,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 1, 0, 0, 1 }
		}
	}
	UI.LoadLevel.LevelButtons = {}
	for i, level in ipairs(LevelListNames) do
		local levelButton = Chili.Button:New{
			parent = UI.LoadLevel.LevelScrollPanel,
			x = "0%",
			y = 80 * ( i - 1 ),
			width = "100%",
			height = 80,
			caption = LevelList[i].description.name,
			OnClick = { function() EditMission(level) end },
			font = {
				font = "LuaUI/Fonts/Asimov.otf",
				size = 40,
				color = { 0.2, 0.4, 0.8, 1 }
			}
		}
		table.insert(UI.LoadLevel.LevelButtons, levelButton)
	end
end

function InitializeScenarioFrame()
	InitializeOutputStates()
	UI.Scenario = {}
	UI.Scenario.Title = Chili.Label:New{
		parent = UI.MainWindow,
		x = "20%",
		y = "15%",
		width = "60%",
		height = "5%",
		align = "center",
		valign = "center",
		caption = LAUNCHER_SCENARIO_TITLE,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = { 0, 0.8, 1, 1 }
		}
	}
	UI.Scenario.Export = Chili.Button:New{
		parent = UI.MainWindow,
		x = "40%",
		y = "90%",
		width = "20%",
		height = "5%",
		caption = LAUNCHER_SCENARIO_EXPORT,
		backgroundColor = { 0, 0.8, 1, 1 },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 25,
			--color = { 0, 0.8, 1, 1 }
		}
	}
	UI.Scenario.ScenarioScrollPanel = Chili.ScrollPanel:New{
		parent = UI.MainWindow,
		x = "2%",
		y = "20%",
		width = "96%",
		height = "68%"
	}
	--[[ FIXME
	local function drawLinks()
		for k, out in pairs(Links) do
			if k == "begin" and out then
				local x1, x2, y1, y2 = 0, 0, 0, 0
				x1 = UI.Scenario.Output.Begin.x + UI.Scenario.Begin.x
				y1 = UI.Scenario.Output.Begin.y + UI.Scenario.Begin.y
				x2 = UI.Scenario.Input[out].x + UI.Scenario.Levels[out].x
				y2 = UI.Scenario.Input[out].y + UI.Scenario.Levels[out].y
				gl.Vertex(x1, y1)
				gl.Vertex(x2, y2)
			else
				for kk, linked in pairs(out) do
					
				end
			end
		end
	end
	UI.Scenario.Links = Chili.Control:New{
		parent = UI.Scenario.ScenarioScrollPanel,
		x = '0%',
		y = '0%',
		width = '100%',
		height = '100%',
		DrawControl = function(obj)
			local x = obj.x
			local y = obj.y
			local w = obj.width
			local h = obj.height
			gl.Color(1, 1, 1, 1)
			gl.PushMatrix()
			gl.Translate(x, y, 0)
			gl.Scale(w, h, 1)
			gl.BeginEnd(GL.LINES, drawLinks)
			gl.PopMatrix()
		end
	}
	]]
	UI.Scenario.Output = {}
	UI.Scenario.Input = {}
	UI.Scenario.Levels = {}
	UI.Scenario.Levels[0] = Chili.Window:New{
		parent = UI.Scenario.ScenarioScrollPanel,
		x = 10,
		y = 10,
		width = 150,
		height = 75,
		draggable = true,
		resizable = false
	}
	UI.Scenario.Output[0] = {}
	UI.Scenario.Output[0][1] = Chili.Button:New{
		parent = UI.Scenario.Levels[0],
		x = "0%",
		y = "0%",
		width = "100%",
		height = "100%",
		caption = LAUNCHER_SCENARIO_BEGIN,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 16
		},
		OnClick = { function() selectedOutputMission = 0 selectedOutput = 1 end }
	}
	UI.Scenario.Levels[#LevelList+1] = Chili.Window:New{
		parent = UI.Scenario.ScenarioScrollPanel,
		x = 170,
		y = 10,
		width = 150,
		height = 75,
		draggable = true,
		resizable = false
	}
	UI.Scenario.Input[#LevelList+1] = Chili.Button:New{
		parent = UI.Scenario.Levels[#LevelList+1],
		x = "0%",
		y = "0%",
		width = "100%",
		height = "100%",
		caption = LAUNCHER_SCENARIO_END,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 16
		},
		OnClick = { function() selectedInput = #LevelList+1 end }
	}
	local column = -1
	for i, level in ipairs(LevelList) do
		-- Search for output states
		local outputStates = OutputStates[i]
		if i % 3 == 1 then
			column = column + 1
			UI.Scenario.Levels[i] = Chili.Window:New{
				parent = UI.Scenario.ScenarioScrollPanel,
				x = 10 + column * 310,
				y = 95,
				width = 300,
				height = math.max(150, (#outputStates + 2) * 30),
				draggable = true,
				resizable = true
			}
		else
			UI.Scenario.Levels[i] = Chili.Window:New{
				parent = UI.Scenario.ScenarioScrollPanel,
				x = 10 + column * 310,
				y = UI.Scenario.Levels[i-1].y + UI.Scenario.Levels[i-1].height + 10,
				width = 300,
				height = math.max(150, (#outputStates + 2) * 30),
				draggable = true,
				resizable = true
			}
		end
		Chili.Label:New{
			parent = UI.Scenario.Levels[i],
			x = "0%",
			y = 0,
			width = "100%",
			height = 30,
			caption = level.description.name,
			align = "center",
			valign = "center",
			font = {
				font = "LuaUI/Fonts/Asimov.otf",
				size = 18,
				color = { 0, 0.8, 0.8, 1 }
			}
		}
		UI.Scenario.Input[i] = Chili.Button:New{
			parent = UI.Scenario.Levels[i],
			x = 0,
			y = 30,
			width = 50,
			height = 30,
			caption = "In",
			font = {
				font = "LuaUI/Fonts/Asimov.otf",
				size = 16
			},
			OnClick = { function() selectedInput = i end }
		}
		UI.Scenario.Output[i] = {}
		for ii, out in ipairs(outputStates) do
			local but = Chili.Button:New{
				parent = UI.Scenario.Levels[i],
				x = 155,
				y = ii * 30,
				width = 120,
				height = 30,
				caption = out,
				font = {
					font = "LuaUI/Fonts/Asimov.otf",
					size = 16
				}
			}
			but.OnClick = { function() selectedOutputMission = i selectedOutput = out end }
			UI.Scenario.Output[i][out] = but
		end
	end
end

function UpdateCaption(element, text)
	if element then
		element:SetCaption(text)
	end
end

function UpdateText(element, text)
	if element then
		element:SetText(text)
	end
end

function ClearUI()
	UI.MainWindow:RemoveChild(UI.NewMissionButton)
	UI.MainWindow:RemoveChild(UI.EditMissionButton)
	UI.MainWindow:RemoveChild(UI.EditScenarioButton)
	UI.MainWindow:RemoveChild(UI.BackButton)
	
	UI.MainWindow:RemoveChild(UI.NewLevel.Title)
	UI.NewLevel.MapScrollPanel:RemoveChild(UI.NewLevel.NoMapMessage)
	UI.MainWindow:RemoveChild(UI.NewLevel.MapScrollPanel)
	
	UI.MainWindow:RemoveChild(UI.LoadLevel.Title)
	UI.LoadLevel.LevelScrollPanel:RemoveChild(UI.LoadLevel.NoLevelMessage)
	UI.MainWindow:RemoveChild(UI.LoadLevel.LevelScrollPanel)
	
	UI.MainWindow:RemoveChild(UI.Scenario.Title)
	UI.MainWindow:RemoveChild(UI.Scenario.ScenarioScrollPanel)
	UI.MainWindow:RemoveChild(UI.Scenario.Export)
end

function MainMenuFrame()
	ClearUI()
	UI.MainWindow:AddChild(UI.NewMissionButton)
	UI.MainWindow:AddChild(UI.EditMissionButton)
	UI.MainWindow:AddChild(UI.EditScenarioButton)
end

function NewMissionFrame()
	ClearUI()
	UI.MainWindow:AddChild(UI.BackButton)
	UI.MainWindow:AddChild(UI.NewLevel.Title)
	UI.MainWindow:AddChild(UI.NewLevel.MapScrollPanel)
	if #MapList == 0 then
		UI.NewLevel.MapScrollPanel:AddChild(UI.MapScrollPanel.NoMapMessage)
	end
end

function EditMissionFrame()
	ClearUI()
	UI.MainWindow:AddChild(UI.BackButton)
	UI.MainWindow:AddChild(UI.LoadLevel.Title)
	UI.MainWindow:AddChild(UI.LoadLevel.LevelScrollPanel)
	if #LevelListNames == 0 then
		UI.LoadLevel.LevelScrollPanel:AddChild(UI.LevelScrollPanel.NoLevelMessage)
	end
end

function EditScenarioFrame()
	ClearUI()
	UI.MainWindow:AddChild(UI.BackButton)
	UI.MainWindow:AddChild(UI.Scenario.Title)
	UI.MainWindow:AddChild(UI.Scenario.ScenarioScrollPanel)
	UI.MainWindow:AddChild(UI.Scenario.Export)
end

function ChangeLanguage(lang)
	Language = lang
	GetLauncherStrings(lang)
	
	UpdateCaption(UI.Title, LAUNCHER_TITLE)
	UpdateCaption(UI.NewMissionButton, LAUNCHER_NEW_MISSION)
	UpdateCaption(UI.EditMissionButton, LAUNCHER_EDIT_MISSION)
	UpdateCaption(UI.EditScenarioButton, LAUNCHER_SCENARIO)
	UpdateCaption(UI.QuitButton, LAUNCHER_QUIT)
	
	UpdateText(UI.NewLevel.NoMapMessage, LAUNCHER_NEW_NO_MAP_FOUND)
	UpdateCaption(UI.NewLevel.Title, LAUNCHER_NEW_TITLE)
	
	UpdateText(UI.LoadLevel.NoLevelMessage, LAUNCHER_EDIT_NO_LEVEL_FOUND)
	UpdateCaption(UI.LoadLevel.Title, LAUNCHER_EDIT_TITLE)
	
	UpdateCaption(UI.Scenario.Title, LAUNCHER_SCENARIO_TITLE)
	UpdateCaption(UI.Scenario.Output[0][1], LAUNCHER_SCENARIO_BEGIN)
	UpdateCaption(UI.Scenario.Input[#LevelList+1], LAUNCHER_SCENARIO_END)
	UpdateCaption(UI.Scenario.Export, LAUNCHER_SCENARIO_EXPORT)
end

function NewMission(map)
	local operations = {
		["MODOPTIONS"] = {
			["language"] = Language,
			["scenario"] = "noScenario"
		},
		["GAME"] = {
			["Mapname"] = map
		}
	}
	DoTheRestart("LevelEditor.txt", operations)
end

function EditMission(level)
	if VFS.FileExists("CustomLevels/"..level..".editor",  VFS.RAW) then
		local levelFile = VFS.LoadFile("CustomLevels/"..level..".editor",  VFS.RAW)
		levelFile = json.decode(levelFile)
		local operations = {
			["MODOPTIONS"] = {
				["language"] = Language,
				["scenario"] = "noScenario",
				["toBeLoaded"] = level
			},
			["GAME"] = {
				["Mapname"] = levelFile.description.map
			}
		}
		DoTheRestart("LevelEditor.txt", operations)
	end
end

function MakeLink()
	if selectedInput and selectedOutputMission then
	
		if Links[selectedOutputMission][selectedOutput] then
			UI.Scenario.Input[Links[selectedOutputMission][selectedOutput]].state.chosen = false
			UI.Scenario.Input[Links[selectedOutputMission][selectedOutput]]:InvalidateSelf()
		end
		for k, link in pairs(Links) do
			for kk, output in pairs(link) do
				if output == selectedInput then
					UI.Scenario.Output[k][kk].state.chosen = false
					UI.Scenario.Output[k][kk]:InvalidateSelf()
					break
				end
			end
		end
		
		Links[selectedOutputMission][selectedOutput] = selectedInput
		
		local r, g, b = math.random(), math.random(), math.random()
		
		UI.Scenario.Output[selectedOutputMission][selectedOutput].chosenColor = { r, g, b, 1 }
		UI.Scenario.Output[selectedOutputMission][selectedOutput].state.chosen = true
		UI.Scenario.Output[selectedOutputMission][selectedOutput]:InvalidateSelf()
		
		UI.Scenario.Input[selectedInput].chosenColor = { r, g, b, 1 }
		UI.Scenario.Input[selectedInput].state.chosen = true
		UI.Scenario.Input[selectedInput]:InvalidateSelf()
		
		selectedOutput = nil
		selectedOutputMission = nil
		selectedInput = nil
	end
end

function Quit()
	Spring.SendCommands("quit")
	Spring.SendCommands("quitforce")
end

function RemoveOtherWidgets()
	for name, w in pairs(widgetHandler.knownWidgets) do
		if w.active and name ~= "Spring Direct Launch 2 for Prog&Play Level Editor" and name ~= "Chili Framework" then
			widgetHandler:DisableWidget(name)
		end
	end
end

function EitherDrawScreen()
	if not vsx or not vsy or not HideView then
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

function SwitchOn()
	Spring.SendCommands({"NoSound 1"})
	Spring.SendCommands("fps 1")
	HideView = true
	RemoveOtherWidgets()
	InitializeLauncher()
end

function SwitchOff()
	HideView = false
	RemoveOtherWidgets()
	InitializeEditor()
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
	if not Spring.GetModOptions().hidemenu then
		GetLauncherStrings("en")
		SwitchOn()
		ChangeLanguage("en")
	else
		SwitchOff()
	end
	MainMenuFrame()
end

function widget:Update(delta)
	MakeLink()
end