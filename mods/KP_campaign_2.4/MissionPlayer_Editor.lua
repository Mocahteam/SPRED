------------------
-- this module play generic missions encoded in a json data format
-- @module MissionPlayer
-- ----------------
--
local maxHealth, tmp
local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local lang = Spring.GetModOptions()["language"] -- get the language
local jsonPartName = Spring.GetModOptions()["missionname"]
local replacements={}
replacements["gray"] = "\255\100\100\100"

local ctx={}
ctx.armySpring={}--table to store created spring units externalId->SpringId
ctx.armyExternal={}--table to store created spring units SpringId->externalId
ctx.groupOfUnits={}--table to store group of units externalIdGroups-> list of externalIdUnits
ctx.armyInformations={}--table to store information on units externalId->Informations
ctx.messages={}--associative array messageId->message type
ctx.conditions={}--associative array idCond->condition
ctx.events={}--associative array idCond->event
ctx.variables={}--associative array variable->value Need to be global so that it can be updated by using loadstring
ctx.zones={}
ctx.killByTeams={}
ctx.attackedUnits={}
ctx.recordCreatedUnits=false
ctx.refreshPeriod=10 -- must be between 1 and 16. The higher the less cpu involved. 
ctx.actionStack={} -- action to be applied on game state, allows to handle table composed by the indexes delay and actId
ctx.success=nil -- when this global variable change (with event of type "end"), the game ends (= victory or defeat)
ctx.outputstate=nil -- if various success or defeat states exist, outputstate can store this information. May be used later such as in AppliqManager to enable adaptative scenarisation
ctx.canUpdate=false
ctx.mission={}
ctx.startingFrame=5
ctx.globalIndexOfCreatedUnits=0


-------------------------------------
-- Load codegiven an environnement (table of variables that can be accessed and changed)
-- This function ensure compatibility (setfenv is dropped from lua 5.2)
-- Shamelessly taken from http://stackoverflow.com/questions/9268954/lua-pass-context-into-loadstring
-------------------------------------
local function load_code(code)
    if setfenv and loadstring then
        local f = assert(loadstring(code))
        setfenv(f,ctx)
        f()
    else
        f=assert(load(code, nil,"t",ctx))
        f()
    end
end

-------------------------------------
-- Compare numerical values, a verbal "mode" being given 
-- @return nil or list
-------------------------------------
local function intersection(list1,list2)
  local inters={}
  if list1==nil then return nil end
  if list2==nil then return nil end
  for i,el in pairs(list1)do
    for i2,el2 in pairs(list2)do
      if(el==el2)then
        table.insert(inters,el)
        break
      end
    end
  end
  --Spring.Echo("resuilt of interset")
  --Spring.Echo(json.encode(inters))
  return inters
end

-------------------------------------
-- Compare numerical values, a verbal "mode" being given 
-- @return boolean
-------------------------------------
local function compareValue_Verbal(reference,maxRef,value,mode)
  if(mode=="atmost")then return (value<=reference)      
  elseif(mode=="atleast")then  return (value>=reference)    
  elseif(mode=="exactly")then return (reference==value)  
  elseif(mode=="all")then return (maxRef==value)
  end
end

-------------------------------------
-- Compare numerical values, a numerical "mode" being given 
-- @return boolean
-------------------------------------
local function compareValue_Numerical(v1,v2,mode) 
  if(mode==">")then return v1>v2 end
  if(mode==">=")then return v1>=v2 end
  if(mode=="<")then return v1<v2 end
  if(mode=="<=")then return v1<=v2 end
  if(mode=="==")then return v1==v2 end
  if(mode=="!=")then return v1~=v2 end
end 

-------------------------------------
-- Make an operation, a numerical "operator" being given 
-- @return number
-------------------------------------
local function makeOperation(v1,v2,operation)
  if(operation=="*")then return v1*v2 end
  if(operation=="+")then return v1+v2 end
  if(operation=="-")then return v1-v2 end
  if(operation=="/")then
    if(v2~=0)then return v1/v2 end
    else
      Spring.Echo("division by 0 replaced by division by 1")
      return v1
    end
  if(operation=="%")then return v1 - math.floor(v1/v2)*v1 end
