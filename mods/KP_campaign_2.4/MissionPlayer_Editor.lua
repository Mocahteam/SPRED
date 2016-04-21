------------------
-- this module play generic missions encoded in a json data format
-- @module MissionPlayer
-- ----------------

local maxHealth, tmp
local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local lang = Spring.GetModOptions()["language"] -- get the language
local jsonPartName = Spring.GetModOptions()["missionname"]
local replacements={}
replacements["gray"] = "\255\100\100\100"

local positions={}--table to store positions
local armySpring={}--table to store created spring units externalId->SpringId
local groupOfUnits={}--table to store group of units externalIdGroups-> list of externalIdUnits
local armyInformations={}--table to store information on units externalId->Informations
local messages={}--associative array messageId->message type
local conditions={}--associative array idCond->condition
local actions={}--associative array idActions->actions
local events={}--associative array idCond->event
local variables={}--associative array variable->value Need to be global so that it can be updated by using loadstring
local zones={}
local killByTeams={}

local refreshPeriod=10 -- must be between 1 and 16. The higher the less cpu involved. 
local frameIndex=0 -- related to refresh
local actionStack={} -- action to be applied on game state, allows to handle table composed by the indexes delay and actId
local success=nil -- when this global variable change (with event of type "end"), the game ends (= victory or defeat)
local outputstate=nil -- if various success or defeat states exist, outputstate can store this information. May be used later such as in AppliqManager to enable adaptative scenarisation
local canUpdate=false
local mission


local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-------------------------------------
-- Convert delay in seconds into delay in number of frames
-- @return delay in number of frames
-------------------------------------
local function secondesToFrames(delaySec)
  return delaySec*16 -- As Sync code is updated 16 times by seconds
end


-------------------------------------
-- Simple faction to get spring code given its string representation
-- @return faction code, related to factions described in txt files (such as Mission1.txt)
-------------------------------------
local function getFactionCode(factionType)
  if(factionType=="PLAYER") then
    return 0
  elseif (factionType=="ALLY") then
    return 1
  elseif (factionType=="ENNEMY") then
    return 2
  end
end

-------------------------------------
-- Return string litteral representation of a boolean 
-------------------------------------
local function boolAsString(booleanValue)
  if (booleanValue) then
    return "true"
  else
    return "false"
   end
end 

