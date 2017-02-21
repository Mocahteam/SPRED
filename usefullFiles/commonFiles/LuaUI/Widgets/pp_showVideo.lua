function widget:GetInfo()
  return {
    name      = "Show PP Video",
    desc      = "Show the Prog&Play video at the beginning of the mission",
    author    = "muratet",
    date      = "Feb 21, 2017",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = false
  }
end

function widget:Initialize()
	if Script.LuaUI("PlayVideo") then
      Script.LuaUI.PlayVideo() -- function defined and registered in pp_gui_main_menu widget
    end
end
