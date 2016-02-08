-- $Id: room_sound.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Complete Annihilation sound interface.
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

soundOptions = Window:Create{
  group = "ingameMenu",
  closed = true,
  tabs = {
    {title="Sound Options"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "mainMenu"}},
    {preset = Tab:Goto{title = "Unit Replies", destination = "unitReplies"}},
    {preset = Tab:Goto{title = "Seismic Pings", destination = "seismicPings"}},
  }
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local function UnitReplyText()
  local lineArray = {}
  if (WG.noises) then
    lineArray[2] = "Unit noises are enabled."
  else
    lineArray[2] = "Unit noises are disabled."
  end
  if (WG.voices) then
    lineArray[1] = "Unit voices are enabled."
  else
    lineArray[1] = "Unit voices are disabled."
  end
  return lineArray
end


unitReplies = Window:Create{
  group = "ingameMenu",
  lineArray = {"Unit noises are disabled."},
  closed = true,
  tabs = {
    {title = "Unit Reply Sounds"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "soundOptions"}},
    {title = "Toggle unit voices",
      position = "left",
      OnClick = function()
        Spring.SendCommands({"luaui togglewidget Voices"})
        unitReplies.lineArray = UnitReplyText()
      end,
    },
    {title = "Toggle unit noises",
      position = "left",
      OnClick = function()
        Spring.SendCommands({"luaui togglewidget Noises"})
        unitReplies.lineArray = UnitReplyText()
      end,
    },
  }
}


unitReplies.lineArray = UnitReplyText()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

do
  local pings

  local LUAUI_DIRNAME = 'LuaUI/'
  local SOUND_DIRNAME = LUAUI_DIRNAME..'Sounds/'
  local PING_FILENAME = "teamgrab.wav"

  
  local function PingText()
    local s
    if (not pings) then
      s = "Seismic pings are inaudible."
    elseif (pings == 1) then
      s = "Seismic pings are positional."
    else
      s = "Seismic pings can be heard from anywhere."
    end
    return s
  end
  
  local function GetConfigData() -- Save
    room_sound_seismicPings = {
      pings = pings
    }
    return "room_sound_seismicPings", room_sound_seismicPings
  end


  local function SetConfigData(data) -- Load
    if data.room_sound_seismicPings then
      pings = data.room_sound_seismicPings.pings
    end
    seismicPings.lineArray[1] = PingText()
  end

  local function playSound(filename, ...)
    local path = SOUND_DIRNAME..filename
    if (VFS.FileExists(path)) then
      Spring.PlaySoundFile(path, ...)
    else
      Spring.Echo("Error: file "..path.." doest not exist.")
    end
  end

  
  local function OnSeismicPing(x, y, z, strength)
    local volume
    if (pings == 1) then
      playSound(PING_FILENAME, strength, x, y, z)
    elseif (pings == 2) then
      playSound(PING_FILENAME, strength)
    end
  end

  
  seismicPings = Window:Create{
    group = "ingameMenu",
    closed = true,
    lineArray = {"Seismic pings can be heard from anywhere."},
    OnSeismicPing = OnSeismicPing,
    tabs = {
      {title = "Unit Reply Sounds"},
      {preset = Tab:Close()},
      {preset = Tab:Back{previousWindow = "soundOptions"}},
      {title = "Off",
        position = "left",
        OnClick = function()
          pings = nil
          seismicPings.lineArray[1] = PingText()
        end,
      },
      {title = "Positional",
        position = "left",
        OnClick = function()
          pings = 1
          seismicPings.lineArray[1] = PingText()
        end,
      },
      {title = "Global",
        position = "left",
        OnClick = function()
          pings = 2
          seismicPings.lineArray[1] = PingText()
        end,
      },
    }
  }
  
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

