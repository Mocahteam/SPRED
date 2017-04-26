-- $Id: room_debug.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
-- Room Info
--------------------------------------------------------------------------------


-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
-- Licensed under the terms of the GNU GPL, v2 or later.

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Speed-ups
--


local Window        = Window
local Tab           = Tab

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function RecordLines(event, line)
  local fileName = debug.getinfo(2).source
  if (string.find(fileName, "rooms")) then
    lineCounts[line] = lineCounts[line] + 1
  end
end


local function WriteReport(file)
  io.input(LUAUI_DIRNAME.."Widgets/gui_rooms.lua")
  local lines = {}
  for line in io.lines() do
    table.insert(lines, line)
  end
  io.output(LUAUI_DIRNAME.."Widgets/Rooms/linecounts.txt")
  for line, count in ipairs(lineCounts) do
    local lineString
    if (lines[line]) then
      lineString = line.." : "..count.." ; "..lines[line].."\n"
    else
      lineString = line.." : "..count.." ; \n"
    end
    if (file) then
      io.write(lineString)
    else
      print(lineString)
    end
  end
  lineCounts = nil
end     

    
debugWindow = Window:Create{
  closed = true,
  group = "mainMenu",
  lineArray = todo,
  tabs = {
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "mainMenu"}},
    {title = 'enable line counts',
      position = 'left',
      OnMouseReleaseAction = function()
        lineCounts = {}
        for i=1, 2000 do
          lineCounts[i] = 0
        end
        debug.sethook(RecordLines, "l")
      end
    },
    {title = 'disable line counts',
      position = 'left',
      OnMouseReleaseAction = function()
        debug.sethook()
      end
    },
    {title = 'print line counts',
     position = 'left',
     OnMouseReleaseAction = function() 
       WriteReport()
     end
    },
    {title = 'save line counts to file',
     position = 'left',
     OnMouseReleaseAction = function()
       WriteReport(true) 
     end
    },
  },
}
  
--[[
  "- gadget interface",
  "  - upgrade interface",
  "- tutorial",  
  "- lodscale", 
  "- show ally commands",
  "- vsync",
  "- unit def editing interface",
  "- real seconds, real speed",
  "- replay skip interface",
  "- keboard ref",
  "- game/economy/kills/graph/map stats?",
  "- adv share dialog?",
  "- upgrade/build tree?",
  "- UDP packet MTU thing?",
  "- player countrycodes",
  "- auto-specfullview 2 option",
  "- volume",
  "- dyn /maxparticles",
  "- minimap simplecolors",  
  "- cmdcolors.txt stuff",
  "- make list of items in the to-do ",
  "  list that i'll actually do",
--]]


-- local lineArray = {}
-- for word in string.gmatch(shortTestString, "[^\n]+") do
  -- table.insert(lineArray, word)
-- end 

todo = {
  "counts the number of time each line is processed",
}

  
-- scrollWindow = Window:Create{
  -- lineArray = lineArray,
  -- tabs = {{title="test"}},
-- }






















