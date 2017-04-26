-- $Id: room_help.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Complete Annihilation in-game help.
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/gui_doors.lua for documentation.
-- Helptexts are now in unit definitions (in the customParams table)
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Speed-ups
--


local Window         = Window
local Tab            = Tab
local GetGameSeconds = Spring.GetGameSeconds
local GetUnitDefID   = Spring.GetUnitDefID


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Constants
--



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Local Variables
--


local unitsHelped = {}
local disableHelpMessages

--------------------------------------------------------------------------------


local function OnUnitFinished(unitID, unitDefID, unitTeam)
  local myTeamID = Spring.GetMyTeamID()
  local name = UnitDefs[unitDefID].name
  if (unitTeam == myTeamID and 
      not disableHelpMessages and
      UnitDefs[unitDefID].customParams and
      UnitDefs[unitDefID].customParams.helptext) then
    MakeUnitHelpWindow(unitDefID, unitID, "UnitFinished")
  end
end


local function GetConfigData() -- Save
  room_help = { 
    unitsHelped = unitsHelped,
    disableHelpMessages = disableHelpMessages,
  }
  return "room_help", room_help
end


local function SetConfigData(data) -- Load  
  if data.room_help then
    unitsHelped = data.room_help.unitsHelped or {}
  else
    data.room_help = {}
    unitsHelped = {}
  end 
  disableHelpMessages = data.room_help.disableHelpMessages
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Warning Windows
--

local disableHelpMessagesTab = {
  title = "Disable Help Messages",
  position = "left",
  OnMouseReleaseAction = function()
    confirmHelpDisable:Open()
    disableHelpMessages = true
  end,
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Unit Selection Dialog
--


infoSelect = Window:Create{
  x = 208,
  y = 100,
  closed = true,
  text = "Please select a unit.",
  tabs = {
    {title = "OK",
       position = "left",
       OnMouseReleaseAction = function()
          infoSelect:Close()
          MakeUnitHelpWindow()
          helpButton:Open()
       end
    },
    {title = "Cancel",
     position = "right",
     OnMouseReleaseAction = function()
        infoSelect:Close()
        if (helpButton.closed) then
          helpButton:Open()
        end
      end
    },
  }
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Help Button
--


helpButton = Window:Create{
  x1 = 600,
  y1 = 100,
  closed = false,
  textWidth = 300,
  lineArray = {"Unit Help"},
  useOnIsAbove = true,
  OnMousePressAction = function()
    helpButton.timeFromMousePress = MakeTimer()
    return true
  end,
  
  OnMouseReleaseAction = function()
    if (helpButton.timeFromMousePress() < 0.2) then -- Ignores press/realease    
      helpButton:Close()                            -- couples intended to drag 
      MakeUnitHelpWindow()                          -- the window, not click.
    end
    helpButton.timeFromMousePress = nil
  end,
  OnUnitFinished = OnUnitFinished,  
  GetConfigData = GetConfigData,  
  SetConfigData = SetConfigData,
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Event-specific Text Maker
--


local function MakeEventText(event, unitDefID)
  local humanName = UnitDefs[unitDefID].humanName
  if (event == "UnitFinished") then
    return string.format("You have just built your first %s. ", humanName)
  else
    return "Error: no event text"
  end
end

 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Unit Help Window Maker
--


function MakeUnitHelpWindow(unitDefID, unitID, event)
  
  local id = {}
  local group = tostring(id) -- make a unique ID
  
  -- Request unit selection if no unitID or unitDefID is supplied
  if (not unitDefID) then
    
    if (not unitID) then
      unitID = Spring.GetSelectedUnits()[1]
      if (not unitID) then
        infoSelect:Open()
        return
      end
    end
    
    unitDefID = Spring.GetUnitDefID(unitID)
  end
  
  local unitDef = UnitDefs[unitDefID]
  
  local eventText
  local text
  local helpText
  
  if (unitDef.customParams and unitDef.customParams.helptext) then
    helpText = unitDef.customParams.helptext
  else
    helpText = "No help text available for this unit."
  end
  
  if (helpText) then
    if (event) then
      eventText = MakeEventText(event, unitDefID)
      text = eventText..helpText
    else
      text = helpText
    end
  end
  
  if (event == "UnitFinished") then
    if (unitsHelped[unitDef.name]) then
      return
    else
      unitsHelped[unitDef.name] = true
    end
  end
  
  local args = {
    group = group,
    text = text,
    id = id, -- Prevents the unique ID source from being garbage collected.
    tabs = {
      {title = unitDef.humanName.." Help Window"},
      {title = "Close",
        position = "right",
        OnMouseReleaseAction = function()
          CloseGroup(group, false)
          helpButton:Open()
        end
      },
      {title = "More Information",
        position = "left",
        OnMouseReleaseAction = function()
          CloseGroup(group, false)
          helpButton:Open()
          MakeInfoWindow(unitDefID, group)
        end,
      },
    },
  }
  
  if (unitID) then
    
    local tab = { 
      title = "Center",
      position = "left",
      OnMouseReleaseAction = function()
        local x, y, z = Spring.GetUnitPosition(unitID)
        Spring.SetCameraTarget(x, y, z)
      end,
    }
            
    table.insert(args.tabs, 2, tab)
  end
  
  if (event == "UnitFinished") then
    local tab = {
      title = "Disable Help Messages",
      position = "left",
      OnMouseReleaseAction = function()
        confirmHelpDisable:Open()
        disableHelpMessages = true
        CloseGroup(group, false)
      end,
    }
    table.insert(args.tabs, tab)
  end
  
  local helpWindow = Window:Create(args)
  
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Help Messages Disabled Dialogs
--


local confirmHelpDisableText = [[
Automatic help messages can be enabled again from the main menu.
]]


confirmHelpDisable = Window:Create{
  x = 208,
  y = 100,
  closed = true,
  text = confirmHelpDisableText,
  tabs = {
    {title = "OK",
       position = "left",
       OnMouseReleaseAction = function()
          confirmHelpDisable:Close()
       end
    },
  }
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Help Options Dialog Maker (to main menu)
--


function GetMessageOptionsText()
  local s
  if (disableHelpMessages) then
    s =  "Help Messages are disabled."
  else
    s =  {
      "Help Messages are enabled.",
      " ",
      "Resetting the unit list makes hidden", 
      "tutorial messages visible again.",
    }
  end
  table.insert(s, "")
  if (WG.improvedMetalMaker) then
    table.insert(s, "Stall prevention is enabled.")
  else
    table.insert(s, "Stall prevention is disabled.")
  end
  return s
end


helpMessageOptions = Window:Create{
  x = 208,
  y = 100,
  closed = true,
  lineArray = GetMessageOptionsText(),
  tabs = {
    {title = "Help Options"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "mainMenu"}},
    {title = "Enable Help Messages",
      position = "left",
      OnMouseReleaseAction = function()
        disableHelpMessages = false
        helpMessageOptions.lineArray[1] = "Help Messages are enabled."
      end,
    },    
    {title = "Disable Help Messages",
      position = "left",
      OnMouseReleaseAction = function()
        disableHelpMessages = true
        helpMessageOptions.lineArray[1] = "Help Messages are disabled."
      end,
    },
    {title = "Reset unit list",
      position = "left",
      OnMouseReleaseAction = function()
        unitsHelped = {}
      end,
    },
    {title = "Toggle Stall Prevention",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands({"luaui togglewidget Improved MetalMakers"})
        helpMessageOptions.lineArray = GetMessageOptionsText()
      end,
    },
  }
}

