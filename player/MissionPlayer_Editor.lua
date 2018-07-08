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

--Table to store group of available units. A localIdGroup could be for exemple "team_0", "group_3", "action_12"... and a localUnitId is a number or a string used to find unit Spring Id through ctx.getSpringIdFromLocalUnitId
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

--associative array widgetName -> monitoring states. We know the state of a widget if we asked its state to unsynced code and we received the answer.
ctx.widgetsState={} -- -> {string widgetName = {number teamId = {boolean asked, boolean answer, boolean state}, ..., -1 (means all teams) = {boolean asked, boolean answer, boolean state, table teamsAnswers = {number teamId, boolean state | "undef"}}}, ...}

--store the last unit killed by a killer. "killer" and "unitKilled" are local unit Id and not Spring unitd id.
ctx.kills={}-- -> { string|number killer = string|number unitKilled, ... }

ctx.timeUntilPeace=2 -- how much time in seconds of inactivity to declare that an attack is no more

--list of units under attack and data associated. "attackedUnit" and "attackerID" refer to Spring unit ids.
ctx.attackedUnits={}-- -> { number SpringUnitId = [{ "attackedUnit" = number, "damage" = number, "attackerID" = number, "frame" = number }, ...], ... }

--list of units attacking another unit and data associated. "attackedUnit" and "attackerID" refer to Spring unit ids.
ctx.attackingUnits={}-- -> { number SpringUnitId = [{ "attackedUnit" = number, "damage" = number, "attackerID" = number, "frame" = number }, ...], ... }

ctx.recordCreatedUnits=false --flag to know when mission is initialized (all initial units have been created)

--action to be applied on game state, allows to handle table composed by the indexes delay and actId
ctx.actionStack={}-- -> { [1] = {"action" = table, "delay" = number}, ... }

--when this global variable change (with event of type "end"), the game ends (= victory or defeat) for a given team
ctx.gameOver={} -- {number teamId = {"victoryState" = string "won"|"lost", "outputstate"=number}, ...}

--associative array team -> end feedback. If teamId == -1 means all teams.
ctx.finalFeedback={} -- -> {number teamId = string, ...}

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
  if list1==nil then return {} end
  if list2==nil then return {} end
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

local function union(list1,list2)
  local union={}
  if (list1~=nil) then
    for i,el in pairs(list1)do
		table.insert(union,el)
    end
  end  
  if (list2~=nil) then
    for i,el in pairs(list2)do
		-- Check if this element is not already included into union list
		local inter = ctx.intersection({el}, union)
		if inter ~= nil and #inter == 0 then
			table.insert(union,el)
		end
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
  local success, result = pcall(ctx.load_code(executableStatement))
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
	reference=ctx.computeReference(reference)
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
-- Convert delay in number of frames into delay in seconds
-- @return delay in seconds
-------------------------------------
local function framesToSecondes(delayFrame)
  return delayFrame/30 -- As game simulation frame is updated 30 times by seconds
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

