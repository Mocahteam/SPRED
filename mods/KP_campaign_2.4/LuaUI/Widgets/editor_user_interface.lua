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
local windows, buttons, topBarButtons, zoneButtons, labels, images, scrollPanels, editBoxes, panels = {}, {}, {}, {}, {}, {}, {}, {}, {} -- references to UI elements
local globalFunctions, unitFunctions, teamFunctions = {}, {}, {} -- Generated functions for some buttons

-- File Variables
local fileButtons = {}

-- Unit Variables
local teams = getTeamsInformation()
local teamCount = tableLength(teamStateMachine.states)
local unitScrollPanel
local unitButtons = {}
local teamLabels = {}
local teamButtons = {}
local teamImages = {}
local unitContextualMenu

-- Draw selection variables
local drawStartX, drawStartY, drawEndX, drawEndY, screenSizeX, screenSizeY = 0, 0, 0, 0, 0, 0
local plotSelection = false
local selectionRect
function widget:DrawScreenEffects(dse_vsx, dse_vsy) screenSizeX, screenSizeY = dse_vsx, dse_vsy end

-- Zone variables
local zoneScrollPanel
local zoneBoxes = {}
local plotZone = false
local rValue, gValue, bValue = 0, 0, 0
local zoneX1, zoneX2, zoneZ1, zoneZ2 = 0, 0, 0, 0
local zoneAnchorX, zoneAnchorZ = 0, 0
local minZoneSize = 32
local zoneList = {}
local selectedZone = nil
local zoneSide = ""
local totalZones = #zoneList
local zoneNumber = totalZones+1

-- Forces variables
local teamConfigWindow, allyTeamsWindow, unitGroupsWindow
local allyTeams = {}
local allyTeamsSize = {}
local allyTeamsRemoveTeamButtons = {}
local selectAllyTeamsButtons = {}
local allyTeamsListButtons = {}
local allyTeamsScrollPanels = {}
local selectedAllyTeam = 0
local unitGroups = {}
local unitTotal = 0
local groupNumber = 0
local groupTotal = nil
local selectedGroup = 0
local groupSizes = {}
local selectUnitGroupBut = {}
local unitGroupsAttributionWindow
local unitListScrollPanel
local unitListLabels = {}
local groupListScrollPanel
local groupPanels = {}
local groupEditBoxes = {}
local unitGroupLabels = {}


-- Mouse variables
local mouseMove = false
local clickToSelect = false
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
	editBox.font.size = _h
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
end
function clearTemporaryWindows()
	Screen0:RemoveChild(unitContextualMenu)
	Screen0:RemoveChild(unitGroupsAttributionWindow)
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
	windows["forceWindow"].x = 100
	windows["forceWindow"].y = 100
	teamConfig()
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Forces window buttons functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function clearForceWindow()
	windows['forceWindow']:RemoveChild(teamConfigWindow)
	windows['forceWindow']:RemoveChild(allyTeamsWindow)
	windows['forceWindow']:RemoveChild(unitGroupsWindow)
end
function teamConfig()
	clearForceWindow()
	windows['forceWindow']:AddChild(teamConfigWindow)
end
function allyTeam()
	clearForceWindow()
	windows['forceWindow']:AddChild(allyTeamsWindow)
