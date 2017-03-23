--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  File:   kp_buildbar.lua
--  Brief:   Add on the right part of the screen a permanent buildbar
--           that let yo keep an eye, and control, your kernel/hole.
--  Authors:  jK, then edited by zwzsg
--
--  License:  GNU GPL, v2 or later
--
--  Changelog:
--    zwzsg: - hidden if IsGUIHidden
--    zwzsg: - changed tooltip to be printed exactly like Spring default,
--             so that the kp_tooltip.lua widget handles it
--    zwzsg: - added firewall and terminal countdown
--    zwzsg: - not storing/reloading settings from regkeys anymore
--    zwzsg: - Do not show a white square when on repeat
--           - Skip factories that can only build one thing
--           - Do not show Energy & Metal on tooltip
--           - bar_offset now in screen ratio, not in pixels, and not mouse tweakable anymore
--           - settings are stored in different register keys than original builbar widget
--           - Border green instead of black
--    jK:    - Initial version this one is based of
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function widget:GetInfo()
  return {
    name      = "Kernel Panic Build Bar",
    desc      = "To always keep an eye on your homebase and specials",
    author    = "jK, edited by zwzsg",
    date      = "Jul 11, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default
  }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--include("spring.h.lua")
--include("colors.h.lua")
--include("opengl.h.lua")
--include("cmdcolors.h.lua")
VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

cmdColors = {}

local f,it,isFile = nil,nil,false
f  = io.open('cmdcolors.txt','r')
if f then
  it = f:lines()
  isFile = true
else
  f  = VFS.LoadFile('cmdcolors.txt')
  it = string.gmatch(f, "%a+.-\n")
end

local wp = '%s*([^%s]+)'           -- word pattern
local cp = '^'..wp..wp..wp..wp..wp -- color pattern
local sp = '^'..wp..wp             -- single value pattern like queuedLineWidth

for line in it do
  local _, _, n, r, g, b, a = string.find(line, cp)

  r = tonumber(r or 1.0)
  g = tonumber(g or 1.0)
  b = tonumber(b or 1.0)
  a = tonumber(a or 1.0)

  if n then
    cmdColors[n]= { r, g,b,a}
  else
    _, _, n, r= string.find(line:lower(), sp)
    if n then
      cmdColors[n]= r
    end
  end
end

if isFile then f:close() end
f,it,wp,cp,sp=nil,nil,nil,nil,nil


WhiteStr   = "\255\255\255\255"
GreyStr    = "\255\210\210\210"
GreenStr   = "\255\092\255\092"
BlueStr    = "\255\170\170\255" 
YellowStr  = "\255\255\255\152"
OrangeStr  = "\255\255\190\128"
RedStr     = "\255\255\170\170"

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
--  vars
--

-- saved values and their default
local bar_side         = 1      --left<=0,top:1,right:2,bottom>=3
local bar_horizontal   = true   --if sides==top v bottom -> horizontal:=true  else-> horizontal:=false
local bar_offset       = 1    --offset, exprimed in screen ratio (i.e., bar_pos := vsx*bar_offset)
local bar_align        = -1     --aligns icons to bar_pos: center=0; left/top>0; right/bottom<0
local bar_iconSizeBase = 55

-- list and interface vars
local facs = {}
local hoveredMenu  = false
local openedMenu   = -1
local mouseIcon    = -1
local mouseSubIcon = -1
--local hoveredMenu  = false
--local openedMenu   = -1
--local pressedFactory     = 
--local pressedBuildOption = 
local waypointMode = 0   -- 0 = off; 1=lazy; 2=greedy (greedy means: you have to left click once before leaving waypoint mode and you can have units selected)

-- factory icon rectangle
local rectLeft   = 0
local rectTop    = 0
local rectRight  = 0
local rectBottom = 0

-- build options rectangle
local rectSubLeft   = 0
local rectSubTop    = 0
local rectSubRight  = 0
local rectSubBottom = 0

-- the following vars make it very easy to use the same code to render the menus, whatever side they are
-- cause we simple take topleft_startcorner and add recursivly *_inext to it to access they next icon pos
local factory_inext_x, factory_inext_y     = 0,0
local buildlist_inext_x, buildlist_inext_y = 0,0

local myTeamID = 0
local inTweak  = 0


-------------------------------------------------------------------------------
-- SCREENSIZE FUNCTIONS
-------------------------------------------------------------------------------
local iconSizeX = 55
local iconSizeY = math.floor(iconSizeX * 0.75)
local fontSize  = iconSizeY * 0.25
local borderSize= 1.5
local maxVisibleBuilds = 3

local vsx, vsy = widgetHandler:GetViewSizes()
function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY

  -- this way we have a resolution depending iconSize
  iconSizeX = math.floor(bar_iconSizeBase + ((vsx-800)/38))
  iconSizeY = math.floor(iconSizeX * 0.75)
  fontSize  = iconSizeY * 0.25  
  SetupNewScreenAlignment()
end

