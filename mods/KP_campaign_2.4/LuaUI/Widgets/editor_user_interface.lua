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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Variables
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Global UI Variables
local Chili, Screen0 -- Chili framework, main screen
local windows, topBarButtons = {}, {} -- references to UI elements
local globalFunctions, unitFunctions, teamFunctions = {}, {}, {} -- Generated functions for some buttons

-- File Variables
local fileButtons = {}

-- Unit Variables
local factionUnits = getFactionUnits() -- List of units sorted by faction
local teams = getTeamsInformation() -- List of teams as read in the LevelEditor.txt file (contains id and color)
local teamCount = tableLength(teamStateMachine.states) -- Total number of teams
local unitScrollPanel
local unitButtons = {} -- Contains every type of unit as defined in UnitDef, buttons used to place units on the field
local teamLabels = {}
local teamButtons = {} -- Contains every teams, buttons used to define the team of units being placed
local teamImages = {}
local unitContextualMenu -- Appears when right-clicking on a unit
local unitAttributesWindow
local unitGroups = {} -- Contains logical groups of units
local unitTotal = 0 -- Total number of units placed on the field
local groupNumber = 1 -- Current ID of a newly created group
local groupTotal = nil -- Total number of unit groups
local groupSizes = {} -- Contains the total number of units in each group
local unitGroupsAttributionWindow -- Pop-up window to add selected units to a group
local unitGroupsRemovalWindow -- Pop-up window to remove selected units from a group
local unitListScrollPanel -- List of units placed on the field
local unitListLabels = {}
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

-- Draw selection variables
local drawStartX, drawStartY, drawEndX, drawEndY, screenSizeX, screenSizeY = 0, 0, 0, 0, 0, 0
local plotSelection = false
local selectionRect -- Selection visual feedback
function widget:DrawScreenEffects(dse_vsx, dse_vsy) screenSizeX, screenSizeY = dse_vsx, dse_vsy end

-- Zone variables
local zoneButtons = {} -- Choose which type of zone to create
local zoneScrollPanel -- List of zones placed
local zoneBoxes = {} -- Contains an editbox to rename a zone and checkbox to display it
local plotZone = false -- Lock to plot a new zone
local rValue, gValue, bValue = 0, 0, 0 -- Color of the new zone
local zoneX1, zoneX2, zoneZ1, zoneZ2 = 0, 0, 0, 0 -- Position of the new zone
local zoneAnchorX, zoneAnchorZ = 0, 0 -- Mouse anchor when resizing a zone
local minZoneSize = 32
local zoneList = {}
local selectedZone = nil
local zoneSide = "" -- Corresponds to the side on which the user clicked to resize a zone
local totalZones = 0 -- Total number of placed zones
local zoneNumber = 1 -- Current ID of a newly created zone

-- Forces variables
local forcesTabs = {} -- Top frame buttons
local teamConfigWindow, allyTeamsWindow -- Windows in the force frame
local allyTeams = {} -- List of ally teams
local allyTeamsSize = {} -- Respective sizes of ally teams
local allyTeamsRemoveTeamButtons = {} -- Remove team from an ally team
local allyTeamsRemoveTeamLabels = {} -- Name of teams in a ally team
local selectAllyTeamsButtons = {} -- Select an ally team
local allyTeamsListButtons = {} -- Add a team to the selected ally team
local allyTeamsScrollPanels = {} -- Contains the allyTeamsListButtons
local selectedAllyTeam = 0 -- Currently selected ally team
local teamControlButtons = {} -- Allows the user to set how the team should be controlled
local teamControl = {} -- player or computer
local teamStateButtons = {} -- Allows the user to set if the team is enabled or not
local teamState = {} -- enabled or disabled
local teamColorTrackbars = {}
local teamColor = {}
local teamColorImage = {}

-- Mouse variables
local mouseMove = false
local clickToSelect = false -- Enable isolation through clicking on an already selected unit
local doubleClick = 0

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Chili UI functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function initChili()
	if (not WG.Chili) then
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
		OnClick = {onClickFunction}
	}
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
		valign = _valign or "linecenter"
	}
	label.font.color = _color or {1, 1, 1, 1}
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
		fontsize = size or 20
	}
	textBox.font.color = _color or {1, 1, 1, 1}
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
		text = _text or ""
	}
	editBox.font.color = _color or {1, 1, 1, 1}
	if type(_h) ~= "string" then
		editBox.font.size = _h
	else
		editBox.font.size = 16
	end
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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Top bar functions (show/hide panels)
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function clearUI() -- remove every windows except topbar and clear current selection
	for key, w in pairs(windows) do
		if (key ~= "topBar") then
			Screen0:RemoveChild(w)
		end
	end
	selectedZone = nil
	Spring.SelectUnitArray({})
	clearTemporaryWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.NONE)
end
function clearTemporaryWindows()
	Screen0:RemoveChild(unitContextualMenu)
	Screen0:RemoveChild(unitGroupsAttributionWindow)
	Screen0:RemoveChild(unitGroupsRemovalWindow)
	Screen0:RemoveChild(unitAttributesWindow)
end
function fileFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.FILE)
	Screen0:AddChild(windows["fileWindow"])
end
function unitFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.UNIT)
	unitStateMachine:setCurrentState(unitStateMachine.states.SELECTION)
	teamStateMachine:setCurrentState(teamStateMachine:getCurrentState())
	Screen0:AddChild(windows["unitWindow"])
	Screen0:AddChild(windows["unitListWindow"])
end
function zoneFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.ZONE)
	zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWRECT)
	Screen0:AddChild(windows["zoneWindow"])
