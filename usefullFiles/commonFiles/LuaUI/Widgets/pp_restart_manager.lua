function widget:GetInfo()
  return {
    name      = "PP Restart Manager",
    desc      = "Used to manage restart in case of multiplayer or solo",
    author    = "muratet, mocahteam",
    date      = "March 28, 2017",
    license   = "GPL v2 or later",
    layer     = -10,
    enabled   = true
  }
end

local json = VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
VFS.Include("LuaUI/Widgets/libs/RestartScript.lua")

local HOST_LABEL = ""
local MULTIPLAYER_LABEL = ""
local SET_IP_LABEL = ""
local JOIN_LABEL = ""
local BACK_LABEL = ""
local MULTI_HELP_LABEL = ""
local SELECT_TEAM_LABEL = ""
local TEST_LABEL = ""
local PLAY_LABEL = ""
local TEAM_CHOSEN_LABEL = ""
local ENTER_IP_LABEL = ""
local NO_PLAYER_LABEL = ""
local function updateLanguage ()
	HOST_LABEL = "Host game"
	MULTIPLAYER_LABEL = "Multiplayer game"
	SET_IP_LABEL = "Host IP Address"
	JOIN_LABEL = "Join game"
	BACK_LABEL = "Back"
	MULTI_HELP_LABEL = "If you want hosting the game, find your IP Address and give it to other palyers, then click on the \""..HOST_LABEL.."\" button.\n \nIf you want to join the game, note the IP Address of the hosting player (you will need it later) and click on the \""..JOIN_LABEL.."\" button."
	SELECT_TEAM_LABEL = "Select the team you want to "
	TEST_LABEL = "test."
	PLAY_LABEL = "play."
	TEAM_CHOSEN_LABEL = "You choose to play \""
	ENTER_IP_LABEL = "Enter IP Address of the hosting player:"
	NO_PLAYER_LABEL = "You can't test this game because no team is controlled by a player."
	if WG.Language == "fr" then
		HOST_LABEL = "Héberger la partie"
		MULTIPLAYER_LABEL = "Partie multijoueurs"
		SET_IP_LABEL = "Adresse IP de l'hôte"
		JOIN_LABEL = "Rejoindre la partie"
		BACK_LABEL = "Retour"
		MULTI_HELP_LABEL = "Si vous souhaitez hébergez la partie, trouvez votre adresse IP et communiquer la aux autres joueurs, cliquez ensuite sur le bouton \""..HOST_LABEL.."\".\n \nSi vous souhaitez rejoindre une partie, notez l'adresse IP du joueur qui héberge la partie (vous en aurez besoin ultérieurement) puis cliquez sur le bouton \""..JOIN_LABEL.."\"."
		SELECT_TEAM_LABEL = "Selectionnez l'équipe que vous souhaitez "
		TEST_LABEL = "tester."
		PLAY_LABEL = "jouer."
		TEAM_CHOSEN_LABEL = "Vous avez choisi de jouer \""
		ENTER_IP_LABEL = "Entrer l'adresse IP do joueur hébergeant la partie :"
		NO_PLAYER_LABEL = "Vous ne pouvez pas tester cette partie car aucune équipe n'est contrôlée par un joueur."
	end
end

local MultiplayerWindow = nil
local FilterBackground = nil

local function runMission(ScriptFileName, options, playerName)
Spring.Echo ("runMission")
  if Spring.Restart then  
      genericRestart(ScriptFileName, options, false, playerName)
  else
    Spring.Echo("Warning!!! No Spring.Restart == nil => Restart aborted.")
  end
end

local function clearUI()
	if MultiplayerWindow ~= nil then
		MultiplayerWindow:Dispose()
		MultiplayerWindow = nil
	end
	if FilterBackground ~= nil then
		FilterBackground:Dispose()
		FilterBackground = nil
	end
end

