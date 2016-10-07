--//=============================================================================

--- Checkbox module

--- Checkbox fields.
-- Inherits from Control.
-- @see control.Control
-- @table Checkbox
-- @bool[opt=true] checked checkbox checked state
-- @string[opt="text"] caption caption to appear in the checkbox
-- @string[opt="left"] textalign text alignment
-- @string[opt="right"] boxalign box alignment
-- @int[opt=10] boxsize box size
-- @int[opt=10] maxboxsize maximum box size in case of auto adjust font
-- @tparam {r,g,b,a} textColor text color, (default {0,0,0,1})
-- @tparam {func1,func2,...} OnChange listener functions for checked state changes, (default {})
Checkbox = Control:Inherit{
  classname = "checkbox",
  checked   = true,
  caption   = "text",
  textalign = "left",
  boxalign  = "right",
  boxsize   = 10,
  maxboxsize = 40,

  textColor = {0,0,0,1},

  defaultWidth     = 70,
  defaultHeight    = 18,

  OnChange = {}
}

local this = Checkbox
local inherited = this.inherited

--//=============================================================================

function Checkbox:New(obj)
	obj = inherited.New(self,obj)
	obj.state.checked = obj.checked
	return obj
end

function Checkbox:UpdateLayout()
  if (self.font.autoAdjust) then
    if (self.caption and self.caption ~= "") then
      local textHeight  = self.font:GetTextHeight(self.caption, self.font.maxSize)
      Spring.Echo("CheckBox (textHeight) : "..textHeight)
      local textWidth = self.font:GetTextWidth(self.caption, self.font.maxSize)
      Spring.Echo("CheckBox (textWidth) : "..textWidth)
      local ratio = (self.height - self.padding[2] - self.padding[4]) / textHeight
      Spring.Echo("CheckBox (ratio 1) : "..ratio)
      ratio = math.min(ratio, (self.width - self.padding[1] - self.padding[3]) / textWidth)
      Spring.Echo("CheckBox (ratio 2) : "..ratio)
      self.font.size = math.max(1, math.min(self.font.maxSize * ratio, self.font.maxSize))
      Spring.Echo("CheckBox (font size) : "..self.font.size)
      self.font:_LoadFont()
      self.font:SetParent(self)
    end
    self.boxsize = math.min(self.width, self.height, self.maxboxsize)
  end
end

--//=============================================================================

--- Toggles the checked state
function Checkbox:Toggle()
  self:CallListeners(self.OnChange,not self.checked)
  self.checked = not self.checked
  self.state.checked = self.checked
  self:Invalidate()
end

--//=============================================================================

function Checkbox:DrawControl()
  --// gets overriden by the skin/theme
end

--//=============================================================================

function Checkbox:HitTest()
  return self
end

function Checkbox:MouseDown()
  self:Toggle()
  return self
end

--//=============================================================================
