-- $Id: gui_rooms.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Info
--


function widget:GetInfo()
  return {
    name      = "CA Interface",
    desc      = "CA in-game interface",
    author    = "quantum, muratet, mocahteam",
    date      = "Jul 15, 2012",
    license   = "GNU GPL, v2 or later",
    layer     = 210,
    enabled   = true  --  loaded by default?
  }
end


-- See LuaUI/Widgets/Rooms/documentation.txt for documentation. (deprecated)
 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- External Access
--


local rooms = widget
WG.rooms = rooms
rooms.Window = {}
rooms.Tab = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Speedups
--


local gl, GL         = gl, GL
local GetGameSeconds = spGetGameSeconds
local Window         = rooms.Window
local Tab            = rooms.Tab
local Delist         = rooms.Delist


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Constants
--


ROOM_DIRNAME = "LuaUI/Widgets/Rooms"
FONT_DIRNAME = LUAUI_DIRNAME.."Fonts/"
VFSMODE      = VFS.RAW_FIRST


-- Color codes: embed in a string to select text color.
white   = "\255\255\255\255"
black   = "\255\001\001\001"
grey    = "\255\128\128\128"
red     = "\255\255\001\001"
pink    = "\255\255\064\064"
green   = "\255\001\255\001"
blue    = "\255\001\001\255"
cyan    = "\255\001\255\255"
yellow  = "\255\255\255\001"
magenta = "\255\255\001\255"


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Locals
--


local realSeconds          = 0
local viewSizeX, viewSizeY = widgetHandler:GetViewSizes()
local objectsToDrawSet     = {} -- FIXME: replace completely with zStack
-- Muratet
local fontHandler = loadstring(VFS.LoadFile(LUAUI_DIRNAME.."modfonts.lua", VFS.ZIP_FIRST))()
--

-- Tables of objects that are to be notified when the specified
-- event takes place.
local onMousePressQueue    = {}
local onMouseReleaseQueue  = {}
local onIsAboveQueue       = {}
local onMouseMoveSet       = {}
local onUnitFinishedSet    = {}
local onUnitCreatedSet     = {}
local getConfigDataSet     = {}
local onUpdateSet          = {}
local onDrawWorldSet       = {}
local onSeismicPingSet     = {}


-- Array of display lists to destroy.
local cleanUp              = {}


local zStack               = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Globals
--


groups = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local GL_LINES         = GL.LINES
local GL_QUADS         = GL.QUADS
local abs              = math.abs
local floor            = math.floor
local glBeginEnd       = gl.BeginEnd
local glCallList       = gl.CallList
local glColor          = gl.Color
local glCreateList     = gl.CreateList
local glDeleteList     = gl.DeleteList
local glFont           = gl.Font
local glPopMatrix      = gl.PopMatrix
local glPushMatrix     = gl.PushMatrix
local glScale          = gl.Scale
local glTexRect        = gl.TexRect
local glTexture        = gl.Texture
local glTranslate      = gl.Translate
local glVertex         = gl.Vertex
local gmatch           = string.gmatch
local log              = math.log
local max              = math.max
local rep              = string.rep
local spGetConfigInt   = Spring.GetConfigInt
local spGetGameSeconds = Spring.GetGameSeconds
local spSetConfigInt   = Spring.SetConfigInt
local sub              = string.sub

local groups  = groups

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Utility
--