colorTable = { -- associative table between a number and its character
"\0","\1","\2","\3","\4","\5","\6","\7","\8","\9","\10","\11","\12","\13","\14","\15","\16","\17","\18","\19","\20","\21","\22","\23","\24","\25","\26","\27","\28","\29","\30","\31","\32","\33","\34","\35","\36","\37","\38","\39","\40","\41","\42","\43","\44","\45","\46","\47","\48","\49","\50","\51","\52","\53","\54","\55","\56","\57","\58","\59","\60","\61","\62","\63","\64","\65","\66","\67","\68","\69","\70","\71","\72","\73","\74","\75","\76","\77","\78","\79","\80","\81","\82","\83","\84","\85","\86","\87","\88","\89","\90","\91","\92","\93","\94","\95","\96","\97","\98","\99","\100","\101","\102","\103","\104","\105","\106","\107","\108","\109","\110","\111","\112","\113","\114","\115","\116","\117","\118","\119","\120","\121","\122","\123","\124","\125","\126","\127","\128","\129","\130","\131","\132","\133","\134","\135","\136","\137","\138","\139","\140","\141","\142","\143","\144","\145","\146","\147","\148","\149","\150","\151","\152","\153","\154","\155","\156","\157","\158","\159","\160","\161","\162","\163","\164","\165","\166","\167","\168","\169","\170","\171","\172","\173","\174","\175","\176","\177","\178","\179","\180","\181","\182","\183","\184","\185","\186","\187","\188","\189","\190","\191","\192","\193","\194","\195","\196","\197","\198","\199","\200","\201","\202","\203","\204","\205","\206","\207","\208","\209","\210","\211","\212","\213","\214","\215","\216","\217","\218","\219","\220","\221","\222","\223","\224","\225","\226","\227","\228","\229","\230","\231","\232","\233","\234","\235","\236","\237","\238","\239","\240","\241","\242","\243","\244","\245","\246","\247","\248","\249","\250","\251","\252","\253","\254","\255"
}
-------------------------------------
-- Get a message from a message table
-- If the message is not unique (a list), taking one by random
-------------------------------------
local function getAMessage(messageTable) 
  if messageTable == nil then
	return ""
  end
  local msg
  if(messageTable[1]==nil) then
    msg = messageTable
  else
    msg = messageTable[math.random(#messageTable)]
  end
  msg = string.gsub(msg, "\\n", "\n")
  msg = string.gsub(msg, "\\t", "\t")
  -- replace variables by its value
  for v,value in pairs(ctx.variables)do
    msg=string.gsub(msg, "##"..v.."##", tostring(value))
  end
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
	return false
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
  return ctx.isXZInsideZone(x,z,idZone)
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
        if(ctx.isXZInsideZone(x,z,idZone, borderException))then
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
  return nil  
end

-------------------------------------
-- Extract position from parameters
-- Sometimes a zone is given and getARandomPositionInZone will be called
-------------------------------------
local function extractPosition(tablePosOrMaybeJustZoneId)
  if(type(tablePosOrMaybeJustZoneId)=="number")then
    return ctx.getARandomPositionInZone(tablePosOrMaybeJustZoneId)
  else
    return tablePosOrMaybeJustZoneId
  end
end

-------------------------------------
-- Show Briefing, this function can be called from outside
-- For this reason all the json files must have a message with id BRIEFING
-------------------------------------
local function ShowBriefing (playerID)
  local briefingTxt = ctx.messages["briefing"] -- convention all json files have briefing attribute
  if briefingTxt and briefingTxt ~= "" then
	Script.LuaRules.showMessage(extractLang(briefingTxt, lang), false, 500, playerID)
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

local function unregisterUnit(springId,localUnitId)
	if springId ~= nil then
		ctx.getLocalUnitIdFromSpringId[springId]=nil
	end
	if localUnitId ~= nil then
		ctx.getSpringIdFromLocalUnitId[localUnitId]=nil
		ctx.armyInformations[localUnitId]=nil
	end
end

local function isInGroup(localUnitId,gp,testOnLocalIds)
  --EchoDebug("is in group ->"..json.encode(gp),0)
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
    local inGp,_ = ctx.isInGroup(localUnitId,g,testOnLocalIds)
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
      local _,i=ctx.isInGroup(localUnitId,ctx.getAvailableLocalUnitIdsFromLocalGroupId[group],testOnLocalIds)
      if(i~=nil)then
		table.remove(ctx.getAvailableLocalUnitIdsFromLocalGroupId[group],i)
	  end
    end
  end
end

local function addUnitToGroups_groupToStoreSpecified(localUnitId,groups,testOnLocalIds,groupToStore)
  local testOnLocalIds=testOnLocalIds or true 
  -- useful to check redundancy at a deeper level because, when it comes about unit creation
  -- units can have a different mission player id (e.g "Action1_0","createdUnit_1") for the same spring id  
  for g,group in pairs(groups) do
      -- create group if not existing
    if(groupToStore[group]==nil) then
      groupToStore[group]={}
    end   
    -- store in group if not already stored
    local isAlreadyStored,_=ctx.isInGroup(localUnitId,groupToStore[group],testOnLocalIds)
    if(not isAlreadyStored)then   
      table.insert(groupToStore[group],localUnitId)
    end
  end
end

-- add Unit to specified groups
-- side effect : add the unit to the overarching group : "team_all".
local function addUnitToGroups(localUnitId,groups,testOnLocalIds)
  table.insert(groups,"team_all")
  ctx.addUnitToGroups_groupToStoreSpecified(localUnitId,groups,testOnLocalIds,ctx.getAvailableLocalUnitIdsFromLocalGroupId)
  ctx.addUnitToGroups_groupToStoreSpecified(localUnitId,groups,testOnLocalIds,ctx.getAllLocalUnitIdsFromLocalGroupId)
end  

local function addUnitsToGroups(units,groups,testOnLocalIds)
  for u,unit in pairs(units) do
    ctx.addUnitToGroups(unit,groups,testOnLocalIds)
  end
end

local function unitSetParamsToMissionPlayerUnitsId(param)
	if param.type == "unit" then
		return {param.value}
	else
		local index = param.type..'_'..tostring(param.value)
		local units = ctx.getAvailableLocalUnitIdsFromLocalGroupId[index]
		--if(ctx.getAvailableLocalUnitIdsFromLocalGroupId[index] == nil)then
		--  EchoDebug("warning. This index gave nothing : "..index,7)
		--end
		return units
	end
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
-- Extract the list of units related to a condition or an action
-- If we are in the context of action, it's possible that a list
-- has already been compiled from previous condition checking process
-- in this case, units_extracted is an index for this list
-------------------------------------
local function extractListOfUnitsInvolved(actOrCond_Params,groupToCheck,frameNumber)
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
	   -- in case of "condition type" we find the group associated to the frameNumber
	   if actOrCond_Params.unitset.type == "condition" and frameNumber ~= nil then
		index = index.."_"..frameNumber
	   end
       if(groupToCheck[index]~=nil)then
		groupToReturn=groupToCheck[index]
       end
     end
  end
  return groupToReturn
end

-------------------------------------
-- Determine if a unit satisfies a condition
-- Two modes are possible depending on the mode of comparison (atleast, atmost ...)
-- Return boolean
-------------------------------------
local function CheckConditionOnUnit (missionPlayerUnitId,c)--for the moment only single unit
  local spUnitId=ctx.getSpringIdFromLocalUnitId[missionPlayerUnitId]
  if(Spring.ValidUnitID(spUnitId)) then  -- 
  -- recquire that the unit is alive (unless the condition type is death, cf at the end of the function
    if(c.type=="zone") then
	  if c.params.zone == nil or c.params.zone == "" then
		Spring.Echo("Warning on condition \""..c.name.."\" (Units are in a zone): No zone selected")
	  elseif ctx.zones[c.params.zone] == nil then
		Spring.Echo("Warning on condition \""..c.name.."\" (Units are in a zone): Zone unknown")
	  end
      local i=ctx.isUnitInZone(spUnitId,c.params.zone)
     --[[--EchoDebug("we check an unit in a zone", 7)
      --EchoDebug(spUnitId, 7)
      --EchoDebug(c.params.zone, 7)
      if(i)then
        --EchoDebug("IN DA ZONE :", 7)
        --EchoDebug(c.name, 7)
      end
      if(i and c.name=="enterda")then
        --EchoDebug("condition validated", 7)
      end--]]
      return i
	  
    elseif(c.type=="underAttack")then
      --EchoDebug("is it working", 7)
      --EchoDebug(json.encode(ctx.armyInformations[missionPlayerUnitId].isUnderAttack), 7)
      if(not ctx.armyInformations[missionPlayerUnitId].isUnderAttack)then return false
      else
        --EchoDebug(json.encode(c),2)
        local spUnit=ctx.getSpringIdFromLocalUnitId[missionPlayerUnitId]
		for i, attacked in ipairs(ctx.attackedUnits[spUnit]) do
			local spAttacker=attacked.attackerID
			if spAttacker == nil then
				Spring.Echo("Warning on condition \""..c.name.."\" (Units are under attack): Attacker unknown")
				return false
			end
			local missionPlayerAttackerId=ctx.getLocalUnitIdFromSpringId[spAttacker]
			if c.params.attacker == nil then
				Spring.Echo("Warning on condition \""..c.name.."\" (Units are under attack): Attacker not defined")
				return false
			else
				if c.params.attacker.type == "unit" and missionPlayerAttackerId == c.params.attacker.value then
					return true
				else
					local group=ctx.getAvailableLocalUnitIdsFromLocalGroupId[c.params.attacker.type.."_"..tostring(c.params.attacker.value)]
					--EchoDebug("group of attackers ->"..json.encode(group),1)
					local is,i=ctx.isInGroup(missionPlayerAttackerId,group,false)
					--EchoDebug(is,2)
					if is then
						return true
					end
				end
			end
		end
		return false
      end
	  
    elseif(c.type=="attacking")then
	  --Spring.Echo ("armyInfo-->("..missionPlayerUnitId.."/"..spUnitId..") "..json.encode(ctx.armyInformations[missionPlayerUnitId]))
      if(not ctx.armyInformations[missionPlayerUnitId].isAttacking)then return false
      else
        --EchoDebug(json.encode(c),2)
        local spUnit=ctx.getSpringIdFromLocalUnitId[missionPlayerUnitId]
		for i, attacker in ipairs(ctx.attackingUnits[spUnit]) do
			local spAttacked=attacker.attackedUnit
			if spAttacked == nil then
				Spring.Echo("Warning on condition \""..c.name.."\" (Units are attacking): Target unknown")
				return false
			end
			local missionPlayerAttackedId=ctx.getLocalUnitIdFromSpringId[spAttacked]
			if c.params.target == nil then
				Spring.Echo("Warning on condition \""..c.name.."\" (Units are attacking): Target not defined")
				return false
			else
				if c.params.target.type == "unit" and missionPlayerAttackedId == c.params.target.value then
					return true
				else
					local group=ctx.getAvailableLocalUnitIdsFromLocalGroupId[c.params.target.type.."_"..tostring(c.params.target.value)]
					--EchoDebug("group of attackers ->"..json.encode(group),1)
					local is,i=ctx.isInGroup(missionPlayerAttackedId,group,false)
					--EchoDebug(is,2)
					if is then
						return true
					end
				end
			end
		end
		return false
      end
	  
    elseif(c.type=="hp") then
	  if c.params.hp == nil or c.params.hp == "" then
		Spring.Echo("Warning on condition \""..c.name.."\" (HP of units): Percentage not defined")
		return false
	  elseif c.params.comparison == nil or c.params.comparison == "" then
		Spring.Echo("Warning on condition \""..c.name.."\" (HP of units): No operator selected")
		return false
	  end
	  local hpInPercent = ctx.computeReference(c.params.hp)/100
	  local health,maxhealth=Spring.GetUnitHealth(spUnitId)
	  return ctx.compareValue_Numerical(health/maxhealth, hpInPercent, c.params.comparison)
	  
    elseif(c.type=="order") then
	  if c.params.command == nil or c.params.command == "" then
		Spring.Echo("Warning on condition \""..c.name.."\" (Units are doing command): No command selected")
		return false
	  end
      local action=ctx.GetCurrentUnitAction(spUnitId)     
      return (action==c.params.command) 
	  
    elseif(c.type=="type") then
      if c.params.type == nil or c.params.type == "" then
		Spring.Echo("Warning on condition \""..c.name.."\" (Units are of specific type): No type selected")
		return false
	  end
      return(c.params.type==UnitDefs[Spring.GetUnitDefID(spUnitId)]["name"])
    end
  end
  return false
end

-------------------------------------
-- Update the truthfulness of a condition
-- return true if condition has been checked
-- return false if condition is not checkable this frame
-------------------------------------
local function UpdateConditionTruthfulness (idCond, frameNumber)
	local c = ctx.conditions[idCond]
	--EchoDebug(json.encode(c),6)
    local object=c["object"]
	
    if(object=="group" or object=="groupWithDead")then
		local count=0
		local total=0
		local alreadySet = false
		if object=="group" then
			-- Units extracted from "team", "group" or single unit (picked). Units involved to a condition can't be extracted from another "condition" or "action".
			local playerUnitList=ctx.extractListOfUnitsInvolved(c.params)
			--EchoDebug(json.encode(playerUnitList),6)
			total=table.getn(playerUnitList)
			if total == 0 then
				-- If the set is empty we can't check condition parameters on units. We set the validity of this condition to false 
				ctx.conditions[idCond]["currentlyValid"] = false
				alreadySet = true
			else
				--EchoDebug(json.encode(playerUnitList), 7)
				for u,missionPlayerUnitId in ipairs(playerUnitList) do
					if(ctx.CheckConditionOnUnit(missionPlayerUnitId,c)) then
						-- We make a group to store units satisfying this condition at the current frame
						-- This group will be used if the event triggers and an action of this event use this condition in its unitset (see frameNumber parameter from "extractListOfUnitsInvolved" call in "AddActionInStack" function)
						ctx.addUnitToGroups(missionPlayerUnitId,{"condition_"..c.id.."_"..frameNumber}) 
						count=count+1
					end 
				end
			end
		  
		else -- <=> object=="groupWithDead"
			-- Units extracted from "team", "group" or single unit (picked). Units involved to a condition can't be extracted from another "condition" or "action".
			local unitsImpliedByCondition = ctx.extractListOfUnitsInvolved(c.params,ctx.getAllLocalUnitIdsFromLocalGroupId)
			total = table.getn(unitsImpliedByCondition)
			  
			if(c.type=="dead") then	
				for u,missionPlayerUnitId in ipairs(unitsImpliedByCondition) do
					-- check if mission player know this unit
					if ctx.armyInformations[missionPlayerUnitId] == nil then
						-- We make a group to store units satisfying this condition at the current frame
						-- This group will be used if the event triggers and an action of this event use this condition in its unitset (see frameNumber parameter from "extractListOfUnitsInvolved" call in "AddActionInStack" function)
						ctx.addUnitToGroups(missionPlayerUnitId,{"condition_"..c.id.."_"..frameNumber}) 
						count=count+1
					end 
				end
				
			elseif c.type=="kill" or c.type=="killed" then
				--EchoDebug("Condkills->"..json.encode(c.params),2)
				--EchoDebug("kills->"..json.encode(ctx.kills),2)
				local killerGroupTofind
				local targetGroupTofind
				if(c.type=="kill")then   
					if c.params.unitset == nil or c.params.unitset == "" then
						Spring.Echo ("Warning on condition \""..c.name.."\" (Units killed specific units): No killer selected")
						return false
					elseif c.params.target  == nil or c.params.target == "" then
						Spring.Echo ("Warning on condition \""..c.name.."\" (Units killed specific units): No target selected")
						return false
					else
						killerGroupTofind=c.params.unitset.type.."_"..tostring(c.params.unitset.value)
						targetGroupTofind=c.params.target.type.."_"..tostring(c.params.target.value)
					end
				else -- <=> c.type=="killed"
					if c.params.unitset  == nil or c.params.unitset == "" then
						Spring.Echo ("Warning on condition \""..c.name.."\" (Units have been killed by other units): No target selected")
						return false
					elseif c.params.attacker == nil or c.params.attacker == "" then
						Spring.Echo ("Warning on condition \""..c.name.."\" (Units have been killed by other units): No killer selected")
						return false
					else
						killerGroupTofind=c.params.attacker.type.."_"..tostring(c.params.attacker.value)
						targetGroupTofind=c.params.unitset.type.."_"..tostring(c.params.unitset.value)     
					end
				end 
				--EchoDebug('killerGroupTofind,targetGroupTofind,ctx.kills -> '..json.encode({killerGroupTofind,targetGroupTofind,ctx.kills}), 2)
				for killerUnit,killedUnit in pairs(ctx.kills) do
					local killerUnit_groups = ctx.getGroupsOfUnit(killerUnit, false, ctx.getAllLocalUnitIdsFromLocalGroupId)--, ctx.getAllLocalUnitIdsFromLocalGroupId
					--EchoDebug('killerUnit_groups -> '..json.encode(killerUnit_groups), 2)--
					local killedUnit_groups = ctx.getGroupsOfUnit(killedUnit, false, ctx.getAllLocalUnitIdsFromLocalGroupId)--
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
							if(c.type=="kill") then
							  unitToStore=killerUnit
							else -- <=> c.type=="killed"
							  unitToStore=killedUnit
							end
							-- We make a group to store units satisfying this condition at the current frame
							-- This group will be used if the event triggers and an action of this event use this condition in its unitset (see frameNumber parameter from "extractListOfUnitsInvolved" call in "AddActionInStack" function)
							ctx.addUnitToGroups(unitToStore,{"condition_"..c.id.."_"..frameNumber})        
						  end
						end
					  end   
					end
				end
			else
				Spring.Echo("Warning on condition \""..c.name.."\": unknown condition type on dead units or bad parameters")
			end
		end
		--EchoDebug(json.encode({idCond,c.params.number.number,total,count,c.params.number.comparison}), 7)
		if c.params.number == nil or c.params.number == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\": missing quantitative parameter (atleast, atmost...)")
			return false
		elseif c.params.number.comparison == nil or c.params.number.comparison == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\": no quantitative parameter selecred (atleast, atmost...)")
			return false
		elseif c.params.number.comparison ~= "all" and (c.params.number.number == nil or c.params.number.number == "") then
			Spring.Echo ("Warning on condition \""..c.name.."\": missing numeric value for the \""..c.params.number.comparison.."\" parameter")
			return false
		elseif not alreadySet then
			ctx.conditions[idCond]["currentlyValid"] = ctx.compareValue_Verbal(c.params.number.number,total,count,c.params.number.comparison)
		end
	  
	elseif(object=="other")then  
      if(c.type=="start") then
        ctx.conditions[idCond]["currentlyValid"]=(frameNumber==ctx.startingFrame)--frame 5 is the new frame 0
		
      elseif(c.type=="elapsedTime") then
		if c.params.number == nil or c.params.number == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Time elapsed): No value defined")
			return false
		elseif c.params.comparison == nil or c.params.comparison == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Time elapsed): No operator selected")
			return false
		else
			local elapsedAsFrame=math.floor(ctx.secondesToFrames(ctx.computeReference(c.params.number)))
			ctx.conditions[idCond]["currentlyValid"]=ctx.compareValue_Numerical(frameNumber, elapsedAsFrame,c.params.comparison) 
		end
		
      elseif(c.type=="repeat") then
        if c.params.number == nil or c.params.number == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Periodically true): No value defined")
			return false
		else
			local framePeriod=ctx.secondesToFrames(ctx.computeReference(c.params.number))
			ctx.conditions[idCond]["currentlyValid"]=((frameNumber-ctx.startingFrame) % framePeriod==0)
		end
		
      elseif(c.type=="widgetEnabled") then
		local widgetName=c.params.widget
		local target=c.params.team or -1
		if c.params.team == nil or c.params.team == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Widget is enabled): No team selected")
		elseif c.params.team ~= -1 and ctx.mission.teams[tostring(c.params.team)] == nil then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Widget is enabled): Team unknown")
		end
		if widgetName == nil or widgetName == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Widget is enabled): Widget name not defined")
		else
			local players  = Spring.GetPlayerList(-1, true) -- Get all alive players
			-- check if this widget is known in mission player
			if ctx.widgetsState[widgetName] == nil then
				ctx.widgetsState[widgetName] = {}
			end
			-- check if this widget is known for this condition in mission player
			if ctx.widgetsState[widgetName][idCond] == nil then
				ctx.widgetsState[widgetName][idCond] = {}
			end
			-- check if this target is monitoring for this widget in mission player
			if ctx.widgetsState[widgetName][idCond][target] == nil then
				-- we init monitoring data
				ctx.widgetsState[widgetName][idCond][target] = {asked=false, answer=false, state = false}
				-- in case of "all teams" we add special field to store data for each team
				if target == -1 then
					-- we filter enabled player teams
					local playerTeams = {}
					for teamId, data in pairs(ctx.mission.teams) do
						if data["control"]=="player" and data["enabled"]==true then
							-- check if at least one player plays current team and can answer
							for _, playerId in ipairs(players) do
								_, _, _, playerTeamId = Spring.GetPlayerInfo(playerId)
								if playerTeamId == teamId then
									playerTeams[tonumber(teamId)] = "undef"
									break
								end
							end
						end
					end
					ctx.widgetsState[widgetName][idCond][target].teamsAnswers = playerTeams
				end
			end
			-- check if the state of this widget for this target was asked
			if ctx.widgetsState[widgetName][idCond][target].asked then
				local foundControler = true
				if target ~= -1 then
					-- check if at least one player plays target team and can answer
					foundControler = false
					for _, playerId in ipairs(players) do
						_, _, _, teamId = Spring.GetPlayerInfo(playerId)
						if teamId == target then
							foundControler = true
							break
						end
					end
				end
				-- check if we received the answer or team not controled by a player
				if ctx.widgetsState[widgetName][idCond][target].answer or not foundControler then
					if not foundControler then
						-- No player control this team, then the widget is not enabled
						ctx.conditions[idCond]["currentlyValid"]=false
					else
						-- we can set truthfullness of this condition
						ctx.conditions[idCond]["currentlyValid"]=ctx.widgetsState[widgetName][idCond][target].state
					end
					-- now we reset monitoring states
					ctx.widgetsState[widgetName][idCond][target].asked = false
					ctx.widgetsState[widgetName][idCond][target].answer = false
					ctx.widgetsState[widgetName][idCond][target].state = false
					if target == -1 then
						-- reset teams answers
						for teamId,_ in pairs(ctx.widgetsState[widgetName][idCond][target].teamsAnswers) do
							-- check if at least one player still plays current team and can answer
							local foundControler2 = false
							for _, playerId in ipairs(players) do
								_, _, _, playerTeamId = Spring.GetPlayerInfo(playerId)
								if playerTeamId == teamId then
									foundControler2 = true
									break
								end
							end
							if foundControler2 then
								ctx.widgetsState[widgetName][idCond][target].teamsAnswers[teamId] = "undef"
							else
								-- we reset this team
								ctx.widgetsState[widgetName][idCond][target].teamsAnswers[teamId] = nil
							end
						end
					end
					return true
				end
			else
				ctx.widgetsState[widgetName][idCond][target].asked = true
				SendToUnsynced("askWidgetState", json.encode({widgetName=widgetName,idCond=idCond,target=target}))
			end
		end
		return false -- truthfulness is not checkable this frame we need to report the evaluation of this condition
		
      elseif(c.type=="numberVariable") then 
	    if c.params.variable == nil or c.params.variable == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Compare the value of a variable): No variable selected")
			return false
		elseif c.params.comparison == nil or c.params.comparison == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Compare the value of a variable): No operator selected")
			return false
		elseif c.params.number == nil or c.params.number == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Compare the value of a variable): No number defined")
			return false
		else
			local v1=ctx.variables[c.params.variable]
			local v2=ctx.computeReference(c.params.number) --{"type":"numberVariable","name":"Condition1","id":1,"object":"other","currentlyValid":false,"params":{"number":"6","variable":"unitscreated","comparison":"<"}}
			ctx.conditions[idCond]["currentlyValid"]=ctx.compareValue_Numerical(v1,v2,c.params.comparison)  
		end
		
      elseif(c.type=="booleanVariable") then
        if c.params.variable == nil or c.params.variable == "" then
			Spring.Echo ("Warning on condition \""..c.name.."\" (Variable is true): No variable selected")
			return false
		else
			ctx.conditions[idCond]["currentlyValid"]=ctx.variables[c.params.variable] -- very simple indeed 
		end
		
      elseif(c.type=="script") then
		if c.params.script == nil or c.params.script == "" then
			Spring.Echo("Warning on condition \""..c.name.."\" (Evaluate custom boolean): No script defined")
			return false
		else
			local sucess, result = pcall(ctx.load_code(c.params.script))
			if success or result == true or result == false then
				if result == nil then
					result=false
				end
				ctx.conditions[idCond]["currentlyValid"]=result
			else
				Spring.Echo ("Warning on condition \""..c.name.."\" (Evaluate custom boolean): script \""..c.params.script.."\" failed: "..result)
				ctx.conditions[idCond]["currentlyValid"]=false
			end
			
			--EchoDebug(string.format("script condition : %s",tostring(ctx.conditions[idCond]["currentlyValid"])), 7)
		end
	  else
		Spring.Echo("Warning on condition \""..c.name.."\": unknown condition type or bad parameters")
      end
    end
    --EchoDebug("state of condition :",2)
    --EchoDebug(idCond,2)
    --EchoDebug(ctx.conditions[idCond]["currentlyValid"],2)
    --EchoDebug("current group of units",2)
    --EchoDebug(json.encode(ctx.getAvailableLocalUnitIdsFromLocalGroupId),2)
    --EchoDebug("current group of undeleted units",2)
    --EchoDebug(json.encode(ctx.getAllLocalUnitIdsFromLocalGroupId),2)
	
	return true
