function widget:GetInfo()
  return {
    name = "Widget Activator",
    desc = "Activate or Deactivate Widgets",
    author = "zigaroula,martinb",
    version = "0.1",
    date = "May 17, 2016",
    license = "Public Domain",
    layer = 250,
    enabled = true,
    handler = true
  }
end

function changeWidgetState(widgetName,activation) -- Disable other widgets
  Spring.Echo("we tryyyyyyyyyyy")
  if(widgetHandler.knownWidgets[widgetName]~=nil)then
    local w=widgetHandler.knownWidgets[widgetName]
    if w.active and activation then
      Spring.Echo("disable this widget")
      Spring.Echo(widgetName)
      widgetHandler:DisableWidget(widgetName)
    elseif not w.active and not activation then
      Spring.Echo("enable this widget")
      Spring.Echo(widgetName)
      widgetHandler:EnableWidget(widgetName)
    end
  end
end

function widget:Initialize()
  widgetHandler:RegisterGlobal("changeWidgetState", changeWidgetState)
end

function widget:Shutdown()
  widgetHandler:DeregisterGlobal("changeWidgetState")
end