local function commonElements()
	clearUI()
	
	FilterBackground = WG.Chili.Image:New {
		parent = WG.Chili.Screen0,
		x = "0%",
		y = "0%",
		width = "100%",
		height = "100%",
		file = "bitmaps/editor/blank.png",
		keepAspect = false
	}
	FilterBackground.color = {0, 0, 0, 0.9}
	FilterBackground.OnClick = {
		function()
			return true -- Stop Clic event
		end
	}
	
	MultiplayerWindow = WG.Chili.Window:New{
		parent = WG.Chili.Screen0,
		x = "20%",
		y = "10%",
		width  = "60%",
		height = "80%",
		minWidth = 0,
		minHeight = 0,
		draggable = false,
		resizable = false
	}
	
	FilterBackground:BringToFront()
	MultiplayerWindow:BringToFront()
	
	-- The close button
	local mainMenuCloseButton = WG.Chili.Image:New {
		parent = MultiplayerWindow,
		x = "95%",
		y = "0%",
		width = "5%",
		height = "5%",
		file = "bitmaps/editor/close.png",
		keepAspect = true
	}
	mainMenuCloseButton.color = { 1, 0, 0, 1 }
	mainMenuCloseButton.OnMouseOver = { function() mainMenuCloseButton.color = { 1, 0.5, 0, 1 } end }
	mainMenuCloseButton.OnMouseOut = { function() mainMenuCloseButton.color = { 1, 0, 0, 1 } end }
	mainMenuCloseButton.OnClick = { clearUI }
	-- The title
	WG.Chili.Label:New{
		parent = MultiplayerWindow,
		x = '5%',
		y = '0%',
		width = '90%',
		height = '10%',
		minWidth = 0,
		minHeight = 0,
		align = "center",
		valign = "linecenter",
		caption = MULTIPLAYER_LABEL,
		fontsize = 20,
		padding = {8, 2, 8, 2},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
			shadow = false
		}
	}
end

function ask_to_input_ip(missionName, options, playerTeams, isHost, isEditorContext, playerName)
	commonElements()
	
	-- call the team chosen back
	WG.Chili.Label:New{
		parent = MultiplayerWindow,
		x = '0%',
		y = '20%',
		width = '100%',
		height = '10%',
		minWidth = 0,
		minHeight = 0,
		align = "center",
		valign = "linecenter",
		caption = TEAM_CHOSEN_LABEL..playerName.."\".",
		fontsize = 20,
		padding = {8, 2, 8, 2},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
			shadow = false
		}
	}
	
	
	WG.Chili.Label:New{
		parent = MultiplayerWindow,
		x = '5%',
		y = '40%',
		width = '95%',
		height = '10%',
		minWidth = 0,
		minHeight = 0,
		align = "left",
		valign = "linecenter",
		caption = ENTER_IP_LABEL,
		fontsize = 20,
		padding = {8, 2, 8, 2},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
			shadow = false
		}
	}
	-- The EditBox
	local editBox = WG.Chili.EditBox:New {
		parent = MultiplayerWindow,
		x = "5%",
		y = "50%",
		width = "70%",
		height = "10%",
		align = "left",
		hint = SET_IP_LABEL,
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 16,
			autoAdjust = true,
			maxSize = 16,
			shadow = false
		},
		OnKeyPress = {
			function (self, key)
				if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
					WG.Chili.Screen0:FocusControl(nil)
					return true
				end
			end
		}
	}
	-- Join Button
	WG.Chili.Button:New{
		parent = MultiplayerWindow,
		x = "75%",
		y = "50%",
		width = "20%",
		height = "10%",
		caption = JOIN_LABEL,
		minWidth = 0,
		minHeight = 0,
		padding = {8, 0, 8, 0},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 15,
			autoAdjust = true,
			maxSize = 15,
			shadow = false,
		},
		backgroundColor = { 0, 0.2, 0.6, 1 },
		focusColor = { 0, 0.6, 1, 1 },
		OnClick = {
			function()
				restartAndJoinTheGame(playerName,editBox.text)
			end
		},	
	}
	-- Back Button
	WG.Chili.Button:New{
		parent = MultiplayerWindow,
		x = "40%",
		y = "80%",
		width = "20%",
		height = "10%",
		caption = BACK_LABEL,
		minWidth = 0,
		minHeight = 0,
		padding = {8, 0, 8, 0},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 15,
			autoAdjust = true,
			maxSize = 15,
			shadow = false,
		},
		backgroundColor = { 0, 0.2, 0.6, 1 },
		focusColor = { 0, 0.6, 1, 1 },
		OnClick = {
			function()
				select_player_slot(missionName, options, playerTeams, isHost, isEditorContext)
			end
		},	
	}
	WG.Chili.Screen0:FocusControl(editBox)