end

-------------------------------------
-- Check if a condition, expressed as a string describing boolean condition where variables
-- are related to conditions in the json files.
-------------------------------------
local function isTriggerable(event, frameNumber)
  --EchoDebug(json.encode(event), 7)
  -- step 1: get the trigger
  local trigger=event.trigger
  if(trigger=="")then   -- empty string => create trigger by conjunction (ands) of all conditions
    for c,cond in pairs(event.listOfInvolvedConditions) do
      trigger=trigger..cond.." and "
    end
    trigger=string.sub(trigger,1,-5) -- drop the last "and"
  end
  -- step 2: Update conditions truthfulness
  for c,cond in pairs(event.listOfInvolvedConditions) do
    if ctx.UpdateConditionTruthfulness(cond.."_"..tostring(event.id), frameNumber) == false then
		-- this condition is not accessible (due to unsynced data request for instance or inconsistent parameters) then we can't evaluate this trigger for now
		return false
	end
  end
  --EchoDebug("isTriggerable (before replacement) => "..trigger, 7)
  -- step 3: conditions are replaced to their boolean values.
  for c,cond in pairs(event.listOfInvolvedConditions) do
	--EchoDebug("look for condition: "..cond.."_"..tostring(event.id).. " in "..json.encode(ctx.conditions), 7)
    local valueCond=ctx.conditions[cond.."_"..tostring(event.id)]
    trigger=replaceConditionInTrigger(trigger, cond, ctx.boolAsString(valueCond["currentlyValid"]))
	--EchoDebug("isTriggerable (after replacement) => "..trigger, 7)
  end
  -- step 4: turn the string in return statement
  local executableStatement="return("..trigger..")"
   -- step 5: loadstring is used to create the function.
  local f = loadstring(executableStatement)
  if f == nil then
	return false
  else
	return(f())
  end
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
  ctx.registerUnit(springId,localUnitId,reduction,unitTable.autoHeal)
  --EchoDebug("try to create unit with these informations", 7)
  Spring.SetUnitRotation(springId,0,-1*unitTable.orientation,0)
  local teamIndex="team_"..tostring(unitTable.team)
  ctx.addUnitToGroups(localUnitId,{teamIndex}) 
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
-- Apply a groupable action on a single spring unit
-------------------------------------
local function ApplyGroupableAction_onSpUnit(spUnitId,act)
  if(Spring.ValidUnitID(spUnitId))then -- check if the unit is still on board
    --EchoDebug("valid", 7)
    if(act.type=="transfer") then
      --EchoDebug("try to apply transfert", 7)
	  if act.params.team == nil or act.params.team == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Transfer units): No team selected")
	  elseif act.params.team ~= -1 and ctx.mission.teams[tostring(act.params.team)] == nil then
		Spring.Echo ("Warning on action \""..act.name.."\" (Transfer units): Team unknown")
	  end
      Spring.TransferUnit(spUnitId,act.params.team)
      ctx.addUnitToGroups(ctx.getLocalUnitIdFromSpringId[spUnitId],{"team_"..tostring(act.params.team)}) 
    elseif(act.type=="kill")then
      Spring.DestroyUnit(spUnitId)
    elseif(act.type=="hp")then
      local health,maxhealth=Spring.GetUnitHealth(spUnitId)
	  if act.params.percentage == nil or act.params.percentage == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Set HP of units): percentage not defined")
	  end
      Spring.SetUnitHealth(spUnitId,maxhealth*ctx.computeReference(act.params.percentage)/100)
    elseif(act.type=="teleport")then
	  if act.params.position == nil or act.params.position == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Teleport units): No position defined")
	  else
		  local posFound=ctx.extractPosition(act.params.position)
		  if posFound == nil or posFound == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Teleport units): Position error")
		  else
			Spring.SetUnitPosition(spUnitId,posFound.x,posFound.z)
			Spring.GiveOrderToUnit(spUnitId,CMD.STOP, {spUnitId}, {}) -- avoid the unit getting back at its original position
		  end
	  end
    elseif(act.type=="addToGroup")then
	  if act.params.group == nil or act.params.group == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Add units to group): No group selected")
	  else
		ctx.addUnitToGroups(ctx.getLocalUnitIdFromSpringId[spUnitId],{"group_"..act.params.group},false) 
		--EchoDebug("Size of group_"..act.params.group..": "..table.getn(ctx.getAllLocalUnitIdsFromLocalGroupId["group_"..act.params.group]))
	  end
    elseif(act.type=="removeFromGroup")then
      if act.params.group == nil or act.params.group == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Remove units from group): No group selected")
	  else
		ctx.removeUnitFromGroups(ctx.getLocalUnitIdFromSpringId[spUnitId],{"group_"..act.params.group},false) 
	  end
    elseif(act.type=="order")then
	  if act.params.command == nil or act.params.command == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Order units (untargeted order)): No command defined")
	  else
		Spring.GiveOrderToUnit(spUnitId, act.params.command, act.params.parameters or {}, {})
	  end
    elseif(act.type=="orderPosition")then
	  if act.params.command == nil or act.params.command == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Order units to position): No command defined")
	  elseif act.params.position == nil or act.params.position == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Order units to position): No position defined")
	  else
		local posFound=ctx.extractPosition(act.params.position)
		if posFound == nil or posFound == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Order units to position): Position error")
		else
			--EchoDebug("orderPosition (posFound,spUnitId,command) : "..json.encode({posFound,spUnitId,act.params.command}),5)
			Spring.GiveOrderToUnit(spUnitId, act.params.command,{posFound.x,Spring.GetGroundHeight(posFound.x, posFound.z),posFound.z}, {})
		end
	  end
    elseif(act.type=="orderTarget")then
	  if act.params.command == nil or act.params.command == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Order units to target): No command defined")
	  else
		targetUnits = {}
		if act.params.target == nil then
			Spring.Echo ("Warning on action \""..act.name.."\" (Order units to target): No target defined")
			return
		else
			if act.params.target.type == "unit" then
				if act.params.target.value == nil or act.params.target.value == "" then
					Spring.Echo ("Warning on action \""..act.name.."\" (Order units to target): Target unknown")
					return
				end
				targetUnits = {act.params.target.value}
			else
				targetUnits = ctx.getAvailableLocalUnitIdsFromLocalGroupId[act.params.target.type.."_"..tostring(act.params.target.value)]
			end
			--EchoDebug("orderTarget (spUnitId,command,targets) : "..json.encode({spUnitId,act.params.command,targetUnits}),5)
			for k, v in pairs(targetUnits) do
				if ctx.getSpringIdFromLocalUnitId[v] ~= nil then
					Spring.GiveOrderToUnit(spUnitId,act.params.command, {ctx.getSpringIdFromLocalUnitId[v]}, {"shift"})   
				end
			end
		end
	  end
   elseif (act.type=="messageUnit")or(act.type=="bubbleUnit") then
		local actType = "Display message above units"
		if act.type=="bubbleUnit" then
			actType = "Display message in a bubble above units"
		end
		if act.params.message == nil or act.params.message == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" ("..actType.."): No message defined")
		else
			if act.params.time == nil or act.params.time == "" then
				Spring.Echo ("Warning on action \""..act.name.."\" ("..actType.."): No time defined")
			end
			--EchoDebug("try to send : DisplayMessageAboveUnit on "..tostring(spUnitId), 5)
			SendToUnsynced("DisplayMessageAboveUnit", json.encode({message=extractLang(ctx.getAMessage(act.params.message), lang),unit=spUnitId,time=(ctx.computeReference(act.params.time) or 0)/ctx.speedFactor,bubble=(act.type=="bubbleUnit"),id=act.params.id}))
		end
    end

    --Spring.GiveOrderToUnit(spUnitId, CMD.ATTACK, {attacked}, {}) 
  else
	Spring.Echo ("Warning on action \""..act.name.."\": unit not valid (springId: "..(spUnitId or "nil")..")")
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
  ctx.registerUnit(springId,localUnitId)
  ctx.addUnitToGroups(localUnitId,{gpIndex,teamIndex}) 

    --<set Heal and underAttack>