function WordWrap(str, maxLineWidth) -- Width in pixels.
                                     -- TODO: Make it respect newlines.
  local insert = table.insert
  local concat = table.concat
  
  local wordArray = {}
  for word in gmatch(str, "[^%s]+") do
    insert(wordArray, word)
  end
  
  local firstWordInPiece = 1
  local lastWordInPiece = 1
  local lineArray = {}
  
  repeat
  
    local linePiece = concat(wordArray, " ", firstWordInPiece, lastWordInPiece)
    local strippedLinePiece = fontHandler.StripColors(linePiece)
    local pieceWidth = fontHandler.GetTextWidth(strippedLinePiece)
    
    if (pieceWidth >= maxLineWidth) then                    
      local line = concat(wordArray, " ", firstWordInPiece, lastWordInPiece-1)
      insert(lineArray, line)                     
      firstWordInPiece = lastWordInPiece
    end
    
    lastWordInPiece = lastWordInPiece + 1
    
  until (lastWordInPiece == #wordArray)
  
  -- Insert the last words in the lineArray
  local line
  if (#wordArray > 1) then
    line = concat(wordArray, " ", firstWordInPiece, lastWordInPiece)
    local strippedLine = fontHandler.StripColors(line)
    local lineWidth = fontHandler.GetTextWidth(strippedLine)
    if (lineWidth < maxLineWidth and line ~= "") then
      insert(lineArray, line)
    else
      -- There can be only one extra word, see the repeat/until loop.
      line = (concat(wordArray, " ", firstWordInPiece, lastWordInPiece-1))
      insert(lineArray, line)
      insert(lineArray, wordArray[#wordArray])
    end
  else
    lineArray = wordArray
  end
  
  return lineArray
end


function Copy(original)       -- Warning: circular table references lead to
  local copy = {}             -- an infinite loop.
  for k, v in pairs(original) do
    if (type(v) == "table") then
      copy[k] = Copy(v)
    else
      copy[k] = v
    end
  end
  return copy
end


function ToSI(n) -- Adapted from IceUI. Thanks, Meltrax!
  
  if (not n) then
    return "nil"
  end
  
  local resultString
  local exponent
  local suffix
  local siSuffixes = {"y", "z", "a", "f", "p", "n", "�", "m", "", "k", "M",
                       "G", "T", "P", "E", "Z", "Y" }
  if (abs(n) < 10^27   and
      abs(n) > 10^-27) then
    n            = abs(n)
    exponent     = n == 0 and 0 or log(n)/log(10)
    suffix       = n == 0 and 0 or floor(exponent/3)
    n            = (n + (0.5*10^(floor(exponent)-2))) / 10^(suffix*3)
    n            = sub(n, 1, tonumber(n) > 100 and 3 or 4)
    resultString = n..siSuffixes[suffix+9]
  else
    resultString = "0"
  end
    return resultString
end


function MakeCounter()
  local count = 0
  return function()
    count = count + 1
    return count
  end
end


function MakeTimer()
  local startTime = realSeconds
  return function()
    return realSeconds - startTime
  end
end


function Delist(array, object) -- Finds and removes a value from an array.
  local objectPos = nil
  for index, key in ipairs(array) do
    if (key == object) then
      objectPos = index
      break
    end
  end
  -- Muratet : check if "object" has been found
  if objectPos ~= nil then
	table.remove(array, objectPos)
  end
  -- table.remove(array, objectPos)
  --
end


function MakeLineArray(text) -- Separates text in lines.
  local array = {}
  for word in gmatch(text, "[^\n]+") do
    table.insert(array, word)
  end
  return array
end


function RunOnce(func, ...)
  local first = true
  return function (...)
    if (first) then
      first = nil
      func(...)
    end
  end
end


function Empty()
  return Empty
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Obsolete Utility
--


--[[--------------- Might be useful again if glFont is used. ------------------


local function WordWrapMono(str, columns) -- Accurate with monospace fonts only.
  local li  = 1
  local len = #str
  while (len-li > columns) do
    local j
    local k
    local i = li + columns
    while (i > li and sub(str, i, i) ~= " ") do
      i = i-1
    end
    j = i
    while (j > li and sub(str, j, j) == " ") do
      j = j-1
    end
    str = sub(str, 1, j).."\n"..sub(str, i+1, -1)
    k   = 1+j-i
    li  = j+k
    len = len+k
  end
  return str
end


local function MakeLineArray(str, width)
  local Lines = gmatch(WordWrap(str, width), "[^\n]+")
  local lineArray = {}
  for line in Lines do
    table.insert(lineArray, line)
  end
  return lineArray
end


local function GetWidth(lineArray)
  local width = 0
  for _, line in pairs(lineArray) do
    local s = fontHandler.StripColorCodes(s)
    local l = #s
    if (l > width) then
      width = l
    end
  end
  return width -- In pixels.
end


local function GetParagraphSize(lineArray, lineSpacing)  -- Line spacing in
  local lineSpacing = lineSpacing or defaultLineSpacing  -- in pixels.
  local w = GetWidth(lineArray)
  local width = fontHandler.GetTextWidth(rep("a", w))
  local fontHeight = fontHandler.GetFontSize()
  local height = #lineArray * (fontHeight + lineSpacing)
  return width, height -- In pixels.
end


]]------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Tab Prototype
--


function Tab:Create(newTab, parent)
  newTab = newTab or {}
  setmetatable(newTab, self)
  self.__index = self  -- Inherit values from the "Tab" prototype.
  newTab.parent = parent
  
  newTab.font = newTab.font or "FreeSansBold_16"
  fontHandler.UseFont(FONT_DIRNAME..newTab.font)
  
  newTab:ProcessArguments()

  newTab.x1, newTab.y1, newTab.x2, newTab.y2 = newTab:GetCoordinates()

  fontHandler.UseFont(FONT_DIRNAME..parent.font)
  return newTab
end


function Tab:ProcessArguments()
  local parent = self.parent
  self.self = self
  
  -- Muratet
  self.type             = self.type             or "Tab"
  --
  self.title            = self.title            or white.."This is a tab"
  self.offset           = self.offset           or parent.tabOffset
  self.leftMargin       = self.leftMargin       or parent.leftMargin
  self.rightMargin      = self.rightMargin      or parent.rightMargin
  self.topMargin        = self.topMargin        or parent.topMargin
  self.bottomMargin     = self.bottomMargin     or parent.bottomMargin
  self.noBorder         = self.noBorder         or parent.border
  -- Border offsets determine how much the border lines protrude.
  self.borderOffset1    = self.borderOffset1    or parent.borderOffset1
  self.borderOffset2    = self.borderOffset2    or parent.borderOffset2
  self.position         = self.position         or "top"

  self.borderColor      = self.borderColor      or self.borderColor
  -- Background colors when the mouse cursor is within the tab.
  self.isAboveColors    = self.isAboveColors    or Copy(parent.isAboveColors)
  self.topLeftColor     = self.topLeftColor     or Copy(parent.topLeftColor)
  self.topRightColor    = self.topRightColor    or Copy(parent.topRightColor)
  self.bottomLeftColor  = self.bottomLeftColor  or Copy(parent.bottomLeftColor)
  self.bottomRightColor = self.bottomRightColor or Copy(parent.bottomRightColor)
  self.gradient         = self.bottomLeftColor  or parent.gradient
  self.backgroundColor  = self.backgroundColor  or parent.backgroundColor
  self.borderColor      = self.borderColor      or parent.borderColor
  self.useOnIsAbove     = true -- FIXME

  if (not self.gradient) then
    self.topRightColor    = Copy(self.backgroundColor)
    self.topLeftColor     = Copy(self.backgroundColor)
    self.bottomLeftColor  = Copy(self.backgroundColor)
    self.bottomRightColor = Copy(self.backgroundColor)
  end

  self.OnMousePressAction = self.OnMousePressAction or function()
                                                         return true
                                                       end
  if (self.preset) then
    self.preset(self)
  end
end


function Tab:GetCoordinates()
  local parent = self.parent
  local x1, y1, y2, x2

  local textWidth = fontHandler.GetTextWidth(self.title)
  local fontSize  = parent.fontSize
  local width     = self.leftMargin + textWidth + self.rightMargin
  local height    = self.topMargin + fontSize + self.bottomMargin
  local offset    = self.offset

  if (self.position == "top") then
    local oldTabOffset = parent.tabOffsets.top -- Place the new tab next to
    x1 = parent.x1 + offset + oldTabOffset     -- the previous one.
    y1 = parent.y2
    x2 = x1 + width
    y2 = parent.y2 + height
    local newTabOffset = x2 - parent.x1
    if (oldTabOffset < newTabOffset ) then
      parent.tabOffsets.top = newTabOffset
    end
  elseif (self.position == "right") then
    local oldTabOffset = parent.tabOffsets.right
    x1 = parent.x2
    y1 = parent.y2 - offset - height - oldTabOffset
    x2 = parent.x2 + width
    y2 = parent.y2 - offset - oldTabOffset
    local newTabOffset = parent.y2 - y1
    if (oldTabOffset < newTabOffset ) then
      parent.tabOffsets.right = newTabOffset
    end
  elseif (self.position == "left") then
    local oldTabOffset = parent.tabOffsets.left
    x1 = parent.x1 - width + 1
    y1 = parent.y2 - offset - height - oldTabOffset
    x2 = parent.x1 + 1
    y2 = parent.y2 - offset - oldTabOffset
    local newTabOffset = parent.y2 - y1
    if (oldTabOffset < newTabOffset ) then
      parent.tabOffsets.left = newTabOffset
    end
  elseif (self.position == "bottom") then
    local oldTabOffset = parent.tabOffsets.bottom
    x1 = parent.x1 + offset + oldTabOffset
    y1 = parent.y1 - height + 1
    x2 = x1 + width
    y2 = parent.y1
    local newTabOffset = x2 - parent.x1
    if (oldTabOffset < newTabOffset ) then
      parent.tabOffsets.bottom = newTabOffset
    end
  end
  return x1, y1, x2, y2
end


function Tab:UpdateCoordinates()
  self.x1, self.y1, self.x2, self.y2 = self:GetCoordinates()
end


function Tab:Draw()

  local x1 = self.x1
  local y1 = self.y1
  local x2 = self.x2
  local y2 = self.y2
  local a = self.borderOffset1
  local b = self.borderOffset2

  if (self.backgroundColor[4] ~= 0) then
    glBeginEnd(GL_QUADS, function()
      glColor(unpack(self.bottomLeftColor))
      glVertex(x1, y1)
      glColor(unpack(self.topLeftColor))
      glVertex(x1, y2)
      glColor(unpack(self.topRightColor))
      glVertex(x2, y2)
      glColor(unpack(self.bottomRightColor))
      glVertex(x2, y1)
    end)
  end

  if (not self.noBorder) then
    self:DrawBorder()
  end

end


function Tab:DrawTitle()
  local x = self.x1 + (self.x2-self.x1)*0.5
  local y = self.y1 + self.bottomMargin
  fontHandler.UseFont(FONT_DIRNAME..self.font)
  fontHandler.DrawCentered(self.title, x, y)
  fontHandler.UseFont(FONT_DIRNAME..self.parent.font) -- FIXME TEMP
end


function Tab:DrawBorder()

  local x1 = self.x1
  local y1 = self.y1
  local x2 = self.x2
  local y2 = self.y2
  local a = self.borderOffset1
  local b = self.borderOffset2

  glBeginEnd(GL_LINES, function()
    glColor(unpack(self.borderColor))
    if (self.position == "top") then
      glVertex(x1-b, y1+b)
      glVertex(x1-b, y2+a)
      glVertex(x1-a, y2+b)
      glVertex(x2+a, y2+b)
      glVertex(x2+b, y2+a)
      glVertex(x2+b, y1+b)
    elseif (self.position == "right") then
      glVertex(x1+b, y2+b)
      glVertex(x2+a, y2+b)
      glVertex(x2+b, y2+a)
      glVertex(x2+b, y1-a)
      glVertex(x2+a, y1-b)
      glVertex(x1+b, y1-b)
    elseif (self.position == "left") then
      glVertex(x1-b, y1-a)
      glVertex(x1-b, y2+a)
      glVertex(x1-a, y2+b)
      glVertex(x2-3*b, y2+b)
      glVertex(x2-3*b, y1-b)
      glVertex(x1-a, y1-b)
    elseif (self.position == "bottom") then
      glVertex(x1-b, y1-a)
      glVertex(x1-b, y2-b)
      glVertex(x2+b, y2-b)
      glVertex(x2+b, y1-a)
      glVertex(x2+a, y1-b)
      glVertex(x1-a, y1-b)
    end
  end)
end


function Tab:OnMousePress(x, y, button)
  local capture
  if (not self.parent.closed) then
	if (x > self.x1 + self.parent.dx  and
        x < self.x2 + self.parent.dx  and
        y > self.y1 + self.parent.dy  and
        y < self.y2 + self.parent.dy) then
      self.pressCaught = true
      self.parent:BringToFront()
      if (self.OnMousePressAction) then
        capture = self.OnMousePressAction(button)
      end
    end
  end
  return capture
end


function Tab:UpdateParentDisplayList()
  self.parent:UpdateDisplayList()
end


function Tab:OnIsAbove(x, y)
  local iac = self.isAboveColors
  if (x > self.x1 + self.parent.dx  and
      x < self.x2 + self.parent.dx  and
      y > self.y1 + self.parent.dy  and
      y < self.y2 + self.parent.dy) then
    if (not self.isAbove) then
      self.isAbove = true
      iac.bottomLeft, self.bottomLeftColor
        = self.bottomLeftColor, iac.bottomLeft
      iac.topLeft, self.topLeftColor
        = self.topLeftColor, iac.topLeft
      iac.topRight, self.topRightColor
        = self.topRightColor, iac.topRight
      iac.bottomRight, self.bottomRightColor
        = self.bottomRightColor, iac.bottomRight
      self:UpdateParentDisplayList()
    end
  elseif (self.isAbove) then
    self.isAbove = nil
    self.bottomLeftColor, iac.bottomLeft
      = iac.bottomLeft, self.bottomLeftColor
    self.topLeftColor, iac.topLeft
      = iac.topLeft, self.topLeftColor
    self.topRightColor, iac.topRight
      = iac.topRight, self.topRightColor
    self.bottomRightColor, iac.bottomRight
      = iac.bottomRight, self.bottomRightColor
    self:UpdateParentDisplayList()
  end
end


function Tab:OnMouseRelease(x, y, button)
  local capture
  if (not self.parent.closed) then
    if (x > self.x1 + self.parent.dx  and
        x < self.x2 + self.parent.dx  and
        y > self.y1 + self.parent.dy  and
        y < self.y2 + self.parent.dy) then
      if (self.OnMouseReleaseAction and self.pressCaught) then
        capture = self.OnMouseReleaseAction(button)
      end
      if (self.OnClick and self.pressCaught) then
        capture = self.OnClick(button)
      end
    end
  end
  self.pressCaught = nil
  return capture
end


-- Preset Functions ------------------------------------------------------------


function Tab:Close()
  return function(tab)
    tab.title = "Close"
    tab.position = "right"
    tab.OnMouseReleaseAction = function()
      tab.parent:Close()
      mainButton:Open()
    end
  end
end

-- Muratet : add a preset quit function
function Tab:Quit()
  return function(tab)
    tab.title = "Quit"
    tab.position = "right"
    tab.OnMouseReleaseAction = function()
      tab.parent:Close()
			Spring.SendCommands"quit"
    end
  end
end
--

function Tab:Goto(args)
  return function(tab)
    tab.title = args.title
    tab.position = "left"
    tab.OnMouseReleaseAction = function()
      tab.parent:Close()
      local f = loadstring(args.destination..":Open()") -- FIXME: there must be a
      setfenv(f, getfenv(1))                      -- better way.
      f()
    end
  end
end


function Tab:Back(args)
  return function(tab)
    tab.title = "Back"
    tab.position = "right"
    tab.OnMouseReleaseAction = function()
      tab.parent:Close()
      local f = loadstring(args.previousWindow..":Open()")
      setfenv(f, getfenv(1))
      f()
    end
  end
end


function Tab:SetConfigInt(args)
  return function(tab)
    tab.title = args.title
    tab.position = "left"
    tab.OnMouseReleaseAction = function()
      spSetConfigInt(args.config, args.int)
      tab.parent.lineArray[1] = args.text or
        "Current setting is: "..spGetConfigInt(args.config).."."
    end
  end
end


function Tab:ConfigEnable(args)
  return function(tab)
    tab.title = "Enable"
    tab.position = "left"
    tab.OnMousePressAction = function()
      spSetConfigInt(args.config, 1)
      tab.parent.lineArray[1] = args.text or
        "Current setting is: enabled."
    end
  end
end


function Tab:ConfigDisable(args)
  return function(tab)
    tab.title = "Disable"
    tab.position = "left"
    tab.OnMousePressAction = function()
      spSetConfigInt(args.config, 0)
      tab.parent.lineArray[1] = args.text or
        "Current setting is: disabled."
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Window Prototype
--


function Window:Create(newWindow)
  newWindow = newWindow or {}
  setmetatable(newWindow, self)
  self.__index = self -- Inherit fields from the "Window" prototype.

  newWindow:ProcessArguments()
  -- If the single line string is smaller than the specified text width,
  -- reduce the window width to match the string width.
  if (not newWindow.noAutoShrink and newWindow.text) then
    newWindow.textWidth = newWindow:GetRealTextWidth()
  end

  if (newWindow.text) then
    newWindow.lineArray = WordWrap(newWindow.text, newWindow.textWidth)
  else
    -- If a line array is fed directly to the window object, make the window
    -- as wide as the widest line.
    newWindow.textWidth = newWindow:GetMaxLineWidth()
  end

  local x2, y2 = newWindow:MakeSize()

  newWindow.x2 = newWindow.x2 or x2
  newWindow.y2 = newWindow.y2 or y2

  newWindow.dx = 0
  newWindow.dy = 0
  
  newWindow:MakeTabs()
  newWindow:ExpandToMakeTabsFit()

  if (not newWindow.closed) then
    newWindow:Open()
  end
  return newWindow
end

-- Muratet
function Window:CreateCentered (template)
	local popup = Window:Create(template)
	-- window centering
	-- compute window centering
	local winSizeX, winSizeY = Spring.GetWindowGeometry()
	local winCenterX = winSizeX/2
	local winCenterY = winSizeY/2
	-- compute popup target position (bottom left corner)
	local targetPopupX = winCenterX - (popup.x2 - popup.x1)/2
	local targetPopupY = winCenterY - (popup.y2 - popup.y1)/2
	-- compute delta between current position and target position
	local dX = math.floor(popup.x1 - targetPopupX)
	local dY = math.floor(popup.y1 - targetPopupY)
	-- update all positions
	popup.x = popup.x - dX
	popup.y = popup.y - dY
	popup.x1 = popup.x1 - dX
	popup.y1 = popup.y1 - dY
	popup.x2 = popup.x2 - dX
	popup.y2 = popup.y2 - dY
	-- recreate it centered
	popup = Window:Create(popup)
	return popup
end
--

function Window:ExpandToMakeTabsFit()

  local width = self.x2 - self.x1
  local redraw

  if (self.tabOffsets.top > width) then
    self.x2 = floor(self.x1 + self.tabOffsets.top + self.tabOffset)
    redraw = true
  end

  local width = self.x2 - self.x1

  if (self.tabOffsets.bottom > width) then
    self.x2 = floor(self.x1 + self.tabOffsets.bottom + self.tabOffset)
    redraw = true
  end

  self.textWidth = self.x2 - self.x1 - self.leftMargin - self.rightMargin

  if (redraw) then -- FIXME: Wasteful, lazy hack.
    self:MakeTabs()
    if (self.text) then
      self.lineArray = WordWrap(self.text, self.textWidth)
    end
    local _
    _, self.y2 = self:MakeSize()
    self.y2 = floor(self.y2)
    redraw = false
  end

  local height = self.y2 - self.y1

  if (self.tabOffsets.right > height) then
    self.y2 = floor(self.y1 + self.tabOffsets.right + self.tabOffset)
  end

  height = self.y2 - self.y1

  if (self.tabOffsets.left > height) then
    self.y2 = floor(self.y1 + self.tabOffsets.left + self.tabOffset)
  end
  self:MakeTabs()
end


function Window:MakeTabs()
  -- Tab offsets are used to stop tabs from overlapping.
  self.tabOffsets = {top = 0, bottom = 0, left = 0, right = 0}

  if (self.tabs) then
    self.tabData = {}
    for tab, tabArgs in ipairs(self.tabs) do
      self.tabData[tab] = Tab:Create(tabArgs, self)
    end
  end
  return self.tabOffsets
end


function Window:MakeSize()
  local textHeight   = #self.lineArray * (self.fontSize + self.lineSpacing)
  local x2 = self.x1 + self.textWidth + self.leftMargin + self.rightMargin
  local y2 = self.y1 + textHeight + self.topMargin + self.bottomMargin
  if (self.x2) then
    x2 = self.x2
  end
  if (self.y2) then
    y2 = self.y2
  end
  return x2, y2
end


function Window:GetRealTextWidth()
  local width
  local oldWidth = self.textWidth
  local textNoColorCodes = fontHandler.StripColors(self.text)
  local newWidth = fontHandler.GetTextWidth(textNoColorCodes)
  if (newWidth < self.textWidth) then
    width = newWidth
  else
    width = oldWidth
  end
  return width
end


function Window:GetMaxLineWidth() -- FIXME: max
  local lineWidth
  local maxWidth
  maxWidth = 0
  for _, line in ipairs(self.lineArray) do
    lineWidth = fontHandler.GetTextWidth(line)
    if (lineWidth > maxWidth) then
      maxWidth = lineWidth
    end
  end
  return maxWidth
end


function Window:ProcessArguments()
  self.self = self
  self.font            = self.font        or "FreeSansBold_16"
  fontHandler.UseFont(FONT_DIRNAME..self.font)
  
  -- Muratet
  self.type            = self.type            or "Window"
  self.son             = self.son             or nil
  --
  
  -- Text as an array of strings. Use "self.text" for automatic word wrapping.
  self.lineArray       = self.lineArray       or {}
  self.x               = self.x               or 400
  self.y               = self.y               or 200
  self.x1              = self.x1              or self.x
  self.y1              = self.y1              or self.y
  self.textWidth       = self.textWidth       or 300
  self.lineSpacing     = self.lineSpacing     or 3
  self.topMargin       = self.topMargin       or self.lineSpacing
  self.bottomMargin    = self.bottomMargin    or self.topMargin*2
  self.leftMargin      = self.leftMargin      or self.topMargin*2
  self.rightMargin     = self.rightMargin     or self.topMargin
  -- Border offsets determine how much the border lines protrude.
  self.borderOffset1   = self.borderOffset1   or 0.5
  self.borderOffset2   = self.borderOffset2   or 0.5
  self.tabOffset       = self.tabOffset       or 10
  
  local isAboveColorsDefault = {
    bottomLeft  = {  0,   0,   0,   1},
    topLeft     = {0.3, 0.3, 0.3,   1},
    topRight    = {0.3, 0.3, 0.3,   1},
    bottomRight = {0.5, 0.5, 0.5,   1},
  }

  self.borderColor        = self.borderColor      or {  1,   1,   1,   1}
  -- Background color when the mouse cursor is within the window.
  self.isAboveColors      = self.isAboveColors    or isAboveColorsDefault
  self.bottomLeftColor    = self.bottomLeftColor  or {  0,   0,   0, 0.5}
  self.topLeftColor       = self.topLeftColor     or {  0,   0,   0, 0.8}
  self.topRightColor      = self.topRightColor    or {  0,   0,   0, 0.5}
  self.bottomRightColor   = self.bottomRightColor or {0.4, 0.4, 0.4, 0.5}
  self.gradient           = self.IsAboveColors    or true -- FIXME?
  self.backgroundColor    = self.backgroundColor  or {  0,   0,   0, 0.5}

  if (not self.gradient) then
    self.topRightColor    = self.backgroundColor
    self.topLeftColor     = self.backgroundColor
    self.bottomLeftColor  = self.backgroundColor
    self.bottomRightColor = self.backgroundColor
  end

  self.fontSize = fontHandler:GetFontSize()
  
  
  if (self.unitPicByName) then
    self.unitPicByID = UnitDefNames[self.unitPicByName].id
  end
  if (self.unitPicByID) then
    self.backGroundTextureString = "#"..self.unitPicByID
  end

  if (self.x1 < 1) then
    self.x1 = floor(self.x1*viewSizeX)
  end
  if (self.y1 < 1) then
    self.y1 = floor(self.y1*viewSizeY)
  end
  if (self.textWidth < 1) then
    self.textWidth = floor(self.textWidth*viewSizeX)
  end
  if (self.x2 and self.x2 < 1) then
    self.x2 = floor(self.x2*viewSizeX)
  end
  if (self.y2 and self.y2 < 1) then
    self.y2 = floor(self.y2*viewSizeY)
  end

  if (self.group) then
    if (groups[self.group]) then
	  -- Muratet : check if "self" is not already into "groups[self.group]"
	  local found = false
	  for index, key in ipairs(groups[self.group]) do
	    if (key == self) then
	      found = true
	      break
	    end
	  end
	  if not found then
		table.insert(groups[self.group], self)
	  end
	  -- table.insert(groups[self.group], self)
	  --
    else
      groups[self.group] = {self}
    end
  end

  -- self.Counter = MakeCounter()
  self.Timer = MakeTimer()
  
  if (self.OnUnitFinished) then
    onUnitFinishedSet[self] = true
  end
  
  if (self.OnUnitCreated) then
    onUnitCreatedSet[self] = true
  end
  
  if (self.GetConfigData) then
    getConfigDataSet[self] = true
  end
  
  if (self.OnUpdate) then
    onUpdateSet[self] = true
  end
  
  if (self.OnDrawWorld) then
    onDrawWorldSet[self] = true
  end
  
  if (self.OnSeismicPing) then
    onSeismicPingSet[self] = true
  end
  
end


function Window:UpdateDisplayList()
  if (self.displayList) then
    glDeleteList(self.displayList)
  end

  self.displayList = glCreateList( function()
    self:DrawBackground()
    if (not self.noBorder) then
      self:DrawBorder()
    end
    if (self.tabs) then
      for _, tab in pairs(self.tabData) do
        tab:Draw()
      end
    end
  end)
  -- Muratet : update son if it available
  if self.son ~= nil then
	self.son:UpdateDisplayList()
  end
  --
end


function Window:Animate()

  local x1 = self.x1
  local x2 = self.x2
  local y1 = self.y1
  local y2 = self.y2

  local t = self.Timer()
  
  -- Muratet : avoid flickering after transition
  if (t < 0.5) then
    if (self.closed) then
      local scaleFactor = 1/(1+(0.3/t)^-15)
      glTranslate(0, 0, -1)
      glTranslate(x1+(x2-x1)/2, y1+(y2-y1)/2, 0)
      glScale(scaleFactor, scaleFactor^12, 1)
      glTranslate(-x1-(x2-x1)/2, -y1-(y2-y1)/2, 0)
    else
      glScale(0, 0, 1)
	end
  elseif (t < 1) then
	if (self.closed) then
	  objectsToDrawSet[self] = nil
	  Delist(zStack, self)
	  return true
	else
      local scaleFactor = 1/(1+(3*t+0.7)^-15)
      glTranslate(x1+(x2-x1)/2, y1+(y2-y1)/2, 0)
      glScale(scaleFactor, scaleFactor^12, 1)
      glTranslate(-x1-(x2-x1)/2, -y1-(y2-y1)/2, 0)
    end
  end
  --

--  if (t < 3) then
--    if (self.closed) then -- TODO: give more transition choices
--      local scaleFactor = 1/(1+(0.3/t)^-15)
--      glTranslate(0, 0, -1)
--      glTranslate(x1+(x2-x1)/2, y1+(y2-y1)/2, 0)
--      glScale(scaleFactor, scaleFactor^12, 1)
--      glTranslate(-x1-(x2-x1)/2, -y1-(y2-y1)/2, 0)
--	else
--      local scaleFactor = 1/(1+(3*t+0.7)^-15)
--      glTranslate(x1+(x2-x1)/2, y1+(y2-y1)/2, 0)
--      glScale(scaleFactor, scaleFactor^12, 1)
--      glTranslate(-x1-(x2-x1)/2, -y1-(y2-y1)/2, 0)
--    end
--  elseif (self.closed) then
--    objectsToDrawSet[self] = nil
--    Delist(zStack, self)
--    return true
--  end
  
end


function Window:Draw()
  -- Muratet : avoid drawing window if it is closed
  if self.closed then
	return
  end
  --
  
  glPushMatrix()

  if (not self.noAnimation) then
    if self:Animate() then
	  -- Muratet : always pop matrix if a push has been done before
	  glPopMatrix()
	  --
      return
    end
  end

  local x = self.x1 + self.leftMargin
  local a = self.fontSize + self.lineSpacing
  local b = self.y2 - self.topMargin + self.lineSpacing
  
  glTranslate(self.dx, self.dy, 0)

  glCallList(self.displayList)
  
  -- Muratet
  if self.OnDraw then
	self.OnDraw()
  end
  --
  
  fontHandler.UseFont(FONT_DIRNAME..self.font)
  fontHandler.BindTexture()
  for line, text in ipairs(self.lineArray) do
    fontHandler.DrawStatic(text, x, b - line * (a))
  end
  glTexture(false)

  if (self.tabs) then
    for _, tab in pairs(self.tabData) do
      tab:DrawTitle()
    end
  end
  
  glPopMatrix()
end


function Window:DeleteList()
  glDeleteList(self.displayList)
end


function Window:DrawBorder()
  local x1 = self.x1
  local y1 = self.y1
  local x2 = self.x2
  local y2 = self.y2
  local a = self.borderOffset1
  local b = self.borderOffset2
  glBeginEnd(GL_LINES, function()
    glColor(unpack(self.borderColor))
    glVertex(x1-b, y1-a)
    glVertex(x1-b, y2+a)
    glVertex(x1-a, y2+b)
    glVertex(x2+a, y2+b)
    glVertex(x2+b, y2+a)
    glVertex(x2+b, y1-a)
    glVertex(x2+a, y1-b)
    glVertex(x1-a, y1-b)
  end)
end


function Window:DrawBackground()
  local x1 = self.x1
  local y1 = self.y1
  local x2 = self.x2
  local y2 = self.y2

  if (self.backgroundColor[4] ~= 0) then -- If background alpha is not 0...
    glBeginEnd(GL_QUADS, function()
      glColor(unpack(self.bottomLeftColor))
      glVertex(x1, y1)
      glColor(unpack(self.topLeftColor))
      glVertex(x1, y2)
      glColor(unpack(self.topRightColor))
      glVertex(x2, y2)
      glColor(unpack(self.bottomRightColor))
      glVertex(x2, y1)
    end)
  end

  -- Draw a unitpic as background.
  if (self.backGroundTextureString) then
    glColor(1, 1, 1, 1)
    glTexture(self.backGroundTextureString)
    glTexRect(x1, y1, x2, y2)
    glTexture(false)
  end
  
end


function Window:OnMousePress(x, y, button)
  local capture
  if (not self.closed) then
    if (x > self.x1 + self.dx  and
        x < self.x2 + self.dx  and
        y > self.y1 + self.dy  and
        y < self.y2 + self.dy) then
      self:BringToFront()
      
      if (self.OnMousePressAction) then
        self.OnMousePressAction(button)
      end
      if (not self.noMove) then
        onMouseMoveSet[self] = true
      end
      self.pressCaught = true
      capture = true
    end
  end
  return capture
end


function Window:OnIsAbove(x, y)
  local siac = self.isAboveColors
  if (x > self.x1 + self.dx  and
      x < self.x2 + self.dx  and
      y > self.y1 + self.dy  and
      y < self.y2 + self.dy) then
    if (not self.isAbove) then
      self.isAbove = true
      siac.bottomLeft, self.bottomLeftColor
        = self.bottomLeftColor, siac.bottomLeft
      siac.topLeft, self.topLeftColor
        = self.topLeftColor, siac.topLeft
      siac.topRight, self.topRightColor
        = self.topRightColor, siac.topRight
      siac.bottomRight, self.bottomRightColor
        = self.bottomRightColor, siac.bottomRight
      self:UpdateDisplayList()
    end
  elseif (self.isAbove) then
    self.isAbove = nil
    self.bottomLeftColor, siac.bottomLeft
      = siac.bottomLeft, self.bottomLeftColor
    self.topLeftColor, siac.topLeft
      = siac.topLeft, self.topLeftColor
    self.topRightColor, siac.topRight
      = siac.topRight, self.topRightColor
    self.bottomRightColor, siac.bottomRight
      = siac.bottomRight, self.bottomRightColor
    self:UpdateDisplayList()
  end
end


function Window:OnMouseRelease(x, y, button)
  local capture
  if (not self.closed) then
    if (x > self.x1 + self.dx  and
        x < self.x2 + self.dx  and
        y > self.y1 + self.dy  and
        y < self.y2 + self.dy) then
      if (self.OnMouseReleaseAction) then
        self.OnMouseReleaseAction(button)
      end
      capture = true
    end
    onMouseMoveSet[self] = nil
  end
  self.pressCaught = nil
  return capture
end


function Window:OnMouseMove(x, y, dx, dy, button)
  if (self.group) then
    for _, object in pairs(groups[self.group]) do
	    object.dx = object.dx + dx
	    object.dy = object.dy + dy
    end
  else
    self.dx = self.dx + dx
    self.dy = self.dy + dy
  end
end


function Window:AvailableForNotifications()
  table.insert(onMousePressQueue, 1, self)
  if (self.useOnIsAbove) then
    table.insert(onIsAboveQueue, 1, self)
  end
  table.insert(onMouseReleaseQueue, 1, self)
  if (self.tabs) then
    for _, tab in pairs(self.tabData) do
        table.insert(onMousePressQueue, 1, tab)
        table.insert(onIsAboveQueue, 1, tab)
        table.insert(onMouseReleaseQueue, 1, tab)
    end
  end
end


function Window:UnavailableForNotifications()
  Delist(onMousePressQueue, self)
  Delist(onIsAboveQueue, self)
  Delist(onMouseReleaseQueue, self)
  if (self.tabs) then
    for _, tab in pairs(self.tabData) do
        Delist(onMousePressQueue, tab)
        Delist(onIsAboveQueue, tab)
        Delist(onMouseReleaseQueue, tab)
    end
  end
end


function Window:Open() -- FIXME: ignore if already opened
  self:AvailableForNotifications()
  self.closed = nil
  self.Timer = MakeTimer()
  objectsToDrawSet[self] = true
  -- Muratet : check if "self" is not already into "zStack"
  local found = false
  for index, key in ipairs(zStack) do
    if (key == self) then
      found = true
      break
    end
  end
  if not found then
	table.insert(zStack, self)
  end
  --table.insert(zStack, self)
  --
  
  self:UpdateDisplayList()
  
  -- Muratet : Open its son if it exists
  if self.son ~= nil then
    self.son:Open()
  end
  --
end


function Window:Close()
  self:UnavailableForNotifications()
  if (not self.noAnimation) then
    self.Timer = MakeTimer()
    self.closed = true
  else
    objectsToDrawSet[self] = nil
	-- Muratet : set window closed even without animation
    self.closed = true
	--
    Delist(zStack, self)
  end
  -- Muratet : Close its son if it exists
  if self.son ~= nil then
    if not self.son.closed then
		self.son:Close()
	end
  end
  --
end


function Window:BringToFront()
  Delist(zStack, self)
  table.insert(zStack, self)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Group Functions
--


function CloseGroup(group, openMainButton)

  for _, object in pairs(groups[group]) do
    object:Close()
  end
  if (mainButton.closed and openMainButton ~= false) then
    mainButton:Open()
  end
end
  
  
function OpenGroup(group)
  for _, object in pairs(groups[group]) do
    object:Open()
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Rooms
--

-- Very Important freaking chunk of code
local roomList = VFS.DirList(ROOM_DIRNAME, "room_*.lua", VFSMODE)
for _, file in ipairs(roomList) do
  local s = assert(VFS.LoadFile(file, VFSMODE))
  chunk = assert(loadstring(s, file))
  setfenv(chunk, rooms)
  local success, e = pcall(chunk(), file)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Call-ins
--


function widget:DrawScreen()
  for _, object in ipairs(zStack) do
    object:Draw()
  end
end


function widget:Update(dt)
 realSeconds = realSeconds + dt
 for object in pairs(onUpdateSet) do
   object.OnUpdate(dt, realSeconds)
 end
end


function widget:MousePress(x, y, button)
  local capture
  for _, object in ipairs(onMousePressQueue) do
    capture = object:OnMousePress(x, y, button)
    if (capture) then
	  return true
    end
  end
  
end

 
function widget:MouseRelease(x, y, button)
  local capture
  for _, object in ipairs(onMouseReleaseQueue) do
    capture = object:OnMouseRelease(x, y, button)
    if (capture) then
      return true
    end
  end
end


function widget:IsAbove(x, y)
  local capture
  for _, object in pairs(onIsAboveQueue) do
    capture = object:OnIsAbove(x, y)
    if (capture) then
      return true
    end
  end
end


function widget:ViewResize(vsx, vsy)
  viewSizeX, viewSizeY = vsx, vsy
end


function widget:MouseMove(x, y, dx, dy, button)
  for object in pairs(onMouseMoveSet) do
    object:OnMouseMove(x, y, dx, dy, button)
  end
end


function widget:UnitFinished(unitID, unitDefID, unitTeam)
  for object in pairs(onUnitFinishedSet) do
    object.OnUnitFinished(unitID, unitDefID, unitTeam)
  end
end


function widget:UnitCreated(unitID, unitDefID, unitTeam)
  for object in pairs(onUnitCreatedSet) do
    object.OnUnitCreated(unitID, unitDefID, unitTeam)
  end
end


function widget:GetConfigData() -- Save
  local save = {}
  for object in pairs(getConfigDataSet) do
    local k, v = object.GetConfigData()
    save[k] = v
  end
  return save
end


function widget:SetConfigData(data)  -- Load
  for object in pairs(getConfigDataSet) do
    object.SetConfigData(data)
  end
end


function widget:DrawWorld()
  for object in pairs(onDrawWorldSet) do
    object.OnDrawWorld()
  end
end


function widget:Intialize()
  fontHandler.FreeFonts()
  fontHandler.FreeCache()
end


function widget:Shutdown()
  fontHandler.FreeFonts()
  fontHandler.FreeCache()
end


function widget:UnitSeismicPing(x, y, z, strength)
  for object in pairs(onSeismicPingSet) do
    object.OnSeismicPing(x, y, z, strength)
  end  
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Notes
--


--[[
 
 todo: easy way to delete objects

MouseWheel(up, value)
UnitCreated(unitID, unitDefID, unitTeam)
UnitFinished(unitID, unitDefID, unitTeam)
UnitDestroyed(unitID, unitDefID, unitTeam)
UnitTaken(unitID, unitDefID, unitTeam, newTeam)
UnitIdle(unitID, unitDefID, unitTeam)
UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)

  print("-- Mouse Press Begin -------------------")
  local count = 0
  for i, v in pairs(onMousePressSet) do
    count = count + 1
    if i.title then
      print(i, "tab", i.title)
    end
    if i.lineArray then
      print(i, "window", i.lineArray[1])
    end
  end
  print("objects notified: ", count)
  print("-- Mouse Press End----------------------")
  
  print("-- Mouse Release Begin -----------------")
  local count = 0
  for i, v in pairs(onMouseReleaseSet) do
    count = count + 1
    if i.title then
      print("window", i.parent, "tab", i, i.title)
    end
    if i.lineArray then
      print("window", i, "body", i.lineArray[1])
    end
  end
  print("objects notified: ", count)
  print("-- Mouse Release End -------------------")
  
  table.foreach(getfenv(1), print)
--]]

--[[
]]

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------