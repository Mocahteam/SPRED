-- $Id: room_ingameMenu.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Complete Annihilation in-game menu interface.
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


local GetConfigInt    = Spring.GetConfigInt
local GetConfigString = Spring.GetConfigString
local SetConfigInt    = Spring.SetConfigInt
local SetConfigString = Spring.SetConfigString
local Window          = Window
local Tab             = Tab

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Constants
--


local testString = red..[[
Click on the window and drag to move it.]]..cyan..[[ Lets see word wrapping and 
colored text.]]..magenta..[[ If you close this window, type "/luaui reload" to 
open it again.]]..white..[[ Lua is an extension programming language designed to
support general procedural programming with data description facilities.
]]..green..[[ It also offers good support for object-oriented programming, 
functional programming, and data-driven programming.]]..red..[[ Lua is intended 
to be used as a powerful, light-weight scripting language for any program that 
needs one.]]..yellow..[[ Lua is implemented as a library, written in clean C 
(that is, in the common subset of ANSI C and C++).
]]


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Main Menu
--


local function MakeLogo()
  local r = math.random(1, 10) 
  return ROOM_DIRNAME.."/Logos/"..r..".png"
end


mainMenu = Window:Create{
  group = "ingameMenu",
  x1 = 300,
  x2 = 600,
  y1 = 300,
  y2 = 600,
  closed = true,
  backGroundTextureString = MakeLogo(),
  tabs = {
    {title = white.."Complete Annihilation Main Menu"},
    {preset = Tab:Close()},
    {preset = Tab:Goto{title="Display Options", destination="displayMenu",}},
    {title = "Unit Information",
     position = "left",
     OnMouseReleaseAction = function()
      MakeInfoWindow()
      mainMenu:Close()
     end},
    {preset = Tab:Goto{title="Storyline", destination="storyLine1",}},
    {preset = Tab:Goto{title="Help Options", destination="helpMessageOptions"}},
    {preset = Tab:Goto{title="Keyboard Reference", destination="keyboardRef"}},
    {preset = Tab:Goto{title="Reminder Options", destination="reminderOptions"}},
    {preset = Tab:Goto{title="Sound Options", destination="soundOptions"}},
  }
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Display Menu and Sub-menus
--


-- Display Menu ----------------------------------------------------------------


displayMenu = Window:Create{
  group = "ingameMenu",
  closed = true,
  tabs = {
    {title = white.."Display Options"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "mainMenu"}},
    {preset =
      Tab:Goto{title="GUI Lines Anti-Aliasing",  destination="smoothLines"}},
    {preset =
      Tab:Goto{title="GUI Points Anti-Aliasing", destination="smoothPoints"}},
    {preset =
      Tab:Goto{title="Team Nanospray Color",     destination="teamNanospray"}},
    {preset =
      Tab:Goto{title="Advanced Unit Shading",    destination="advUnitShading"}},
    {preset =
      Tab:Goto{title="Water Detail",             destination="waterDetail"}},
    {preset =
      Tab:Goto{title="Shadow Detail",            destination="shadowDetail"}},
    {preset =
      Tab:Goto{title="Maximum Particles",        destination="maxParticles"}},
    {preset =
      Tab:Goto{title="Frame Rate Manager",       destination="managerOptions"}},
    {preset =
      Tab:Goto{title="Command Display",          destination="commandsWindow"}},
    {preset =
      Tab:Goto{title="Build Menu",               destination="buildMenu"}},
    {preset =
      Tab:Goto{title="Cursors",                  destination="cursors"}},
    {preset =
      Tab:Goto{title="Minimap Colors",           destination="minimapColors"}},
    {preset =
      Tab:Goto{title="DPS display",           destination="dpsDisplay"}},
      
  }
}


-- GUI Lines Anti-Aliansing Options Dialog -------------------------------------


