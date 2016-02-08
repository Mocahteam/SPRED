-- $Id: room_showAllCommands.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Room based on tombom's showAllCommands widget: 
-- http://www.unknown-files.net/spring/3391/SeeAllCommands_05/
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Speed-ups
--


local Window           = Window
local Tab              = Tab
local GetMouseState    = Spring.GetMouseState
local TraceScreenRay   = Spring.TraceScreenRay
local DrawUnitCommands = Spring.DrawUnitCommands
local GetTeamUnits     = Spring.GetTeamUnits
local GetTeamList      = Spring.GetTeamList



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



local team
local ally
local myTeam = Spring.GetMyTeamID()
local myAlly = Spring.GetMyAllyTeamID()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



local function MakeCommandsWindowText()
  local s, t
  if (ally) then 
    s = "All ally commands are visible.  "
  elseif (team) then
    s = "All team commands are visible.  "
  else
    s, t = 'Commands are only visible   ', 'when "SHIFT" is held.'
  end
  return {s, t}
end



function GetConfigData() -- Save
  room_showAllCommands = {
    ally = ally,
    team = team,
  }
  return "room_showAllCommands", room_showAllCommands
end


function SetConfigData(data) -- Load
  if data.room_showAllCommands then
    ally = data.room_showAllCommands.ally
    team = data.room_showAllCommands.team
  else
    data.room_showAllCommands = {}
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



function OnDrawWorld()
  RunOnce(function() 
      commandsWindow.lineArray = MakeCommandsWindowText() 
    end)()
 	local mx, my = GetMouseState()
  	local type, data = TraceScreenRay(mx, my)
	if (ally) then
		local allyList = GetTeamList(myAlly)
		for i, v in pairs(allyList) do
			local units = GetTeamUnits(v)
    			for q, s in pairs(units) do
				if (q ~= nil) then
        				DrawUnitCommands(s)
				end
			end
		end
	elseif (team) then
		local units = GetTeamUnits(myTeam)
    		for i, v in pairs(units) do
			if (i ~= nil) then
        			DrawUnitCommands(v)
			end
		end
	end
	if (type == 'unit') then
		DrawUnitCommands(data)
	end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


commandsWindow = Window:Create{
  closed = true,
  group = "ingameMenu",
  OnDrawWorld = OnDrawWorld,
  SetConfigData = SetConfigData,
  GetConfigData = GetConfigData,
  lineArray = MakeCommandsWindowText(),
  tabs = {
    {title = "Command Display Options"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow='displayMenu'}},
    {title = "Show all ally commands.",
      position = "left",
      OnClick = function()
        ally = true
        team = true
        commandsWindow.lineArray = MakeCommandsWindowText()
      end,
    },
    {title = "Show all team commands.",
      position = "left",
      OnClick = function()
        ally = nil
        team = true
        commandsWindow.lineArray = MakeCommandsWindowText()
      end,
    },
    {title = "Hide commands.",
      position = "left",
      OnClick = function()
        ally = nil
        team = nil
        commandsWindow.lineArray = MakeCommandsWindowText()
      end,
    },
  }
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------