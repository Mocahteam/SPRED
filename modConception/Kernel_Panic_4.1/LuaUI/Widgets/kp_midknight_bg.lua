
function widget:GetInfo()
  return {
    name      = "Kernel Panic MidKnight's tooltip background",
    desc      = "Prettier background for the tooltip",
    author    = "MidKnight",
    date      = "August 22, 2009",
    license   = "Free",
    layer     = 0,
    enabled   = true
  }
end

function widget:Initialize()
  WG.MidKnightBG=true
end

function widget:GameStart()
  WG.MidKnightBG=true
end

function widget:Shutdown()
  WG.MidKnightBG=nil
end