smoothLines = Window:Create{
  group = "ingameMenu",
  closed = true,
  lineArray = {
                "Current setting is: "..GetConfigInt("smoothLines")..".",
                red.."Requires restart to take effect."..white,
              },
  tabs = {
    {title = "GUI Lines Anti-Aliansing Options"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {preset = Tab:SetConfigInt{title  = "Set to 0 (off)",
                               config = "smoothLines",
                               int    = 0}},
    {preset = Tab:SetConfigInt{title  = "Set to 1 (fastest)",
                               config = "smoothLines",
                               int    = 1}},
    {preset = Tab:SetConfigInt{title  = "Set to 2 (don't care)",
                               config = "smoothLines",
                               int    = 2}},
    {preset = Tab:SetConfigInt{title  = "Set to 3 (nicest)",
                               config = "smoothLines",
                               int    = 3}},
  }
}


-- GUI Points Anti-Aliansing Options Dialog ------------------------------------


smoothPoints = Window:Create{
  group = "ingameMenu",
  closed = true,
  lineArray = {
                "Current setting is: "..GetConfigInt("smoothPoints")..".",
                red.."Requires restart to take effect."..white,
                "With 0, points appear as squares.",
                "With 1 to 3, points appear as discs.",
              },
  tabs = {
    {title = "GUI Points Anti-Aliansing Options"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {preset = Tab:SetConfigInt{title  = "Set to 0 (off)",
                               config = "smoothPoints",
                               int    = 0}},
    {preset = Tab:SetConfigInt{title  = "Set to 1 (fastest)",
                               config = "smoothPoints",
                               int    = 1}},
    {preset = Tab:SetConfigInt{title  = "Set to 2 (don't care)",
                               config = "smoothPoints",
                               int    = 2}},
    {preset = Tab:SetConfigInt{title  = "Set to 3 (nicest)",
                               config = "smoothPoints",
                               int    = 3}},
  }
}


-- Team Nanospray Color Dialog -------------------------------------------------


local function teamNanosprayText()
  local status
  local s = GetConfigInt("TeamNanospray")
  if (s < 1) then
    status = "disabled"
  else
    status = "enabled"
  end
  return "Team nanospray color is "..status.."."
end


teamNanospray = Window:Create{
  group = "ingameMenu",
  lineArray = {teamNanosprayText(), 
               red.."Requires restart to take effect."..white},
  closed = true,
  tabs = {
    {title = white.."Team Nanospray Color Dialog"},
    {preset = Tab:ConfigEnable{config = "teamNanospray"}},
    {preset = Tab:ConfigDisable{config = "teamNanospray"}},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
  }
}


-- 3D Trees Dialog -------------------------------------------------------------


--[[ -- Redundant: already in settings.exe.

local function threeDTreesText()
  local status
  local s = GetConfigInt("teamNanospray")
  if (s < 1) then
    status = "disabled"
  else
    status = "enabled"
  end
  return "3D trees are "..status.."."
end


threeDTrees = Window:Create{
  group = "ingameMenu",
  lineArray = {threeDTreesText(), red.."Restart required to take effect."},
  closed = true,
  tabs = {
    {title = white.."3D Trees Dialog"},
    {preset = Tab:ConfigEnable{config = "3DTrees"}},
    {preset = Tab:ConfigDisable{config = "3DTrees"}},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
  }
}


-- High detail sky Dialog ------------------------------------------------------


local function advSkyText()
  local status
  local s = GetConfigInt("advSky")
  if (s < 1) then
    status = "disabled"
  else
    status = "enabled"
  end
  return "High detail sky is "..status.."."
end


advSky = Window:Create{
  group = "ingameMenu",
  lineArray = {advSkyText(), red.."Restart required to take effect."},
  closed = true,
  tabs = {
    {title = white.."High detail sky Dialog"},
    {preset = Tab:ConfigEnable{config = "advSky"}},
    {preset = Tab:ConfigDisable{config = "advSky"}},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
  }
}


-- Dual Screen Mode ------------------------------------------------------------


local function dualScreenModeText()
  local status
  local s = GetConfigInt("dualScreenMode")
  if (s < 1) then
    status = "disabled"
  else
    status = "enabled"
  end
  return "Dual screen mode is "..status.."."
end


dualScreenMode = Window:Create{
  group = "ingameMenu",
  lineArray = {dualScreenModeText(), red.."Restart required to take effect."},
  closed = true,
  tabs = {
    {title = white.."Dual Screen Mode Dialog"},
    {preset = Tab:ConfigEnable{config = "dualScreenMode"}},
    {preset = Tab:ConfigDisable{config = "dualScreenMode"}},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
  }
}


-- Dual Screen Minimap Side ----------------------------------------------------


local function dualScreenSideText()
  local status
  local s = GetConfigInt("DualScreenMiniMapOnLeft")
  if (s < 1) then
    status = "right"
  else
    status = "left"
  end
  return "Minimap is on the "..status.." in dual screen mode."
end


dualScreenSide = Window:Create{
  group = "ingameMenu",
  lineArray = {dualScreenSideText(), red.."Restart required to take effect"},
  closed = true,
  tabs = {
    {preset = Tab:SetConfigInt{title  = white.."Minimap on left",
                               config = "DualScreenMiniMapOnLeft",
                               int    = 1,
                               text   = "Minimap is on the left in "..
                                 "dual screen mode."}},
    {preset = Tab:SetConfigInt{title  = "Minimap on right",
                               config = "DualScreenMiniMapOnLeft",
                               int    = 0,
                               text   = "Minimap is on the right in "..
                                 "dual screen mode."}},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
  }
}

--]]


-- Advanced Unit Shading -------------------------------------------------------


local function advUnitShadingText()
  local status
  local s = GetConfigInt("AdvUnitShading")
  if (s < 1) then
    status = "disabled"
  else
    status = "enabled"
  end
  return "Advanced unit shading is "..status.."."
end


advUnitShading = Window:Create{
  group = "ingameMenu",
  closed = true,
  lineArray = {advUnitShadingText(),
               'It is also known as "shiny units"',
               'or "reflective units".'},
  tabs = {
    {title = "Advanced Unit Shading"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {title = "Enable",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"advshading 1"}
        SetConfigInt("advUnitShading", 1)
        advUnitShading.lineArray[1] = advUnitShadingText() -- lineArray changes
      end                                                  -- take effect
    },                                                     -- immediately. 
    {title = "Disable",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"advshading 0"}
        SetConfigInt("advUnitShading", 0)
        advUnitShading.lineArray[1] = advUnitShadingText()
      end
    },
  }
}


-- Water Detail ----------------------------------------------------------------


local function waterText()
  local status
  local s = GetConfigInt("ReflectiveWater")
  if (s < 1) then
    status = "basic"
  elseif (s < 2) then
    status = "reflective"
  elseif (s < 3) then
    status = "dynamic"
  elseif (s < 4) then
    status = "bumpmapped"
  else
    status = "reflective and refractive"
  end
  return "The water surface is "..status.."."
end


waterDetail = Window:Create{
  group = "ingameMenu",
  closed = true,
  lineArray = {waterText(),
               red..'On computers with old video cards, dynamic',
               'water can severely impair performance.'},
  tabs = {
    {title = white.."Water Detail"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {title = "Basic Water",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"water 0"}
        SetConfigInt("ReflectiveWater", 0)
        waterDetail.lineArray[1] = waterText()
      end
    },
    {title = "Reflective Water",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"water 1"}
        SetConfigInt("ReflectiveWater", 1)
        waterDetail.lineArray[1] = waterText()
      end
    },
    {title = "Reflective and Refractive Water",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"water 3"}
        SetConfigInt("ReflectiveWater", 3)
        waterDetail.lineArray[1] = waterText()
      end
    },
    {title = "Dynamic Water",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"water 2"}
        SetConfigInt("ReflectiveWater", 2)
        waterDetail.lineArray[1] = waterText()
      end
    },
    {title = "Bumpmapped Water",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"water 4"}
        SetConfigInt("ReflectiveWater", 4)
        waterDetail.lineArray[1] = waterText()
      end
    },
  }
}


