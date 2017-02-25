---
-- Appliq LUA library
-- _This module enable Prog&Play to load xml produce with Appliq software Xml exported 
-- by Appliq has to be renamed with the same short name as define in ModInfo.lua
-- The names activities in Appliq XML export has to have the same name with files stored into Missions/[ModShortName]/_
--
-- @module appliqManager
appliqManager = {} 

--local rootDirectory="KP_campaign_2.4/LuaUI/Widgets/libs/" -- IMPORTANT EDIT THIS LINE with the path for this file relatively to the roo of the current project.
--dofile(rootDirectory.."context.lua") -- allows to work in local or int the context of Spring Runtime
--dofile("context.lua")
--local contx=context:new("AppliqManager/",rootDirectory) -- Not sure that spring is working

--require("context") -- allows to work in local or int the context of Spring Runtime
local xml = VFS.Include("LuaUI/Widgets/libs/LuaXML/luaxml-mod-xml.lua")
local handler = VFS.Include("LuaUI/Widgets/libs/LuaXML/luaxml-mod-handler.lua")

-------------------------------------
-- Constructor
-- @param xmldata : filepath to xml file
-------------------------------------
function appliqManager:new(xmldata)
  local instance = {}
  instance.start="start"
  instance.currentActivityID=nil
  instance.progressionOutputs={}
  instance.goalsReached={ludo={},peda={}}
  instance.progression=nil
  instance.xmldata=xmldata
  setmetatable(instance, self)
  self.__index = self
	instance.treehandler = handler.simpleTreeHandler()
	-- do not reduce node activity, input_state, output_state, goal, goal_link, link_set and output_input_link if they are alone
	-- in our case it is preferable to always insert elements as a vector which can be specified on a per element basis
	instance.treehandler.options.noreduce = {activity = true, input_state = true, output_state = true, goal = true, goal_link = true, link_set = true, output_input_link = true}
	-- define parser and parse xml
  instance.game = nil
  instance.scenario = nil
  instance.activities = nil
  instance.goals = {}--avoid bugs
  instance.selectedScenarioIndex = nil
	instance.x = xml.xmlParser(instance.treehandler)
  return instance
end

-------------------------------------
-- Parsing function, necessary to get informations from the xml file
-------------------------------------
function appliqManager:parse()
  local loadedFile=VFS.LoadFile(self.xmldata)
  if(loadedFile)==nil then
    self=nil
    return
  end
  self.x:parse(loadedFile)
  -- check if we have at least a game node. If not, something wrong !!!
  if (self.treehandler.root and self.treehandler.root.games and self.treehandler.root.games.game) then
    self.game = self.treehandler.root.games.game
    -- trying to initialise scenario
    if self.game.link_sets and self.game.link_sets.link_set then
      self.scenario = self.game.link_sets.link_set
    end
    -- trying to initialise activities
    if self.game.activities and self.game.activities.activity then
      self.activities = self.game.activities.activity
    end
    -- trying to initialise and goals
    if self.game.goals and self.game.goals.goal then
      self.goals = self.game.goals.goal
    end
  end
end

-------------------------------------
-- validate that most important informations are present
-- do not check any kind of consistency
-- @return #boolean presence of most important informations
-------------------------------------
function appliqManager:validateValues()
  return((self.game~=nil)and(self.scenario~=nil)and(self.activities~=nil)and(self.activities~=nil)and(self.goals~=nil))
end

-------------------------------------
-- return the number of available scenarios 
-------------------------------------
function appliqManager:scenarioGetN()
	if self.scenario ~= nil then
		return table.getn(self.scenario)
	end
	return 0
end

-------------------------------------
-- select current scenario and update the list of outputs
-- @param  #number index the index of the selected scenario (starting to 1, LUA style, you know)
-- @return #boolean success of operation
-------------------------------------
function appliqManager:selectScenario(index)
  -- index must be include into [1, scenarioGetN()]
  if  self:scenarioGetN()>=index then
    self.selectedScenarioIndex=index
    local links=self:scenarioGetLinks()
    self.AvailableOutputsFromCurrentScenario={}
    for i=1,table.getn(links) do
      local l=links[i]
      table.insert(self.AvailableOutputsFromCurrentScenario,l._attr.id_output)
    end
    return true
  else
    Spring.Echo("scenario index out of range, the selected scenario does not exist")
    return false
  end
end

-------------------------------------
-- @return #string  Name of selected scenario
-- @return nil if error
-------------------------------------
function appliqManager:scenarioGetName(i)
  local index=self.selectedScenarioIndex or i
  if index ~= nil and self.scenario~= nil and self.scenario[index].title ~= nil then
    return self.scenario[index].title
  else
    return nil
  end
end

-------------------------------------
-- @return links constituting the scenario
-- @return nil on error
-------------------------------------
function appliqManager:scenarioGetLinks()
	-- check if scenario have at least one link
	local index=self.selectedScenarioIndex
	if index ~= nil and self.scenario ~= nil and self.scenario[index].links ~= nil and self.scenario[index].links.output_input_link ~= nil then
		return self.scenario[index].links.output_input_link
	end
	return nil