end

function select_player_slot(missionName, options, playerTeams, isHost, isEditorContext)
	commonElements()
	
	local action = PLAY_LABEL
	if isEditorContext then
		action = TEST_LABEL
	end
	-- we ask the player/teacher to select a team
	WG.Chili.Label:New{
		parent = MultiplayerWindow,
		x = '0%',
		y = '20%',
		width = '100%',
		height = '10%',
		minWidth = 0,
		minHeight = 0,
		align = "center",
		valign = "linecenter",
		caption = SELECT_TEAM_LABEL..action,
		fontsize = 20,
		padding = {8, 2, 8, 2},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
			shadow = false
		}
	}
	
	local playerList = WG.Chili.ScrollPanel:New{
		parent = MultiplayerWindow,
		x = "20%",
		y = "40%",
		width = "60%",
		height = "40%"
	}
	-- add one button for each payer slot
	local counter = 0
	for key, playerTeam in ipairs(playerTeams) do 
		WG.Chili.Button:New{
			parent = playerList,
			x = "0%",
			y = ((counter)*15).."%", --80 * ( i - 1 ),
			width = "100%",
			height = "15%",
			caption = playerTeam.name,
			OnClick = {
				function()
					if isHost or isEditorContext then
						runMission(missionName, options, playerTeam.name)
					else
						ask_to_input_ip(missionName, options, playerTeams, isHost, isEditorContext, playerTeam.name)
					end
				end
			},
			font = {
				font = "LuaUI/Fonts/Asimov.otf",
				size = 30,
				autoAdjust = true,
				maxSize = 30,
				color = { playerTeam.color.red, playerTeam.color.green, playerTeam.color.blue, 1 },
				shadow = false
			}
		}
		counter = counter + 1
	end
	if not isEditorContext then
		-- Back Button
		WG.Chili.Button:New{
			parent = MultiplayerWindow,
			x = "40%",
			y = "80%",
			width = "20%",
			height = "10%",
			caption = BACK_LABEL,
			minWidth = 0,
			minHeight = 0,
			padding = {8, 0, 8, 0},
			font = {
				font = "LuaUI/Fonts/TruenoRg.otf",
				size = 15,
				autoAdjust = true,
				maxSize = 15,
				shadow = false,
			},
			backgroundColor = { 0, 0.2, 0.6, 1 },
			focusColor = { 0, 0.6, 1, 1 },
			OnClick = {
				function()
					ask_to_host_or_join(missionName, options, playerTeams, isEditorContext)
				end
			},	
		}
	end
end