-- Shadow Detail ---------------------------------------------------------------


local function shadowDetailText()
  local status
  local s = GetConfigInt("Shadows")
  local t = GetConfigInt("ShadowMapSize")
  if (s < 1) then
    status = "Shadows are disabled.   "
  elseif (t < 2048) then
    status = "Shadow detail is low.   "
  elseif (t < 4096) then
    status = "Shadow detail is medium."
  else
    status = "Shadow detail is high.  "
  end
  return status
end


shadowDetail = Window:Create{
  group = "ingameMenu",
  closed = true,
  text = shadowDetailText(),
  tabs = {
    {title = "Shadow Detail"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {title = "Disable Shadows",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"Shadows 0"}
        SetConfigInt("Shadows", 0)
        shadowDetail.lineArray[1] = shadowDetailText()
      end
    },
    {title = "Low Detail Shadows",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"shadows 1 1024"}
        SetConfigInt("Shadows", 1)
        SetConfigInt("ShadowMapSize", 1024)
        shadowDetail.lineArray[1] = shadowDetailText()
      end
    },
    {title = "Medium Detail Shadows",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"shadows 1 2048"}
        SetConfigInt("Shadows", 1)
        SetConfigInt("ShadowMapSize", 2048)
        shadowDetail.lineArray[1] = shadowDetailText()
      end
    },
    {title = "High Detail Shadows",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"shadows 1 4096"}
        SetConfigInt("Shadows", 1)
        SetConfigInt("ShadowMapSize", 4096)
        shadowDetail.lineArray[1] = shadowDetailText()
      end
    },
  }
}


