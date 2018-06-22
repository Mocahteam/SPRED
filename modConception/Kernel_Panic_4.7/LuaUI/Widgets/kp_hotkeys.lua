--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  File: kp_hotkeys.lua
--  Brief:  Make it easier to place sockets/windows
--  Author:  zwzsg
--
--  License:  Free to do anything with it.
--
--  Changelog:
--    zwzsg:   Initial version
--    KDR_11k: Added Network faction
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Kernel Panic Hotkeys",
    desc      = "Hotkeys placing sockets/windows to double pression on keypad 2,4,6,8",
    author    = "zwzsg",
    date      = "January 11, 2008",
    license   = "Free",
    layer     = 0,
    enabled   = true  -- loaded by default
  }
end

--------------------------------------------------------------------------------

function widget:Initialize()
  Spring.SendCommands({"bind numpad2 buildfacing south"})
  Spring.SendCommands({"bind numpad4 buildfacing west"})
  Spring.SendCommands({"bind numpad6 buildfacing east"})
  Spring.SendCommands({"bind numpad8 buildfacing north"})
  Spring.SendCommands({"bind numpad2 buildunit_socket"})
  Spring.SendCommands({"bind numpad4 buildunit_socket"})
  Spring.SendCommands({"bind numpad6 buildunit_socket"})
  Spring.SendCommands({"bind numpad8 buildunit_socket"})
  Spring.SendCommands({"bind numpad2 buildunit_window"})
  Spring.SendCommands({"bind numpad4 buildunit_window"})
  Spring.SendCommands({"bind numpad6 buildunit_window"})
  Spring.SendCommands({"bind numpad8 buildunit_window"})
  Spring.SendCommands({"bind numpad2 buildunit_windowold"})
  Spring.SendCommands({"bind numpad4 buildunit_windowold"})
  Spring.SendCommands({"bind numpad6 buildunit_windowold"})
  Spring.SendCommands({"bind numpad8 buildunit_windowold"})
  Spring.SendCommands({"bind numpad2 buildunit_port"})
  Spring.SendCommands({"bind numpad4 buildunit_port"})
  Spring.SendCommands({"bind numpad6 buildunit_port"})
  Spring.SendCommands({"bind numpad8 buildunit_port"})
  Spring.SendCommands({"bind numpad2 buildunit_thminifac"})
  Spring.SendCommands({"bind numpad4 buildunit_thminifac"})
  Spring.SendCommands({"bind numpad6 buildunit_thminifac"})
  Spring.SendCommands({"bind numpad8 buildunit_thminifac"})
  Spring.SendCommands({"bind d dgun"})
  Spring.SendCommands({"bind Shift+d dgun queued"})
  Spring.SendCommands({"bind d deploy"})
  Spring.SendCommands({"bind Shift+d deploy queued"})
  Spring.SendCommands({"bind u undeploy"})
  Spring.SendCommands({"bind Shift+u undeploy queued"})
  Spring.SendCommands({"bind d launchmines"})
  Spring.SendCommands({"bind Shift+d launchmines queued"})
  Spring.SendCommands({"bind d dispatch"})
  Spring.SendCommands({"bind e enter"})
  Spring.SendCommands({"bind down hero_south"})
  Spring.SendCommands({"bind up hero_north"})
  Spring.SendCommands({"bind left hero_west"})
  Spring.SendCommands({"bind right hero_east"})
  widgetHandler:RemoveWidget()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

