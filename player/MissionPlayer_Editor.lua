------------------
-- this module play generic missions encoded in a json data format
-- @module MissionPlayer
-- ----------------
--
local maxHealth, tmp
local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local lang = Spring.GetModOptions()["language"] -- get the language
VFS.Include("LuaUI/Widgets/libs/MiscCommon.lua")

local ctx={}
--ctx is a table containing main variables and functions (cf end of file). 
--ctx passed as a "context" when loading custom code from the user (script actions). 
--This way, the user can get and set values related to the game 

ctx.debugLevel=0 -- in order to filter Spring Echo between 0 (all) and 10 (none)

--Table to associate local unit id (number or string) used in this file with unit Spring Id (number)
ctx.getSpringIdFromLocalUnitId={} -- -> {string|number localUnitId = number SpringId, ...}

--Table to associate unit Spring Id (number) with local unit id (number or string) used in this file
ctx.getLocalUnitIdFromSpringId={} -- -> {number SpringId = string|number localUnitId, ...}

--Table to store group of available units. A localIdGroup could be for exemple "team_0", "group_3", "action_12"... and an localUnitId is a number or a string used to find unit Spring Id through ctx.getSpringIdFromLocalUnitId
ctx.getAvailableLocalUnitIdsFromLocalGroupId={} -- -> {string localIdGroup = [string|number localUnitId, ...], ...}

--Same as ctx.getAvailableLocalUnitIdsFromLocalGroupId except that we keep units destroyed (usefull to count kills)
ctx.getAllLocalUnitIdsFromLocalGroupId={} -- -> {string localIdGroup = [string|number localUnitId, ...], ...}

--table to store information on units
ctx.armyInformations={}-- -> {string|number localUnitId = {"health" = number, "previousHealth" = number, "autoHeal" = number, "idleAutoHeal" = number, "autoHealStatus" = boolean, "isUnderAttack" = boolean, "isAttacking" = boolean}, ...}

--associative array messageId->message type
ctx.messages={}-- -> {string messageId = string messageContent, ...}

--associative array idCond->condition. The "type" of a condition is one of the ones defined in Conditions.lua. The "params" of a condition depends on its "type".
ctx.conditions={}-- -> {string conditionId = {"id" = number, "type" = string, "name" = string, "params" = table, "currentlyValid" = boolean, "object" = "killed" | "kill" | "group" | "other"}, ...}

ctx.nextUniqueIdCondition = 0 --useful to set unique Id to condition created dynamically (see waitCondition and waitTrigger)
ctx.nextUniqueIdEvent = 0 --useful to set unique Id to event created dynamically (see waitCondition and waitTrigger)

--associative array idEvent->event
ctx.events={}-- -> {string evenId = {"id" = number, "name" = string, "comment" = string, "repetition" = boolean, "repetitionTime" = string, "lastExecution" = number, "trigger" = string, "conditionTotal" = number, "conditions" = table, "actionTotal" = number, "actions" = table, "listOfInvolvedConditions" = {[1] = string conditionName, ...}}, ...}

--associative array order->idEvent
ctx.orderedEventsId={} -- -> { [1] = number eventId, ... }

--associative array variable->value. Need to be global so that it can be updated by using loadstring
ctx.variables={}-- -> { string variableName = number|boolean, ... }

--associative array idZone->zone
ctx.zones={}-- -> { number id = {"type" = "Disk", "center_xz" = {"x" = number, "z" = number}, "a" = number, "b" = number} | {"type" = "Rectangle", "center_xz" = {"x" = number, "z" = number}, "demiLargeur" = number, "demiLongueur" = number}, ... }

--store the last unit killed by a killer. "killer" and "unitKilled" are local unit Id and not Spring unitd id.
ctx.kills={}-- -> { string|number killer = string|number unitKilled, ... }

ctx.timeUntilPeace=5 -- how much time in seconds of inactivity to declare that an attack is no more

--list of units under attack and data associated. "attackedUnit" and "attackerID" refer to Spring unit ids. Note: springId == ctx.attackedUnits[springId].attackedUnit
ctx.attackedUnits={}-- -> { number SpringUnitId = { "attackedUnit" = number, "damage" = number, "attackerID" = number, "frame" = number }, ... }

--list of units attacking another unit and data associated. "attackedUnit" and "attackerID" refer to Spring unit ids. Note: springId == ctx.attackingUnits[springId].attackerID
ctx.attackingUnits={}-- -> { number SpringUnitId = { "attackedUnit" = number, "damage" = number, "attackerID" = number, "frame" = number }, ... }

ctx.recordCreatedUnits=false --flag to know when mission is initialized (all initial units have been created)

--action to be applied on game state, allows to handle table composed by the indexes delay and actId
ctx.actionStack={}-- -> { [1] = {"action" = table, "delay" = number}, ... }

--when this global variable change (with event of type "end"), the game ends (= victory or defeat) for a given team
ctx.gameOver={} -- {number teamId = {"victoryState" = string "won"|"lost", "outputstate"=number}, ...}

--the full json describing the mission
ctx.mission=nil-- -> { "desciption" = table, "zones" = table, "units" = table, "allyteams" = table, "groups" = table, "listOfUnitTypes" = table, "variables" = table, "teams" = table, "events" = table, "listOfCommands" = table }

ctx.startingFrame=5 -- added delay before starting game. Used to avoid counting twice units placed at start

ctx.globalIndexOfCreatedUnits=0 -- count the number of created units. Both in-game (constructor) and event-related (action of creation) 

ctx.speedFactor=1 -- placeHolder to store current speed

-- Brainless copy-pasta from http://lua-users.org/wiki/SortedIteration, 
-- in order to sort events by order of execution
-- 1/3
local function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

-- Brainless copy-pasta from http://lua-users.org/wiki/SortedIteration, 
-- in order to sort events by order of execution
-- 2/3
local function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

-- Brainless copy-pasta from http://lua-users.org/wiki/SortedIteration, 
-- in order to sort events by order of execution
-- 3/3
local function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end


local function EchoDebug(message,level)
  local level=level or 10
  if(level >= ctx.debugLevel)then
    Spring.Echo(message)
  end
end

-------------------------------------
-- Load codegiven an environnement (table of variables that can be accessed and changed)
-- This function ensure compatibility (setfenv is dropped from lua 5.2)
-- Shamelessly taken from http://stackoverflow.com/questions/9268954/lua-pass-context-into-loadstring
-------------------------------------
local function load_code(code)
    if setfenv and loadstring then
        local f, err = loadstring(code) -- Lua 5.1
		if f then
			setfenv(f,ctx)
		end
        return f
    else
        local f = load(code, nil,"t",ctx) -- Lua 5.2 and later
        return f
    end
end

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
  return inters
end

-- warning, if intersection is non void, duplicates will occur.
local function union(list1,list2)
  local union={}
  if (list1~=nil) then
    for i,el in pairs(list1)do
      table.insert(union,el)
    end
  end  
  if (list2~=nil) then
    for i,el in pairs(list2)do
      table.insert(union,el)
    end
  end
  return union
end

-- must give a number, string under the form of "8", "3" or v1+v2-3
-- return a number
local function computeReference(expression)
  if(expression==nil or expression=="") then return 0 end
  --EchoDebug("compute expression : "..expression, 1)
  local n1=tonumber(expression)
  if(n1~=nil)then return n1 end

  for v,value in pairs(ctx.variables)do
    expression=replaceVariableInExpression(expression, v, tostring(value))
  end
  --EchoDebug("expression before execution : "..expression, 1)
  local executableStatement="return("..expression..")"
  local success, result = pcall(load_code(executableStatement))
  if success then
	if result ~= nil then
		return result
	else
		Spring.Echo ("Warning!!! expression \""..expression.."\" return nil value. 0 is returned instead")
		return 0
	end
  else
	Spring.Echo ("Warning!!! expression \""..expression.."\" is not a valid expression: "..(result or "nil"))
	return 0
  end
end

-------------------------------------
-- Compare an expression to a numerical value, a verbal "mode" being given 
-- @return boolean
-------------------------------------
local function compareValue_Verbal(reference,maxRef,value,mode)
	--EchoDebug(json.encode{reference,maxRef,value,mode},1)
	reference=computeReference(reference)
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
  v1 = tonumber(v1)
  v2 = tonumber(v2)
  if(mode==">") then return v1>v2  end
  if(mode==">=")then return v1>=v2 end
  if(mode=="<") then return v1<v2  end
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
      --EchoDebug("division by 0 replaced by division by 1",4)
      return v1
    end
  if(operation=="%")then return v1 - math.floor(v1/v2)*v1 end