-- Maximum Particles -----------------------------------------------------------


local function MaxParticlesText()
  local n = GetConfigInt("MaxParticles")
  return "At most, "..n.." particles are displayed on-screen."
end


maxParticles = Window:Create{
  group = "ingameMenu",
  closed = true,
  lineArray = {MaxParticlesText()},
  tabs = {
    {title = "Maximum Particles"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {title = "1000",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"maxparticles 1000"}
        SetConfigInt("MaxParticles", 1000)
        maxParticles.lineArray[1] = MaxParticlesText()
        maxParticles:UpdateDisplayList()
      end
    },
    {title = "5000",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"maxparticles 5000"}
        SetConfigInt("MaxParticles", 5000)
        maxParticles.lineArray[1] = MaxParticlesText()
        maxParticles:UpdateDisplayList()
      end
    },
    {title = "10000",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"maxparticles 10000"}
        SetConfigInt("MaxParticles", 10000)
        maxParticles.lineArray[1] = MaxParticlesText()
        maxParticles:UpdateDisplayList()
      end
    },
    {title = "20000",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"maxparticles 20000"}
        SetConfigInt("MaxParticles", 20000)
        maxParticles.lineArray[1] = MaxParticlesText()
        maxParticles:UpdateDisplayList()
      end
    },
    {title = "40000",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"maxparticles 40000"}
        SetConfigInt("MaxParticles", 40000)
        maxParticles.lineArray[1] = MaxParticlesText()
        maxParticles:UpdateDisplayList()
      end
    },
  }
}



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Storyline 
--

-- FIXME: use scrolling


-- The "text" parameter, which word wraps, isn't used as it doesn't support 
-- newlines (yet).

local storyLineString1 = {
"Long ago, the galaxy had known peace.",
"",
"Paradise was ruled with the hand of",
"science, and the hand was that of the",
"galactic governing body known as the",
"Core.",
"",
"Ironically, it was the Core's ultimate",
"victory, the victory over death itself,",
"that brought about the downfall of its",
"paradise and started the war that would",
"decimate a million worlds.",
"",
"The immortality process, known as",
'"patterning," involved the electronic',
"duplication of brain matrices, allowing",
"the transfer of consciousness into",
"durable machines. Effectively it meant",
"immortality, and the Core decreed the",
"process mandatory for all citizens in",
"order to ensure their safety.",
}


local storyLineString2 = {
"However, there were many citizens",
"unwilling to toss aside their bodies so",
"casually, many indeed who regarded",
"patterning as an atrocity. They fled to",
"the outer edges of the galaxy, forming a",
"resistance movement that became known as",
"the Arm. War began, though it was never",
"officially declared by either side.",
"",
"The Arm developed high-powered combat",
"suits for its armies, while the Core",
"transferred the minds of its soldiers",
"directly into similarly deadly machines.",
"The Core duplicated its finest warriors",
"thousands of times over. The Arm",
"countered with a massive cloning",
"program. The war raged on for more than",
"4,000 years, consuming the resources of",
"an entire galaxy and leaving it a",
"scorched wasteland.",
"",
"Both sides lay in ruins. Their",
"civilizations had long since vanished,",
"their once vast military complexes were",
"smashed. Their armies were reduced to a",
"few scattered remnants that continued to",
"battle on ravaged worlds. Their hatred",
"fueled by millenia of conflict, they",
"would fight to the death. For each, the",
"only acceptable outcome was the complete",
"annihilation of the other.",
}


storyLine1 = Window:Create{
  group = "storyLine",
  lineArray = storyLineString1,
  closed = true,
  tabs = {
    {title = "Storyline"},
    {title = "Close",
      position = "right",
      OnMouseReleaseAction = function()
        -- storyLine1.noAnimation = nil
        -- storyLine2.noAnimation = nil
        storyLine1:Close()
        mainButton:Open()
      end,
    },
    {title = "Back",
      position = "right",
      OnMouseReleaseAction = function()
        -- storyLine1.noAnimation = nil
        -- storyLine2.noAnimation = nil
        storyLine1:Close()
        mainMenu:Open()
      end,
    },
    {title = "Next Page", 
      position = "bottom",
      OnMousePressAction = function()
        -- storyLine1.noAnimation = true
        -- storyLine2.noAnimation = true
        return true
      end,
      OnMouseReleaseAction = function()
        storyLine1:Close()
        storyLine2:Open()
      end},
    {title = "Page 1", position = "bottom"},
  }
}