function widget:MouseWheel(up,value)
  -- you can resize the icons with the mousewheel
  local mx,my = Spring.GetMouseState()

  if IsAbove_(mx,my) then
    if up then
      bar_iconSizeBase = math.max(bar_iconSizeBase + 3,40)
    else
      bar_iconSizeBase = math.max(bar_iconSizeBase - 3,40)
    end

    iconSizeX = math.floor(bar_iconSizeBase+((vsx-800)/38))
    iconSizeY = math.floor(iconSizeX * 0.75)
    fontSize  = iconSizeY * 0.25  
    SetupNewScreenAlignment()

    return true
  end
  return false
end


-------------------------------------------------------------------------------
-- INITIALIZTION FUNCTIONS
-------------------------------------------------------------------------------
function widget:Initialize()
  myTeamID = Spring.GetMyTeamID()

  -- Not loading settings anymore because I had messed bar_offset (storing a float as an int) in last version
  -- bar_side         = Spring.GetConfigInt("kpbb_buildmenu_side",bar_side)
  -- bar_offset       = Spring.GetConfigInt("kpbb_buildmenu_offset",bar_offset*10000)*0.0001
  -- bar_align        = Spring.GetConfigInt("kpbb_buildmenu_align",bar_align)
  -- bar_iconSizeBase = Spring.GetConfigInt("kpbb_buildmenu_icon_size_base",bar_iconSizeBase)

  SetupNewScreenAlignment()

  UpdateFactoryList()
end


function widget:Shutdown()
  -- Not storing settings anymore because I had messed bar_offset (storing a float as an int) in last version
  -- Spring.SetConfigInt("kpbb_buildmenu_side",bar_side)
  -- Spring.SetConfigInt("kpbb_buildmenu_offset",bar_offset*10000)
  -- Spring.SetConfigInt("kpbb_buildmenu_align",bar_align)
  -- Spring.SetConfigInt("kpbb_buildmenu_icon_size_base",bar_iconSizeBase)
end


function SetupNewScreenAlignment()
  bar_horizontal = (bar_side==1)or(bar_side>2)
  if bar_side<=0 then
    factory_inext_x, factory_inext_y     = 0,-iconSizeY
    buildlist_inext_x, buildlist_inext_y = iconSizeX,0
  elseif bar_side==1 then
    factory_inext_x, factory_inext_y     = iconSizeX,0
    buildlist_inext_x, buildlist_inext_y = 0,-iconSizeY
  elseif bar_side==2 then
    factory_inext_x, factory_inext_y     = 0,-iconSizeY
    buildlist_inext_x, buildlist_inext_y = -iconSizeX,0
  else --bar_side>=3
    factory_inext_x, factory_inext_y     = iconSizeX,0
    buildlist_inext_x, buildlist_inext_y = 0,iconSizeY
  end
end