end

-------------------------------------
-- @return #string selected scenario id
-- @return nil on error
-------------------------------------
function appliqManager:scenarioGetId()
  if self.selectedScenarioIndex ~= nil and self.scenario ~= nil then
      return self.scenario[self.selectedScenarioIndex]._attr.id_link_set
    else
      return nil
  end
end

-------------------------------------
-- @return #string id of activity of the first activity of selected scenario
-- @return nil on error
-------------------------------------
function appliqManager:getInputFromOutput(output)
  local links = self:scenarioGetLinks()
  if links == nil or output==nil then
    return nil
  end
  -- look for input_state linked with start
  local input_stateId = nil
  for i=1,table.getn(links) do
    if links[i]._attr ~= nil and links[i]._attr.id_output == output then
      return links[i]._attr.id_input
    end
  end
end

-------------------------------------
-- @param #string input state Id
-- @return #string id of activity giving its input_state Id
-- @return nil on error
-------------------------------------
function appliqManager:getActivityFromInput(input_stateId)
  if input_stateId == nil then
    return nil
  end
  if input_stateId == "end" then
    return "end"
  end
  -- find activity's name with this input_stateId
  for i=1,table.getn(self.activities) do
    -- check if activity is well formed
    if self.activities[i].name ~= nil and self.activities[i].input_states ~= nil and self.activities[i].input_states.input_state ~= nil then
      local inputStates = self.activities[i].input_states.input_state
      -- parse all input states of this activity to find the input state id we look for
      for j=1,table.getn(inputStates) do
        if inputStates[j]._attr ~= nil and inputStates[j]._attr.id_input == input_stateId then
          return self.activities[i]._attr.id_activity
        end
      end
    end
  end
end

-------------------------------------
-- @return #string id of activity of the first activity of selected scenario
-- @return nil on error
-------------------------------------
function appliqManager:getNextActivityFromOutput(output)
  local input_stateId=self:getInputFromOutput(output)
  return self:getActivityFromInput(input_stateId)
end

-------------------------------------
-- @param #string idToFind of input or output to find 
-- @param #string states value is "outputs" or "inputs"
-- @param #string state value is "output" or "input"
-- @return nil if not found
-- @return #string name of input or output to find 
-------------------------------------
function appliqManager:getIONameFromId(idToFind,state)
  for i=1,table.getn(self.activities) do
    local act=self.activities[i]
    --Spring.Echo(state)
    local elements=act[state.."_states"][state.."_state"]
    if(elements~=nil)then
      for j=1,table.getn(elements) do
        local element=elements[j]
        if((element._attr)["id_"..state]==idToFind) then
        local val=element._attr.name
          if val==nil then
            return "unnamed"
          end
          return val
        end
      end
    end
  end
  return "untitled"
end

-------------------------------------
-- @param #string id of output 
-- @return nil if not found
-- @return #string name of output 
-------------------------------------
function appliqManager:getOutputNameFromId(idOutput)
  return self:getIONameFromId(idOutput,"output")
end

-------------------------------------
-- @param #string idToFind of output to find 
-- @return #string name of output found
-- @return nil if not found
-------------------------------------
function appliqManager:getInputNameFromId(idInput)
  return self:getIONameFromId(idInput,"input")
end

-------------------------------------
-- @param #string id of activity 
-- @return nil if not found
-- @return #string name of activity 
-------------------------------------
function appliqManager:getActivityNameFromId(idAct)
  for i=1,table.getn(self.activities) do
    local act=self.activities[i]
    --Spring.Echo(act._attr.id_activity)
    if(act._attr.id_activity==idAct) then
      return act.name
    end
  end
  return nil
end

-------------------------------------
-- @param #string id of goal 
-- @return nil if not found
-- @return #string name of goal 
-------------------------------------
function appliqManager:getGoalNameFromId(idGoal)
  for i=1,table.getn(self.goals) do
    local g=self.goals[i]
    if(g._attr.id_goal==idGoal) then
      return g.name
    end
  end
  return nil
end

-------------------------------------
-- @return #table idOutputs list of possible outputs from the current activity
-- @return nil on error
-------------------------------------
function appliqManager:listPossibleOutputsFromCurrentActivity()
  for i=1,table.getn(self.activities) do
    if(self.activities[i]._attr.id_activity==self.currentActivityID) then
      local act=self.activities[i]
      local states=act.output_states.output_state
      local idOutputs={}
      for j=1, table.getn(states) do
        local currentOutput=(states[j])._attr.id_output
        if(contains(self.AvailableOutputsFromCurrentScenario,currentOutput)) then 
        -- giving a specific scenario, some outputs might be unavailable 
          table.insert(idOutputs,currentOutput)
        end
      end
      return idOutputs
    end
  end
  return nil
end

-------------------------------------
-- Maybe an overkill as it only uses getActivityFromOutput with self.start argument
-- Set the currentActivity field and return its value
-- update progressionOutputs field
-- @return #string id of activity of the first activity of selected scenario
-- @return nil on error
-------------------------------------
function appliqManager:startRoute()
  self.currentActivityID=self:getNextActivityFromOutput(self.start)
  --self.progressionOutputs={self.start}--commented out as not homoegenous as setPrgression
  
  return self.currentActivityID
