function widget:GetInfo()
  return {
    name      = "PP Widget Informer",
    desc      = "Used to inform about states of widgets by setting a ConfigString (see Spring.SetConfigString())",
    author    = "meresse, mocahteam",
    date      = "Jun 20, 2016",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true,
	handler   = true
  }
end

local savedActiveStates = {}

function widget:Update()
	for name,data in pairs(widgetHandler.knownWidgets) do
		if savedActiveStates[name] ~= nil and savedActiveStates[name] ~= data.active then
			if savedActiveStates[name] then 
				Spring.Echo(name.." was enabled and is now disabled")
			else
				Spring.Echo(name.." was disabled and is now enabled")
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