storyLine2 = Window:Create{
  group = "storyLine",
  lineArray = storyLineString2,
  closed = true,
  tabs = {
    {title = "Storyline"},
    {title = "Close",
      position = "right",
      OnMouseReleaseAction = function()
        -- storyLine1.noAnimation = nil
        -- storyLine2.noAnimation = nil
        storyLine2:Close()
        mainButton:Open()
      end,
    },
    {title = "Back",
      position = "right",
      OnMouseReleaseAction = function()
        -- storyLine1.noAnimation = nil
        -- storyLine2.noAnimation = nil
        storyLine2:Close()
        mainMenu:Open()
      end,
    },
    {title = "Previous Page",      
      position = "bottom",
      OnMousePressAction = function()
        return true
      end,
      OnMouseReleaseAction = function()
        storyLine2:Close()
        storyLine1:Open()
      end},
    {title = "Page 2", position = "bottom"},
  }
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Main Menu Link Button
--


mainButton = Window:Create{
  x1 = 700,
  y1 = 100,
  textWidth = 300,
  lineArray = {"Main Menu"},
  useOnIsAbove = true,
  OnMousePressAction = function()
    mainButton.timeFromMousePress = MakeTimer()
    return true
  end,
  OnMouseReleaseAction = function()
    if (mainButton.timeFromMousePress() < 0.2) then -- Ignores press/realease    
      mainButton:Close()                            -- couples intended to drag 
      mainMenu:Open()                               -- the window, not click.
    end
    mainButton.timeFromMousePress = nil
  end,
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Minimap Colors
--


minimapColors = Window:Create{
  group = "ingameMenu",
  closed = true,
  tabs = {
    {title = "Minimap Colors"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {title = "Simple Colors",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"minimap simplecolors 1"}
        SetConfigInt("SimpleMiniMapColors", 1)
      end                                                  
    },                                                     
    {title = "Team Colors",
      position = "left",
      OnMouseReleaseAction = function()
        Spring.SendCommands{"minimap simplecolors 0"}
        SetConfigInt("SimpleMiniMapColors", 0)
      end
    },
  }
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Build Menu
--


buildMenu = Window:Create{
  group = "ingameMenu",
  lineArray = {
                "The first option let you switch between",
                red.."c"..yellow.."o"..green.."l"..blue.."o"..cyan.."r"..magenta.."i"..red.."z"..green.."e"..yellow.."d"..white.." and "..grey.."b"..white.."&w icons.",
                "The second one let you hide command",
                "buttons, which are accesible throught",
                "keyboard shortcuts (for experienced",
                "players).",
              },
  closed = true,
  tabs = {
    {title = "Build Menu Settings"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {title = "Black and White",
      position = "left",
      OnMouseReleaseAction = function()
        WG.Layout.colorized = false
        Spring.ForceLayoutUpdate()
      end
    },
    {title = "Colorized",
      position = "left",
      OnMouseReleaseAction = function()
        WG.Layout.colorized = true
        Spring.ForceLayoutUpdate()
      end
    },
    {title = "",
      position = "left",
      OnMouseReleaseAction = function()
      end
    },
    {title = "Normal",
      position = "left",
      OnMouseReleaseAction = function()
        WG.Layout.minimal = false
        Spring.ForceLayoutUpdate()
      end
    },
    {title = "Minimal",
      position = "left",
      OnMouseReleaseAction = function()
        WG.Layout.minimal = true
        Spring.ForceLayoutUpdate()
      end
    },
  }
}



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- DPS display
dpsDisplay = Window:Create{
  group = "ingameMenu",
  lineArray = {"Displays damage caused by weapons."},
  closed = true,
  tabs = {
    {title = "DPS display settings"},
    {preset = Tab:Close()},
    {preset = Tab:Back{previousWindow = "displayMenu"}},
    {title = "Toggle DPS display",
      position = "left",
      OnClick = function()
        Spring.SendCommands({"luaui togglewidget Display DPS"})
      end,
    },
  }
}