end

-------------------------------------
-- Deep copy of tables 
-- @return table
-------------------------------------
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
  return delaySec*30 -- As game simulation frame is updated 30 times by seconds
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
colorTable = { -- associative table between a number and its character
"\0","\1","\2","\3","\4","\5","\6","\7","\8","\9","\10","\11","\12","\13","\14","\15","\16","\17","\18","\19","\20","\21","\22","\23","\24","\25","\26","\27","\28","\29","\30","\31","\32","\33","\34","\35","\36","\37","\38","\39","\40","\41","\42","\43","\44","\45","\46","\47","\48","\49","\50","\51","\52","\53","\54","\55","\56","\57","\58","\59","\60","\61","\62","\63","\64","\65","\66","\67","\68","\69","\70","\71","\72","\73","\74","\75","\76","\77","\78","\79","\80","\81","\82","\83","\84","\85","\86","\87","\88","\89","\90","\91","\92","\93","\94","\95","\96","\97","\98","\99","\100","\101","\102","\103","\104","\105","\106","\107","\108","\109","\110","\111","\112","\113","\114","\115","\116","\117","\118","\119","\120","\121","\122","\123","\124","\125","\126","\127","\128","\129","\130","\131","\132","\133","\134","\135","\136","\137","\138","\139","\140","\141","\142","\143","\144","\145","\146","\147","\148","\149","\150","\151","\152","\153","\154","\155","\156","\157","\158","\159","\160","\161","\162","\163","\164","\165","\166","\167","\168","\169","\170","\171","\172","\173","\174","\175","\176","\177","\178","\179","\180","\181","\182","\183","\184","\185","\186","\187","\188","\189","\190","\191","\192","\193","\194","\195","\196","\197","\198","\199","\200","\201","\202","\203","\204","\205","\206","\207","\208","\209","\210","\211","\212","\213","\214","\215","\216","\217","\218","\219","\220","\221","\222","\223","\224","\225","\226","\227","\228","\229","\230","\231","\232","\233","\234","\235","\236","\237","\238","\239","\240","\241","\242","\243","\244","\245","\246","\247","\248","\249","\250","\251","\252","\253","\254","\255"
}
local function getAMessage(messageTable) 
  local msg
  if(messageTable[1]==nil) then
    msg = messageTable
  else
    msg = messageTable[math.random(#messageTable)]
  end
  msg = string.gsub(msg, "\\n", "\n")
  msg = string.gsub(msg, "\\t", "\t")
  -- manage colors
  for i = 255, 0, -1 do
	msg = string.gsub(msg, "\\"..i, colorTable[i+1])
  end
  return msg
end

-------------------------------------
-- Indicates if a point is inside a zone (disk or rectangle).
-- If borderException is not nil => consider position into the border outside the zone
-- @return boolean
-------------------------------------
local function isXZInsideZone(x,z,zoneId, borderException)
  local zone=ctx.zones[zoneId]
  if(zone==nil)then
    --EchoDebug(string.format("%s not found. ZoneLists : %s",zoneId,json.encode(ctx.zones)),5)
  end
  if(zone.type=="Rectangle") then
    local center_x=zone.center_xz.x
    local center_z=zone.center_xz.z
    if(center_x+zone.demiLargeur-(borderException or 0)<x)then return false end -- uncommon formatting but multiline looks better IMHO
    if(center_x-zone.demiLargeur+(borderException or 0)>x)then return false end
    if(center_z+zone.demiLongueur-(borderException or 0)<z)then return false end
    if(center_z-zone.demiLongueur+(borderException or 0)>z)then return false end
    return true
  elseif(zone.type=="Disk") then
    local center_x=zone.center_xz.x
    local center_z=zone.center_xz.z
    local apart=((center_x-x)*(center_x-x))/((zone.a-(borderException or 0))*(zone.a-(borderException or 0)))
    local bpart=((center_z-z)*(center_z-z))/((zone.b-(borderException or 0))*(zone.b-(borderException or 0)))
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
-- @return table with x,z attributes 
-------------------------------------
local function getARandomPositionInZone(idZone)
  if(ctx.zones[idZone]~=nil) then
    local zone=ctx.zones[idZone]
    local posit={}
    local center_x=zone.center_xz.x
    local center_z=zone.center_xz.z
	local borderException = 10 -- we avoid to get random position closer to the border (resolve bug when we ask to move a unit on a random position in a zone, if the position is on the border the unit risks to not enter in the zone. Then a condition testing the entrance of the unit into the zone will be never evaluated to true.
    if(zone.type=="Disk") then
	  -- if zone is to small to take into account the borderException, we use its center
	  local rayonA = zone.a <= borderException and 0 or zone.a - borderException -- <=> (zone.a <= borderException) ? 0 : zone.a - borderException;
	  local rayonB = zone.b <= borderException and 0 or zone.b - borderException -- <=> (zone.b <= borderException) ? 0 : zone.b - borderException;
      while true do -- rejection method to draw random points from ellipse (drawn from rectangle and accepted if inside ellipse
        local x=math.random(center_x-rayonA, center_x+rayonA)
        local z=math.random(center_z-rayonB, center_z+rayonB)
        if(isXZInsideZone(x,z,idZone, borderException))then
          posit["x"]=x
          posit["z"]=z
          return posit
        end
      end
    elseif(zone.type=="Rectangle") then
	  -- if zone is to small to take into account the borderException, we use its center
	  local demiLargeur = zone.demiLargeur <= borderException and 0 or zone.demiLargeur - borderException -- <=> (zone.demiLargeur <= borderException) ? 0 : zone.demiLargeur - borderException;
	  local demiLongueur = zone.demiLongueur <= borderException and 0 or zone.demiLongueur - borderException -- <=> (zone.demiLongueur <= borderException) ? 0 : zone.demiLongueur - borderException;
      local x=math.random(center_x-demiLargeur, center_x+demiLargeur)
      local z=math.random(center_z-demiLongueur, center_z+demiLongueur)
      posit["x"]=x
      posit["z"]=z
      return posit
    end 
  end   
end

-------------------------------------
-- Extract position from parameters
-- Sometimes a zone is given and getARandomPositionInZone will be called
-------------------------------------
local function extractPosition(tablePosOrMaybeJustZoneId)
  if(type(tablePosOrMaybeJustZoneId)=="number")then
    return getARandomPositionInZone(tablePosOrMaybeJustZoneId)
  else
    return tablePosOrMaybeJustZoneId
  end
end

-------------------------------------
-- Show Briefing, this function can be called from outside
-- For this reason all the json files must have a message with id BRIEFING
-------------------------------------
local function ShowBriefing ()
  local briefingTxt = ctx.messages["briefing"] -- convention all json files have briefing attribute
  if briefingTxt and briefingTxt ~= "" then
	Script.LuaRules.showMessage(extractLang(briefingTxt, lang), false, 500)
  end
end

local function registerUnit(springId,localUnitId,reduction,autoHeal)
    ctx.getSpringIdFromLocalUnitId[localUnitId]=springId
    ctx.getLocalUnitIdFromSpringId[springId]=localUnitId
    -- default values if not given
    local reduction=reduction or 1
    local autoHeal=autoHeal or (ctx.mission.description.autoHeal=="enabled")
    
    ctx.armyInformations[localUnitId]={}
    local h=Spring.GetUnitHealth(springId)*reduction
    ctx.armyInformations[localUnitId].health=h
    if(reduction~=1)then
      Spring.SetUnitHealth(springId,h)
    end
    ctx.armyInformations[localUnitId].previousHealth=ctx.armyInformations[localUnitId].health
    ctx.armyInformations[localUnitId].autoHeal = UnitDefs[Spring.GetUnitDefID(springId)]["autoHeal"]
    ctx.armyInformations[localUnitId].idleAutoHeal = UnitDefs[Spring.GetUnitDefID(springId)]["idleAutoHeal"]
    ctx.armyInformations[localUnitId].autoHealStatus=autoHeal
    --EchoDebug(ctx.armyInformations[localUnitId].autoHealStatus, 7)
    ctx.armyInformations[localUnitId].isUnderAttack=false
    ctx.armyInformations[localUnitId].isAttacking=false
end

local function isInGroup(localUnitId,gp,testOnLocalIds)
  --EchoDebug("is in group ->"..json.encode(gp),0)
  local isAlreadyStored=false
  if(gp==nil)then
    --EchoDebug("group is nil in function isInGroup, this should not occur",1)
    return false, nil
  end
  if(testOnLocalIds)then
    for i = 1,table.getn(gp) do
      if(localUnitId==gp[i]) then return true,i end
    end
  else
    local spId=ctx.getSpringIdFromLocalUnitId[localUnitId]
    for i = 1,table.getn(gp) do
      if(spId==ctx.getSpringIdFromLocalUnitId[gp[i]]) then return true,i end
    end    
  end
  return false,nil
end

-- Get all groups in which the unit is included
local function getGroupsOfUnit(localUnitId, testOnLocalIds, groupToCheck)
  local groupToCheck = groupToCheck or ctx.getAvailableLocalUnitIdsFromLocalGroupId
  local groups={}
  for indexGroup,g in pairs(groupToCheck)do
    local inGp,_ = isInGroup(localUnitId,g,testOnLocalIds)
    if(inGp)then
      table.insert(groups,indexGroup)
    end
  end
  table.insert(groups, "unit_"..localUnitId)
  return groups
end
 
local function removeUnitFromGroups(localUnitId,groups,testOnLocalIds)
  local testOnLocalIds=testOnLocalIds or true 
  for g,group in pairs(groups) do
    if(ctx.getAvailableLocalUnitIdsFromLocalGroupId[group]~=nil) then 
      local _,i=isInGroup(localUnitId,ctx.getAvailableLocalUnitIdsFromLocalGroupId[group],testOnLocalIds)
      if(i~=nil)then table.remove(ctx.getAvailableLocalUnitIdsFromLocalGroupId[group],i) end
    end
  end
end

local function addUnitToGroups_groupToStoreSpecified(localUnitId,groups,testOnLocalIds,groupToStore)
  local testOnLocalIds=testOnLocalIds or true 
  -- usefull to check redundancy at a deeper level because, when it comes about unit creation
  -- units can have a different external id (e.g "Action1_0","createdUnit_1") for the same spring id  
  for g,group in pairs(groups) do
      -- create group if not existing
    if(groupToStore[group]==nil) then
      groupToStore[group]={}
    end   
    -- store in group if not already stored
    local isAlreadyStored,_=isInGroup(localUnitId,groupToStore[group],testOnLocalIds)
    if(not isAlreadyStored)then   
      table.insert(groupToStore[group],localUnitId)
    end
  end
end

-- add Unit to specified groups
-- side effect : add the unit to the overarching group : "team_all".
local function addUnitToGroups(localUnitId,groups,testOnLocalIds)
  table.insert(groups,"team_all")
  addUnitToGroups_groupToStoreSpecified(localUnitId,groups,testOnLocalIds,ctx.getAvailableLocalUnitIdsFromLocalGroupId)
  addUnitToGroups_groupToStoreSpecified(localUnitId,groups,testOnLocalIds,ctx.getAllLocalUnitIdsFromLocalGroupId)
end  

local function addUnitsToGroups(units,groups,testOnLocalIds)
  for u,unit in pairs(units) do
    addUnitToGroups(unit,groups,testOnLocalIds)
  end
end

local function unitSetParamsToUnitsExternal(param)
  local index = param.type..'_'..tostring(param.value)
  local units = ctx.getAvailableLocalUnitIdsFromLocalGroupId[index]
  --if(ctx.getAvailableLocalUnitIdsFromLocalGroupId[index] == nil)then
  --  EchoDebug("warning. This index gave nothing : "..index,7)
  --end
  return units
end

-------------------------------------
-- Check if a condition, expressed as a string describing boolean condition where variables
-- are related to conditions in the json files.
-------------------------------------
local function isTriggerable(event)
  --EchoDebug(json.encode(ctx.conditions), 7)
  local trigger=event.trigger
  if(trigger=="")then   -- empty string => create trigger by cunjunction (ands) of all conditions
  -- step 1 : write the trigger
    for c,cond in pairs(event.listOfInvolvedConditions) do
      trigger=trigger..cond.." and "
    end
    trigger=string.sub(trigger,1,-5) -- drop the last "and"
  end
  --EchoDebug("isTriggerable (before replacement) => "..trigger, 7)
  for c,cond in pairs(event.listOfInvolvedConditions) do
    -- second step : conditions are replaced to their boolean values.
	--EchoDebug("look for condition: "..cond.."_"..tostring(event.id).. " in "..json.encode(ctx.conditions), 7)
    local valueCond=ctx.conditions[cond.."_"..tostring(event.id)]
    trigger=replaceConditionInTrigger(trigger, cond, boolAsString(valueCond["currentlyValid"]))
	--EchoDebug("isTriggerable (after replacement) => "..trigger, 7)
  end
  -- third step : turn the string in return statement
  local executableStatement="return("..trigger..")"
  local f = loadstring(executableStatement)
   -- fourth step : loadstring is used to create the function.
  return(f())
end

-------------------------------------
-- Extract the list of units related to a condition or an action
-- If we are in the context of action, it's possible that a list
-- has already been compiled from previous condition checking process
-- in this case, units_extracted is an index for this list
-------------------------------------
local function extractListOfUnitsInvolved(actOrCond_Params,groupToCheck)
  local groupToCheck = groupToCheck or ctx.getAvailableLocalUnitIdsFromLocalGroupId
  --EchoDebug("debug : "..tostring(id), 1)
  --EchoDebug("extract process", 1)
  --EchoDebug(json.encode(actOrCond_Params), 1)
  --EchoDebug(json.encode(ctx.getAvailableLocalUnitIdsFromLocalGroupId), 1)
  
  if(actOrCond_Params["units_extracted"]~=nil)then 
  -- when units_extracted exists, this means we are in the context of action.
  -- and that uniset has been set at the moment of the execution of the event
    return actOrCond_Params["units_extracted"]
  end
  
  local groupToReturn={}
  if(actOrCond_Params.unitset~=nil)then
     -- gives something like action_1, condition_3, groupe_2, team_0*
     if (actOrCond_Params.unitset.type=="unit") then
      groupToReturn={actOrCond_Params.unitset.value}
      --EchoDebug(json.encode({actOrCond_Params,groupToReturn}),2)
     else
       local index=actOrCond_Params.unitset.type..'_'..tostring(actOrCond_Params.unitset.value)
       --if(groupToCheck[index]==nil)then
       --  EchoDebug("warning. This index gave nothing : "..index, 2)
       --end
       groupToReturn=groupToCheck[index]
     end
  end
  return groupToReturn
end

-------------------------------------
-- Create unit according informations stored in a table
-- Also add unit in group tables (team, type) 
-------------------------------------
local function createUnit(unitTable)
  local posit=unitTable.position
  local localUnitId=unitTable.id
  local springId=Spring.CreateUnit(unitTable.type, posit.x, posit.y,posit.z, "n", unitTable.team)
  local reduction=(unitTable.hp/100) 
  registerUnit(springId,localUnitId,reduction,unitTable.autoHeal)
  --EchoDebug("try to create unit with these informations", 7)
  Spring.SetUnitRotation(springId,0,-1*unitTable.orientation,0)
  local teamIndex="team_"..tostring(unitTable.team)
  addUnitToGroups(localUnitId,{teamIndex}) 
end

-------------------------------------
-- Indicate if the action is groupable, which means that
-- it can be applied to a group of units
-- add information in the action to facilitate manipulations of this action
-- return a boolean indicating if it's groupable
-------------------------------------
local function isAGroupableTypeOfAction(a)
 local groupable=(a.params.unitset~=nil)
  return a,groupable
end

-------------------------------------
-- Apply a groupable action on a single unit
-------------------------------------
local function ApplyGroupableAction_onSpUnit(unit,act)
  if(Spring.ValidUnitID(unit))then -- check if the unit is still on board
    --EchoDebug("valid", 7)
    if(act.type=="transfer") then
      --EchoDebug("try to apply transfert", 7)
      Spring.TransferUnit(unit,act.params.team)
      addUnitToGroups(ctx.getLocalUnitIdFromSpringId[unit],{"team_"..tostring(act.params.team)}) 
    elseif(act.type=="kill")then
      Spring.DestroyUnit(unit)
    elseif(act.type=="hp")then
      local health,maxhealth=Spring.GetUnitHealth(unit)
      Spring.SetUnitHealth(unit,maxhealth*computeReference(act.params.percentage)/100)
    elseif(act.type=="teleport")then
      local posFound=extractPosition(act.params.position)
      Spring.SetUnitPosition(unit,posFound.x,posFound.z)
      Spring.GiveOrderToUnit(unit,CMD.STOP, {unit}, {}) -- avoid the unit getting back at its original position 
    elseif(act.type=="addToGroup")then
      addUnitToGroups(ctx.getLocalUnitIdFromSpringId[unit],{"group_"..act.params.group},false) 
	  --EchoDebug("Size of group_"..act.params.group..": "..table.getn(ctx.getAllLocalUnitIdsFromLocalGroupId["group_"..act.params.group]))
    elseif(act.type=="removeFromGroup")then
      removeUnitFromGroups(ctx.getLocalUnitIdFromSpringId[unit],{"group_"..act.params.group},false) 
    elseif(act.type=="order")then
      Spring.GiveOrderToUnit(unit, act.params.command, act.params.parameters or {}, {})
    elseif(act.type=="orderPosition")then
      local posFound=extractPosition(act.params.position)
      --EchoDebug("orderPosition (posFound,unit,command) : "..json.encode({posFound,unit,act.params.command}),5)
      Spring.GiveOrderToUnit(unit, act.params.command,{posFound.x,Spring.GetGroundHeight(posFound.x, posFound.z),posFound.z}, {})
    elseif(act.type=="orderTarget")then
	  targetUnits = {}
	  if act.params.target.type == "unit" then
		targetUnits = {act.params.target.value}
	  else
		targetUnits = ctx.getAvailableLocalUnitIdsFromLocalGroupId[act.params.target.type.."_"..tostring(act.params.target.value)]
	  end
	  --EchoDebug("orderTarget (unit,command,targets) : "..json.encode({unit,act.params.command,targetUnits}),5)
	  for k, v in pairs(targetUnits) do
		Spring.GiveOrderToUnit(unit,act.params.command, {ctx.getSpringIdFromLocalUnitId[v]}, {"shift"})   
	  end
   elseif (act.type=="messageUnit")or(act.type=="bubbleUnit") then
      if Spring.ValidUnitID(unit) then
        --EchoDebug("try to send : DisplayMessageAboveUnit on "..tostring(unit), 5)
        SendToUnsynced("DisplayMessageAboveUnit", json.encode({message=extractLang(getAMessage(act.params.message), lang),unit=unit,time=(computeReference(act.params.time) or 0)/ctx.speedFactor,bubble=(act.type=="bubbleUnit")}))
        --[[
        local x,y,z=Spring.GetUnitePosition(springUnitId)
        Spring.MarkerAddPoint(x,y,z, getAMessage(act.params.message))
        local deletePositionAction={id=99,type="erasemarker",params={x=x,y=y,z=z},name="deleteMessageAfterTimeOut"} --to erase message after timeout
        AddActionInStack(deletePositionAction, secondesToFrames(act.params.time or 0))--]]
      end
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
  local springId= Spring.CreateUnit(act.params.unitType, position.x,y,position.z, "n",act.params.team)
  local localUnitId=act.name.."_"..tostring(ctx.globalIndexOfCreatedUnits)
  -- in order to keep to track of all created units
  ctx.globalIndexOfCreatedUnits=ctx.globalIndexOfCreatedUnits+1 
  local gpIndex="action_"..act.id
  local teamIndex="team_"..tostring(act.params.team)
  registerUnit(springId,localUnitId)
  addUnitToGroups(localUnitId,{gpIndex,teamIndex}) 

    --<set Heal and underAttack>
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
	local pause = true -- default value in editor
	if act.params.boolean then
		pause = act.params.boolean == "true"
	end
    Script.LuaRules.showMessage(extractLang(getAMessage(act.params.message), lang), pause, 500)
  
  elseif(act.type=="showBriefing") then
    ShowBriefing()

  elseif(act.type=="messagePosition") then
    --EchoDebug("try to send : DisplayMessagePosition", 7)
  --Script.LuaUI.DisplayMessageAtPosition(p.message, p.x, Spring.GetGroundHeight( p.x, p.z), p.z, p.time) 
    local posFound=extractPosition(act.params.position)   
    local x=posFound.x
    local y=Spring.GetGroundHeight(posFound.x,posFound.z)
    local z=posFound.z
    SendToUnsynced("displayMessageOnPosition", json.encode({message=extractLang(getAMessage(act.params.message), lang),x=x,y=y,z=z,time=(computeReference(act.params.time) or 0)/ctx.speedFactor}))
     
  -- ZONES
  
  elseif(act.type=="hideZone") then 
	-- look for corresponding zone
	for i=1, table.getn(ctx.mission.zones) do
		local cZ=ctx.mission.zones[i]
		if cZ.id == act.params.zone then
			SendToUnsynced("hideZone", json.encode(cZ))
			break
		end
	end
  
  elseif(act.type=="showZone") then 
	-- look for corresponding zone
	for i=1, table.getn(ctx.mission.zones) do
		local cZ=ctx.mission.zones[i]
		if cZ.id == act.params.zone then
			SendToUnsynced("showZone", json.encode(cZ))
			break
		end
	end
  
   -- WIN/LOSE
   
  elseif (act.type=="win") and (ctx.mission.teams[tostring(act.params.team)]["control"]=="player") then
    ctx.gameOver[act.params.team]={victoryState="won", outputstate=act.params.outputState}
  elseif (act.type=="lose") and (ctx.mission.teams[tostring(act.params.team)]["control"]=="player") then
    ctx.gameOver[act.params.team]={victoryState="lost", outputstate=act.params.outputState}
   
   -- VARIABLES
    
  elseif(act.type=="changeVariable")then
    ctx.variables[act.params.variable]=computeReference(act.params.number)   
  elseif(act.type=="setBooleanVariable")then
    ctx.variables[act.params.variable]=(act.params.boolean=="true")
  elseif(act.type=="createUnits") then
	ctx.getAvailableLocalUnitIdsFromLocalGroupId["action_"..act.id]={} -- Implementation choice : we reset the action-group associated to the action-created to store only units created by the last call of this action.
    for var=1,computeReference(act.params.number) do
      local position=getARandomPositionInZone(act.params.zone)
      createUnitAtPosition(act,position)
    end 
  elseif(act.type=="changeVariableRandom") then
    local v=math.random(computeReference(act.params.min),computeReference(act.params.max))
    ctx.variables[act.params.variable]=v   
  elseif(act.type=="script") then
    local sucess, result = pcall(load_code(act.params.script))
	if not success and result ~= nil then
		Spring.Echo ("Warning!!! script \""..act.params.script.."\" failed: "..result)
	end
 
  elseif(act.type=="enableWidget")or(act.type=="disableWidget") then
    local widgetName=act.params.widget
    local activation=(act.type=="enableWidget")
    SendToUnsynced("changeWidgetState", json.encode({widgetName=widgetName,activation=activation}))
  
  elseif (act.type == "intersection") or (act.type == "union") then
    local g1=unitSetParamsToUnitsExternal(act.params.unitset1)
    local g2=unitSetParamsToUnitsExternal(act.params.unitset2)
    local g3
    --EchoDebug("act.params intersec/union -> "..json.encode(act.params),3 )
    if(act.type == "intersection")then
      g3=intersection(g1,g2)
    elseif(act.type == "union")then
      g3=union(g1,g2) -- at this point, duplicates will occur, but addUnitsToGroups for duplicates
    end
    --EchoDebug("g3 -> "..json.encode(g3),3 )
    --EchoDebug("before -> "..json.encode(ctx.getAvailableLocalUnitIdsFromLocalGroupId) ,3 )
    addUnitsToGroups(g3,{"group_"..tostring(act.params.group)},false)
    --EchoDebug("after -> "..json.encode(ctx.getAvailableLocalUnitIdsFromLocalGroupId) ,3 )
  else
    --EchoDebug("this action is not recognized : "..act.type,8)  
  end
end

-------------------------------------
-- The more general function to apply an action
-- according to its type (groupable or not) will be applied within another function
-- Handle group of units
-------------------------------------
function ApplyAction (a)
  
  --EchoDebug("we try to apply action :"..tostring(a.name),7)
  --EchoDebug(json.encode(a),7)
  local a, groupable=isAGroupableTypeOfAction(a)
  --if(groupable)then
  if(groupable) then
    --extract units
    if(a.params.unit~=nil)then
      local u=ctx.getSpringIdFromLocalUnitId[a.params.unit]
      ApplyGroupableAction_onSpUnit(u,a)
    else   
      --local tl={[1]={"currentTeam","team"},[2]={"team","team"},[3]={"unitType","type"},[4]={"group","group"}}
      local listOfUnits=extractListOfUnitsInvolved(a.params)
      --EchoDebug("we try to apply the groupable action to this group", 7)
      --EchoDebug("Units selected : "..json.encode(listOfUnits),7)
      if(a.type=="transfer")then
        --EchoDebug("about to transfer", 7)
        --EchoDebug(json.encode(listOfUnits), 7)
      end
      
      if(listOfUnits~=nil)then
        for i, externalUnitId in ipairs(listOfUnits) do
          local unit=ctx.getSpringIdFromLocalUnitId[externalUnitId]
          ApplyGroupableAction_onSpUnit(unit,a)
          --
        end
      else
        --EchoDebug("no units available for this action", 7)
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
    --EchoDebug("action "..el.actId.." is planned with delay : "..el.delay, 7)
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
-- actions refer to unitsets which are subject to change over time 
-- conditions, actions, and groups 
-------------------------------------
function replaceDynamicUnitSet(action)
  local action2=deepcopy(action)
  if(action.params.unitset~=nil)and(action.params.type~="action")then
    -- we exclude action from this early extraction because the group do not exist when event is executed
    action2.params["units_extracted"]=extractListOfUnitsInvolved(action.params)
  end
  return action2
end

-------------------------------------
-- Add an action to the stack, in a sorted manner
-- The action is insert according its delay
-- At the beginning of table if the quickest action to be applied
-- At the end if the action with the biggest delay
-------------------------------------
function AddActionInStack(action, delayFrame)
  local element={}
  element["delay"]=delayFrame
  element["action"]=replaceDynamicUnitSet(action)
  for index,el in pairs(ctx.actionStack) do
    local del=el.delay
    local act=el.actId
    if(del>delayFrame) then
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
  --EchoDebug("attacking-->"..json.encode(ctx.attackingUnits),1)
  --EchoDebug("attacked-->"..json.encode(ctx.attackedUnits),1)
  for attacked,tableInfo in pairs(ctx.attackedUnits) do
    local idAttacked=ctx.getLocalUnitIdFromSpringId[attacked]
    if(idAttacked~=nil)and (ctx.armyInformations[idAttacked]~=nil)then
      --EchoDebug(json.encode(tableInfo), 1)
      if(tableInfo.frame==-1)then
        ctx.attackedUnits[attacked].frame=frameNumber
        ctx.armyInformations[idAttacked].isUnderAttack=true
        --EchoDebug("under attack", 1)
      elseif(frameNumber-tonumber(tableInfo.frame)<secondesToFrames(ctx.timeUntilPeace))then
        ctx.armyInformations[idAttacked].isUnderAttack=true
        --EchoDebug("still under attack", 1)
      else
       --EchoDebug("no more under attack", 1)
        ctx.armyInformations[idAttacked].isUnderAttack=false
      end
    end
  end
  for attacking,tableInfo in pairs(ctx.attackingUnits) do
    local idAttacking=ctx.getLocalUnitIdFromSpringId[attacking]
    if(idAttacking~=nil)and (ctx.armyInformations[idAttacking]~=nil)then
      --EchoDebug(json.encode(tableInfo), 1)
      if(tableInfo.frame==-1 or tableInfo.frame==nil)then
        --EchoDebug(json.encode(ctx.attackingUnits[attacking]),2)
        ctx.attackingUnits[attacking]["frame"]=frameNumber
        ctx.armyInformations[idAttacking].isAttacking=true
        --EchoDebug("under attack", 1)
      elseif(frameNumber-tonumber(tableInfo.frame)<secondesToFrames(ctx.timeUntilPeace))then
        ctx.armyInformations[idAttacking].isAttacking=true
        --EchoDebug("still under attack", 1)
      else
       --EchoDebug("no more under attack", 1)
        ctx.armyInformations[idAttacking].isAttacking=false
      end
    end
  end
  for idUnit,infos in pairs(ctx.armyInformations) do
    local springUnit=ctx.getSpringIdFromLocalUnitId[idUnit]
  -- ctx.armyInformations
    if(not infos.autoHealStatus)and(Spring.ValidUnitID(springUnit)) then
      --EchoDebug("try to fix autoheal", 1)
      --EchoDebug(springUnit, 1)
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
--
-- If an event must be triggered, then shall be it
-- All the actions will be put in stack unless some specific options related to repetition
-- forbide to do so, such as allowMultipleInStack
-- this function as a side effect : it can create new actions (ex : to remove a message after a certain delay)
-------------------------------------
local function processEvents(frameNumber)
  local newevent
  local toBeRemoved = {}
  --EchoDebug("liste of events: "..json.encode(ctx.orderedEventsId, { indent = true }),7)
  for order,idEvent in orderedPairs(ctx.orderedEventsId) do
	-- ctx.events
    local event=ctx.events[idEvent]
	--EchoDebug("Event "..order..": "..json.encode(event, { indent = true }),7)
    if isTriggerable(event) then
	  --EchoDebug("Event "..event.id.." is triggerable",7)
      if(event.lastExecution==nil)or((event.repetition~=nil and event.repetition~=false and frameNumber>event.lastExecution+secondesToFrames(computeReference(event.repetitionTime)))) then
        -- Handle repetition
        event.lastExecution=frameNumber
        local frameDelay=0
        --EchoDebug("try to apply the event with the following actions: "..json.encode(event.actions, { indent = true }),7)
		local creationOfNewEvent=false
        for j=1,table.getn(event.actions) do
          frameDelay=frameDelay+1
          local a=event.actions[j]
          if(a.type=="wait")then
            frameDelay=frameDelay+secondesToFrames(computeReference(a.params.time)) 
          elseif (a.type=="waitCondition" or a.type=="waitTrigger") and not creationOfNewEvent then -- if creationOfNewEvent is already set this means a previous action ask to wait. So we don't have to process this new wait now but only to insert in the new event in order to be process when the new event will be trigger
            creationOfNewEvent=true
            newevent=deepcopy(event)
            newevent["actions"]={}
            newevent.lastExecution=nil
            newevent.id=tostring(ctx.nextUniqueIdEvent)
			ctx.nextUniqueIdEvent = ctx.nextUniqueIdEvent + 1
            if(a.type=="waitCondition") then
              newevent.trigger=a.params.condition
            elseif(a.type=="waitTrigger")then 
              newevent.trigger=a.params.trigger
			else
			  newevent.trigger=""
            end  
			newevent.conditions = {}
			--EchoDebug("Conditions list: "..json.encode(ctx.conditions, { indent = true }),7)
			for c,cond in pairs(newevent.listOfInvolvedConditions) do
				local newConditionId = cond.."_"..tostring(newevent.id)
				ctx.conditions[newConditionId]=deepcopy(ctx.conditions[cond.."_"..tostring(event.id)])
				ctx.conditions[newConditionId].id = ctx.nextUniqueIdCondition
				ctx.nextUniqueIdCondition = ctx.nextUniqueIdCondition + 1
				ctx.conditions[newConditionId].currentlyValid = false
				newevent.conditions[newConditionId]=ctx.conditions[newConditionId]
			end
			--EchoDebug("New event created: "..json.encode(newevent, { indent = true }),7)
			--EchoDebug("Conditions list: "..json.encode(ctx.conditions, { indent = true }),7)
			
          else
			-- if no creation of new event we can stack on the action, if creation of new event (means a previous action of the current event was waitCondition or waitTrigger) we add this action to the new event that will be evaluate again later and we don't stack on this action now
            if creationOfNewEvent==false then
              AddActionInStack(a,frameDelay)
            else
              table.insert(newevent["actions"],a)
            end
          end
        end
        if creationOfNewEvent then
          local newEvId=tostring(frameNumber+100)
          ctx.events[newEvId]=newevent -- dirty trick to generate an unique id for this new event
          ctx.indexOfLastEvent=ctx.indexOfLastEvent+1
          ctx.orderedEventsId[ctx.indexOfLastEvent]=newEvId
        end
		-- tag this event to be removed from events list if no repetition sets
		if event.repetition==nil or event.repetition==false then
			table.insert(toBeRemoved, idEvent)
		end
      end
    end
  end
  -- remove events
  for i, idEventToRemove in ipairs(toBeRemoved) do
	-- remove associated conditions to avoid to process them on "UpdateConditionsTruthfulness" call
	local conditionsToRemove = ctx.events[idEventToRemove].conditions
	for k, cond in pairs(conditionsToRemove) do
		-- look for this condition on conditions list
		for idCond,c in pairs(ctx.conditions) do
			if cond.id == c.id then
				--EchoDebug("Removing condition: "..idCond, 7)
				ctx.conditions[idCond] = nil
				break
			end
		end
	end
	--EchoDebug("Removing event: "..idEventToRemove, 7)
	for k, idEvent in pairs(ctx.orderedEventsId) do
		if idEvent == idEventToRemove then
			table.remove(ctx.orderedEventsId, k)
			ctx.indexOfLastEvent=ctx.indexOfLastEvent-1
			break
		end
	end
  end
end

-------------------------------------
-- update values which are available in unsync only
-- It justs request unsync code by sendMessage
-- Values are sent back to sync code (check RecvLuaMsg(msg, player))
-------------------------------------
local function  UpdateUnsyncValues(frameNumber)
  if(frameNumber%10~=0)then return end
  SendToUnsynced("requestUnsyncVals")
end

local function UpdateGroups()
  --EchoDebug("before update-> "..json.encode(ctx.getAvailableLocalUnitIdsFromLocalGroupId),0)
  for g,group in pairs(ctx.getAvailableLocalUnitIdsFromLocalGroupId) do
    for u,unit in pairs(group) do
      if(not Spring.ValidUnitID(ctx.getSpringIdFromLocalUnitId[unit]))then
        table.remove(group,u)
        --EchoDebug("remove ! -> "..json.encode(u),0)
      end
    end
  end
  --EchoDebug("after update-> "..json.encode(ctx.getAvailableLocalUnitIdsFromLocalGroupId),0)
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
if(Spring.ValidUnitID(unit))then
    local q=Spring.GetCommandQueue(unit,1) -- 1 means the only the first action in the stack
    local action=""
    if(q~=nil)and(q[1]~=nil) then
      action=q[1].id
      -- get the string describing the action by CMD[q[1].id] if you want
    end
    return action
  else
    --EchoDebug("GetCurrentUnitAction called with invalid unit it", 7)
    return nil
  end
end


-------------------------------------
-- Determine if an unit satisfies a condition
-- Two modes are possible depending on the mode of comparison (at least, at most ...)
-- Return boolean
-------------------------------------
local function UpdateConditionOnUnit (externalUnitId,c)--for the moment only single unit
  local internalUnitId=ctx.getSpringIdFromLocalUnitId[externalUnitId]
  if(c.type=="dead") then --untested yet
    --EchoDebug("is it dead ?", 7)
    --EchoDebug(externalUnitId, 7)
    local alive=Spring.ValidUnitID(internalUnitId)
    --EchoDebug(alive, 7)
    return not(alive)
  elseif(Spring.ValidUnitID(internalUnitId)) then  -- 
  -- recquire that the unit is alive (unless the condition type is death, cf at the end of the function
    if(c.type=="zone") then
      local i=isUnitInZone(internalUnitId,c.params.zone)
     --[[--EchoDebug("we check an unit in a zone", 7)
      --EchoDebug(internalUnitId, 7)
      --EchoDebug(c.params.zone, 7)
      if(i)then
        --EchoDebug("IN DA ZONE :", 7)
        --EchoDebug(c.name, 7)
      end
      if(i and c.name=="enterda")then
        --EchoDebug("condition validated", 7)
      end--]]
      return i  
    elseif(c.type=="underAttack")then --untested yet
      --EchoDebug("is it working", 7)
      --EchoDebug(ctx.armyInformations[externalUnitId].isUnderAttack, 7)
      if(not ctx.armyInformations[externalUnitId].isUnderAttack)then return false
      else
        --EchoDebug(json.encode(c),2)
        local spUnit=ctx.getSpringIdFromLocalUnitId[externalUnitId]
        local spAttacker=ctx.attackedUnits[spUnit].attackerID 
        local externalAttacker=ctx.getLocalUnitIdFromSpringId[spAttacker]
        local group=ctx.getAvailableLocalUnitIdsFromLocalGroupId[c.params.attacker.type.."_"..tostring(c.params.attacker.value)]
        --EchoDebug("group of attackers ->"..json.encode(group),1)
        local is,i=isInGroup(externalAttacker,group,false)
        --EchoDebug(is,2)
        return is
      end
    elseif(c.type=="attacking")then --untested yet
      return ctx.armyInformations[externalUnitId].isAttacking
    elseif(c.type=="order") then
      local action=GetCurrentUnitAction(internalUnitId)     
      return (action==c.params.command) 
    elseif(c.type=="hp") then
	  local hpInPercent = computeReference(c.params.hp)/100
	  local health,maxhealth=Spring.GetUnitHealth(internalUnitId)
	  return compareValue_Numerical(health/maxhealth, hpInPercent, c.params.comparison)
      --return compareValue_Verbal(tresholdRatio*maxhealth,maxhealth,health,c.params.hp.comparison)      
    elseif(c.type=="type") then
      return(c.params.type==UnitDefs[Spring.GetUnitDefID(internalUnitId)]["name"])
    end
  end
end

-------------------------------------
-- Update the truthfulness of a condition
-------------------------------------
local function UpdateConditionsTruthfulness (frameNumber)
  for idCond,c in pairs(ctx.conditions) do
    local object=c["object"]
	
    if(object=="group")then  
      --local tl={[1]={"team","team"},[2]={"unitType","type"},[3]={"group","group"}}
      local externalUnitList=extractListOfUnitsInvolved(c.params)
      --EchoDebug(json.encode(externalUnitList),6)
      local count=0
      local total=0
      if(externalUnitList~=nil)then
        total=table.getn(externalUnitList)
        --EchoDebug(json.encode(externalUnitList), 7)
        for u,unit in ipairs(externalUnitList) do
          if(UpdateConditionOnUnit(unit,c)) then
            addUnitToGroups(unit,{"condition_"..c.id}) 
            count=count+1
          end 
        end
      end      
      --EchoDebug(json.encode({idCond,c.params.number.number,total,count,c.params.number.comparison}), 7)
      ctx.conditions[idCond]["currentlyValid"] = compareValue_Verbal(c.params.number.number,total,count,c.params.number.comparison)
	  
    elseif(object=="kill")or(object=="killed")then  
      --EchoDebug("Condkills->"..json.encode(c.params),2)
      --EchoDebug("kills->"..json.encode(ctx.kills),2)
      local count=0
	  local unitsImpliedByCondition = extractListOfUnitsInvolved(c.params,ctx.getAllLocalUnitIdsFromLocalGroupId)
	  --EchoDebug("unitsImpliedByCondition: "..json.encode(unitsImpliedByCondition),2)
	  local total=0
	  if unitsImpliedByCondition ~= nil then
		total = table.getn(unitsImpliedByCondition)
	  end
      local killerGroupTofind
      local targetGroupTofind
      if(object=="kill")then   
		--EchoDebug("object->kill",2)
        killerGroupTofind=c.params.unitset.type.."_"..tostring(c.params.unitset.value)
        targetGroupTofind=c.params.target.type.."_"..tostring(c.params.target.value)
      elseif (object=="killed") then
		--EchoDebug("object->killed",2)
        killerGroupTofind=c.params.attacker.type.."_"..tostring(c.params.attacker.value)
        targetGroupTofind=c.params.unitset.type.."_"..tostring(c.params.unitset.value)     
      end 
      --EchoDebug('killerGroupTofind,targetGroupTofind,ctx.kills -> '..json.encode({killerGroupTofind,targetGroupTofind,ctx.kills}), 2)
      for killerUnit,killedUnit in pairs(ctx.kills) do
        local killerUnit_groups = getGroupsOfUnit(killerUnit, false, ctx.getAllLocalUnitIdsFromLocalGroupId)--, ctx.getAllLocalUnitIdsFromLocalGroupId
        --EchoDebug('killerUnit_groups -> '..json.encode(killerUnit_groups), 2)--
        local killedUnit_groups = getGroupsOfUnit(killedUnit, false, ctx.getAllLocalUnitIdsFromLocalGroupId)--
        --EchoDebug('killedUnit_groups -> '..json.encode(killedUnit_groups), 2)
        for g,gpname_killer in pairs(killerUnit_groups) do
		  --EchoDebug("Check killer : "..g.." "..gpname_killer.." == "..killerGroupTofind, 2)
          if(gpname_killer == killerGroupTofind) then
            for g,gpname_killed in pairs(killedUnit_groups) do
			  --EchoDebug("Check killed : "..g.." "..gpname_killed.." == "..targetGroupTofind, 2)
              if(gpname_killed == targetGroupTofind) then
                count = count + 1     
                --EchoDebug("finally !", 2)
                local unitToStore
                if(object=="killed") then
                  unitToStore=killedUnit
                else
                  unitToStore=killerUnit
                end
                addUnitToGroups(unitToStore,{"condition_"..c.id})        
              end
            end
          end   
        end
      end
      --EchoDebug("final count : "..tostring(count).."/"..tostring(total),0)    
      ctx.conditions[idCond]["currentlyValid"]= compareValue_Verbal(c.params.number.number,total,count,c.params.number.comparison)
	  if ctx.conditions[idCond]["currentlyValid"] then
		--EchoDebug("Condition validated",0)
	  end
	  
	elseif(object=="other")then  
      -- Time related conditions [START]
      if(c.type=="elapsedTime") then
        local elapsedAsFrame=math.floor(secondesToFrames(computeReference(c.params.number)))
        ctx.conditions[idCond]["currentlyValid"]=compareValue_Numerical(frameNumber, elapsedAsFrame,c.params.comparison) 
      elseif(c.type=="repeat") then
        local framePeriod=secondesToFrames(computeReference(c.params.number))
        ctx.conditions[idCond]["currentlyValid"]=((frameNumber-ctx.startingFrame) % framePeriod==0)
      elseif(c.type=="start") then
        ctx.conditions[idCond]["currentlyValid"]=(frameNumber==ctx.startingFrame)--frame 5 is the new frame 0
      -- Time related conditions [END]
      -- Variable related conditions [START]
      elseif(c.type=="numberVariable") then 
        local v1=ctx.variables[c.params.variable]
        local v2=computeReference(c.params.number)
        --{"type":"numberVariable","name":"Condition1","id":1,"object":"other","currentlyValid":false,"params":{"number":"6","variable":"unitscreated","comparison":"<"}}
        ctx.conditions[idCond]["currentlyValid"]=compareValue_Numerical(v1,v2,c.params.comparison)   
      elseif(c.type=="variableVSvariable") then
        local v1=ctx.variables[c.params.variable1]
        local v2=ctx.variables[c.params.variable2]
        ctx.conditions[idCond]["currentlyValid"]=compareValue_Numerical(v1,v2,c.params.comparison)   
      elseif(c.type=="booleanVariable") then
        ctx.conditions[idCond]["currentlyValid"]=ctx.variables[c.params.variable] -- very simple indeed 
      elseif(c.type=="script") then	  
		local sucess, result = pcall(load_code(c.params.script))
		if success or result == true or result == false then
			if result == nil then
				result=false
			end
			ctx.conditions[idCond]["currentlyValid"]=result
		else
			Spring.Echo ("Warning!!! script \""..c.params.script.."\" failed: "..result)
			ctx.conditions[idCond]["currentlyValid"]=false
		end
        
        --EchoDebug(string.format("script condition : %s",tostring(ctx.conditions[idCond]["currentlyValid"])), 7)
      end
    end
    --EchoDebug("state of condition :",2)
    --EchoDebug(idCond,2)
    --EchoDebug(ctx.conditions[idCond]["currentlyValid"],2)
    --EchoDebug("current group of units",2)
    --EchoDebug(json.encode(ctx.getAvailableLocalUnitIdsFromLocalGroupId),2)
    --EchoDebug("current group of undeleted units",2)
    --EchoDebug(json.encode(ctx.getAllLocalUnitIdsFromLocalGroupId),2)
  end 
end

-------------------------------------
-- Parse the editor file
-- enable/deactivate widgets according to the settings
-------------------------------------
local function parseJson(jsonString)
  --EchoDebug(jsonString, 7)
  if(jsonString==nil) then
    return nil
  end
  ctx.mission=json.decode(jsonString)

  local widgetWithForcedState={
    ["PP gui rooms"]=true,["Chili Framework"]=true,["PP Display Bubble"]=true
	,["PP GUI Messenger"]=true,["PP Camera Auto"]=true
    ,["PP GUI Main Menu"]=true,["Spring Direct Launch for mission player"]=true
	,["PP Display Zones"]=true,["PP Meta Traces Manager"]=true
	,["PP Show Feedbacks"]=true,["PP Widget Informer"]=true,["PP Restart Manager"]=true
  } -- remove <<["Hide commands"]=true>> managed by mouse activation
  
  for i=1, table.getn(ctx.mission.description.widgets) do
    local widgetName=ctx.mission.description.widgets[i].name
    if(widgetWithForcedState.widgetName==nil)then
      local activation=ctx.mission.description.widgets[i].active
      SendToUnsynced("changeWidgetState", json.encode({widgetName=widgetName,activation=activation}))
    end
  end
  
  -- Required widgets for Prog&Play   
  for name, activ in pairs(widgetWithForcedState) do
    SendToUnsynced("changeWidgetState", json.encode({widgetName=name,activation=activ}))
  end
  
  
  return true
end

-------------------------------------
-- Initialize the mission by parsing informations from the json
-- and process some datas
-- @todo This function does too many things
-------------------------------------
local function StartAfterJson ()
  if ctx.mission==nil then return end
  local units = Spring.GetAllUnits()
  for i = 1,table.getn(units) do
    --EchoDebug("I am Totally Deleting Stuff", 7)
    Spring.DestroyUnit(units[i], false, true)
  end  
 
 local specialPositionTables={} 
 
 -------------------------------
 ------COMMANDS LIST------------
 -------------------------------
 if (ctx.mission.listOfCommands~=nil and ctx.mission.listOfUnitTypes~=nil) then
	-- send these data to Spring engine
	if Spring.SendModConstants then
		Spring.SendModConstants(ctx.mission.listOfCommands, ctx.mission.listOfUnitTypes)
	end
 end
 
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
      --EchoDebug(cZ.type.." not implemented yet", 7)
      end
    if(cZ.alwaysInView)then
      table.insert(specialPositionTables,{center_xz.x,center_xz.z})
    end 
    if(cZ.marker)then
      local zName = string.gsub(extractLang(cZ.inGameText, lang), "\\n", "\n")
      Spring.MarkerAddPoint(center_xz.x,Spring.GetGroundHeight(center_xz.x,center_xz.z),center_xz.z, zName)
    end 
    --displayZone
    if cZ.showInGame then
       SendToUnsynced("showZone", json.encode(cZ))    
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
  --EchoDebug(json.encode(ctx.variables), 7)
  
  
  
    -- specialPositionTables[i]={positions[id].x,positions[id].z}
    -- 
  
   -------------------------------
   -------SETTINGS----------------
   -------------------------------
  ctx.messages["briefing"]=ctx.mission.description.briefing
  --EchoDebug(ctx.messages["briefing"], 7)
   if(ctx.mission.description.mouse=="disabled") then
    SendToUnsynced("mouseDisabled", true)
   end
  
  if(ctx.mission.description.cameraAuto=="enabled") then
    _G.cameraAuto = {
      enable = true,
      specialPositions = specialPositionTables --TODO: minimap and special position géree dans les zones
    }
    SendToUnsynced("enableCameraAuto")
    _G.cameraAuto = nil
  end
  local isautoHealGlobal=(ctx.mission.description.autoHeal=="enabled")
  
  if(ctx.mission.description.minimap and ctx.mission.description.minimap=="disabled") then
    Spring.SendCommands("minimap min")
  end
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
      local groupId=ctx.mission.groups[i].id
      local groupIndex="group_"..groupId
      ctx.getAvailableLocalUnitIdsFromLocalGroupId[groupIndex]={}
      ctx.getAllLocalUnitIdsFromLocalGroupId[groupIndex]={}
      addUnitsToGroups(ctx.mission.groups[i].units,{groupIndex},true)
    end
  end 
   


   ---------------------------------------------
   -------EVENTS  AND  CONDITIONS--------------
   ---------------------------------------------
  if(ctx.mission.events~=nil)then
	  ctx.nextUniqueIdCondition = 0
	  ctx.nextUniqueIdEvent = 0
      for i,currentEvent in ipairs(ctx.mission.events) do
       local idEvent=currentEvent.id
	   ctx.nextUniqueIdEvent = ctx.nextUniqueIdEvent <= tonumber(idEvent) and tonumber(idEvent) + 1 or ctx.nextUniqueIdEvent -- <=> (ctx.nextUniqueIdEvent < idEvent) ? idEvent + 1 : ctx.nextUniqueIdEvent;
       ctx.orderedEventsId[i]=idEvent
       ctx.events[idEvent]={}
       ctx.events[idEvent]=ctx.mission.events[i]
       ctx.events[idEvent].listOfInvolvedConditions={}
       for j=1, table.getn(currentEvent.conditions)do
         local currentCond=currentEvent.conditions[j]
		 ctx.nextUniqueIdCondition = ctx.nextUniqueIdCondition <= currentCond.id and currentCond.id + 1 or ctx.nextUniqueIdCondition -- <=> (ctx.nextUniqueIdCondition < currentCond.id) ? currentCond.id + 1 : ctx.nextUniqueIdCondition;
         local id=currentCond.name
         table.insert(ctx.events[idEvent].listOfInvolvedConditions,id)
         ctx.conditions[id.."_"..tostring(ctx.events[idEvent].id)]=currentCond
         ctx.conditions[id.."_"..tostring(ctx.events[idEvent].id)]["currentlyValid"]=false
         local type=currentCond.type
         local cond_object="other"
         if(currentCond.type=="killed")or(currentCond.type=="kill")then
          cond_object=currentCond.type -- special case as related units are no more
         elseif(currentCond.params.unitset~=nil)then
          cond_object="group"
         end
        ctx.conditions[id.."_"..tostring(ctx.events[idEvent].id)]["object"]=cond_object
        --EchoDebug(json.encode(ctx.conditions), 2)
      end 
      ctx.indexOfLastEvent=i
    end
  end     
end


-- shorthand for parseJson + StartAfterJson.
local function Start(jsonString) 
  --EchoDebug("missionFile : "..jsonString,2)
  parseJson(jsonString)
  StartAfterJson()
end

-------------------------------------
-- The main function of Mission Player
-- Update the game state of the mission 
-- Called externally by the gadget mission_runner.lua 
-- @return gameOver table 
-------------------------------------
local function Update (frameNumber)
  if ctx.mission==nil then return 0 end
  -- reset previous ctx.gameOver
  ctx.gameOver = {}
  -- loop all conditions and evaluate them
  UpdateConditionsTruthfulness(frameNumber) 
  -- loop all events and add actions in stack if the trigger return true (use validity of condition updated in previous "UpdateConditionsTruthfulness" call
  UpdateGameState(frameNumber)
  ctx.actionStack=updateStack(1)--update the stack with one frame (all the delays are decremented)
  applyCurrentActions() 
  if(frameNumber>32)then ctx.recordCreatedUnits=true end   -- in order to avoid to record units that are created at the start of the game
  UpdateUnsyncValues(frameNumber)
  UpdateGroups()
  return ctx.gameOver
  -- Trigger Events
end  
  
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


local function isMessage(msg,target_msg)
  local lengthTarget=string.len(target_msg)
  return ((msg~=nil)and(string.len(msg)>lengthTarget)and(string.sub(msg,1,lengthTarget)==target_msg))
end

-------------------------------------
-- Information received from Unsynced Code 
-- Executed in mission_runner.lua
-------------------------------------
local function RecvLuaMsg(msg, player)
  if isMessage(msg,"kill") then
    local jsonString=string.sub(msg,5,-1)
    --EchoDebug("killTable-->"..jsonString,3)
    local killTable=json.decode(jsonString)
    local killer=killTable.attackerID
    local killerExternal=ctx.getLocalUnitIdFromSpringId[killer]
    local killedExternal=ctx.getLocalUnitIdFromSpringId[killTable.unitID]
    ctx.kills[killerExternal]=killedExternal
    
  elseif isMessage(msg,"damage") then
    local jsonString=string.sub(msg,7,-1)
    local damageTable=json.decode(jsonString)
    --EchoDebug("damageTable-->"..json.encode(damageTable),1)
    local attackedUnit=damageTable.attackedUnit
    local attackingUnit=damageTable.attackerID
    damageTable.frame=tonumber(damageTable.frame)    
    if ctx.attackedUnits[attackedUnit]==nil then
      ctx.attackedUnits[attackedUnit]={} 
    end
    ctx.attackedUnits[attackedUnit]=damageTable
    if(attackingUnit~=nil)then
      if ctx.attackingUnits[attackingUnit]==nil then
        ctx.attackingUnits[attackingUnit]={} 
      end
      ctx.attackingUnits[attackingUnit]=damageTable
    end
    
  elseif isMessage(msg,"unitCreation") then
    if(ctx.recordCreatedUnits)then -- this avoid to store starting bases in the tables
      local jsonString=string.sub(msg,13,-1)
      local creationTable=json.decode(jsonString)
      local realId="createdUnit_"..tostring(ctx.globalIndexOfCreatedUnits)
      ctx.globalIndexOfCreatedUnits=ctx.globalIndexOfCreatedUnits+1
      local springId=creationTable.unitID 
      
      -- < Register>
      local teamIndex="team_"..tostring(creationTable.unitTeam)
      registerUnit(springId,realId)
      addUnitToGroups(realId,{teamIndex},false)
      -- </ Register> 
    end 
  elseif isMessage(msg,"returnUnsyncVals") then
    local jsonString=string.sub(msg,17,-1)
    local values=json.decode(jsonString)
    for ind,val in pairs(values)do
      ctx[ind]=val
    end
  end
end



missionScript = {}

missionScript.parseJson=parseJson
missionScript.StartAfterJson=StartAfterJson
missionScript.Start = Start
missionScript.ShowBriefing = ShowBriefing
missionScript.Update = Update
missionScript.Stop = Stop
missionScript.ApplyAction = ApplyAction
missionScript.RecvLuaMsg = RecvLuaMsg

ctx.load_code=load_code ; ctx.intersection=intersection ; ctx.compareValue_Verbal=compareValue_Verbal ; ctx.compareValue_Numerical=compareValue_Numerical ; ctx.makeOperation=makeOperation ; ctx.deepcopy=deepcopy ; ctx.secondesToFrames=secondesToFrames ; ctx.getFactionCode=getFactionCode ; ctx.boolAsString=boolAsString ; ctx.getAMessage=getAMessage ; ctx.isXZInsideZone=isXZInsideZone ; ctx.isUnitInZone=isUnitInZone ; ctx.getARandomPositionInZone=getARandomPositionInZone ; ctx.extractPosition=extractPosition ; ctx.ShowBriefing=ShowBriefing ; ctx.isTriggerable=isTriggerable ; ctx.extractListOfUnitsInvolved=extractListOfUnitsInvolved ; ctx.createUnit=createUnit ; ctx.isAGroupableTypeOfAction=isAGroupableTypeOfAction ; ctx.ApplyGroupableAction_onSpUnit=ApplyGroupableAction_onSpUnit ; ctx.createUnitAtPosition=createUnitAtPosition ; ctx.ApplyNonGroupableAction=ApplyNonGroupableAction ; ctx.ApplyAction=ApplyAction ; ctx.printMyStack=printMyStack ; ctx.alreadyInStack=alreadyInStack ; ctx.AddActionInStack=AddActionInStack ; ctx.updateStack=updateStack ; ctx.applyCurrentActions=applyCurrentActions ; ctx.watchHeal=watchHeal ; ctx.processEvents=processEvents ; ctx.GetCurrentUnitAction=GetCurrentUnitAction ; ctx.UpdateConditionOnUnit=UpdateConditionOnUnit ; ctx.UpdateConditionsTruthfulness=UpdateConditionsTruthfulness ; ctx.parseJson=parseJson ; ctx.returnTestsToPlay=returnTestsToPlay ; ctx.StartAfterJson=StartAfterJson ; ctx.Start=Start ; ctx.Update=Update ; ctx.Stop=Stop ; ctx.SendToUnsynced=SendToUnsynced
ctx.Spring=Spring ; ctx.UnitDefs=UnitDefs ; ctx.math=math

return missionScript