end

-------------------------------------
-- Apply a groupable action, generally not related to an unit
-------------------------------------
local function ApplyNonGroupableAction(act)
  if(act.type=="cameraAuto") then
	if(act.params.toggle==nil or act.params.toggle=="")then
		Spring.Echo ("Warning on action \""..act.name.."\" (Change camera auto state): No boolean value selected")
	end
	if(act.params.team==nil or act.params.team=="")then
		Spring.Echo ("Warning on action \""..act.name.."\" (Change camera auto state): No team selected")
	elseif act.params.team ~= -1 and ctx.mission.teams[tostring(act.params.team)] == nil then
		Spring.Echo ("Warning on action \""..act.name.."\" (Change camera auto state): Team unknown")
	end
    if(act.params.toggle=="enabled")then
      _G.cameraAuto = {
		target = act.params.team,
        enable = true,
        specialPositions = {} --TODO: minimap and special position géree dans les zones
      }
      SendToUnsynced("enableCameraAuto")
      _G.cameraAuto = nil
    else
      _G.cameraAuto = {
		target = act.params.team,
        enable = false,
        specialPositions = {} 
      }
      SendToUnsynced("disableCameraAuto")
      _G.cameraAuto = nil  
    end

  elseif(act.type=="mouse") then
	if(act.params.toggle==nil or act.params.toggle=="")then
		Spring.Echo ("Warning on action \""..act.name.."\" (Change mouse state): No boolean value selected")
	end
	local target=act.params.team
	if(target==nil or target=="")then
		Spring.Echo ("Warning on action \""..act.name.."\" (Change mouse state): No team selected")
	elseif target ~= -1 and ctx.mission.teams[tostring(target)] == nil then
		Spring.Echo ("Warning on action \""..act.name.."\" (Change mouse state): Team unknown")
	end
    if(act.params.toggle=="enabled")then
      SendToUnsynced("mouseEnabled", target)
    else
      SendToUnsynced("mouseDisabled", target) 
    end
    
  elseif(act.type=="centerCamera") then
	if act.params.position == nil or act.params.position == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Center camera to position): No position defined")
	else
		if act.params.team == nil or act.params.team == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Center camera to position): No team selected")
		elseif act.params.team ~= -1 and ctx.mission.teams[tostring(act.params.team)] == nil then
			Spring.Echo ("Warning on action \""..act.name.."\" (Center camera to position): Team unknown")
		end
		local posFound=ctx.extractPosition(act.params.position)
		if posFound == nil or posFound == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Center camera to position): Position error")
		else
			local dist
			if act.params.distance == nil or act.params.distance == "" then
				dist = 12 -- default value
			else
				dist = ctx.computeReference(act.params.distance)
			end
			-- keep dist between 0 and 99
			dist = math.max(0, math.min(dist, 99))
			local rotation
			if act.params.rotation == nil or act.params.rotation == "" then
				rotation = 20 -- default value
			else
				rotation = ctx.computeReference(act.params.rotation)
			end
			-- keep rotation between 0 and 100
			rotation = math.max(0, math.min(rotation, 100))
			local target=act.params.team
			SendToUnsynced("centerCamera", json.encode({pos=posFound,target=target,distance=dist,rotation=rotation}))
		end
	end
   
  -- MESSAGES
  
  elseif(act.type=="messageGlobal") then
	local pause = true -- default value in editor
	if act.params.boolean then
		pause = act.params.boolean == "true"
	end
	if act.params.message == nil or act.params.message == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Display message): No message defined")
	else
		Script.LuaRules.showMessage(extractLang(ctx.getAMessage(act.params.message), lang), pause, 500)
	end
  
  elseif(act.type=="showBriefing") then
    ctx.ShowBriefing()

  elseif(act.type=="messagePosition") then
	if act.params.message == nil or act.params.message == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Display message at position): No message defined")
	elseif act.params.position == nil or act.params.position == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Display message at position): No position defined")
	else
		--EchoDebug("try to send : DisplayMessagePosition", 7)
		--Script.LuaUI.DisplayMessageAtPosition(p.message, p.x, Spring.GetGroundHeight( p.x, p.z), p.z, p.time) 
		local posFound=ctx.extractPosition(act.params.position)
		if posFound == nil or posFound == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Display message at position): Position error")
		else
			if act.params.time == nil or act.params.time == "" then
				Spring.Echo ("Warning on action \""..act.name.."\" (Display message at position): No time defined")
			end
			local x=posFound.x
			local y=Spring.GetGroundHeight(posFound.x,posFound.z)
			local z=posFound.z
			SendToUnsynced("displayMessageOnPosition", json.encode({message=extractLang(ctx.getAMessage(act.params.message), lang),x=x,y=y,z=z,time=(ctx.computeReference(act.params.time) or 0)/ctx.speedFactor,id=act.params.id}))
		end
	end

  elseif(act.type=="messageUI") then
    if act.params.message == nil or act.params.message == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Display UI message): No message defined")
	elseif act.params.x == nil or act.params.x == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Display UI message): No x defined")
	elseif act.params.y == nil or act.params.y == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Display UI message): No y defined")
	elseif act.params.width == nil or act.params.width == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Display UI message): No width defined")
	elseif act.params.height == nil or act.params.height == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Display UI message): No height defined")
	else
		if act.params.team == nil or act.params.team == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Display UI message): No team selected")
		elseif act.params.team ~= -1 and ctx.mission.teams[tostring(act.params.team)] == nil then
			Spring.Echo ("Warning on action \""..act.name.."\" (Display UI message): Team unknown")
		end
		local message = extractLang(ctx.getAMessage(act.params.message), lang)
		local x = ctx.computeReference(act.params.x)
		local y = ctx.computeReference(act.params.y)
		local width = ctx.computeReference(act.params.width)
		local height = ctx.computeReference(act.params.height)
		SendToUnsynced("displayUIMessage", json.encode({message=message,x=x.."%",y=y.."%",width=width.."%",height=height.."%",id=act.params.id,target=act.params.team}))
	end

  elseif(act.type=="updateMessageUI") then
	if act.params.id == nil or act.params.id == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Update UI message): No id defined")
	elseif act.params.message == nil or act.params.message == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Update UI message): No message defined")
	else
		if act.params.team == nil or act.params.team == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Update UI message): No team selected")
		elseif act.params.team ~= -1 and ctx.mission.teams[tostring(act.params.team)] == nil then
			Spring.Echo ("Warning on action \""..act.name.."\" (Update UI message): Team unknown")
		end
		local message = extractLang(ctx.getAMessage(act.params.message), lang)
		SendToUnsynced("updateMessageUI", json.encode({id=act.params.id, message=message, target=act.params.team}))
	end

  elseif(act.type=="removeMessage") then
	if act.params.id == nil or act.params.id == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Force message to close): No id defined")
	else
		SendToUnsynced("removeMessage", json.encode({id=act.params.id}))
	end
     
  -- ZONES
  
  elseif(act.type=="hideZone") then 
	-- look for corresponding zone
	if act.params.zone == nil or act.params.zone == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Hide zone in game): No zone selected")
	else
		for i=1, table.getn(ctx.mission.zones) do
			local cZ=ctx.mission.zones[i]
			if cZ.id == act.params.zone then
				SendToUnsynced("hideZone", json.encode(cZ))
				break
			end
		end
	end
  
  elseif(act.type=="showZone") then 
	-- look for corresponding zone
	if act.params.zone == nil or act.params.zone == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Show zone in game): No zone selected")
	else
		for i=1, table.getn(ctx.mission.zones) do
			local cZ=ctx.mission.zones[i]
			if cZ.id == act.params.zone then
				SendToUnsynced("showZone", json.encode(cZ))
				break
			end
		end
	end
  
   -- WIN/LOSE
   
  elseif (act.type=="win") then
	if act.params.team == nil or act.params.team == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Player wins): No team selected")
	elseif ctx.mission.teams[tostring(act.params.team)] == nil then
		Spring.Echo ("Warning on action \""..act.name.."\" (Player wins): Team unknown")
	elseif ctx.mission.teams[tostring(act.params.team)]["control"]=="player" then
		if act.params.outputState == nil or act.params.outputState == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Player wins): No output state defined")
		end
		ctx.gameOver[act.params.team]={victoryState="won", outputstate=act.params.outputState}
	end
  elseif (act.type=="lose") then
	if act.params.team == nil or act.params.team == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Player loses): No team selected")
	elseif ctx.mission.teams[tostring(act.params.team)] == nil then
		Spring.Echo ("Warning on action \""..act.name.."\" (Player loses): Team unknown")
	elseif (ctx.mission.teams[tostring(act.params.team)]["control"]=="player") then
		if act.params.outputState == nil or act.params.outputState == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Player loses): No output state defined")
		end
		ctx.gameOver[act.params.team]={victoryState="lost", outputstate=act.params.outputState}
	end
  elseif (act.type=="gameover") then
	if act.params.team == nil or act.params.team == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Player Over): No team selected")
	elseif ctx.mission.teams[tostring(act.params.team)] == nil then
		Spring.Echo ("Warning on action \""..act.name.."\" (Player Over): Team unknown")
	elseif (ctx.mission.teams[tostring(act.params.team)]["control"]=="player") then
		if act.params.outputState == nil or act.params.outputState == "" then
			Spring.Echo ("Warning on action \""..act.name.."\" (Game Over): No output state defined")
		end
		ctx.gameOver[act.params.team]={victoryState="gameover", outputstate=act.params.outputState}
	end
	
  -- FINAL FEEDBACK
  elseif (act.type=="setFinalFeedback") then
	if act.params.message == nil or act.params.message == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Set Final Feedback): No message defined")
	end
	if act.params.team == nil or act.params.team == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Set Final Feedback): No team selected")
	elseif act.params.team ~= -1 and ctx.mission.teams[tostring(act.params.team)] == nil then
		Spring.Echo ("Warning on action \""..act.name.."\" (Set Final Feedback): Team unknown")
	end
	ctx.finalFeedback[act.params.team] = extractLang(ctx.getAMessage(act.params.message), lang)
   
   -- VARIABLES
    
  elseif(act.type=="changeVariable")then
	if act.params.variable == nil or act.params.variable == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Set number variable): No variable defined")
	elseif act.params.number == nil or act.params.number == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Set number variable): No value defined")
	else
		ctx.variables[act.params.variable]=ctx.computeReference(act.params.number)
	end		
  elseif(act.type=="setBooleanVariable")then
    if act.params.variable == nil or act.params.variable == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Set boolean variable): No variable defined")
	elseif act.params.boolean == nil or act.params.boolean == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Set boolean variable): No boolean value defined")
	else
		ctx.variables[act.params.variable]=(act.params.boolean=="true")
	end
  elseif(act.type=="createUnits") then
	if act.params.number == nil or act.params.number == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Create Units in Zone): No number defined")
	elseif act.params.unitType == nil or act.params.unitType == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Create Units in Zone): No unitType selected")
	elseif act.params.team == nil or act.params.team == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Create Units in Zone): No team selected")
	elseif ctx.mission.teams[tostring(act.params.team)] == nil then
		Spring.Echo ("Warning on action \""..act.name.."\" (Create Units in Zone): Team unknown")
	elseif act.params.zone == nil or act.params.zone == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Create Units in Zone): No zone selected")
	elseif ctx.zones[act.params.zone] == nil then
		Spring.Echo("Warning on action \""..act.name.."\" (Create Units in Zone): Zone unknown")
	end
	ctx.getAvailableLocalUnitIdsFromLocalGroupId["action_"..act.id]={} -- Implementation choice : we reset the action-group associated to the action-created to store only units created by the last call of this action.
    for var=1,ctx.computeReference(act.params.number) do
      local position=ctx.getARandomPositionInZone(act.params.zone)
	  if position ~= nil then
		ctx.createUnitAtPosition(act,position)
	  end
    end 
  elseif(act.type=="changeVariableRandom") then
    if act.params.variable == nil or act.params.variable == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Change the value of a variable randomly): No variable defined")
	elseif act.params.min == nil or act.params.min == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Change the value of a variable randomly): No min value defined")
	elseif act.params.max == nil or act.params.max == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Change the value of a variable randomly): No max value defined")
	else
		local v=math.random(ctx.computeReference(act.params.min),ctx.computeReference(act.params.max))
		ctx.variables[act.params.variable]=v
	end
  elseif(act.type=="script") then
    if act.params.script == nil or act.params.script == "" then
		Spring.Echo("Warning on action \""..act.name.."\" (Execute custom script): No script defined")
	else
		local sucess, result = pcall(ctx.load_code(act.params.script))
		if not success and result ~= nil then
			Spring.Echo ("Warning on action \""..act.name.."\" (Execute custom script): Script \""..act.params.script.."\" failed: "..json.encode(result))
		end
	end
	
  -- WIDGETS
 
  elseif(act.type=="enableWidget")or(act.type=="disableWidget") then
    local widgetName=act.params.widget
	local target=act.params.team
	if widgetName == nil or widgetName == "" then
		if(act.type=="enableWidget") then
			Spring.Echo ("Warning on action \""..act.name.."\" (Enable Widget): No widget selected")
		else
			Spring.Echo ("Warning on action \""..act.name.."\" (Disable Widget): No widget selected")
		end
	else
		if target == nil or target == "" then
			if(act.type=="enableWidget") then
				Spring.Echo ("Warning on action \""..act.name.."\" (Enable Widget): No team selected")
			else
				Spring.Echo ("Warning on action \""..act.name.."\" (Disable Widget: No team selected")
			end
		elseif target ~= -1 and ctx.mission.teams[tostring(target)] == nil then
			if(act.type=="enableWidget") then
				Spring.Echo ("Warning on action \""..act.name.."\" (Enable Widget): Team unknown")
			else
				Spring.Echo ("Warning on action \""..act.name.."\" (Disable Widget): Team unknown")
			end
		end
		local activation=(act.type=="enableWidget")
		SendToUnsynced("changeWidgetState", json.encode({widgetName=widgetName,target=target,activation=activation}))
	end
	
  -- LOS
  
  elseif(act.type=="enableLOS") then
		Spring.SendCommands("cheat 1")
		Spring.SendCommands("GlobalLOS 0")
		Spring.SendCommands("cheat 0")
  elseif(act.type=="disableLOS") then
		Spring.SendCommands("cheat 1")
		Spring.SendCommands("GlobalLOS 1")
		Spring.SendCommands("cheat 0")
		
  -- Trace
  elseif (act.type=="traceAction") then
	if act.params.trace == nil or act.params.trace == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Trace Action): No trace defined")
	elseif act.params.team == nil or act.params.team == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" (Trace Action: No team selected")
	elseif act.params.team ~= -1 and ctx.mission.teams[tostring(act.params.team)] == nil then
		Spring.Echo ("Warning on action \""..act.name.."\" (Trace Action): Team unknown")
	end
	SendToUnsynced("traceAction", json.encode({traceContent=extractLang(ctx.getAMessage(act.params.trace), lang),target=act.params.team}))
  
  elseif (act.type == "union") or (act.type == "intersection")then
    local actType = "Union between 2 Unitsets"
	if act.type == "intersection" then
		actType = "Intersection between 2 Unitsets"
	end
	if act.params.unitset1 == nil or act.params.unitset1 == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" ("..actType.."): No unitset1 selected for action "..act.id)
	elseif act.params.unitset2 == nil or act.params.unitset2 == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" ("..actType.."): No unitset2 selected for action "..act.id)
	elseif act.params.group == nil or act.params.group == "" then
		Spring.Echo ("Warning on action \""..act.name.."\" ("..actType.."): No group selected for action "..act.id)
	else
		--EchoDebug("act.params intersec/union -> "..json.encode(act.params),3 )
		local g1=ctx.unitSetParamsToMissionPlayerUnitsId(act.params.unitset1)
		--Spring.Echo ("g1-->"..json.encode(g1))
		local g2=ctx.unitSetParamsToMissionPlayerUnitsId(act.params.unitset2)
		--Spring.Echo ("g2-->"..json.encode(g2))
		local g3
		if(act.type == "intersection")then
		  g3=ctx.intersection(g1,g2)
		elseif(act.type == "union")then
		  g3=ctx.union(g1,g2)
		end
		--Spring.Echo ("g3-->"..json.encode(g3))
		--EchoDebug("before -> "..json.encode(ctx.getAvailableLocalUnitIdsFromLocalGroupId) ,3 )
		local groupName = "group_"..tostring(act.params.group)
		ctx.getAvailableLocalUnitIdsFromLocalGroupId[groupName] = nil
		ctx.addUnitsToGroups(g3,{groupName},false)
		--EchoDebug("after -> "..json.encode(ctx.getAvailableLocalUnitIdsFromLocalGroupId) ,3 )
	end
  else
    Spring.Echo ("Warning on action \""..act.name.."\": unknown action type or bad parameters") 
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
  local a, groupable=ctx.isAGroupableTypeOfAction(a)
  --if(groupable)then
  if(groupable) then
    --extract units
    if(a.params.unit~=nil)then
      local u=ctx.getSpringIdFromLocalUnitId[a.params.unit]
      ctx.ApplyGroupableAction_onSpUnit(u, a)
    else   
      -- Get units concerned by this action
      local listOfUnits=ctx.extractListOfUnitsInvolved(a.params)
      --EchoDebug("we try to apply the groupable action to this group", 7)
      --EchoDebug("Units selected : "..json.encode(listOfUnits),7)
      
	  for i, missionPlayerUnitId in ipairs(listOfUnits) do
	    local unit=ctx.getSpringIdFromLocalUnitId[missionPlayerUnitId]
	    ctx.ApplyGroupableAction_onSpUnit(unit, a)
	  end
    end
  else
    ctx.ApplyNonGroupableAction(a)
  end   
