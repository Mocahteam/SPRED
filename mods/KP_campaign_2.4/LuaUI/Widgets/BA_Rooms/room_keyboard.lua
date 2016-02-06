-- $Id: room_keyboard.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Keyboard reference. At the moment it's not interactive.
-- Image by Pendrokar. Thanks for letting us use it!
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local kbSizeX = 966
local kbSizeY = 453
local keyImageFile = ROOM_DIRNAME.."/keys.jpg"

keyboardRef = Window:Create{
  closed = true,
  x1 = 100, 
  y1 = 100, 
  x2 = 100 + kbSizeX, 
  y2 = 100 + kbSizeY,
  backGroundTextureString = keyImageFile,
  group = group,
  unitPicByID = unitDefID,
  tabs = {
    {title = "Keyboard Reference"},
      {preset = Tab:Close()},
      {preset = Tab:Back{previousWindow = "mainMenu"}},
  },
}