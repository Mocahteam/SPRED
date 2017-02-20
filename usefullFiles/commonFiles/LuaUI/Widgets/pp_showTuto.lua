function widget:GetInfo()
  return {
    name      = "Show PP Tuto",
    desc      = "Show the Prog&Play tutorial based on KernelPanic mod and MarbleMasdness map",
    author    = "muratet",
    date      = "Feb 20, 2017",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = false
  }
end

function widget:Initialize()
	if Script.LuaUI("TutorialEvent") then
      Script.LuaUI.TutorialEvent() -- function defined and registered in pp_gui_main_menu widget
    end
end
