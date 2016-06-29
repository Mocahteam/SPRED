function widget:GetInfo()
  return {
    name      = "Widget Informer",
    desc      = "Used to inform about states of widgets by setting a ConfigString (see Spring.SetConfigString())",
    author    = "meresse",
    date      = "Jun 20, 2016",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true,
	handler   = true
  }
end

local savedActiveStates = {}
local widgets = {"Feedbacks Widget"}

function informAboutWidget(name)
	for _,e in pairs(widgets) do
		if e == name then
			return true
		end
	end
	return false
end

function widget:Update()
	for name,data in pairs(widgetHandler.knownWidgets) do
		if savedActiveStates[name] ~= nil and savedActiveStates[name] ~= data.active then
			if savedActiveStates[name] then 
				Spring.Echo(name.." was enabled and is now disabled")
			else
				Spring.Echo(name.." was disabled and is now enabled")
			end
			if informAboutWidget(name) then
				local value = ""
				if data.active then
					value = "enabled"
				else
					value = "disabled"
				end
				Spring.SetConfigString(name, value, 1)
			end
			savedActiveStates[name] = data.active
		end
	end
end

function widget:Initialize()
	for name,data in pairs(widgetHandler.knownWidgets) do
		savedActiveStates[name] = data.active
	end
end

function widget:Shutdown()

end