-------------------------------------
-- Get a message giving its Id.
-- If the message is not unique (a list), taking one by random
-------------------------------------
local function getAMessage(messageId) 
  local mess=messages[messageId] -- messageId can be a list
  if(mess[1]==nil) then
    return mess
  else
    return mess[math.random(#mess)]
  end
end

local function isXZInsideZone(x,z,zoneId)
  local zone=zones[zoneId]
  if(zone.type=="Rectangle") then
    local center_x=zone.center_xz.x
    local center_z=zone.center_xz.z
    if(center_x+zone.demiLargeur<x)then return false end -- uncommon formatting but multiline looks better IMHO
    if(center_x-zone.demiLargeur>x)then return false end
    if(center_z+zone.demiLongueur<z)then return false end
    if(center_z-zone.demiLongueur>z)then return false end
    return true
  elseif(zone.type=="Disk") then
    local center_x=zone.center_xz.x
    local center_z=zone.center_xz.z
    local apart=((center_x-x)*(center_x-x))/((zone.a)*(zone.a))
    local bpart=((center_z-z)*(center_z-z))/((zone.b)*(zone.b))
    return (apart+bpart<1)
  end
end

-------------------------------------
-- determine if a unit is in zone
-------------------------------------
local function isUnitInZone(springUnit,idZone)
  local x, y, z = Spring.GetUnitPosition(springUnit)
  return isXZInsideZone(x,z,idZone)
end

-------------------------------------
-- get a position randomly drawn within a zone
-- If extra parameters are given (such as validZone)
-- a random position can be drawn
-------------------------------------
local function getARandomPositionInZone(idZone)
  local zone=zones[idZone]
  local posit={}
  local center_x=zone.center_xz.x
  local center_z=zone.center_xz.z
  if(zone.type=="Disk") then
    while true do -- rejection method to draw random points from ellipse (drawn from rectangle and accepted if inside ellipse
      local x=math.random(center_x-zone.a, center_x+zone.a)
      local z=math.random(center_z-zone.b, center_z+zone.b)
      if(isXZInsideZone(x,z,idZone))then
        posit["x"]=x
        posit["z"]=z
        return posit
      end
    end
  elseif(zone.type=="Rectangle") then
    local x=math.random(center_x-zone.demiLargeur, center_x+zone.demiLargeur)
    local z=math.random(center_z-zone.demiLongueur, center_z+zone.demiLongueur)
    posit["x"]=x
    posit["z"]=z
    return posit
  end    
end

-------------------------------------
-- Write letter on map giving its position
-- Only O,W,N,S,E implemented
-------------------------------------
local function writeLetter(x, y, z, letter)
  if letter == "O" then
    -- write letter
    Spring.MarkerAddLine(x-5, y, z-8, x+5, y, z-8)
    Spring.MarkerAddLine(x+5, y, z-8, x+5, y, z+8)
    Spring.MarkerAddLine(x+5, y, z+8, x-5, y, z+8)
    Spring.MarkerAddLine(x-5, y, z+8, x-5, y, z-8)
  elseif letter == "W" then
    -- write letter
    Spring.MarkerAddLine(x-5, y, z-8, x-2.5, y, z+8)
    Spring.MarkerAddLine(x-2.5, y, z+8, x, y, z)
    Spring.MarkerAddLine(x, y, z, x+2.5, y, z+8)
    Spring.MarkerAddLine(x+2.5, y, z+8, x+5, y, z-8)
  elseif letter == "N" then
    -- write letter
    Spring.MarkerAddLine(x-5, y, z+8, x-5, y, z-8)
    Spring.MarkerAddLine(x-5, y, z-8, x+5, y, z+8)
    Spring.MarkerAddLine(x+5, y, z+8, x+5, y, z-8)
  elseif letter == "S" then
    -- write letter
    Spring.MarkerAddLine(x+5, y, z-8, x-5, y, z-8)
    Spring.MarkerAddLine(x-5, y, z-8, x-5, y, z)
    Spring.MarkerAddLine(x-5, y, z, x+5, y, z)
    Spring.MarkerAddLine(x+5, y, z, x+5, y, z+8)
    Spring.MarkerAddLine(x+5, y, z+8, x-5, y, z+8)
  elseif letter == "E" then
    -- write letter
    Spring.MarkerAddLine(x+5, y, z-8, x-5, y, z-8)
    Spring.MarkerAddLine(x-5, y, z-8, x-5, y, z+8)
    Spring.MarkerAddLine(x-5, y, z+8, x+5, y, z+8)
    Spring.MarkerAddLine(x-5, y, z, x, y, z)
  end
end

-------------------------------------
-- Write sign on map at given position
-- Only + and - are implemented
-------------------------------------
local function writeSign(x, y, z, sign)
  if sign == "+" then
    Spring.MarkerAddLine(x-5, y, z, x+5, y, z)
    Spring.MarkerAddLine(x, y, z-5, x, y, z+5)
  elseif sign == "-" then
    Spring.MarkerAddLine(x-5, y, z, x+5, y, z)
  end
end

-------------------------------------
-- show message on map 
-- instead of directly printing the message, replacements are made
-- to allow special elements such as colors. A global table, replacements is used to this effect
-------------------------------------
local function showMessage(content)
  local contentList=string.gmatch(content, '([^%.%.]+)') --split according the two dots (..) separator
  local message=""
  for chunk in contentList do
    if replacements[chunk]~=nil then
      message=message..replacements[chunk]
    else
      message=message..chunk
    end
  end
  Script.LuaRules.showMessage(message, false, 500)
end

-------------------------------------
-- Show Briefing, this function can be called from outside
-- For this reason all the json files must have a message with id BRIEFING
-------------------------------------
local function ShowBriefing ()
  --Spring.Echo(json.encode(mission))
  showMessage(getAMessage("briefing"))-- convention all json files have briefing attribute
end

-------------------------------------
-- Check if a condition, expressed as a string describing boolean condition where variables
-- are related to conditions in the json files.
-------------------------------------
local function isTriggerable(trigger)
  for idCond,valueCond in pairs(conditions) do
    -- first step : conditions are replaced to their boolean values.
    trigger=string.gsub(trigger, idCond, boolAsString(valueCond["currentlyValid"]))
  end
  
  for name,value in pairs(variables) do
  -- second step : conditions are replaced to their boolean values.
    trigger=string.gsub(trigger, name, 'variables.'..name)
  end
  
  -- third step : turn the string in return statement
  local executableStatement="return("..trigger..")"
  local f = loadstring(executableStatement)
   -- fourth step : loadstring is used to create the function.
  return(f())
end


local function getUnitTableFromId(idUnit)
  for i=1,table.getn(mission.armies) do
    local factionArmies=mission.armies[i]
    for j=1,table.getn(factionArmies.units) do
      local unitTable=factionArmies.units[j]
      if(unitTable.id==idUnit)then
        return unitTable
      end
    end
  end
  --Spring.Echo("impossible to find the table of "..idUnit.." in mission.armies")
  --Spring.Echo(json.encode(mission.armies))
  return nil
end

local function getUnitFactionTypeFromId(idUnit)
  for i=1,table.getn(mission.armies) do
    local factionArmies=mission.armies[i]
    local factionType=factionArmies.faction
    local factionTypeCode=getFactionCode(factionType)
    for j=1,table.getn(factionArmies.units) do
      local unitTable=factionArmies.units[j]
      if(unitTable.id==idUnit)then
        return factionType
      end
    end
  end
  return nil
end

local function createUnit(unitTable)
    local posit=unitTable.position
    armySpring[unitTable.id] = Spring.CreateUnit(unitTable.type, posit.x, posit.y,posit.z, "n", unitTable.team)
    armyInformations[unitTable.id]={}
    local springUnit=armySpring[unitTable.id]    
    armyInformations[unitTable.id].health=Spring.GetUnitHealth(springUnit)*(unitTable.hp/100)
    Spring.SetUnitHealth(springUnit,armyInformations[unitTable.id].health)
    
    armyInformations[unitTable.id].previousHealth=armyInformations[unitTable.id].health
    armyInformations[unitTable.id].autoHeal = UnitDefs[Spring.GetUnitDefID(armySpring[unitTable.id])]["autoHeal"]
    armyInformations[unitTable.id].idleAutoHeal = UnitDefs[Spring.GetUnitDefID(armySpring[unitTable.id])]["idleAutoHeal"]
    armyInformations[unitTable.id].autoHealStatus=unitTable.autoheal
    armyInformations[unitTable.id].isUnderAttack=false
    --Spring.Echo("try to create unit with these informations")
    Spring.SetUnitRotation(springUnit,0,-1*unitTable.orientation,0)
    
    -- update group units (team related)
    if(groupOfUnits[unitTable.team]==nil) then
      groupOfUnits[unitTable.team]={}
    end
    table.insert(groupOfUnits[unitTable.team],unitTable.id)
    -- update group units (type related)
    if(groupOfUnits[unitTable.type]==nil) then
      groupOfUnits[unitTable.type]={}
    end
    table.insert(groupOfUnits[unitTable.type],unitTable.id)
end

-------------------------------------
-- Indicate if the action is groupable, which means that
-- it can be applied to a group of units
-------------------------------------
local function isAGroupableTypeOfAction(actionType)
  if (actionType=="attack")or(actionType=="noFire")or(actionType=="move")or(actionType=="transfert") then
    return true
  end
  return false
end

-------------------------------------
-- Apply a groupable action on a unit
-------------------------------------
local function ApplyGroupableAction(unit,act)
  if(Spring.ValidUnitID(unit))then -- check if the unit is still on board
    if(act.type=="attack") then
    -- Maybe One day check if valid unit are recquiered (not dead I mean)
      local attacked=armySpring[act.attacked] 
      if(Spring.ValidUnitID(attacked))then -- check if the unit is still on board
        Spring.GiveOrderToUnit(unit, CMD.FIRE_STATE, {0}, {})
        -- command this unit to attack the byte
        Spring.GiveOrderToUnit(unit, CMD.ATTACK, {attacked}, {}) 
      end    
    
    elseif(act.type=="noFire") then
      Spring.GiveOrderToUnit(unit, CMD.FIRE_STATE, {0}, {})   
        
    elseif(act.type=="move")then
      local posit=getAPosition(act.position)
      Spring.GiveOrderToUnit(unit, CMD.MOVE, {tonumber(posit.x), Spring.GetGroundHeight(tonumber(posit.x), tonumber(posit.z)),tonumber(posit.z)}, {})
      
    elseif(act.type=="transfert")then -- gives the possession at another faction
      local faction=act.factionReceiving
      local factioncode=getFactionCode(faction)
      Spring.TransferUnit(unit, factioncode)
    end
  end
end

-------------------------------------
-- Apply a groupable action, generally not related to an unit
-------------------------------------
local function ApplyNonGroupableAction(act)
  if(act.type=="marker") then
    local posit=getAPosition(act.position)
    local message=getAMessage(act.messageId)
    --Spring.Echo("this is the intended message "..message[lang])
    Spring.MarkerAddPoint(tonumber(posit.x), Spring.GetGroundHeight(tonumber(posit.x), tonumber(posit.z)),tonumber(posit.z), message[lang])
  
  elseif(act.type=="briefing") then
    local content=getAMessage(act.messageId)
    showMessage(content) 
     
  elseif(act.type=="erasemarker") then 
    local posit=getAPosition(act.position)
    Spring.MarkerErasePosition(tonumber(posit.x), Spring.GetGroundHeight(tonumber(posit.x), tonumber(posit.z)),tonumber(posit.z))
  
  elseif(act.type=="end") then -- Change global variable success, and outputstate
    --Spring.Echo("applyingVictory")
    --Spring.Echo(json.encode(conditions))
    outputstate=act.outputState
    if(act.result=="success")then
      success=1
    else
      success=-1
    end 
    
  elseif(act.type=="unitCreation") then
    local oldId=act.unitId
    local tableUnit=getUnitTableFromId(oldId)
    local factionType=getUnitFactionTypeFromId(oldId)
    local factionTypeCode=getFactionCode(factionType)
    local newId=oldId -- by default
    if(armyInformations[oldId]~=nil)then -- if an ennemy with the same id has already been created, then create another id 
      local index=0   
      while (armyInformations[oldId.."_"..tostring(index)]~=nil) do
        index=index+1
      end
      newId=oldId.."_"..tostring(index) 
    end 
    local newtableUnit=deepcopy(tableUnit)
    newtableUnit.id=newId
    createUnit(newtableUnit,factionTypeCode)
    if(act.actionId~=nil)then
      ApplyAction (act.actionId,newId)
    end
  end
end

-------------------------------------
-- The more general function to apply an action
-- according to its type, will be applied within another function
-- Handle group of units
-------------------------------------
function ApplyAction (actionId,overridingId)
  --Spring.Echo("try to apply "..actionId)
  --Spring.Echo(json.encode(actions))
  if (not actions[actionId]["alreadyDone"])or(actions[actionId].toBeRepeated=="yes") then
    actions[actionId]["alreadyDone"]=true
    local act=actions[actionId] 
    if(isAGroupableTypeOfAction(act.type)) then 
    -- All actions have a type attribute, allowing us to know what they deal about
      local externalUnitId=act.object
      if(overridingId~=nil) then
        externalUnitId=overridingId
      end
      if(groupOfUnits[externalUnitId]==nil) then 
      -- the first thing we check is wether the id is related to a group or not
      -- if we pass this condition, it means that the condition is on only one unit
        local unit=armySpring[externalUnitId]
        --Spring.Echo(externalUnitId.." is asked to "..act.type)
        ApplyGroupableAction(unit,act)
      else
        -- we apply the condition the whole group
        for i, externalUnitId in ipairs(groupOfUnits[externalUnitId]) do
          local unit=armySpring[externalUnitId]
          ApplyGroupableAction(unit,act)
        end
      end
    else
      ApplyNonGroupableAction(act)
    end  
  end
end

-------------------------------------
-- Printing the stack of actions planned in time
-- For debugging purpose
-------------------------------------
local function printMyStack()
  for i,el in pairs(actionStack) do
    --Spring.Echo("action "..el.actId.." is planned with delay : "..el.delay)
  end
end 

-------------------------------------
-- Check if an action is already in the stack of actions
-------------------------------------
local function alreadyInStack(actId)
  for index,el in pairs(actionStack) do
    if(el.actId==actId)then
      return true
    end
  end
  return false
end 

-------------------------------------
-- Add an action to the stack, in a sorted manner
-- The action is insert according its delay
-- At the beginning of table if the quickest action to be applied
-- At the end if the action with the biggest delay
-------------------------------------
local function AddActionInStack(actId, delSeconds)
  local delay=secondesToFrames(delSeconds)
  local element={}
  element["delay"]=delay
  element["actId"]=actId
  --Spring.Echo(actId.." is added with delay : "..delay)
  for index,el in pairs(actionStack) do
    local del=el.delay
    local act=el.actId
    if(del>delay) then
      table.insert(actionStack,index,element)
      return
    end
  end
  table.insert(actionStack,element)
end 

-------------------------------------
-- Update the stack by considering the time elapsed (in frames)
-- Actions get closer to be applied when time passes
-------------------------------------
local function updateStack(timeLapse)
  local updatedStack={}
  for index,el in pairs(actionStack) do
    el.delay=el.delay-timeLapse -- updating the delay
    table.insert(updatedStack,el)
  end
  return updatedStack
end 

-------------------------------------
-- All the actions with a negative delay will be applied
-- and removed from the stack
-------------------------------------
local function applyCurrentActions()
  for index,el in pairs(actionStack) do
    if(el.delay<0)then
      ApplyAction(el.actId, nil)
      table.remove(actionStack,index)
    end
  end
end 

-------------------------------------
-- Units heal by themselves, which can be problematic
-- We let an option to override this principle
-- This function allows to cancel auto heal
-- for the units concerned by this option
-------------------------------------
local function cancelAutoHeal()
  for idUnit,infos in pairs(armyInformations) do
    local springUnit=armySpring[idUnit]
  -- armyInformations
    if(infos.autoHealStatus=="disabled")and(Spring.ValidUnitID(springUnit)) then
      local currentHealth = Spring.GetUnitHealth(springUnit)
      if currentHealth == infos.previousHealth+infos.autoHeal or currentHealth == infos.previousHealth+infos.idleAutoHeal then
        Spring.SetUnitHealth(springUnit, infos.previousHealth)
      else
        if(currentHealth<infos.previousHealth)then
          --if updated too often this is not reliable (to fix)
          infos.isUnderAttack=true
        end
        infos.previousHealth = currentHealth
      end
    end
    armyInformations[idUnit]=infos
  end
end

-------------------------------------
-- If an event must be triggered, then shall be it
-- All the actions will be put in stack unless some specific options
-- forbide to do so, such as allowMultipleInStack
-------------------------------------
local function processEvents()
  for idEvent,event in pairs(events) do
    if isTriggerable(event.trigger) then
      if(event.script~=nil)then
        --Spring.Echo("before")
        --Spring.Echo(json.encode(variables))
        local script=event.script
        --Spring.Echo()
        for name,value in pairs(variables) do
          -- first step : conditions are replaced to their boolean values.
          script=string.gsub(script, name, 'variables.'..name)
        end
        -- second step : turn the string in return statement
        local f = loadstring(script)
        f()
      end
      --Spring.Echo("after")
      --Spring.Echo(json.encode(variables))          
      for j=1,table.getn(event.actions) do
        local actId=event.actions[j].actionId
        local allowMultipleInStack=actions[actId].allowMultipleInStack   
        if ((allowMultipleInStack==nil or allowMultipleInStack=="yes"))or(not(alreadyInStack(actId))) then
          AddActionInStack(actId,tonumber(actions[actId].delay))
        end
      end 
    end
  end
end

-------------------------------------
-- wrapper for two main functions related to
-- the main operations on the game
-------------------------------------
local function  UpdateGameState()
  cancelAutoHeal()
  --processEvents() 
end

-------------------------------------
-- Get the action of the unit
-- Actions are in a queue list available by GetCommandQueue
-------------------------------------
local function GetCurrentUnitAction(unit)
  local q=Spring.GetCommandQueue(unit,1) -- 1 means the only the first action in the stack
  local action=""
  if(q~=nil)and(q[1]~=nil) then
    action=q[1].id
    -- get the string describing the action by CMD[q[1].id] if you want
  end
  return action
end

-------------------------------------
-- Determine if an unit satisfy a condition
-- Two modes are possible depending on if we want the condition
-- to be satisfied if at least one unit of this group satisfy it
-- or if all the units satisfy it
-------------------------------------
local function UpdateConditionOnUnit (externalUnitId,c)--for the moment only single unit
  local internalUnitId=armySpring[externalUnitId]
  if(c.attribute=="dead") then --untested yet
    --Spring.Echo("is it alive ?")
    local alive=Spring.ValidUnitID(internalUnitId)
    --Spring.Echo(alive)
    return not(alive)
  elseif(Spring.ValidUnitID(internalUnitId)) then  -- 
  -- recquire that the unit is alive (unless the condition type is death, cf at the end of the function
    if(c.attribute=="zone") then
      return isUnitInZone(internalUnitId,c.params.zone)  
    elseif(c.attribute=="underAttack")then --untested yet
      return armyInformations[externalUnitId].isUnderAttack
    elseif(c.attribute=="order") then 
      local action=GetCurrentUnitAction(internalUnitId)     
      return (action==CMD[c.params.command]) 
    end
  end
end


    --[[
    elseif(c.attribute=="health") then
      local tresholdRatio=tonumber(c.value.tresholdRatio)
      local mode=c.value.mode--upTo/downTo
      local health,maxhealth=Spring.GetUnitHealth(internalUnitId)
      if(mode=="upTo")then
        if(maxhealth*tresholdRatio<=health) then
          return true
        else
          return false
        end
      elseif(mode=="downTo")then
        if(maxhealth*tresholdRatio>=health) then
          return true
        else
          return false
        end
      end
    end  
  end    --]]

-------------------------------------
-- Determine if a group satisfies a condition
-------------------------------------
local function UpdateConditionOnGroup(groupId,c)
  --Spring.Echo("group Investigated : "..groupId)
  for i, externalUnitId in ipairs(groupOfUnits[groupId]) do
    --Spring.Echo("unit Investigated : "..externalUnitId)
    local bool=UpdateConditionOnUnit (externalUnitId,c)
    --Spring.Echo(bool)
    if(c["value"]["group"]=="any")and(bool) then
      return true
    elseif(c["value"]["group"]=="all")and(not bool) then
      return false
    end     
  end
  return(c["value"]["group"]=="all")
  --trick to figure out the boolean value if the loop never break.
  -- if it was "all" then bool was always true, then the whole condition is true
  -- if it was "any" then bool was always false, then the whole condition is false
end   

-------------------------------------
-- Update the truthfulness of a condition
-------------------------------------
local function UpdateConditionsTruthfulness (frameNumber)
  for idCond,c in pairs(conditions) do
    local object=c["object"]
    if(object=="unit")then
      conditions[idCond]["currentlyValid"]=UpdateConditionOnUnit(c.params.unit,c)
    end
    
    --[[
    if(externalUnitId=="frameNumber") then
      local bool=true
      bool=bool and ((c.value.superiorTo==nil)or(secondesToFrames(tonumber(c.value.superiorTo))<frameNumber))
      bool=bool and ((c.value.inferiorTo==nil)or(secondesToFrames(tonumber(c.value.inferiorTo))>frameNumber))
      conditions[idCond]["currentlyValid"]=bool          
    elseif(groupOfUnits[externalUnitId]==nil) then 
      -- means that the condition is on only one unit
      conditions[idCond]["currentlyValid"]=UpdateConditionOnUnit(externalUnitId,c)
    else 
      -- means that the condition is on a group
      conditions[idCond]["currentlyValid"]=UpdateConditionOnGroup(externalUnitId,c)
    end
  --]]
  end 
end

-------------------------------------
-- Update dynamic variables
-------------------------------------
local function UpdateDynamicVariables ()--for the moment only positions
  -- POSITIONS
  for idPos,p in pairs(positions) do
    if(p.type=="dynamic") then
      local springUnitId=armySpring[p.updatedAccording]
      if(Spring.ValidUnitID(springUnitId))then
        local x,y,z=Spring.GetUnitPosition(springUnitId)
        positions[idPos].x=x
        positions[idPos].z=z
      end
    end
  end 
end

-------------------------------------
--Write a compass on unit, useful to help the player with
--coordinates when dealing with relative positions  
-------------------------------------
local function writeCompassOnUnit(springUnitId)
    local x,y,z=Spring.GetUnitPosition(springUnitId)
    -- Add marks around unit
    -- left arrow
    Spring.MarkerAddLine(x-65, y, z, x-25, y, z)
    Spring.MarkerAddLine(x-65, y, z, x-55, y, z+10)
    Spring.MarkerAddLine(x-65, y, z, x-55, y, z-10)
    -- right arrow
    Spring.MarkerAddLine(x+65, y, z, x+25, y, z)
    Spring.MarkerAddLine(x+65, y, z, x+55, y, z+10)
    Spring.MarkerAddLine(x+65, y, z, x+55, y, z-10)
    -- top arrow
    Spring.MarkerAddLine(x, y, z-65, x, y, z-25)
    Spring.MarkerAddLine(x, y, z-65, x+10, y, z-55)
    Spring.MarkerAddLine(x, y, z-65, x-10, y, z-55)
    -- down arrow
    Spring.MarkerAddLine(x, y, z+65, x, y, z+25)
    Spring.MarkerAddLine(x, y, z+65, x+10, y, z+55)
    Spring.MarkerAddLine(x, y, z+65, x-10, y, z+55)
    -- write letters
    if lang == "fr" then
      writeLetter(x-60, y, z-25, "O")
    else
      writeLetter(x-60, y, z-25, "W")
    end
    writeLetter(x+60, y, z-25, "E")
    writeLetter(x-25, y, z-60, "N")
    writeLetter(x-25, y, z+60, "S")
    -- write signs
    writeSign(x-48, y, z+18, "-")
    writeSign(x+48, y, z+18, "+")
    writeSign(x+18, y, z-48, "-")
    writeSign(x+18, y, z+48, "+")
end

local function parseJson(jsonFile)
  Spring.Echo(jsonFile)
  if(jsonFile==nil) then
    return nil
  end
  canUpdate=true
  --Spring.Echo(jsonName)
  --Spring.Echo("we try to decode"..jsonFile)
  mission=json.decode(jsonFile)
  
  return true
end

local function returnEventsTriggered()
  local eventsTriggered={}
  for idEv,ev in pairs(events) do   
    if(ev.hasTakenPlace) then
      table.insert(eventsTriggered,idEv)
    end
  end
  return eventsTriggered
end

local function returnTestsToPlay()
  --Spring.Echo(json.encode(mission.tests))
  return mission.tests
end

-------------------------------------
-- Initialize the mission by parsing informations from the json
-- and process some datas
-- @todo This function does too many things
-------------------------------------
local function StartAfterJson ()
  -- Delete all the stuff (required as team kernel are placed by spring since the beginnning)
  

  --[[ 

  --]]

  -- COMMENTED OUT for the moment, avoid unsage attempt to modify gamestate
  local units = Spring.GetAllUnits()
  for i = 1,table.getn(units) do
    --Spring.Echo("I am Totally Deleting Stuff")
    Spring.DestroyUnit(units[i], false, true)
  end  
  
   -------------------------------
   -------VARIABLES---------------
   -------------------------------
  if(mission.variables~=nil)then
    for i=1,table.getn(mission.variables) do
      local missionVar=mission.variables[i]
      local initValue=missionVar.initValue
      local name=missionVar.name
      if(missionVar.type=="number") then
        initValue=tonumber(initValue)
      elseif(missionVar.type=="boolean") then
        initValue=(initValue=="true")
      end
      variables[name]=initValue
    end
  end  
  Spring.Echo(json.encode(variables))


  local specialPositionTables={}
  -- specialPositionTables[i]={positions[id].x,positions[id].z}
  -- 

   -------------------------------
   -------SETTINGS----------------
   -------------------------------
  messages["briefing"]=mission.description.briefing
  Spring.Echo(messages["briefing"])
--  if(mission.description.mouse=="disabled") then
--   SendToUnsynced("mouseDisabled", true)
--  end

  if(mission.description.cameraAuto=="enabled") then
    _G.cameraAuto = {
      enable = true,
      specialPositions = specialPositionTables --TODO: minimap and special position géree dans les zones
    }
    SendToUnsynced("enableCameraAuto")
    _G.cameraAuto = nil
  end
  local isautoHealGlobal=(mission.description.autoHeal=="enabled")
  
 -------------------------------
 ----------ARMIES---------------
 -------------------------------
  local isAutoHeal
  if(mission.units~=nil)then
    for i=1,table.getn(mission.units) do
      local armyTable=mission.units[i]
      if(armyTable.autoHeal=="global") then
        isAutoHeal=isautoHealGlobal
      else
        isAutoHeal=(armyTable.autoHeal=="enabled")
      end
        armyTable["autoHeal"]=isAutoHeal
        createUnit(armyTable)
    end
  end
  
  ShowBriefing()
   

 -------------------------------
 ------GROUP OF ARMIES----------
 -------------------------------
  if(mission["groups"]~=nil) then
    for i=1, table.getn(mission.groups) do
      local groupname=mission.groups[i].name
      groupOfUnits[groupname]={}
      for i,unit in ipairs(mission.groups[i].units) do
        table.insert(groupOfUnits[groupname],unit)
      end
    end
  end 
  Spring.Echo(json.encode(groupOfUnits))
   


 -------------------------------
 -------CONDITIONS--------------
 -------------------------------
if(mission.events~=nil)then
    for i=1, table.getn(mission.events) do
     local currentEvent=mission.events[i]
     for j=1, table.getn(currentEvent.conditions)do
       local currentCond=currentEvent.conditions[j]
       local id=currentCond.name
       conditions[id]=currentEvent.conditions[j]
       conditions[id]["currentlyValid"]=false
       local type=currentCond.type
       local cond_object="other"
       local attribute=type
       if(string.sub(type, 1, 5)=="type_") then
        cond_object="group" -- group is the generic thing
        attribute=string.sub(type, 6, -1)
       elseif(string.sub(type, 1, 5)=="unit_") then
        cond_object="unit"
        attribute=string.sub(type, 6, -1)
       elseif(string.sub(type, 1, 6)=="group_") then
        cond_object="group"
        attribute=string.sub(type, 7, -1)
       elseif(string.sub(type, 1, 5)=="team_") then
        cond_object="group"
        attribute=string.sub(type, 6, -1)
      end
      conditions[id]["object"]=cond_object
      conditions[id]["attribute"]=attribute
    end 
  end
  -- Spring.Echo(json.encode(conditions))
end

 -------------------------------
 -------EVENTS------------------
 -------------------------------
 if(mission.events~=nil)then   
  for i=1, table.getn(mission.events) do
   local idEvent=mission.events[i].id
   events[idEvent]={}
   events[idEvent]=mission.events[i]
   events[idEvent].hasTakenPlace=false
  end
end


 -------------------------------
 -------ZONES--------------------
 -------------------------------
 if(mission.zones~=nil)then   
  for i=1, table.getn(mission.zones) do
   local cZ=mission.zones[i]
   local idZone=cZ.name
   if(cZ.type=="Disk") then
    zones[idZone]={type="Disk",center_xz={x=cZ.x, z=cZ.z},a=cZ.a,b=cZ.b}
   elseif(cZ.type=="Rectangle") then
    local demiLargeur=(cZ.x2-cZ.x1)/2
    local demiLongueur=(cZ.z2-cZ.z1)/2
    local center_xz={x=cZ.x1+demiLargeur, z=cZ.z1+demiLongueur}
    zones[idZone]={type="Rectangle",center_xz=center_xz,demiLargeur=demiLargeur,demiLongueur=demiLongueur} 
   else
    Spring.Echo(cZ.type.." not implemented yet")
    end  
  end
end



 --[[  
   
   -------------------------------
   -------START------------------
   -------------------------------   
  
  --Spring.DestroyUnit(armySpring["ahah"],false,false)
  
  conditions["START"]={}
  for idEvent,event in pairs(events) do
    if(event.trigger=="START") then -- CONVENTION : Id Condition for start is START, does not recquired to get a definition
      for j=1, table.getn(event.actions) do
        local actId=event.actions[j].actionId
        --Spring.Echo("try to apply"..actId)
        AddActionInStack(actId,tonumber(actions[actId].delay))
      end
    end
  end
  conditions["START"]["currentlyValid"]=false
  ShowBriefing()    
--]]        
end
-------------------------------------
-- Update the game state of the mission 
-- Called externally by the gadget mission_runner.lua 
-- @return success (0,1 or -1) for (nothing, success, fail) and outputstate (appliq related)
-------------------------------------

local function Start(jsonFile) -- shorthand for parseJson + StartAfterJson.
  parseJson(jsonFile)
  StartAfterJson ()
end

local function Update (frameNumber)
  UpdateConditionsTruthfulness(frameNumber) 
  UpdateGameState()
  if(success~=nil) then
    return success,outputstate
  else
    return 0 -- means continue
  end
  -- Trigger Events
end  
  
  
  
  
  
  --[[
  if(not canUpdate)then
    return 0
  end
  frameIndex=frameIndex+1
  if(frameIndex>=refreshPeriod) then
    --printMyStack()
    frameIndex=0  
    actionStack=updateStack(refreshPeriod)
    applyCurrentActions() 
    UpdateDynamicVariables() -- update knowledge on the game situation
    UpdateConditionsTruthfulness(frameNumber)-- update truthfulness of conditions
    UpdateGameState()-- act upon the situation
    if(success~=nil) then
      return success,outputstate
    else
      return 0 -- means continue
    end
  else
    return 0 -- means continue
  end
 
  return 0
end
 --]]
-------------------------------------
-- Called by mission_runner at the end of the mission
-------------------------------------
local function Stop ()
	-- delete all units created
	local units = Spring.GetAllUnits() 
	for i = 1,table.getn(units) do
		Spring.DestroyUnit(units[i], false, true)
	end
	
	-- delete marker
	Spring.MarkerErasePosition(1983, Spring.GetGroundHeight(1983, 1279), 1279)
end

function gadget:RecvLuaMsg(msg, player)
  if((msg~=nil)and(string.len(msg)>4)and(string.sub(msg,1,4)=="kill")) then
    -- comes from mission runner unit destroyed
    -- local killTable={unitID=unitID, unitDefID=unitDefID, unitTeam=unitTeam, attackerID=attackerID, attackerDefID=attackerDefID, attackerTeam=attackerTeam}
    -- is encoded
    local jsonfile=string.sub(msg,5,-1)
    local killTable=json.decode(jsonfile)
    local attackerTeam=killTable.attackerTeam
    if killByTeams[attackerTeam]==nil then
      killByTeams[attackerTeam]={} 
    end
    table.insert(killByTeams[attackerTeam],killTable)
    --Spring.Echo(json.encode(killByTeams))
  end
end

local Mission = {}

Mission.returnEventsTriggered=returnEventsTriggered
Mission.returnTestsToPlay=returnTestsToPlay
Mission.parseJson=parseJson
Mission.StartAfterJson=StartAfterJson
Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop
Mission.ApplyAction = ApplyAction

return Mission
