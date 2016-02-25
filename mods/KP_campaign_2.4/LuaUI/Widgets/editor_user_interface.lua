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

-- UI Variables
local Chili, Screen0 -- Chili framework, main screen
local windows, buttons, teamButtons, unitButtons, fileButtons, labels, zoneBoxes, images, scrollPanels, editBoxes = {}, {}, {}, {}, {}, {}, {}, {}, {}, {} --refereces to UI elements
local globalFunctions, unitFunctions, teamFunctions = {}, {}, {} -- Generated functions for some buttons

-- Draw selection variables
local drawStartX, drawStartY, drawEndX, drawEndY, screenSizeX, screenSizeY = 0, 0, 0, 0, 0, 0
local plotSelection = false
function widget:DrawScreenEffects(dse_vsx, dse_vsy) screenSizeX, screenSizeY = dse_vsx, dse_vsy end

-- Zone variables
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
function addImageButton(_parent, _x, _y, _w, _h, imagePath, onClickFunction)
	local imageButton = Chili.Image:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		file = imagePath,
		keepAspect = false,
		OnClick = {onClickFunction}
	}
	return imageButton
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
function addLabel(_parent, _x, _y, _w, _h, text, size, _align)
	local label = Chili.Label:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		caption = text,
		fontsize = size or 20,
		align = _align or "center"
	}
	return label
end
function addImage(_parent, _x, _y, _w, _h, imagePath, _keepAspect)
	local image = Chili.Image:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		file = imagePath,
		keepAspect = _keepAspect or false
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
			windows.key = nil
		end
	end
	selectedZone = nil
	Spring.SelectUnitArray({})
end
function fileFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.FILE)
	
	windows['fileWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	labels['fileLabel'] = addLabel(windows['fileWindow'], '0%', '1%', '100%', '5%', "File")
	fileButtons['new'] = addButton(windows['fileWindow'], '0%', '10%', '100%', '10%', "New Map", function() newMap() end)
	fileButtons['load'] = addButton(windows['fileWindow'], '0%', '20%', '100%', '10%', "Load Map", function() loadMap("Missions/jsonFiles/Mission3.json") end)
end
function zoneFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.ZONE)
	zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWRECT)
	
	windows['zoneWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	labels['zoneLabel'] = addLabel(windows['zoneWindow'], '0%', '1%', '100%', '5%', "Zone")
	fileButtons['zoneRect'] = addButton(windows['zoneWindow'], '0%', '5%', '50%', '10%', "", function() zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWRECT) selectedZone = nil end)
	images['zoneRect'] = addImage(fileButtons['zoneRect'], '0%', '0%', '100%', '100%', "bitmaps/editor/rectangle.png")
	fileButtons['zoneDisk'] = addButton(windows['zoneWindow'], '50%', '5%', '50%', '10%', "", function() zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAWDISK) selectedZone = nil end) -- TODO
	images['zoneDisk'] = addImage(fileButtons['zoneDisk'], '0%', '0%', '100%', '100%', "bitmaps/editor/disk.png")
	scrollPanels['zonePanel'] = addScrollPanel(windows['zoneWindow'], '0%', '15%', '100%', '85%')
	
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
	buttons["checkAllZones"] = addButton(scrollPanels["zonePanel"], 0, 0, "50%", 30, "Show all", toggleAllOn)
	buttons["hideAllZones"] = addButton(scrollPanels["zonePanel"], "50%", 0, "50%", 30, "Hide all", toggleAllOff)
	updateZonePanel() -- initialize zone list when coming back to this menu
