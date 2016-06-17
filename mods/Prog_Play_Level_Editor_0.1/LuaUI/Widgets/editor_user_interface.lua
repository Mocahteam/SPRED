function widget:GetInfo()
	return {
		name = "Editor User Interface",
		desc = "User interface of the level editor",
		author = "zigaroula",
		date = "02/05/2016",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true
	}
end

VFS.Include("LuaUI/Widgets/editor/StateMachine.lua") -- State machines definitions (class and instances)
VFS.Include("LuaUI/Widgets/editor/Misc.lua") -- Miscellaneous useful functions
VFS.Include("LuaUI/Widgets/editor/Conditions.lua")
VFS.Include("LuaUI/Widgets/editor/Actions.lua")
VFS.Include("LuaUI/Widgets/editor/EditorStrings.lua")
VFS.Include("LuaUI/Widgets/libs/RestartScript.lua")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			UI Variables
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Global UI Variables
local Chili, Screen0 -- Chili framework, main screen
local windows, topBarButtons = {}, {} -- references to UI elements
local testLevelButton
local globalFunctions, unitFunctions, teamFunctions = {}, {}, {} -- Generated functions for some buttons
local initialize = false
local UIelements = {}

-- File Variables
local fileButtons = {}
local loadedTable = {}

-- Unit Variables
local factionUnits = getFactionUnits() -- List of units sorted by faction
local teams = getTeamsInformation() -- List of teams as read in the LevelEditor.txt file (contains id and color)
local teamCount = tableLength(teamStateMachine.states) -- Total number of teams
local unitScrollPanel -- Contains buttons to change the state of the unit state machine
local unitButtons = {} -- Contains every type of unit as defined in UnitDef, buttons used to place units on the field
local factionButtons = {} -- Buttons to expand or collapse unit buttons
local teamLabels = {} -- Number of each team
local teamButtons = {} -- Contains every teams, buttons used to define the team of units being placed
local teamImages = {} -- Used to color the team buttons
local unitContextualMenu -- Appears when right-clicking on a unit
local unitAttributesWindow -- Temporary window to change unit's attributes
local changeHPEditBox -- Edit box to change the hp of the unit to a specific percentage
local autoHealComboBox -- Choose whether the autoheal should be enabled, disabled or use global settings
local teamComboBox -- Choose the targeted team for transfer
local unitHP = {} -- Array to store the hp of every units
local unitAutoHeal = {} -- Array to store the status of ever unit's autoheal
local unitGroups = {} -- Contains logical groups of units
local unitTotal = 0 -- Total number of units placed on the field
local unitGroupsUnitTotal = 0 -- Total number of units placed on the field (used for the unitGroups frame)
local groupNumber = 1 -- Current ID of a newly created group
local groupTotal = nil -- Total number of unit groups
local groupSizes = {} -- Contains the total number of units in each group
local unitGroupsAttributionWindow -- Pop-up window to add selected units to a group
local unitGroupsRemovalWindow -- Pop-up window to remove selected units from a group
local unitListScrollPanel -- List of units placed on the field
local unitListLabels = {} -- Type and ID of units as shown in right window
local unitListViewButtons = {} -- Buttons to focus a unit
local unitListHighlight = {} -- Show if unit is selected or not
local groupListScrollPanel -- List of unit groups
local groupListUnitsScrollPanel -- List of units in the unit groups frame
local groupPanels = {} -- Panels of unit groups
local groupEditBoxes = {} -- Allows changing the name of unit groups
local selectGroupButtons = {} -- Select a group to assign units to it
local unitGroupLabels = {} -- Name and id of unit in a group
local unitGroupViewButtons = {} -- Focus on a unit that is in a group
local unitGroupRemoveUnitButtons = {} -- Remove a unit from a group
local addUnitsToGroupsButton -- Add the selected units to the selected groups (in the groups frame)
local groupListUnitsButtons = {} -- Allows selection of units
local groupListUnitsViewButtons = {} -- Focus on units
local addGroupButton -- Creates a new group
local updateTeamButtons = true -- Force update on the bottom-right team buttons
local newUnitGroupEditBox -- Edit box to specify the name of the new group created from selected units

-- Draw selection variables
local drawStartX, drawStartY, drawEndX, drawEndY, screenSizeX, screenSizeY = 0, 0, 0, 0, 1920, 1080 -- Used to know where to plot the rectangle
local plotSelection = false -- Used in mouse events to plot the selection feedback rectangle
local selectionRect -- Selection visual feedback

-- Zone variables
local zoneButtons = {} -- Choose which type of zone to create
local zoneScrollPanel -- List of zones placed
local zoneBoxes = {} -- Contains an editbox to rename a zone and checkbox to display it
local plotZone = false -- Lock to plot a new zone
local rValue, gValue, bValue = 0, 0, 0 -- Color of the new zone
local zonePositions = { zoneX1 = 0, zoneX2 = 0, zoneZ1 = 0, zoneZ2 = 0 }
local zoneAnchorX, zoneAnchorZ = 0, 0 -- Mouse anchor when resizing a zone
local minZoneSize = 32 -- Minimum zone size
local zoneList = {} -- List of the zones placed on the field
local selectedZone = nil -- Currently selected zone for resizing/moving
local zoneSide = "" -- Corresponds to the side on which the user clicked to resize a zone
local totalZones = 0 -- Total number of placed zones
local zoneNumber = 1 -- Current ID of a newly created zone
local zoneIndex = 0 -- Used to go through every zones under the cursor when multiple zones are under it
local clickedZone -- Contains the zone the user clicked on
local zonesAttributesButton -- Button to show the window to change special attributes

-- Forces variables
local forcesTabs = {} -- Top frame buttons
local forcesWindows = {} -- Windows in the force frame
local teamConfigPanels = {} -- Contains UI elements to change team options
local allyTeams = {} -- List of ally teams
local allyTeamsSize = {} -- Respective sizes of ally teams
local allyTeamsRemoveTeamButtons = {} -- Remove team from an ally team
local allyTeamsRemoveTeamLabels = {} -- Name of teams in a ally team
local selectAllyTeamsButtons = {} -- Select an ally team
local allyTeamsListButtons = {} -- Add a team to the selected ally team
local allyTeamsListLabels = {} -- Name of the teams in the team list
local allyTeamsScrollPanels = {} -- Contains the allyTeamsListButtons
local allyTeamPanels = {} -- Panels to select an allyteam or to remove teams from an allyteam
local teamListScrollPanel -- Scroll panel to store every enabled teams
local selectedAllyTeam = 0 -- Currently selected ally team
local teamControlButtons = {} -- Allows the user to set how the team should be controlled
local teamControl = {} -- player or computer
local teamControlLabels = {} -- So the user knows he is changing the control of a team
local teamColorLabels = {} -- So the user knows he is changing the color of a team
local enableTeamButtons = {} -- Allows the user to set if the team is enabled or not
local enabledTeams = {} -- enabled or disabled
local enabledTeamsTotal = nil -- Number of enabled teams
local teamColorTrackbars = {} -- Trackbars to change the color of a team
local teamColor = {} -- Stores the color of each team
local teamColorImage = {} -- Image to preview the color of a team
local updateTeamConfig = true -- Force update of the team config panel
local updateAllyTeam = true -- Force update of the allyteam panel
local teamNameEditBoxes = {} -- Edit boxes to change the name of the teams
local teamName = {} -- Stores the names of the teams
local teamAIElements = {}
teamAIElements.teamAI = {} -- AI of computer controlled teams
teamAIElements.teamAILabels = {}
teamAIElements.teamAIEditBoxes = {}

-- Trigger variables
local events = {} -- Stores the events
local eventTotal -- Number of events
local eventScrollPanel -- scroll panel containing each event
local eventConditionsScrollPanel -- scroll panel containing each condition of an event
local eventActionsScrollPanel -- scroll panel containing each action of an event
local eventUI = {}
eventUI.eventButtons = {} -- buttons for each event
eventUI.deleteEventButtons = {} -- buttons to delete an event
eventUI.upEventButtons = {} -- buttons to change the sequence of events
eventUI.downEventButtons = {}
local currentEvent -- index of the current inspected event
local currentCondition -- index of the current inspected condition of the current inspected event
local currentAction -- index of the current inspected action of the current inspected event
local eventNumber = 0 -- used to assign a unique id to an event
local conditionNumber = 0 -- used to assign a unique id to a condition
local actionNumber = 0 -- used to assign a unique id to an action
local conditionButtons = {} -- buttons for each condition of the selected event
local deleteConditionButtons = {} -- buttons to delete a condition of the selected event
local newEventConditionButton -- button to add a condition to an event
local conditionNameEditBox -- to change the name of a condition
local conditionTypeComboBox -- to change the type of a condition
local conditionFilterComboBox -- to change the filter of the type combobox
local conditionScrollPanel -- scrollpanel containing each conditionButton
local conditionTextBox -- textbox containing the description of this type of condition
local conditionFeatures = {} -- table containing each customizable parameter of the condition
local actionButtons = {}  -- same for actions
local deleteActionButtons = {}
local newEventActionButton
local actionNameEditBox 
local actionTypeComboBox
local actionFilterComboBox
local actionScrollPanel
local actionTextBox
local actionFeatures = {}
local dontUpdateComboBox = false -- lock to prevent updating when it's required not to
local configureEventButton -- button to show the configure event window
local customTriggerEditBox -- to write a custom trigger
local customTriggerButton -- to save the custom trigger
local defaultTriggerButton -- to use the default trigger
local currentTriggerLabel -- so the user knows which trigger is currently used
local actionSequenceScrollPanel -- scrollpanel containing labels and buttons for each action
local actionSequenceItems = {} -- contains the aforementioned labels and buttons
local updateActionSequence = false -- update panels when sequence is altered
local importEventComboBox -- Choose the event from which conditions/actions should be imported
local importConditionComboBox -- Choose the coniditon to be imported
local importActionComboBox -- Choose the action to be imported
local changedParam -- parameter begin altered (picking for example)
local triggerVariables = {} -- Stores the variables
local variablesNumber = 0 -- Current ID to be attributed to a new variable
local variablesTotal = nil -- Number of variables
local editVariablesButton -- Button to show the window to edit variables
local variablesScrollPanel -- Scroll panel which contains UI elements to edit variables
local variablesFeatures = {} -- UI elements to edit variables
local forceUpdateVariables = false -- Force variables update
local commandsToID = {} -- Get the ID of a command knowing its name
local idToCommands = {} -- Get the name of a command knowing its ID
local sortedCommandsList = {} -- Sorted list of all the commands
local sortedCommandsListUnit = {} -- Sorted list of all the commands filtered by unit
local selectSetOfUnitsWindows = {} -- Windows to select unit by groups, teams, actions which create units and conditions triggered by units
local randomInZoneWindow -- Window to select a random position within a zone
local repetitionUI = {} -- Contains repetition parameters elements
local eventCommentEditBox -- Add a comment to an event
local markerList = {}

-- Map settings variables
local mapDescription = {}
mapDescription.mapName = "Map" -- Name of the map
mapDescription.mapBriefing = "Map Briefing" -- Briefing of the map
mapDescription.mapBriefingRaw = "Map Briefing" -- Briefing of the map with raw color tags
local mapNameEditBox -- Edit box to change the name of the map
local mapBriefingEditBox -- Edit box to change the briefing of the map
local mapBriefingTextBox -- Text box to preview the briefing of the map with colors
local mapSettingsButtons = {} -- Buttons in the mapsettings frame
local cameraAutoState = "enabled" -- Current state of camera auto
local autoHealState = "disabled" -- Current state of auto heal
local minimapState = "disabled" -- Current minimap state
local mouseState = "disabled" -- Current state of the mouse
local feedbackState = "disabled" -- Current state of the feedback (traces)
local customWidgets = {} -- List of widgets with status (enabled/disabled)

-- Save states variables
local saveStates = {} -- States for CTRL+Z
local loadLock = true -- Prevents saving states when loading a state
local loading = false -- Prevents multiple load
local loadIndex = 1 -- State to be loaded
local saveLoadCooldown = 0 -- Prevents too many loads in a short period of time
local saveCurrentEvent = nil -- If an event was opened, save it to open it again after the load
local saveCurrentCondition = nil -- same for condition
local saveCurrentAction = nil -- same for action
local variablesWindowToBeShown = false -- same for the variables window
local configureWindowToBeShown = false -- same for the configure event window
local unitGroupsWindowToBeShown = false -- same for the unit groups window
local toSave = false -- Synchronised save when moving units for example
local NeedToBeSaved = true -- Know when changes happened

-- Mouse variables
local mouseMove = false
local clickToSelect = false -- Enable isolation through clicking on an already selected unit
local doubleClick = 0

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Chili UI functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function initChili() -- Initialize Chili variables
	if (not WG.Chili) then -- If the chili widget is not found, remove this widget
		widgetHandler:RemoveWidget()
		return
	end

	-- Get ready to use Chili
	Chili = WG.Chili
	Screen0 = Chili.Screen0
end

function addWindow(_parent, _x, _y, _w, _h, _draggable)
	local window = Chili.Window:New{
		parent = _parent,
		x = _x,
		y = _y,
		width  = _w,
		height = _h,
		draggable = _draggable or false,
		resizable = false
	}
	return window
end

function addPanel(_parent, _x, _y, _w, _h)
	local panel = Chili.Panel:New{
		parent = _parent,
		x = _x,
		y = _y,
		width  = _w,
		height = _h,
		draggable = false,
		resizable = false
	}
	return panel
end

function addButton(_parent, _x, _y, _w, _h, text, onClickFunction)
	local button = Chili.Button:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		caption = text,
		OnClick = {onClickFunction},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf"
		}
	}
	table.insert(UIelements, button)
	return button
end

function addLabel(_parent, _x, _y, _w, _h, text, size, _align, _color, _valign)
	local label = Chili.Label:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		caption = text,
		fontsize = size or 20,
		align = _align or "center",
		valign = _valign or "linecenter",
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf"
		}
	}
	label.font.color = _color or {1, 1, 1, 1}
	table.insert(UIelements, label)
	return label
end

function addTextBox(_parent, _x, _y, _w, _h, _text, size, _color)
	local textBox = Chili.TextBox:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		text = _text,
		fontsize = size or 20,
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf"
		}
	}
	textBox.font.color = _color or {1, 1, 1, 1}
	table.insert(UIelements, textBox)
	return textBox
end

function addImage(_parent, _x, _y, _w, _h, imagePath, _keepAspect, _color)
	local image = Chili.Image:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		file = imagePath,
		keepAspect = _keepAspect or false,
		color = _color or {1, 1, 1, 1}
	}
	return image
end

function addRect(_parent, x1, y1, x2, y2, _color)
	local rect = Chili.Image:New {
		parent = _parent,
		x = x1,
		y = y1,
		width = x2 - x1,
		height = y2 - y1,
		file = "bitmaps/editor/blank.png",
		color = _color,
		keepAspect = false
	}
	return rect
end

function addScrollPanel(_parent, _x, _y, _w, _h)
	local scrollPanel = Chili.ScrollPanel:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h
	}
	return scrollPanel
end

function addEditBox(_parent, _x, _y, _w, _h, _align, _text, _color)
	local editBox = Chili.EditBox:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		align = _align or "left",
		text = _text or "",
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf"
		}
	}
	editBox.font.color = _color or {1, 1, 1, 1}
	if type(_h) ~= "string" then
		editBox.font.size = _h
	else
		editBox.font.size = 16
	end
	table.insert(UIelements, editBox)
	return editBox
end

function addCheckbox(_parent, _x, _y, _w, _h, _checked, _text, _textColor)
	local checkBox = Chili.Checkbox:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		caption = _text or "",
		textColor = _textColor or {1, 1, 1, 1},
		boxsize = _h or 10,
		checked = _checked or false
	}
	table.insert(UIelements, checkBox)
	return checkBox
end

function addTrackbar(_parent, _x, _y, _w, _h, _min, _max, _value, _step)
	local trackbar = Chili.Trackbar:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		min = _min or 0,
		max = _max or 100,
		value = _value or 50,
		step = _step or 1
	}
	return trackbar
end

function addComboBox(_parent, _x, _y, _w, _h, _items, onSelectFunction)
	local comboBox = Chili.ComboBox:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		items = _items,
		OnSelect = { onSelectFunction },
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf"
		}
	}
	table.insert(UIelements, comboBox)
	return comboBox
end

function removeElements(parent, elementsTable, dispose) -- Remove UI elements from a parent and eventually dispose them
	for k, e in pairs(elementsTable) do
		parent:RemoveChild(e)
		if dispose then
			e:Dispose()
		end
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Top bar functions (show/hide panels)
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function clearUI() -- remove every windows except topbar and clear current selection (units and events)
	for key, w in pairs(windows) do
		if (key ~= "topBar") then
			Screen0:RemoveChild(w)
		end
	end
	selectedZone = nil
	Spring.SelectUnitArray({})
	clearTemporaryWindows()
	currentEvent = nil
	currentCondition = nil
	currentAction = nil
	globalStateMachine:setCurrentState(globalStateMachine.states.NONE)
	triggerStateMachine:setCurrentState(triggerStateMachine.states.DEFAULT)
	
	-- Dispose some windows
	if selectSetOfUnitsWindows.groupteam then
		selectSetOfUnitsWindows.groupteam:Dispose()
	end
	if selectSetOfUnitsWindows.actcond then
		selectSetOfUnitsWindows.actcond:Dispose()
	end
	if randomInZoneWindow then
		randomInZoneWindow:Dispose()
	end
	if windows['widgetsWindow'] then
		windows['widgetsWindow']:Dispose()
		windows['widgetsWindow'] = nil
	end
	if windows['zonesAttributes'] then
		windows['zonesAttributes']:Dispose()
		windows['zonesAttributes'] = nil
	end
end

function clearTemporaryWindows()
	Screen0:RemoveChild(unitContextualMenu)
	Screen0:RemoveChild(unitGroupsAttributionWindow)
	Screen0:RemoveChild(unitGroupsRemovalWindow)
	Screen0:RemoveChild(unitAttributesWindow)
end

function fileFrame()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.FILE then
		clearUI()
	else
		clearUI()
		globalStateMachine:setCurrentState(globalStateMachine.states.FILE)
		Screen0:AddChild(windows["fileWindow"])
	end
end

function unitFrame()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
		clearUI()
	else
		clearUI()
		globalStateMachine:setCurrentState(globalStateMachine.states.UNIT)
		unitStateMachine:setCurrentState(unitStateMachine.states.SELECTION)
		teamStateMachine:setCurrentState(teamStateMachine:getCurrentState())
		Screen0:AddChild(windows["unitWindow"])
		Screen0:AddChild(windows["unitListWindow"])
	end
end

function zoneFrame()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		clearUI()
	else
		clearUI()
		globalStateMachine:setCurrentState(globalStateMachine.states.ZONE)
		zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWRECT)
		Screen0:AddChild(windows["zoneWindow"])
		zonesAttributesButton.state.chosen = false -- Reset state of this button
		zonesAttributesButton:InvalidateSelf()
	end
end

function forcesFrame()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.FORCES then
		clearUI()
	else
		clearUI()
		globalStateMachine:setCurrentState(globalStateMachine.states.FORCES)
		Screen0:AddChild(windows["forceWindow"])
		if forcesStateMachine:getCurrentState() == forcesStateMachine.states.TEAMCONFIG then
			teamConfig()
		elseif forcesStateMachine:getCurrentState() == forcesStateMachine.states.ALLYTEAMS then
			allyTeam()
		end
	end
end

function triggerFrame()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.TRIGGER then
		clearUI()
	else
		clearUI()
		globalStateMachine:setCurrentState(globalStateMachine.states.TRIGGER)
		Screen0:AddChild(windows["triggerWindow"])
		editVariablesButton.state.chosen = false -- Reset state of this button
		editVariablesButton:InvalidateSelf()
	end
end

function mapSettingsFrame()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.MAPSETTINGS then
		clearUI()
	else
		clearUI()
		globalStateMachine:setCurrentState(globalStateMachine.states.MAPSETTINGS)
		Screen0:AddChild(windows["mapSettingsWindow"])
		-- Set parameters to UI elements
		mapNameEditBox:SetText(mapDescription.mapName)
		mapBriefingEditBox:SetText(mapDescription.mapBriefingRaw)
		if cameraAutoState == "enabled" then
			mapSettingsButtons.cameraAutoButton:SetCaption(EDITOR_MAPSETTINGS_CAMERA_AUTO_ENABLED)
		elseif cameraAutoState == "disabled" then
			mapSettingsButtons.cameraAutoButton:SetCaption(EDITOR_MAPSETTINGS_CAMERA_AUTO_DISABLED)
		end
		if autoHealState == "enabled" then
			mapSettingsButtons.autoHealButton:SetCaption(EDITOR_MAPSETTINGS_HEAL_AUTO_ENABLED)
		elseif autoHealState == "disabled" then
			mapSettingsButtons.autoHealButton:SetCaption(EDITOR_MAPSETTINGS_HEAL_AUTO_DISABLED)
		end
		if mouseState == "enabled" then
			mapSettingsButtons.mouseStateButton:SetCaption(EDITOR_MAPSETTINGS_MOUSE_ENABLED)
		elseif mouseState == "disabled" then
			mapSettingsButtons.mouseStateButton:SetCaption(EDITOR_MAPSETTINGS_MOUSE_DISABLED)
		end
		if minimapState == "enabled" then
			mapSettingsButtons.minimapButton:SetCaption(EDITOR_MAPSETTINGS_MINIMAP_ENABLED)
		elseif minimapState == "disabled" then
			mapSettingsButtons.minimapButton:SetCaption(EDITOR_MAPSETTINGS_MINIMAP_DISABLED)
		end
		if feedbackState == "enabled" then
			mapSettingsButtons.feedbackButton:SetCaption(EDITOR_MAPSETTINGS_FEEDBACK_ENABLED)
		elseif feedbackState == "disabled" then
			mapSettingsButtons.feedbackButton:SetCaption(EDITOR_MAPSETTINGS_FEEDBACK_DISABLED)
		end
		mapSettingsButtons.widgetsButton.state.chosen = false -- Reset the state of this button
		mapSettingsButtons.widgetsButton:InvalidateSelf()
	end
end

function testLevel()

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Forces window buttons functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function clearForceWindow()
	windows['forceWindow']:RemoveChild(forcesWindows.teamConfigWindow)
	windows['forceWindow']:RemoveChild(forcesWindows.allyTeamsWindow)
end

function teamConfig() -- Show the team config panel
	clearForceWindow()
	forcesStateMachine:setCurrentState(forcesStateMachine.states.TEAMCONFIG)
	windows['forceWindow']:AddChild(forcesWindows.teamConfigWindow)
	for k, p in pairs(teamConfigPanels) do -- Force update on panels
		p:InvalidateSelf()
	end
	for k, t in pairs(teamStateMachine.states) do
		-- Update the name of the teams
		teamNameEditBoxes[t]:SetText(teamName[t]) 
		-- Update the state of the buttons if they are in wrong state
		if enabledTeams[t] and not enableTeamButtons[t].state.chosen then
			enableTeamButtons[t].state.chosen = not enableTeamButtons[t].state.chosen
			enableTeamButtons[t].caption = EDITOR_FORCES_TEAMCONFIG_ENABLED
		elseif not enabledTeams[t] and enableTeamButtons[t].state.chosen then
			enableTeamButtons[t].state.chosen = not enableTeamButtons[t].state.chosen
			enableTeamButtons[t].caption = EDITOR_FORCES_TEAMCONFIG_DISABLED
		end
		-- Update the values of the trackbars
		local r, g, b = teamColor[t].red, teamColor[t].green, teamColor[t].blue
		teamColorTrackbars[t].red:SetValue(r)
		teamColorTrackbars[t].green:SetValue(g)
		teamColorTrackbars[t].blue:SetValue(b)
		-- Update the values of AI
		teamAIElements.teamAIEditBoxes[t]:SetText(teamAIElements.teamAI[t])
	end
end