end

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
-- Get a message from a message table
-- If the message is not unique (a list), taking one by random
-------------------------------------
local function getAMessage(messageTable) 
  if(messageTable[1]==nil) then
    return messageTable
  else
    return messageTable[math.random(#messageTable)]
  end
end

-------------------------------------
-- Indicates if a point is inside a zone (disk or rectangle)
-- @return boolean
-------------------------------------
local function isXZInsideZone(x,z,zoneId)
  local zone=ctx.zones[zoneId]
  if(zone==nil)then
    Spring.Echo("not found")
    Spring.Echo(zoneId)
    Spring.Echo(json.encode(ctx.zones))
  end
  if(zone.type=="Rectangle") then
  --[[
    Spring.Echo("debug : x,z,centerx,centerz,demL,deml")
    Spring.Echo(x)
    Spring.Echo(z)
    Spring.Echo(zone.center_xz.x)
    Spring.Echo(zone.center_xz.z)
    Spring.Echo(zone.demiLongueur)
    Spring.Echo(zone.demiLargeur)--]]
    local center_x=zone.center_xz.x
    local center_z=zone.center_xz.z
    if(center_x+zone.demiLargeur<x)then return false end -- uncommon formatting but multiline looks better IMHO
    if(center_x-zone.demiLargeur>x)then return false end
    if(center_z+zone.demiLongueur<z)then return false end
    if(center_z-zone.demiLongueur>z)then return false end
    return true
  elseif(zone.type=="Disk") then
   --[[
    Spring.Echo("debug : x,z,centerx,centerz,a,b")
    Spring.Echo(x)
    Spring.Echo(z)
    Spring.Echo(zone.center_xz.x)
    Spring.Echo(zone.center_xz.z)
    Spring.Echo(zone.a)
    Spring.Echo(zone.b)--]]
    local center_x=zone.center_xz.x
    local center_z=zone.center_xz.z
    local apart=((center_x-x)*(center_x-x))/((zone.a)*(zone.a))
    local bpart=((center_z-z)*(center_z-z))/((zone.b)*(zone.b))
    return (apart+bpart<1)
  end
end

-------------------------------------
-- Indicates if an unit is inside a zone (disk or rectangle)
-- @return boolean
-------------------------------------
local function isUnitInZone(springUnit,idZone)
  local x, y, z = Spring.GetUnitPosition(springUnit)
  return isXZInsideZone(x,z,idZone)
end

-------------------------------------
-- draw a position randomly drawn within a zone
-------------------------------------
local function getARandomPositionInZone(idZone)
  if(ctx.zones[idZone]~=nil) then
    local zone=ctx.zones[idZone]
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
  else
    Spring.Echo("zone not found")
  end   
end

-------------------------------------
-- Extract position from parameters
-- Sometimes a zone is given and getARandomPositionInZone will be called
-------------------------------------
local function extractPosition(tablePosOrMaybeJustZoneId)
  if(type(tablePosOrMaybeJustZoneId)~="number")then
    return tablePosOrMaybeJustZoneId
  else
    return getARandomPositionInZone(tablePosOrMaybeJustZoneId)
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
  showMessage(getAMessage(ctx.messages["briefing"]))-- convention all json files have briefing attribute
end

-------------------------------------
-- Check if a condition, expressed as a string describing boolean condition where variables
-- are related to conditions in the json files.
-------------------------------------
local function isTriggerable(event)
  local trigger=event.trigger
  if(trigger=="")then   -- empty string => create trigger by cunjunction (ands) of all conditions
  -- step 1 : write the trigger
    for c,cond in pairs(event.listOfInvolvedConditions) do
      trigger=trigger..cond.." and "
    end
    trigger=string.sub(trigger,1,-5) -- drop the last "and"
  end
  for c,cond in pairs(event.listOfInvolvedConditions) do
    -- second step : conditions are replaced to their boolean values.
    local valueCond=ctx.conditions[cond..tostring(event.id)]
    trigger=string.gsub(trigger, cond, boolAsString(valueCond["currentlyValid"]))
  end
  -- third step : turn the string in return statement
  local executableStatement="return("..trigger..")"
  local f = loadstring(executableStatement)
   -- fourth step : loadstring is used to create the function.
  return(f())
end

-------------------------------------
-- Extract the list of units related to a condition
-- tableLookup represent a list of attributes to look up in the condition
-- When one is found the search is interrupted
-------------------------------------
local function extractListOfUnitsImpliedByCondition(conditionParams,tableLookup)
  --Spring.Echo(json.encode(condition))
  
  -- special case here, processed in a sadly ugly manner : unitTYpe t of Team X must be an intersection
  if(conditionParams.unitType~=nil)and(conditionParams.team~=nil)then
    local l1=ctx.groupOfUnits["team_"..conditionParams.team]
    local l2=ctx.groupOfUnits["type_"..conditionParams.unitType]
    return intersection(l1,l2) 
  end
  for idx,tableT in ipairs(tableLookup)do
    local conditionTerm=tableT[1]
    local prefixTerm=tableT[2]   
    --Spring.Echo("we look for this term in the conditions")
    --Spring.Echo(conditionTerm) 
    if(conditionParams[conditionTerm]~=nil)then
      local groupIndex=prefixTerm.."_"..tostring(conditionParams[conditionTerm])--gives stuff like team_1
      --Spring.Echo("this group is selected")
      --Spring.Echo(conditionTerm)
     -- Spring.Echo(groupIndex)
      --Spring.Echo(json.encode(ctx.groupOfUnits))
      return ctx.groupOfUnits[groupIndex]
    end
  end
end

-------------------------------------
-- Create unit according informations stored in a table
-- Also add unit in group tables (team, type) 
-------------------------------------
local function createUnit(unitTable)
    local posit=unitTable.position
    ctx.armySpring[unitTable.id] = Spring.CreateUnit(unitTable.type, posit.x, posit.y,posit.z, "n", unitTable.team)
    ctx.armyExternal[ctx.armySpring[unitTable.id]]=unitTable.id
    ctx.armyInformations[unitTable.id]={}
    local springUnit=ctx.armySpring[unitTable.id]    
    ctx.armyInformations[unitTable.id].health=Spring.GetUnitHealth(springUnit)*(unitTable.hp/100)
    Spring.SetUnitHealth(springUnit,ctx.armyInformations[unitTable.id].health)
    ctx.armyInformations[unitTable.id].previousHealth=ctx.armyInformations[unitTable.id].health
    ctx.armyInformations[unitTable.id].autoHeal = UnitDefs[Spring.GetUnitDefID(ctx.armySpring[unitTable.id])]["autoHeal"]
    ctx.armyInformations[unitTable.id].idleAutoHeal = UnitDefs[Spring.GetUnitDefID(ctx.armySpring[unitTable.id])]["idleAutoHeal"]
    ctx.armyInformations[unitTable.id].autoHealStatus=unitTable.autoHeal
    --Spring.Echo(ctx.armyInformations[unitTable.id].autoHealStatus)
    ctx.armyInformations[unitTable.id].isUnderAttack=false
    --Spring.Echo("try to create unit with these informations")
    Spring.SetUnitRotation(springUnit,0,-1*unitTable.orientation,0)
    
    -- update group units (team related)

    local teamIndex="team_"..tostring(unitTable.team)
    local typeIndex="type_"..tostring(unitTable.type)
    if(ctx.groupOfUnits[teamIndex]==nil) then
      ctx.groupOfUnits[teamIndex]={}
    end
    table.insert(ctx.groupOfUnits[teamIndex],unitTable.id)
    -- update group units (type related)
    if(ctx.groupOfUnits[typeIndex]==nil) then
      ctx.groupOfUnits[typeIndex]={}
    end
    table.insert(ctx.groupOfUnits[typeIndex],unitTable.id)

end

-------------------------------------
-- Indicate if the action is groupable, which means that
-- it can be applied to a group of units
-- add information in the action to facilitate manipulations of this action
-- return a boolean indicating if it's groupable
-------------------------------------
local function isAGroupableTypeOfAction(a)
 local groupable=true
 if(string.sub(a.type, 1, 5)=="type_") then
    a["cond_object"]="group" -- group is the generic thing
    a["attribute"]=string.sub(a.type, 6, -1)
 elseif(string.sub(a.type, 1, 5)=="unit_") then
    a["cond_object"]="unit"
    a["attribute"]=string.sub(a.type, 6, -1)
 elseif(string.sub(a.type, 1, 6)=="group_") then
    a["cond_object"]="group"
    a["attribute"]=string.sub(a.type, 7, -1)
  return a,true
 elseif(string.sub(a.type, 1, 5)=="team_") then
    a["cond_object"]="group"
    a["attribute"]=string.sub(a.type, 6, -1)
  else
    groupable=false
  end 
  return a,groupable
end

-------------------------------------
-- Apply a groupable action on a single unit
-------------------------------------
local function ApplyGroupableAction(unit,act)
  if(Spring.ValidUnitID(unit))then -- check if the unit is still on board
    Spring.Echo("valid")
    if(act.attribute=="transfer") then
      Spring.Echo("try to apply transfert")
      Spring.TransferUnit(unit,act.params.team)
    elseif(act.attribute=="kill")then
      Spring.DestroyUnit(unit)
    elseif(act.attribute=="hp")then
      local health,maxhealth=Spring.GetUnitHealth(unit)
      Spring.SetUnitHealth(unit,maxhealth*(act.params.percentage)/100)
    elseif(act.attribute=="teleport")then
      local posFound=extractPosition(act.params.position)
      Spring.SetUnitPosition(unit,posFound.x,posFound.z)
    elseif(act.attribute=="group")then
      table.insert(ctx.groupOfUnits["group_"..act.params.group],unit)
    elseif(act.attribute=="order")then
      Spring.GiveOrderToUnit(unit, act.params.command, act.params.parameters, {})
    elseif(act.attribute=="orderPosition")then
      local posFound=extractPosition(act.params.position)
      Spring.GiveOrderToUnit(unit, act.params.command,{posFound.x,Spring.GetGroundHeight(posFound.x, posFound.z),posFound.z}, {})
    elseif(act.attribute=="orderTarget")then
      local u=act.params.target
      local spUnit=ctx.armySpring[u]
      --Spring.GiveOrderToUnit(unit, act.params.command,{spUnit}, {})
      --Spring.GiveOrderToUnit(unit, CMD.FIRE_STATE, {0}, {})
      Spring.GiveOrderToUnit(unit,act.params.command, {spUnit}, {}) 
    end

    --Spring.GiveOrderToUnit(unit, CMD.ATTACK, {attacked}, {}) 
  end
end

-------------------------------------
-- Create an unit at a certain position
-- As side effects, the unit is added to various groups
-- One special group is also used in order to identify all the units
-- created by an action 
-------------------------------------
local function createUnitAtPosition(act,position)
    local y=Spring.GetGroundHeight(position.x,position.z)
    local spId= Spring.CreateUnit(act.params.unitType, position.x,y,position.z, "n",act.params.team)
    ctx.armySpring[act.name]=spId
    ctx.armyExternal[spId]=act.name
    -- ctx.armySpring[act.name] will be override each time this action is called
    -- this is on purpose as some actions can take the last unit created by this unit creation action
    local realId=act.name..tostring(ctx.globalIndexOfCreatedUnits)
    ctx.armySpring[realId]=spId 
    -- in order to keep to track of all created units
    ctx.globalIndexOfCreatedUnits=ctx.globalIndexOfCreatedUnits+1
    local gpIndex="group_"..act.name
    if(ctx.groupOfUnits[gpIndex]==nil) then
      ctx.groupOfUnits[gpIndex]={}
    end
    table.insert(ctx.groupOfUnits[gpIndex],realId)
    
    -- Nasty copy pasta from the other function to create unit

    local teamIndex="team_"..tostring(act.params.team)
    local typeIndex="type_"..tostring(act.params.unitType)
    if(ctx.groupOfUnits[teamIndex]==nil) then
      ctx.groupOfUnits[teamIndex]={}
    end
    table.insert(ctx.groupOfUnits[teamIndex],realId)
    -- update group units (type related)
    if(ctx.groupOfUnits[typeIndex]==nil) then
      ctx.groupOfUnits[typeIndex]={}
    end
    table.insert(ctx.groupOfUnits[typeIndex],realId)

    ctx.armyInformations[realId]={}
    ctx.armyInformations[realId]["health"]=Spring.GetUnitHealth(spId)
    ctx.armyInformations[realId]["previousHealth"]=Spring.GetUnitHealth(spId)
    ctx.armyInformations[realId]["autoHeal"] = UnitDefs[Spring.GetUnitDefID(spId)]["autoHeal"]
    ctx.armyInformations[realId]["idleAutoHeal"] = UnitDefs[Spring.GetUnitDefID(spId)]["idleAutoHeal"]
    ctx.armyInformations[realId]["autoHealStatus"]=(ctx.mission.description.autoHeal=="enabled")
    ctx.armyInformations[realId]["isUnderAttack"]=false
end

-------------------------------------
-- Apply a groupable action, generally not related to an unit
-------------------------------------
local function ApplyNonGroupableAction(act)
  if(act.type=="cameraAuto") then
    if(act.params.toggle=="enabled")then
      _G.cameraAuto = {
        enable = true,
        specialPositions = {} --TODO: minimap and special position géree dans les zones
      }
      SendToUnsynced("enableCameraAuto")
      _G.cameraAuto = nil
    else
      _G.cameraAuto = {
        enable = false,
        specialPositions = {} 
      }
      SendToUnsynced("disableCameraAuto")
      _G.cameraAuto = nil  
    end

  elseif(act.type=="mouse") then
    if(act.params.toggle=="enabled")then
      SendToUnsynced("mouseEnabled", true)
    else
      SendToUnsynced("mouseDisabled", true) 
    end
    
  elseif(act.type=="centerCamera") then
    local posFound=extractPosition(act.params.position)
    SendToUnsynced("centerCamera", json.encode(posFound))
   
  -- MESSAGES
  
  elseif(act.type=="messageGlobal") then
    Script.LuaRules.showMessage(getAMessage(act.params.message), false, 500)
    
   elseif (act.type=="messageUnit")or(act.type=="bubbleUnit") then
    --bubbleUnit
      local springUnitId=ctx.armySpring[act.params.unit]
      if Spring.ValidUnitID(springUnitId) then
        local factor=Spring.GetGameSpeed()
        --Spring.Echo("try to send : DisplayMessageAboveUnit")
        SendToUnsynced("DisplayMessageAboveUnit", json.encode({message=getAMessage(act.params.message),unit=springUnitId,time=act.params.time/factor,bubble=(act.type=="bubbleUnit")}))
        --[[
        local x,y,z=Spring.GetUnitPosition(springUnitId)
        Spring.MarkerAddPoint(x,y,z, getAMessage(act.params.message))
        local deletePositionAction={id=99,type="erasemarker",params={x=x,y=y,z=z},name="deleteMessageAfterTimeOut"} --to erase message after timeout
        AddActionInStack(deletePositionAction, secondesToFrames(act.params.time))--]]
      end
  elseif(act.type=="messagePosition") then
    --Spring.Echo("try to send : DisplayMessagePosition")
  --Script.LuaUI.DisplayMessageAtPosition(p.message, p.x, Spring.GetGroundHeight( p.x, p.z), p.z, p.time) 
    local factor=Spring.GetGameSpeed()
    local posFound=extractPosition(act.params.position)   
    local x=posFound.x
    local y=Spring.GetGroundHeight(posFound.x,posFound.z)
    local z=posFound.z
    SendToUnsynced("displayMessageOnPosition", json.encode({message=getAMessage(act.params.message),x=x,z=z,time=act.params.time/factor}))
    
    
   --[[ Spring.MarkerAddPoint(x,y,z, getAMessage(act.params.message))
    local deletePositionAction={id=99,type="erasemarker",params={x=x,y=y,z=z}} --to erase message after timeout
    AddActionInStack(deletePositionAction, secondesToFrames(act.params.time))
    --]]
     
  elseif(act.type=="erasemarker") then 
    Spring.MarkerErasePosition(act.params.x,act.params.y,act.params.z)
  
   -- WIN/LOSE
   
  elseif((act.type=="win")and(ctx.mission.teams[tostring(act.params.team)]["control"]=="player"))
      or((act.type=="lose")and(ctx.mission.teams[tostring(act.params.team)]["control"]=="computer"))then
    ctx.outputstate=act.params.outputState
    ctx.success=1
  -- Note : this is binary, it needs to be improved if multiplayer is enabled
  elseif((act.type=="lose")and(ctx.mission.teams[tostring(act.params.team)]["control"]=="player"))
      or((act.type=="win")and(ctx.mission.teams[tostring(act.params.team)]["control"]=="computer"))then
    ctx.outputstate=act.params.outputState
    ctx.success=-1
   
   -- VARIABLES
    
  elseif(act.type=="changeVariable")then
    ctx.variables[act.params.variable]=act.params.number   
  elseif(act.type=="changeVariableNumber")then
    ctx.variables[act.params.variable1]=makeOperation(ctx.variables[act.params.variable2],act.params.number,act.params.operator)   
  elseif(act.type=="setBooleanVariable")then
    ctx.variables[act.params.variable]=(act.params.boolean=="true")
  elseif(act.type=="changeVariableVariable")then
    ctx.variables[act.params.variable1]=makeOperation(ctx.variables[act.params.variable2],ctx.variables[act.params.variable3],act.params.operator)           
        
  elseif(act.type=="createUnitAtPosition") then
    --ctx.globalIndexOfCreatedUnits
    local posFound=extractPosition(act.params.position)
     createUnitAtPosition(act,posFound)
  elseif(act.type=="createUnitsInZone") then
    for var=1,act.params.number do
      local position=getARandomPositionInZone(act.params.zone)
      createUnitAtPosition(act,position)
    end 
  elseif(act.type=="changeVariableRandom") then
    local v=math.random(act.params.min,act.params.max)
    Spring.Echo("drawn variable")
    Spring.Echo(v)
    ctx.variables[act.params.variable]=v   
  elseif(act.type=="script") then
    load_code(act.params.script)
  end
end

-------------------------------------
-- The more general function to apply an action
-- according to its type (groupable or not) will be applied within another function
-- Handle group of units
-------------------------------------
function ApplyAction (a)
  --Spring.Echo("try to apply "..actionId)
  --Spring.Echo(json.encode(actions))
  Spring.Echo("we try to apply action :"..tostring(a.name))
  local a, groupable=isAGroupableTypeOfAction(a)
  --if(groupable)then
  if(groupable) then
    --extract units
    if(a.params.unit~=nil)then
      local u=ctx.armySpring[a.params.unit]
      ApplyGroupableAction(u,a)
    else   
      local tl={[1]={"currentTeam","team"},[2]={"team","team"},[3]={"unitType","type"},[4]={"group","group"}}
      local listOfUnits=extractListOfUnitsImpliedByCondition(a.params,tl)
      --Spring.Echo("we try to apply the groupable action to this group")
      --Spring.Echo(json.encode(listOfUnits))
      if(a.attribute=="transfer")then
        Spring.Echo("about to transfer")
        Spring.Echo(json.encode(listOfUnits))
      end
      
      if(listOfUnits~=nil)then
        for i, externalUnitId in ipairs(listOfUnits) do
          local unit=ctx.armySpring[externalUnitId]
          ApplyGroupableAction(unit,a)
          --
        end
      else
        Spring.Echo("no units available for this action")
      end
    end
  else
    ApplyNonGroupableAction(a)
  end   
end

-------------------------------------
-- Printing the stack of actions planned in time
-- For debugging purpose
-------------------------------------
local function printMyStack()
  for i,el in pairs(ctx.actionStack) do
    --Spring.Echo("action "..el.actId.." is planned with delay : "..el.delay)
  end
end 

-------------------------------------
-- Check if an action is already in the stack of actions
-------------------------------------
local function alreadyInStack(actId)
  for index,el in pairs(ctx.actionStack) do
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
function AddActionInStack(action, delSeconds)
  local delay=secondesToFrames(delSeconds)
  local element={}
  element["delay"]=delay
  element["action"]=action
  --Spring.Echo(actId.." is added with delay : "..delay)
  for index,el in pairs(ctx.actionStack) do
    local del=el.delay
    local act=el.actId
    if(del>delay) then
      table.insert(ctx.actionStack,index,element)
      return
    end
  end
  table.insert(ctx.actionStack,element)
end 

-------------------------------------
-- Update the stack by considering the time elapsed (in frames)
-- Actions get closer to be applied when time passes
-------------------------------------
local function updateStack(timeLapse)
  local updatedStack={}
  for index,el in pairs(ctx.actionStack) do
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
  for index,el in pairs(ctx.actionStack) do
    if(el.delay<0)then
      ApplyAction(el.action, nil)
      table.remove(ctx.actionStack,index)
    end
  end
end 

-------------------------------------
-- Units heal by themselves, which can be problematic
-- We let an option to override this principle
-- This function allows to cancel auto heal
-- for the units concerned by this option
-------------------------------------
local function watchHeal(frameNumber)
--attackedUnits
  -- for attacked TODO: for loop here and stuff
  for attacked,tableInfo in pairs(ctx.attackedUnits) do
    local idAttacked=ctx.armyExternal[attacked]
    if(idAttacked~=nil)and (ctx.armyInformations[idAttacked]~=nil)then
      --Spring.Echo(json.encode(tableInfo))
      if(tableInfo.frame==-1)then
        ctx.attackedUnits[attacked].frame=frameNumber
        ctx.armyInformations[idAttacked].isUnderAttack=true
        --Spring.Echo("under attack")
      elseif(frameNumber-tonumber(tableInfo.frame)<secondesToFrames(5))then
        ctx.armyInformations[idAttacked].isUnderAttack=true
        --Spring.Echo("still under attack")
      else
       -- Spring.Echo("no more under attack")
        ctx.armyInformations[idAttacked].isUnderAttack=false
      end
    end
  end
  for idUnit,infos in pairs(ctx.armyInformations) do
    local springUnit=ctx.armySpring[idUnit]
  -- ctx.armyInformations
    if(not infos.autoHealStatus)and(Spring.ValidUnitID(springUnit)) then
      --Spring.Echo("try to fix autoheal")
      --Spring.Echo(springUnit)
      local currentHealth = Spring.GetUnitHealth(springUnit)
      if currentHealth == infos.previousHealth+infos.autoHeal or currentHealth == infos.previousHealth+infos.idleAutoHeal then
        Spring.SetUnitHealth(springUnit, infos.previousHealth)
        
      else
        --if(currentHealth<infos.previousHealth)then
          --if updated too often this is not reliable (to fix)
          --infos.isUnderAttack=true
        --end
        infos.previousHealth = currentHealth
      end
    end
    ctx.armyInformations[idUnit]=infos
  end
end

-------------------------------------
-- If an event must be triggered, then shall be it
-- All the actions will be put in stack unless some specific options related to repetition
-- forbide to do so, such as allowMultipleInStack
-- this function as a side effect : it can create new actions (ex : to remove a message after a certain delay)
-------------------------------------
local function processEvents(frameNumber)
  local creationOfNewEvent=false
  local newevent
  for idEvent,event in pairs(ctx.events) do
    if isTriggerable(event) then
      if(event.lastExecution==nil)or((event.repetition~=nil and event.repetition~=false and frameNumber>event.lastExecution+secondesToFrames(tonumber(event.repetitionTime)))) then
        -- Handle repetition
        event.lastExecution=frameNumber
        local frameDelay=0
        Spring.Echo("try to apply the event with the following actions")
        Spring.Echo(json.encode(event.actions))          
        for j=1,table.getn(event.actions) do
          frameDelay=frameDelay+1
          local a=event.actions[j]
          if(a.type=="wait")then
            frameDelay=frameDelay+secondesToFrames(a.params.time) 
          elseif(a.type=="waitCondition")then
            creationOfNewEvent=true
            newevent=deepcopy(event)
            newevent["actions"]={}
            newevent.hasTakenPlace=false
            newevent.lastExecution=nil
            newevent.listOfInvolvedConditions={}
            table.insert(newevent.listOfInvolvedConditions,a.params.condition)   
            newevent.conditions={}
            newevent.id=tostring(frameNumber)
            newevent.conditions[a.params.condition..newevent.id]=ctx.conditions[a.params.condition..tostring(event.id)]
            --Spring.Echo("this event is created")
            --Spring.Echo(json.encode(newevent))                      
          else
            if creationOfNewEvent==false then
              AddActionInStack(a,frameDelay)
              Spring.Echo(a.name.." added to stack")
            else
              table.insert(newevent["actions"],a)
            end
          end
        end
        if creationOfNewEvent then
          ctx.events[tostring(frameNumber+100)]=newevent -- dirty trick to generate an unique id for this new event
          --Spring.Echo(json.encode(events))
        end
      end
    end
  end
end

-------------------------------------
-- wrapper for two main functions related to
-- the main operations on the game
-------------------------------------
local function  UpdateGameState(frameNumber)
  watchHeal(frameNumber)
  processEvents(frameNumber) 
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
-- Determine if an unit satisfies a condition
-- Two modes are possible depending on the mode of comparison (at least, at most ...)
-------------------------------------
local function UpdateConditionOnUnit (externalUnitId,c)--for the moment only single unit
  local internalUnitId=ctx.armySpring[externalUnitId]
  if(c.attribute=="dead") then --untested yet
    --Spring.Echo("is it dead ?")
    --Spring.Echo(externalUnitId)
    local alive=Spring.ValidUnitID(internalUnitId)
    --Spring.Echo(alive)
    return not(alive)
  elseif(Spring.ValidUnitID(internalUnitId)) then  -- 
  -- recquire that the unit is alive (unless the condition type is death, cf at the end of the function
    if(c.attribute=="zone") then
      local i=isUnitInZone(internalUnitId,c.params.zone)
     --[[Spring.Echo("we check an unit in a zone")
      Spring.Echo(internalUnitId)
      Spring.Echo(c.params.zone)
      if(i)then
        Spring.Echo("IN DA ZONE :")
        Spring.Echo(c.name)
      end
      if(i and c.name=="enterda")then
        Spring.Echo("condition validated")
      end--]]
      return i  
    elseif(c.attribute=="underAttack")then --untested yet
      --Spring.Echo("is it working")
      --Spring.Echo(ctx.armyInformations[externalUnitId].isUnderAttack)
      return ctx.armyInformations[externalUnitId].isUnderAttack
    elseif(c.attribute=="order") then
      local action=GetCurrentUnitAction(internalUnitId)     
      return (action==c.params.command) 
    elseif(c.attribute=="hp") then 
      local tresholdRatio=c.params.hp.number/100
      local health,maxhealth=Spring.GetUnitHealth(internalUnitId)
      return compareValue_Verbal(tresholdRatio*maxhealth,maxhealth,health,c.params.hp.comparison)
    end
  end
end

-------------------------------------
-- Update the truthfulness of a condition
-------------------------------------
local function UpdateConditionsTruthfulness (frameNumber)
  for idCond,c in pairs(ctx.conditions) do
    local object=c["object"]
    if(object=="unit")then
      ctx.conditions[idCond]["currentlyValid"]=UpdateConditionOnUnit(c.params.unit,c)
    elseif(object=="other")then  
      -- Time related conditions [START]
      if(c.type=="elapsedTime") then
      local elapsedAsFrame=math.floor(secondesToFrames(c.params.number.number))
      ctx.conditions[idCond]["currentlyValid"]= compareValue_Verbal(elapsedAsFrame,nil,frameNumber,c.params.number.comparison)  
      elseif(c.type=="repeat") then
        local framePeriod=secondesToFrames(c.params.number)
        ctx.conditions[idCond]["currentlyValid"]=((frameNumber-ctx.startingFrame) % framePeriod==0)
      elseif(c.type=="start") then
        ctx.conditions[idCond]["currentlyValid"]=(frameNumber==ctx.startingFrame)--frame 5 is the new frame 0
      -- Time related conditions [END]
      -- Variable related conditions [START]
      elseif(c.type=="variableVSnumber") then
        local v1=ctx.variables[c.params.variable]
        local v2=c.params.number
        ctx.conditions[idCond]["currentlyValid"]=compareValue_Numerical(v1,v2,c.params.comparison)   
      elseif(c.type=="variableVSvariable") then
        local v1=ctx.variables[c.params.variable1]
        local v2=ctx.variables[c.params.variable2]
        ctx.conditions[idCond]["currentlyValid"]=compareValue_Numerical(v1,v2,c.params.comparison)   
      elseif(c.type=="booleanVariable") then
        ctx.conditions[idCond]["currentlyValid"]=ctx.variables[c.params.variable] -- very simple indeed 
      end
      
    elseif(object=="group")then  
      local tl={[1]={"team","team"},[2]={"unitType","type"},[3]={"group","group"}}
      local externalUnitList=extractListOfUnitsImpliedByCondition(c.params,tl)
      local count=0
      local total=0
      if(externalUnitList~=nil)then
        total=table.getn(externalUnitList)
        --Spring.Echo(json.encode(externalUnitList))
        for u,unit in ipairs(externalUnitList) do
          if(UpdateConditionOnUnit(unit,c)) then
           count=count+1
          end 
        end
      end
      ctx.conditions[idCond]["currentlyValid"]= compareValue_Verbal(c.params.number.number,total,count,c.params.number.comparison)
    elseif(object=="killed")then 
      if((c.type=="killed_group")or(c.type=="killed_team")or(c.type=="killed_type"))then
        local tlkup={[1]={"targetTeam","team"},[2]={"unitType","type"},[3]={"group","group"}}
        local externalUnitList=extractListOfUnitsImpliedByCondition(c.params,tlkup)
        --Spring.Echo(json.encode(externalUnitList))
        local total=table.getn(externalUnitList)
        local count=0
        if(ctx.killByTeams[c.params.team]~=nil)then
          for u,unit in ipairs(externalUnitList) do
            local spUnit=ctx.armySpring[unit]
            for u2,killInformation in ipairs(ctx.killByTeams[c.params.team]) do
              if spUnit==killInformation.unitID then -- means a unit from the searched group has been found amongst killed units
                count=count+1
                break
              end
            end
          end
        end
        ctx.conditions[idCond]["currentlyValid"]= compareValue_Verbal(c.params.number.number,total,count,c.params.number.comparison)
      elseif (c.type=="killed_unit") then
        local numberOfKill=0
        if(ctx.killByTeams[c.params.team]~=nil)then
          local numberOfKill=table.getn(ctx.killByTeams[c.params.team])
        end
        ctx.conditions[idCond]["currentlyValid"]= compareValue_Verbal(c.params.number.number,nil,numberOfKill,c.params.number.comparison)
        -- For the moment the "killed all" is not implemented 
      elseif (c.type=="killed") then
        local found=false
        local targetedUnit=ctx.armySpring[c.params.unit]
        local kills=ctx.killByTeams[c.params.team]
        if(kills~=nil)then
          for u2,killInformation in ipairs(kills) do
            if targetedUnit==killInformation.unitID then -- means a unit from the searched group has been found amongst killed units
              ctx.conditions[idCond]["currentlyValid"]=true
              found=true
              break
            end
          end
        end
        if(not found)then ctx.conditions[idCond]["currentlyValid"]=false end 
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
  ctx.canUpdate=true
  --Spring.Echo(jsonName)
  --Spring.Echo("we try to decode"..jsonFile)
  ctx.mission=json.decode(jsonFile)
  
  -- desactivate widget
  -- This should be done ASAP
  for i=1, table.getn(ctx.mission.description.widgets) do
    local widgetName=ctx.mission.description.widgets[i].name
    local activation=ctx.mission.description.widgets[i].active
    SendToUnsynced("changeWidgetState", json.encode({widgetName=widgetName,activation=activation}))
  end 
  
  return true
end

local function returnEventsTriggered()
  local eventsTriggered={}
  for idEv,ev in pairs(ctx.events) do   
    if(ev.hasTakenPlace) then
      table.insert(eventsTriggered,idEv)
    end
  end
  return eventsTriggered
end

local function returnTestsToPlay()
  --Spring.Echo(json.encode(ctx.mission.tests))
  return ctx.mission.tests
end

-------------------------------------
-- Initialize the mission by parsing informations from the json
-- and process some datas
-- @todo This function does too many things
-------------------------------------
local function StartAfterJson ()
  -- Delete all the stuff (required as team kernel are placed by spring since the beginnning)
  

  --[[ 

 

  -- COMMENTED OUT for the moment, avoid unsage attempt to modify gamestate
  

  Spring.Echo("trééééééééééééééééé")
  local context = {}
  local uuu=1
  context.uuu = uuu
  context.Spring=Spring
  -- etc. add libraries/functions that are safe for your application.
  -- see: http://lua-users.org/wiki/SandBoxes
  load_code("uuu=uuu+1;Spring.Echo(uuu)", context)
  Spring.Echo(uuu)
  Spring.Echo(context.uuu)
   --]]
  
  local units = Spring.GetAllUnits()
  for i = 1,table.getn(units) do
    --Spring.Echo("I am Totally Deleting Stuff")
    Spring.DestroyUnit(units[i], false, true)
  end  
 
 local specialPositionTables={} 
 
 -------------------------------
 -------ZONES-------------------
 -------------------------------
 if(ctx.mission.zones~=nil)then   
  for i=1, table.getn(ctx.mission.zones) do
    local center_xz
     local cZ=ctx.mission.zones[i]
     local idZone=cZ.id
     if(cZ.type=="Disk") then
      center_xz={x=cZ.x, z=cZ.z}
      ctx.zones[idZone]={type="Disk",center_xz=center_xz,a=cZ.a,b=cZ.b}
     elseif(cZ.type=="Rectangle") then
      local demiLargeur=(cZ.x2-cZ.x1)/2
      local demiLongueur=(cZ.z2-cZ.z1)/2
      center_xz={x=cZ.x1+demiLargeur, z=cZ.z1+demiLongueur}
      ctx.zones[idZone]={type="Rectangle",center_xz=center_xz,demiLargeur=demiLargeur,demiLongueur=demiLongueur} 
     else
      Spring.Echo(cZ.type.." not implemented yet")
      end
    if(cZ.alwaysInView)then
      table.insert(specialPositionTables,{center_xz.x,center_xz.z})
    end 
    if(cZ.marker)then
      Spring.MarkerAddPoint(center_xz.x,Spring.GetGroundHeight(center_xz.x,center_xz.z),center_xz.z, cZ.name)
    end 
  end
end
 
 -------------------------------
 -------VARIABLES---------------
 -------------------------------
if(ctx.mission.variables~=nil)then
  for i=1,table.getn(ctx.mission.variables) do
    local missionVar=ctx.mission.variables[i]
    local initValue=missionVar.initValue
    local name=missionVar.name
    if(missionVar.type=="number") then
      initValue=initValue
    elseif(missionVar.type=="boolean") then
      initValue=(initValue=="true")
    end
    ctx.variables[name]=initValue
  end
end  
Spring.Echo(json.encode(ctx.variables))



  -- specialPositionTables[i]={positions[id].x,positions[id].z}
  -- 

 -------------------------------
 -------SETTINGS----------------
 -------------------------------
ctx.messages["briefing"]=ctx.mission.description.briefing
Spring.Echo(ctx.messages["briefing"])
--  if(mission.description.mouse=="disabled") then
--   SendToUnsynced("mouseDisabled", true)
--  end

if(ctx.mission.description.cameraAuto=="enabled") then
  _G.cameraAuto = {
    enable = true,
    specialPositions = specialPositionTables --TODO: minimap and special position géree dans les zones
  }
  SendToUnsynced("enableCameraAuto")
  _G.cameraAuto = nil
end
local isautoHealGlobal=(ctx.mission.description.autoHeal=="enabled")

 
 -------------------------------
 ----------ARMIES---------------
 -------------------------------
  local isAutoHeal
  if(ctx.mission.units~=nil)then
    for i=1,table.getn(ctx.mission.units) do
      local armyTable=ctx.mission.units[i]
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
  if(ctx.mission["groups"]~=nil) then
    for i=1, table.getn(ctx.mission.groups) do
      local groupname=ctx.mission.groups[i].name
      local groupIndex="group_"..groupname
      ctx.groupOfUnits[groupIndex]={}
      for i,unit in ipairs(ctx.mission.groups[i].units) do
        table.insert(ctx.groupOfUnits[groupIndex],unit)
      end
    end
  end 
  Spring.Echo(json.encode(ctx.groupOfUnits))
   


 ---------------------------------------------
 -------EVENTS  AND  CONDITIONS--------------
 ---------------------------------------------
if(ctx.mission.events~=nil)then
    for i=1, table.getn(ctx.mission.events) do
     local currentEvent=ctx.mission.events[i]
     local idEvent=ctx.mission.events[i].id
     ctx.events[idEvent]={}
     ctx.events[idEvent]=ctx.mission.events[i]
     ctx.events[idEvent].hasTakenPlace=false
     ctx.events[idEvent].listOfInvolvedConditions={}
     for j=1, table.getn(currentEvent.conditions)do
       local currentCond=currentEvent.conditions[j]
       local id=currentCond.name
       table.insert(ctx.events[idEvent].listOfInvolvedConditions,id)
       ctx.conditions[id..tostring(ctx.events[idEvent].id)]=currentEvent.conditions[j]
       ctx.conditions[id..tostring(ctx.events[idEvent].id)]["currentlyValid"]=false
       local type=currentCond.type
       local cond_object="other"
       local attribute=type
       if(string.sub(type, 1, 5)=="type_") then
        cond_object="group" -- group is the generic thing
        attribute=string.sub(type, 6, -1)
       elseif(string.sub(type, 1, 6)=="killed") then
        cond_object="killed" -- very special group (not working like others)
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
      ctx.conditions[id..tostring(ctx.events[idEvent].id)]["object"]=cond_object
      ctx.conditions[id..tostring(ctx.events[idEvent].id)]["attribute"]=attribute
    end 
  end
end







 --[[  
   
   -------------------------------
   -------START------------------
   -------------------------------   
  
  --Spring.DestroyUnit(ctx.armySpring["ahah"],false,false)
  
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
  UpdateGameState(frameNumber)
  ctx.actionStack=updateStack(1)
  applyCurrentActions() 
  if(frameNumber>10)then ctx.recordCreatedUnits=true end

  if(ctx.success==1) then
    return ctx.success,ctx.outputstate
  elseif(ctx.success==-1) then
    return ctx.success,ctx.outputstate
  else
    return 0 -- means continue
  end
  -- Trigger Events
end  
  
  
  
  
  
  --[[
  if(not ctx.canUpdate)then
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
    if(ctx.success~=nil) then
      return ctx.success,outputstate
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
end

function gadget:RecvLuaMsg(msg, player)
  if((msg~=nil)and(string.len(msg)>4)and(string.sub(msg,1,4)=="kill")) then
    -- comes from mission runner unit destroyed
    -- local killTable={unitID=unitID, unitDefID=unitDefID, unitTeam=unitTeam, attackerID=attackerID, attackerDefID=attackerDefID, attackerTeam=attackerTeam}
    -- is encoded
    local jsonfile=string.sub(msg,5,-1)
    local killTable=json.decode(jsonfile)
    local attackerTeam=killTable.attackerTeam
    if ctx.killByTeams[attackerTeam]==nil then
      ctx.killByTeams[attackerTeam]={} 
    end
    table.insert(ctx.killByTeams[attackerTeam],killTable)
    Spring.Echo(json.encode(ctx.killByTeams))
    --Spring.Echo(json.encode(ctx.killByTeams))
  elseif((msg~=nil)and(string.len(msg)>4)and(string.sub(msg,1,6)=="damage")) then
    -- comes from mission runner unit destroyed
    -- local killTable={unitID=unitID, unitDefID=unitDefID, unitTeam=unitTeam, attackerID=attackerID, attackerDefID=attackerDefID, attackerTeam=attackerTeam}
    -- is encoded
    --Spring.Echo("damage received")
    local jsonfile=string.sub(msg,7,-1)
    local damageTable=json.decode(jsonfile)
    local attackedUnit=damageTable.attackedUnit
    damageTable.frame=tonumber(damageTable.frame)
    if ctx.attackedUnits[attackedUnit]==nil then
      ctx.attackedUnits[attackedUnit]={} 
    end
    ctx.attackedUnits[attackedUnit]=damageTable
    --Spring.Echo(json.encode(attackedUnits))
    
  elseif((msg~=nil)and(string.len(msg)>4)and(string.sub(msg,1,12)=="unitCreation")) then
    if(ctx.recordCreatedUnits)then -- this avoid to store starting bases in the tables
      local jsonfile=string.sub(msg,13,-1)
      Spring.Echo(jsonfile)
      local creationTable=json.decode(jsonfile)
      -- {unitID=unitID,unitDefID=unitDefID, unitTeam=unitTeam,factID=factID,factDefID=factDefID,userOrders=userOrders}
      --local attackedUnit=damageTable.attackedUnit
      local teamIndex="team_"..tostring(creationTable.unitTeam)
      local typeIndex="type_"..tostring(UnitDefs[creationTable.unitDefID].name)
      ctx.globalIndexOfCreatedUnits=ctx.globalIndexOfCreatedUnits+1
      local realId="createdUnit"..tostring(ctx.globalIndexOfCreatedUnits)
      ctx.armySpring[realId]=creationTable.unitID 
      Spring.Echo("this unit is created")
      Spring.Echo(creationTable.unitID)
      if(ctx.groupOfUnits[teamIndex]==nil) then
        ctx.groupOfUnits[teamIndex]={}
      end
      local isAlreadyStored=false
      for i = 1,table.getn(ctx.groupOfUnits[teamIndex]) do
        if(realId==ctx.groupOfUnits[teamIndex][i]) then isAlreadyStored=true end
      end
      if(not isAlreadyStored)then   
        table.insert(ctx.groupOfUnits[teamIndex],realId)
      end
      -- update group units (type related)
      if(ctx.groupOfUnits[typeIndex]==nil) then
        ctx.groupOfUnits[typeIndex]={}
      end
      table.insert(ctx.groupOfUnits[typeIndex],realId)
    end 
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

ctx.load_code=load_code ; ctx.intersection=intersection ; ctx.compareValue_Verbal=compareValue_Verbal ; ctx.compareValue_Numerical=compareValue_Numerical ; ctx.makeOperation=makeOperation ; ctx.deepcopy=deepcopy ; ctx.secondesToFrames=secondesToFrames ; ctx.getFactionCode=getFactionCode ; ctx.boolAsString=boolAsString ; ctx.getAMessage=getAMessage ; ctx.isXZInsideZone=isXZInsideZone ; ctx.isUnitInZone=isUnitInZone ; ctx.getARandomPositionInZone=getARandomPositionInZone ; ctx.extractPosition=extractPosition ; ctx.writeLetter=writeLetter ; ctx.writeSign=writeSign ; ctx.showMessage=showMessage ; ctx.ShowBriefing=ShowBriefing ; ctx.isTriggerable=isTriggerable ; ctx.extractListOfUnitsImpliedByCondition=extractListOfUnitsImpliedByCondition ; ctx.createUnit=createUnit ; ctx.isAGroupableTypeOfAction=isAGroupableTypeOfAction ; ctx.ApplyGroupableAction=ApplyGroupableAction ; ctx.createUnitAtPosition=createUnitAtPosition ; ctx.ApplyNonGroupableAction=ApplyNonGroupableAction ; ctx.ApplyAction=ApplyAction ; ctx.printMyStack=printMyStack ; ctx.alreadyInStack=alreadyInStack ; ctx.AddActionInStack=AddActionInStack ; ctx.updateStack=updateStack ; ctx.applyCurrentActions=applyCurrentActions ; ctx.watchHeal=watchHeal ; ctx.processEvents=processEvents ; ctx.GetCurrentUnitAction=GetCurrentUnitAction ; ctx.UpdateConditionOnUnit=UpdateConditionOnUnit ; ctx.UpdateConditionsTruthfulness=UpdateConditionsTruthfulness ; ctx.writeCompassOnUnit=writeCompassOnUnit ; ctx.parseJson=parseJson ; ctx.returnEventsTriggered=returnEventsTriggered ; ctx.returnTestsToPlay=returnTestsToPlay ; ctx.StartAfterJson=StartAfterJson ; ctx.Start=Start ; ctx.Update=Update ; ctx.Stop=Stop ;
ctx.Spring=Spring 

return Mission