function ask_to_host_or_join(missionName, options, playerTeams, isEditorContext)
	
	if isEditorContext then
		-- we ask the teacher wich team he want to test
		select_player_slot(missionName, options, playerTeams, true, isEditorContext)
	else
		commonElements()
		-- we ask the player to choose between hosting or joining the game
		local HelpPanel = WG.Chili.ScrollPanel:New{
			parent = MultiplayerWindow,
			x = "0%",
			y = "20%",
			width = "100%",
			height = "40%"
		}
		WG.Chili.TextBox:New {
			parent = HelpPanel,
			x = '0%',
			y = '0%',
			width = '100%',
			height = '100%',
			text = MULTI_HELP_LABEL,
			fontsize = 16,
			font = {
				font = "LuaUI/Fonts/TruenoRg.otf",
				shadow = false
			}
		}
		
		WG.Chili.Button:New{
			parent = MultiplayerWindow,
			x = "30%",
			y = "60%",
			width = "40%",
			height = "10%",
			caption = HOST_LABEL,
			minWidth = 0,
			minHeight = 0,
			padding = {8, 0, 8, 0},
			font = {
				font = "LuaUI/Fonts/TruenoRg.otf",
				size = 15,
				autoAdjust = true,
				maxSize = 15,
				shadow = false,
			},
			OnClick = {
				function()
					select_player_slot(missionName, options, playerTeams, true, isEditorContext)
				end
			},
		}
		WG.Chili.Button:New{
			parent = MultiplayerWindow,
			x = "30%",
			y = "70%",
			width = "40%",
			height = "10%",
			caption = JOIN_LABEL,
			minWidth = 0,
			minHeight = 0,
			padding = {8, 0, 8, 0},
			font = {
				font = "LuaUI/Fonts/TruenoRg.otf",
				size = 15,
				autoAdjust = true,
				maxSize = 15,
				shadow = false,
			},
			OnClick = {
				function()
					select_player_slot(missionName, options, playerTeams, false, isEditorContext)
				end
			},
		}
	end
end

-- string ScriptFileName: the name of the file containing the mission description
-- table options: used to define modOptions
-- boolean isEditorContext: true if this function is called from the editor
function LoadMission (ScriptFileName, options, isEditorContext)
Spring.Echo ("LoadMission")
	if isEditorContext == nil then
		isEditorContext = false
	end
	-- get teams name controlled by players
	local playerTeams = {}
	local tableEditor = json.decode(VFS.LoadFile(ScriptFileName))
	for teamNumber,teamInformations in pairs(tableEditor.teams) do
		if (teamInformations.control=="player" and teamInformations.enabled==true) then 
			table.insert(playerTeams, {name=teamInformations.name, color=teamInformations.color})
		end
	end
	
	updateLanguage()
	
Spring.Echo ("LoadMission "..#playerTeams)
	-- display appropriate UI depending on players number
	if(#playerTeams > 1)then
		ask_to_host_or_join(ScriptFileName, options, playerTeams, isEditorContext)
	elseif (#playerTeams == 1)then
		runMission(ScriptFileName, options, playerTeams[1].name)
	else
		clearUI()
		-- display popup to explain no player is defined
		MultiplayerWindow = WG.Chili.Window:New{
			parent = WG.Chili.Screen0,
			x = "10%",
			y = "40%",
			width  = "80%",
			height = "20%",
			minWidth = 0,
			minHeight = 0,
			draggable = false,
			resizable = false
		}
		WG.Chili.Label:New{
			parent = MultiplayerWindow,
			x = '0%',
			y = '0%',
			width = '100%',
			height = '50%',
			minWidth = 0,
			minHeight = 0,
			align = "center",
			valign = "linecenter",
			caption = NO_PLAYER_LABEL,
			fontsize = 20,
			padding = {8, 2, 8, 2},
			font = {
				font = "LuaUI/Fonts/TruenoRg.otf",
				size = 20,
				autoAdjust = true,
				maxSize = 20,
				shadow = false
			}
		}
		WG.Chili.Button:New{
			parent = MultiplayerWindow,
			x = "45%",
			y = "50%",
			width = "10%",
			height = "50%",
			caption = "Ok",
			minWidth = 0,
			minHeight = 0,
			padding = {8, 0, 8, 0},
			font = {
				font = "LuaUI/Fonts/TruenoRg.otf",
				size = 15,
				autoAdjust = true,
				maxSize = 15,
				shadow = false,
			},
			OnClick = { clearUI },
		}
	end
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("LoadMission", LoadMission)
	widgetHandler:RegisterGlobal("RestartManagerClearUI", clearUI)
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("LoadMission")
	widgetHandler:DeregisterGlobal("RestartManagerClearUI")
end
