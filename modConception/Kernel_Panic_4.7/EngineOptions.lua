--  Custom Options Definition Table format

--  NOTES:
--  - using an enumerated table lets you specify the options order

--
--  These keywords must be lowercase for LuaParser to read them.
--
--  key:      the string used in the script.txt
--  name:     the displayed name
--  desc:     the description (could be used as a tooltip)
--  type:     the option type
--  def:      the default value
--  min:      minimum value for number options
--  max:      maximum value for number options
--  step:     quantization step, aligned to the def value
--  maxlen:   the maximum string length for string options
--  items:    array of item strings for list options
--  scope:    'all', 'player', 'team', 'allyteam'      <<< not supported yet >>>
--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Example EngineOptions.lua 
--

local options = 
{
  {
    key    = 'GameMode',
    name   = 'Game end condition',
    desc   = 'Determines what condition triggers the defeat of a player',
    type   = 'list',
    def    = '1',
    items  = 
    {
      { 
        key  = '0',
        name = 'Kill everything',
        desc = 'The player will lose only after all his units are dead (not counting mines)\n',
      },
      {
        key  = '1',
        name = 'Kill all factories',
        desc = 'The player will lose when his homebase and all his minifacs will be dead\n',
      },
      {
        key  = '2',
        name = 'Kill homebase',
        desc = 'The player will lose when his homebase will be dead\nAlso, every unit will inherit the lineage from the player whom built it\neven if shared, so that when the homebase dies everything die\n',
      },
      {
        key  = '3',
        name = 'Never ends',
        desc = 'The player will not lose, ever, even when no units left',
      },
    },
  },
    
  {
    key    = 'MaxUnits',
    name   = 'Max units',
    desc   = 'Determines the ceiling of how many units and buildings a player is allowed  to own at the same time',
    type   = 'number',
    def    = 1000,
    min    = 1,
    max    = 10000,
    step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },

  {
    key    = 'LimitSpeed',
    name   = 'Speed Restriction',
    desc   = 'Limits maximum and minimum speed that the players will be allowed to change to',
    type   = 'section',
  },
  
  {
    key    = 'MaxSpeed',
    name   = 'Maximum game speed',
    desc   = 'Sets the maximum speed that the players will be allowed to change to',
    type   = 'number',
    section= 'LimitSpeed',
    def    = 5,
    min    = 0,
    max    = 100,
    step   = 0.1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },
  
  {
    key    = 'MinSpeed',
    name   = 'Minimum game speed',
    desc   = 'Sets the minimum speed that the players will be allowed to change to',
    type   = 'number',
    section= 'LimitSpeed',
    def    = 0,
    min    = 0,
    max    = 100,
    step   = 0.1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },

  {
    key    = 'FixedAllies',
    name   = 'Fixed ingame alliances',
    desc   = 'Disables the possibility of players to dynamically change allies ingame',
    type   = 'bool',
    def    = true,
  },
  
  {
    key    = 'GhostedBuildings',
    name   = 'Ghosted buildings',
    desc   = "Once an enemy building will be spotted\n a ghost trail will be placed to memorize location even after the loss of the line of sight",
    type   = 'bool',
    def    = true,
  },

}
return options