end
function unitGroupsPanel()
	clearForceWindow()
	windows['forceWindow']:AddChild(unitGroupsWindow)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Initialisation functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function hideDefaultGUI()
	-- get rid of engine UI
	Spring.SendCommands("resbar 0","fps 0","console 0","info 0")
	-- leaves rendering duty to widget (we won't)
	gl.SlaveMiniMap(true)
	-- a hitbox remains for the minimap, unless you do this
	gl.ConfigMiniMap(0,0,0,0)
end
function initTopBar()
	-- Top bar
	windows['topBar'] = addWindow(Screen0, '0%', '0%', '100%', '5%')
	
	-- Menu buttons
	topBarButtons[globalStateMachine.states.FILE] = addButton(windows["topBar"], '0%', '0%', '5%', '100%', 'File', fileFrame)
	topBarButtons[globalStateMachine.states.UNIT] = addButton(windows["topBar"], '5%', '0%', '5%', '100%', 'Units', unitFrame)
	topBarButtons[globalStateMachine.states.ZONE] = addButton(windows["topBar"], '10%', '0%', '5%', '100%', 'Zones', zoneFrame)
	topBarButtons[globalStateMachine.states.FORCES] = addButton(windows["topBar"], '15%', '0%', '5%', '100%', 'Forces', forcesFrame)
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
	fileButtons['new'] = addButton(windows['fileWindow'], '0%', '10%', '100%', '10%', "New Map", function() newMap() end)
	fileButtons['load'] = addButton(windows['fileWindow'], '0%', '20%', '100%', '10%', "Load Map", function() loadMap("Missions/jsonFiles/Mission3.json") end)
end
function initUnitWindow()
	windows['unitWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	unitScrollPanel = addScrollPanel(windows['unitWindow'], '0%', '5%', '100%', '80%')
	
	-- Put unit states in an array to sort them alphabetically
	local unitStates = {}
	for k, u in pairs(unitStateMachine.states) do
		if k ~= "SELECTION" then
			table.insert(unitStates, u)
		end
	end
	table.sort(unitStates)
	
	-- Unit buttons
	addLabel(windows['unitWindow'], '0%', '1%', '100%', '5%', "Units")
	local button_size = 40
	local y = 0
	for i,u in ipairs(unitStates) do
		unitButtons[u] = addButton(unitScrollPanel, 0, y, '100%', button_size, UnitDefNames[u].humanName, unitFunctions[u])
		y = y + button_size
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
end
function initUnitContextualMenu()
	unitContextualMenu = addWindow(nil, 0, 0, 200, 200)
	addButton(unitContextualMenu, '0%', tostring(100/3).."%", '100%', tostring(100/3).."%", "Edit Attributes", nil)
	addButton(unitContextualMenu, '0%', tostring(200/3).."%", '100%', tostring(100/3).."%", "Add to group", showUnitGroupsAttributionWindow)
end
function initZoneWindow()
	windows['zoneWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	addLabel(windows['zoneWindow'], '0%', '1%', '100%', '5%', "Zone")
	zoneButtons[zoneStateMachine.states.DRAWRECT] = addButton(windows['zoneWindow'], '0%', '5%', '50%', '10%', "", function() zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWRECT) selectedZone = nil end)
	addImage(zoneButtons[zoneStateMachine.states.DRAWRECT], '0%', '0%', '100%', '100%', "bitmaps/editor/rectangle.png")
	zoneButtons[zoneStateMachine.states.DRAWDISK] = addButton(windows['zoneWindow'], '50%', '5%', '50%', '10%', "", function() zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWDISK) selectedZone = nil end) -- TODO
	addImage(zoneButtons[zoneStateMachine.states.DRAWDISK], '0%', '0%', '100%', '100%', "bitmaps/editor/disk.png")
	zoneScrollPanel = addScrollPanel(windows['zoneWindow'], '0%', '15%', '100%', '85%')
	
	local toggleAllOn = 	function() -- show all zones
									for k, zb in pairs(zoneBoxes) do
										if not zb.checkbox.checked then
											zb.checkbox:Toggle()
										end
									end
								end
	local toggleAllOff = 	function() -- hide all zones
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
	addButton(windows['forceWindow'], 0, 0, tostring(100/3).."%", '5%', "Teams Configuration", teamConfig)
	addButton(windows['forceWindow'], tostring(100/3).."%", 0, tostring(100/3).."%", '5%', "Ally Teams", allyTeam)
	addButton(windows['forceWindow'], tostring(200/3).."%", 0, tostring(100/3).."%", '5%', "Unit Groups", unitGroupsPanel)
	
	-- Team Config Window
	teamConfigWindow = addWindow(windows['forceWindow'], 0, '5%', '100%', '95%')
	local teamConfigScrollPanel = addScrollPanel(teamConfigWindow, '0%', '0%', '100%', '100%')
	for k, team in pairs(teamStateMachine.states) do
		local panel = addPanel(teamConfigScrollPanel, '0%', team * 100, '100%', 100)
		addLabel(panel, '0%', '0%', '20%', '100%', "Team "..tostring(team), 30, "center", {teams[team].red, teams[team].green, teams[team].blue, 1}, "center")
		-- TODO : add configurable parameters
	end
	
	-- Ally Team Window
	allyTeamsWindow = addWindow(windows['forceWindow'], 0, '5%', '100%', '95%')
	addLabel(allyTeamsWindow, '0%', '0%', '20%', '10%', "Team List", 30, "center", nil, "center")
	local teamListScrollPanel = addScrollPanel(allyTeamsWindow, '0%', '10%', '20%', '90%') -- List of all the teams
	for k, team in pairs(teamStateMachine.states) do
		local x = tostring(20 + team * 80 / math.ceil(teamCount/2) - 80 * math.floor(team/math.ceil(teamCount/2)))..'%'
		local y = tostring(0 + 50 * math.floor(team/math.ceil(teamCount/2))).."%"
		local w = tostring(80 / math.ceil(teamCount/2)).."%"
		local h = "50%"
		local panel = addPanel(allyTeamsWindow, x, y, w, h)
		selectAllyTeamsButtons[team] = addButton(panel, '0%', '0%', '100%', '10%', "Team "..tostring(team), function() selectedAllyTeam = team end)
		selectAllyTeamsButtons[team].font.color = {teams[team].red, teams[team].green, teams[team].blue, 1}
		selectAllyTeamsButtons[team].font.size = 20
		allyTeamsScrollPanels[team] = addScrollPanel(panel, '2%', '10%', '96%', '89%')
		
		allyTeamsListButtons[team] = addButton(teamListScrollPanel, '0%', 40*team, '100%', 40, "Team "..tostring(team), function() addTeamToSelectedAllyTeam(team) end)
		allyTeamsListButtons[team].font.color = {teams[team].red, teams[team].green, teams[team].blue, 1}
		allyTeamsListButtons[team].font.size = 20
		
		allyTeams[team] = {}
		allyTeamsSize[team] = 0
		allyTeamsRemoveTeamButtons[team] = {}
	end
	
	-- Unit Groups Window
	unitGroupsWindow = addWindow(windows['forceWindow'], 0, '5%', '100%', '95%')
	addLabel(unitGroupsWindow, '0%', '0%', '20%', '10%', "Unit List", 30, "center", nil, "center")
	unitListScrollPanel = addScrollPanel(unitGroupsWindow, '0%', '10%', '20%', '90%')
	addLabel(unitGroupsWindow, '20%', '0%', '80%', '10%', "Group List", 30, "center", nil, "center")
	groupListScrollPanel = addScrollPanel(unitGroupsWindow, '20%', '10%', '80%', '90%')
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
	local msg = "Change HP".."++"..editBoxes["unitAttributesHpField"].text
	Spring.SendLuaRulesMsg(msg)
end
function drawSelectionRect() -- Draw the selection feedback rectangle
	if selectionRect ~= nil then
		Screen0:RemoveChild(selectionRect)
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
	-- TODO : requires rework
	local unitSelection = Spring.GetSelectedUnits()
	if unitSelection.n > 0	and windows["unitAttributes"] == nil then -- only show the window when some units are selected
		windows["unitAttributes"] = addWindow(Screen0, screenSizeX - 200, "50%", 200, 200, true)
		labels["unitAttributesTitle"] = addLabel(windows["unitAttributes"], 0, 0, "100%", 20, "Attributes", 20)
		labels["unitAttributesHp"] = addLabel(windows["unitAttributes"], 0, 50, "30%", 20, "HP%", 20, "right")
		if #unitSelection == 1 then -- if unit is alone, show its hp percentage in the editbox
			local h, mh = Spring.GetUnitHealth(unitSelection[1])
			editBoxes["unitAttributesHpField"] = addEditBox(windows["unitAttributes"], "35%", 50, "65%", 20, "left", tostring(round(100*(h/mh))))
		else
			editBoxes["unitAttributesHpField"] = addEditBox(windows["unitAttributes"], "35%", 50, "65%", 20, "left")
		end
		buttons["unitAttributesApply"] = addButton(windows["unitAttributes"], 0, "85%", "100%", "15%", "Apply", applyChangesToSelectedUnits)
	elseif #unitSelection == 0 then
		Screen0:RemoveChild(windows["unitAttributes"])
		windows["unitAttributes"] = nil
	end
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
function showUnitGroupsAttributionWindow()
	clearTemporaryWindows()
	unitGroupsAttributionWindow = addWindow(Screen0, '90%', '30%', '10%', '40%', true)
	local attributionWindowScrollPanel = addScrollPanel(unitGroupsAttributionWindow, '0%', '0%', '100%', '100%')
	
	local count = 0
	for k, group in pairs(unitGroups) do
		addButton(attributionWindowScrollPanel, '0%', count * 40, '100%', 40, group.name, function() addSelectedUnitsToGroup(group) clearTemporaryWindows() end)
		count = count + 1
	end
	
	local newUnitGroupEditBox = addEditBox(attributionWindowScrollPanel, '0%', count * 40, '80%', 40, "left", "New Group")
	newUnitGroupEditBox.font.size = 14
	local newUnitValidationButton = addButton(attributionWindowScrollPanel, '80%', count * 40, '20%', 40, "OK", function() addUnitGroup(newUnitGroupEditBox.text) clearTemporaryWindows() end)
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
			else
				side = "LEFT"
			end
		elseif right >= 0 and right <= 8 then
			if top >= 0 and top <= 8 then
				side = "TOPRIGHT"
			elseif bottom >= 0 and bottom <= 8 then
				side = "BOTRIGHT"
			else
				side = "RIGHT"
			end
		elseif top >= 0 and top <= 8 then
			side = "TOP"
		elseif bottom >= 0 and bottom <= 8 then
			side = "BOT"
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
		end
	end
	return side
end
function applyChangesToSelectedZone(dx, dz) -- Move or resize the selected zone
	if selectedZone.type == "Rectangle" then
		-- depending on the side clicked, apply modifications
		if zoneSide == "" then
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
		if zoneSide == "" then
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
				zoneScrollPanel:RemoveChild(zb.checkbox)
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
			end
			local count = 0
			for i, t in ipairs(at) do
				local but = addButton(allyTeamsScrollPanels[k], '0%', 40 * count, '100%', 40, "Team "..tostring(t), function() removeTeamFromAllyTeam(k, t) end)
				but.font.color = {teams[t].red, teams[t].green, teams[t].blue, 1}
				but.font.size = 20
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
function updateUnitGroupPanels()
	local units = Spring.GetAllUnits()
	if units.n ~= unitTotal then
		for k, l in pairs(unitListLabels) do
			unitListScrollPanel:RemoveChild(l)
		end
		local count = 0
		for i, u in ipairs(units) do
			local uDefID = Spring.GetUnitDefID(u)
			local name = UnitDefs[uDefID].humanName
			local team = Spring.GetUnitTeam(u)
			unitListLabels[u] = addLabel(unitListScrollPanel, '0%', 20 * count, '100%', 20, name.." ("..tostring(u)..")", 16, "left", {teams[team].red, teams[team].green, teams[team].blue, 1})
			count = count + 1
		end
		unitsTotal = units.n
	end
	
	local updatePanels = false
	if tableLength(unitGroups) ~= groupTotal then
		for k, p in pairs(groupPanels) do
			groupListScrollPanel:RemoveChild(p)
		end
		
		local count = 0
		for k, group in pairs(unitGroups) do
			groupPanels[k] = addPanel(groupListScrollPanel, 200 * count, 0, 200, 60 + 20 * tableLength(group.units))
			groupEditBoxes[k] = addEditBox(groupPanels[k], 5, 5, 150, 20, "left", group.name)
			groupEditBoxes[k].font.size = 14
			local deleteButton = addButton(groupPanels[k], 160, 0, 30, 30, "X", function() deleteUnitGroup(k) end)
			deleteButton.font.color = {1, 0, 0, 1}
			count = count + 1
		end
		groupTotal = tableLength(unitGroups)
		updatePanels = true
	end
	
	for k, group in pairs(unitGroups) do
		if tableLength(group.units) ~= groupSizes[k] or updatePanels then
			for key, l in pairs(unitGroupLabels[k]) do
				groupPanels[k]:RemoveChild(l)
			end
			
			local count = 0
			unitGroupLabels[k] = {}
			for key, u in pairs(group.units) do
				local uDefID = Spring.GetUnitDefID(u)
				local name = UnitDefs[uDefID].humanName
				local team = Spring.GetUnitTeam(u)
				local label = addLabel(groupPanels[k], '5%', 40 + 20 * count, '95%', 20, name.." ("..tostring(u)..")", 16, "left", {teams[team].red, teams[team].green, teams[team].blue, 1})
				table.insert(unitGroupLabels[k], label)
				count = count + 1
			end
			groupSizes[k] = tableLength(group.units)
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
	groupNumber = groupNumber + 1
end
function deleteUnitGroup(id)
	unitGroups[id] = nil
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
function changeMouseCursor() -- Hide mouse cursor in unit state and during movement, show another cursor in other states
	--[[
	local mouseCursor = Spring.GetMouseCursor()
	if mouseCursor ~= "none" then
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and Screen0.hoveredControl == false then
			Spring.SetMouseCursor("none")
		elseif globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION and mouseMove then
			Spring.SetMouseCursor("none")
		end
	elseif mouseCursor ~= "cursornormal" then
		Spring.SetMouseCursor("cursornormal") -- cursornormal, Guard, Move ...
	end
	]]
end
function updateButtonVisualFeedback() -- Show current states on GUI
	for _, b in pairs(topBarButtons) do
		b.state.hovered = false
	end
	if topBarButtons[globalStateMachine:getCurrentState()] ~= nil then
		topBarButtons[globalStateMachine:getCurrentState()].state.hovered = true
	end
	
	for _, b in pairs (unitButtons) do
		b.state.hovered = false
	end
	if unitButtons[unitStateMachine:getCurrentState()] ~= nil then
		unitButtons[unitStateMachine:getCurrentState()].state.hovered = true
	end
	
	for _, b in pairs (teamButtons) do
		b.state.hovered = false
	end
	if teamButtons[teamStateMachine:getCurrentState()] ~= nil and unitStateMachine:getCurrentState() ~= unitStateMachine.states.SELECTION then
		teamButtons[teamStateMachine:getCurrentState()].state.hovered = true
	end
	
	for _, b in pairs (zoneButtons) do
		b.state.hovered = false
	end
	if zoneButtons[zoneStateMachine:getCurrentState()] ~= nil then
		zoneButtons[zoneStateMachine:getCurrentState()].state.hovered = true
	end
	
	for _, b in pairs (selectAllyTeamsButtons) do
		b.state.hovered = false
	end
	if selectedAllyTeam ~= nil then
		selectAllyTeamsButtons[selectedAllyTeam].state.hovered = true
	end
	
	for _, b in pairs(selectUnitGroupBut) do
		b.state.hovered = false
	end
	if selectedGroup ~= nil and selectUnitGroupBut[selectedGroup] ~= nil then
		selectUnitGroupBut[selectedGroup].state.hovered = true
	end
end
function widget:DrawScreen()
	changeMouseCursor()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and unitStateMachine:getCurrentState() == unitStateMachine.states.SELECTION then
		showUnitsInformation()
		--showUnitAttributes()
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
	
	updateZonePanel()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.FORCES then
		updateAllyTeamPanels()
		updateUnitGroupPanels()
	end
	updateButtonVisualFeedback()
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Input functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function widget:MousePress(mx, my, button)
	clearTemporaryWindows()
	-- Left click
	if button == 1 then
		-- raycast
		local kind,var = Spring.TraceScreenRay(mx,my)
		
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
			local kind, var = Spring.TraceScreenRay(mx, my)
			if kind == "unit" then
				local unitSelection = Spring.GetSelectedUnits()
				if unitSelection.n == 0 or not Spring.IsUnitSelected(var) then
					proceedSelection({var})
				end
				if Spring.IsUnitSelected(var) then
					Screen0:AddChild(unitContextualMenu)
					unitContextualMenu.x = mx
					unitContextualMenu.y = screenSizeY - my
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
			local altPressed = Spring.GetModKeyState()
			if altPressed then -- Send a message to the gadget to rotate selectedUnits
				local kind, var = Spring.TraceScreenRay(mx, my, true, true)
				if var ~= nil then
					local x, _, z = unpack(var)
					local msg = "Rotate Units".."++"..x.."++"..z
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
	-- CTRL + O : load a map
	elseif key == Spring.GetKeyCode("o") and mods.ctrl then
		loadMap("Missions/jsonFiles/Mission3.json")
	-- CTRL + N : new map
	elseif key == Spring.GetKeyCode("n") and mods.ctrl then
		newMap()
	end
	-- Selection state
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and unitStateMachine:getCurrentState() == unitStateMachine.states.SELECTION then
		-- CTRL + A : select all units
		if key == Spring.GetKeyCode("a") and mods.ctrl then
			Spring.SelectUnitArray(Spring.GetAllUnits())
		-- DELETE : delete selected units
		elseif key == Spring.GetKeyCode("delete") then
			Spring.SendLuaRulesMsg("Delete Selected Units")
		-- ARROWS : move selected units
		elseif key == Spring.GetKeyCode("up") then
			local msg = "Translate Units".."++".."0".."++".."-1"
			Spring.SendLuaRulesMsg(msg)
		elseif key == Spring.GetKeyCode("down") then
			local msg = "Translate Units".."++".."0".."++".."1"
			Spring.SendLuaRulesMsg(msg)
		elseif key == Spring.GetKeyCode("left") then
			local msg = "Translate Units".."++".."-1".."++".."0"
			Spring.SendLuaRulesMsg(msg)
		elseif key == Spring.GetKeyCode("right") then
			local msg = "Translate Units".."++".."1".."++".."0"
			Spring.SendLuaRulesMsg(msg)
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
			-- ARROWS : move selected zone
			elseif key == Spring.GetKeyCode("up") then
				selectedZone.z1 = selectedZone.z1 - 8
				selectedZone.z2 = selectedZone.z2 - 8
			elseif key == Spring.GetKeyCode("down") then
				selectedZone.z1 = selectedZone.z1 + 8
				selectedZone.z2 = selectedZone.z2 + 8
			elseif key == Spring.GetKeyCode("left") then
				selectedZone.x1 = selectedZone.x1 - 8
				selectedZone.x2 = selectedZone.x2 - 8
			elseif key == Spring.GetKeyCode("right") then
				selectedZone.x1 = selectedZone.x1 + 8
				selectedZone.x2 = selectedZone.x2 + 8
			end
		end
	end
	return false
end