end
function forcesFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.FORCES)
	Screen0:AddChild(windows["forceWindow"])
	if forcesStateMachine:getCurrentState() == forcesStateMachine.states.TEAMCONFIG then
		teamConfig()
	elseif forcesStateMachine:getCurrentState() == forcesStateMachine.states.ALLYTEAMS then
		allyTeam()
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Forces window buttons functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function clearForceWindow()
	windows['forceWindow']:RemoveChild(teamConfigWindow)
	windows['forceWindow']:RemoveChild(allyTeamsWindow)
end
function teamConfig()
	clearForceWindow()
	forcesStateMachine:setCurrentState(forcesStateMachine.states.TEAMCONFIG)
	windows['forceWindow']:AddChild(teamConfigWindow)
end
function allyTeam()
	clearForceWindow()
	forcesStateMachine:setCurrentState(forcesStateMachine.states.ALLYTEAMS)
	windows['forceWindow']:AddChild(allyTeamsWindow)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Initialisation functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function hideDefaultGUI()
	-- get rid of engine UI
	Spring.SendCommands("resbar 0","fps 1","console 0","info 0")
	-- leaves rendering duty to widget (we won't)
	gl.SlaveMiniMap(true)
	-- a hitbox remains for the minimap, unless you do this
	gl.ConfigMiniMap(0,0,0,0)
end
function initTopBar()
	-- Top bar
	windows['topBar'] = addWindow(Screen0, '0%', '0%', '100%', '5%')
	
	-- Menu buttons
	topBarButtons[globalStateMachine.states.FILE] = addButton(windows["topBar"], '0%', '0%', '10%', '100%', 'File', fileFrame)
	topBarButtons[globalStateMachine.states.UNIT] = addButton(windows["topBar"], '15%', '0%', '10%', '100%', 'Units', unitFrame)
	topBarButtons[globalStateMachine.states.ZONE] = addButton(windows["topBar"], '25%', '0%', '10%', '100%', 'Zones', zoneFrame)
	topBarButtons[globalStateMachine.states.FORCES] = addButton(windows["topBar"], '40%', '0%', '10%', '100%', 'Forces', forcesFrame)
	topBarButtons[globalStateMachine.states.TRIGGER] = addButton(windows["topBar"], '50%', '0%', '10%', '100%', 'Triggers', nil)
end
function initWindows()
	initFileWindow()
	initUnitWindow()
	initUnitContextualMenu()
	initZoneWindow()
	initForcesWindow()
end
function initFileWindow()
	windows['fileWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	addLabel(windows['fileWindow'], '0%', '1%', '100%', '5%', "File")
	fileButtons['new'] = addButton(windows['fileWindow'], '0%', '10%', '100%', '10%', "New Map", newMap) -- needs a rework
	fileButtons['load'] = addButton(windows['fileWindow'], '0%', '20%', '100%', '10%', "Load Map", function() loadMap("Missions/jsonFiles/Mission3.json") end)
end
function initUnitWindow()
	-- Left Panel
	windows['unitWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	unitScrollPanel = addScrollPanel(windows['unitWindow'], '0%', '5%', '100%', '80%')
	
	-- Unit Buttons
	addLabel(windows['unitWindow'], '0%', '1%', '100%', '5%', "Units")
	local button_size = 40
	local y = 0
	for c, t in ipairs(factionUnits) do
		if c == #factionUnits then
			addLabel(unitScrollPanel, '0%', y, '100%', button_size, "Unstable units", 20, "center", nil, "center")
		else
			addLabel(unitScrollPanel, '0%', y, '100%', button_size, "Faction "..c, 20, "center", nil, "center")
		end
		y = y + button_size
		for i, u in ipairs(t) do
			unitButtons[u] = addButton(unitScrollPanel, '0%', y, '100%', button_size, UnitDefNames[u].humanName, unitFunctions[u])
			y = y + button_size
		end
	end
	
	-- Team buttons
	addLabel(windows["unitWindow"], '0%', '87%', '100%', '5%', "Team")
	for k, team in pairs(teamStateMachine.states) do
		local x = tostring(team * 100 / math.ceil(teamCount/2) - 100 * math.floor(team/math.ceil(teamCount/2))).."%"
		local y = tostring(90 + 5 * math.floor(team/math.ceil(teamCount/2))).."%"
		local w = tostring(100 / math.ceil(teamCount/2)).."%"
		local h = "5%"
		local color = {teams[team].red, teams[team].green, teams[team].blue, 1}
		teamButtons[team] = addButton(windows["unitWindow"], x, y, w, h, "", teamFunctions[team])
		teamImages[team] = addImage(teamButtons[team], "0%", "0%", "100%", "100%", "bitmaps/editor/blank.png", false, color)
		teamLabels[team] = addLabel(teamImages[team], "0%", "0%", "100%", "100%", team, 15, "center", nil, "center")
	end
	
	-- Unit List
	windows['unitListWindow'] = addWindow(Screen0, "85%", '5%', '15%', '80%')
	addLabel(windows['unitListWindow'], '0%', '1%', '100%', '5%', "Unit List")
	unitListScrollPanel = addScrollPanel(windows['unitListWindow'], '0%', '5%', '100%', '85%')
	local showGroupsWindow = function()
		Screen0:AddChild(windows["unitGroupsWindow"])
		Screen0:RemoveChild(windows['unitListWindow'])
		Screen0:RemoveChild(windows['unitWindow'])
	end
	local showGroupsButton = addButton(windows['unitListWindow'], '0%', '90%', '100%', '10%', "Show Unit Groups", showGroupsWindow)
	
	-- Unit Groups Window
	windows["unitGroupsWindow"] = addWindow(Screen0, "5%", "10%", '90%', '80%', true)
	addLabel(windows["unitGroupsWindow"], '0%', '0%', '18%', '10%', "Unit List", 30, "center", nil, "center")
	groupListUnitsScrollPanel = addScrollPanel(windows["unitGroupsWindow"], '0%', '10%', '18%', '90%')
	addUnitsToGroupsButton = addButton(windows["unitGroupsWindow"], '18%', '50%', '4%', '10%', ">>", addChosenUnitsToSelectedGroups)
	addLabel(windows["unitGroupsWindow"], '22%', '0%', '78%', '10%', "Group List", 30, "center", nil, "center")
	groupListScrollPanel = addScrollPanel(windows["unitGroupsWindow"], '22%', '10%', '78%', '90%')
	local closeGroupsWindow = function()
		Screen0:RemoveChild(windows["unitGroupsWindow"])
		Screen0:AddChild(windows['unitListWindow'])
		Screen0:AddChild(windows['unitWindow'])
		showGroupsButton:InvalidateSelf()
	end
	local closeButton = addButton(windows["unitGroupsWindow"], "95%", "0%", "5%", "5%", "X", closeGroupsWindow)
	closeButton.font.color = {1, 0, 0, 1}
end
function initUnitContextualMenu()
	unitContextualMenu = addWindow(nil, 0, 0, 200, 200)
	addButton(unitContextualMenu, '0%', "0%", '100%', tostring(100/3).."%", "Edit Attributes", showUnitAttributes)
	addButton(unitContextualMenu, '0%', tostring(100/3).."%", '100%', tostring(100/3).."%", "Add to group", showUnitGroupsAttributionWindow)
	addButton(unitContextualMenu, '0%', tostring(200/3).."%", '100%', tostring(100/3).."%", "Remove from group", showUnitGroupsRemovalWindow)
end
function initZoneWindow()
	windows['zoneWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	addLabel(windows['zoneWindow'], '0%', '1%', '100%', '5%', "Zone")
	zoneButtons[zoneStateMachine.states.DRAWRECT] = addButton(windows['zoneWindow'], '0%', '5%', '50%', '10%', "", function() zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWRECT) selectedZone = nil end)
	addImage(zoneButtons[zoneStateMachine.states.DRAWRECT], '0%', '0%', '100%', '100%', "bitmaps/editor/rectangle.png")
	zoneButtons[zoneStateMachine.states.DRAWDISK] = addButton(windows['zoneWindow'], '50%', '5%', '50%', '10%', "", function() zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWDISK) selectedZone = nil end) -- TODO
	addImage(zoneButtons[zoneStateMachine.states.DRAWDISK], '0%', '0%', '100%', '100%', "bitmaps/editor/disk.png")
	zoneScrollPanel = addScrollPanel(windows['zoneWindow'], '0%', '15%', '100%', '85%')
	
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
	addButton(zoneScrollPanel, 0, 0, "50%", 30, "Show all", toggleAllOn)
	addButton(zoneScrollPanel, "50%", 0, "50%", 30, "Hide all", toggleAllOff)
end
function initForcesWindow()
	windows['forceWindow'] = addWindow(Screen0, '10%', '10%', '80%', '80%', true)
	forcesTabs[forcesStateMachine.states.TEAMCONFIG] = addButton(windows['forceWindow'], "0%", "0%", tostring(95/3).."%", '5%', "Teams Configuration", teamConfig)
	forcesTabs[forcesStateMachine.states.ALLYTEAMS] = addButton(windows['forceWindow'], tostring(95/3).."%", "0%", tostring(95/3).."%", '5%', "Ally Teams", allyTeam)
	local closeButton = addButton(windows['forceWindow'], "95%", "0%", "5%", "5%", "X", clearUI)
	closeButton.font.color = {1, 0, 0, 1}
	
	-- Team Config Window
	teamConfigWindow = addWindow(windows['forceWindow'], 0, '5%', '100%', '95%')
	local teamConfigScrollPanel = addScrollPanel(teamConfigWindow, '0%', '0%', '100%', '100%')
	for k, team in pairs(teamStateMachine.states) do
		local panel = addPanel(teamConfigScrollPanel, '0%', team * 100, '100%', 100)
		addLabel(panel, '0%', '0%', '20%', '100%', "Team "..tostring(team), 30, "center", {teams[team].red, teams[team].green, teams[team].blue, 1}, "center")
		-- Enabled/Disabled
		teamStateButtons[team] = {}
		teamStateButtons[team].enabled = addButton(panel, '20%', '10%', '10%', '35%', "Enabled", function() teamState[team] = "enabled" end)
		teamStateButtons[team].disabled = addButton(panel, '20%', '55%', '10%', '35%', "Disabled", function() teamState[team] = "disabled" end)
		teamState[team] = "disabled"
		-- Controlled by
		addLabel(panel, '35%', '20%', '20%', '30%', "Controlled by", 20, "center", nil, "center")
		teamControlButtons[team] = {}
		teamControlButtons[team].player = addButton(panel, '35%', '50%', '10%', '30%', "Player", function() teamControl[team] = "player" end)
		teamControlButtons[team].computer = addButton(panel, '45%', '50%', '10%', '30%', "Computer", function() teamControl[team] = "computer" end)
		teamControl[team] = "player"
		-- Color
		teamColor[team] = {}
		teamColor[team].red = tonumber(teams[team].red)
		teamColor[team].green = tonumber(teams[team].green)
		teamColor[team].blue = tonumber(teams[team].blue)
		addLabel(panel, '60%', '20%', '20%', '30%', "In-game color", 20, "center", nil, "center")
		teamColorImage[team] = addImage(panel, '82%', '20%', '5%', '60%', "bitmaps/editor/blank.png", false, {teamColor[team].red, teamColor[team].green, teamColor[team].blue, 1})
		teamColorTrackbars[team] = {}
		teamColorTrackbars[team].red = addTrackbar(panel, '60%', '50%', tostring(20/3).."%", "30%", 0, 1, teamColor[team].red, 0.02)
		teamColorTrackbars[team].green = addTrackbar(panel, tostring(60 + 20/3)..'%', '50%', tostring(20/3).."%", "30%", 0, 1, teamColor[team].green, 0.02)
		teamColorTrackbars[team].blue = addTrackbar(panel, tostring(60 + 40/3)..'%', '50%', tostring(20/3).."%", "30%", 0, 1, teamColor[team].blue, 0.02)
		local function updateImage()
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
	end
	
	-- Ally Team Window
	allyTeamsWindow = addWindow(windows['forceWindow'], 0, '5%', '100%', '95%')
	addLabel(allyTeamsWindow, '0%', '0%', '20%', '10%', "Team List", 30, "center", nil, "center")
	local teamListScrollPanel = addScrollPanel(allyTeamsWindow, '2%', '10%', '16%', '85%') -- List of all the teams
	for k, team in pairs(teamStateMachine.states) do
		local x = tostring(20 + team * 80 / math.ceil(teamCount/2) - 80 * math.floor(team/math.ceil(teamCount/2)))..'%'
		local y = tostring(0 + 50 * math.floor(team/math.ceil(teamCount/2))).."%"
		local w = tostring(80 / math.ceil(teamCount/2)).."%"
		local h = "50%"
		local panel = addWindow(allyTeamsWindow, x, y, w, h)
		selectAllyTeamsButtons[team] = addButton(panel, '0%', '0%', '100%', '10%', "Team "..tostring(team), function() selectedAllyTeam = team end)
		selectAllyTeamsButtons[team].font.color = {teams[team].red, teams[team].green, teams[team].blue, 1}
		selectAllyTeamsButtons[team].font.size = 20
		allyTeamsScrollPanels[team] = addScrollPanel(panel, '2%', '10%', '96%', '89%')
		
		allyTeamsListButtons[team] = addButton(teamListScrollPanel, '80%', 40*team, '20%', 40, ">>", function() addTeamToSelectedAllyTeam(team) end)
		addLabel(teamListScrollPanel, '0%', 40*team, '80%', 40, "Team "..tostring(team), 20, "center", {teams[team].red, teams[team].green, teams[team].blue, 1}, "center")
		
		allyTeamsRemoveTeamButtons[team] = {}
		allyTeamsRemoveTeamLabels[team] = {}
		
		allyTeams[team] = {}
		allyTeamsSize[team] = 0
	end
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

function applyChangesToSelectedUnits()-- Tell the gadget to apply changes to units attributes
	-- do something
	clearTemporaryWindows()
end
function drawSelectionRect() -- Draw the selection feedback rectangle
	if selectionRect ~= nil then
		Screen0:RemoveChild(selectionRect)
		selectionRect:Dispose()
	end
	if plotSelection then -- only draw it when mouse button 1 is down and global state is selection
		-- compute good values for x1, x2, y1, y2, regarding respective anchors
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
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and unitStateMachine:getCurrentState() ~= unitStateMachine.states.SELECTION and not Screen0.hoveredControl then
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
	addLabel(unitAttributesWindow, '0%', 0, "100%", 20, "Attributes", 20)
	addLabel(unitAttributesWindow, '0%', 50, "30%", 20, "HP%", 20, "right")
	if #unitSelection == 1 then -- if unit is alone, show its hp percentage in the editbox
		local h, mh = Spring.GetUnitHealth(unitSelection[1])
		addEditBox(unitAttributesWindow, "35%", 50, "65%", 20, "left", tostring(round(100*(h/mh))))
	else
		addEditBox(unitAttributesWindow, "35%", 50, "65%", 20, "left")
	end
	addButton(unitAttributesWindow, 0, "85%", "100%", "15%", "Apply", applyChangesToSelectedUnits)
end
function showUnitsInformation() -- Show information about selected and hovered units
	gl.BeginText()
	local unitSelection = Spring.GetSelectedUnits()
	for i, u in ipairs(unitSelection) do
		showUnitInformation(u)
	end
	
	-- Draw information above hovered unit
	local mx, my = Spring.GetMouseState()
	local kind, var = Spring.TraceScreenRay(mx, my)
	if kind == "unit" then
		local isUnitSelected = false
		for _, u in ipairs(unitSelection) do
			if var == u then
				isUnitSelected = true
				break
			end
		end
		if not isUnitSelected then
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
	for k, group in pairs(unitGroups) do -- Show already created unit groups
		addButton(attributionWindowScrollPanel, '0%', count * 40, '100%', 40, group.name, function() addSelectedUnitsToGroup(group) clearTemporaryWindows() end) -- Add unit selection to this group
		count = count + 1
	end
	
	local newUnitGroupEditBox = addEditBox(attributionWindowScrollPanel, '0%', count * 40, '80%', 40, "left", "") -- Allow the creation of a new group
	newUnitGroupEditBox.font.size = 14
	newUnitGroupEditBox.hint = "New Group"
	local function newGroup()
		if newUnitGroupEditBox.text ~= "" then
			addUnitGroup(newUnitGroupEditBox.text)
			clearTemporaryWindows()
		end
	end
	local newUnitValidationButton = addButton(attributionWindowScrollPanel, '80%', count * 40, '20%', 40, "OK", newGroup)
end
function showUnitGroupsRemovalWindow() -- Show a small window allowing to remove the current selection from a group
	clearTemporaryWindows()
	unitGroupsRemovalWindow = addWindow(Screen0, '75%', '5%', '10%', '40%', true)
	local removalWindowScrollPanel = addScrollPanel(unitGroupsRemovalWindow, '0%', '0%', '100%', '100%')
	
	local noGroupsInCommon = true
	local unitSelection = Spring.GetSelectedUnits()
	
	local count = 0
	for k, group in pairs(unitGroups) do
		local addUnitGroupButton = true
		for i, u in ipairs(unitSelection) do
			if not findInTable(group.units, u) then
				addUnitGroupButton = false -- Only display groups that are common to every units of the current selection
				break
			end
		end
		if addUnitGroupButton then
			addButton(removalWindowScrollPanel, '0%', count * 40, '100%', 40, group.name, function() removeSelectedUnitsFromGroup(group) clearTemporaryWindows() end) -- Remove unit selection from this group
			count = count + 1
			noGroupsInCommon = false
		end
	end
	
	if noGroupsInCommon then -- If units have to groups in common or the selected unit does not belong to any group, display a specific message
		unitGroupsRemovalWindow:RemoveChild(removalWindowScrollPanel)
		local text = "Selected units have no groups in common."
		if unitSelection.n == 1 then
			text = "This unit does not belong to any group."
		end
		addTextBox(unitGroupsRemovalWindow, '0%', '0%', '100%', '100%', text, 20, {1, 0, 0, 1})
	end
end
function updateUnitList() -- When a unit is created, update the two units lists (on the screen and in the unit groups frame)
	local units = Spring.GetAllUnits()
	if units.n ~= unitTotal then
		-- Clear UI elements
		for k, l in pairs(unitListLabels) do
			unitListScrollPanel:RemoveChild(l)
			l:Dispose()
		end
		for k, b in pairs(unitListViewButtons) do
			unitListScrollPanel:RemoveChild(b)
			b:Dispose()
		end
		for k, i in pairs(unitListHighlight) do
			unitListScrollPanel:RemoveChild(i)
			i:Dispose()
		end
		for k, b in pairs(groupListUnitsButtons) do
			groupListUnitsScrollPanel:RemoveChild(b)
			b:Dispose()
		end
		for k, b in pairs(groupListUnitsViewButtons) do
			groupListUnitsScrollPanel:RemoveChild(b)
			b:Dispose()
		end
		
		-- Add labels and buttons to both lists
		local count = 0
		for i, u in ipairs(units) do
			-- Unit label (type, team and id)
			local uDefID = Spring.GetUnitDefID(u)
			local name = UnitDefs[uDefID].humanName
			local team = Spring.GetUnitTeam(u)
			unitListLabels[u] = addLabel(unitListScrollPanel, '0%', 30 * count, '85%', 30, name.." ("..tostring(u)..")", 16, "left", {teams[team].red, teams[team].green, teams[team].blue, 1}, "center")
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
				unitStateMachine:setCurrentState(unitStateMachine.states.SELECTION)
			end
			unitListViewButtons[u] = addButton(unitListScrollPanel, '85%', 30 * count, '15%', 30, "", viewUnit)
			addImage(unitListViewButtons[u], '0%', '0%', '100%', '100%', "bitmaps/editor/eye.png", true, {0, 1, 1, 1})
			groupListUnitsViewButtons[u] = addButton(groupListUnitsScrollPanel, '85%', 30 * count, '15%', 30, "", viewUnit)
			addImage(groupListUnitsViewButtons[u], '0%', '0%', '100%', '100%', "bitmaps/editor/eye.png", true, {0, 1, 1, 1})
			
			-- Highlight
			unitListHighlight[u] = addImage(unitListScrollPanel, '0%', 30 * count, '100%', 30, "bitmaps/editor/blank.png", false, {1, 1, 0.4, 0})
			
			count = count + 1
		end
		unitTotal = units.n
	end
end
function updateUnitHighlights() -- Visual feedback on the units list to see what units are selected
	local units = Spring.GetAllUnits()
	for i, u in ipairs(units) do
		if Spring.IsUnitSelected(u) then
			unitListHighlight[u].color = {1, 1, 0.4, 0.2}
			unitListHighlight[u]:InvalidateSelf()
		else
			unitListHighlight[u].color = {1, 1, 0.4, 0}
			unitListHighlight[u]:InvalidateSelf()
		end
	end
end
function updateUnitGroupPanels() -- Update groups when a group is created/removed or a unit is added to/removed from a group
	-- Check if update is mandatory
	local updatePanels = false
	if tableLength(unitGroups) ~= groupTotal then -- Group count changed
		updatePanels = true
	end
	for k, group in pairs(unitGroups) do
		if tableLength(group.units) ~= groupSizes[k] then -- Unit count of a group changed
			updatePanels = true
			break
		end
	end
	
	-- Update
	if updatePanels then
		-- Clear UI elements
		for k, p in pairs(groupPanels) do
			groupListScrollPanel:RemoveChild(p)
			p:Dispose()
		end
		groupListScrollPanel:RemoveChild(addGroupButton)
		
		local count = 0
		local heights = {0, 0, 0, 0} -- Stores heights to place groups on the lower
		local widths = {0, 0, 0, 0} -- Stores corresponding widths
		for k, group in pairs(unitGroups) do
			local x, y
			-- Compute x and y depending on the number of groups
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
			groupPanels[k] = addPanel(groupListScrollPanel, x, y, 300, 60 + 30 * tableLength(group.units))
			selectGroupButtons[k] = addButton(groupPanels[k], 0, 0, 30, 30, "", function() selectGroupButtons[k].state.chosen = not selectGroupButtons[k].state.chosen selectGroupButtons[k]:InvalidateSelf() end)
			groupEditBoxes[k] = addEditBox(groupPanels[k], 35, 5, 220, 20, "left", group.name)
			groupEditBoxes[k].font.size = 14
			local deleteButton = addButton(groupPanels[k], 260, 0, 30, 30, "X", function() deleteUnitGroup(k) end)
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
		addGroupButton = addButton(groupListScrollPanel, x, y, 300, 60, "Add Group", addEmptyUnitGroup)
		groupTotal = tableLength(unitGroups)
		
		-- Update groups
		for k, group in pairs(unitGroups) do
			-- Clear UI elements
			for key, l in pairs(unitGroupLabels[k]) do
				groupPanels[k]:RemoveChild(l)
				l:Dispose()
			end
			for key, b in pairs(unitGroupViewButtons[k]) do
				groupPanels[k]:RemoveChild(b)
				b:Dispose()
			end
			for key, b in pairs(unitGroupRemoveUnitButtons[k]) do
				groupPanels[k]:RemoveChild(b)
				b:Dispose()
			end
			
			local count = 0
			unitGroupLabels[k] = {}
			unitGroupViewButtons[k] = {}
			for key, u in pairs(group.units) do
				-- Remove button
				local removeButton = addButton(groupPanels[k], '5%', 40 + 30 * count, '10%', 30, "X", function() removeUnitFromGroup(unitGroups[k], u) end)
				removeButton.font.color = {1, 0, 0, 1}
				table.insert(unitGroupRemoveUnitButtons[k], removeButton)
				
				-- Label of unit
				local uDefID = Spring.GetUnitDefID(u)
				local name = UnitDefs[uDefID].humanName
				local team = Spring.GetUnitTeam(u)
				local label = addLabel(groupPanels[k], '20%', 40 + 30 * count, '75%', 30, name.." ("..tostring(u)..")", 15, "left", {teams[team].red, teams[team].green, teams[team].blue, 1}, "center")
				table.insert(unitGroupLabels[k], label)
				
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
				local but = addButton(groupPanels[k], '80%', 40 + 30 * count, '15%', 30, "", viewUnit)
				addImage(but, '0%', '0%', '100%', '100%', "bitmaps/editor/eye.png", true, {0, 1, 1, 1})
				table.insert(unitGroupViewButtons[k], but)
				
				count = count + 1
			end
			groupSizes[k] = tableLength(group.units)
		end
	end
	
	-- String in the editbox as name for the group
	for k, group in pairs(unitGroups) do
		if group.name ~= groupEditBoxes[k].text and groupEditBoxes[k].text ~= "" then
			group.name = groupEditBoxes[k].text
		end
	end
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
	end
	for unitKey, unitButton in pairs(groupListUnitsButtons) do
		unitButton.state.chosen = false
	end
end
function removeSelectedUnitsFromGroup(group)
	local unitSelection = Spring.GetSelectedUnits()
	for i, u in ipairs(unitSelection) do
		removeUnitFromGroup(group, u)
	end
end
function removeUnitFromGroup(group, unit)
	local units = group.units
	for i, u in ipairs(units) do
		if u == unit then
			table.remove(units, i)
			break
		end
	end
end
function addUnitGroup(name)
	local unitSelection = Spring.GetSelectedUnits()
	unitGroups[groupNumber] = {}
	unitGroups[groupNumber].name = name
	unitGroups[groupNumber].units = {}
	for i, u in ipairs(unitSelection) do
		addUnitToGroup(unitGroups[groupNumber], u)
	end
	groupSizes[groupNumber] = 0
	unitGroupLabels[groupNumber] = {}
	unitGroupViewButtons[groupNumber] = {}
	unitGroupRemoveUnitButtons[groupNumber] = {}
	groupNumber = groupNumber + 1
end
function addEmptyUnitGroup()
	unitGroups[groupNumber] = {}
	unitGroups[groupNumber].name = "Group #"..groupNumber
	unitGroups[groupNumber].units = {}
	groupSizes[groupNumber] = 0
	unitGroupLabels[groupNumber] = {}
	unitGroupViewButtons[groupNumber] = {}
	unitGroupRemoveUnitButtons[groupNumber] = {}
	groupNumber = groupNumber + 1
end
function deleteUnitGroup(id)
	unitGroups[id] = nil
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Zone state functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function computeZoneWorldCoords()
	local _,varA = Spring.TraceScreenRay(drawStartX, drawStartY, true, true) -- compute world's coords of the beginning of the draw
	local _, varB = Spring.TraceScreenRay(drawEndX, drawEndY, true, true) -- compute world's coords of the end of the draw
	if varA ~= nil and varB ~= nil then
		zoneX1, _, zoneZ1 = unpack(varA)
		zoneX2, _, zoneZ2 = unpack(varB)
	else
		zoneX1, zoneZ1, zoneX2, zoneZ2 = 0, 0, 0, 0
	end
	zoneX1, zoneX2 = sort(zoneX1, zoneX2) -- sort values to prevent errors
	zoneZ1, zoneZ2 = sort(zoneZ1, zoneZ2)
	
	local altPressed = Spring.GetModKeyState() -- force square if alt is pressed
	if altPressed then
		local length = math.min(zoneX2 - zoneX1, zoneZ2 - zoneZ1)
		if drawStartX > drawEndX then
			zoneX1 = zoneX2 - length
		else
			zoneX2 = zoneX1 + length
		end
		if drawStartY > drawEndY then
			zoneZ2 = zoneZ1 + length
		else
			zoneZ1 = zoneZ2 - length
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
				gl.DrawGroundQuad(zoneX1, zoneZ1, zoneX2, zoneZ2) -- draw the zone
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
				local a, b = (zoneX2 - zoneX1) / 2, (zoneZ2 - zoneZ1) /2
				local centerX, centerZ = (zoneX1 + zoneX2) / 2, (zoneZ1 + zoneZ2) / 2
				gl.Color(rValue, gValue, bValue, 0.5)
				drawGroundFilledEllipsis(centerX, centerZ, a, b, 50)
			end
		end
	end
end
function displayZones()
	for i, z in ipairs(zoneList) do -- render every other zones that are displayed
		if z.shown and z.type == "Rectangle" then
			gl.Color(z.red, z.green, z.blue, 0.5)
			gl.DrawGroundQuad(z.x1, z.z1, z.x2, z.z2)
		elseif z.shown and z.type == "Disk" then
			gl.Color(z.red, z.green, z.blue, 0.5)
			drawGroundFilledEllipsis(z.x, z.z, z.a, z.b, 50)
		elseif not z.shown and z == selectedZone then
			selectedZone = nil
		end
	end
end
function displaySelectedZoneAnchors()
	if selectedZone ~= nil then -- if a zone is selected, render its border
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
	if selectedZone ~= nil then
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
	for i, z in ipairs(zoneList) do
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
function clickedZone(mx, my) -- Returns the clicked zone if it exists, else nil
	local kind, var = Spring.TraceScreenRay(mx, my, true, true)
	local clickedZone = nil
	if var ~= nil then
		local x, _, z = unpack(var)
		for i, zone in ipairs(zoneList) do
			if zone.type == "Rectangle" then
				if x >= zone.x1 and x <= zone.x2 and z >= zone.z1 and z <= zone.z2 then -- check if we clicked in a zone
					clickedZone = zone
					if zone == selectedZone then -- if we clicked on the already selected zone, break and return selected zone
						return selectedZone
					end
				end
			elseif zone.type == "Disk" then
				if ((x - zone.x)*(x - zone.x)) / (zone.a*zone.a) + ((z - zone.z)*(z - zone.z)) / (zone.b*zone.b) <= 1 then -- check if we clicked in a zone
					clickedZone = zone
					if zone == selectedZone then -- if we clicked on the already selected zone, break and return selected zone
						return selectedZone
					end
				end
			end
		end
	end
	return clickedZone
end
function getZoneSide(x, z) -- Returns the clicked side of the selected zone
	local side = ""
	if selectedZone.type == "Rectangle" then
		local left = x - selectedZone.x1
		local right = selectedZone.x2 - x
		local top = z - selectedZone.z1
		local bottom = selectedZone.z2 - z -- these variable represent the distance between where the user clicked and the borders of the selected zone
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
	if selectedZone.type == "Rectangle" then
		-- depending on the side clicked, apply modifications
		if zoneSide == "CENTER" then
			if selectedZone.x1 + dx > 0 and selectedZone.x2 + dx < Game.mapSizeX then
				selectedZone.x1 = selectedZone.x1 + dx
				selectedZone.x2 = selectedZone.x2 + dx
				zoneAnchorX = zoneAnchorX + dx
			else
				applyChangesToSelectedZone(dx-sign(dx)*8, 0)
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
	if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE and totalZones ~= #zoneList then
		for k, zb in pairs(zoneBoxes) do
			if k ~= "global" then
				zoneScrollPanel:RemoveChild(zb.editBox)
				zb.editBox:Dispose()
				zoneScrollPanel:RemoveChild(zb.checkbox)
				zb.checkbox:Dispose()
			end
		end
		local size = 20
		for i, z in ipairs(zoneList) do
			local checkbox = addCheckbox(zoneScrollPanel, "80%", i * 3/2 * size, "20%", size, z.shown)
			local editBox = addEditBox(zoneScrollPanel, 0, i * 3/2 * size, "80%", size, "left", z.name, {z.red, z.green, z.blue, 1})
			zoneBoxes[z.id] = { editBox = editBox, checkbox = checkbox }
		end
		totalZones = #zoneList
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Forces state functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function updateAllyTeamPanels()
	for k, at in pairs(allyTeams) do
		if tableLength(at) ~= allyTeamsSize[k] then
			for _, c in ipairs(allyTeamsRemoveTeamButtons[k]) do
				allyTeamsScrollPanels[k]:RemoveChild(c)
				c:Dispose()
			end
			for _, c in ipairs(allyTeamsRemoveTeamLabels[k]) do
				allyTeamsScrollPanels[k]:RemoveChild(c)
				c:Dispose()
			end
			local count = 0
			for i, t in ipairs(at) do
				local lab = addLabel(allyTeamsScrollPanels[k], '30%', 40 * count, '70%', 40, "Team "..tostring(t), 20, "left", {teams[t].red, teams[t].green, teams[t].blue, 1}, "center")
				table.insert(allyTeamsRemoveTeamLabels[k], lab)
				local but = addButton(allyTeamsScrollPanels[k], '0%', 40 * count, '20%', 40, "X", function() removeTeamFromAllyTeam(k, t) selectedAllyTeam = k end)
				but.font.color = {1, 0, 0, 1}
				table.insert(allyTeamsRemoveTeamButtons[k], but)
				count = count + 1
			end
			allyTeamsSize[k] = tableLength(at)
		end
	end
end
function addTeamToSelectedAllyTeam(team)
	if team ~= selectedAllyTeam and not findInTable(allyTeams[selectedAllyTeam], team) then
		table.insert(allyTeams[selectedAllyTeam], team)
		table.sort(allyTeams[selectedAllyTeam])
	end
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
	end
end
function updateButtonVisualFeedback() -- Show current states on GUI
	markButtonWithinSet(topBarButtons, globalStateMachine:getCurrentState())
	markButtonWithinSet(unitButtons, unitStateMachine:getCurrentState())
	markButtonWithinSet(teamButtons, teamStateMachine:getCurrentState(), unitStateMachine:getCurrentState() ~= unitStateMachine.states.SELECTION)
	markButtonWithinSet(zoneButtons, zoneStateMachine:getCurrentState())
	markButtonWithinSet(selectAllyTeamsButtons, selectedAllyTeam)
	markButtonWithinSet(forcesTabs, forcesStateMachine:getCurrentState())
	for k, team in pairs(teamStateMachine.states) do
		markButtonWithinSet(teamStateButtons[team], teamState[team])
		markButtonWithinSet(teamControlButtons[team], teamControl[team])
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
	hideDefaultGUI()
	initChili()
	initTopBar()
	initUnitFunctions()
	initTeamFunctions()
	initMouseCursors()
	initWindows()
	fileFrame()
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
	
	if unitSelection.n == 0 then
		clearTemporaryWindows()
	end
	
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
		updateUnitList()
		updateUnitHighlights()
		updateUnitGroupPanels()
	end
	
	updateZonePanel()
	
	if globalStateMachine:getCurrentState() == globalStateMachine.states.FORCES then
		updateAllyTeamPanels()
	end
	
	updateButtonVisualFeedback()
	
	changeMouseCursor()
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
	
	-- Change state depending on the clicked element
	if kind == "unit" then
		if globalStateMachine:getCurrentState() ~= globalStateMachine.states.UNIT then
			unitFrame()
		end
	elseif clickedZone(mx, my) ~= nil then
		zoneFrame()
		zoneStateMachine:setCurrentState(zoneStateMachine.states.SELECTION)
	end
	
	-- Left click
	if button == 1 then
		-- STATE UNIT : place units on the field and select/move/rotate them
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
			-- STATE UNIT : place units on the field
			if unitStateMachine:getCurrentState() ~= unitStateMachine.states.SELECTION then
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
					if selectedZone ~= clickedZone(mx, my) then
						selectedZone = clickedZone(mx, my)
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
		
	-- Right click
	elseif button == 3 then
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then -- enable selection / disable unit placement
			unitStateMachine:setCurrentState(unitStateMachine.states.SELECTION)
			if kind == "unit" then
				local unitSelection = Spring.GetSelectedUnits()
				if unitSelection.n == 0 or not Spring.IsUnitSelected(var) then
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
				selectedZone = clickedZone(mx, my)
				zoneStateMachine:setCurrentState(zoneStateMachine.states.SELECTION)
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWRECT then
				local zone = 	{ 	
										red = rValue, green = gValue, blue = bValue,
										x1 = round(zoneX1) - round(zoneX1)%8,
										x2 = round(zoneX2) - round(zoneX2)%8,
										z1 = round(zoneZ1) - round(zoneZ1)%8,
										z2 = round(zoneZ2) - round(zoneZ2)%8,
										id = "Zone "..zoneNumber, name = "Zone "..zoneNumber,
										type = "Rectangle",
										shown = true
									}
				if zone.x2 - zone.x1 >= minZoneSize and zone.z2 - zone.z1 >= minZoneSize then -- if the drew zone is large enough, store it
					table.insert(zoneList, zone)
					zoneNumber = zoneNumber + 1
				end
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWDISK then
				local zone = 	{ 	
										red = rValue, green = gValue, blue = bValue,
										a = round((zoneX2 - zoneX1) / 2) - round((zoneX2 - zoneX1) / 2)%8,
										b = round((zoneZ2 - zoneZ1) / 2) - round((zoneZ2 - zoneZ1) / 2)%8,
										x = round((zoneX1 + zoneX2) / 2) - round((zoneX1 + zoneX2) / 2)%8,
										z = round((zoneZ1 + zoneZ2) / 2) - round((zoneZ1 + zoneZ2) / 2)%8,
										id = "Zone "..zoneNumber, name = "Zone "..zoneNumber,
										type = "Disk",
										shown = true
									}
				if 2*zone.a >= minZoneSize and 2*zone.b >= minZoneSize then -- if the drew zone is large enough, store it
					table.insert(zoneList, zone)
					zoneNumber = zoneNumber + 1
				end
			end
			plotZone = false
			mouseMove = false
			zoneSide = ""
		end
	end
	doubleClick = 0 -- reset double click timer
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
					if pos ~=nil then
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
				if mouseMove and selectedZone ~= nil then
					local _, var = Spring.TraceScreenRay(mx, my, true, true)
					if var ~= nil then
						local x, _, z = unpack(var)
						x, z = round(x), round(z)
						local dx, dz = round(x - zoneAnchorX), round(z - zoneAnchorZ)
						dx = dx - sign(dx) * ( (sign(dx)*dx)%8 ) -- compute variations modulo 8 (complex because operator % only accepts positive numbers)
						dz = dz - sign(dz) * ( (sign(dz)*dz)%8 )
						applyChangesToSelectedZone(dx, dz)
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
		saveMap()
		return true
	-- CTRL + O : load a map
	elseif key == Spring.GetKeyCode("o") and mods.ctrl then
		loadMap("Missions/jsonFiles/Mission3.json")
		return true
	-- CTRL + N : new map
	elseif key == Spring.GetKeyCode("n") and mods.ctrl then
		newMap()
		return true
	-- ESCAPE : back to file menu
	elseif key == Spring.GetKeyCode("esc") then
		clearUI()
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
			for k, g in pairs(unitGroups) do
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
		if unitSelection.n > 0 then
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
				return true
			-- ARROWS : move selected zone
			elseif key == Spring.GetKeyCode("up") then
				selectedZone.z1 = selectedZone.z1 - 8
				selectedZone.z2 = selectedZone.z2 - 8
				return true
			elseif key == Spring.GetKeyCode("down") then
				selectedZone.z1 = selectedZone.z1 + 8
				selectedZone.z2 = selectedZone.z2 + 8
				return true
			elseif key == Spring.GetKeyCode("left") then
				selectedZone.x1 = selectedZone.x1 - 8
				selectedZone.x2 = selectedZone.x2 - 8
				return true
			elseif key == Spring.GetKeyCode("right") then
				selectedZone.x1 = selectedZone.x1 + 8
				selectedZone.x2 = selectedZone.x2 + 8
				return true
			end
		end
	end
	return false
end
