--//=============================================================================

--- ComboBoxWindow module

--- ComboBoxWindow fields.
-- Inherits from Window.
-- @see window.Window
-- @table ComboBoxWindow
ComboBoxWindow = Window:Inherit{
  classname = "combobox_window",
  resizable = false,
  draggable = false,
}

local this = ComboBoxWindow
local inherited = this.inherited
local mainCombo

function ComboBoxWindow:New(obj)
  obj = inherited.New(self,obj)
  mainCombo = obj.mainCombo
  mainCombo:Select(obj.selected)
  return obj
end

function ComboBoxWindow:FocusUpdate()
  if (not self.state.focused) then
    local needToClose = true
    --Check if one of the items is focused
    local scrollPanel = self.children[1]
    local stackPanel = scrollPanel.children[1]
    local items = stackPanel.children
    for i=1,#items do
      if items[i].state.focused then
        needToClose = false
      end
    end
    if needToClose then
      mainCombo:_CloseWindow()
    end
  end
end
