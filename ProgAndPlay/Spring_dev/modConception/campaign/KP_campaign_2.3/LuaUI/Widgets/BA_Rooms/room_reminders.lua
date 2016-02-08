-- $Id: room_reminders.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Complete Annihilation reminders.
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/gui_doors.lua for documentation.
--
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
-- Locals
--


local myTeamID = Spring.GetMyTeamID()
local reminders
local timeIncrement = 5*60
local MakeReminderConfText


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Event Configuration
--


local events = {
  { 
    name = "Anti-Air",
    time = 300,
    text = "You have not built any anti-air unit yet. It's a good idea to build some even if you haven't seen any plane around yet.",
    units = {
      "armaak",
      "armaas",
      "armah",
      "armarch",
      "armcir",
      "armflak",
      "armfrt",
      "armjeth",
      "armrl",
      "armhawk",
      "armfig",
      "armsfig",
      "armyork",
      "corah",
      "corarch",
      "corcrash",
      "corenaa",
      "corerad",
      "corflak",
      "corfrt",
      "corrazor",
      "corrl",
      "corsfig",
      "corveng",
      "mercury",
      "screamer",
    },
  },
  
  {
    name = "Storage",
    time = 600,
    text = "You have not built any storage yet. Storage enables you to use powerful weapons and increases the efficiency of your economy. Most units do not store energy or metal so you should build some dedicated storage buildings.",
    units = {
      "armestor",
      "armmstor",
      "armuwadves",
      "armuwadvms",
      "armuwes",
      "armuwms",
      "coruwes",
      "coruwms",
      "corestor",
      "cormstor",
    },
  },
  {
    name = "Anti-Nuke",
    time = 1200,
    text = "You have not built any anti-nuke yet. Anti-Nukes intercept any incoming nuclear missile aimed at inside their area of protection. At this point, it might be prudent to build one.",
    units = {
      "armscab",
      "corfmd",
      "cormabm",
      "armamd",
    }
  },
  {
    name = "Anti-Intrusion",
    time = 900,
    text = "You have not built any anti-intrusion device yet. Anti-intrusion devices detect moving units by their seismic signature, even if they are cloaked or stealth. If you don't intend to build one, it is judicious to arrange scout patrols in or around your base.",
    units = {
      "armsd",
      "corsd",
    },
  },
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Save/Load (to reminderOptions)
--


local function GetConfigData() -- Save
  room_reminders = { 
    reminders = reminders,

  }
  for _, event in ipairs(events) do
    room_reminders[event.name] = event.time 
  end
  return "room_reminders", room_reminders
end


local function SetConfigData(data) -- Load  
  if (data.room_reminders) then
    reminders = data.room_reminders.reminders
    for _, event in ipairs(events) do
      event.time = data.room_reminders[event.name]
    end
  else
    data.room_reminders = {}
    reminders = true
  end
  for _, event in ipairs(events) do
    event.reminderConf.lineArray[1] = MakeReminderConfText(event)
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Unit accounting
--


local function CheckUnit(unitID)
  local unitDefID = GetUnitDefID(unitID)
  local unitName = UnitDefs[unitDefID].name 
  for _, event in ipairs(events) do 
    for _, eventUnitName in ipairs(event.units) do 
      if (unitName == eventUnitName) then
        event.built = true
      end
    end
  end
end


do 
  local teamUnits = Spring.GetTeamUnits(myTeamID)
  for _, unitID in ipairs(teamUnits) do
    CheckUnit(unitID)
  end
end


local function OnUnitCreated(unitID, unitDefID, unitTeam)
  if (unitTeam ~= myTeamID) then
    return
  else
    CheckUnit(unitID)
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Confirm disable reminders window
--


local confirmHelpDisableText = [[
Reminders can be enabled again from the main menu.
]]


confirmReminderDisable = Window:Create{
  x = 208,
  y = 100,
  closed = true,
  text = confirmHelpDisableText,
  tabs = {
    {title = "OK",
       position = "left",
       OnMouseReleaseAction = function()
          confirmReminderDisable:Close()
       end
    },
  }
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Reminder Window
--
  
  
local disableRemindersTab = {
  title = "Disable Reminders",
  position = "left",
  OnMouseReleaseAction = function()
    confirmReminderDisable:Open()
    reminders = false
  end,
}


local function MakeReminderWindow(event)
  return  Window:Create{
    text = event.text,
    tabs = {
      {title = "Reminder: "..event.name},
      {preset = Tab:Close()},
      Copy(disableRemindersTab),
    }
  }
end

  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Event triggering
--


local function CheckTriggers()
  local t = GetGameSeconds()
  -- print("reminders", reminders)
  for _, event in ipairs (events) do
    -- print("name", event.name)
    -- print("built", event.built)
    -- print("triggered", event.trigged)
    if (not event.built and
        event.time < t and
        not event.triggered and
        reminders) then
      event.triggered = true
      MakeReminderWindow(event)
    end 
  end
end


local function MakeOnUpdate()
  local Counter = MakeCounter()
  return function(dt)
    if (Counter() > 100) then
      CheckTriggers()
      Counter = MakeCounter()
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Reminder configuration windows
--

function MakeReminderConfText(event)
  return "Reminder trigger countdown duration: "..event.time/60 .." minutes.   "
end

local function MakeReminderConf(event)
  local lineArray = {}
  local group = tostring(lineArray)
  return Window:Create{
    group = group,
    closed = true,
    lineArray = {MakeReminderConfText(event)},
    tabs = {
      {title = event.name.." Configuration"},
      {title = "Close",
        position = "right",
        OnClick = function()
          CloseGroup(group)
          mainButton:Open()
        end,
      },
      {preset = Tab:Back{previousWindow = "reminderOptions"}},
      {title = "Increment Countdown",
        position = "left",
        OnClick = function()
          event.time = event.time + timeIncrement
          event.reminderConf.lineArray[1] = MakeReminderConfText(event)
        end,
      },
      {title = "Decrement Countdown",
        position = "left",
        OnClick = function()
          event.time = event.time - timeIncrement
          event.reminderConf.lineArray[1] = MakeReminderConfText(event)
        end,
      },
    }, 
  }
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Reminder options window
--

do

  local windowArgs = {
    closed = true,
    text =  "Reminders are triggered when you haven't built determined "..
    "buildings at the selected time. Click on the buttons on the left to "..
    "configure reminders.",
    OnUpdate = MakeOnUpdate(),
    SetConfigData = SetConfigData,
    GetConfigData = GetConfigData,
    OnUnitCreated = OnUnitCreated,
    tabs = {
      {title = "Reminder Options"},
      {preset = Tab:Close()},
      {preset = Tab:Back{previousWindow = "mainMenu"}},
      {title = "Enable Reminders",
        position = "left",
        OnClick = function()
          reminders = true
        end,
      },
      {title = "Disable Reminders",
        position = "left",
        OnClick = function()
          reminders = false
        end,
      },
    },  
  }

  for _, event in ipairs(events) do
    event.reminderConf = MakeReminderConf(event)
    local tab = {
      title = event.name,
      position = "left",
      OnClick = function()
        event.reminderConf:Open()
        reminderOptions:Close()
      end,
    }
    table.insert(windowArgs.tabs, tab)
  end

  reminderOptions = Window:Create(windowArgs)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------