end
function unitFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
	unitStateMachine:setCurrentState(unitStateMachine.states.DEFAULT)
	teamStateMachine:setCurrentState(teamStateMachine:getCurrentState())
	
	windows['unitWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	scrollPanels['unitScrollPanel'] = addScrollPanel(windows['unitWindow'], '0%', '5%', '100%', '80%')

	-- Put unit states in an array to sort them alphabetically
	local unitStates = {}
	for k, u in pairs(unitStateMachine.states) do
		if k ~= "DEFAULT" then
			table.insert(unitStates, u)
		end
	end
	table.sort(unitStates)
	
	-- Unit buttons
	labels['unitLabel'] = addLabel(windows['unitWindow'], '0%', '1%', '100%', '5%', "Units")
	local button_size = 40
	local y = 0
	for i,u in ipairs(unitStates) do
		unitButtons[u] = addButton(scrollPanels['unitScrollPanel'], 0, y, '100%', button_size, UnitDefNames[u].humanName, unitFunctions[u])
		y = y + button_size
	end
	
	-- Team buttons
	-- TODO : require refactor
	labels['teamLabel'] = addLabel(windows["unitWindow"], '0%', '87%', '100%', '5%', "Team")
	teamButtons[teamStateMachine.states.PLAYER] = addImageButton(windows["unitWindow"], '5%', '92%', '30%', '5%', "bitmaps/editor/player.png", teamFunctions[teamStateMachine.states.PLAYER])
	teamButtons[teamStateMachine.states.ALLY] = addImageButton(windows["unitWindow"], '35%', '92%', '30%', '5%', "bitmaps/editor/ally.png", teamFunctions[teamStateMachine.states.ALLY])
	teamButtons[teamStateMachine.states.ENEMY] = addImageButton(windows["unitWindow"], '65%', '92%', '30%', '5%', "bitmaps/editor/enemy.png", teamFunctions[teamStateMachine.states.ENEMY])
	
	-- Selection image
	images['selectionType'] = addImage(unitButtons[unitStateMachine.states.DEFAULT], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
	images['selectionTeam'] = addImage(teamButtons[teamStateMachine:getCurrentState()], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end
function eventFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.EVENT)
	
	windows['editBoxWindow'] = addWindow(Screen0, '30%', '30%', '30%', '30%')
	labels['editBoxLabel'] = addLabel(windows['editBoxWindow'], '5%', '1%', '90%', '5%', "EditBox")
	editBoxes["editBox"] = addEditBox(windows['editBoxWindow'], '0%', '10%', '100%', 20)
end
function actionFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.ACTION)
end
function linkFrame()
	clearUI()
	globalStateMachine:setCurrentState(globalStateMachine.states.LINK)
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
	buttons['file'] = addButton(windows["topBar"], '0%', '0%', '5%', '100%', 'File', fileFrame)
	buttons['units'] = addButton(windows["topBar"], '5%', '0%', '5%', '100%', 'Units', unitFrame)
	buttons['zones'] = addButton(windows["topBar"], '10%', '0%', '5%', '100%', 'Zones', zoneFrame)
	buttons['events'] = addButton(windows["topBar"], '15%', '0%', '5%', '100%', 'Events', eventFrame)
	buttons['actions'] = addButton(windows["topBar"], '20%', '0%', '5%', '100%', 'Actions', actionFrame)
	buttons['links'] = addButton(windows["topBar"], '25%', '0%', '5%', '100%', 'Links', linkFrame)
end
function initUnitFunctions() -- Creates a function for every unitState to change state and handle selection feedback
	for k, u in pairs(unitStateMachine.states) do
		unitFunctions[u] = function()
			globalStateMachine:setCurrentState(globalStateMachine.states.UNIT)
			unitStateMachine:setCurrentState(u)
			for key, ub in pairs(unitButtons) do
				ub:RemoveChild(images["selectionType"])
			end
			images['selectionType'] = addImage(unitButtons[u], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
		end
	end
end
function initTeamFunctions() -- Creates a function for every teamState to change state and handle selection feedback
	for k, t in pairs(teamStateMachine.states) do
		teamFunctions[t] = function()
			teamStateMachine:setCurrentState(t)
			for _, tb in pairs(teamButtons) do
				tb:RemoveChild(images["selectionTeam"])
			end
			images['selectionTeam'] = addImage(teamButtons[t], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
			local msg = "Transfer Units".."++"..t
			Spring.SendLuaRulesMsg(msg)
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
	if images["selectionRect"] ~= nil then
		Screen0:RemoveChild(images["selectionRect"])
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
		images["selectionRect"] = addRect(Screen0, x1, y1, x2, y2, {0, 1, 1, 0.3})
	end
end
function previewUnit()-- Draw units before placing them
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and not Screen0.hoveredControl then
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
	local unitSelection = Spring.GetSelectedUnits()
	if #unitSelection > 0	and windows["unitAttributes"] == nil then -- only show the window when some units are selected
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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Zone state functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function drawZoneRect() -- Draw the zone feedback rectangle
	if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWRECT then
		local _, _, leftPressed = Spring.GetMouseState()
		if leftPressed then -- if draw has to begin
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
			if plotZone then
				gl.Color(rValue, gValue, bValue, 0.5)
				gl.DrawGroundQuad(zoneX1, zoneZ1, zoneX2, zoneZ2) -- draw the zone
			end
		end
	end
	
	for i, z in ipairs(zoneList) do -- render every other zones that are displayed
		if z.shown then
			gl.Color(z.red, z.green, z.blue, 0.5)
			gl.DrawGroundQuad(z.x1, z.z1, z.x2, z.z2)
		elseif not z.shown and z == selectedZone then
			selectedZone = nil
		end
	end
	
	if selectedZone ~= nil then -- if a zone is selected, render its border
		gl.Color(selectedZone.red, selectedZone.green, selectedZone.blue, 0.7)
		gl.DrawGroundQuad(selectedZone.x1, selectedZone.z1, selectedZone.x1+8, selectedZone.z2)
		gl.DrawGroundQuad(selectedZone.x1, selectedZone.z1, selectedZone.x2, selectedZone.z1+8)
		gl.DrawGroundQuad(selectedZone.x2-8, selectedZone.z1, selectedZone.x2, selectedZone.z2)
		gl.DrawGroundQuad(selectedZone.x1, selectedZone.z2-8, selectedZone.x2, selectedZone.z2)
	end
end
function showZoneInformation() -- Show each displayed zone name and top-left/bottom-right positions of selected zone
	gl.BeginText()
	if selectedZone ~= nil then
		local x, y = Spring.WorldToScreenCoords(selectedZone.x1, Spring.GetGroundHeight(selectedZone.x1, selectedZone.z1), selectedZone.z1)
		local text =  "x:"..tostring(selectedZone.x1).." z:"..tostring(selectedZone.z1)
		gl.Text(text, x, y, 15, "s")
		x, y = Spring.WorldToScreenCoords(selectedZone.x2, Spring.GetGroundHeight(selectedZone.x2, selectedZone.z2), selectedZone.z2)
		text =  "x:"..tostring(selectedZone.x2).." z:"..tostring(selectedZone.z2)
		x = x - gl.GetTextWidth(text)*15
		gl.Text(text, x, y, 15, "s")
	end
	for i, z in ipairs(zoneList) do
		if z.shown then
			local x, y = (z.x1 + z.x2) / 2, (z.z1 + z.z2) / 2
			x, y = Spring.WorldToScreenCoords(x, Spring.GetGroundHeight(x, y), y)
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
			if x >= zone.x1 and x <= zone.x2 and z >= zone.z1 and z <= zone.z2 then -- check if we clicked in a zone
				clickedZone = zone
				if zone == selectedZone then -- if we clicked on the already selected zone, break and return selected zone
					return selectedZone
				end
			end
		end
	end
	return clickedZone
end
function getZoneSide(x, z) -- Returns the clicked side of the selected zone
	local left = x - selectedZone.x1
	local right = selectedZone.x2 - x
	local top = z - selectedZone.z1
	local bottom = selectedZone.z2 - z -- these variable represent the distance between where the user clicked and the borders of the selected zone
	local side = ""
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
	return side
end
function applyChangesToSelectedZone(dx, dz) -- Move or resize the selected zone
	local updateAnchor = true
	-- depending on the side clicked, apply modifications
	if zoneSide == "" and selectedZone.x1 + dx > 0 and selectedZone.x2 + dx < Game.mapSizeX and selectedZone.z1 + dz > 0 and selectedZone.z2 + dz < Game.mapSizeZ then
		selectedZone.x1 = selectedZone.x1 + dx
		selectedZone.x2 = selectedZone.x2 + dx
		selectedZone.z1 = selectedZone.z1 + dz
		selectedZone.z2 = selectedZone.z2 + dz
	elseif zoneSide == "LEFT" and selectedZone.x1 + dx + minZoneSize <= selectedZone.x2 then
		selectedZone.x1 = selectedZone.x1 + dx
	elseif zoneSide == "RIGHT" and selectedZone.x1 - dx + minZoneSize <= selectedZone.x2 then
		selectedZone.x2 = selectedZone.x2 + dx
	elseif zoneSide == "TOP" and selectedZone.z1 + dz + minZoneSize <= selectedZone.z2 then
		selectedZone.z1 = selectedZone.z1 + dz
	elseif zoneSide == "BOT" and selectedZone.z1 - dz+ minZoneSize <= selectedZone.z2 then
		selectedZone.z2 = selectedZone.z2 + dz
	elseif zoneSide == "TOPLEFT" and selectedZone.z1 + dz + minZoneSize <= selectedZone.z2 and selectedZone.x1 + dx + minZoneSize <= selectedZone.x2 then
		selectedZone.z1 = selectedZone.z1 + dz
		selectedZone.x1 = selectedZone.x1 + dx
	elseif zoneSide == "BOTLEFT" and selectedZone.z1 - dz + minZoneSize <= selectedZone.z2 and selectedZone.x1 + dx + minZoneSize <= selectedZone.x2 then
		selectedZone.z2 = selectedZone.z2 + dz
		selectedZone.x1 = selectedZone.x1 + dx
	elseif zoneSide == "TOPRIGHT" and selectedZone.z1 + dz + minZoneSize <= selectedZone.z2 and selectedZone.x1 - dx + minZoneSize <= selectedZone.x2 then
		selectedZone.z1 = selectedZone.z1 + dz
		selectedZone.x2 = selectedZone.x2 + dx
	elseif zoneSide == "BOTRIGHT" and selectedZone.z1 - dz + minZoneSize <= selectedZone.z2 and selectedZone.x1 - dx + minZoneSize <= selectedZone.x2 then
		selectedZone.z2 = selectedZone.z2 + dz
		selectedZone.x2 = selectedZone.x2 + dx
	else
		updateAnchor = false -- if no modifications have been applied (mouse out of map for instance), do not update the anchor of the transformation
	end
	if updateAnchor then
		zoneAnchorX = zoneAnchorX + dx
		zoneAnchorZ = zoneAnchorZ + dz
	end
end
function updateZonePanel() -- Add/remove an editbox and a checkbox to/from the zone window when a zone is created/deleted
	for k, zb in pairs(zoneBoxes) do
		if k ~= "global" then
			scrollPanels["zonePanel"]:RemoveChild(zb.editBox)
			scrollPanels["zonePanel"]:RemoveChild(zb.checkbox)
		end
	end
	local size = 20
	for i, z in ipairs(zoneList) do
		local checkbox = addCheckbox(scrollPanels["zonePanel"], "80%", i * 3/2 * size, "20%", size, z.shown)
		local editBox = addEditBox(scrollPanels["zonePanel"], 0, i * 3/2 * size, "80%", size, "left", z.name, {z.red, z.green, z.blue, 1})
		zoneBoxes[z.id] = { editBox = editBox, checkbox = checkbox }
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Draw functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

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
function widget:DrawScreen()
	changeMouseCursor()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
		showUnitsInformation()
		showUnitAttributes()
		drawSelectionRect()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		updateZoneInformation()
	end
	showZoneInformation()
end
function widget:DrawWorld()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
		previewUnit()
	end
	drawZoneRect()
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
	
	if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE and totalZones ~= #zoneList then
		updateZonePanel()
		totalZones = #zoneList
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
--			Input functions
--
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function widget:MousePress(mx, my, button)
	-- Left click
	if button == 1 then
		-- raycast
		local kind,var = Spring.TraceScreenRay(mx,my)
		
		-- STATE UNIT : place units on the field
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
			if kind == "ground" then -- If ground is selected and we can place a unit, send a message to the gadget to create the unit
				local xUnit, yUnit, zUnit = unpack(var)
				xUnit, yUnit, zUnit = round(xUnit), round(yUnit), round(zUnit)
				local msg = "Create Unit".."++"..unitStateMachine:getCurrentState().."++"..teamStateMachine:getCurrentState().."++"..tostring(xUnit).."++"..tostring(yUnit).."++"..tostring(zUnit)
				Spring.SendLuaRulesMsg(msg)
			elseif kind == "unit" then -- If unit is selected, go to selection state
				for key, ub in pairs(unitButtons) do
					ub:RemoveChild(images["selectionType"])
				end
				globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
			end
		end
		
		-- STATE SELECTION : select and move units on the field
		if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
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
		
		-- STATE ZONE : draw, move and rename logical zones
		if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
			if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWRECT or zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWRECT then
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
			for key, ub in pairs(unitButtons) do
				ub:RemoveChild(images["selectionType"])
			end
			globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
		elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then -- enable selection / disable zone placement
			zoneStateMachine:setCurrentState(zoneStateMachine.states.SELECTION)
		end
	end
end
function widget:MouseRelease(mx, my, button)
	if button == 1 then
		if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
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
										shown = true
									}
				if zone.x2 - zone.x1 >= minZoneSize and zone.z2 - zone.z1 >= minZoneSize then -- if the drew zone is large enough, store it
					table.insert(zoneList, zone)
					zoneNumber = zoneNumber + 1
				end
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWDISK then
				-- TODO
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
		if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
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
			if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAWRECT then
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
	if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
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
	return true
end