-------------------------------------------------------------------------------
-- UNIT INITIALIZTION FUNCTIONS
-------------------------------------------------------------------------------
function UpdateFactoryList()
  facs = {}
  local teamUnits = Spring.GetTeamUnits(myTeamID)
  local totalUnits = teamUnits.n
  for num = 1, totalUnits do
    local unitID = teamUnits[num]
    local unitDefID = Spring.GetUnitDefID(unitID)
    if UnitDefs[unitDefID].isFactory then
      local _, _, _, _, buildProgress = Spring.GetUnitHealth(unitID)
      if (buildProgress)and(buildProgress>=1) then
        if ((#UnitDefs[unitDefID].buildOptions)>1) then -- do not display factory that can only build one thing
          table.insert(facs,{ unitID=unitID, unitDefID=unitDefID, buildList=GetBuildList(unitDefID) })
        end
      end
    end
    if unitDefID==UnitDefNames.terminal.id or unitDefID==UnitDefNames.firewall.id then
      table.insert(facs,1,{ unitID=unitID, unitDefID=unitDefID, buildList={} })
    end
  end
end



function widget:UnitFinished(unitID, unitDefID, unitTeam)
  if (unitTeam ~= myTeamID) then
    return
  end
  if UnitDefs[unitDefID].isFactory then
    if ((#UnitDefs[unitDefID].buildOptions)>1) then -- do not display factory that can only build one thing
      table.insert(facs,1,{ unitID=unitID, unitDefID=unitDefID, buildList=GetBuildList(unitDefID) })
    end
  end
  if unitDefID==UnitDefNames.terminal.id or unitDefID==UnitDefNames.firewall.id then
    table.insert(facs,1,{ unitID=unitID, unitDefID=unitDefID, buildList={} })
  end
end

function widget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
  widget:UnitFinished(unitID, unitDefID, unitTeam)
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  if (unitTeam ~= myTeamID) then
    return
  end

  if UnitDefs[unitDefID].isFactory or unitDefID==UnitDefNames.terminal.id or unitDefID==UnitDefNames.firewall.id then
    for i,facInfo in ipairs(facs) do
      if unitID==facInfo.unitID then
        table.remove(facs,i)
        return
      end
    end
  end
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
  widget:UnitDestroyed(unitID, unitDefID, unitTeam)
end

function widget:Update()
  if myTeamID~=Spring.GetMyTeamID() then
    myTeamID = Spring.GetMyTeamID()
    UpdateFactoryList()
  end
  inTweak = widgetHandler:InTweakMode()
end



-------------------------------------------------------------------------------
-- DRAWSCREEN
-------------------------------------------------------------------------------
function widget:DrawScreen()

  if Spring.IsGUIHidden() then
    return
  end

  SetupDimensions(#facs)
  SetupSubDimensions()
  gl.Text("\255\255\255\255 ",0,0,FontSize,'o') -- Reset color to white in case other widgets changed gl.Text color

  local icon,mx,my,lb,mb,rb = -1,-1,-1,false,false,false
  if (not inTweak) then
    mx,my,lb,mb,rb = Spring.GetMouseState()
  end

  -- draw factory list
  local xmin = rectLeft
  local ymax = rectTop
  local xmax = xmin + iconSizeX 
  local ymin = ymax - iconSizeY
  for i,facInfo in ipairs(facs) do
    -- is building in progress?
    local unitBuildID = Spring.GetUnitIsBuilding(facInfo.unitID)
    if unitBuildID then
      -- draw unit icon
      DrawTexRect(xmin,ymax,xmax,ymin,"#"..Spring.GetUnitDefID(unitBuildID))
      local _, _, _, _, buildProgress = Spring.GetUnitHealth(unitBuildID)
      if buildProgress~=nil then
        DrawBuildProgress(xmin,ymax,xmax,ymin, buildProgress, { 1, 1, 1, 0.5 })
      end
    else
      -- draw factory icon
      DrawTexRect(xmin,ymax,xmax,ymin, "#"..facInfo.unitDefID)
      if facInfo.unitDefID==UnitDefNames.firewall.id or facInfo.unitDefID==UnitDefNames.terminal.id then
        local readyframe=Spring.GetUnitRulesParam(facInfo.unitID,"readyframe")
        local reloadtime=Spring.GetUnitRulesParam(facInfo.unitID,"reloadtime")
        local text="?"
        if readyframe then
          if readyframe>Spring.GetGameFrame() then
            if reloadtime then
              DrawBuildProgress(xmin,ymax,xmax,ymin, 1-(readyframe-Spring.GetGameFrame())/(32*reloadtime), { 1, 1, 1, 0.5 })
            end
            text = math.ceil((readyframe - Spring.GetGameFrame()) / 32) .. "s"
            gl.Text(text,xmin+(xmax-xmin)/4,ymin+(ymax-ymin)/6,(ymax-ymin)/3,'o')
          else
            text="Ready!"
            gl.Text(text,xmin+(xmax-xmin)/6,ymin+(ymax-ymin)/4,(ymax-ymin)/4,'o')
          end
        end
      end
    end

    -- loop status?
    local ustate = Spring.GetUnitStates(facInfo.unitID)
    if ustate and ustate["repeat"] then
      -- DrawTexRect(xmax-24,ymax,xmax,ymax-24, "LuaUI/Images/repeat.png")
    end

    -- hover or pressed?
    if IsInRect(mx,my, xmin+1,ymax-1,xmax,ymin) then
      if (lb or mb or rb) then
        DrawRect(xmin,ymax,xmax,ymin, { 0, 0, 0, 0.35 })  -- pressed
      else
        DrawRect(xmin,ymax,xmax,ymin, { 1, 1, 1, 0.35 })  -- hover
      end
    end

    -- draw border
    if (waypointMode>1 and i==mouseIcon+1) then
      DrawRect(xmin,ymax,xmax,ymin, { 0.4, 0.4, 1, 0.45 })
      DrawLineRect(xmin,ymax,xmax,ymin, { 0, 0.8, 0, 1 },borderSize+2)
    elseif (i==openedMenu+1) then
      DrawRect(xmin,ymax,xmax,ymin, { 1, 1, 1, 0.35 })
      DrawLineRect(xmin,ymax,xmax,ymin, { 0, 0.8, 0, 1 },borderSize+2)
    else
      DrawLineRect(xmin,ymax,xmax,ymin, { 0, 0.8, 0, 1 })
    end


    -- draw build list
    if i==openedMenu+1 then
      -- draw buildoptions
      local xmin_ = xmin  + buildlist_inext_x
      local ymax_ = ymax  + buildlist_inext_y
      local xmax_ = xmin_ + iconSizeX 
      local ymin_ = ymax_ - iconSizeY

      local buildList   = facInfo.buildList
      local buildQueue  = GetBuildQueue(facInfo.unitID)
      local unitBuildID = Spring.GetUnitIsBuilding(facInfo.unitID) or -1
      local unitBuildDefID = -1
      if unitBuildID>=0 then
        unitBuildDefID = Spring.GetUnitDefID(unitBuildID)
      end

      for _,unitDefID in ipairs(buildList) do
        DrawTexRect(xmin_,ymax_,xmax_,ymin_,"#"..unitDefID,0.75)

        -- is Unit == BuildUnit?
        if unitDefID==unitBuildDefID then
          local _, _, _, _, buildProgress = Spring.GetUnitHealth(unitBuildID)
          if buildProgress~=nil then
            DrawBuildProgress(xmin_,ymax_,xmax_,ymin_, buildProgress, { 1, 1, 1, 0.5 })
          end
        end

        -- amount
        if (buildQueue[unitDefID] ~= nil) then
          gl.Text( buildQueue[unitDefID] ,xmin_+2,ymin_+2,fontSize,"o")
        end

        -- hover,press?
        if IsInRect(mx,my, xmin_+1,ymax_-1,xmax_,ymin_) then
          if (lb or mb or rb) then
            DrawRect(xmin_,ymax_,xmax_,ymin_, { 0, 0, 0, 0.35 })  -- pressed
          else
            DrawRect(xmin_,ymax_,xmax_,ymin_, { 1, 1, 1, 0.35 })  -- hover
          end
        end

        -- draw border
        DrawLineRect(xmin_,ymax_,xmax_,ymin_, { 0, 0.5, 0, 1 })

        -- setup next icon pos
        xmax_, xmin_ = xmax_ + buildlist_inext_x, xmin_ + buildlist_inext_x
        ymax_, ymin_ = ymax_ + buildlist_inext_y, ymin_ + buildlist_inext_y
      end
    else
      -- draw buildqueue
      local buildQueue  = Spring.GetFullBuildQueue(facInfo.unitID,3)
      if (buildQueue ~= nil) then
        local xmin_ = xmin  + buildlist_inext_x
        local ymax_ = ymax  + buildlist_inext_y
        local xmax_ = xmin_ + iconSizeX 
        local ymin_ = ymax_ - iconSizeY

        local n,j = 1,maxVisibleBuilds
        while (buildQueue[n]) do
          local unitBuildDefID, count = next(buildQueue[n], nil)
          if (n==1) then count=count-1 end -- cause we show the actual in building unit instead of the factory icon

          if (count>0) then
            DrawTexRect(xmin_,ymax_,xmax_,ymin_,"#"..unitBuildDefID,0.55)
            if (count>1) then gl.Text( count ,xmin_+2,ymin_+2,fontSize,"o") end

            xmax_, xmin_ = xmax_ + buildlist_inext_x, xmin_ + buildlist_inext_x
            ymax_, ymin_ = ymax_ + buildlist_inext_y, ymin_ + buildlist_inext_y
            j = j-1
            if j==0 then break end
          end
          n = n+1
        end
      end
    end

    -- setup next icon pos
    xmax, xmin = xmax + factory_inext_x, xmin + factory_inext_x
    ymax, ymin = ymax + factory_inext_y, ymin + factory_inext_y
  end

  -- draw border around factory list
  -- if (#facs>0) then DrawLineRect(rectLeft,rectTop,rectRight,rectBottom, { 0, 0.5, 0, 1 },borderSize+2) end
end



function widget:DrawWorld()

  if Spring.IsGUIHidden() then
    return
  end

  -- Draw factories command lines
  if (waypointMode>1 or openedMenu>=0) and facs[mouseIcon+1]then
    local unitID
    if waypointMode>1 then
      unitID = facs[mouseIcon+1].unitID
    else
      unitID = facs[openedMenu+1].unitID
    end

    gl.LineStipple("foobar")
    gl.DepthTest(false)
    local qwidth = cmdColors["queuedlinewidth"] or 1
    gl.LineWidth(qwidth)

    local cmdqueue = Spring.GetCommandQueue(unitID)
    cmdqueue.n = nil

    local last_pos = {}
    last_pos[1],last_pos[2],last_pos[3] = Spring.GetUnitPosition(unitID)

    for _,cmd in pairs(cmdqueue) do
      local pos = {}
      if (3==#cmd.params) then
        pos = cmd.params
        pos[2],pos.n = pos[2] + 3
      elseif (cmd.id==CMD.GUARD) then
        pos[1],pos[2],pos[3] = Spring.GetUnitPosition(cmd.params[1])
      end
      cmdColor = cmdColors[CMD[cmd.id]:lower()] or {1,1,1,1}
      cmdColor[4] = cmdColor[4]+0.1
      gl.Color(cmdColor)
      gl.Shape(GL.LINES, { { v = last_pos }, { v = pos } })
      last_pos = pos
    end

    gl.LineWidth(1)
    gl.DepthTest(false)
    gl.LineStipple(false)
  end
end



-------------------------------------------------------------------------------
-- UNIT FUNCTIONS
-------------------------------------------------------------------------------
function GetBuildList(unitDefID)
  return UnitDefs[unitDefID].buildOptions
end

function GetBuildQueue(unitID)
  local result = {}
  local queue = Spring.GetFullBuildQueue(unitID)
  if (queue ~= nil) then
    for _,buildPair in ipairs(queue) do
      local udef, count = next(buildPair, nil)
      if result[udef]~=nil then
        result[udef] = result[udef] + count
      else
        result[udef] = count
      end
    end
  end
  return result
end




-------------------------------------------------------------------------------
-- DRAW FUNCTIONS
-------------------------------------------------------------------------------
function DrawRect(left,top,right,bottom, color)
  gl.Color(color)
  gl.Rect(left,top,right,bottom)
  gl.Color(1,1,1,1)
end

function DrawLineRect(left,top,right,bottom, color, width)
  gl.Color(color)
  gl.LineWidth(width or borderSize)
  left,top,right,bottom = left+0.5,top+0.5,right+0.5,bottom+0.5
  gl.Shape(GL.LINE_LOOP, {
    { v = { right ,  top    } }, { v = { left  ,  top    } },
    { v = { left  ,  bottom } }, { v = { right ,  bottom } },
  })
  gl.LineWidth(1)
  gl.Color(1,1,1,1)
end

function DrawTexRect(left,top,right,bottom, texture, alpha)
  gl.Texture(true)
  gl.Texture(texture)
  gl.Color(1,1,1,alpha or 1)
  gl.TexRect(left,bottom,right,top)
  gl.Color(1,1,1,1)
  gl.Texture(false)
end

function DrawBuildProgress(left,top,right,bottom, progress, color)
  gl.Color(color)
  local xcen = (left+right)/2
  local ycen = (top+bottom)/2

  local alpha = 360*progress
  local alpha_rad = math.rad(alpha)
  local beta_rad  = math.pi/2 - alpha_rad
  local list = {}
  table.insert(list, {v = { xcen,  ycen }})
  table.insert(list, {v = { xcen,  top }})

  local x,y
  x = (top-ycen)*math.tan(alpha_rad) + xcen
  if (alpha<90)and(x<right) then
    table.insert(list, {v = { x,  top }})   
  else
    table.insert(list, {v = { right,  top }})
    y = (right-xcen)*math.tan(beta_rad) + ycen
    if (alpha<180)and(y>bottom) then
      table.insert(list, {v = { right,  y }})
    else
      table.insert(list, {v = { right,  bottom }})
      x = (top-ycen)*math.tan(-alpha_rad) + xcen
      if (alpha<270)and(x>left) then
        table.insert(list, {v = { x,  bottom }})
      else
        table.insert(list, {v = { left,  bottom }})
        y = (right-xcen)*math.tan(-beta_rad) + ycen
        if (alpha<350)and(y<top) then
          table.insert(list, {v = { left,  y }})
        else
          table.insert(list, {v = { left,  top }})
          x = (top-ycen)*math.tan(alpha_rad) + xcen
          table.insert(list, {v = { x,  top }})
        end
      end
    end
  end

  gl.Shape(GL.TRIANGLE_FAN, list)
  gl.Color(1,1,1,1)
end



-------------------------------------------------------------------------------
-- GEOMETRIC FUNCTIONS
-------------------------------------------------------------------------------
function SetupDimensions(count)
  if bar_horizontal then --vertical (top or bottom bar)

    local width      = math.floor(iconSizeX * count)
    local half_width = 0.5 * width
    local xmid       = vsx * bar_offset

    --setup alignment of the icons to the position
    if bar_align<0 then
      xmid = xmid-half_width --expand to right
    elseif bar_align>0 then
      xmid = xmid+half_width --expand to left
    end

    if (xmid-half_width<0) then
      rectLeft = 0
      rectRight= width
    elseif (xmid+half_width>vsx) then
      rectLeft = vsx-width
      rectRight= vsx
    else
      rectLeft = math.floor(xmid - half_width)
      rectRight= rectLeft + width
    end

    if bar_side==3 then --bottom
      rectTop   = iconSizeY
      rectBottom= 0
    else --top
      rectTop   = vsy
      rectBottom= vsy-iconSizeY
    end

  else --vertical (left or right bar)

    local height      = math.floor(iconSizeY * count)
    local half_height = 0.5 * height
    local ymid        = vsy * bar_offset

    --setup alignment of the icons to the position
    if bar_align<0 then
      ymid = ymid-half_height --expand to bottom
    elseif bar_align>0 then
      ymid = ymid+half_height --expand to top
    end

    if (ymid-half_height<0) then
      rectBottom = 0
      rectTop    = height
    elseif (ymid+half_height>vsy) then
      rectBottom = vsy-height
      rectTop    = vsy
    else
      rectBottom = math.floor(ymid - half_height)
      rectTop    = rectBottom + height
    end

    if bar_side<=0 then --left
      rectLeft  = 0
      rectRight = iconSizeX
    else --right
      rectRight = vsx
      rectLeft  = vsx-iconSizeX
    end

  end
end


function SetupSubDimensions()
  if openedMenu<0 or facs[openedMenu+1]==nil then
    rectSubLeft,rectSubTop,rectSubRight,rectSubBottom=0,0,0,0
    return
  end

  local buildListn = #facs[openedMenu+1].buildList
  if bar_horizontal then --please note the factorylist is horizontal not the buildlist!!!

    rectSubLeft   = math.floor(rectLeft + iconSizeX * openedMenu)
    rectSubRight  = rectSubLeft + iconSizeX
    if bar_side==1 then --top
      rectSubTop    = vsy - iconSizeY
      rectSubBottom = rectSubTop - math.floor(iconSizeY * buildListn)
    else --bottom
      rectSubBottom = iconSizeY
      rectSubTop    = iconSizeY + math.floor(iconSizeY * buildListn)
    end

  else

    rectSubTop    = math.floor(rectTop - iconSizeY * openedMenu)
    rectSubBottom = rectSubTop - iconSizeY
    if bar_side<=0 then --left
      rectSubLeft   = iconSizeX
      rectSubRight  = iconSizeX + math.floor(iconSizeX * buildListn)
    else --right
      rectSubRight  = vsx - iconSizeX
      rectSubLeft   = rectSubRight - math.floor(iconSizeX * buildListn)
    end

  end
end


function IsInRect(left,top, rectleft,recttop,rectright,rectbottom)
  return (left >= rectleft)and(left <= rectright)and
         ( top <= recttop) and( top >= rectbottom)
end




-------------------------------------------------------------------------------
-- MOUSE PRESS FUNCTIONS
-------------------------------------------------------------------------------
function widget:MousePress(x, y, button)
  if IsAbove_(x,y) then
    mouseIcon = MouseOverIcon(x,y)
    if facs[mouseIcon+1] then
      -- Remove all units of same type from the current selection
      local UnitsSelection = Spring.GetSelectedUnits()
      Spring.SelectUnitMap({},false)
      for i,SelectedUnit in pairs(UnitsSelection) do
        if Spring.GetUnitDefID(SelectedUnit) ~= facs[mouseIcon+1].unitDefID then
          Spring.SelectUnitMap({[SelectedUnit]=true},true)
        end
      end
      -- Add unit from the buildbar to selection
      Spring.SelectUnitMap({[facs[mouseIcon+1].unitID]=true},true)
      -- If firewall or terminal then set appropriate active command
      local CmdIndex = nil
      if facs[mouseIcon+1].unitDefID == UnitDefNames.terminal.id then
        CmdIndex = Spring.GetCmdDescIndex(CMD_AIRSTRIKE)
      end
      if facs[mouseIcon+1].unitDefID == UnitDefNames.firewall.id then
        CmdIndex = Spring.GetCmdDescIndex(CMD_FIREWALL)
      end
      if CmdIndex then
        Spring.SetActiveCommand(CmdIndex)
      end
    end
    if (mouseIcon<0)and(openedMenu>=0) then
      mouseSubIcon = MouseOverSubIcon(x,y)
    end
    if waypointMode>1 then
      Spring.Echo("BuildBar: Exited greedy waypoint mode")
    end
    waypointMode = 0
  else
    --todo: close hovered
    if waypointMode>1 then
      -- greedy waypointMode
      return (button~=2) -- we allow middle click scrolling in greedy waypoint mode
    elseif (button==3) and (openedMenu>=0) and (#Spring.GetSelectedUnits()==0) then
      -- lazy waypointMode
      waypointMode = 1   -- lazy mode
      mouseIcon    = openedMenu
      return true
    end

    if waypointMode>1 then
      Spring.Echo("BuildBar: Exited greedy waypoint mode")
    end
    waypointMode = 0

    if button~=2 then
      openedMenu = -1
      hoveredMenu= false
    end
    mouseIcon    = -1
    mouseSubIcon = -1
    return false
  end
  return true
end


function widget:MouseRelease(x, y, button)
  if IsAbove_(x,y) then
    mouseIcon = MouseOverIcon(x,y)
    if (mouseIcon<0)and(openedMenu>=0) then
      mouseSubIcon = MouseOverSubIcon(x,y)
    end
    if (mouseIcon>=0)and(waypointMode<1) then
      MenuHandler(button)
    else
      BuildHandler(button)
    end
  elseif (waypointMode>0)and(mouseIcon>=0) then
    WaypointHandler(x,y,button)
  else
    openedMenu = -1
    hoveredMenu= false
  end
  return -1
end



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function MenuHandler(button)
  if button>3 then
    return
  end

  if button==2 then
    local x,y,z = Spring.GetUnitPosition(facs[mouseIcon+1].unitID)
    Spring.SetCameraTarget(x,y,z)
    return
  end

  if button==3 then
    Spring.Echo("BuildBar: Entered greedy waypoint mode")
    waypointMode = 2 -- greedy mode
    mouseIcon    = openedMenu
    return
  end

  --if openedMenu == mouseIcon then
  --  openedMenu = -1
  --else
  --  openedMenu = mouseIcon
  --end
end


function BuildHandler(button)
  local alt, ctrl, meta, shift = Spring.GetModKeyState()
  local opt = {}
  if alt   then table.insert(opt,"alt")   end
  if ctrl  then table.insert(opt,"ctrl")  end
  if meta  then table.insert(opt,"meta")  end
  if shift then table.insert(opt,"shift") end

  if button==1 then
    Spring.GiveOrderToUnit(facs[openedMenu+1].unitID, -(facs[openedMenu+1].buildList[mouseSubIcon+1]),{},opt)
  elseif button==3 then
    table.insert(opt,"right")
    Spring.GiveOrderToUnit(facs[openedMenu+1].unitID, -(facs[openedMenu+1].buildList[mouseSubIcon+1]),{},opt)
  end
end


function WaypointHandler(x,y,button)
  if (button==1)or(button>3) then
    Spring.Echo("BuildBar: Exited greedy waypoint mode")
    hoveredMenu  = false
    openedMenu   = -1
    waypointMode = 0
    return
  end

  local alt, ctrl, meta, shift = Spring.GetModKeyState()
  local opt = {"right"}
  if alt   then table.insert(opt,"alt")   end
  if ctrl  then table.insert(opt,"ctrl")  end
  if meta  then table.insert(opt,"meta")  end
  if shift then table.insert(opt,"shift") end

--[[ doesn't work for some reason
  local cmd = nil
  if facs[mouseIcon+1].unitDefID==UnitDefNames.terminal.id then
    cmd = CMD_AIRSTRIKE
    opt = {}
  elseif facs[mouseIcon+1].unitDefID==UnitDefNames.firewall.id then
    cmd = CMD_FIREWALL
    opt = {}
  end
]]--

  local type,param = Spring.TraceScreenRay(x,y,cmd~=nil)
  if type=='ground' then
    Spring.GiveOrderToUnit(facs[mouseIcon+1].unitID, cmd or CMD.MOVE,param,opt) 
  elseif type=='unit' then
    Spring.GiveOrderToUnit(facs[mouseIcon+1].unitID, cmd or CMD.GUARD,{param},opt)     
  else --feature
    type,param = Spring.TraceScreenRay(x,y,true)
    Spring.GiveOrderToUnit(facs[mouseIcon+1].unitID, cmd or CMD.MOVE,param,opt)
  end

  --if not shift then waypointMode = 0; return true end
end


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function MouseOverIcon(x, y)
  if  (x >= rectLeft)  and (x <= rectRight)and
     (y >= rectBottom) and  (y <= rectTop)
  then
    local icon
    if bar_horizontal then
      icon = math.floor((x - rectLeft) / factory_inext_x)
    else
      icon = math.floor((y - rectTop) / factory_inext_y)
    end

    if (icon >= #facs) then
      icon = (#facs - 1)
    elseif (icon < 0) then
      icon = 0
    end

    return icon
  end
  return -1
end


function MouseOverSubIcon(x,y)
  if  (x >= rectSubLeft)  and (x <= rectSubRight)and
     (y >= rectSubBottom) and  (y <= rectSubTop)
  then
    local icon  
    if bar_side<=0 then
      icon = math.floor((x - rectSubLeft) / buildlist_inext_x)
    elseif bar_side==1 then
      icon = math.floor((y - rectSubTop) / buildlist_inext_y)
    elseif bar_side==2 then
      icon = math.floor((x - rectSubRight) / buildlist_inext_x)
    else --bar_side>=3
      icon = math.floor((y - rectSubBottom) / buildlist_inext_y)
    end

    if (facs[openedMenu+1] and icon > #facs[openedMenu+1].buildList-1) then
      icon = #facs[openedMenu+1].buildList-1
    elseif (icon < 0) then
      icon = 0
    end

    return icon
  end
  return -1
end



-------------------------------------------------------------------------------
-- HOVER FUNCTIONS
-------------------------------------------------------------------------------
function widget:GetTooltip(x,y)
  local iconNum = MouseOverIcon(x,y)
  if iconNum>=0 then
    local unitID    = facs[iconNum+1].unitID
    local unitDef   = UnitDefs[facs[iconNum+1].unitDefID]
    return unitDef.humanName .. "\n" ..
           --GreyStr .. "Left mouse: show build options\n" .. 
           --GreyStr .. "Middle mouse: set camera target\n" ..
           --GreyStr .. "Right mouse: show build options"
           GreyStr .. "mouse wheel: in-/decrease iconsize\n"
  elseif (openedMenu>=0) then
    iconNum = MouseOverSubIcon(x,y)
    if iconNum>=0 and facs[openedMenu+1] then
      local unitDef = UnitDefs[facs[openedMenu+1].buildList[iconNum+1]]
      --[[
      return unitDef.humanName .. " (" .. unitDef.tooltip .. ")\n" ..
             GreyStr .. " Build time "  .. BlueStr .. unitDef.buildTime ..
             GreyStr .. "  " .. "Health " .. RedStr .. unitDef.health
      ]]--
      --[[
      return "Build: "..unitDef.humanName.. " - "..unitDef.tooltip.."\n"..
             "Health "..unitDef.health.."\n"..
             "Metal cost "..unitDef.metalCost.."\n"..
             "Energy cost "..unitDef.energyCost.." "..
             "Build time "..unitDef.buildTime
      ]]--
      local CmdDescIndex = Spring.FindUnitCmdDesc(facs[openedMenu+1].unitID,-(facs[openedMenu+1].buildList[iconNum+1]))
      return Spring.GetUnitCmdDescs(facs[openedMenu+1].unitID)[CmdDescIndex].tooltip
    end
  end
  return ""
end

function widget:IsAbove(x,y)
  return IsAbove_(x,y)
end


function IsAbove_(x,y,dontCheckTweak)
  if Spring.IsGUIHidden() then
    return false
  end
  if (not inTweak)or(dontCheckTweak) then
    if IsInRect(x,y, rectLeft,rectTop,rectRight,rectBottom) then
      --factory icon
      if (not inTweak)and((openedMenu<0)or(hoveredMenu)) then
        hoveredMenu= true
        openedMenu = MouseOverIcon(x,y)
        if facs[openedMenu+1] and (facs[openedMenu+1].unitDefID==UnitDefNames.terminal.id or facs[openedMenu+1].unitDefID==UnitDefNames.firewall.id) then
          openedMenu = -1
        end
      else
        hoveredMenu= false
        openedMenu = -1
      end
      return true
    elseif (openedMenu>=0) and IsInRect(x,y, rectSubLeft,rectSubTop,rectSubRight,rectSubBottom) then
      --buildoption icon
      return true
    end
  end

  return false
end



-------------------------------------------------------------------------------
-- TWEAK MODE
-------------------------------------------------------------------------------
local TweakMousePressed = false
local TweakMouseMoved   = false
local TweakPressedPos_X, TweakPressedPos_Y = 0,0


function widget:TweakDrawScreen()
  local mx,my,lb,mb,rb = Spring.GetMouseState()
  if IsInRect(mx,my, rectLeft,rectTop,rectRight,rectBottom) then
    DrawRect(rectLeft,rectTop,rectRight,rectBottom, { 0, 0, 1, 0.35 })  -- hover
  else
    DrawRect(rectLeft,rectTop,rectRight,rectBottom, { 0, 0, 0, 0.45 })
    DrawRect(rectLeft,rectTop,rectRight,rectBottom, { 0, 0, 1, 0.2 })
    DrawLineRect(rectLeft,rectTop,rectRight,rectBottom, { 0, 0, 1, 0.5 })
  end
end

function widget:TweakIsAbove(x,y)
  return IsAbove_(x,y,true)
end

function widget:TweakGetTooltip(x,y)
  return 'Single Left  Click: raise\n'..
         'Single Right Click: lower\n\n'..
         'Left Click + Drag: move'
end

function widget:TweakMousePress(x, y, button)
  if (IsAbove_(x,y,true)) then
    TweakMousePressed = true
    TweakPressedPos_X, TweakPressedPos_Y = x,y
    return true
  end
  return false
end

function widget:TweakMouseRelease(x, y, button)
  TweakPressedPos_X, TweakPressedPos_Y = 0,0

  if (TweakMousePressed)and(IsAbove_(x,y,true)) then
    TweakMousePressed = false
    if not TweakMouseMoved then
      TweakMouseMoved = false
      if (button == 1) then
        widgetHandler:RaiseWidget()
        Spring.Echo("widget raised")
        return true
      elseif (button == 3) then
        widgetHandler:LowerWidget()
        Spring.Echo("widget lowered")
        return true
      end
    else
    end
  end
  TweakMousePressed = false
  TweakMouseMoved   = false
  return false
end

function widget:TweakMouseMove(x, y, dx, dy, button)
  if TweakMousePressed then
    TweakMouseMoved = true
    if bar_horizontal then
      -- bar_offset = bar_offset + dx -- now the bar_offset is not in pixel but in screen ratio, so better not add -+1 to it

      if math.abs(TweakPressedPos_Y-y)>100 then
        local bar_center = (rectRight + rectLeft)/2
        if bar_center>0.5*vsx then
          bar_side=2
        else
          bar_side=0
        end
        TweakPressedPos_X = x
        TweakPressedPos_Y = 0
        -- bar_offset = y - 0.5*vsy -- now the bar_offset is not in pixel but in screen ratio, so I don't care modifying it
        SetupNewScreenAlignment()
      end
    else
      -- bar_offset = bar_offset + dy -- now the bar_offset is not in pixel but in screen ratio, so better not add -+1 to it
      if math.abs(TweakPressedPos_X-x)>100 then
        local bar_center = (rectTop + rectBottom)/2
        if bar_center>0.5*vsy then
          bar_side=1
        else
          bar_side=3
        end
        TweakPressedPos_X = 0
        TweakPressedPos_Y = y
        -- bar_offset = x - 0.5*vsx -- now the bar_offset is not in pixel but in screen ratio, so I don't care modifying it
        SetupNewScreenAlignment()
      end
    end
  end
end

function widget:TweakMouseWheel(up,value)
  -- you can resize the icons with the mousewheel
  local mx,my = Spring.GetMouseState()

  if IsAbove_(mx,my,true) then
    if up then
      bar_align=math.min(bar_align+1,1)
    else
      bar_align=math.max(bar_align-1,-1)
    end

    return true
  end
  return false
end
