-- $Id: room_cursors.lua 3577 2008-12-29 05:40:38Z google frog $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Cursor Set Selector Window.
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local cursorNames = {
  'cursornormal',
  'cursorareaattack',
  'cursorattack',
  'cursorattack',
  'cursorbuildbad',
  'cursorbuildgood',
  'cursorcapture',
  'cursorcentroid',
  'cursordwatch',
  'cursorwait',
  'cursordgun',
  'cursorattack',
  'cursorfight',
  'cursorattack',
  'cursorgather',
  'cursorwait',
  'cursordefend',
  'cursorpickup',
  'cursormove',
  'cursorpatrol',
  'cursorreclamate',
  'cursorrepair',
  'cursorrevive',
  'cursorrepair',
  'cursorrestore',
  'cursorrepair',
  'cursorselfd',
  'cursornumber',
  'cursorwait',
  'cursortime',
  'cursorwait',
  'cursorunload',
  'cursorwait',
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function SetCursor(cursorSet)
  for _, cursor in ipairs(cursorNames) do
    local topLeft = (cursor == 'cursornormal' and cursorSet ~= 'k_haos_girl')
    Spring.ReplaceMouseCursor(cursor, cursorSet.."/"..cursor, topLeft)
  end
end


local function RestoreCursor()
  for _, cursor in ipairs(cursorNames) do
    local topLeft = (cursor == 'cursornormal')
    Spring.ReplaceMouseCursor(cursor, cursor, topLeft)
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function GetConfigData() -- Save
  room_cursors = {
    cursorSet = cursorSet,
  }
  return "room_cursors", room_cursors
end


function SetConfigData(data) -- Load
  if data.room_cursors then
    cursorSet = data.room_cursors.cursorSet
  else
    data.room_cursors = {}
  end
  
  if (cursorSet) then
    SetCursor(cursorSet)
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

cursors = Window:Create{
  group = "ingameMenu",
  closed = true,
  SetConfigData = SetConfigData,
  GetConfigData = GetConfigData,
  tabs = {
    {title = "Cursor Selection"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {title = "Complete Annihilation",
      position = "left",
      OnMouseReleaseAction = function()
        cursorSet = nil
        RestoreCursor()
		
      end,
    },
	{title = "Static CA",
      position = "left",
      OnMouseReleaseAction = function()
        cursorSet = "ca_static"
        SetCursor(cursorSet)
      end,
    },
    {title = "Erom",
      position = "left",
      OnMouseReleaseAction = function()
        cursorSet = "erom"
        SetCursor(cursorSet)
      end,
    },
    {title = "Masse",
      position = "left",
      OnMouseReleaseAction = function()
        cursorSet = "masse"
        SetCursor(cursorSet)
      end,
    },
    {title = "Lathan",
      position = "left",
      OnMouseReleaseAction = function()
        cursorSet = "lathan"
        SetCursor(cursorSet)
      end,
    },
    {title = "Total Annihilation",
      position = "left",
      OnMouseReleaseAction = function()
        cursorSet = "ota"
        SetCursor(cursorSet)
      end,
    },
    {title = "K_haos_girl",
      position = "left",
      OnMouseReleaseAction = function()
        cursorSet = "k_haos_girl"
        SetCursor(cursorSet)
      end,
    },
  }
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------