function allyTeam() -- Show the allyteam panel
	clearForceWindow()
	forcesStateMachine:setCurrentState(forcesStateMachine.states.ALLYTEAMS)
	windows['forceWindow']:AddChild(forcesWindows.allyTeamsWindow)
	for i, t in ipairs(teamStateMachine.states) do -- Set the teams names
		selectAllyTeamsButtons[t]:SetCaption(teamName[t])
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Initialisation functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function hideDefaultGUI()
	-- get rid of engine UI
	Spring.SendCommands("resbar 0","fps 1","console 0","info 0", "tooltip 0", "unbindkeyset backspace") -- TODO : change fps 1 to fps 0 in release
	-- leaves rendering duty to widget (we won't)
	gl.SlaveMiniMap(true)
	-- a hitbox remains for the minimap, unless you do this
	gl.ConfigMiniMap(0,0,0,0)
end

function initTopBar()
	-- Top bar
	windows['topBar'] = addWindow(Screen0, '0%', '0%', '100%', '5%')
	
	-- Menu buttons
	topBarButtons[globalStateMachine.states.FILE] = addButton(windows["topBar"], '0%', '0%', '10%', '100%', EDITOR_FILE, fileFrame)
	topBarButtons[globalStateMachine.states.UNIT] = addButton(windows["topBar"], '15%', '0%', '10%', '100%', EDITOR_UNITS, unitFrame)
	topBarButtons[globalStateMachine.states.ZONE] = addButton(windows["topBar"], '25%', '0%', '10%', '100%', EDITOR_ZONES, zoneFrame)
	topBarButtons[globalStateMachine.states.FORCES] = addButton(windows["topBar"], '40%', '0%', '10%', '100%', EDITOR_FORCES, forcesFrame)
	topBarButtons[globalStateMachine.states.TRIGGER] = addButton(windows["topBar"], '50%', '0%', '10%', '100%', EDITOR_TRIGGERS, triggerFrame)
	topBarButtons[globalStateMachine.states.MAPSETTINGS] = addButton(windows["topBar"], '60%', '0%', '10%', '100%', EDITOR_MAPSETTINGS, mapSettingsFrame)
	testLevelButton = addButton(windows["topBar"], '85%', '0%', '15%', '100%', EDITOR_TEST_LEVEL, testLevel)
	testLevelButton.backgroundColor = { 0.4, 1, 0.4, 1 }
end

function initWindows()
	initFileWindow()
	initForcesWindow()
	initUnitWindow()
	initUnitContextualMenu()
	initZoneWindow()
	initTriggerWindow()
	initMapSettingsWindow()
end

function initFileWindow()
	windows['fileWindow'] = addWindow(Screen0, '0%', '5%', '10%', '40%')
	addLabel(windows['fileWindow'], '0%', '1%', '100%', '5%', EDITOR_FILE, 20, "center", nil, "center")
	fileButtons['new'] = addButton(windows['fileWindow'], '0%', '10%', '100%', '15%', EDITOR_FILE_NEW, newMapFrame)
	fileButtons['load'] = addButton(windows['fileWindow'], '0%', '25%', '100%', '15%', EDITOR_FILE_LOAD, loadMapFrame)
	fileButtons['save'] = addButton(windows['fileWindow'], '0%', '40%', '100%', '15%', EDITOR_FILE_SAVE, saveMapFrame)
	fileButtons['settings'] = addButton(windows['fileWindow'], '0%', '70%', '100%', '15%', EDITOR_FILE_MENU, backToMenuFrame)
	fileButtons['quit'] = addButton(windows['fileWindow'], '0%', '85%', '100%', '15%', EDITOR_FILE_QUIT, quitFrame)
	fileButtons['quit'].backgroundColor = { 0.8, 0, 0.2, 1 }
	fileButtons['quit'].focusColor = { 0.8, 0.6, 0.2, 1 }
end

function initUnitWindow()
	-- Left Panel
	windows['unitWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	addLabel(windows['unitWindow'], '0%', '1%', '100%', '5%', EDITOR_UNITS)
	addLabel(windows["unitWindow"], '0%', '87%', '100%', '5%', EDITOR_UNITS_TEAM)
	unitScrollPanel = addScrollPanel(windows['unitWindow'], '0%', '5%', '100%', '80%')
	
	-- Faction Buttons
	local button_size = 40
	local y = 0
	for c, t in ipairs(factionUnits) do
		local function changeFactionButtonState() -- Expand/Collapse unit buttons
			factionButtons[c].state.chosen = not factionButtons[c].state.chosen
			factionButtons[c]:InvalidateSelf()
			updateUnitWindow()
		end
		if c == #factionUnits then -- Rename the last faction, which corresponds to units not belonging to any faction
			factionButtons[c] = addButton(unitScrollPanel, '0%', y, '100%', button_size, EDITOR_UNITS_UNSTABLE, changeFactionButtonState)
		else
			factionButtons[c] = addButton(unitScrollPanel, '0%', y, '100%', button_size, EDITOR_UNITS_FACTION.." "..c, changeFactionButtonState)
		end
		factionButtons[c].backgroundColor = {0.2, 0.8, 0.6, 1}
		factionButtons[c].chosenColor = {0.2, 0.8, 0.2, 1}
		factionButtons[c].state.chosen = false
		y = y + button_size
	end
	
	-- Unit List
	windows['unitListWindow'] = addWindow(Screen0, "85%", '5%', '15%', '80%')
	addLabel(windows['unitListWindow'], '0%', '1%', '100%', '5%', EDITOR_UNITS_LIST)
	unitListScrollPanel = addScrollPanel(windows['unitListWindow'], '0%', '5%', '100%', '85%')
	local showGroupsButton = addButton(windows['unitListWindow'], '0%', '90%', '100%', '10%', EDITOR_UNITS_GROUPS_SHOW, showGroupsWindow)
	
	-- Unit Groups Window
	windows["unitGroupsWindow"] = addWindow(Screen0, "5%", "10%", '90%', '80%', true)
	addLabel(windows["unitGroupsWindow"], '0%', '0%', '18%', '10%', EDITOR_UNITS_LIST, 30, "center", nil, "center")
	groupListUnitsScrollPanel = addScrollPanel(windows["unitGroupsWindow"], '0%', '10%', '18%', '90%')
	addUnitsToGroupsButton = addButton(windows["unitGroupsWindow"], '18%', '50%', '4%', '10%', ">>", addChosenUnitsToSelectedGroups)
	addLabel(windows["unitGroupsWindow"], '22%', '0%', '78%', '10%', EDITOR_UNITS_GROUPS_LIST, 30, "center", nil, "center")
	groupListScrollPanel = addScrollPanel(windows["unitGroupsWindow"], '22%', '10%', '78%', '90%')
	local closeGroupsWindow = function()
		Screen0:RemoveChild(windows["unitGroupsWindow"])
		Screen0:AddChild(windows['unitListWindow'])
		Screen0:AddChild(windows['unitWindow'])
		showGroupsButton:InvalidateSelf()
		unitStateMachine:setCurrentState(unitStateMachine.states.SELECTION)
	end
	local closeButton = addButton(windows["unitGroupsWindow"], "95%", "0%", "5%", "5%", EDITOR_X, closeGroupsWindow)
	closeButton.font.color = {1, 0, 0, 1}
end

function initUnitContextualMenu()
	unitContextualMenu = addWindow(nil, 0, 0, 200, 200)
	addButton(unitContextualMenu, '0%', "0%", '100%', tostring(100/3).."%", EDITOR_UNITS_EDIT_ATTRIBUTES_EDIT, showUnitAttributes)
	addButton(unitContextualMenu, '0%', tostring(100/3).."%", '100%', tostring(100/3).."%", EDITOR_UNITS_GROUPS_ADDTO, showUnitGroupsAttributionWindow)
	addButton(unitContextualMenu, '0%', tostring(200/3).."%", '100%', tostring(100/3).."%", EDITOR_UNITS_GROUPS_REMOVEFROM, showUnitGroupsRemovalWindow)
end

function initZoneWindow()
	windows['zoneWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	addLabel(windows['zoneWindow'], '0%', '1%', '100%', '5%', EDITOR_ZONES)
	zoneButtons[zoneStateMachine.states.DRAWRECT] = addButton(windows['zoneWindow'], '0%', '5%', '50%', '10%', "", function() zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWRECT) selectedZone = nil end)
	addImage(zoneButtons[zoneStateMachine.states.DRAWRECT], '0%', '0%', '100%', '100%', "bitmaps/editor/rectangle.png")
	zoneButtons[zoneStateMachine.states.DRAWDISK] = addButton(windows['zoneWindow'], '50%', '5%', '50%', '10%', "", function() zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWDISK) selectedZone = nil end)
	addImage(zoneButtons[zoneStateMachine.states.DRAWDISK], '0%', '0%', '100%', '100%', "bitmaps/editor/disk.png")
	zoneScrollPanel = addScrollPanel(windows['zoneWindow'], '0%', '15%', '100%', '75%')
	
	local toggleAllOn = function() -- show all zones
		for k, zb in pairs(zoneBoxes) do
			if not zb.checkbox.checked then
				zb.checkbox:Toggle()
			end
		end
	end
	local toggleAllOff = function() -- hide all zones
		for k, zb in pairs(zoneBoxes) do
			if zb.checkbox.checked then
				zb.checkbox:Toggle()
			end
		end
	end
	addButton(zoneScrollPanel, 0, 0, "50%", 30, EDITOR_ZONES_SHOW, toggleAllOn)
	addButton(zoneScrollPanel, "50%", 0, "50%", 30, EDITOR_ZONES_HIDE, toggleAllOff)
	
	zonesAttributesButton = addButton(windows['zoneWindow'], '0%', '90%', '100%', '10%', EDITOR_ZONES_ATTRIBUTES, showZonesSpecialAttributesWindow)
end

function initForcesWindow()
	windows['forceWindow'] = addWindow(Screen0, '10%', '10%', '80%', '80%', true)
	forcesTabs[forcesStateMachine.states.TEAMCONFIG] = addButton(windows['forceWindow'], "0%", "0%", tostring(95/2).."%", '5%', EDITOR_FORCES_TEAMCONFIG, teamConfig)
	forcesTabs[forcesStateMachine.states.ALLYTEAMS] = addButton(windows['forceWindow'], tostring(95/2).."%", "0%", tostring(95/2).."%", '5%', EDITOR_FORCES_ALLYTEAMS, allyTeam)
	local closeButton = addButton(windows['forceWindow'], "95%", "0%", "5%", "5%", EDITOR_X, clearUI)
	closeButton.font.color = {1, 0, 0, 1}
	
	-- Team Config Window
	forcesWindows.teamConfigWindow = addWindow(windows['forceWindow'], 0, '5%', '100%', '95%')
	local teamConfigScrollPanel = addScrollPanel(forcesWindows.teamConfigWindow, '0%', '0%', '100%', '100%')
	for i, team in ipairs(teamStateMachine.states) do
		teamConfigPanels[team] = addPanel(teamConfigScrollPanel, '0%', team * 100, '100%', 100)
		teamNameEditBoxes[team] = addEditBox(teamConfigPanels[team], '5%', '30%', '10%', '40%', "left", EDITOR_FORCES_TEAM_DEFAULT_NAME.." "..tostring(team), {teams[team].red, teams[team].green, teams[team].blue, 1})
		teamName[team] = teamNameEditBoxes[team].text
		-- Enabled/Disabled
		enableTeamButtons[team] = addButton(teamConfigPanels[team], '20%', '30%', '10%', '40%', EDITOR_FORCES_TEAMCONFIG_DISABLED, nil)
		local function changeTeamState()
			enabledTeams[team] = not enabledTeams[team]
			enableTeamButtons[team].state.chosen = not enableTeamButtons[team].state.chosen
			if enableTeamButtons[team].caption == EDITOR_FORCES_TEAMCONFIG_DISABLED then
				enableTeamButtons[team].caption = EDITOR_FORCES_TEAMCONFIG_ENABLED
			else
				enableTeamButtons[team].caption = EDITOR_FORCES_TEAMCONFIG_DISABLED
			end
			if not enabledTeams[team] then
				removeTeamFromTables(team)
			end
			saveState()
		end
		enabledTeams[team] = false -- Disable all teams at start
		enableTeamButtons[team].state.chosen = false
		enableTeamButtons[team].OnClick = { changeTeamState }
		if team == 0 or team == 1 or team == 2 then -- except the first 3 teams
			changeTeamState()
		end
		-- Controlled by
		teamControlLabels[team] = addLabel(teamConfigPanels[team], '35%', '20%', '20%', '30%', EDITOR_FORCES_TEAMCONFIG_CONTROL, 20, "center", nil, "center")
		teamControlButtons[team] = {}
		teamControlButtons[team].player = addButton(teamConfigPanels[team], '35%', '50%', '10%', '30%', EDITOR_FORCES_TEAMCONFIG_CONTROL_PLAYER, function() teamControl[team] = "player" updateTeamConfig = true saveState() end)
		teamControlButtons[team].computer = addButton(teamConfigPanels[team], '45%', '50%', '10%', '30%', EDITOR_FORCES_TEAMCONFIG_CONTROL_COMPUTER, function() teamControl[team] = "computer" updateTeamConfig = true saveState() end)
		teamControl[team] = "computer"
		if team == 0 then
			teamControl[team] = "player"
			updateTeamConfig = true
		end
		-- Color
		teamColor[team] = {}
		teamColor[team].red = tonumber(teams[team].red)
		teamColor[team].green = tonumber(teams[team].green)
		teamColor[team].blue = tonumber(teams[team].blue)
		teamColorLabels[team] = addLabel(teamConfigPanels[team], '60%', '20%', '20%', '30%', EDITOR_FORCES_TEAMCONFIG_COLOR, 20, "center", nil, "center")
		teamColorImage[team] = addImage(teamConfigPanels[team], '82%', '20%', '5%', '60%', "bitmaps/editor/blank.png", false, {teamColor[team].red, teamColor[team].green, teamColor[team].blue, 1})
		teamColorTrackbars[team] = {}
		teamColorTrackbars[team].red = addTrackbar(teamConfigPanels[team], '60%', '50%', tostring(20/3).."%", "30%", 0, 1, teamColor[team].red, 0.02)
		teamColorTrackbars[team].green = addTrackbar(teamConfigPanels[team], tostring(60 + 20/3)..'%', '50%', tostring(20/3).."%", "30%", 0, 1, teamColor[team].green, 0.02)
		teamColorTrackbars[team].blue = addTrackbar(teamConfigPanels[team], tostring(60 + 40/3)..'%', '50%', tostring(20/3).."%", "30%", 0, 1, teamColor[team].blue, 0.02)
		local function updateImage()
			teamColor[team].red = teamColorTrackbars[team].red.value
			teamColor[team].green = teamColorTrackbars[team].green.value
			teamColor[team].blue = teamColorTrackbars[team].blue.value
			teamColorImage[team].color = {
				teamColorTrackbars[team].red.value,
				teamColorTrackbars[team].green.value,
				teamColorTrackbars[team].blue.value,
				1
			}
			teamColorImage[team]:InvalidateSelf()
		end
		teamColorTrackbars[team].red.OnChange = {updateImage}
		teamColorTrackbars[team].red.color = {1, 0, 0, 1}
		teamColorTrackbars[team].green.OnChange = {updateImage}
		teamColorTrackbars[team].green.color = {0, 1, 0, 1}
		teamColorTrackbars[team].blue.OnChange = {updateImage}
		teamColorTrackbars[team].blue.color = {0, 0, 1, 1}
		-- IA field
		teamAIElements.teamAI[team] = ""
		teamAIElements.teamAILabels[team] = addLabel(teamConfigPanels[team], '90%', '20%', '8%', '30%', EDITOR_FORCES_TEAMCONFIG_AI, 20, "center", nil, "center")
		teamAIElements.teamAIEditBoxes[team] = addEditBox(teamConfigPanels[team], '90%', '50%', '8%', '30%')
	end
	
	-- Ally Team Window
	forcesWindows.allyTeamsWindow = addWindow(windows['forceWindow'], 0, '5%', '100%', '95%')
	addLabel(forcesWindows.allyTeamsWindow, '0%', '0%', '20%', '10%', EDITOR_FORCES_ALLYTEAMS_LIST, 30, "center", nil, "center")
	teamListScrollPanel = addScrollPanel(forcesWindows.allyTeamsWindow, '2%', '10%', '16%', '85%') -- List of all the teams
	for i, team in ipairs(teamStateMachine.states) do
		local x = tostring(20 + team * 80 / math.ceil(teamCount/2) - 80 * math.floor(team/math.ceil(teamCount/2)))..'%'
		local y = tostring(0 + 50 * math.floor(team/math.ceil(teamCount/2))).."%"
		local w = tostring(80 / math.ceil(teamCount/2)).."%"
		local h = "50%"
		allyTeamPanels[team] = addWindow(forcesWindows.allyTeamsWindow, x, y, w, h)
		selectAllyTeamsButtons[team] = addButton(allyTeamPanels[team], '0%', '0%', '100%', '10%', teamName[team], function() selectedAllyTeam = team end)
		selectAllyTeamsButtons[team].font.color = {teams[team].red, teams[team].green, teams[team].blue, 1}
		selectAllyTeamsButtons[team].font.size = 20
		allyTeamsScrollPanels[team] = addScrollPanel(allyTeamPanels[team], '2%', '10%', '96%', '89%')
		
		allyTeamsListButtons[team] = addButton(teamListScrollPanel, '80%', 40*team, '20%', 40, ">>", function() addTeamToSelectedAllyTeam(team) end)
		allyTeamsListLabels[team] = addLabel(teamListScrollPanel, '0%', 40*team, '80%', 40, teamName[team], 20, "center", {teams[team].red, teams[team].green, teams[team].blue, 1}, "center")
		
		allyTeamsRemoveTeamButtons[team] = {}
		allyTeamsRemoveTeamLabels[team] = {}
		
		allyTeams[team] = {}
		allyTeamsSize[team] = 0
	end
end

function initTriggerWindow()
	-- Left Panel
	windows['triggerWindow'] = addWindow(Screen0, '0%', '5%', '30%', '80%')
	addLabel(windows['triggerWindow'], '0%', '1%', '100%', '5%', EDITOR_TRIGGERS_EVENTS)
	eventScrollPanel = addScrollPanel(windows['triggerWindow'], '0%', '5%', '100%', '85%')
	newEventButton = addButton(eventScrollPanel, '0%', 0, '100%', 40, EDITOR_TRIGGERS_EVENTS_NEW, createNewEvent)
	editVariablesButton = addButton(windows['triggerWindow'], '0%', '90%', '100%', '10%', EDITOR_TRIGGERS_VARIABLES_EDIT, showVariablesFrame)
	
	-- Event window
	windows['eventWindow'] = addWindow(Screen0, '30%', '5%', '30%', '80%')
	local closeEvent = addButton(windows['eventWindow'], '93%', '0%', '7%', '4%', "X", function() editEvent(currentEvent) end)
	closeEvent.font.color = { 1, 0, 0, 1 }
	eventNameEditBox = addEditBox(windows['eventWindow'], '30%', '1%', '40%', '3%', "left", "")
	addLabel(windows['eventWindow'], '0%', '5%', '50%', '5%', EDITOR_TRIGGERS_CONDITIONS, 20, "center", nil, "center")
	addLabel(windows['eventWindow'], '50%', '5%', '50%', '5%', EDITOR_TRIGGERS_ACTIONS, 20, "center", nil, "center")
	eventConditionsScrollPanel = addScrollPanel(windows['eventWindow'], '2%', '10%', '46%', '83%')
	newEventConditionButton = addButton(eventConditionsScrollPanel, '0%', 0, '100%', 40, EDITOR_TRIGGERS_CONDITIONS_NEW, createNewCondition)
	eventActionsScrollPanel = addScrollPanel(windows['eventWindow'], '52%', '10%', '46%', '83%')
	newEventActionButton = addButton(eventActionsScrollPanel, '0%', 0, '100%', 40, EDITOR_TRIGGERS_ACTIONS_NEW, createNewAction)
	configureEventButton = addButton(windows['eventWindow'], '2%', '94%', '96%', '6%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_EVENT, configureEvent)
	
	-- Action/Condition
	local conditionFilterList, actionFilterList = { "All" }, { "All" }
	for i, a in ipairs(actions_list) do
		if not findInTable(actionFilterList, a.filter) then
			table.insert(actionFilterList, a.filter)
		end
	end
	for i, c in ipairs(conditions_list) do
		if not findInTable(conditionFilterList, c.filter) then
			table.insert(conditionFilterList, c.filter)
		end
	end
	
	-- Condition window
	windows['conditionWindow'] = addWindow(Screen0, '60%', '5%', '30%', '80%')
	local closeCondition = addButton(windows['conditionWindow'], '93%', '0%', '7%', '4%', "X", function() editCondition(currentCondition) end)
	closeCondition.font.color = { 1, 0, 0, 1 }
	conditionNameEditBox = addEditBox(windows['conditionWindow'], '30%', '1%', '40%', '3%', "left", "")
	addLabel(windows['conditionWindow'], '0%', '5%', '20%', '5%', EDITOR_TRIGGERS_EVENTS_FILTER, 20, "center", nil, "center")
	addLabel(windows['conditionWindow'], '0%', '10%', '20%', '5%', EDITOR_TRIGGERS_EVENTS_TYPE, 20, "center", nil, "center")
	conditionFilterComboBox = addComboBox(windows['conditionWindow'], '20%', '5%', '80%', '5%', conditionFilterList, selectFilter)
	conditionTypeComboBox = addComboBox(windows['conditionWindow'], '20%', '10%', '80%', '5%', {}, selectConditionType)
	conditionScrollPanel = addScrollPanel(windows['conditionWindow'], '0%', '15%', '100%', '85%')
	conditionTextBox = addTextBox(conditionScrollPanel, '5%', 20, '90%', 100, "")
	conditionTextBox.font.shadow = false
	
	-- Action window
	windows['actionWindow'] = addWindow(Screen0, '60%', '5%', '30%', '80%')
	local closeAction = addButton(windows['actionWindow'], '93%', '0%', '7%', '4%', "X", function() editAction(currentAction) end)
	closeAction.font.color = { 1, 0, 0, 1 }
	actionNameEditBox = addEditBox(windows['actionWindow'], '30%', '1%', '40%', '3%', "left", "")
	addLabel(windows['actionWindow'], '0%', '5%', '20%', '5%', "Filter", 20, "center", nil, "center")
	addLabel(windows['actionWindow'], '0%', '10%', '20%', '5%', "Type", 20, "center", nil, "center")
	actionFilterComboBox = addComboBox(windows['actionWindow'], '20%', '5%', '80%', '5%', actionFilterList, selectFilter)
	actionTypeComboBox = addComboBox(windows['actionWindow'], '20%', '10%', '80%', '5%', {}, selectActionType)
	actionScrollPanel = addScrollPanel(windows['actionWindow'], '0%', '15%', '100%', '85%')
	actionTextBox = addTextBox(actionScrollPanel, '5%', 20, '90%', 100, "")
	actionTextBox.font.shadow = false
	
	-- Configure event window
	windows['configureEvent'] = addWindow(Screen0, '60%', '5%', '30%', '80%')
	local closeConfigure = addButton(windows['configureEvent'], '93%', '0%', '7%', '4%', "X", configureEvent)
	closeConfigure.font.color = { 1, 0, 0, 1 }
	configureEventLabel = addLabel(windows['configureEvent'], '0%', '1%', '100%', '5%', EDITOR_TRIGGERS_EVENTS_CONFIGURE, 20, "center", nil, "center")
	-- Trigger
	addLabel(windows['configureEvent'], '0%', '6%', '100%', '5%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER, 20, "left", nil, "center")
	customTriggerEditBox = addEditBox(windows['configureEvent'], '0%', '11%', '100%', '3%', "left", "")
	customTriggerEditBox.hint = EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_EXAMPLE
	local useDefaultTrigger = function()
		if currentEvent then
			local e = events[currentEvent]
			local trig = ""
			for i, c in ipairs(e.conditions) do
				trig = trig..c.name
				if i ~= #(e.conditions) then
					trig = trig.." and "
				end
			end
			e.trigger = trig
			customTriggerEditBox:SetText(trig)
			currentTriggerLabel:SetCaption(EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CURRENT.."\255\0\255\204"..trig)
		end
		saveState()
	end
	local useCustomTrigger = function()
		if currentEvent then
			local e = events[currentEvent]
			local validTrigger = false
			local checkingTrigger = customTriggerEditBox.text
			local count = 0
			for i, c in ipairs(e.conditions) do
				checkingTrigger = string.gsub(checkingTrigger, c.name, "")
			end
			checkingTrigger = string.gsub(checkingTrigger, ".", function(c) if c == "(" then count = count + 1 return "" elseif c == ")" then count = count - 1 return "" end return c end)
			checkingTrigger = string.gsub(checkingTrigger, "or", "")
			checkingTrigger = string.gsub(checkingTrigger, "and", "")
			checkingTrigger = string.gsub(checkingTrigger, "not", "")
			checkingTrigger = string.gsub(checkingTrigger, " ", "")
			if count == 0 and checkingTrigger == "" then
				validTrigger = true
			end
			if validTrigger then
				checkingTrigger = customTriggerEditBox.text
				for i, c in ipairs(e.conditions) do
					checkingTrigger = string.gsub(checkingTrigger, c.name, "true")
				end
				if pcall(loadstring("return "..checkingTrigger)) then
					e.trigger = customTriggerEditBox.text
					currentTriggerLabel:SetCaption(EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CURRENT.."\255\0\255\204"..e.trigger)
				else
					currentTriggerLabel:SetCaption(EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CURRENT.."\255\255\0\0"..EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_NOT_VALID)
				end
			else
				currentTriggerLabel:SetCaption(EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CURRENT.."\255\255\0\0"..EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_NOT_VALID)
			end
		end
		saveState()
	end
	currentTriggerLabel = addLabel(windows['configureEvent'], '2%', '19%', '96%', '2%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CURRENT, 13, "left")
	customTriggerButton = addButton(windows['configureEvent'], '0%', '14%', '50%', '5%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CUSTOM, useCustomTrigger)
	defaultTriggerButton = addButton(windows['configureEvent'], '50%', '14%', '50%', '5%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_DEFAULT, useDefaultTrigger)
	-- Action sequence
	addLabel(windows['configureEvent'], '0%', '25%', '100%', '5%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_ACTION_SEQUENCE, 20, "center", nil, "center")
	actionSequenceScrollPanel = addScrollPanel(windows['configureEvent'], '25%', '30%', '50%', '40%')
	-- Other parameters
	addLabel(windows['configureEvent'], '0%', '75%', '100%', '5%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_OTHER, 20, "center", nil, "center")
	addLabel(windows['configureEvent'], '5%', '80%', '20%', '5%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION, 20, "left", nil, "center")
	addLabel(windows['configureEvent'], '5%', '90%', '20%', '5%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_COMMENT, 20, "left", nil, "center")
	
	-- Import Actions/Conditions window
	windows["importWindow"] = addWindow(Screen0, "30%", "86%", "30%", "10%")
	addLabel(windows["importWindow"], '0%', '0%', '100%', '20%', EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT, 16, "left", nil, "center")
	importEventComboBox = addComboBox(windows["importWindow"], '0%', '20%', tostring(100/3).."%", "80%", {}, nil)
	importConditionComboBox = addComboBox(windows["importWindow"], tostring(100/3).."%", '20%', tostring(100/3).."%", "40%", {}, nil)
	addButton(windows["importWindow"], tostring(200/3).."%", '20%', tostring(100/3).."%", "40%", EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT_CONDITION, importCondition)
	importActionComboBox = addComboBox(windows["importWindow"], tostring(100/3).."%", '60%', tostring(100/3).."%", "40%", {}, nil)
	addButton(windows["importWindow"], tostring(200/3).."%", '60%', tostring(100/3).."%", "40%", EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT_ACTION, importAction)
	importEventComboBox.OnSelect = { updateImportComboBoxes }

	-- Variables window
	windows["variablesWindow"] = addWindow(Screen0, '30%', '5%', '60%', '80%')
	local closeVariables = addButton(windows['variablesWindow'], '97%', '0%', '3%', '4%', "X", showVariablesFrame)
	closeVariables.font.color = { 1, 0, 0, 1 }
	addLabel(windows["variablesWindow"], '0%', '1%', '100%', '5%', EDITOR_TRIGGERS_VARIABLES, 20, "center", nil, "center")
	variablesScrollPanel = addScrollPanel(windows["variablesWindow"], '2%', '7%', '96%', '91%')
	newVariableButton = addButton(variablesScrollPanel, '0%', 0, '100%', 40, EDITOR_TRIGGERS_VARIABLES_NEW, addVariable)
end

function initMapSettingsWindow()
	windows['mapSettingsWindow'] = addWindow(Screen0, '20%', '25%', '60%', '50%', true)
	local closeButton = addButton(windows['mapSettingsWindow'], '95%', '0%', '5%', '7%', "X", mapSettingsFrame)
	closeButton.font.color = { 1, 0, 0, 1 }
	addLabel(windows['mapSettingsWindow'], '0%', '0%', '100%', '5%', EDITOR_MAPSETTINGS, 20, "center", nil, "center")
	addLabel(windows['mapSettingsWindow'], '0%', '10%', '10%', '10%', EDITOR_MAPSETTINGS_MAP_NAME, 16, "center", nil, "center")
	mapNameEditBox = addEditBox(windows['mapSettingsWindow'], '10%', '10%', '85%', '10%')
	addLabel(windows['mapSettingsWindow'], '0%', '25%', '100%', '5%', EDITOR_MAPSETTINGS_MAP_BRIEFING, 20, "center", nil, "center")
	mapBriefingEditBox = addEditBox(windows['mapSettingsWindow'], '2%', '30%', '96%', '5%')
	local panel = addScrollPanel(windows['mapSettingsWindow'], '2%', '45%', '96%', '30%')
	mapBriefingTextBox = addTextBox(panel, '2%', '7%', '96%', '86%', "Lorem ipsum blabla", 18)
	mapBriefingTextBox.font.shadow = false
	
	local colorUI = {}
	colorUI.red = addTrackbar(windows['mapSettingsWindow'], '5%', '37%', "20%", "5%", 0, 1, 1, 0.02)
	colorUI.green = addTrackbar(windows['mapSettingsWindow'], '25%', '37%', "20%", "5%", 0, 1, 0, 0.02)
	colorUI.blue = addTrackbar(windows['mapSettingsWindow'], '45%', '37%', "20%", "5%", 0, 1, 0, 0.02)
	colorUI.previewImage = addImage(windows['mapSettingsWindow'], '67%', '37%', '6%', '5%', "bitmaps/editor/blank.png", false, {1, 0, 0, 1})
	colorUI.button = addButton(windows['mapSettingsWindow'], '75%', '37%', '20%', '5%', EDITOR_MAPSETTINGS_MAP_BRIEFING_COLOR)
	
	local function updateImage()
		colorUI.previewImage.color = { colorUI.red.value, colorUI.green.value, colorUI.blue.value, 1 }
		colorUI.previewImage:InvalidateSelf()
	end
	colorUI.red.color = {1, 0, 0, 1}
	colorUI.red.OnChange = {updateImage}
	colorUI.green.color = {0, 1, 0, 1}
	colorUI.green.OnChange = {updateImage}
	colorUI.blue.color = {0, 0, 1, 1}
	colorUI.blue.OnChange = {updateImage}
	local function applyColor()
		local selStart, selEnd = mapBriefingEditBox.selStart, mapBriefingEditBox.selEnd
		if not (selStart and selEnd) then return end
		if selStart > selEnd then selStart, selEnd = selEnd, selStart end
		local hexColor = "/#"..DEC_HEX(colorUI.red.value*255)..DEC_HEX(colorUI.green.value*255)..DEC_HEX(colorUI.blue.value*255).."#"
		local txt = mapBriefingEditBox.text
		txt = string.sub(txt, 1, selEnd - 1) .. "/" .. string.sub(txt, selEnd, #txt)
		txt = string.sub(txt, 1, selStart - 1) .. hexColor .. string.sub(txt, selStart, #txt)
		mapBriefingEditBox:SetText(txt)
	end
	colorUI.button.OnClick = {applyColor}
	
	mapSettingsButtons.cameraAutoButton = addButton(windows['mapSettingsWindow'], '2%', '76%', '30%', '8%', EDITOR_MAPSETTINGS_CAMERA_AUTO_ENABLED)
	mapSettingsButtons.cameraAutoButton.OnClick = {
		function()
			if mapSettingsButtons.cameraAutoButton.caption == EDITOR_MAPSETTINGS_CAMERA_AUTO_ENABLED then
				mapSettingsButtons.cameraAutoButton:SetCaption(EDITOR_MAPSETTINGS_CAMERA_AUTO_DISABLED)
				cameraAutoState = "disabled"
			else
				mapSettingsButtons.cameraAutoButton:SetCaption(EDITOR_MAPSETTINGS_CAMERA_AUTO_ENABLED)
				cameraAutoState = "enabled"
			end
		end
	}
	
	mapSettingsButtons.autoHealButton = addButton(windows['mapSettingsWindow'], '35%', '80%', '30%', '8%', EDITOR_MAPSETTINGS_HEAL_AUTO_DISABLED)
	mapSettingsButtons.autoHealButton.OnClick = {
		function()
			if mapSettingsButtons.autoHealButton.caption == EDITOR_MAPSETTINGS_HEAL_AUTO_ENABLED then
				mapSettingsButtons.autoHealButton:SetCaption(EDITOR_MAPSETTINGS_HEAL_AUTO_DISABLED)
				autoHealState = "disabled"
			else
				mapSettingsButtons.autoHealButton:SetCaption(EDITOR_MAPSETTINGS_HEAL_AUTO_ENABLED)
				autoHealState = "enabled"
			end
		end
	}
	
	mapSettingsButtons.mouseStateButton = addButton(windows['mapSettingsWindow'], '2%', '84%', '30%', '8%', EDITOR_MAPSETTINGS_MOUSE_DISABLED)
	mapSettingsButtons.mouseStateButton.OnClick = {
		function()
			if mapSettingsButtons.mouseStateButton.caption == EDITOR_MAPSETTINGS_MOUSE_ENABLED then
				mapSettingsButtons.mouseStateButton:SetCaption(EDITOR_MAPSETTINGS_MOUSE_DISABLED)
				mouseState = "disabled"
			else
				mapSettingsButtons.mouseStateButton:SetCaption(EDITOR_MAPSETTINGS_MOUSE_ENABLED)
				mouseState = "enabled"
			end
		end
	}
	
	mapSettingsButtons.minimapButton = addButton(windows['mapSettingsWindow'], '35%', '90%', '30%', '8%', EDITOR_MAPSETTINGS_MINIMAP_DISABLED)
	mapSettingsButtons.minimapButton.OnClick = {
		function()
			if mapSettingsButtons.minimapButton.caption == EDITOR_MAPSETTINGS_MINIMAP_ENABLED then
				mapSettingsButtons.minimapButton:SetCaption(EDITOR_MAPSETTINGS_MINIMAP_DISABLED)
				minimapState = "disabled"
			else
				mapSettingsButtons.minimapButton:SetCaption(EDITOR_MAPSETTINGS_MINIMAP_ENABLED)
				minimapState = "enabled"
			end
		end
	}
	
	mapSettingsButtons.feedbackButton = addButton(windows['mapSettingsWindow'], '2%', '92%', '30%', '8%', EDITOR_MAPSETTINGS_FEEDBACK_DISABLED)
	mapSettingsButtons.feedbackButton.OnClick = {
		function()
			if mapSettingsButtons.feedbackButton.caption == EDITOR_MAPSETTINGS_FEEDBACK_ENABLED then
				mapSettingsButtons.feedbackButton:SetCaption(EDITOR_MAPSETTINGS_FEEDBACK_DISABLED)
				feedbackState = "disabled"
			else
				mapSettingsButtons.feedbackButton:SetCaption(EDITOR_MAPSETTINGS_FEEDBACK_ENABLED)
				feedbackState = "enabled"
			end
		end
	}
	
	mapSettingsButtons.widgetsButton = addButton(windows['mapSettingsWindow'], '68%', '80%', '30%', '18%',  EDITOR_MAPSETTINGS_WIDGETS, showWidgetsWindow)
end

function initUnitFunctions() -- Creates a function for every unitState to change state and handle selection feedback
	for k, u in pairs(unitStateMachine.states) do
		unitFunctions[u] = function()
			globalStateMachine:setCurrentState(globalStateMachine.states.UNIT)
			unitStateMachine:setCurrentState(u)
			Spring.SelectUnitArray({})
		end
	end
end

function initTeamFunctions() -- Creates a function for every teamState to change state and handle selection feedback
	for k, t in pairs(teamStateMachine.states) do
		teamFunctions[t] = function()
			globalStateMachine:setCurrentState(globalStateMachine.states.UNIT)
			teamStateMachine:setCurrentState(t)
			Spring.SelectUnitArray({})
		end
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Unit/Selection state functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --



function updateUnitWindow() -- Display buttons to choose the type of the unit the user wants to instanciate.
	removeElements(unitScrollPanel, unitButtons, true)
	local button_size = 40
	local y = 0
	for c, t in ipairs(factionUnits) do
		factionButtons[c].y = y
		y = y + button_size
		if factionButtons[c].state.chosen then -- Show unit buttons that belong to a faction which button is chosen
			for i, u in ipairs(t) do
				unitButtons[u] = addButton(unitScrollPanel, '10%', y, '80%', button_size, UnitDefNames[u].humanName, unitFunctions[u])
				y = y + button_size
			end
		end
	end
end

function applyChangesToSelectedUnits() -- Apply changes to units attributes
	local unitSelection = Spring.GetSelectedUnits()
	for i, u in ipairs(unitSelection) do
		unitHP[u] = tonumber(changeHPEditBox.text)
		if autoHealComboBox.items[autoHealComboBox.selected] == EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_GLOBAL then
			unitAutoHeal[u] = "global"
		elseif autoHealComboBox.items[autoHealComboBox.selected] == EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_ENABLED	then
			unitAutoHeal[u] = "enabled"
		elseif autoHealComboBox.items[autoHealComboBox.selected] == EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_DISABLED then
			unitAutoHeal[u] = "disabled"
		end
	end
	for k, n in pairs(teamName) do
		if teamComboBox.items[teamComboBox.selected] == n then
			Spring.SendLuaRulesMsg("Transfer Units".."++"..k)
			break
		end
	end
	clearTemporaryWindows()
end

function drawSelectionRect() -- Draw the selection feedback rectangle
	if selectionRect ~= nil then
		Screen0:RemoveChild(selectionRect)
		selectionRect:Dispose()
	end
	if plotSelection then -- only draw it when mouse button 1 is down and global state is selection
		-- to draw the rectangle, we need the x and y of the top-left corner and the x and y of the bottom-right corner of the rectangle
		-- be careful about anchors : spring's and openGL's (0,0) is bottom-left corner whereas Chili's (0,0) is top-left corner !
		local x1, x2, y1, y2 = 0, 0, screenSizeY, screenSizeY
		if (drawStartX <= drawEndX and drawStartY <= drawEndY) then
			x1 = drawStartX
			y1 = screenSizeY - drawEndY
			x2 = drawEndX
			y2 = screenSizeY - drawStartY
		elseif (drawStartX <= drawEndX and drawStartY >= drawEndY) then
			x1 = drawStartX
			y1 = screenSizeY - drawStartY
			x2 = drawEndX
			y2 = screenSizeY - drawEndY
		elseif (drawStartX >= drawEndX and drawStartY <= drawEndY) then
			x1 = drawEndX
			y1 = screenSizeY - drawEndY
			x2 = drawStartX
			y2 = screenSizeY - drawStartY
		elseif (drawStartX >= drawEndX and drawStartY >= drawEndY) then
			x1 = drawEndX
			y1 = screenSizeY - drawStartY
			x2 = drawStartX
			y2 = screenSizeY - drawEndY
		end
		-- draw the rectangle
		selectionRect = addRect(Screen0, x1, y1, x2, y2, {0, 1, 1, 0.3})
	end
end

function previewUnit()-- Draw units before placing them
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and unitStateMachine:getCurrentState() ~= unitStateMachine.states.UNITGROUPS and unitStateMachine:getCurrentState() ~= unitStateMachine.states.SELECTION and not Screen0.hoveredControl then
		local mx, my = Spring.GetMouseState()
		local kind, coords = Spring.TraceScreenRay(mx, my)
		if kind == "ground" then -- only draw if unit is placeable
			local x, _, z = unpack(coords)
			local unitDefID = UnitDefNames[unitStateMachine:getCurrentState()].id
			gl.DepthTest(GL.LEQUAL) -- prevents depth bug (~ reverted normals)
			gl.DepthMask(true) -- same
			gl.PushMatrix()
			gl.Color(1, 1, 1, 0.7) -- a bit of transparency
			gl.Translate(x, Spring.GetGroundHeight(x,z), z)
			gl.UnitShape(unitDefID, teamStateMachine:getCurrentState())
			gl.PopMatrix()
			gl.DepthTest(false) -- return to normal state
			gl.DepthMask(false)
		end
	end
end

function showUnitAttributes() -- Show a window to edit unit's instance attributes
	clearTemporaryWindows()
	local unitSelection = Spring.GetSelectedUnits()
	unitAttributesWindow = addWindow(Screen0, '75%', '5%', '10%', '40%', true)
	addLabel(unitAttributesWindow, '0%', 0, "100%", 20, EDITOR_UNITS_EDIT_ATTRIBUTES, 20)
	-- HP
	addLabel(unitAttributesWindow, '0%', 50, "30%", 20, EDITOR_UNITS_EDIT_ATTRIBUTES_HP.."%", 20, "right")
	local hpPercent = ""
	for i, u in ipairs(unitSelection) do
		if i == 1 and unitHP[u] then
			hpPercent = tostring(unitHP[u])
		end
		if hpPercent ~= tostring(unitHP[u]) then -- only initialize this field if every unit of the selection have the same value
			hpPercent = ""
			break
		end
	end
	changeHPEditBox = addEditBox(unitAttributesWindow, "35%", 50, "65%", 20, "left", hpPercent)
	-- AutoHeal
	addLabel(unitAttributesWindow, '0%', 100, '100%', 20, EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL, 20, "center")
	autoHealComboBox = addComboBox(unitAttributesWindow, "0%", 120, "100%", 30, { EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_GLOBAL, EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_ENABLED, EDITOR_UNITS_EDIT_ATTRIBUTES_AUTO_HEAL_DISABLED })
	local autoHealStatus = ""
	for i, u in ipairs(unitSelection) do
		if i == 1 and unitAutoHeal[u] then
			autoHealStatus = unitAutoHeal[u]
		end
		if autoHealStatus ~= unitAutoHeal[u] then -- only initialize this field if every unit of the selection have the same value
			autoHealStatus = ""
			break
		end
	end
	if autoHealStatus == "enabled" then
		autoHealComboBox:Select(2)
	elseif autoHealStatus == "disabled" then
		autoHealComboBox:Select(3)
	else
		autoHealComboBox:Select(1)
	end
	-- Team
	addLabel(unitAttributesWindow, '0%', 180, '100%', 20, EDITOR_UNITS_EDIT_ATTRIBUTES_TEAM, 20, "center")
	local comboBoxItems = {}
	for k, t in pairs(teamStateMachine.states) do
		if enabledTeams[t] then
			table.insert(comboBoxItems, teamName[t])
		end
	end
	teamComboBox = addComboBox(unitAttributesWindow, '0%', 200, '100%', 30, comboBoxItems)
	local team = Spring.GetUnitTeam(unitSelection[1])
	for i, t in ipairs(comboBoxItems) do
		if t == teamName[team] then
			teamComboBox:Select(i) -- initialize this field to the team of the first unit
			break
		end
	end
	-- Apply
	addButton(unitAttributesWindow, 0, "85%", "100%", "15%", EDITOR_UNITS_EDIT_ATTRIBUTES_APPLY, applyChangesToSelectedUnits)
end

function showUnitsInformation() -- Show information (ID and position) about selected and hovered units
	gl.BeginText()
	local unitSelection = Spring.GetSelectedUnits()
	for i, u in ipairs(unitSelection) do
		showUnitInformation(u)
	end
	
	-- Draw information above hovered unit
	local mx, my = Spring.GetMouseState()
	local kind, var = Spring.TraceScreenRay(mx, my)
	if kind == "unit" then
		if not Spring.IsUnitSelected(var) then
			showUnitInformation(var)
		end
	end
	gl.EndText()
end

function showUnitGroupsAttributionWindow() -- Show a small window allowing to add the current selection to an existing or new group
	clearTemporaryWindows()
	unitGroupsAttributionWindow = addWindow(Screen0, '75%', '5%', '10%', '40%', true)
	local attributionWindowScrollPanel = addScrollPanel(unitGroupsAttributionWindow, '0%', '0%', '100%', '100%')
	
	local count = 0
	for i, group in ipairs(unitGroups) do -- Show already created unit groups
		local function addToGroup()
			addSelectedUnitsToGroup(group)
			clearTemporaryWindows()
		end
		addButton(attributionWindowScrollPanel, '0%', count * 40, '100%', 40, group.name, addToGroup) -- Add unit selection to this group
		count = count + 1
	end
	
	newUnitGroupEditBox = addEditBox(attributionWindowScrollPanel, '0%', count * 40, '80%', 40, "left", "") -- Allow the creation of a new group
	newUnitGroupEditBox.font.size = 14
	newUnitGroupEditBox.hint = EDITOR_UNITS_GROUPS_NEW
	local function newGroup()
		if newUnitGroupEditBox.text ~= "" then
			addUnitGroup(newUnitGroupEditBox.text)
			clearTemporaryWindows()
		end
	end
	local newUnitValidationButton = addButton(attributionWindowScrollPanel, '80%', count * 40, '20%', 40, EDITOR_OK, newGroup)
end

function showUnitGroupsRemovalWindow() -- Show a small window allowing to remove the current selection from a group
	clearTemporaryWindows()
	unitGroupsRemovalWindow = addWindow(Screen0, '75%', '5%', '10%', '40%', true)
	local removalWindowScrollPanel = addScrollPanel(unitGroupsRemovalWindow, '0%', '0%', '100%', '100%')
	
	local noGroupsInCommon = true
	local unitSelection = Spring.GetSelectedUnits()
	
	local count = 0
	for i, group in ipairs(unitGroups) do
		local addUnitGroupButton = true
		for i, u in ipairs(unitSelection) do
			if not findInTable(group.units, u) then
				addUnitGroupButton = false -- Only display groups that are common to every units of the current selection
				break
			end
		end
		if addUnitGroupButton then
			local function removeFromGroup()
				removeSelectedUnitsFromGroup(group)
				clearTemporaryWindows()
			end
			addButton(removalWindowScrollPanel, '0%', count * 40, '100%', 40, group.name, removeFromGroup) -- Remove unit selection from this group
			count = count + 1
			noGroupsInCommon = false
		end
	end
	
	if noGroupsInCommon then -- If units have to groups in common or the selected unit does not belong to any group, display a specific message
		unitGroupsRemovalWindow:RemoveChild(removalWindowScrollPanel)
		local text = EDITOR_UNITS_GROUPS_NO_COMMON_GROUP
		if #unitSelection == 1 then
			text = EDITOR_UNITS_GROUPS_NO_GROUP
		end
		addTextBox(unitGroupsRemovalWindow, '0%', '0%', '100%', '100%', text, 20, {1, 0, 0, 1})
	end
end

function updateSelectTeamButtons() -- Update the buttons used to select a team before instanciating a unit
	if updateTeamButtons then
		removeElements(windows["unitWindow"], teamButtons, true)
		local count = 0
		local enabledTeamsCount = 0 -- count the number of enabled teams
		for k, enabled in pairs(enabledTeams) do
			if enabled then
				enabledTeamsCount = enabledTeamsCount + 1
			end
		end
		for i, team in ipairs(teamStateMachine.states) do
			if enabledTeams[team] then
				local x = tostring(count * 100 / math.ceil(enabledTeamsCount/2) - 100 * math.floor(count/math.ceil(enabledTeamsCount/2))).."%"
				local y = tostring(90 + 5 * math.floor(count/math.ceil(enabledTeamsCount/2))).."%"
				local w = tostring(100 / math.ceil(enabledTeamsCount/2)).."%"
				local h = "5%"
				local color = {teams[team].red, teams[team].green, teams[team].blue, 1}
				teamButtons[team] = addButton(windows["unitWindow"], x, y, w, h, "", teamFunctions[team])
				teamImages[team] = addImage(teamButtons[team], "0%", "0%", "100%", "100%", "bitmaps/editor/blank.png", false, color)
				teamLabels[team] = addLabel(teamImages[team], "0%", "0%", "100%", "100%", team, 15, "center", nil, "center")
				count = count + 1
			end
		end
		updateTeamButtons = false
	end
end

function updateUnitList(forceUpdate) -- When a unit is created, update the left unit list
	local units = Spring.GetAllUnits()
	if units.n ~= unitTotal or forceUpdate then
		-- Clear UI elements
		removeElements(unitListScrollPanel, unitListLabels, true)
		removeElements(unitListScrollPanel, unitListViewButtons, true)
		removeElements(unitListScrollPanel, unitListHighlight, true)
		
		-- Add labels and buttons to both lists
		local count = 0
		for i, u in ipairs(units) do
			-- Unit label (type, team and id)
			local uDefID = Spring.GetUnitDefID(u)
			local name = UnitDefs[uDefID].humanName
			local team = Spring.GetUnitTeam(u)
			unitListLabels[u] = addLabel(unitListScrollPanel, '0%', 30 * count, '85%', 30, name.." ("..tostring(u)..")", 16, "left", {teams[team].red, teams[team].green, teams[team].blue, 1}, "center")
			
			-- Eye button to focus a specific unit
			local function viewUnit()
				local state = Spring.GetCameraState()
				local x, y, z = Spring.GetUnitPosition(u)
				state.px, state.py, state.pz = x, y, z
				state.height = 500
				Spring.SetCameraState(state, 2)
				Spring.SelectUnitArray({u})
				unitStateMachine:setCurrentState(unitStateMachine.states.SELECTION)
			end
			unitListViewButtons[u] = addButton(unitListScrollPanel, '85%', 30 * count, '15%', 30, "", viewUnit)
			addImage(unitListViewButtons[u], '0%', '0%', '100%', '100%', "bitmaps/editor/eye.png", true, {0, 1, 1, 1})
			
			-- Highlight
			unitListHighlight[u] = addImage(unitListScrollPanel, '0%', 30 * count, '100%', 30, "bitmaps/editor/blank.png", false, {1, 1, 0.4, 0})
			
			count = count + 1
		end
		unitTotal = units.n
	end
end

function updateGroupListUnitList() -- When a unit is created, update group frame unit list
	local units = Spring.GetAllUnits()
	if units.n ~= unitGroupsUnitTotal then
		-- Clear UI elements
		removeElements(groupListUnitsScrollPanel, groupListUnitsButtons, true)
		removeElements(groupListUnitsScrollPanel, groupListUnitsViewButtons, true)
		
		-- Add labels and buttons to both lists
		local count = 0
		for i, u in ipairs(units) do
			Spring.Echo(u)
			-- Unit label (type, team and id)
			local uDefID = Spring.GetUnitDefID(u)
			local name = UnitDefs[uDefID].humanName
			local team = Spring.GetUnitTeam(u)
			groupListUnitsButtons[u] = addButton(groupListUnitsScrollPanel, '0%', 30 * count, '85%', 30, name.." ("..tostring(u)..")", function() groupListUnitsButtons[u].state.chosen = not groupListUnitsButtons[u].state.chosen groupListUnitsButtons[u]:InvalidateSelf() end)
			groupListUnitsButtons[u].font.size = 16
			groupListUnitsButtons[u].font.color = {teams[team].red, teams[team].green, teams[team].blue, 1}
			
			-- Eye button to focus a specific unit
			local function viewUnit()
				local state = Spring.GetCameraState()
				local x, y, z = Spring.GetUnitPosition(u)
				state.px, state.py, state.pz = x, y, z
				state.height = 500
				Spring.SetCameraState(state, 2)
				Spring.SelectUnitArray({u})
			end
			groupListUnitsViewButtons[u] = addButton(groupListUnitsScrollPanel, '85%', 30 * count, '15%', 30, "", viewUnit)
			addImage(groupListUnitsViewButtons[u], '0%', '0%', '100%', '100%', "bitmaps/editor/eye.png", true, {0, 1, 1, 1})

			count = count + 1
		end
		unitGroupsUnitTotal = units.n
	end
end

function updateUnitHighlights() -- Visual feedback on the units list to see what units are selected
	local units = Spring.GetAllUnits()
	for i, u in ipairs(units) do
		if unitListHighlight[u] then
			if Spring.IsUnitSelected(u) then
				unitListHighlight[u].color = {1, 1, 0.4, 0.2}
				unitListHighlight[u]:InvalidateSelf()
			else
				unitListHighlight[u].color = {1, 1, 0.4, 0}
				unitListHighlight[u]:InvalidateSelf()
			end
		end
	end
end

function updateUnitGroupPanels() -- Update groups when a group is created/removed or a unit is added to/removed from a group
	-- Check if update is mandatory
	local updatePanels = false
	if #unitGroups ~= groupTotal then -- Group count changed
		updatePanels = true
	end
	for i, group in ipairs(unitGroups) do
		if tableLength(group.units) ~= groupSizes[group.id] then -- Unit count of a group changed
			updatePanels = true
			break
		end
	end
	
	-- Update
	if updatePanels then
		-- Clear UI elements
		removeElements(groupListScrollPanel, groupPanels, true)
		groupListScrollPanel:RemoveChild(addGroupButton)
		
		local count = 0
		local heights = {0, 0, 0, 0} -- Stores heights to place groups on the lower
		local widths = {0, 0, 0, 0} -- Stores corresponding widths
		for i, group in ipairs(unitGroups) do
			local x, y
			-- Compute x and y depending on the number of groups
			-- Place the first four groups next to each other, and then place the following under the column with the least height
			if count < 4 then
				x = 300 * count
				y = 0
				count = count + 1
				heights[count] = 65 + 30 * tableLength(group.units)
				widths[count] = 300 * (count - 1)
			else
				local column = minOfTable(heights)
				x = widths[column]
				y = heights[column]
				heights[column] = heights[column] + 65 + 30 * tableLength(group.units)
			end
			-- Add panel, editbox, buttons
			groupPanels[group.id] = addPanel(groupListScrollPanel, x, y, 300, 60 + 30 * tableLength(group.units))
			selectGroupButtons[group.id] = addButton(groupPanels[group.id], 0, 0, 30, 30, "", function() selectGroupButtons[group.id].state.chosen = not selectGroupButtons[group.id].state.chosen selectGroupButtons[group.id]:InvalidateSelf() end)
			groupEditBoxes[group.id] = addEditBox(groupPanels[group.id], 35, 5, 220, 20, "left", group.name)
			groupEditBoxes[group.id].font.size = 14
			local deleteButton = addButton(groupPanels[group.id], 260, 0, 30, 30, EDITOR_X, function() deleteUnitGroup(group.id) end)
			deleteButton.font.color = {1, 0, 0, 1}
		end
		-- Add a button to create an empty group
		local x, y
		if count < 4 then
			x = 300 * count
			y = 0
		else
			local column = minOfTable(heights)
			x = widths[column]
			y = heights[column]
		end
		addGroupButton = addButton(groupListScrollPanel, x, y, 300, 60, EDITOR_UNITS_GROUPS_ADD, addEmptyUnitGroup)
		groupTotal = #unitGroups
		
		-- Update groups
		for i, group in ipairs(unitGroups) do
			-- Clear UI elements
			removeElements(groupPanels[group.id], unitGroupLabels[group.id], true)
			removeElements(groupPanels[group.id], unitGroupViewButtons[group.id], true)
			removeElements(groupPanels[group.id], unitGroupRemoveUnitButtons[group.id], true)
			
			local count = 0
			unitGroupLabels[group.id] = {}
			unitGroupViewButtons[group.id] = {}
			for key, u in pairs(group.units) do
				-- Remove button
				local removeButton = addButton(groupPanels[group.id], '5%', 40 + 30 * count, '10%', 30, EDITOR_X, function() removeUnitFromGroup(group, u) end)
				removeButton.font.color = {1, 0, 0, 1}
				table.insert(unitGroupRemoveUnitButtons[group.id], removeButton)
				
				-- Label of unit
				local uDefID = Spring.GetUnitDefID(u)
				local name = UnitDefs[uDefID].humanName
				local team = Spring.GetUnitTeam(u)
				local label = addLabel(groupPanels[group.id], '20%', 40 + 30 * count, '75%', 30, name.." ("..tostring(u)..")", 15, "left", {teams[team].red, teams[team].green, teams[team].blue, 1}, "center")
				table.insert(unitGroupLabels[group.id], label)
				
				-- Eye button to focus a specific unit
				local function viewUnit()
					local state = Spring.GetCameraState()
					local x, y, z = Spring.GetUnitPosition(u)
					state.px, state.py, state.pz = x, y, z
					state.height = 500
					Spring.SetCameraState(state, 2)
					Spring.SelectUnitArray({u})
				end
				local but = addButton(groupPanels[group.id], '80%', 40 + 30 * count, '15%', 30, "", viewUnit)
				addImage(but, '0%', '0%', '100%', '100%', "bitmaps/editor/eye.png", true, {0, 1, 1, 1})
				table.insert(unitGroupViewButtons[group.id], but)
				
				count = count + 1
			end
			groupSizes[group.id] = tableLength(group.units)
		end
	end
	
	-- String in the editbox as name for the group
	for i, group in ipairs(unitGroups) do
		if group.name ~= groupEditBoxes[group.id].text and groupEditBoxes[group.id].text ~= "" then
			group.name = groupEditBoxes[group.id].text
		end
	end
end

function showGroupsWindow()
	Screen0:AddChild(windows["unitGroupsWindow"])
	for k, p in pairs(groupPanels) do
		p:InvalidateSelf()
	end
	Screen0:RemoveChild(windows['unitListWindow'])
	Screen0:RemoveChild(windows['unitWindow'])
	updateGroupListUnitList()
	unitStateMachine:setCurrentState(unitStateMachine.states.UNITGROUPS)
end

function addUnitToGroup(group, unit)
	if group ~= nil then
		if not findInTable(group.units, unit) then
			table.insert(group.units, unit)
			table.sort(group.units)
		end
	end
end

function addSelectedUnitsToGroup(group)
	local unitSelection = Spring.GetSelectedUnits()
	for i, u in ipairs(unitSelection) do
		addUnitToGroup(group, u)
	end
	saveState()
end

function addChosenUnitsToSelectedGroups() -- Add selected units to the selected groups (in the groups frame)
	for groupKey, groupButton in pairs(selectGroupButtons) do
		if groupButton.state.chosen then
			for unitKey, unitButton in pairs(groupListUnitsButtons) do
				if unitButton.state.chosen then
					addUnitToGroup(unitGroups[groupKey], unitKey)
				end
			end
		end
		groupButton.state.chosen = false
		groupButton:InvalidateSelf()
	end
	for unitKey, unitButton in pairs(groupListUnitsButtons) do
		unitButton.state.chosen = false
		unitButton:InvalidateSelf()
	end
	saveState()
end

function removeSelectedUnitsFromGroup(group)
	local unitSelection = Spring.GetSelectedUnits()
	for i, u in ipairs(unitSelection) do
		removeUnitFromGroup(group, u)
	end
	saveState()
end

function removeUnitFromGroup(group, unit)
	local units = group.units
	for i, u in ipairs(units) do
		if u == unit then
			table.remove(units, i)
			break
		end
	end
	saveState()
end

function addUnitGroup(name)
	local unitSelection = Spring.GetSelectedUnits()
	local group = {}
	group.name = name
	group.units = {}
	group.id = groupNumber
	for i, u in ipairs(unitSelection) do
		addUnitToGroup(group, u)
	end
	table.insert(unitGroups, group)
	groupSizes[groupNumber] = 0
	unitGroupLabels[groupNumber] = {}
	unitGroupViewButtons[groupNumber] = {}
	unitGroupRemoveUnitButtons[groupNumber] = {}
	groupNumber = groupNumber + 1
	saveState()
end

function addEmptyUnitGroup()
	local group = {}
	group.name = EDITOR_UNITS_GROUPS_DEFAULT_NAME..groupNumber
	group.units = {}
	group.id = groupNumber
	table.insert(unitGroups, group)
	groupSizes[groupNumber] = 0
	unitGroupLabels[groupNumber] = {}
	unitGroupViewButtons[groupNumber] = {}
	unitGroupRemoveUnitButtons[groupNumber] = {}
	groupNumber = groupNumber + 1
	saveState()
end

function deleteUnitGroup(id)
	for i, g in ipairs(unitGroups) do
		if id == g.id then
			table.remove(unitGroups, i)
			break
		end
	end
	saveState()
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Zone state functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function computeZoneWorldCoords() -- Compute world coordinates of the mouse when drawing a zone
	local _,varA = Spring.TraceScreenRay(drawStartX, drawStartY, true, true) -- compute world's coords of the beginning of the draw
	local _, varB = Spring.TraceScreenRay(drawEndX, drawEndY, true, true) -- compute world's coords of the end of the draw
	if varA ~= nil and varB ~= nil then
		zonePositions.zoneX1, _, zonePositions.zoneZ1 = unpack(varA)
		zonePositions.zoneX2, _, zonePositions.zoneZ2 = unpack(varB)
	else
		zonePositions.zoneX1, zonePositions.zoneZ1, zonePositions.zoneX2, zonePositions.zoneZ2 = 0, 0, 0, 0
	end
	zonePositions.zoneX1, zonePositions.zoneX2 = sort(zonePositions.zoneX1, zonePositions.zoneX2) -- sort values to prevent errors
	zonePositions.zoneZ1, zonePositions.zoneZ2 = sort(zonePositions.zoneZ1, zonePositions.zoneZ2)
	
	local altPressed = Spring.GetModKeyState() -- force square if alt is pressed
	if altPressed then
		local length = math.min(zonePositions.zoneX2 - zonePositions.zoneX1, zonePositions.zoneZ2 - zonePositions.zoneZ1)
		if drawStartX > drawEndX then
			zonePositions.zoneX1 = zonePositions.zoneX2 - length
		else
			zonePositions.zoneX2 = zonePositions.zoneX1 + length
		end
		if drawStartY > drawEndY then
			zonePositions.zoneZ2 = zonePositions.zoneZ1 + length
		else
			zonePositions.zoneZ1 = zonePositions.zoneZ2 - length
		end
	end
end

function drawZoneRect() -- Draw the zone feedback rectangle
	if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWRECT then
		local _, _, leftPressed = Spring.GetMouseState()
		if leftPressed then -- if draw has to begin
			computeZoneWorldCoords()
			
			if plotZone then
				gl.Color(rValue, gValue, bValue, 0.5)
				gl.DrawGroundQuad(zonePositions.zoneX1, zonePositions.zoneZ1, zonePositions.zoneX2, zonePositions.zoneZ2) -- draw the zone
			end
		end
	end
end

function drawZoneDisk() -- Draw the zone feedback ellipsis
	if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWDISK then
		local _, _, leftPressed = Spring.GetMouseState()
		if leftPressed then -- if draw has to begin
			computeZoneWorldCoords()
			
			if plotZone then
				local a, b = (zonePositions.zoneX2 - zonePositions.zoneX1) / 2, (zonePositions.zoneZ2 - zonePositions.zoneZ1) /2
				local centerX, centerZ = (zonePositions.zoneX1 + zonePositions.zoneX2) / 2, (zonePositions.zoneZ1 + zonePositions.zoneZ2) / 2
				gl.Color(rValue, gValue, bValue, 0.5)
				drawGroundFilledEllipsis(centerX, centerZ, a, b, 50)
			end
		end
	end
end

function displayZones() -- Render every zones that are displayed
	for i, z in ipairs(zoneList) do 
		if z.shown and z.type == "Rectangle" then
			gl.Color(z.red, z.green, z.blue, 0.5)
			gl.DrawGroundQuad(z.x1, z.z1, z.x2, z.z2)
		elseif z.shown and z.type == "Disk" then
			gl.Color(z.red, z.green, z.blue, 0.5)
			drawGroundFilledEllipsis(z.x, z.z, z.a, z.b, 50)
		elseif not z.shown and z == selectedZone then
			selectedZone = nil -- Deselect hidden zone
		end
	end
end

function displaySelectedZoneAnchors() -- Render the border of the selected zone (in order to change its size)
	if selectedZone ~= nil then
		gl.Color(selectedZone.red, selectedZone.green, selectedZone.blue, 0.7)
		if selectedZone.type == "Rectangle" then
			gl.DrawGroundQuad(selectedZone.x1, selectedZone.z1, selectedZone.x1+8, selectedZone.z2)
			gl.DrawGroundQuad(selectedZone.x1, selectedZone.z1, selectedZone.x2, selectedZone.z1+8)
			gl.DrawGroundQuad(selectedZone.x2-8, selectedZone.z1, selectedZone.x2, selectedZone.z2)
			gl.DrawGroundQuad(selectedZone.x1, selectedZone.z2-8, selectedZone.x2, selectedZone.z2)
		elseif selectedZone.type == "Disk" then
			drawGroundEmptyEllipsis(selectedZone.x, selectedZone.z, selectedZone.a, selectedZone.b, 12, 50)
		end
	end
end

function showZoneInformation() -- Show each displayed zone name and top-left/bottom-right positions of selected zone
	gl.BeginText()
	if selectedZone ~= nil then -- Selected zone (coordinates)
		if selectedZone.type == "Rectangle" then
			local x, y = Spring.WorldToScreenCoords(selectedZone.x1, Spring.GetGroundHeight(selectedZone.x1, selectedZone.z1), selectedZone.z1)
			local text =  "("..tostring(selectedZone.x1)..", "..tostring(selectedZone.z1)..")"
			gl.Text(text, x, y, 15, "s")
			
			x, y = Spring.WorldToScreenCoords(selectedZone.x2, Spring.GetGroundHeight(selectedZone.x2, selectedZone.z2), selectedZone.z2)
			text =  "("..tostring(selectedZone.x2)..", "..tostring(selectedZone.z2)..")"
			gl.Text(text, x, y, 15, "s")
		elseif selectedZone.type == "Disk" then
			local x, y = Spring.WorldToScreenCoords(selectedZone.x - selectedZone.a, Spring.GetGroundHeight(selectedZone.x - selectedZone.a, selectedZone.z), selectedZone.z)
			local text =  tostring(selectedZone.x - selectedZone.a)
			gl.Text(text, x, y, 15, "s")
			
			x, y = Spring.WorldToScreenCoords(selectedZone.x + selectedZone.a, Spring.GetGroundHeight(selectedZone.x + selectedZone.a, selectedZone.z), selectedZone.z)
			text =  tostring(selectedZone.x + selectedZone.a)
			gl.Text(text, x, y, 15, "s")
			
			x, y = Spring.WorldToScreenCoords(selectedZone.x, Spring.GetGroundHeight(selectedZone.x, selectedZone.z + selectedZone.b), selectedZone.z + selectedZone.b)
			text =  tostring(selectedZone.z + selectedZone.b)
			gl.Text(text, x, y, 15, "s")
			
			x, y = Spring.WorldToScreenCoords(selectedZone.x, Spring.GetGroundHeight(selectedZone.x, selectedZone.z - selectedZone.b), selectedZone.z - selectedZone.b)
			text =  tostring(selectedZone.z - selectedZone.b)
			gl.Text(text, x, y, 15, "s")
		end
	end
	for i, z in ipairs(zoneList) do -- Every zones (name)
		if z.shown then
			local x, y
			if z.type == "Rectangle" then
				x, y = (z.x1 + z.x2) / 2, (z.z1 + z.z2) / 2
				x, y = Spring.WorldToScreenCoords(x, Spring.GetGroundHeight(x, y), y)
			elseif z.type == "Disk" then
				x, y = Spring.WorldToScreenCoords(z.x, Spring.GetGroundHeight(z.x, z.z), z.z)
			end
			local text = z.name
			local w, h = gl.GetTextWidth(text) * 15, gl.GetTextHeight(text) * 15
			x, y = x - w/2, y - h/2
			gl.Text(text, x, y, 15, "s")
		end
	end
	gl.EndText()
end

function updateZoneInformation() -- Change the name and the shown state of a zone
	for i, z in ipairs(zoneList) do
		if z.name ~= zoneBoxes[z.id].editBox.text then
			z.name = zoneBoxes[z.id].editBox.text
		end
		z.shown = zoneBoxes[z.id].checkbox.checked
	end
end

function getClickedZone(mx, my) -- Returns the clicked zone if it exists, else nil
	local kind, var = Spring.TraceScreenRay(mx, my, true, true)
	if var ~= nil then
		local x, _, z = unpack(var)
		for i, _ in ipairs(zoneList) do
			local index = 1 + ((i - 1 + zoneIndex) % #zoneList) -- circular selection (if the user clicks on a zone masked by the selected zone, select the first zone)
			local zone = zoneList[index]
			if zone.type == "Rectangle" then
				if x >= zone.x1 and x <= zone.x2 and z >= zone.z1 and z <= zone.z2 then -- check if we clicked in a zone
					zoneIndex = index
					return zone
				end
			elseif zone.type == "Disk" then
				if ((x - zone.x)*(x - zone.x)) / (zone.a*zone.a) + ((z - zone.z)*(z - zone.z)) / (zone.b*zone.b) <= 1 then -- check if we clicked in a zone
					zoneIndex = index
					return zone
				end
			end
		end
	end
	return nil
end

function getZoneSide(x, z) -- Returns the clicked side of the selected zone
	local side = ""
	if selectedZone.type == "Rectangle" then
		local left = x - selectedZone.x1
		local right = selectedZone.x2 - x
		local top = z - selectedZone.z1
		local bottom = selectedZone.z2 - z -- these variables represent the distance between where the user clicked and the borders of the selected zone
		if left >= 0 and left <= 8 then -- if this distance is less than 8, return the clicked border
			if top >= 0 and top <= 8 then
				side = "TOPLEFT"
			elseif bottom >= 0 and bottom <= 8 then
				side = "BOTLEFT"
			elseif top >= 0 and bottom >= 0 then
				side = "LEFT"
			end
		elseif right >= 0 and right <= 8 then
			if top >= 0 and top <= 8 then
				side = "TOPRIGHT"
			elseif bottom >= 0 and bottom <= 8 then
				side = "BOTRIGHT"
			elseif top >= 0 and bottom >= 0 then
				side = "RIGHT"
			end
		elseif top >= 0 and top <= 8 and left >= 0 and right >= 0 then
			side = "TOP"
		elseif bottom >= 0 and bottom <= 8 and left >= 0 and right >= 0 then
			side = "BOT"
		else
			side = "CENTER"
		end
	elseif selectedZone.type == "Disk" then
		local outer = (x-selectedZone.x)*(x-selectedZone.x)/(selectedZone.a*selectedZone.a) + (z-selectedZone.z)*(z-selectedZone.z)/(selectedZone.b*selectedZone.b)
		local inner = (x-selectedZone.x)*(x-selectedZone.x)/((selectedZone.a-12)*(selectedZone.a-12)) + (z-selectedZone.z)*(z-selectedZone.z)/((selectedZone.b-12)*(selectedZone.b-12))
		if outer <= 1 and inner >= 1 then -- in outer ellipsis and out of inner ellipsis (= in the border)
			if x > selectedZone.x and z > selectedZone.z then
				side = "BOTRIGHT"
			elseif x < selectedZone.x and z > selectedZone.z then
				side = "BOTLEFT"
			elseif x > selectedZone.x and z < selectedZone.z then
				side = "TOPRIGHT"
			elseif x < selectedZone.x and z < selectedZone.z then
				side = "TOPLEFT"
			end
		else
			side = "CENTER"
		end
	end
	return side
end

function applyChangesToSelectedZone(dx, dz) -- Move or resize the selected zone
	if dx == 0 and dz == 0 then return end
	if selectedZone.type == "Rectangle" then
		-- depending on the side clicked, apply modifications
		if zoneSide == "CENTER" then
			if selectedZone.x1 + dx > 0 and selectedZone.x2 + dx < Game.mapSizeX then
				selectedZone.x1 = selectedZone.x1 + dx
				selectedZone.x2 = selectedZone.x2 + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0) 	-- This recursive call has been made in order to make moving and resizing feel better user-wise (even if the user moves the mouse too fast). It also allows the zones to be expanded to the border of the map.
			end
			if selectedZone.z1 + dz > 0 and selectedZone.z2 + dz < Game.mapSizeZ then
				selectedZone.z1 = selectedZone.z1 + dz
				selectedZone.z2 = selectedZone.z2 + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
		elseif zoneSide == "LEFT" then
			if selectedZone.x1 + dx + minZoneSize <= selectedZone.x2 then
				selectedZone.x1 = selectedZone.x1 + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
		elseif zoneSide == "RIGHT" then
			if selectedZone.x1 - dx + minZoneSize <= selectedZone.x2 then
				selectedZone.x2 = selectedZone.x2 + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
		elseif zoneSide == "TOP" then
			if selectedZone.z1 + dz + minZoneSize <= selectedZone.z2 then
				selectedZone.z1 = selectedZone.z1 + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
		elseif zoneSide == "BOT" then
			if selectedZone.z1 - dz + minZoneSize <= selectedZone.z2 then
				selectedZone.z2 = selectedZone.z2 + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
		elseif zoneSide == "TOPLEFT" then
			if selectedZone.z1 + dz + minZoneSize <= selectedZone.z2 then
				selectedZone.z1 = selectedZone.z1 + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
			if selectedZone.x1 + dx + minZoneSize <= selectedZone.x2 then
				selectedZone.x1 = selectedZone.x1 + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
		elseif zoneSide == "BOTLEFT" then
			if selectedZone.z1 - dz + minZoneSize <= selectedZone.z2 then
				selectedZone.z2 = selectedZone.z2 + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
			if selectedZone.x1 + dx + minZoneSize <= selectedZone.x2 then
				selectedZone.x1 = selectedZone.x1 + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
		elseif zoneSide == "TOPRIGHT" then
			if selectedZone.z1 + dz + minZoneSize <= selectedZone.z2 then
				selectedZone.z1 = selectedZone.z1 + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
			if selectedZone.x1 - dx + minZoneSize <= selectedZone.x2 then
				selectedZone.x2 = selectedZone.x2 + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
		elseif zoneSide == "BOTRIGHT" then
			if selectedZone.z1 - dz + minZoneSize <= selectedZone.z2 then
				selectedZone.z2 = selectedZone.z2 + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
			if selectedZone.x1 - dx + minZoneSize <= selectedZone.x2 then
				selectedZone.x2 = selectedZone.x2 + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
		end
	elseif selectedZone.type == "Disk" then
		if zoneSide == "CENTER" then
			if selectedZone.x - selectedZone.a + dx > 0 and selectedZone.x + selectedZone.a + dx < Game.mapSizeX then
				selectedZone.x = selectedZone.x + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
			if selectedZone.z - selectedZone.b + dz > 0 and selectedZone.z + selectedZone.b + dz < Game.mapSizeZ then
				selectedZone.z = selectedZone.z + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
		elseif zoneSide == "TOPLEFT" then
			if 2*(selectedZone.a - dx) > minZoneSize and selectedZone.x - (selectedZone.a - dx) > 0 and selectedZone.x + (selectedZone.a - dx) < Game.mapSizeX then
				selectedZone.a = selectedZone.a - dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
			if 2*(selectedZone.b - dz) > minZoneSize and selectedZone.z - (selectedZone.b - dz) > 0 and selectedZone.z + (selectedZone.b - dz) < Game.mapSizeZ then
				selectedZone.b = selectedZone.b - dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
		elseif zoneSide == "TOPRIGHT" then
			if 2*(selectedZone.a + dx) > minZoneSize and selectedZone.x - (selectedZone.a + dx) > 0 and selectedZone.x + (selectedZone.a + dx) < Game.mapSizeX then
				selectedZone.a = selectedZone.a + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
			if 2*(selectedZone.b - dz) > minZoneSize and selectedZone.z - (selectedZone.b - dz) > 0 and selectedZone.z + (selectedZone.b - dz) < Game.mapSizeZ then
				selectedZone.b = selectedZone.b - dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
		elseif zoneSide == "BOTLEFT" then
			if 2*(selectedZone.a - dx) > minZoneSize and selectedZone.x - (selectedZone.a - dx) > 0 and selectedZone.x + (selectedZone.a - dx) < Game.mapSizeX then
				selectedZone.a = selectedZone.a - dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
			if 2*(selectedZone.b + dz) > minZoneSize and selectedZone.z - (selectedZone.b + dz) > 0 and selectedZone.z + (selectedZone.b + dz) < Game.mapSizeZ then
				selectedZone.b = selectedZone.b + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
		elseif zoneSide == "BOTRIGHT" then
			if 2*(selectedZone.a + dx) > minZoneSize and selectedZone.x - (selectedZone.a + dx) > 0 and selectedZone.x + (selectedZone.a + dx) < Game.mapSizeX then
				selectedZone.a = selectedZone.a + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
			end
			if 2*(selectedZone.b + dz) > minZoneSize and selectedZone.z - (selectedZone.b + dz) > 0 and selectedZone.z + (selectedZone.b + dz) < Game.mapSizeZ then
				selectedZone.b = selectedZone.b + dz
				zoneAnchorZ = zoneAnchorZ + dz
			else
				applyChangesToSelectedZone(0, dz-sign(dz)*8)
			end
		end
	end
end

function updateZonePanel() -- Add/remove an editbox and a checkbox to/from the zone window when a zone is created/deleted
	if totalZones ~= #zoneList then
		for k, zb in pairs(zoneBoxes) do
			zoneScrollPanel:RemoveChild(zb.editBox)
			zb.editBox:Dispose()
			zoneScrollPanel:RemoveChild(zb.checkbox)
			zb.checkbox:Dispose()
		end
		local size = 20
		for i, z in ipairs(zoneList) do
			local checkbox = addCheckbox(zoneScrollPanel, "80%", i * 3/2 * size, "20%", size, z.shown)
			local editBox = addEditBox(zoneScrollPanel, 0, i * 3/2 * size, "80%", size, "left", z.name, {z.red, z.green, z.blue, 1})
			zoneBoxes[z.id] = { editBox = editBox, checkbox = checkbox }
		end
		totalZones = #zoneList
		zoneIndex = 0
	end
	if windows['zonesAttributes'] and zoneStateMachine:getCurrentState() ~= zoneStateMachine.states.ATTR then
		showZonesSpecialAttributesWindow() -- Remove the zone attributes window when not in right state
	end
end

function showZonesSpecialAttributesWindow() -- Show the window to change some special attributes concerning zones
	if windows['zonesAttributes'] then -- if the window is already opened, close it
		zonesAttributesButton.state.chosen = false
		zonesAttributesButton:InvalidateSelf()
		windows['zonesAttributes']:Dispose()
		windows['zonesAttributes'] = nil
		if zoneStateMachine:getCurrentState() == zoneStateMachine.states.ATTR then
			zoneStateMachine:setCurrentState(zoneStateMachine.states.SELECTION)
		end
		return
	end
	zoneStateMachine:setCurrentState(zoneStateMachine.states.ATTR)
	zonesAttributesButton.state.chosen = true
	zonesAttributesButton:InvalidateSelf()
	windows['zonesAttributes'] = addWindow(Screen0, '15%', '5%', '30%', '80%')
	local sp = addScrollPanel(windows['zonesAttributes'], '0%', '0%', '100%', '100%')
	local count = 0
	for i, z in ipairs(zoneList) do -- Generate labels and buttons
		addLabel(sp, '0%', count * 50, "20%", 50, z.name, 20, "center", { z.red, z.green, z.blue, 1 }, "center")
		local alwaysInViewButton = addButton(sp, "20%", count * 50, "40%", 50, EDITOR_ZONES_ATTRIBUTES_ALWAYS_IN_VIEW, nil)
		alwaysInViewButton.state.chosen = z.alwaysInView -- Set to current value
		alwaysInViewButton.OnClick = {
			function()
				alwaysInViewButton.state.chosen = not alwaysInViewButton.state.chosen
				alwaysInViewButton:InvalidateSelf()
				z.alwaysInView = not z.alwaysInView
			end
		}
		local markerButton = addButton(sp, "60%", count * 50, "40%", 50, EDITOR_ZONES_ATTRIBUTES_MARKER, nil)
		markerButton.state.chosen = z.marker -- Set to current value
		markerButton.OnClick = {
			function()
				markerButton.state.chosen = not markerButton.state.chosen
				markerButton:InvalidateSelf()
				z.marker = not z.marker
			end
		}
		count = count + 1
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Forces state functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function updateAllyTeamPanels() -- Update the ally team window
	for k, at in pairs(allyTeams) do
		if tableLength(at) ~= allyTeamsSize[k] then -- Update panel when the size of an allyteam changed
			removeElements(allyTeamsScrollPanels[k], allyTeamsRemoveTeamButtons[k], true)
			removeElements(allyTeamsScrollPanels[k], allyTeamsRemoveTeamLabels[k], true)
			local count = 0
			for i, t in ipairs(at) do
				local lab = addLabel(allyTeamsScrollPanels[k], '30%', 40 * count, '70%', 40, teamName[t], 20, "left", {teams[t].red, teams[t].green, teams[t].blue, 1}, "center")
				table.insert(allyTeamsRemoveTeamLabels[k], lab)
				local but = addButton(allyTeamsScrollPanels[k], '0%', 40 * count, '20%', 40, EDITOR_X, function() removeTeamFromAllyTeam(k, t) selectedAllyTeam = k end)
				but.font.color = {1, 0, 0, 1}
				table.insert(allyTeamsRemoveTeamButtons[k], but)
				count = count + 1
			end
			allyTeamsSize[k] = tableLength(at)
		end
	end
	
	if updateAllyTeam then -- Update left list
		removeElements(forcesWindows.allyTeamsWindow, allyTeamPanels, false)
		removeElements(teamListScrollPanel, allyTeamsListButtons, true)
		removeElements(teamListScrollPanel, allyTeamsListLabels, true)
		count = 0
		for i, team in ipairs(teamStateMachine.states) do
			if enabledTeams[team] then
				forcesWindows.allyTeamsWindow:AddChild(allyTeamPanels[team])
				allyTeamsListButtons[team] = addButton(teamListScrollPanel, '80%', 40*count, '20%', 40, ">>", function() addTeamToSelectedAllyTeam(team) end)
				allyTeamsListLabels[team] = addLabel(teamListScrollPanel, '0%', 40*count, '80%', 40, teamName[team], 20, "center", {teams[team].red, teams[team].green, teams[team].blue, 1}, "center")
				count = count + 1
			end
		end
		updateAllyTeam = false
	end
end

function addTeamToSelectedAllyTeam(team)
	if team ~= selectedAllyTeam and not findInTable(allyTeams[selectedAllyTeam], team) then
		table.insert(allyTeams[selectedAllyTeam], team)
		table.sort(allyTeams[selectedAllyTeam])
	end
	saveState()
end

function removeTeamFromAllyTeam(allyTeam, team)
	local at = allyTeams[allyTeam]
	for i, t in ipairs(at) do
		if t == team then
			table.remove(at, i)
			break
		end
	end
	table.sort(at)
	saveState()
end

function removeTeamFromTables(team) -- Remove disabled team from allyteams
	for k, at in pairs(allyTeams) do
		removeTeamFromAllyTeam(k, team)
	end
end

function updateTeamsWindows() -- When the number of enabled teams changes, ask other windows to update themselves the next time they are shown
	local enabledTeamsCount = 0 -- count the number of enabled teams
	for k, enabled in pairs(enabledTeams) do
		if enabled then
			enabledTeamsCount = enabledTeamsCount + 1
		end
	end
	
	if enabledTeamsCount ~= enabledTeamsTotal then -- update every windows
		updateTeamButtons = true -- Team selection when instanciating units
		updateTeamConfig = true -- Team settings
		updateAllyTeam = true -- Ally teams
		enabledTeamsTotal = enabledTeamsCount
	end
end

function updateTeamConfigPanels() -- Update panels when teams become enabled/disabled
	if updateTeamConfig then
		for k, l in pairs(teamControlLabels) do
			teamConfigPanels[k]:RemoveChild(l)
		end
		for k, b in pairs(teamControlButtons) do
			teamConfigPanels[k]:RemoveChild(b.player)
			teamConfigPanels[k]:RemoveChild(b.computer)
		end
		for k, l in pairs(teamColorLabels) do
			teamConfigPanels[k]:RemoveChild(l)
		end
		for k, i in pairs(teamColorImage) do
			teamConfigPanels[k]:RemoveChild(i)
		end
		for k, t in pairs(teamColorTrackbars) do
			teamConfigPanels[k]:RemoveChild(t.red)
			teamConfigPanels[k]:RemoveChild(t.green)
			teamConfigPanels[k]:RemoveChild(t.blue)
		end
		for k, l in pairs(teamAIElements.teamAILabels) do
			teamConfigPanels[k]:RemoveChild(l)
		end
		for k, e in pairs(teamAIElements.teamAIEditBoxes) do
			teamConfigPanels[k]:RemoveChild(e)
		end
		for i, team in ipairs(teamStateMachine.states) do
			if enabledTeams[team] then
				teamConfigPanels[team]:AddChild(teamControlLabels[team])
				teamConfigPanels[team]:AddChild(teamControlButtons[team].player)
				teamConfigPanels[team]:AddChild(teamControlButtons[team].computer)
				teamConfigPanels[team]:AddChild(teamColorLabels[team])
				teamConfigPanels[team]:AddChild(teamColorImage[team])
				teamConfigPanels[team]:AddChild(teamColorTrackbars[team].red)
				teamConfigPanels[team]:AddChild(teamColorTrackbars[team].green)
				teamConfigPanels[team]:AddChild(teamColorTrackbars[team].blue)
				if teamControl[team] == "computer" then
					teamConfigPanels[team]:AddChild(teamAIElements.teamAILabels[team])
					teamConfigPanels[team]:AddChild(teamAIElements.teamAIEditBoxes[team])
				end
			end
		end
		updateTeamConfig = false
	end
	for i, t in ipairs(teamStateMachine.states) do
		if teamName[t] ~= teamNameEditBoxes[t].text then -- Update the name of the teams
			teamName[t] = teamNameEditBoxes[t].text
			updateAllyTeam = true
		end
		if teamAIElements.teamAI[t] ~= teamAIElements.teamAIEditBoxes[t].text then -- Update the AI of the computer controlled teams
			teamAIElements.teamAI[t] = teamAIElements.teamAIEditBoxes[t].text
		end
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Triggers state functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function createNewEvent()
	local event = {}
	event.conditions = {}
	event.trigger = ""
	event.actions = {}
	event.id = eventNumber
	event.name = EDITOR_TRIGGERS_EVENTS_DEFAULT_NAME..tostring(event.id)
	event.conditionTotal = 0
	event.actionTotal = 0
	event.repetition = false
	event.comment = ""
	table.insert(events, event)
	
	eventNumber = eventNumber + 1 -- increment id for future events
	conditionButtons[event.id] = {}
	deleteConditionButtons[event.id] = {}
	actionButtons[event.id] = {}
	deleteActionButtons[event.id] = {}
	
	editEvent(#events) -- edit this event
	saveState()
end

function editEvent(i)
	removeSecondWindows()
	removeThirdWindows()
	currentCondition = nil
	currentAction = nil
	if currentEvent ~= i then
		Screen0:AddChild(windows['eventWindow'])
		Screen0:AddChild(windows["importWindow"])
		currentEvent = i
		currentEventFrame()
		updateImportWindow()
	else -- if the edit frame is already opened, close it
		currentEvent = nil
	end
end

function removeEvent(i)
	table.remove(events, i)
	removeSecondWindows() -- close windows to prevent bugs
	removeThirdWindows() 
	currentEvent = nil
	currentCondition = nil
	currentAction = nil
	saveState()
end

function createNewCondition()
	if currentEvent then
		local e = events[currentEvent]
		local condition = {}
		condition.id = conditionNumber
		condition.name = EDITOR_TRIGGERS_CONDITIONS_DEFAULT_NAME..tostring(condition.id)
		table.insert(e.conditions, condition)
		
		conditionNumber = conditionNumber + 1
		
		editCondition(#(e.conditions))
		saveState()
	end
end

function editCondition(i)
	removeThirdWindows()
	currentAction = nil
	if currentCondition ~= i then
		Screen0:AddChild(windows['conditionWindow'])
		currentCondition = i
		currentConditionFrame()
		updateImportWindow()
	else -- if the edit frame is already opened, close it
		currentCondition = nil
	end
end

function removeCondition(i)
	if currentEvent then
		table.remove(events[currentEvent].conditions, i)
		removeThirdWindows() -- close windows to prevent bugs
		currentCondition = nil
		currentAction = nil
		saveState()
	end
end

function createNewAction()
	if currentEvent then
		local e = events[currentEvent]
		local action = {}
		action.id = actionNumber
		action.name = EDITOR_TRIGGERS_ACTIONS_DEFAULT_NAME..tostring(action.id)
		action.params = {}
		table.insert(e.actions, action)
		
		actionNumber = actionNumber + 1
		
		editAction(#(e.actions))
		saveState()
	end
end

function editAction(i)
	removeThirdWindows()
	currentCondition = nil
	if currentAction ~= i then
		Screen0:AddChild(windows['actionWindow'])
		currentAction = i
		currentActionFrame()
		updateImportWindow()
	else -- if the edit frame is already opened, close it
		currentAction = nil
	end
end

function removeAction(i)
	if currentEvent then
		table.remove(events[currentEvent].actions, i)
		removeThirdWindows() -- close windows to prevent bugs
		currentAction = nil
		currentCondition = nil
		saveState()
	end
end

function removeSecondWindows() -- Removes the middle window
	Screen0:RemoveChild(windows['eventWindow'])
	Screen0:RemoveChild(windows["importWindow"])
	Screen0:RemoveChild(windows['variablesWindow'])
	editVariablesButton.state.chosen = false
	editVariablesButton:InvalidateSelf()
end

function removeThirdWindows() -- Removes the rightmost window
	if eventCommentEditBox then
		windows["configureEvent"]:RemoveChild(eventCommentEditBox)
		eventCommentEditBox:Dispose()
		eventCommentEditBox = nil
	end
	Screen0:RemoveChild(windows['conditionWindow'])
	Screen0:RemoveChild(windows['actionWindow'])
	Screen0:RemoveChild(windows['configureEvent'])
	configureEventButton.state.chosen = false
	configureEventButton:InvalidateSelf()
end

function updateEventList(forceEventListUpdate) -- When a new event is created or the name of an event is changed, update the list
	if eventTotal ~= #events or forceEventListUpdate then
		removeElements(eventScrollPanel, eventUI.eventButtons, true)
		removeElements(eventScrollPanel, eventUI.deleteEventButtons, true)
		removeElements(eventScrollPanel, eventUI.upEventButtons, true)
		removeElements(eventScrollPanel, eventUI.downEventButtons, true)
		local count = 0
		for i, e in ipairs(events) do
			eventUI.eventButtons[i] = addButton(eventScrollPanel, '15%', 40 * count, '60%', 40, e.name, function() editEvent(i) end)
			eventUI.deleteEventButtons[i] = addButton(eventScrollPanel, '90%', 40 * count, '10%', 40, EDITOR_X, function() removeEvent(i) end)
			eventUI.deleteEventButtons[i].font.color = {1, 0, 0, 1}
			eventUI.deleteEventButtons[i].font.size = 20
			if i ~= 1 then
				local moveUpEvent = function()
					removeSecondWindows() -- close windows to prevent bugs
					removeThirdWindows() 
					currentEvent = nil
					local e = events[i]
					table.remove(events, i)
					table.insert(events, i-1, e)
					updateEventList(true)
					saveState()
				end
				eventUI.upEventButtons[i] = addButton(eventScrollPanel, '0%', 40 * count, '15%', 40, "", moveUpEvent)
				addImage(eventUI.upEventButtons[i], '0%', '0%', '100%', '100%', "bitmaps/editor/arrowup.png", false, {1, 1, 1, 1})
			end
			if i ~= #events then
				local moveDownEvent = function()
					removeSecondWindows() -- close windows to prevent bugs
					removeThirdWindows() 
					currentEvent = nil
					local e = events[i]
					table.remove(events, i)
					table.insert(events, i+1, e)
					updateEventList(true)
					saveState()
				end
				eventUI.downEventButtons[i] = addButton(eventScrollPanel, '75%', 40 * count, '15%', 40, "", moveDownEvent)
				addImage(eventUI.downEventButtons[i], '0%', '0%', '100%', '100%', "bitmaps/editor/arrowdown.png", false, {1, 1, 1, 1})
			end
			count = count + 1
		end
		newEventButton.y = 40 * count
		eventTotal = #events
	end
	
	if currentEvent then
		events[currentEvent].name = eventNameEditBox.text
		if events[currentEvent].name ~= eventUI.eventButtons[currentEvent].caption then
			eventUI.eventButtons[currentEvent].caption = events[currentEvent].name
			eventUI.eventButtons[currentEvent]:InvalidateSelf()
		end
	end
end

function updateEventFrame() -- When a new condition or action is created or its name is changed, update lists
	if currentEvent then
		local e = events[currentEvent]
		
		if eventCommentEditBox then
			e.comment = eventCommentEditBox.text
		end
		
		if e.conditionTotal ~= #(e.conditions) then
			removeElements(eventConditionsScrollPanel, conditionButtons[e.id], true)
			removeElements(eventConditionsScrollPanel, deleteConditionButtons[e.id], true)
			local count = 0
			for i, c in ipairs(e.conditions) do
				conditionButtons[e.id][i] = addButton(eventConditionsScrollPanel, '0%', 40 * count, '80%', 40, c.name, function() editCondition(i) end)
				deleteConditionButtons[e.id][i] = addButton(eventConditionsScrollPanel, '80%', 40 * count, '20%', 40, EDITOR_X, function() removeCondition(i) end)
				deleteConditionButtons[e.id][i].font.color = {1, 0, 0, 1}
				deleteConditionButtons[e.id][i].font.size = 20
				count = count + 1
			end
			newEventConditionButton.y = 40 * count
			e.conditionTotal = #(e.conditions)
		end
		
		if e.actionTotal ~= #(e.actions) then
			removeElements(eventActionsScrollPanel, actionButtons[e.id], true)
			removeElements(eventActionsScrollPanel, deleteActionButtons[e.id], true)
			local count = 0
			for i, c in ipairs(e.actions) do
				actionButtons[e.id][i] = addButton(eventActionsScrollPanel, '0%', 40 * count, '80%', 40, c.name, function() editAction(i) end)
				deleteActionButtons[e.id][i] = addButton(eventActionsScrollPanel, '80%', 40 * count, '20%', 40, EDITOR_X, function() removeAction(i) end)
				deleteActionButtons[e.id][i].font.color = {1, 0, 0, 1}
				deleteActionButtons[e.id][i].font.size = 20
				count = count + 1
			end
			newEventActionButton.y = 40 * count
			e.actionTotal = #(e.actions)
		end
	end
	
	if currentEvent and currentCondition then
		events[currentEvent].conditions[currentCondition].name = conditionNameEditBox.text
		if events[currentEvent].conditions[currentCondition].name ~= conditionButtons[events[currentEvent].id][currentCondition].caption then
			conditionButtons[events[currentEvent].id][currentCondition].caption = events[currentEvent].conditions[currentCondition].name
			conditionButtons[events[currentEvent].id][currentCondition]:InvalidateSelf()
		end
	end
	
	if currentEvent and currentAction then
		events[currentEvent].actions[currentAction].name = actionNameEditBox.text
		if events[currentEvent].actions[currentAction].name ~= actionButtons[events[currentEvent].id][currentAction].caption then
			actionButtons[events[currentEvent].id][currentAction].caption = events[currentEvent].actions[currentAction].name
			actionButtons[events[currentEvent].id][currentAction]:InvalidateSelf()
		end
	end
end

function currentEventFrame() -- Force update on the event frame when switching event
	if currentEvent then
		local e = events[currentEvent]
		-- set editbox text
		eventNameEditBox:SetText(e.name)
		-- set condition buttons
		for _, cB in pairs(conditionButtons) do
			removeElements(eventConditionsScrollPanel, cB, false)
		end
		for _, dCB in pairs(deleteConditionButtons) do
			removeElements(eventConditionsScrollPanel, dCB, false)
		end
		local count = 0
		for i, c in ipairs(e.conditions) do
			conditionButtons[e.id][i] = addButton(eventConditionsScrollPanel, '0%', 40 * count, '80%', 40, c.name, function() editCondition(i) end)
			deleteConditionButtons[e.id][i] = addButton(eventConditionsScrollPanel, '80%', 40 * count, '20%', 40, EDITOR_X, function() removeCondition(i) end)
			deleteConditionButtons[e.id][i].font.color = {1, 0, 0, 1}
			deleteConditionButtons[e.id][i].font.size = 20
			count = count + 1
		end
		newEventConditionButton.y = 40 * count
		-- set action buttons
		for _, aB in pairs(actionButtons) do
			removeElements(eventActionsScrollPanel, aB, false)
		end
		for _, dAB in pairs(deleteActionButtons) do
			removeElements(eventActionsScrollPanel, dAB, false)
		end
		local count = 0
		for i, c in ipairs(e.actions) do
			actionButtons[e.id][i] = addButton(eventActionsScrollPanel, '0%', 40 * count, '80%', 40, c.name, function() editAction(i) end)
			deleteActionButtons[e.id][i] = addButton(eventActionsScrollPanel, '80%', 40 * count, '20%', 40, EDITOR_X, function() removeAction(i) end)
			deleteActionButtons[e.id][i].font.color = {1, 0, 0, 1}
			deleteActionButtons[e.id][i].font.size = 20
			count = count + 1
		end
		newEventActionButton.y = 40 * count
	end
end

function currentConditionFrame() -- Force update on the condition frame when switching condition
	if currentCondition then
		dontUpdateComboBox = true -- Lock to prevent the callback of some comboboxes
		local c = events[currentEvent].conditions[currentCondition]
		conditionNameEditBox:SetText(c.name)
		if c.type then -- if the condition already exists and has a type, select this type in the combobox
			for i, condition in ipairs(conditions_list) do
				if condition.type == c.type then
					conditionFilterComboBox:Select(1)
					conditionTypeComboBox:Select(i)
					break
				end
			end
		else
			conditionFilterComboBox:Select(1)
			conditionTypeComboBox:Select(1)
		end
		dontUpdateComboBox = false
	end
end

function currentActionFrame() -- Force update on the action frame when switching action
	if currentAction then
		dontUpdateComboBox = true
		local a = events[currentEvent].actions[currentAction]
		actionNameEditBox:SetText(a.name)
		if a.type then
			for i, action in ipairs(actions_list) do
				if action.type == a.type then
					actionFilterComboBox:Select(1)
					actionTypeComboBox:Select(i)
					break
				end
			end
		else
			actionFilterComboBox:Select(1)
			actionTypeComboBox:Select(1)
		end
		dontUpdateComboBox = false
	end
end

function selectFilter() -- Only show some conditions/actions in the combobox
	if currentCondition then
		local conditionTypesList = {}
		if conditionFilterComboBox.selected == 1 then
			for i, c in ipairs(conditions_list) do
				table.insert(conditionTypesList, c.typeText)
			end
		else
			for i, c in ipairs(conditions_list) do
				if conditionFilterComboBox.items[conditionFilterComboBox.selected] == c.filter then
					table.insert(conditionTypesList, c.typeText)
				end
			end
		end
		conditionTypeComboBox.items = conditionTypesList
		if not dontUpdateComboBox then
			conditionTypeComboBox:Select(1)
		end
	elseif currentAction then
		local actionTypesList = {}
		if actionFilterComboBox.selected == 1 then
			for i, c in ipairs(actions_list) do
				table.insert(actionTypesList, c.typeText)
			end
		else
			for i, c in ipairs(actions_list) do
				if actionFilterComboBox.items[actionFilterComboBox.selected] == c.filter then
					table.insert(actionTypesList, c.typeText)
				end
			end
		end
		actionTypeComboBox.items = actionTypesList
		if not dontUpdateComboBox then
			actionTypeComboBox:Select(1)
		end
	end
end

function selectConditionType() -- Callback when selecting a condition
	if currentEvent and currentCondition then
		local selectedItem = conditionTypeComboBox.items[conditionTypeComboBox.selected]
		local conditionType
		for i, cond in ipairs(conditions_list) do
			if cond.typeText == selectedItem then
				conditionType = cond.type
				break
			end
		end
		if events[currentEvent].conditions[currentCondition].type ~= conditionType then
			events[currentEvent].conditions[currentCondition].type = conditionType
			drawConditionFrame(true)
		else
			drawConditionFrame(false)
		end
	end
end

function selectActionType() -- Callback when selecting an action
	if currentEvent and currentAction then
		local selectedItem = actionTypeComboBox.items[actionTypeComboBox.selected]
		local actionType
		for i, act in ipairs(actions_list) do
			if act.typeText == selectedItem then
				actionType = act.type
				break
			end
		end
		if events[currentEvent].actions[currentAction].type ~= actionType then
			events[currentEvent].actions[currentAction].type = actionType
			drawActionFrame(true)
		else
			drawActionFrame(false)
		end
	end
end

function drawConditionFrame(reset) -- Display specific condition with its parameters
	if currentEvent and currentCondition then
		local a = events[currentEvent].conditions[currentCondition]
		local condition_template
		for i, condition in pairs(conditions_list) do
			if condition.type == a.type then
				condition_template = condition -- get the template of the selected condition
				break
			end
		end
		conditionTextBox:SetText(condition_template.text)
		if reset then -- if reset is true, reset the parameters
			a.params = {}
		end
		for i, cf in ipairs(conditionFeatures) do
			for _, f in ipairs(cf) do
				conditionScrollPanel:RemoveChild(f)
				f:Dispose()
			end
		end
		local y = {}
		y[1] = 120
		conditionFeatures = {}
		for i, attr in ipairs(condition_template.attributes) do
			table.insert(conditionFeatures, drawFeature(attr, y, a, conditionScrollPanel))
			y[1] = y[1] + 30
		end
	end
end

function drawActionFrame(reset) -- Display specific action with its parameters
	if currentEvent and currentAction then
		local a = events[currentEvent].actions[currentAction]
		local action_template
		for i, action in pairs(actions_list) do
			if action.type == a.type then
				action_template = action
				break
			end
		end
		actionTextBox:SetText(action_template.text)
		if reset then
			a.params = {}
		end
		for i, af in ipairs(actionFeatures) do
			for _, f in ipairs(af) do
				actionScrollPanel:RemoveChild(f)
				f:Dispose()
			end
		end
		local y = {}
		y[1] = 120
		actionFeatures = {}
		for i, attr in ipairs(action_template.attributes) do
			table.insert(actionFeatures, drawFeature(attr, y, a, actionScrollPanel))
			y[1] = y[1] + 30
		end
	end
end

drawFeatureFunctions = {}

drawFeatureFunctions["unitType"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	for i, fu in ipairs(factionUnits) do
		for i, u in ipairs(fu) do
			table.insert(comboBoxItems, u)
		end
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { function() a.params[attr.id] = comboBox.items[comboBox.selected] end }
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if a.params[attr.id] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["team"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	for k, t in pairs(teamStateMachine.states) do
		if enabledTeams[t] then
			table.insert(comboBoxItems, teamName[t])
		end
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = {
		function()
			for k, n in pairs(teamName) do
				if comboBox.items[comboBox.selected] == n then
					a.params[attr.id] = k
					break
				end
			end
		end
	}
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if teamName[a.params[attr.id]] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["player"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	for k, t in pairs(teamStateMachine.states) do
		if enabledTeams[t] and teamControl[t] == "player" then
			table.insert(comboBoxItems, teamName[t])
		end
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = {
		function()
			for k, n in pairs(teamName) do
				if comboBox.items[comboBox.selected] == n then
					a.params[attr.id] = k
					break
				end
			end
		end
	}
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if teamName[a.params[attr.id]] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["group"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	for i, g in ipairs(unitGroups) do
		table.insert(comboBoxItems, g.name)
	end
	if #comboBoxItems == 0 then
		table.insert(comboBoxItems, EDITOR_TRIGGERS_EVENTS_GROUP_NOT_FOUND)
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = {
		function()
			for i, g in ipairs(unitGroups) do
				if g.name == comboBox.items[comboBox.selected] then
					a.params[attr.id] = g.id
					return
				end
			end
		end
	}
	
	-- Parameters check
	if a.params[attr.id] then
		local groupName
		for i, g in ipairs(unitGroups) do
			if g.id == a.params[attr.id] then
				groupName = g.name
				break
			end
		end
		for i, item in ipairs(comboBox.items) do
			if item == groupName then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["zone"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	for k, z in pairs(zoneList) do
		table.insert(comboBoxItems, z.name)
	end
	if #comboBoxItems == 0 then
		table.insert(comboBoxItems, EDITOR_TRIGGERS_EVENTS_ZONE_NOT_FOUND)
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { 
		function() 
			for i, zone in ipairs(zoneList) do
				if zone.name == comboBox.items[comboBox.selected] then
					a.params[attr.id] = zone.id
					break
				end
			end
		end
	}
	
	-- Parameters check
	if a.params[attr.id] then
		chosenZone = ""
		for i, zone in ipairs(zoneList) do
			if zone.id == a.params[attr.id] then
				chosenZone = zone.name
			end
		end
		for i, item in ipairs(comboBox.items) do
			if chosenZone == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["numberVariable"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	for i, v in ipairs(triggerVariables) do
		if v.type == "number" then
			table.insert(comboBoxItems, v.name)
		end
	end
	if #comboBoxItems == 0 then
		table.insert(comboBoxItems, EDITOR_TRIGGERS_EVENTS_VARNUM_NOT_FOUND)
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { function() a.params[attr.id] = comboBox.items[comboBox.selected] end }
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if a.params[attr.id] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["booleanVariable"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	for i, v in ipairs(triggerVariables) do
		if v.type == "boolean" then
			table.insert(comboBoxItems, v.name)
		end
	end
	if #comboBoxItems == 0 then
		table.insert(comboBoxItems, EDITOR_TRIGGERS_EVENTS_VARBOOL_NOT_FOUND)
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { function() a.params[attr.id] = comboBox.items[comboBox.selected] end }
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if a.params[attr.id] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["comparison"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = { "==", "!=", ">", ">=", "<", "<=" }
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { function() a.params[attr.id] = comboBox.items[comboBox.selected] end }
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if a.params[attr.id] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["condition"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	for i, e in ipairs(events) do
		for ii, c in ipairs(e.conditions) do
			table.insert(comboBoxItems, c.name)
		end
	end
	if #comboBoxItems == 0 then
		table.insert(comboBoxItems, EDITOR_TRIGGERS_EVENTS_CONDITION_NOT_FOUND)
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { function() a.params[attr.id] = comboBox.items[comboBox.selected] end }
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if a.params[attr.id] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["toggle"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = { "enabled", "disabled" }
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { function() a.params[attr.id] = comboBox.items[comboBox.selected] end }
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if a.params[attr.id] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["command"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	if a.params["unitset"] then
		if a.params["unitset"].type == "unit" then
			local uDefID = Spring.GetUnitDefID(a.params["unitset"].value)
			local unitType = UnitDefs[uDefID].name
			comboBoxItems = sortedCommandsListUnit[unitType] or { EDITOR_TRIGGERS_EVENTS_COMMANDS_NOT_FOUND }
		else
			comboBoxItems = sortedCommandsList or { EDITOR_TRIGGERS_EVENTS_COMMANDS_NOT_FOUND }
		end
	else
		comboBoxItems = sortedCommandsList or { EDITOR_TRIGGERS_EVENTS_COMMANDS_NOT_FOUND }
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { function() a.params[attr.id] = commandsToID[comboBox.items[comboBox.selected]] end }
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if idToCommands[tostring(a.params[attr.id])] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["boolean"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = { "true", "false" }
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { function() a.params[attr.id] = comboBox.items[comboBox.selected] end }
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if a.params[attr.id] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["widget"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Items generation
	local comboBoxItems = {}
	for i, w in ipairs(customWidgets) do
		table.insert(comboBoxItems, w.name)
	end
	
	-- ComboBox select
	local comboBox = addComboBox(panel, '30%', y, '40%', 30, comboBoxItems)
	comboBox.OnSelect = { function() a.params[attr.id] = comboBox.items[comboBox.selected] end }
	
	-- Parameters check
	if a.params[attr.id] then
		for i, item in ipairs(comboBox.items) do
			if a.params[attr.id] == item then
				comboBox:Select(i)
				break
			end
		end
	else
		comboBox:Select(1)
	end
	
	table.insert(feature, comboBox)
end

drawFeatureFunctions["position"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Parameters check
	local positionLabel = addLabel(panel, '30%', y, '40%', 30, "X: ?   Z: ?", 16, "center", nil, "center")
	if a.params[attr.id] then
		local param = a.params[attr.id]
		if type(param) == "number" then
			local zoneName = ""
			local r, g, b = 255, 255, 255
			for i, z in ipairs(zoneList) do
				if z.id == param then
					zoneName = z.name
					r, g, b = round(z.red*255)+1, round(z.green*255)+1, round(z.blue*255)+1
					break
				end
			end
			positionLabel.font.color = {1, 1, 1, 1}
			positionLabel:SetCaption(EDITOR_TRIGGERS_EVENTS_RANDOM_ZONE.." \255"..colorTable[r]..colorTable[g]..colorTable[b]..zoneName)
		else
			if a.params[attr.id].x and a.params[attr.id].z then
				positionLabel:SetCaption("X: "..tostring(a.params[attr.id].x).."   Z: "..tostring(a.params[attr.id].z))
				local function viewPosition()
					local state = Spring.GetCameraState()
					local x, z = a.params[attr.id].x, a.params[attr.id].z
					local y = Spring.GetGroundHeight(x, z)
					state.px, state.py, state.pz = x, y, z
					state.height = 500
					Spring.SetCameraState(state, 2)
					Spring.MarkerAddPoint(x, y, z, "("..tostring(x)..", "..tostring(z)..")")
					table.insert(markerList, { x = x, y = y, z = z, timer = 2 })
				end
				local viewButton = addButton(panel, '90%', y, '10%', 30, "", viewPosition)
				addImage(viewButton, '0%', '0%', '100%', '100%', "bitmaps/editor/eye.png", true, {0, 1, 1, 1})
				table.insert(feature, viewButton)
			end
		end
	end
	
	-- Pick process
	local pickButton = addButton(panel, '70%', y, '20%', 30, EDITOR_TRIGGERS_EVENTS_PICK, nil)
	local pickPosition = function()
		changedParam = attr.id
		triggerStateMachine:setCurrentState(triggerStateMachine.states.PICKPOSITION)
		Screen0:RemoveChild(windows["triggerWindow"])
		Screen0:RemoveChild(windows["eventWindow"])
		Screen0:RemoveChild(windows["conditionWindow"])
		Screen0:RemoveChild(windows["actionWindow"])
		Screen0:RemoveChild(windows["importWindow"])
		showRandomPositionInZoneWindow()
	end
	pickButton.OnClick = { pickPosition }
	
	table.insert(feature, positionLabel)
	table.insert(feature, pickButton)
end

drawFeatureFunctions["unit"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Parameters check
	local unitLabel = addLabel(panel, '30%', y, '40%', 30, "? (?)", 16, "center", nil, "center")
	if a.params[attr.id] then
		if a.params[attr.id].type and a.params[attr.id].value then
			local u = a.params[attr.id].value
			local uDefID = Spring.GetUnitDefID(u)
			if uDefID then
				local name = UnitDefs[uDefID].humanName
				local team = Spring.GetUnitTeam(u)
				unitLabel.font.color = { teams[team].red, teams[team].green, teams[team].blue, 1 }
				unitLabel:SetCaption(name.." ("..tostring(u)..")")
				local function viewUnit()
					local state = Spring.GetCameraState()
					local x, y, z = Spring.GetUnitPosition(u)
					state.px, state.py, state.pz = x, y, z
					state.height = 500
					Spring.SetCameraState(state, 2)
				end
				local viewButton = addButton(panel, '90%', y, '10%', 30, "", viewUnit)
				addImage(viewButton, '0%', '0%', '100%', '100%', "bitmaps/editor/eye.png", true, {0, 1, 1, 1})
				table.insert(feature, viewButton)
			end
		end
	end
	
	-- Pick process
	local pickButton = addButton(panel, '70%', y, '20%', 30, EDITOR_TRIGGERS_EVENTS_PICK, nil)
	local pickUnit = function()
		changedParam = attr.id 
		triggerStateMachine:setCurrentState(triggerStateMachine.states.PICKUNIT)
		Screen0:RemoveChild(windows["triggerWindow"])
		Screen0:RemoveChild(windows["eventWindow"])
		Screen0:RemoveChild(windows["conditionWindow"])
		Screen0:RemoveChild(windows["actionWindow"])
		Screen0:RemoveChild(windows["importWindow"])
	end
	pickButton.OnClick = { pickUnit }
	
	table.insert(feature, unitLabel)
	table.insert(feature, pickButton)
end

drawFeatureFunctions["unitset"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Parameters check
	local unitLabel = addLabel(panel, '30%', y, '40%', 30, "[ ]", 16, "center", nil, "center")
	if a.params[attr.id] then
		local param = a.params[attr.id]
		if param.type and param.value then
			if param.type == "unit" then
				local u = param.value
				local uDefID = Spring.GetUnitDefID(u)
				if uDefID then
					local name = UnitDefs[uDefID].humanName
					local team = Spring.GetUnitTeam(u)
					local r, g, b = round(teams[team].red*255)+1, round(teams[team].green*255)+1, round(teams[team].blue*255)+1
					unitLabel.font.color = { 1, 1, 1, 1 }
					unitLabel:SetCaption("\255\255\255\255[ \255"..colorTable[r]..colorTable[g]..colorTable[b]..name.." ("..tostring(u)..")\255\255\255\255 ]")
					local function viewUnit()
						local state = Spring.GetCameraState()
						local x, y, z = Spring.GetUnitPosition(u)
						state.px, state.py, state.pz = x, y, z
						state.height = 500
						Spring.SetCameraState(state, 2)
					end
					local viewButton = addButton(panel, '90%', y, '10%', 30, "", viewUnit)
					addImage(viewButton, '0%', '0%', '100%', '100%', "bitmaps/editor/eye.png", true, {0, 1, 1, 1})
					table.insert(feature, viewButton)
				end
			elseif param.type == "group" then
				unitLabel.font.color = {1, 1, 1, 1}
				for i, g in ipairs(unitGroups) do
					if g.id == param.value then
						unitLabel:SetCaption(g.name)
						break
					end
				end
			elseif param.type == "team" then
				if param.value == "all" then
					unitLabel.font.color = {1, 1, 1, 1}
					unitLabel:SetCaption(EDITOR_TRIGGERS_EVENTS_PICK_UNIT_ALL)
				else
					unitLabel.font.color = {teamColor[param.value].red, teamColor[param.value].green, teamColor[param.value].blue, 1}
					unitLabel:SetCaption(teamName[param.value])
				end
			elseif param.type == "action" then
				for i, ev in ipairs(events) do
					for ii, act in ipairs(ev.actions) do
						if act.id == param.value then
							unitLabel.font.color = {1, 1, 1, 1}
							unitLabel:SetCaption(act.name)
							break
						end
					end
				end
			elseif param.type == "condition" then
				local ev = events[currentEvent]
				for ii, cond in ipairs(ev.conditions) do
					if cond.id == param.value then
						unitLabel.font.color = {1, 1, 1, 1}
						unitLabel:SetCaption(cond.name)
						break
					end
				end
			end
		end
	end
	
	-- Pick process
	local pickButton = addButton(panel, '70%', y, '20%', 30, EDITOR_TRIGGERS_EVENTS_PICK, nil)
	local pickUnit = function()
		changedParam = attr.id 
		triggerStateMachine:setCurrentState(triggerStateMachine.states.PICKUNITSET)
		Screen0:RemoveChild(windows["triggerWindow"])
		Screen0:RemoveChild(windows["eventWindow"])
		Screen0:RemoveChild(windows["conditionWindow"])
		Screen0:RemoveChild(windows["actionWindow"])
		Screen0:RemoveChild(windows["importWindow"])
		showPickUnitWindow()
	end
	pickButton.OnClick = { pickUnit }
	
	table.insert(feature, unitLabel)
	table.insert(feature, pickButton)
end

drawFeatureFunctions["text"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Editbox
	local editBox = addEditBox(panel, '30%', y, '40%', 30)
	editBox.font.size = 13
	editBox.updateFunction = function()
		a.params[attr.id] = editBox.text
	end
	editBox.isEditBox = true
	
	-- Parameters check
	if a.params[attr.id] then
		editBox:SetText(a.params[attr.id])
	end
	
	table.insert(feature, editBox)
end

drawFeatureFunctions["textSplit"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Editbox
	local editBox = addEditBox(panel, '30%', y, '40%', 30)
	editBox.font.size = 13
	editBox.updateFunction = function()
		local msgs = splitString(editBox.text, "||")
		for i in ipairs(msgs) do
			msgs[i] = string.gsub(msgs[i], "^%s+", "")
			msgs[i] = string.gsub(msgs[i], "%s+$", "")
		end
		a.params[attr.id] = msgs
	end
	editBox.isEditBox = true
	
	-- Parameters check
	if a.params[attr.id] then
		local text = ""
		for i, msg in ipairs(a.params[attr.id]) do
			text = text .. msg
			if i ~= #a.params[attr.id] then
				text = text .. " || "
			end
		end
		editBox:SetText(text)
	end
	
	table.insert(feature, editBox)
end

drawFeatureFunctions["numberComparison"] = function(attr, yref, a, panel, feature)
	local y = yref[1]
	
	-- Initialize parameters table
	if not a.params[attr.id] then
		a.params[attr.id] = {}
	end
	
	-- Combobox
	local comboBoxItems = {
		EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_EXACTLY,
		EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_ATLEAST,
		EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_ATMOST,
		EDITOR_TRIGGERS_EVENTS_COMPARISON_NUMBER_ALL
	}
	local comboBox = addComboBox(panel, '30%', y, '30%', 30, comboBoxItems)
	
	-- Editbox
	local editBox = addEditBox(panel, '60%', y, '30%', 30)
	editBox.toShow = true
	comboBox.OnSelect = {
		function()
			if comboBox.selected == 1 then
				a.params[attr.id].comparison = "exactly"
				if not editBox.toShow then
					panel:AddChild(editBox)
					editBox.toShow = true
				end
			elseif comboBox.selected == 2 then
				a.params[attr.id].comparison = "atleast"
				if not editBox.toShow then
					panel:AddChild(editBox)
					editBox.toShow = true
				end
			elseif comboBox.selected == 3 then
				a.params[attr.id].comparison = "atmost"
				if not editBox.toShow then
					panel:AddChild(editBox)
					editBox.toShow = true
				end
			elseif comboBox.selected == 4 then
				a.params[attr.id].comparison = "all"
				panel:RemoveChild(editBox)
				editBox.toShow = false
			end
		end
	}
	editBox.font.size = 13
	editBox.updateFunction = function()
		a.params[attr.id].number = editBox.text
	end
	editBox.isEditBox = true
	
	-- Parameters check
	if a.params[attr.id].comparison then
		local comp = a.params[attr.id].comparison
		if comp == "exactly" then
			comboBox:Select(1)
		elseif comp == "atleast" then
			comboBox:Select(2)
		elseif comp == "atmost" then
			comboBox:Select(3)
		elseif comp == "all" then
			comboBox:Select(4)
		end
	else
		comboBox:Select(1)
	end
	if a.params[attr.id].number then
		editBox:SetText(a.params[attr.id].number)
	end
	
	table.insert(feature, comboBox)
	table.insert(feature, editBox)
end

function drawFeature(attr, yref, a, panel) -- Display parameter according to its type
	local feature = {}
	
	local textLabel = addLabel(panel, '0%', yref[1], '30%', 30, attr.text, 16, "center", nil, "center")
	textLabel.font.shadow = false
	table.insert(feature, textLabel)
	
	drawFeatureFunctions[attr.type](attr, yref, a, panel, feature)
	
	if attr.hint then
		local variableHint = addTextBox(panel, '5%', yref[1]+35, '90%', 35, attr.hint, 14, { 0.6, 1, 1, 1 })
		table.insert(feature, variableHint)
		yref[1] = yref[1] + 40
	end
	
	return feature
end

function configureEvent() -- Show the event configuration window
	if currentEvent then
		if not configureEventButton.state.chosen or updateActionSequence then -- force update when changing the action sequence
			local e = events[currentEvent]
			removeThirdWindows()
			currentCondition = nil
			currentAction = nil
			Screen0:AddChild(windows['configureEvent'])
			configureEventButton.state.chosen = true
			configureEventButton:InvalidateSelf()
			-- Name
			configureEventLabel:SetCaption(EDITOR_TRIGGERS_EVENTS_CONFIGURE.." "..events[currentEvent].name)
			-- Trigger
			customTriggerEditBox:SetText(e.trigger)
			currentTriggerLabel:SetCaption(EDITOR_TRIGGERS_EVENTS_CONFIGURE_TRIGGER_CURRENT.."\255\0\255\204"..e.trigger)
			-- Action sequence
			removeElements(actionSequenceScrollPanel, actionSequenceItems, true)
			local act = events[currentEvent].actions
			for i, a in ipairs(act) do
				local lab = addLabel(actionSequenceScrollPanel, '20%', (i - 1) * 40, '60%', 40, a.name, 16, "center", nil, "center")
				table.insert(actionSequenceItems, lab)
				if i ~= 1 then -- do not show this arrow for the first element
					local moveUpAction = function()
						table.remove(act, i)
						table.insert(act, i-1, a)
						updateActionSequence = true
						configureEvent()
						for _, aB in pairs(actionButtons) do
							removeElements(eventActionsScrollPanel, aB, false)
						end
						for _, dAB in pairs(deleteActionButtons) do
							removeElements(eventActionsScrollPanel, dAB, false)
						end
						local count = 0
						for i, c in ipairs(e.actions) do -- update action list
							actionButtons[e.id][i] = addButton(eventActionsScrollPanel, '0%', 40 * count, '80%', 40, c.name, function() editAction(i) end)
							deleteActionButtons[e.id][i] = addButton(eventActionsScrollPanel, '80%', 40 * count, '20%', 40, EDITOR_X, function() removeAction(i) end)
							deleteActionButtons[e.id][i].font.color = {1, 0, 0, 1}
							deleteActionButtons[e.id][i].font.size = 20
							count = count + 1
						end
						newEventActionButton.y = 40 * count
						saveState()
					end
					local but = addButton(actionSequenceScrollPanel, '0%', (i - 1) * 40, '20%', 40, "", moveUpAction)
					addImage(but, '0%', '0%', '100%', '100%', "bitmaps/editor/arrowup.png", false, {1, 1, 1, 1})
					table.insert(actionSequenceItems, but)
				end
				if i ~= #(events[currentEvent].actions) then -- do not show this arrow for the last element
					local moveDownAction = function()
						table.remove(act, i)
						table.insert(act, i+1, a)
						updateActionSequence = true
						configureEvent()
						for _, aB in pairs(actionButtons) do
							removeElements(eventActionsScrollPanel, aB, false)
						end
						for _, dAB in pairs(deleteActionButtons) do
							removeElements(eventActionsScrollPanel, dAB, false)
						end
						local count = 0
						for i, c in ipairs(e.actions) do -- update action list
							actionButtons[e.id][i] = addButton(eventActionsScrollPanel, '0%', 40 * count, '80%', 40, c.name, function() editAction(i) end)
							deleteActionButtons[e.id][i] = addButton(eventActionsScrollPanel, '80%', 40 * count, '20%', 40, EDITOR_X, function() removeAction(i) end)
							deleteActionButtons[e.id][i].font.color = {1, 0, 0, 1}
							deleteActionButtons[e.id][i].font.size = 20
							count = count + 1
						end
						newEventActionButton.y = 40 * count
						saveState()
					end
					local but = addButton(actionSequenceScrollPanel, '80%', (i - 1) * 40, '20%', 40, "", moveDownAction)
					addImage(but, '0%', '0%', '100%', '100%', "bitmaps/editor/arrowdown.png", false, {1, 1, 1, 1})
					table.insert(actionSequenceItems, but)
				end
			end
			-- Parameters
			removeElements(windows['configureEvent'], repetitionUI, true)
			repetitionUI = {}
			repetitionUI.repetitionLabel = addLabel(windows['configureEvent'], '10%', '85%', '80%', '5%', "", 16, "left")
			repetitionUI.repetitionComboBox = addComboBox(windows['configureEvent'], '25%', '80%', '40%', '5%', { EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_NO, EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_YES })
			repetitionUI.repetitionComboBox.OnSelect = {
				function()
					if repetitionUI.repetitionComboBox.selected == 1 then
						e.repetition = false
						e.repetitionTime = nil
						repetitionUI.repetitionLabel:SetCaption("")
					else
						e.repetition = true
					end
				end
			}
			repetitionUI.repetitionEditBox = addEditBox(windows['configureEvent'], '70%', '81%', '10%', '3%')
			repetitionUI.repetitionEditBox.hint = "X = "
			repetitionUI.repetitionButton = addButton(windows['configureEvent'], '85%', '80%', '10%', '5%', EDITOR_OK,
				function()
					if e.repetition then
						e.repetitionTime = repetitionUI.repetitionEditBox.text
						repetitionUI.repetitionLabel:SetCaption(string.gsub(EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_MESSAGE, "/X/", tostring(e.repetitionTime)))
					end
				end
			)
			if e.repetition then
				repetitionUI.repetitionComboBox:Select(2)
				repetitionUI.repetitionEditBox:SetText(e.repetitionTime)
				if e.repetitionTime then
					repetitionUI.repetitionLabel:SetCaption(string.gsub(EDITOR_TRIGGERS_EVENTS_CONFIGURE_REPETITION_MESSAGE, "/X/", tostring(e.repetitionTime)))
				end
			else
				repetitionUI.repetitionComboBox:Select(1)
				repetitionUI.repetitionLabel:SetCaption("")
			end
			
			eventCommentEditBox = addEditBox(windows["configureEvent"], '25%', '90%', '70%', '4%', "left", "")
			if e.comment then
				eventCommentEditBox:SetText(e.comment)
			else
				eventCommentEditBox:SetText("")
			end
			
			updateActionSequence = false
		else
			removeThirdWindows()
			currentCondition = nil
			currentAction = nil
		end
	end
end

function updateImportWindow() -- Update the event combobox in the import window
		local eventList = {}
		for i, ev in ipairs(events) do
			table.insert(eventList, ev.name)
		end
		importEventComboBox.items = eventList
		importEventComboBox:Select(1)
end

function updateImportComboBoxes() -- Update the condition and action comboboxes in the import window
	local e = events[importEventComboBox.selected]
	local conditionList = {}
	for i, c in ipairs(e.conditions) do
		table.insert(conditionList, c.name)
	end
	importConditionComboBox.items = conditionList
	if #conditionList == 0 then
		importConditionComboBox.items = { EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT_CONDITION_NO }
	end
	importConditionComboBox:InvalidateSelf()
	importConditionComboBox:Select(1)
	local actionList = {}
	for i, a in ipairs(e.actions) do
		table.insert(actionList, a.name)
	end
	importActionComboBox.items = actionList
	if #actionList == 0 then
		importActionComboBox.items = { EDITOR_TRIGGERS_EVENTS_CONFIGURE_IMPORT_ACTION_NO }
	end
	importActionComboBox:InvalidateSelf()
	importActionComboBox:Select(1)
end

function importCondition() -- Import a condition to the current event, renaming it if necessary
	local e = events[importEventComboBox.selected]
	local ce = events[currentEvent]
	local importedCondition = e.conditions[importConditionComboBox.selected]
	if not importedCondition then return end
	local newCondition = {}
	newCondition.id = conditionNumber
	local count = 0
	for i, c in ipairs(ce.conditions) do
		local substring = string.gsub(c.name, "%(%d+%)", "")
		if substring == importedCondition.name then
			count = count + 1
		end
	end
	if count == 0 then
		newCondition.name = importedCondition.name
	else
		newCondition.name = importedCondition.name.."("..count..")"
	end
	newCondition.type = importedCondition.type
	newCondition.params = deepcopy(importedCondition.params)
	
	table.insert(ce.conditions, newCondition)
	
	conditionNumber = conditionNumber + 1
	
	saveState()
end

function importAction() -- Import an action to the current event, renaming it if necessary
	local e = events[importEventComboBox.selected]
	local ce = events[currentEvent]
	local importedAction = e.actions[importActionComboBox.selected]
	if not importedAction then return end
	local newAction = {}
	newAction.id = actionNumber
	local count = 0
	for i, a in ipairs(ce.actions) do
		local substring = string.gsub(a.name, "%(%d+%)", "")
		if substring == importedAction.name then
			count = count + 1
		end
	end
	if count == 0 then
		newAction.name = importedAction.name
	else
		newAction.name = importedAction.name.."("..count..")"
	end
	newAction.type = importedAction.type
	newAction.params = deepcopy(importedAction.params)
	
	table.insert(events[currentEvent].actions, newAction)
	
	actionNumber = actionNumber + 1
	
	updateActionSequence = true
	
	saveState()
end

function preventSpaces() -- Prevent user to use spaces in names (would bug with the custom trigger)
	if currentEvent then
		if string.find(eventNameEditBox.text, " ") then
			local cursor = eventNameEditBox.cursor
			eventNameEditBox:SetText(string.gsub(eventNameEditBox.text, "%s+", ""))
			eventNameEditBox.cursor = cursor - 1
			eventNameEditBox:InvalidateSelf()
		end
	end
	if currentAction then
		if string.find(actionNameEditBox.text, " ") then
			local cursor = actionNameEditBox.cursor
			actionNameEditBox:SetText(string.gsub(actionNameEditBox.text, "%s+", ""))
			actionNameEditBox.cursor = cursor - 1
			actionNameEditBox:InvalidateSelf()
		end
	end
	if currentCondition then
		if string.find(conditionNameEditBox.text, " ") then
			local cursor = conditionNameEditBox.cursor
			conditionNameEditBox:SetText(string.gsub(conditionNameEditBox.text, "%s+", ""))
			conditionNameEditBox.cursor = cursor - 1
			conditionNameEditBox:InvalidateSelf()
		end
	end
end

function showVariablesFrame() -- Display the edit variables window or hide it if already displayed
	if not editVariablesButton.state.chosen then
		removeSecondWindows()
		removeThirdWindows()
		currentCondition = nil
		currentAction = nil
		currentEvent = nil
		Screen0:AddChild(windows['variablesWindow'])
		editVariablesButton.state.chosen = true
	else
		removeSecondWindows()
		removeThirdWindows()
		currentCondition = nil
		currentAction = nil
		currentEvent = nil
	end
end

function addVariable()
	local variable = {}
	variable.id = variablesNumber
	variable.name = EDITOR_TRIGGERS_VARIABLES_DEFAULT_NAME.." "..tostring(variablesNumber)
	variable.type = "number"
	variable.initValue = 0
	
	table.insert(triggerVariables, variable)
	
	variablesNumber = variablesNumber + 1
	
	saveState()
end

function removeVariable(var)
	for i, v in ipairs(triggerVariables) do
		if var == v then
			table.remove(triggerVariables, i)
			saveState()
			break
		end
	end
end

function updateVariables()
	if editVariablesButton.state.chosen then
		for i, vf in ipairs(variablesFeatures) do
			vf.var.name = vf.nameEditBox.text -- Update variables value
			if vf.var.type == "number" then
				vf.var.initValue = tonumber(vf.initValueEditBox.text)
			end
		end
	end
	if variablesTotal ~= #triggerVariables or forceUpdateVariables then -- When a variable is added or deleted, update the window
		for i, vf in ipairs(variablesFeatures) do
			for k, f in pairs(vf) do
				if k ~= "var" then
					variablesScrollPanel:RemoveChild(f)
				end
			end
		end
		local count = 0
		variablesFeatures = {}
		for i, var in ipairs(triggerVariables) do
			table.insert(variablesFeatures, drawVariableFeature(var, count * 40))
			count = count + 1
		end
		newVariableButton.y = count * 40
		variablesTotal = #triggerVariables
		forceUpdateVariables = false
	end
end

function drawVariableFeature(var, y) -- Draw the UI elements to edit a variable
	local feature = {}
	local nameLabel = addLabel(variablesScrollPanel, '0%', y, '5%', 40, EDITOR_TRIGGERS_VARIABLES_NAME, 16, "center", nil, "center")
	local nameEditBox = addEditBox(variablesScrollPanel, '5%', y+5, '30%', 30, "left", var.name)
	nameEditBox.font.size = 16
	local typeLabel = addLabel(variablesScrollPanel, '40%', y, '5%', 40, EDITOR_TRIGGERS_VARIABLES_TYPE, 16, "center", nil, "center")
	local typeComboBox = addComboBox(variablesScrollPanel, '45%', y, '10%', 40, { EDITOR_TRIGGERS_VARIABLES_TYPE_NUMBER, EDITOR_TRIGGERS_VARIABLES_TYPE_BOOLEAN }, nil)
	local selectType = function()
		if typeComboBox.items[typeComboBox.selected] == EDITOR_TRIGGERS_VARIABLES_TYPE_NUMBER then
			var.type = "number"
			variablesScrollPanel:RemoveChild(feature.initValueComboBox)
			variablesScrollPanel:RemoveChild(feature.initValueEditBox)
			variablesScrollPanel:AddChild(feature.initValueEditBox)
		elseif typeComboBox.items[typeComboBox.selected] == EDITOR_TRIGGERS_VARIABLES_TYPE_BOOLEAN then
			var.type = "boolean"
			variablesScrollPanel:RemoveChild(feature.initValueComboBox)
			variablesScrollPanel:RemoveChild(feature.initValueEditBox)
			variablesScrollPanel:AddChild(feature.initValueComboBox)
		end
	end
	typeComboBox.OnSelect = { selectType }

	local initValueLabel = addLabel(variablesScrollPanel, '60%', y, '10%', 40, EDITOR_TRIGGERS_VARIABLES_INITVALUE, 16, "center", nil, "center")
	local initValueComboBox = addComboBox(variablesScrollPanel, '70%', y, '20%', 40, { "true", "false" }, nil)
	local selectInitValue = function()
		var.initValue = initValueComboBox.items[initValueComboBox.selected]
	end
	initValueComboBox.OnSelect = { selectInitValue }
	local initValueEditBox = addEditBox(variablesScrollPanel, '70%', y+5, '20%', 30, "left", tostring(var.initValue))
	initValueEditBox.font.size = 16
	local deleteVariableButton = addButton(variablesScrollPanel, '95%', y, '5%', 40, EDITOR_X, function() removeVariable(var) end)
	deleteVariableButton.font.color = {1, 0, 0, 1}
	
	feature.nameLabel = nameLabel
	feature.nameEditBox = nameEditBox
	feature.typeLabel = typeLabel
	feature.typeComboBox = typeComboBox
	feature.initValueLabel = initValueLabel
	feature.initValueEditBox = initValueEditBox
	feature.initValueComboBox = initValueComboBox
	feature.deleteVariableButton = deleteVariableButton
	feature.var = var
	
	if var.type == "number" then
		feature.typeComboBox:Select(1)
	elseif var.type == "boolean" then
		feature.typeComboBox:Select(2)
		if var.initValue == "true" then
			feature.initValueComboBox:Select(1)
		elseif var.initValue == "false" then
			feature.initValueComboBox:Select(2)
		end
	end
	
	return feature
end

function showPickText() -- Show text next to the mouse and in the middle of the screen when picking a unit or a position for a condition or an event
	local text = ""
	if triggerStateMachine:getCurrentState() == triggerStateMachine.states.PICKUNIT or triggerStateMachine:getCurrentState() == triggerStateMachine.states.PICKUNITSET then
		text = EDITOR_TRIGGERS_EVENTS_PICK_UNIT
	elseif triggerStateMachine:getCurrentState() == triggerStateMachine.states.PICKPOSITION then
		text = EDITOR_TRIGGERS_EVENTS_PICK_POSITION
	end
	if text ~= "" then
		local w = gl.GetTextWidth(text)
		local x = screenSizeX * 0.5
		local y = screenSizeY * 0.8
		gl.Text("\255\51\255\255"..text, x - (20*w/2), y, 20, "s")
	end
	if triggerStateMachine:getCurrentState() == triggerStateMachine.states.PICKPOSITION then
		local mx, my = Spring.GetMouseState()
		local kind, var = Spring.TraceScreenRay(mx, my, true, true)
		local text = EDITOR_TRIGGERS_EVENTS_PICK_POSITION_WRONG
		if var then
			local x, _, z = unpack(var)
			text = "("..tostring(round(x))..", "..tostring(round(z))..")"
		end
		gl.Text(text, mx, my, 16, "s")
	end
end

function updateEditBoxesParams() -- update some attributes if they require editboxes
	if currentAction then
		for i, af in ipairs(actionFeatures) do
			for ii, f in ipairs(af) do
				if f.isEditBox then
					f.updateFunction()
				end
			end
		end
	elseif currentCondition then
		for i, cf in ipairs(conditionFeatures) do
			for ii, f in ipairs(cf) do
				if f.isEditBox then
					f.updateFunction()
				end
			end
		end
	end
end

function getCommandsList() -- Get the list of the commands of the units as read in the appropriate widget
	local commandList = Spring.GetModOptions().commands
	if commandList then
		commandList = splitString(commandList, "++")
		commandsToID, idToCommands, sortedCommandsList, sortedCommandsListUnit = json.decode(commandList[1]), json.decode(commandList[2]), json.decode(commandList[3]), json.decode(commandList[4])
	end
end

function showPickUnitWindow() -- Allow the user to pick a specific set of units
	local pickFunction = function(t, v)
		local ca = {}
		if currentAction then
			ca = events[currentEvent].actions[currentAction]
		elseif currentCondition then
			ca = events[currentEvent].conditions[currentCondition]
		end
		triggerStateMachine:setCurrentState(triggerStateMachine.states.DEFAULT)
		ca.params[changedParam] = {}
		ca.params[changedParam].type = t
		ca.params[changedParam].value = v
		Screen0:RemoveChild(selectSetOfUnitsWindows.actcond)
		Screen0:RemoveChild(selectSetOfUnitsWindows.groupteam)
		Screen0:AddChild(windows["triggerWindow"])
		Screen0:AddChild(windows["eventWindow"])
		Screen0:AddChild(windows["importWindow"])
		if currentAction then
			Screen0:AddChild(windows["actionWindow"])
			drawActionFrame(false)
		elseif currentCondition then
			Screen0:AddChild(windows["conditionWindow"])
			drawConditionFrame(false)
		end
	end
	
	selectSetOfUnitsWindows.groupteam = addWindow(Screen0, "0%", "5%", "15%", "80%")
	
	addLabel(selectSetOfUnitsWindows.groupteam, '0%', '0%', '100%', '5%', EDITOR_TRIGGERS_EVENTS_PICK_UNIT_TEAM, 20, "center", nil, "center")
	local tsp = addScrollPanel(selectSetOfUnitsWindows.groupteam, '0%', '5%', '100%', '45%')
	local tc = 0
	local allBut = addButton(tsp, "0%", tc * 40, "100%", 40, EDITOR_TRIGGERS_EVENTS_PICK_UNIT_TEAM_ALL, function() pickFunction("team", "all") end)
	tc = tc + 1
	for k, t in pairs(teamStateMachine.states) do
		if enabledTeams[t] then
			local but = addButton(tsp, "0%", tc * 40, "100%", 40, teamName[t], function() pickFunction("team", t) end)
			but.font.color = {teamColor[t].red, teamColor[t].green, teamColor[t].blue, 1}
			tc = tc + 1
		end
	end
	
	addLabel(selectSetOfUnitsWindows.groupteam, '0%', '50%', '100%', '5%', EDITOR_TRIGGERS_EVENTS_PICK_UNIT_GROUP, 20, "center", nil, "center")
	local gsp = addScrollPanel(selectSetOfUnitsWindows.groupteam, '0%', '55%', '100%', '45%')
	for i, g in ipairs(unitGroups) do
		addButton(gsp, "0%", (i-1) * 40, "100%", 40, g.name, function() pickFunction("group", g.id) end)
	end
	
	selectSetOfUnitsWindows.actcond = addWindow(Screen0, "85%", "5%", "15%", "80%")
	
	addLabel(selectSetOfUnitsWindows.actcond, '0%', '0%', '100%', '3%', EDITOR_TRIGGERS_EVENTS_PICK_UNIT_ACTION, 20, "center", nil, "center")
	addLabel(selectSetOfUnitsWindows.actcond, '0%', '3%', '100%', '2%', EDITOR_TRIGGERS_EVENTS_PICK_UNIT_CREATED, 13, "center", nil, "center")
	local asp = addScrollPanel(selectSetOfUnitsWindows.actcond, '0%', '5%', '100%', '45%')
	local count = 0
	for i, e in ipairs(events) do
		for ii, a in ipairs(e.actions) do
			if a.type == "createUnits" then
				addButton(asp, "0%", count * 40, "100%", 40, a.name, function() pickFunction("action", a.id) end)
				count = count + 1
			end
		end
	end
	
	addLabel(selectSetOfUnitsWindows.actcond, '0%', '50%', '100%', '3%', EDITOR_TRIGGERS_EVENTS_PICK_UNIT_CONDITION, 20, "center", nil, "center")
	addLabel(selectSetOfUnitsWindows.actcond, '0%', '53%', '100%', '2%', EDITOR_TRIGGERS_EVENTS_PICK_UNIT_TRIGGERING, 13, "center", nil, "center")
	local csp = addScrollPanel(selectSetOfUnitsWindows.actcond, '0%', '55%', '100%', '45%')
	for i, c in ipairs(events[currentEvent].conditions) do
		addButton(csp, "0%", (i-1) * 40, "100%", 40, c.name, function() pickFunction("condition", c.id) end)
	end
end

function showRandomPositionInZoneWindow() -- Allow the user to pick a zone when picking a position (the position will then be random within the zone)
	randomInZoneWindow = addWindow(Screen0, "0%", "30%", "20%", "40%", true)
	addLabel(randomInZoneWindow, '0%', '0%', '100%', '10%', EDITOR_TRIGGERS_EVENTS_PICK_RANDOM_ZONE, 20, "center", nil, "center")
	local sp = addScrollPanel(randomInZoneWindow, '0%', '10%', '100%', '90%')
	for i, z in ipairs(zoneList) do
		local but = addButton(sp, "0%", (i - 1) * 40, "100%", 40, z.name, nil)
		local pickFunction = function()
			local ca = {}
			if currentAction then
				ca = events[currentEvent].actions[currentAction]
			elseif currentCondition then
				ca = events[currentEvent].conditions[currentCondition]
			end
			triggerStateMachine:setCurrentState(triggerStateMachine.states.DEFAULT)
			ca.params[changedParam] = z.id
			Screen0:RemoveChild(randomInZoneWindow)
			Screen0:AddChild(windows["triggerWindow"])
			Screen0:AddChild(windows["eventWindow"])
			Screen0:AddChild(windows["importWindow"])
			if currentAction then
				Screen0:AddChild(windows["actionWindow"])
				drawActionFrame(false)
			elseif currentCondition then
				Screen0:AddChild(windows["conditionWindow"])
				drawConditionFrame(false)
			end
		end
		but.OnClick = { pickFunction }
	end
	if #zoneList == 0 then
		randomInZoneWindow:Dispose()
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Map settings functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function updateMapSettings() -- Update the settings of the map according to what is written/chosen
	mapDescription.mapName = mapNameEditBox.text -- update name
	mapDescription.mapBriefingRaw = mapBriefingEditBox.text -- update briefing (without colors and returns)
	if mapBriefingEditBox.text ~= mapBriefingTextBox.text then
		local text = mapBriefingEditBox.text
		local newText = text
		for word in string.gmatch(text, "/#%w*#.-/") do -- for each /#XXXXXX#ABC/ sequence where X is a hexadecimal number and ABC a string, surround ABC with color tags to color this part of the string
			local color = string.gsub(word, "#[^#]+$", "")
			color = string.gsub(color, "/#", "")
			local red = tonumber(string.sub(color, 1, 2), 16)
			if red then red = red + 1 end
			local green = tonumber(string.sub(color, 3, 4), 16)
			if green then green = green + 1 end
			local blue = tonumber(string.sub(color, 5, 6), 16)
			if blue then blue = blue + 1 end
			if red and green and blue then
				local replacement = "\255"..colorTable[red]..colorTable[green]..colorTable[blue]
				local newWord = string.gsub(word, "/#%w*#", replacement)
				newWord = string.gsub(newWord, "/", "\255\255\255\255")
				newText = string.gsub(newText, word, newWord)
			end
		end
		newText = string.gsub(newText, "\\n", "\n")
		mapBriefingTextBox:SetText(newText)
	end
	mapDescription.mapBriefing = mapBriefingTextBox.text
end

function initWidgetList() -- Remove some widgets linked directly to prog&play from the widget list
	customWidgets = {}
	for k, w in pairs(WG.widgetList) do
		if 	k ~= "Spring Direct Launch 2 for Prog&Play" and
			k ~= "Messenger" and
			k ~= "Mission GUI" and
			k ~= "CA Interface" and
			k ~= "Files IO" and
			k ~= "Display Message" and
			k ~= "Camera Auto" and
			k ~= "Chili Framework" and
			k ~= "Editor Commands List" and
			k ~= "Editor Loading Screen" and
			k ~= "Spring Direct Launch 2 for Prog&Play Level Editor" and
			k ~= "Editor User Interface" and
			k ~= "Editor Widget List"
		then
			local customWidget = {}
			customWidget.name = k
			customWidget.active = false
			customWidget.desc = w.desc
			table.insert(customWidgets, customWidget)
		end
	end
end

function showWidgetsWindow() -- Show the window that allows the user to change widgets status for his level
	if windows['widgetsWindow'] then
		mapSettingsButtons.widgetsButton.state.chosen = false
		mapSettingsButtons.widgetsButton:InvalidateSelf()
		windows['widgetsWindow']:Dispose()
		windows['widgetsWindow'] = nil
		return
	end
	mapSettingsButtons.widgetsButton.state.chosen = true
	mapSettingsButtons.widgetsButton:InvalidateSelf()
	windows['widgetsWindow'] = addWindow(Screen0, '0%', '0%', '20%', '50%')
	addLabel(windows['widgetsWindow'], '0%', '0%', '100%', '10%', EDITOR_MAPSETTINGS_WIDGETS, 20, "center", nil, "center")
	local sp = addScrollPanel(windows['widgetsWindow'], '2%', '10%', '96%', '89%')
	local count = 0
	for i, w in ipairs(customWidgets) do
		local but = addButton(sp, '0%', 40 * count, '100%', 40, w.name)
		but.state.chosen = w.active
		but.OnClick = {
			function()
				but.state.chosen = not but.state.chosen
				w.active = not w.active
			end
		}
		count = count + 1
	end
end

function updateWidgetsWindowPosition() -- Stick the widget window to the mapsettings window
	if windows['widgetsWindow'] then
		windows['widgetsWindow']:SetPos(windows['mapSettingsWindow'].x + windows['mapSettingsWindow'].width, windows['mapSettingsWindow'].y, '15%', '50%')
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Save/load functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function newMap() -- Set each parameter to its default value
	-- Units
	unitHP = {}
	unitAutoHeal = {}
	-- Groups
	unitGroups = {}
	unitTotal = nil
	unitGroupsUnitTotal = nil
	groupNumber = 1
	groupTotal = nil
	groupSizes = {}
	drawStartX, drawStartY, drawEndX, drawEndY = 0, 0, 0, 0
	rValue, gValue, bValue = 0, 0, 0
	-- Zone
	zonePositions.zoneX1, zonePositions.zoneX2, zonePositions.zoneZ1, zonePositions.zoneZ2 = 0, 0, 0, 0
	zoneAnchorX, zoneAnchorZ = 0, 0
	zoneList = {}
	selectedZone = nil
	zoneSide = ""
	totalZones = nil
	zoneNumber = 1
	zoneIndex = 0
	-- AllyTeams
	allyTeams = {}
	for k, t in pairs(teamStateMachine.states) do
		allyTeams[t] = {}
	end
	allyTeamsSize = {}
	selectedAllyTeam = 0
	-- TeamConfig
	teamControl = {}
	for k, t in pairs(teamStateMachine.states) do
		teamControl[t] = "computer"
		if t == 0 then
			teamControl[t] = "player"
		end
	end
	enabledTeams = {}
	for k, t in pairs(teamStateMachine.states) do
		enabledTeams[t] = false
		if t == 0 or t == 1 or t == 2 then
			enabledTeams[t] = true
		end
	end
	enabledTeamsTotal = nil
	teamColor = {}
	for k,t in pairs(teamStateMachine.states) do
		teamColor[t] = {}
		teamColor[t].red = tonumber(teams[t].red)
		teamColor[t].green = tonumber(teams[t].green)
		teamColor[t].blue = tonumber(teams[t].blue)
	end
	teamName = {}
	for i, t in ipairs(teamStateMachine.states) do
		teamName[t] = EDITOR_FORCES_TEAM_DEFAULT_NAME.." "..tostring(t)
	end
	teamAIElements.teamAI = {}
	for i, t in ipairs(teamStateMachine.states) do
		teamAIElements.teamAI[t] = ""
	end
	-- Trigger
	events = {}
	eventTotal = nil
	currentEvent = nil
	currentCondition = nil
	currentAction = nil
	eventNumber = 0
	conditionNumber = 0
	actionNumber = 0
	changedParam = nil
	-- Variables
	triggerVariables = {}
	variablesNumber = 0
	variablesTotal = nil
	-- Map
	mapDescription.mapName = "Map"
	mapDescription.mapBriefing = "Map Briefing"
	mapDescription.mapBriefingRaw = "Map Briefing"
	cameraAutoState = "enabled"
	autoHealState = "disabled"
	mouseState = "disabled"
	minimapState = "disabled"
	feedbackState = "disabled"
	initWidgetList()
	-- Gadget (units)
	Spring.SendLuaRulesMsg("New Map")
	-- Reset some chili elements
	eventConditionsScrollPanel:Dispose()
	newEventConditionButton:Dispose()
	eventActionsScrollPanel:Dispose()
	newEventActionButton:Dispose()
	eventConditionsScrollPanel = addScrollPanel(windows['eventWindow'], '2%', '10%', '46%', '83%')
	newEventConditionButton = addButton(eventConditionsScrollPanel, '0%', 0, '100%', 40, EDITOR_TRIGGERS_CONDITIONS_NEW, createNewCondition)
	eventActionsScrollPanel = addScrollPanel(windows['eventWindow'], '52%', '10%', '46%', '83%')
	newEventActionButton = addButton(eventActionsScrollPanel, '0%', 0, '100%', 40, EDITOR_TRIGGERS_ACTIONS_NEW, createNewAction)
end

function newMapInitialize() -- Open the window of the state you were in before load/new
	-- Initialize
	updateTeamButtons = true -- prevents requiring to go to the forces menu
	updateTeamConfig = true
	if globalStateMachine:getCurrentState() == globalStateMachine.states.FILE then
		fileFrame() -- double to close the frame and open it again (to refresh)
		fileFrame()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
		unitFrame()
		unitFrame()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		zoneFrame()
		zoneFrame()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.FORCES then
		forcesFrame()
		forcesFrame()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.TRIGGER then
		triggerFrame()
		triggerFrame()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.MAPSETTINGS then
		mapSettingsFrame()
		mapSettingsFrame()
	end
	saveState()
end

function loadMap(name) -- Load a map given a file name or if loadedTable is not nil
	if loading then return end -- Don't load if already loading
	loading = true
	newMap()
	if VFS.FileExists("pp_editor/missions/"..name..".editor",  VFS.RAW) then
		local mapfile = VFS.LoadFile("pp_editor/missions/"..name..".editor",  VFS.RAW)
		loadedTable = json.decode(mapfile)
	else
		loading = false
	end
	if loadedTable then
		-- Units
		Spring.SendLuaRulesMsg("Load Map".."++"..json.encode(loadedTable.units)) -- ask the gadget to instanciate units with new ids
		-- See next method
	else
		loading = false
	end
end

function GetNewUnitIDsAndContinueLoadMap(unitIDs) -- Continue the loading once the units have been instanciated with new ids
	local uIDs = json.decode(unitIDs) -- get the associative table between old ids and new ids
	for i, u in ipairs(loadedTable.units) do -- set up unit parameters
		unitHP[uIDs[tostring(u.id)]] = u.hp
		unitAutoHeal[uIDs[tostring(u.id)]] = u.autoHeal
	end
	
	-- Unit Groups
	for i, g in ipairs(loadedTable.groups) do
		groupNumber = g.id
		addUnitGroup(g.name)
		for ii, u in ipairs(g.units) do
			addUnitToGroup(unitGroups[#unitGroups], uIDs[tostring(u)])
		end
	end
	
	-- Zones
	for i, z in ipairs(loadedTable.zones) do
		local zone = {}
		for k, attr in pairs(z) do
			zone[k] = attr
		end
		table.insert(zoneList, zone)
		if z.id >= zoneNumber then
			zoneNumber = z.id + 1
		end
	end
	
	-- Teams
	updateTeamButtons = true
	for k, t in pairs(teamStateMachine.states) do
		teamControl[t] = loadedTable.teams[tostring(t)].control
		teamColor[t] = {}
		enabledTeams[t] = loadedTable.teams[tostring(t)].enabled
		teamAIElements.teamAI[t] = loadedTable.teams[tostring(t)].ai
		teamColor[t].red = loadedTable.teams[tostring(t)].color.red
		teamColor[t].blue = loadedTable.teams[tostring(t)].color.blue
		teamColor[t].green = loadedTable.teams[tostring(t)].color.green
		teamName[t] = loadedTable.teams[tostring(t)].name
	end
	
	-- Ally Teams
	for k, at in pairs(loadedTable.allyteams) do
		selectedAllyTeam = tonumber(k)
		allyTeams[selectedAllyTeam] = {}
		for i, t in ipairs(at) do
			addTeamToSelectedAllyTeam(t)
		end
	end
	
	-- Variables
	for i, v in ipairs(loadedTable.variables) do
		table.insert(triggerVariables, v)
		if v.id >= variablesNumber then
			variablesNumber = v.id + 1
		end
	end
	
	-- Triggers
	for i, e in ipairs(loadedTable.events) do
		local event = {}
		event.id = e.id
		if e.id >= eventNumber then
			eventNumber = e.id + 1
		end
		event.name = e.name
		event.actionTotal = e.actionTotal
		event.conditionTotal = e.conditionTotal
		event.trigger = e.trigger
		event.repetition = e.repetition
		event.comment = e.comment
		event.repetitionTime = e.repetitionTime
		event.conditions = {}
		for ii, c in ipairs(e.conditions) do
			local condition = {}
			condition.id = c.id
			if c.id >= conditionNumber then
				conditionNumber = c.id + 1
			end
			condition.type = c.type
			condition.name = c.name
			condition.params = {}
			for k, p in pairs(c.params) do
				local updateUnitID = false
				for iii, cond in ipairs(conditions_list) do
					for iiii, attr in ipairs(cond.attributes) do
						if attr.id == k and (attr.type == "unit" or attr.type == "unitset") and p.type == "unit" then -- if the condition has a unit as parameter, ask to update the old id to the new id
							updateUnitID = true
							break
						end
					end
					if updateUnitID then
						break
					end
				end
				if updateUnitID then
					condition.params[k] = {}
					condition.params[k].type = p.type
					condition.params[k].value = uIDs[tostring(p.value)]
				else
					condition.params[k] = p
				end
			end
			table.insert(event.conditions, condition)
		end
		event.actions = {}
		for ii, a in ipairs(e.actions) do
			local action = {}
			action.id = a.id
			if a.id >= actionNumber then
				actionNumber = a.id + 1
			end
			action.type = a.type
			action.name = a.name
			action.params = {}
			for k, p in pairs(a.params) do
				local updateUnitID = false
				for iii, act in ipairs(actions_list) do
					for iiii, attr in ipairs(act.attributes) do
						if attr.id == k and (attr.type == "unit" or attr.type == "unitset") and p.type == "unit" then
							updateUnitID = true
							break
						end
					end
					if updateUnitID then
						break
					end
				end
				if updateUnitID then
					action.params[k] = {}
					action.params[k].type = p.type
					action.params[k].value = uIDs[tostring(p.value)]
				else
					action.params[k] = p
				end
			end
			table.insert(event.actions, action)
		end
		table.insert(events, event)
		conditionButtons[event.id] = {}
		deleteConditionButtons[event.id] = {}
		actionButtons[event.id] = {}
		deleteActionButtons[event.id] = {}
	end
	
	-- Global description
	mapDescription.mapName = loadedTable.description.name
	mapDescription.mapBriefingRaw = loadedTable.description.briefingRaw
	mapDescription.mapBriefing = loadedTable.description.briefing
	cameraAutoState = loadedTable.description.cameraAuto
	autoHealState = loadedTable.description.autoHeal
	mouseState = loadedTable.description.mouse
	minimapState = loadedTable.description.minimap
	feedbackState = loadedTable.description.feedback
	for i, w in ipairs(loadedTable.description.widgets) do
		for ii, wid in ipairs(customWidgets) do
			if wid.name == w.name then
				wid.active = w.active
				break
			end
		end
	end
	
	loadedTable = nil
	
	-- Initialize
	newMapInitialize()
	
	if not loadLock then
		continueLoadState()
	end
	
	loading = false
	NeedToBeSaved = true
end

function saveMap() -- Save the table containing the data of the mission into a file
	if windows["saveWindow"] then
		Screen0:RemoveChild(windows["saveWindow"])
		windows["saveWindow"]:Dispose()
	end
	
	local savedTable = encodeSaveTable()
	local saveName = savedTable.description.saveName
	
	-- Write
	local jsonfile = json.encode(savedTable)
	local DBG_formatString = true -- TODO remove format
	if DBG_formatString then
		jsonfile = string.gsub(jsonfile, ",", ",\n")
		jsonfile = string.gsub(jsonfile, "}", "\n}")
		jsonfile = string.gsub(jsonfile, "{", "{\n")
		jsonfile = string.gsub(jsonfile, "%[", "[\n")
		jsonfile = string.gsub(jsonfile, "%]", " \n]")
		local count = 0
		jsonfile = string.gsub(
			jsonfile,
			".",
			function(c)
				if c == "\n" then
					local rtr = "\n"
					for i = 1, count, 1 do
						rtr = rtr.."\t"
					end
					return rtr
				end
				if c == "[" or c == "{" then
					count = count + 1
					return c
				end
				if c == "]" or c == "}" then
					count = count - 1
					return c
				end
			end
		)
		jsonfile = string.gsub(jsonfile, "\t}", "}")
		jsonfile = string.gsub(jsonfile, "\t%]", "]")
	end
	local file = io.open("pp_editor/missions/"..saveName..".editor", "w")
	file:write(jsonfile)
	file:close()
	NeedToBeSaved = false
end

function newMapFrame() -- Show a window when the user clicks on the new button
	if windows["newMapWindow"] then
		Screen0:RemoveChild(windows["newMapWindow"])
		windows["newMapWindow"]:Dispose()
	end
	windows["newMapWindow"] = addWindow(Screen0, '40%', '30%', '20%', '40%', true)
	addLabel(windows["newMapWindow"], '0%', '0%', '90%', '10%', EDITOR_FILE_NEW_TITLE, 20, "center", nil, "center")
	local delbut = addButton(windows["newMapWindow"], '90%', '0%', '10%', '10%', EDITOR_X, function() Screen0:RemoveChild(windows["newMapWindow"]) windows["newMapWindow"]:Dispose() end)
	delbut.font.color = {1, 0, 0, 1}
	local mapList = VFS.GetMaps()
	if #mapList == 0 then
		addTextBox(windows["loadWindow"], '10%', '20%', '80%', '70%', EDITOR_FILE_NEW_NO_MAP_FOUND, 16, {1, 0, 0, 1})
	else
		local scrollPanel = addScrollPanel(windows["newMapWindow"], '0%', '10%', '100%', '90%')
		local count = 0
		for i, m in ipairs(mapList) do
			addButton(scrollPanel, '0%', 40 * count, '100%', 40, m,  function() Screen0:RemoveChild(windows["newMapWindow"]) windows["newMapWindow"]:Dispose() newLevelWithRightMap(m) end)
			count = count + 1
		end
	end
end

function loadMapFrame() -- Show a window when the user clicks on the load button
	if windows["loadWindow"] then
		Screen0:RemoveChild(windows["loadWindow"])
		windows["loadWindow"]:Dispose()
	end
	local showLoadWindow = function()
		windows["loadWindow"] = addWindow(Screen0, '40%', '30%', '20%', '40%', true)
		addLabel(windows["loadWindow"], '0%', '0%', '90%', '10%', EDITOR_FILE_LOAD_TITLE, 20, "center", nil, "center")
		local delbut = addButton(windows["loadWindow"], '90%', '0%', '10%', '10%', EDITOR_X, function() Screen0:RemoveChild(windows["loadWindow"]) windows["loadWindow"]:Dispose() end)
		delbut.font.color = {1, 0, 0, 1}
		local levelList = VFS.DirList("pp_editor/missions/", "*.editor", VFS.RAW)
		if #levelList == 0 then
			addTextBox(windows["loadWindow"], '10%', '20%', '80%', '70%', EDITOR_FILE_LOAD_NO_LEVEL_FOUND, 16, {1, 0, 0, 1})
		else
			local scrollPanel = addScrollPanel(windows["loadWindow"], '0%', '10%', '100%', '90%')
			local count = 0
			for i, l in ipairs(levelList) do
				local name = string.gsub(l, "pp_editor\\missions\\", "")
				name = string.gsub(name, ".editor", "")
				local levelDescription = json.decode(VFS.LoadFile("pp_editor/missions/"..name..".editor"))
				if levelDescription.description.mainGame == Spring.GetModOptions().maingame then
					local displayedName = string.gsub(name, "_", " ")
					addButton(scrollPanel, '0%', 40 * count, '100%', 40, displayedName, function() Screen0:RemoveChild(windows["loadWindow"]) windows["loadWindow"]:Dispose() loadLevelWithRightMap(name) end)
					count = count + 1
				end
			end
			if count == 0 then
				scrollPanel:Dispose()
				addTextBox(windows["loadWindow"], '10%', '20%', '80%', '70%', EDITOR_FILE_LOAD_NO_LEVEL_FOUND_GAME, 16, {1, 0, 0, 1})
			end
		end
	end
	if NeedToBeSaved then
		windows["loadWindow"] = addWindow(Screen0, "35%", "45%", "30%", "10%")
		addLabel(windows["loadWindow"], '0%', '0%', '100%', '35%', EDITOR_FILE_SAVE_CHANGES, 20)
		addLabel(windows["loadWindow"], '0%', '30%', '100%', '15%', EDITOR_FILE_SAVE_CHANGES_HELP, 14)
		addButton(windows["loadWindow"], '0%', '50%', '50%', '50%', EDITOR_YES, function() Screen0:RemoveChild(windows["loadWindow"]) windows["loadWindow"]:Dispose() saveMapFrame() end)
		addButton(windows["loadWindow"], '50%', '50%', '50%', '50%', EDITOR_NO, function() Screen0:RemoveChild(windows["loadWindow"]) windows["loadWindow"]:Dispose() showLoadWindow() end)
		return
	else
		showLoadWindow()
	end
end

function saveMapFrame() -- Show a window when the user clicks on the save button
	if windows["saveWindow"] then
		Screen0:RemoveChild(windows["saveWindow"])
		windows["saveWindow"]:Dispose()
	end
	local saveName = generateSaveName(mapDescription.mapName)
	if saveName == "Map" then
		windows["saveWindow"] = addWindow(Screen0, "35%", "45%", "30%", "10%")
		addLabel(windows["saveWindow"], '0%', '0%', '100%', '35%', EDITOR_FILE_SAVE_CHANGE_NAME, 20)
		addLabel(windows["saveWindow"], '0%', '30%', '100%', '15%', EDITOR_FILE_SAVE_CHANGE_NAME_HELP, 14)
		addButton(windows["saveWindow"], '25%', '50%', '50%', '50%', EDITOR_OK, function() Screen0:RemoveChild(windows["saveWindow"]) windows["saveWindow"]:Dispose() mapSettingsFrame() end)
	else
		local confirmSave = function()
			if windows["saveWindow"] then
				Screen0:RemoveChild(windows["saveWindow"])
				windows["saveWindow"]:Dispose()
			end
			windows["saveWindow"] = addWindow(Screen0, "25%", "45%", "50%", "10%")
			addLabel(windows["saveWindow"], '0%', '0%', '100%', '35%', EDITOR_FILE_SAVE_COMPLETED.." (<Spring>/pp_editor/levels/"..saveName..".editor)", 20)
			addButton(windows["saveWindow"], '25%', '50%', '50%', '50%', EDITOR_OK, function() Screen0:RemoveChild(windows["saveWindow"]) windows["saveWindow"]:Dispose() end)
		end
		if VFS.FileExists("pp_editor/missions/"..saveName..".editor", VFS.RAW) then
			windows["saveWindow"] = addWindow(Screen0, "35%", "45%", "30%", "10%")
			addLabel(windows["saveWindow"], '0%', '0%', '100%', '35%', EDITOR_FILE_SAVE_CONFIRM.." ("..saveName..".editor)", 20)
			addLabel(windows["saveWindow"], '0%', '30%', '100%', '15%', EDITOR_FILE_SAVE_CONFIRM_HELP, 14)
			addButton(windows["saveWindow"], '0%', '50%', '50%', '50%', EDITOR_YES, function() saveMap() confirmSave() end)
			addButton(windows["saveWindow"], '50%', '50%', '50%', '50%', EDITOR_NO, function() Screen0:RemoveChild(windows["saveWindow"]) windows["saveWindow"]:Dispose() end)
		else
			saveMap()
			confirmSave()
		end
	end
end

function backToMenuFrame() -- Show a window when the user clicks on the main menu button
	if windows["backToMenu"] then
		Screen0:RemoveChild(windows["backToMenu"])
		windows["backToMenu"]:Dispose()
	end
	windows["backToMenu"] = addWindow(Screen0, "35%", "45%", "30%", "10%")
	addLabel(windows["backToMenu"], '0%', '0%', '100%', '35%', EDITOR_FILE_BACK_TO_MENU_CONFIRM, 20)
	addLabel(windows["backToMenu"], '0%', '30%', '100%', '15%', EDITOR_FILE_BACK_TO_MENU_CONFIRM_HELP, 14)
	addButton(windows["backToMenu"], '0%', '50%', '50%', '50%', EDITOR_YES, function() WG.BackToMainMenu() end)
	addButton(windows["backToMenu"], '50%', '50%', '50%', '50%', EDITOR_NO, function() Screen0:RemoveChild(windows["backToMenu"]) windows["backToMenu"]:Dispose() end)
end

function quitFrame() -- Show a window when the user clicks on the quit button
	if windows["backToMenu"] then
		Screen0:RemoveChild(windows["backToMenu"])
		windows["backToMenu"]:Dispose()
	end
	windows["backToMenu"] = addWindow(Screen0, "35%", "45%", "30%", "10%")
	addLabel(windows["backToMenu"], '0%', '0%', '100%', '35%', EDITOR_FILE_QUIT_CONFIRM, 20)
	addLabel(windows["backToMenu"], '0%', '30%', '100%', '15%', EDITOR_FILE_BACK_TO_MENU_CONFIRM_HELP, 14)
	addButton(windows["backToMenu"], '0%', '50%', '50%', '50%', EDITOR_YES, function() Spring.SendCommands("quit") Spring.SendCommands("quitforce") end)
	addButton(windows["backToMenu"], '50%', '50%', '50%', '50%', EDITOR_NO, function() Screen0:RemoveChild(windows["backToMenu"]) windows["backToMenu"]:Dispose() end)
end

function beginLoadLevel(name) -- Callback used to load a map directly from the launcher
	loadMap(name)
end

function loadLevelWithRightMap(name) -- Load a level in the map associated to the level if the map is different
	if VFS.FileExists("pp_editor/missions/"..name..".editor",  VFS.RAW) then
		local levelFile = VFS.LoadFile("pp_editor/missions/"..name..".editor",  VFS.RAW)
		levelFile = json.decode(levelFile)
		if levelFile.description.map == Game.mapName then
			loadMap(name)
			return
		end
		if Game.version == "0.82.5.1" then
			local operations = {
				["MODOPTIONS"] = {
					["language"] = Language,
					["scenario"] = "noScenario",
					["toBeLoaded"] = level,
					["maingame"] = Spring.GetModOptions().maingame,
					["commands"] = json.encode(commandsToID).."++"..json.encode(idToCommands).."++"..json.encode(sortedCommandsList).."++"..json.encode(sortedCommandsListUnit)
				},
				["GAME"] = {
					["Mapname"] = levelFile.description.map,
					["Gametype"] = Game.modName
				}
			}
			DoTheRestart("LevelEditor.txt", operations)
		else
			local operations = {
				["MODOPTIONS"] = {
					["language"] = Language,
					["scenario"] = "noScenario",
					["toBeLoaded"] = level,
					["maingame"] = Spring.GetModOptions().maingame,
					["commands"] = json.encode(commandsToID).."++"..json.encode(idToCommands).."++"..json.encode(sortedCommandsList).."++"..json.encode(sortedCommandsListUnit)
				},
				["GAME"] = {
					["Mapname"] = levelFile.description.map,
					["Gametype"] = Game.gameName.." "..Game.gameVersion
				}
			}
			DoTheRestart("LevelEditor.txt", operations)
		end
	end
end

function newLevelWithRightMap(name) -- Creates a new level on the selected map
	if name == Game.mapName then
		newMap()
		newMapInitialize()
		return
	end
	if Game.version == "0.82.5.1" then
		local operations = {
			["MODOPTIONS"] = {
				["language"] = Language,
				["scenario"] = "noScenario",
				["maingame"] = Spring.GetModOptions().maingame,
				["commands"] = json.encode(commandsToID).."++"..json.encode(idToCommands).."++"..json.encode(sortedCommandsList).."++"..json.encode(sortedCommandsListUnit)
			},
			["GAME"] = {
				["Mapname"] = name,
				["Gametype"] = Game.modName
			}
		}
		DoTheRestart("LevelEditor.txt", operations)
	else
		local operations = {
			["MODOPTIONS"] = {
				["language"] = Language,
				["scenario"] = "noScenario",
				["maingame"] = Spring.GetModOptions().maingame,
				["commands"] = json.encode(commandsToID).."++"..json.encode(idToCommands).."++"..json.encode(sortedCommandsList).."++"..json.encode(sortedCommandsListUnit)
			},
			["GAME"] = {
				["Mapname"] = name,
				["Gametype"] = Game.gameName.." "..Game.gameVersion
			}
		}
		DoTheRestart("LevelEditor.txt", operations)
	end
end

function encodeSaveTable() -- Transforms parameters to a table containing all the information needed to store the level
	local savedTable = {}
	-- Global description
	savedTable.description = {}
	savedTable.description.mainGame = Spring.GetModOptions().maingame
	savedTable.description.map = Game.mapName
	savedTable.description.name = mapDescription.mapName
	savedTable.description.saveName = generateSaveName(mapDescription.mapName)
	savedTable.description.briefing = mapDescription.mapBriefing
	savedTable.description.briefingRaw = mapDescription.mapBriefingRaw
	savedTable.description.cameraAuto = cameraAutoState
	savedTable.description.autoHeal = autoHealState
	savedTable.description.mouse = mouseState
	savedTable.description.minimap = minimapState
	savedTable.description.feedback = feedbackState
	savedTable.description.widgets = {}
	for i, w in ipairs(customWidgets) do
		local widget = {}
		widget.name = w.name
		widget.active = w.active
		widget.desc = w.desc
		table.insert(savedTable.description.widgets, widget)
	end
	
	-- Units
	local units = Spring.GetAllUnits()
	savedTable.units = {}
	for i, u in ipairs(units) do
		local unit = {}
		unit.type = UnitDefs[Spring.GetUnitDefID(u)].name
		unit.position = {}
		unit.position.x, unit.position.y, unit.position.z = Spring.GetUnitPosition(u)
		unit.team = Spring.GetUnitTeam(u)
		local dirX, _, dirZ = Spring.GetUnitDirection(u)
		local length = math.sqrt(dirX*dirX + dirZ*dirZ)
		unit.orientation = math.atan2(dirX/length, dirZ/length)
		unit.hp = unitHP[u] or 100
		unit.autoHeal = unitAutoHeal[u] or "global"
		unit.id = u
		table.insert(savedTable.units, unit)
	end
	
	-- Unit groups
	savedTable.groups = {}
	for i, g in ipairs(unitGroups) do
		local group = {}
		group.name = g.name
		group.units = g.units
		group.id = g.id
		table.insert(savedTable.groups, group)
	end
	
	-- Zones
	savedTable.zones = {}
	for i, z in ipairs(zoneList) do
		local zone = {}
		for k, attr in pairs(z) do
			zone[k] = attr
		end
		table.insert(savedTable.zones, zone)
	end
	
	-- Teams
	savedTable.teams = {}
	for k, t in pairs(teamStateMachine.states) do
		savedTable.teams[t] = {}
		savedTable.teams[t].control = teamControl[t]
		savedTable.teams[t].enabled = enabledTeams[t]
		savedTable.teams[t].ai = teamAIElements.teamAI[t]
		savedTable.teams[t].color = {}
		savedTable.teams[t].color.red = teamColor[t].red
		savedTable.teams[t].color.green = teamColor[t].green
		savedTable.teams[t].color.blue = teamColor[t].blue
		savedTable.teams[t].name = teamName[t]
	end
	
	-- AllyTeams
	savedTable.allyteams = allyTeams
	
	-- Variables
	savedTable.variables = triggerVariables
	
	-- Triggers
	savedTable.events = events
	
	return savedTable
end

function saveState() -- Save the state and put it in the stack
	NeedToBeSaved = true
	if loadLock and not initialize then
		local savedTable = encodeSaveTable()
		savedTable = json.decode(json.encode(savedTable))
		for i = 1, loadIndex-1, 1 do
			table.remove(saveStates, 1)
		end
		loadIndex = 1
		table.insert(saveStates, 1, savedTable)
	end
end

function loadState(direction) -- Load a state from the stack depending on the direction (CTRL + Y or Z)
	NeedToBeSaved = true
	loadLock = false
	saveCurrentEvent = currentEvent
	saveCurrentAction = currentAction
	saveCurrentCondition = currentCondition
	variablesWindowToBeShown = editVariablesButton.state.chosen
	configureWindowToBeShown = configureEventButton.state.chosen
	unitGroupsWindowToBeShown = (unitStateMachine:getCurrentState() == unitStateMachine.states.UNITGROUPS)
	if (loadIndex < #saveStates and direction > 0) or (loadIndex > 1 and direction < 0) then
		if loadIndex == 1 then
			saveState()
		end
		loadIndex = loadIndex + direction
		loadedTable = saveStates[loadIndex]
		loadMap("")
	end
end

function continueLoadState() -- Open windows that were opened before ctrl + z or y
	if saveCurrentEvent and events[saveCurrentEvent] then
		editEvent(saveCurrentEvent)
		if saveCurrentAction and events[saveCurrentEvent].actions[saveCurrentAction] then
			editAction(saveCurrentAction)
		elseif saveCurrentCondition and events[saveCurrentEvent].conditions[saveCurrentCondition] then
			editCondition(saveCurrentCondition)
		elseif configureWindowToBeShown then
			configureEvent()
		end
	end
	if variablesWindowToBeShown then
		showVariablesFrame()
	end
	if unitGroupsWindowToBeShown then
		showGroupsWindow()
	end
	
	loadLock = true
end

function requestSave() -- Save only after everything required has been done
	toSave = true
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Draw functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function drawGroundFilledEllipsis(centerX, centerZ, a, b, d)
	local divs = d or 25
	gl.BeginEnd(GL.TRIANGLE_STRIP, function()
		for angle = 0, 2*math.pi+2*math.pi/25, 2*math.pi/25 do
			local x, z = centerX + a * math.cos(angle), centerZ + b * math.sin(angle)
			gl.Vertex(x, Spring.GetGroundHeight(x, z), z)
			gl.Vertex(centerX, Spring.GetGroundHeight(centerX, centerZ), centerZ)
		end
	end)
end

function drawGroundEmptyEllipsis(centerX, centerZ, a, b, w, d)
	local divs = d or 25
	gl.BeginEnd(GL.TRIANGLE_STRIP, function()
		for angle = 0, 2*math.pi+2*math.pi/25, 2*math.pi/25 do
			local x, z = centerX + a * math.cos(angle), centerZ + b * math.sin(angle)
			gl.Vertex(x, Spring.GetGroundHeight(x, z), z)
			local xbis, zbis = centerX + (a-w) * math.cos(angle), centerZ + (b-w) * math.sin(angle)
			gl.Vertex(xbis, Spring.GetGroundHeight(xbis, zbis), zbis)
		end
	end)
end

function initMouseCursors()
	Spring.AssignMouseCursor("cursor-resize-x-y-1", "cursor-resize-x-y-1", false)
	Spring.AssignMouseCursor("cursor-resize-x-y-2", "cursor-resize-x-y-2", false)
	Spring.AssignMouseCursor("cursor-resize-x", "cursor-resize-x", false)
	Spring.AssignMouseCursor("cursor-resize-y", "cursor-resize-y", false)
end

function changeMouseCursor()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE and zoneStateMachine:getCurrentState() == zoneStateMachine.states.SELECTION then
		local mx, my, leftPressed = Spring.GetMouseState()
		local kind, var = Spring.TraceScreenRay(mx, my, true, true)
		if var ~= nil and selectedZone ~= nil and not leftPressed then
			local x, _, z = unpack(var)
			if getZoneSide(x, z) == "LEFT" or getZoneSide(x, z) == "RIGHT" then
				Spring.SetMouseCursor("cursor-resize-x")
				return
			elseif getZoneSide(x, z) == "TOP" or getZoneSide(x, z) == "BOT" then
				Spring.SetMouseCursor("cursor-resize-y")
				return
			elseif getZoneSide(x, z) == "TOPLEFT" or getZoneSide(x, z) == "BOTRIGHT" then
				Spring.SetMouseCursor("cursor-resize-x-y-1")
				return
			elseif getZoneSide(x, z) == "TOPRIGHT" or getZoneSide(x, z) == "BOTLEFT" then
				Spring.SetMouseCursor("cursor-resize-x-y-2")
				return
			end
		end
		if zoneSide == "LEFT" or zoneSide == "RIGHT" then
			Spring.SetMouseCursor("cursor-resize-x")
		elseif zoneSide == "TOP" or zoneSide == "BOT" then
			Spring.SetMouseCursor("cursor-resize-y")
		elseif zoneSide == "TOPLEFT" or zoneSide == "BOTRIGHT" then
			Spring.SetMouseCursor("cursor-resize-x-y-1")
		elseif zoneSide == "TOPRIGHT" or zoneSide == "BOTLEFT" then
			Spring.SetMouseCursor("cursor-resize-x-y-2")
		else
			Spring.SetMouseCursor("normalcursor")
		end
	else
		Spring.SetMouseCursor("normalcursor")
	end
end

function recursiveResize(obj, textSize)
	if obj.children then
		for i, child in ipairs(obj.children) do
			recursiveResize(child, textSize)
		end
	end
	if obj.font then
		obj.font.size = obj.font.size * textSize
		obj:InvalidateSelf()
	end
end

function updateButtonVisualFeedback() -- Show current states on GUI
	markButtonWithinSet(topBarButtons, globalStateMachine:getCurrentState())
	markButtonWithinSet(unitButtons, unitStateMachine:getCurrentState())
	markButtonWithinSet(teamButtons, teamStateMachine:getCurrentState(), unitStateMachine:getCurrentState() ~= unitStateMachine.states.SELECTION)
	markButtonWithinSet(zoneButtons, zoneStateMachine:getCurrentState())
	markButtonWithinSet(selectAllyTeamsButtons, selectedAllyTeam)
	markButtonWithinSet(forcesTabs, forcesStateMachine:getCurrentState())
	for i, team in ipairs(teamStateMachine.states) do
		markButtonWithinSet(teamControlButtons[team], teamControl[team])
	end
	markButtonWithinSet(eventUI.eventButtons, currentEvent)
	if currentEvent then
		markButtonWithinSet(actionButtons[events[currentEvent].id], currentAction)
		markButtonWithinSet(conditionButtons[events[currentEvent].id], currentCondition)
	end
end

function markButtonWithinSet(buttonTable, markedButton, condition) -- Visual feedback when an option is chosen in a set of options
	local specificCondition = true
	if condition ~= nil then
		specificCondition = condition
	end
	
	for k, b in pairs(buttonTable) do
		local requestUpdate = false
		if b.state.chosen then
			b.state.chosen = false
			requestUpdate = not requestUpdate
		end
		if markedButton == k and not buttonTable[markedButton].state.chosen and specificCondition then
			buttonTable[markedButton].state.chosen = true
			requestUpdate = not requestUpdate
		end
		if requestUpdate then
			b:InvalidateSelf()
		end
	end
end

function widget:DrawScreen()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and unitStateMachine:getCurrentState() == unitStateMachine.states.SELECTION then
		showUnitsInformation()
		drawSelectionRect()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		updateZoneInformation()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.TRIGGER then
		showPickText()
		if triggerStateMachine:getCurrentState() == triggerStateMachine.states.PICKUNIT or triggerStateMachine:getCurrentState() == triggerStateMachine.states.PICKUNITSET then
			showUnitsInformation()
		end
	end
	showZoneInformation()
end

function widget:DrawWorld()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
		previewUnit()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		drawZoneRect()
		drawZoneDisk()
		displaySelectedZoneAnchors()
	end
	displayZones()
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Widget basic functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function widget:Initialize()
	initialize = true
	widgetHandler:RegisterGlobal("GetNewUnitIDsAndContinueLoadMap", GetNewUnitIDsAndContinueLoadMap)
	widgetHandler:RegisterGlobal("saveState", saveState)
	widgetHandler:RegisterGlobal("requestSave", requestSave)
	widgetHandler:RegisterGlobal("beginLoadLevel", beginLoadLevel)
	widgetHandler:RegisterGlobal("requestUnitListUpdate", function() updateUnitList(true) end)
	getCommandsList()
	hideDefaultGUI()
	initChili()
	initTopBar()
	initUnitFunctions()
	initTeamFunctions()
	initMouseCursors()
	initWindows()
	fileFrame()
	initWidgetList()
	initialize = false
	saveState()
end

function widget:Update(delta)
	-- Tell the gadget which units are selected (might be improved in terms of performance)
	local unitSelection = Spring.GetSelectedUnits()
	local msg = "Select Units"
	for i, u in ipairs(unitSelection) do
		msg = msg.."++"..u
	end
	Spring.SendLuaRulesMsg(msg)

	-- Double click timer
	if doubleClick < 0.3 then
		doubleClick = doubleClick + delta
	end
	
	if #unitSelection == 0 then
		clearTemporaryWindows()
	end
	
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
		updateSelectTeamButtons()
		updateUnitList()
		updateUnitHighlights()
		if unitStateMachine:getCurrentState() == unitStateMachine.states.UNITGROUPS then
			updateUnitGroupPanels()
			updateGroupListUnitList()
		end
	end
	
	if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		updateZonePanel()
	end
	
	if globalStateMachine:getCurrentState() == globalStateMachine.states.FORCES then
		updateTeamsWindows()
		if forcesStateMachine:getCurrentState() == forcesStateMachine.states.ALLYTEAMS then
			updateAllyTeamPanels()
		elseif forcesStateMachine:getCurrentState() == forcesStateMachine.states.TEAMCONFIG then
			updateTeamConfigPanels()
		end
	end
	
	if globalStateMachine:getCurrentState() == globalStateMachine.states.TRIGGER then
		preventSpaces()
		updateEventList()
		updateEventFrame()
		updateVariables()
		if currentEvent and (currentAction or currentCondition) then
			updateEditBoxesParams()
		end
	end
	
	if globalStateMachine:getCurrentState() == globalStateMachine.states.MAPSETTINGS then
		updateMapSettings()
		updateWidgetsWindowPosition()
	end
	
	updateButtonVisualFeedback()
	
	changeMouseCursor()
	
	for i, marker in ipairs(markerList) do
		marker.timer = marker.timer - delta
		if marker.timer < 0 then
			Spring.MarkerErasePosition(marker.x, marker.y, marker.z)
			table.remove(markerList, i)
		end
	end
	
	-- Add a cooldown to ctrl+z/y 
	if saveLoadCooldown < 1 then
		saveLoadCooldown = saveLoadCooldown + delta
	end
	
	-- Remove UI elements that do not have a parent from the table so their text size is not updated
	local toBeRemoved = {}
	for i, obj in ipairs(UIelements) do
		if not obj.parent then
			table.insert(toBeRemoved, i)
		end
	end
	for _, i in ipairs(toBeRemoved) do
		table.remove(UIelements, i)
	end
end

function widget:DrawScreenEffects(dse_vsx, dse_vsy)
	if dse_vsx ~= screenSizeX or dse_vsy ~= screenSizeY then
		local textSize = ((dse_vsx/screenSizeX) + (dse_vsy/screenSizeY))/2
		--recursiveResize(Screen0, textSize)
		for i, obj in ipairs(UIelements) do
			if obj.font then
				obj.font.size = obj.font.size * textSize
				obj:InvalidateSelf()
			end
		end
		screenSizeX, screenSizeY = dse_vsx, dse_vsy
	end
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("GetNewUnitIDsAndContinueLoadMap")
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Input functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function widget:MousePress(mx, my, button)
	clearTemporaryWindows()
	-- raycast
	local kind,var = Spring.TraceScreenRay(mx,my)
	
	clickedZone = getClickedZone(mx, my)
	
	-- Change state depending on the clicked element
	if kind == "unit" and globalStateMachine:getCurrentState() ~= globalStateMachine.states.TRIGGER then
		if globalStateMachine:getCurrentState() ~= globalStateMachine.states.UNIT then
			unitFrame()
		end
	elseif clickedZone ~= nil and globalStateMachine:getCurrentState() ~= globalStateMachine.states.TRIGGER then
		if (unitStateMachine:getCurrentState() == unitStateMachine.states.SELECTION or unitStateMachine:getCurrentState() == unitStateMachine.states.UNITGROUPS) and clickedZone.shown and globalStateMachine:getCurrentState() ~= globalStateMachine.states.ZONE then
			zoneFrame()
			zoneStateMachine:setCurrentState(zoneStateMachine.states.SELECTION)
		end
	end
	
	-- Left click
	if button == 1 then
		-- STATE UNIT : place units on the field and select/move/rotate them
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
			-- STATE UNIT : place units on the field
			if unitStateMachine:getCurrentState() ~= unitStateMachine.states.SELECTION and unitStateMachine:getCurrentState() ~= unitStateMachine.states.UNITGROUPS then
				if kind == "ground" then -- If ground is selected and we can place a unit, send a message to the gadget to create the unit
					local xUnit, yUnit, zUnit = unpack(var)
					xUnit, yUnit, zUnit = round(xUnit), round(yUnit), round(zUnit)
					local msg = "Create Unit".."++"..unitStateMachine:getCurrentState().."++"..teamStateMachine:getCurrentState().."++"..tostring(xUnit).."++"..tostring(yUnit).."++"..tostring(zUnit)
					Spring.SendLuaRulesMsg(msg)
				elseif kind == "unit" then -- If unit is selected, go to selection state
					unitStateMachine:setCurrentState(unitStateMachine.states.SELECTION)
				end
			end
			-- STATE SELECTION : select and move units on the field
			if unitStateMachine:getCurrentState() == unitStateMachine.states.SELECTION then
				if kind == "unit" then -- handle movement / selection
					if doubleClick < 0.3 then -- multiple selection of units of same type and same team using double click
						local unitArray = Spring.GetTeamUnitsByDefs(Spring.GetUnitTeam(var), Spring.GetUnitDefID(var)) -- get units of same type and same team
						proceedSelection(unitArray)
						doubleClick = 0.3
						return true
					else
						if Spring.IsUnitSelected(var) then
							if proceedDeselection(var) then -- deselect the unit if shift is pressed
								return false
							else
								clickToSelect = true -- if the unit is already selected and shift is not pressed, allow isolation
							end
						else
							proceedSelection({var}) -- if the unit was not selected, select it and proceed movement
						end
						mouseMove = true
						Spring.SendLuaRulesMsg("Anchor".."++"..var) -- tell the gadget the anchor of the movement
						return true
					end
				else -- start a box selection
					proceedSelection({}) -- deselect all units
					plotSelection = true
					drawStartX, drawEndX = mx, mx
					drawStartY, drawEndY = my, my
					return true
				end
			end
		end
		
		-- STATE ZONE : draw, move and rename logical zones
		if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
			if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWRECT or zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWDISK then
				rValue, gValue, bValue = math.random(), math.random(), math.random() -- define new zone color
				plotZone = true
				drawStartX, drawEndX = mx, mx
				drawStartY, drawEndY = my, my
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.SELECTION then
				local _, var = Spring.TraceScreenRay(mx, my, true, true)
				if var ~= nil then
					local x, _, z = unpack(var)
					zoneAnchorX, zoneAnchorZ = x, z
					-- select new zone
					if selectedZone ~= clickedZone then
						selectedZone = clickedZone
					end
					if selectedZone ~= nil then
						zoneSide = getZoneSide(x, z) -- get side to proceed movement/resizing
						mouseMove = true
					end
				end
			end
			clickToSelect = true
			return true
		end
		
		-- STATE TRIGGER
		if globalStateMachine:getCurrentState() == globalStateMachine.states.TRIGGER then
			local e = {}
			if currentEvent then
				if currentAction then
					e = events[currentEvent].actions[currentAction]
				elseif currentCondition then
					e = events[currentEvent].conditions[currentCondition]
				end
			end
			if triggerStateMachine:getCurrentState() == triggerStateMachine.states.PICKPOSITION then
				local kind, var = Spring.TraceScreenRay(mx, my, true, true)
				if var and currentEvent and (currentCondition or currentAction) then
					triggerStateMachine:setCurrentState(triggerStateMachine.states.DEFAULT)
					local x, _, z = unpack(var)
					e.params[changedParam] = {}
					e.params[changedParam].x = round(x)
					e.params[changedParam].z = round(z)
					Screen0:AddChild(windows["triggerWindow"])
					Screen0:AddChild(windows["eventWindow"])
					Screen0:AddChild(windows["importWindow"])
					Screen0:RemoveChild(randomInZoneWindow)
					if currentAction then
						Screen0:AddChild(windows["actionWindow"])
						drawActionFrame(false)
					elseif currentCondition then
						Screen0:AddChild(windows["conditionWindow"])
						drawConditionFrame(false)
					end
				end
			elseif triggerStateMachine:getCurrentState() == triggerStateMachine.states.PICKUNITSET or triggerStateMachine:getCurrentState() == triggerStateMachine.states.PICKUNIT then
				if kind == "unit" and currentEvent then
					triggerStateMachine:setCurrentState(triggerStateMachine.states.DEFAULT)
					e.params[changedParam] = {}
					e.params[changedParam].type = "unit"
					e.params[changedParam].value = var
					Screen0:AddChild(windows["triggerWindow"])
					Screen0:AddChild(windows["eventWindow"])
					Screen0:AddChild(windows["importWindow"])
					Screen0:RemoveChild(selectSetOfUnitsWindows.actcond)
					Screen0:RemoveChild(selectSetOfUnitsWindows.groupteam)
					if currentAction then
						Screen0:AddChild(windows["actionWindow"])
						drawActionFrame(false)
					elseif currentCondition then
						Screen0:AddChild(windows["conditionWindow"])
						drawConditionFrame(false)
					end
				end
			end
		end
		
	-- Right click
	elseif button == 3 then
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then -- enable selection / disable unit placement
			unitStateMachine:setCurrentState(unitStateMachine.states.SELECTION)
			if kind == "unit" then
				local unitSelection = Spring.GetSelectedUnits()
				if #unitSelection == 0 or not Spring.IsUnitSelected(var) then
					proceedSelection({var})
				end
				if Spring.IsUnitSelected(var) then
					Screen0:AddChild(unitContextualMenu)
					if mx + unitContextualMenu.width > screenSizeX then -- force contextual menu in the screen region
						unitContextualMenu.x = mx - unitContextualMenu.width
					else
						unitContextualMenu.x = mx
					end
					if screenSizeY - my + unitContextualMenu.height > screenSizeY then
						unitContextualMenu.y = screenSizeY - my - unitContextualMenu.height
					else
						unitContextualMenu.y = screenSizeY - my
					end
				end
			end
		elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then -- enable selection / disable zone placement
			zoneStateMachine:setCurrentState(zoneStateMachine.states.SELECTION)
		end
	end
end

function widget:MouseRelease(mx, my, button)
	if button == 1 then
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and unitStateMachine:getCurrentState() == unitStateMachine.states.SELECTION then
			-- raycast
			local kind, var = Spring.TraceScreenRay(mx, my)
			if kind == "unit" then
				if clickToSelect and doubleClick > 0.3 then -- isolate one unit if the mouse did not move during the process
					proceedSelection({var})
					clickToSelect = false
				end
			end
			-- return in idle state
			plotSelection = false
			mouseMove = false
		end
		
		if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
			if clickToSelect then -- select clicked zone and go to selection state
				selectedZone = clickedZone
				zoneStateMachine:setCurrentState(zoneStateMachine.states.SELECTION)
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWRECT then
				local zone = 	{ 	
										red = rValue, green = gValue, blue = bValue,
										x1 = round(zonePositions.zoneX1) - round(zonePositions.zoneX1)%8,
										x2 = round(zonePositions.zoneX2) - round(zonePositions.zoneX2)%8,
										z1 = round(zonePositions.zoneZ1) - round(zonePositions.zoneZ1)%8,
										z2 = round(zonePositions.zoneZ2) - round(zonePositions.zoneZ2)%8,
										id = zoneNumber,
										name = EDITOR_ZONES_DEFAULT_NAME.." "..zoneNumber,
										type = "Rectangle",
										shown = true,
										alwaysInView = false,
										marker = false
									}
				if zone.x2 - zone.x1 >= minZoneSize and zone.z2 - zone.z1 >= minZoneSize then -- if the drew zone is large enough, store it
					table.insert(zoneList, zone)
					zoneNumber = zoneNumber + 1
					requestSave()
				end
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWDISK then
				local zone = 	{ 	
										red = rValue, green = gValue, blue = bValue,
										a = round((zonePositions.zoneX2 - zonePositions.zoneX1) / 2) - round((zonePositions.zoneX2 - zonePositions.zoneX1) / 2)%8,
										b = round((zonePositions.zoneZ2 - zonePositions.zoneZ1) / 2) - round((zonePositions.zoneZ2 - zonePositions.zoneZ1) / 2)%8,
										x = round((zonePositions.zoneX1 + zonePositions.zoneX2) / 2) - round((zonePositions.zoneX1 + zonePositions.zoneX2) / 2)%8,
										z = round((zonePositions.zoneZ1 + zonePositions.zoneZ2) / 2) - round((zonePositions.zoneZ1 + zonePositions.zoneZ2) / 2)%8,
										id = zoneNumber,
										name = EDITOR_ZONES_DEFAULT_NAME.." "..zoneNumber,
										type = "Disk",
										shown = true,
										alwaysInView = false,
										marker = false
									}
				if 2*zone.a >= minZoneSize and 2*zone.b >= minZoneSize then -- if the drew zone is large enough, store it
					table.insert(zoneList, zone)
					zoneNumber = zoneNumber + 1
					requestSave()
				end
			end
			plotZone = false
			mouseMove = false
			zoneSide = ""
		end
	end
	doubleClick = 0 -- reset double click timer
	if toSave then
		saveState()
		toSave = false
	end
	return true
end

function widget:MouseMove(mx, my, dmx, dmy, button)	
	-- disable click to select and double click if mousemove
	clickToSelect = false
	doubleClick = 0.3
	
	if button == 1 then
		-- STATE SELECTION
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and unitStateMachine:getCurrentState() == unitStateMachine.states.SELECTION then
			local altPressed, ctrlPressed = Spring.GetModKeyState()
			if altPressed then -- Send a message to the gadget to rotate selectedUnits
				local kind, var = Spring.TraceScreenRay(mx, my, true, true)
				if var ~= nil then
					local x, _, z = unpack(var)
					local msg = "Rotate Units".."++"..x.."++"..z
					Spring.SendLuaRulesMsg(msg)
				end
			elseif ctrlPressed then -- Send a message to the gadget to make unit face a point
				local kind, var = Spring.TraceScreenRay(mx, my, true, true)
				if var ~= nil then
					local x, _, z = unpack(var)
					local msg = "Face Units".."++"..x.."++"..z
					Spring.SendLuaRulesMsg(msg)
				end
			else -- Send a message to the gadget to move selected units
				if mouseMove and not plotSelection then
					local _, pos = Spring.TraceScreenRay(mx, my, true)
					if pos then
						local x, _, z = unpack(pos)
						x, z = round(x), round(z)
						local msg = "Move Units".."++"..x.."++"..z
						Spring.SendLuaRulesMsg(msg)
					end
				end
				-- update selection box
				if plotSelection then
					drawEndX = mx
					drawEndY = my
					-- Select all units in the rectangle
					local unitSelection = GetUnitsInScreenRectangle(drawStartX, drawStartY, drawEndX, drawEndY)
					proceedSelection(unitSelection)
				end
			end
		end
		
		-- STATE ZONE
		if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
			if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWRECT or zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWDISK then
				-- update zone
				if plotZone then
					drawEndX = mx
					drawEndY = my
				end
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.SELECTION then
				if mouseMove and selectedZone then
					local _, var = Spring.TraceScreenRay(mx, my, true, true)
					if var ~= nil then
						local x, _, z = unpack(var)
						x, z = round(x), round(z)
						local dx, dz = round(x - zoneAnchorX), round(z - zoneAnchorZ)
						dx = dx - sign(dx) * ( (sign(dx)*dx)%8 ) -- compute variations modulo 8 (complex because operator % only accepts positive numbers)
						dz = dz - sign(dz) * ( (sign(dz)*dz)%8 )
						applyChangesToSelectedZone(dx, dz)
						requestSave()
					end
				end
			end
		end
	end
end

function widget:KeyPress(key, mods)
	-- Global 
	-- CTRL + S : save the current map
	if key == Spring.GetKeyCode("s") and mods.ctrl then
		saveMapFrame()
		return true
	-- CTRL + O : load a map
	elseif key == Spring.GetKeyCode("o") and mods.ctrl then
		loadMapFrame()
		return true
	-- CTRL + N : new map
	elseif key == Spring.GetKeyCode("n") and mods.ctrl then
		newMapFrame()
		return true
	-- CTRL + Z
	elseif key == Spring.GetKeyCode("z") and mods.ctrl and saveLoadCooldown > 0.2 then
		saveLoadCooldown = 0
		loadState(1)
		return true
	-- CTRL + Y
	elseif key == Spring.GetKeyCode("y") and mods.ctrl and saveLoadCooldown > 0.2 then
		saveLoadCooldown = 0
		loadState(-1)
		return true
	-- ESCAPE : back to file menu
	elseif key == Spring.GetKeyCode("esc") then
		if globalStateMachine:getCurrentState() == globalStateMachine.states.NONE then
			backToMenuFrame()
		else
			clearUI()
		end
		return true
	-- ENTER
	elseif key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
		if newUnitGroupEditBox then
			if newUnitGroupEditBox.state.focused and newUnitGroupEditBox.text ~= "" then
				addUnitGroup(newUnitGroupEditBox.text)
				clearTemporaryWindows()
			end
		end
		return true
	end
	-- Selection state
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and unitStateMachine:getCurrentState() == unitStateMachine.states.SELECTION then
		local unitSelection = Spring.GetSelectedUnits()
		-- CTRL + A : select all units
		if key == Spring.GetKeyCode("a") and mods.ctrl then
			Spring.SelectUnitArray(Spring.GetAllUnits())
			return true
		-- DELETE : delete selected units
		elseif key == Spring.GetKeyCode("delete") then
			for i, g in ipairs(unitGroups) do
				for i, u in ipairs(unitSelection) do
					if findInTable(g.units, u) then
						removeUnitFromGroup(g, u)
					end
				end
			end
			Spring.SendLuaRulesMsg("Delete Selected Units")
			return true
		end
		-- ARROWS : move selected units
		if #unitSelection > 0 then
			if key == Spring.GetKeyCode("up") then
				Spring.SendLuaRulesMsg("Anchor".."++"..unitSelection[1])
				local msg = "Translate Units".."++".."0".."++".."-1"
				Spring.SendLuaRulesMsg(msg)
				return true
			elseif key == Spring.GetKeyCode("down") then
				Spring.SendLuaRulesMsg("Anchor".."++"..unitSelection[1])
				local msg = "Translate Units".."++".."0".."++".."1"
				Spring.SendLuaRulesMsg(msg)
				return true
			elseif key == Spring.GetKeyCode("left") then
				Spring.SendLuaRulesMsg("Anchor".."++"..unitSelection[1])
				local msg = "Translate Units".."++".."-1".."++".."0"
				Spring.SendLuaRulesMsg(msg)
				return true
			elseif key == Spring.GetKeyCode("right") then
				Spring.SendLuaRulesMsg("Anchor".."++"..unitSelection[1])
				local msg = "Translate Units".."++".."1".."++".."0"
				Spring.SendLuaRulesMsg(msg)
				return true
			end
		end
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		if selectedZone ~= nil then
			-- DELETE : delete selected zone
			if key == Spring.GetKeyCode("delete") then
				for i, z in ipairs(zoneList) do
					if z == selectedZone then
						table.remove(zoneList, i)
						selectedZone = nil
						break
					end
				end
				saveState()
				return true
			-- ARROWS : move selected zone
			elseif key == Spring.GetKeyCode("up") then
				if selectedZone.type == "Rectangle" then
					selectedZone.z1 = selectedZone.z1 - 8
					selectedZone.z2 = selectedZone.z2 - 8
				elseif selectedZone.type == "Disk" then
					selectedZone.z = selectedZone.z - 8
				end
				return true
			elseif key == Spring.GetKeyCode("down") then
				if selectedZone.type == "Rectangle" then
					selectedZone.z1 = selectedZone.z1 + 8
					selectedZone.z2 = selectedZone.z2 + 8
				elseif selectedZone.type == "Disk" then
					selectedZone.z = selectedZone.z + 8
				end
				return true
			elseif key == Spring.GetKeyCode("left") then
				if selectedZone.type == "Rectangle" then
					selectedZone.x1 = selectedZone.x1 - 8
					selectedZone.x2 = selectedZone.x2 - 8
				elseif selectedZone.type == "Disk" then
					selectedZone.x = selectedZone.x - 8
				end
				return true
			elseif key == Spring.GetKeyCode("right") then
				if selectedZone.type == "Rectangle" then
					selectedZone.x1 = selectedZone.x1 + 8
					selectedZone.x2 = selectedZone.x2 + 8
				elseif selectedZone.type == "Disk" then
					selectedZone.x = selectedZone.x + 8
				end
				return true
			end
		end
	end
	return false
end
