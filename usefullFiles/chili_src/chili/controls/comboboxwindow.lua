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
  mainCombo = nil,
}

local this = ComboBoxWindow
local inherited = this.inherited

function ComboBoxWindow:New(obj)
  obj = inherited.New(self,obj)
  obj.mainCombo:Select(obj.selected)
  return obj
end

function ComboBoxWindow:FocusUpdate()
  if (not self.state.focused) then
    local needToClose = true
    --Check if one of the items is focused
    local scrollPanel = self.children[1]
    if scrollPanel.state.focused then
      needToClose = false
    else
      local stackPanel = scrollPanel.children[1]
      local items = stackPanel.children
      for i=1,#items do
        if items[i].state.focused then
          needToClose = false
        end
      end
    end
    if needToClose then
      self.mainCombo:_CloseWindow()
    end
  end
end