end

-------------------------------------
-- @return inputId of the current activity
-------------------------------------
function appliqManager:getCurrentInputId()
  local lastOutput=self.progressionOutputs[table.getn(self.progressionOutputs)]
  return self:getInputFromOutput(lastOutput) 
end

-------------------------------------
-- @return inputId of the current activity
-------------------------------------
function appliqManager:getCurrentInputName()
  local idInp=self:getCurrentInputId()
  local nameInp=self:getInputNameFromId(idInp)
  return nameInp
end


function appliqManager:scenarioGetFirstActivityName(i)
  local index=i or self.selectedScenarioIndex
  self.currentActivityID=self:getNextActivityFromOutput(self.start)
  self.progressionOutputs={self.start}
  return self.currentActivityID
end

-------------------------------------
-- Select the new activity giving a list of outputs
-- Set the currentActivity field and return its value
-- update progressionOutputs field
-- @return #table outputList list of the different output
-- @return nil on error
-------------------------------------
function appliqManager:setProgression(outputList)
  local val
  for i=1,table.getn(outputList) do
    val=self:next(outputList[i])
    if val==nil then
      return nil
    end
  end
  return val
end

-------------------------------------
-- update the list of Reached goals during progression
-- @return #boolean atLeatOneNewGoal indicating if at least one goal has been reachind during the progression
-------------------------------------
function appliqManager:updateReachedGoalsFromProgression()
  local atLeatOneNewGoal=false
  for i=1,table.getn(self.goals) do
  local currentGoal=(self.goals)[i]
  if(currentGoal.goal_links~=nil) then
    for j=1,table.getn(currentGoal.goal_links.goal_link) do
      local goalLink=currentGoal.goal_links.goal_link[j]
      if(goalLink._attr.object=="output_state") then
        local currentId=goalLink._attr.id_object
          for k=1,table.getn(self.progressionOutputs) do
            if(currentId==self.progressionOutputs[k]) then
              atLeatOneNewGoal=true
              self:addGoal(currentGoal)
            end
          end
        end
      end
    end
  end
  return atLeatOneNewGoal
end

-------------------------------------
-- add a goal
-- @param #xmlStuff representing a goal
-------------------------------------
function appliqManager:addGoal(g)
  local type=g._attr.type
  local idG=g._attr.id_goal
  table.insert(self.goalsReached[type],idG) -- goalsReached has two subtables : ludo and peda
end

-------------------------------------
-- reset Reached Goals
-------------------------------------
function appliqManager:resetReachedGoals()
  self.goalsReached={ludo={},peda={}}
end

-------------------------------------
-- Select the new activity giving the output of the current activity
-- Set the currentActivity field and return its value
-- update progressionOutputs field
-- @return #string id of activity of the first activity of selected scenario
-- @return nil on error
-------------------------------------
function appliqManager:next(newOutput)
  local outputs=self:listPossibleOutputsFromCurrentActivity()
  if(not contains(outputs, newOutput)) then
    return nil
  end
  self.currentActivityID=self:getNextActivityFromOutput(newOutput)
  table.insert(self.progressionOutputs,newOutput)
  return self.currentActivityID
end

-------------------------------------
-- List of unit tests for appliqManager
-------------------------------------

-------------------------------------
-- unit Tests for AppliqManager
-------------------------------------
function appliqManager:fullTest()
  -- Must be placed elsewhere
  --Full test on cristaux d'ehere
  assert(appliqManager~=nil)
  assert(self:selectScenario(1)==true)
  assert(self:validateValues())
  assert(self:scenarioGetN()==1)
  assert(self:scenarioGetName()=="Parcours complet")
  assert(self:scenarioGetId()=="143")
  assert(self:getActivityNameFromId("793")=="L'urgence du palier")
  assert(self:getInputNameFromId("940")=="Pour joueurs rapides")
  assert(self:getOutputNameFromId("1131")=="Utilisation de la masse")
  assert(self:getGoalNameFromId("1227")=="Identifier une source de chaleur")
  --assert(self:selectScenario(2)==false)--commented out for pretiness purpose (generates an error even if the assertion is successful)
  assert(self:startRoute()=="717")
  assert(self.progressionOutputs[1]=="start")
  assert(self.currentActivityID=="717")
  assert(self:next("11361")==nil) -- if not in possible output, it returns nill
  assert(self:next("1136")=="790")
  assert(self.currentActivityID=="790")
  assert(self.progressionOutputs[2]=="1136")
  assert(self:updateReachedGoalsFromProgression()==false)
  self:resetReachedGoals() -- nothing to reset, just a call for its own sake
  assert(self:startRoute()=="717")
  assert(self:setProgression({"1136","1254"})=="724")
  assert(self:updateReachedGoalsFromProgression()==true)
  assert(contains(self.goalsReached["ludo"],"1222") and contains(self.goalsReached["ludo"],"1227")) -- two goals related to the progression
  Spring:Echo("full test done with success")     
 end
 
-- other functions
function contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

