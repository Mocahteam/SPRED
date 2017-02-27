function widget:GetInfo()
  return {
    name      = "Show PP Video",
    desc      = "Show the Prog&Play video at the beginning of the mission",
    author    = "muratet",
    date      = "Feb 21, 2017",
    license   = "GPL v2 or later",
    layer     = 220,
    enabled   = false
  }
end

local started = false

function widget:GameStart()
	if Script.LuaUI.ToggleHelpButton then
		-- we want to hide help button during video playing
		Script.LuaUI.ToggleHelpButton() -- registered by pp_show_feedback.lua
	end
end

function widget:Update(dt)
	if not started then
		-- The runner manages widgets for the mission played in GamePreload and so we have to launch video after GamePreload if this widget is already turn on. We can't try to launch video in GameStart to avoid flickering artifact. The last choice is to to this in Update callin because the first call of Update callin occurs after GamePreload and before GameStart
		if Script.LuaUI("PlayVideo") then
		  Script.LuaUI.PlayVideo() -- function defined and registered in pp_gui_main_menu widget
		end
		started = true
	end
end