end

-------------------------------------
-- Printing the stack of actions planned in time
-- For debugging purpose
-------------------------------------
local function printMyStack()
  EchoDebug("START STACK", 7)
  for i,el in pairs(ctx.actionStack) do
    EchoDebug("action "..el.action.name.." is planned with delay : "..el.delay, 7)
  end
  EchoDebug("END STACK", 7)
end 

-------------------------------------
-- Check if an action is already in the stack of actions
-------------------------------------
local function alreadyInStack(actId)
  for index,el in pairs(ctx.actionStack) do
    if(el.action.id==actId)then
      return true
    end
  end
  return false
end 

local function PrepareActionForExecution (action, currentFrameNumber)
  -- We make a copy of this action in order to execute this copy and not the original action (useful for
  -- recursive events that will trigger again actions)
  local action2 = ctx.deepcopy(action)
  -- We store in this copy units that satisfied the event (we can't process action depending on an other action because the group does not exist when event is executed)
  if(action.params.unitset~=nil)and(action.params.type~="action")then
	-- We store units that are concerned by this action. In case of concerned units depend on a condition, we pass the frameNumber in order to get only units that verified the condition at this time 
    action2.params["units_extracted"]=ctx.extractListOfUnitsInvolved(action.params, nil, currentFrameNumber)
  end
  return action2
end

-------------------------------------
-- Add an action to the stack, in a sorted manner
-- The action is insert according its delay
-- At the beginning of table if the quickest action to be applied
-- At the end if the action with the biggest delay
-------------------------------------
function AddActionInStack(action, delayFrame, currentFrameNumber)
  local element={}
  element["delay"]=delayFrame
  element["action"]=ctx.PrepareActionForExecution(action, currentFrameNumber)
  for index,el in pairs(ctx.actionStack) do
    if(el.delay>delayFrame) then
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
local function applyDelayedActionsReached()
  local i = 1
  while i <= table.getn(ctx.actionStack) do
	local el = ctx.actionStack[i]
    if(el.delay<0)then
      ctx.ApplyAction(el.action)
      table.remove(ctx.actionStack,i)
	  i = i - 1
    end
	i = i + 1
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
  for attacked,listOfAttaquers in pairs(ctx.attackedUnits) do
    local idAttacked=ctx.getLocalUnitIdFromSpringId[attacked]
    if(idAttacked~=nil)and (ctx.armyInformations[idAttacked]~=nil)then
		ctx.armyInformations[idAttacked].isUnderAttack=false
		for _, fightTable in ipairs(listOfAttaquers) do
			if(fightTable.frame==-1 or fightTable.frame==nil)then
				fightTable.frame=frameNumber
				ctx.armyInformations[idAttacked].isUnderAttack=true
			elseif(frameNumber-tonumber(fightTable.frame)<ctx.secondesToFrames(ctx.timeUntilPeace))then
				ctx.armyInformations[idAttacked].isUnderAttack=true
			end
		end
		if not ctx.armyInformations[idAttacked].isUnderAttack then
			ctx.attackedUnits[attacked] = nil
		end
    end
  end
  for attacking,listOfTargets in pairs(ctx.attackingUnits) do
    local idAttacking=ctx.getLocalUnitIdFromSpringId[attacking]
    if(idAttacking~=nil)and (ctx.armyInformations[idAttacking]~=nil)then
		ctx.armyInformations[idAttacking].isAttacking=false
		for _, fightTable in ipairs(listOfTargets) do
			if(fightTable.frame==-1 or fightTable.frame==nil)then
				fightTable.frame=frameNumber
				ctx.armyInformations[idAttacking].isAttacking=true
			elseif(frameNumber-tonumber(fightTable.frame)<ctx.secondesToFrames(ctx.timeUntilPeace))then
				ctx.armyInformations[idAttacking].isAttacking=true
			end
		end
		if not ctx.armyInformations[idAttacking].isAttacking then
		  ctx.attackingUnits[attacking] = nil
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
    if ctx.isTriggerable(event, frameNumber) then
	  --EchoDebug("Event "..event.id.." is triggerable",7)
      if(event.lastExecution==nil)or((event.repetition~=nil and event.repetition~=false and frameNumber>event.lastExecution+ctx.secondesToFrames(ctx.computeReference(event.repetitionTime)))) then
        -- Handle repetition
        event.lastExecution=frameNumber
        local frameDelay=0
        --EchoDebug("try to apply the event with the following actions: "..json.encode(event.actions, { indent = true }),7)
		local creationOfNewEvent=false
        for j=1,table.getn(event.actions) do
          local a=event.actions[j]
          if(a.type=="wait")then
			if a.params.time == nil or a.params.time == "" then
				Spring.Echo ("Warning on action \""..a.name.."\" (Wait): No time defined")
			end
            frameDelay=frameDelay+ctx.secondesToFrames(ctx.computeReference(a.params.time)) 
          elseif (a.type=="waitCondition" or a.type=="waitTrigger") and not creationOfNewEvent then -- if creationOfNewEvent is already set this means a previous action ask to wait. So we don't have to process this new wait now but only to insert in the new event in order to be process when the new event will be trigger
            creationOfNewEvent=true
            newevent=ctx.deepcopy(event)
            newevent["actions"]={}
            newevent.lastExecution=nil
            newevent.id=tostring(ctx.nextUniqueIdEvent)
			ctx.nextUniqueIdEvent = ctx.nextUniqueIdEvent + 1
            if(a.type=="waitCondition") then
			  if a.params.condition == nil or a.params.condition == "" then
				Spring.Echo ("Warning on action \""..a.name.."\" (Wait for condition): No condition selected")
			  end
              newevent.trigger=a.params.condition or ""
            elseif(a.type=="waitTrigger")then 
			  if a.params.trigger == nil or a.params.trigger == "" then
				Spring.Echo ("Warning on action \""..a.name.."\" (Wait for trigger): No trigger defined")
			  end
              newevent.trigger=a.params.trigger or ""
			else
			  newevent.trigger=""
            end  
			newevent.conditions = {}
			--EchoDebug("Conditions list: "..json.encode(ctx.conditions, { indent = true }),7)
			for c,cond in pairs(newevent.listOfInvolvedConditions) do
				local newConditionId = cond.."_"..tostring(newevent.id)
				ctx.conditions[newConditionId]=ctx.deepcopy(ctx.conditions[cond.."_"..tostring(event.id)])
				ctx.conditions[newConditionId].id = ctx.nextUniqueIdCondition
				ctx.nextUniqueIdCondition = ctx.nextUniqueIdCondition + 1
				ctx.conditions[newConditionId].currentlyValid = false
				newevent.conditions[newConditionId]=ctx.conditions[newConditionId]
			end
			-- if frame delay is greater than 0 we have to add a condition to wait else we lose this information for futur actions
			if frameDelay > 0 then
				local baseName = "WaitActionAsCondition"
				local newConditionId = baseName.."_"..tostring(newevent.id)
				ctx.conditions[newConditionId] = {
					type="elapsedTime",
					name=baseName,
					id=ctx.nextUniqueIdCondition,
					object="other",
					currentlyValid = false,
					params={
						number=ctx.framesToSecondes(frameNumber+frameDelay),
						comparison=">"
					}
				}
				ctx.nextUniqueIdCondition = ctx.nextUniqueIdCondition + 1
				newevent.conditions[newConditionId]=ctx.conditions[newConditionId]
				if newevent.trigger ~= "" then
					newevent.trigger = newevent.trigger.." and "..baseName
				end
				table.insert(newevent.listOfInvolvedConditions, baseName)
				frameDelay = 0
			end
			--EchoDebug("New event created: "..json.encode(newevent, { indent = true }),7)
			--EchoDebug("Conditions list: "..json.encode(ctx.conditions, { indent = true }),7)
			
          else
			-- if no creation of new event we can execute the action, if creation of new event (means a previous action of the current event was waitCondition or waitTrigger) we add this action to the new event that will be evaluate again later and we don't execute this action now
            if creationOfNewEvent==false then
			  -- if frameDelay is greater than 0 we stack this action for a later execution
			  if frameDelay > 0 then
				ctx.AddActionInStack(a,frameDelay,frameNumber)
			  else
			    -- We can execute this action
				local actionReady = ctx.PrepareActionForExecution(a, frameNumber)
				ctx.ApplyAction(actionReady)
			  end
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
	else
		--EchoDebug("Event "..event.id.." is not triggerable",7)
		-- Clean condition groups that will be never used due to trigger fail
		-- Condition groups are set into "UpdateConditionTruthfulness" function
		for c,condName in pairs(event.listOfInvolvedConditions) do
			local cond=ctx.conditions[condName.."_"..tostring(event.id)]
			local groupCondName = "condition_"..cond.id.."_"..frameNumber
			ctx.getAvailableLocalUnitIdsFromLocalGroupId[groupCondName]=nil
			ctx.getAllLocalUnitIdsFromLocalGroupId[groupCondName]=nil
		end
    end
  end
  -- remove events
  for i, idEventToRemove in ipairs(toBeRemoved) do
	-- remove associated conditions
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
	,["SPRED Hide commands"]=false
  }
  
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
    SendToUnsynced("mouseDisabled")
   else
	SendToUnsynced("mouseEnabled")
   end
  
  if(ctx.mission.description.cameraAuto=="enabled") then
    _G.cameraAuto = {
      enable = true,
      specialPositions = specialPositionTables
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
        ctx.createUnit(armyTable)
    end
  end
 
  ctx.ShowBriefing()
   

 -------------------------------
 ------GROUP OF ARMIES----------
 -------------------------------
  if(ctx.mission["groups"]~=nil) then
    for i=1, table.getn(ctx.mission.groups) do
      local groupId=ctx.mission.groups[i].id
      local groupIndex="group_"..groupId
      ctx.getAvailableLocalUnitIdsFromLocalGroupId[groupIndex]={}
      ctx.getAllLocalUnitIdsFromLocalGroupId[groupIndex]={}
      ctx.addUnitsToGroups(ctx.mission.groups[i].units,{groupIndex},true)
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
         if currentCond.type=="killed" or currentCond.type=="kill" or currentCond.type=="dead" then
          cond_object="groupWithDead"
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
  ctx.parseJson(jsonString)
  ctx.StartAfterJson()
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
  ctx.watchHeal(frameNumber)
  -- loop all events and add actions in stack if the trigger return true
  ctx.processEvents(frameNumber)
  ctx.actionStack=ctx.updateStack(1)--update the stack with one frame (all the delays are decremented)
  ctx.applyDelayedActionsReached() 
  if(frameNumber>32)then ctx.recordCreatedUnits=true end   -- in order to avoid to record units that are created at the start of the game
  ctx.UpdateUnsyncValues(frameNumber)
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

-----------------------------------
-- Get the final feedback message sets for this teamId
local function GetFinalFeedback (teamId)
	local feedback = ""
	if ctx.finalFeedback[teamId] ~= nil and ctx.finalFeedback[teamId] ~= "" then
		feedback = ctx.finalFeedback[teamId]
	elseif ctx.finalFeedback[-1] ~= nil and ctx.finalFeedback[-1] ~= "" then
		feedback = ctx.finalFeedback[-1]
	end
	return feedback
end

-------------------------------------
-- Information received from Unsynced Code 
-- Executed in mission_runner.lua
-------------------------------------
local function RecvLuaMsg(msg, player)
  if ctx.isMessage(msg,"kill") then
    local jsonString=string.sub(msg,5,-1)
    --EchoDebug("killTable-->"..jsonString,3)
    local killTable=json.decode(jsonString)
    local spKillerId=killTable.attackerID
    local spKilledId=killTable.unitID
    local missionPlayerKillerId=ctx.getLocalUnitIdFromSpringId[spKillerId]
    local missionPlayerKilledId=ctx.getLocalUnitIdFromSpringId[spKilledId]
	if missionPlayerKilledId ~= nil then
		if missionPlayerKillerId ~= nil then
			ctx.kills[missionPlayerKillerId]=missionPlayerKilledId
		end
		--Update Groups
		local groupsName = {}
		for groupName, _ in pairs(ctx.getAvailableLocalUnitIdsFromLocalGroupId) do
			table.insert (groupsName, groupName)
		end
		ctx.removeUnitFromGroups(missionPlayerKilledId, groupsName)
		ctx.unregisterUnit(spKilledId,missionPlayerKilledId)
	end
    
  elseif ctx.isMessage(msg,"damage") then
    local jsonString=string.sub(msg,7,-1)
    local damageTable=json.decode(jsonString)
    --EchoDebug("damageTable-->"..json.encode(damageTable),1)
    local attackedUnit=damageTable.attackedUnit
    local attackingUnit=damageTable.attackerID
    damageTable.frame=-1
	if attackedUnit ~= nil then
		if ctx.attackedUnits[attackedUnit]==nil then
		  ctx.attackedUnits[attackedUnit]={} 
		end
		-- check if this fight is already known
		local found = false
		for k,v in ipairs(ctx.attackedUnits[attackedUnit]) do
			if v.attackerID == attackingUnit then
				found = true
				v.frame=-1
				break
			end
		end
		if not found then
			table.insert (ctx.attackedUnits[attackedUnit], damageTable)
		end
	end
    if(attackingUnit~=nil)then
		if ctx.attackingUnits[attackingUnit]==nil then
			ctx.attackingUnits[attackingUnit]={} 
		end
		-- check if this fight is already known
		local found = false
		for k,v in ipairs(ctx.attackingUnits[attackingUnit]) do
			if v.attackedUnit == attackedUnit then
				found = true
				v.frame=-1
				break
			end
		end
		if not found then
			table.insert (ctx.attackingUnits[attackingUnit], damageTable)
		end
    end
	--EchoDebug("attackedUnits-->"..json.encode(ctx.attackedUnits),1)
	--EchoDebug("attackingUnits-->"..json.encode(ctx.attackingUnits),1)
    
  elseif ctx.isMessage(msg,"unitCreation") then
    if(ctx.recordCreatedUnits)then -- this avoid to store starting bases in the tables
      local jsonString=string.sub(msg,13,-1)
      local creationTable=json.decode(jsonString)
      local springId=creationTable.unitID 
	  -- check if this unit is already registered
	  local realId = ctx.getLocalUnitIdFromSpringId[springId]
	  if realId == nil then
		realId="createdUnit_"..tostring(ctx.globalIndexOfCreatedUnits)
		ctx.globalIndexOfCreatedUnits=ctx.globalIndexOfCreatedUnits+1
		-- < Register>
		local teamIndex="team_"..tostring(creationTable.unitTeam)
		ctx.registerUnit(springId,realId)
		ctx.addUnitToGroups(realId,{teamIndex},false)
		-- </ Register> 
	  end
    end 
	
  elseif ctx.isMessage(msg,"returnUnsyncVals") then
    local jsonString=string.sub(msg,17,-1)
    local values=json.decode(jsonString)
    for ind,val in pairs(values)do
      ctx[ind]=val
    end
	
  elseif ctx.isMessage(msg,"mission") then
	local jsonfile=string.sub(msg,8,-1)
	ctx.parseJson(jsonfile)
	
  elseif ctx.isMessage(msg,"WidgetStateResult") then -- sent from pp_widget_informer.lua
	local jsonString=string.sub(msg,18,-1)
	local values=json.decode(jsonString)
	-- check if this widgetName is monitored (theorically yes, if not its a problem...) - see UpdateConditionTruthfulness => "widgetEnabled" condition
	if ctx.widgetsState[values.widgetName] then
		-- check if this widgetName is monitored for the specified condition Id (theorically yes, if not its a problem...) - see UpdateConditionTruthfulness => "widgetEnabled" condition
		if ctx.widgetsState[values.widgetName][values.idCond] then
			-- store this data for the team if we ask it
			if ctx.widgetsState[values.widgetName][values.idCond][values.teamId] ~= nil and ctx.widgetsState[values.widgetName][values.idCond][values.teamId].asked then
				ctx.widgetsState[values.widgetName][values.idCond][values.teamId].answer = true
				ctx.widgetsState[values.widgetName][values.idCond][values.teamId].state = values.state
			end
			-- store this data for all teams if we ask it
			if ctx.widgetsState[values.widgetName][values.idCond][-1] ~= nil and ctx.widgetsState[values.widgetName][values.idCond][-1].asked then
				ctx.widgetsState[values.widgetName][values.idCond][-1].teamsAnswers[values.teamId] = values.state
				-- check if all teams answer
				local result = true
				local allAnswer = true
				for teamId, r in pairs(ctx.widgetsState[values.widgetName][values.idCond][-1].teamsAnswers) do
					-- check if current team is still controled by a player
					local foundControler = false
					local players  = Spring.GetPlayerList(-1, true) -- Get all alive players
					for _, playerId in ipairs(players) do
						_, _, _, playerTeamId = Spring.GetPlayerInfo(playerId)
						if playerTeamId == teamId then
							foundControler = true
							break
						end
					end
					if foundControler then
						if r == "undef" then
							allAnswer = false
						else
							result = result and r
						end
					end
				end
				if allAnswer then
					ctx.widgetsState[values.widgetName][values.idCond][-1].answer = true
					ctx.widgetsState[values.widgetName][values.idCond][-1].state = result
				end
			end
		end
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
missionScript.GetFinalFeedback = GetFinalFeedback

ctx.load_code=load_code ; ctx.intersection=intersection ; ctx.union=union ; ctx.computeReference=computeReference ; ctx.compareValue_Verbal=compareValue_Verbal ; ctx.compareValue_Numerical=compareValue_Numerical ; ctx.deepcopy=deepcopy ; ctx.secondesToFrames=secondesToFrames ; ctx.framesToSecondes=framesToSecondes ; ctx.boolAsString=boolAsString ; ctx.getAMessage=getAMessage ; ctx.isXZInsideZone=isXZInsideZone ; ctx.isUnitInZone=isUnitInZone ; ctx.getARandomPositionInZone=getARandomPositionInZone ; ctx.extractPosition=extractPosition ; ctx.ShowBriefing=ShowBriefing ;ctx.registerUnit=registerUnit ; ctx.unregisterUnit=unregisterUnit ; ctx.isInGroup=isInGroup ; ctx.getGroupsOfUnit=getGroupsOfUnit ; ctx.removeUnitFromGroups=removeUnitFromGroups ; ctx.addUnitToGroups_groupToStoreSpecified=addUnitToGroups_groupToStoreSpecified ; ctx.addUnitToGroups=addUnitToGroups ; ctx.addUnitsToGroups=addUnitsToGroups ; ctx.unitSetParamsToMissionPlayerUnitsId=unitSetParamsToMissionPlayerUnitsId ; ctx.isTriggerable=isTriggerable ; ctx.extractListOfUnitsInvolved=extractListOfUnitsInvolved ; ctx.createUnit=createUnit ; ctx.isAGroupableTypeOfAction=isAGroupableTypeOfAction ; ctx.ApplyGroupableAction_onSpUnit=ApplyGroupableAction_onSpUnit ; ctx.createUnitAtPosition=createUnitAtPosition ; ctx.ApplyNonGroupableAction=ApplyNonGroupableAction ; ctx.ApplyAction=ApplyAction ; ctx.printMyStack=printMyStack ; ctx.alreadyInStack=alreadyInStack ; ctx.PrepareActionForExecution=PrepareActionForExecution ; ctx.AddActionInStack=AddActionInStack ; ctx.updateStack=updateStack ; ctx.applyDelayedActionsReached=applyDelayedActionsReached ; ctx.watchHeal=watchHeal ; ctx.processEvents=processEvents ; ctx.GetCurrentUnitAction=GetCurrentUnitAction ; ctx.CheckConditionOnUnit=CheckConditionOnUnit ; ctx.UpdateConditionTruthfulness=UpdateConditionTruthfulness ; ctx.parseJson=parseJson ; ctx.UpdateUnsyncValues=UpdateUnsyncValues ; ctx.returnTestsToPlay=returnTestsToPlay ; ctx.StartAfterJson=StartAfterJson ; ctx.Start=Start ; ctx.Update=Update ; ctx.Stop=Stop ; ctx.SendToUnsynced=SendToUnsynced ; ctx.Spring=Spring ; ctx.UnitDefs=UnitDefs ; ctx.math=math ; ctx.pairs=pairs ; ctx.isMessage=isMessage ; ctx.GetFinalFeedback=GetFinalFeedback

return missionScript