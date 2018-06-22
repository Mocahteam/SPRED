
--------------------------------------------------------------------------------
-- Utilities functions
--------------------------------------------------------------------------------
local function GetWords(line,spacers)
	local words={}
	local str=line
	local spacers=spacers or {" ","\t",","}
	local function isSpacer(s)
		for _,spacer in ipairs(spacers) do
			if spacer==s then
				return true
			end
		end
		return false
	end
	while string.len(str)>0 do
		local cursor1=1
		while isSpacer(string.sub(str,cursor1,cursor1)) and cursor1<=string.len(str) do
			cursor1=cursor1+1
		end
		local cursor2=cursor1
		while cursor2<=string.len(str) and not isSpacer(string.sub(str,cursor2,cursor2)) do
			cursor2=cursor2+1
		end
		if cursor1<cursor2 then
			table.insert(words,string.sub(str,cursor1,cursor2-1))
		end
		str=string.sub(str,cursor2,-1)
	end
	return words
end

local function isDigit(c)
	if c=="0"
	or c=="1"
	or c=="2"
	or c=="3"
	or c=="4"
	or c=="5"
	or c=="6"
	or c=="7"
	or c=="8"
	or c=="9" then
		return true
	else
		return false
	end
end

local function isInteger(w)
	if not w then
		return nil
	end
	if string.len(w)==0 then
		return false
	end
	for c=1,string.len(w) do
		if not isDigit(string.sub(w,c,c)) then
			return false
		end
	end
	return true
end

local function isFloat(w)
	if not w then
		return nil
	end
	if string.len(w)==0 then
		return false
	end
	local dot=false
	for c=1,string.len(w) do
		local char=string.sub(w,c,c)
		if char=="." then
			if dot then
				return false
			else
				dot=true
			end
		elseif not isDigit(char) then
			return false
		end
	end
	return true
end

local function isAnyKeyWord(word,KeyWords)
	if not word then
		return nil
	end
	for _,kw in ipairs(KeyWords) do
		if string.len(word)>=string.len(kw) then
			if string.lower(string.sub(word,1,string.len(kw)))==string.lower(kw) then
				if string.len(word)==string.len(kw) then
					--Spring.Echo("word "..word.." is keyword "..kw)
					return true,nil
				elseif isFloat(string.sub(word,string.len(kw)+1,string.len(word))) then
					--Spring.Echo("word "..word.." contains keyword "..kw)
					return true,string.sub(word,string.len(kw)+1,string.len(word))
				elseif string.len(word)>=2+string.len(kw) and string.sub(word,string.len(kw)+1,string.len(kw)+1)=="_" and isFloat(string.sub(word,string.len(kw)+2,string.len(word))) then
					--Spring.Echo("word "..word.." contains keyword "..kw.." followed by underscore")
					return true,string.sub(word,string.len(kw)+2,string.len(word))
				end
			end
		end
	end
	return false
end

local function Eat(list,pos)
	return table.remove(list,pos or 1)
end

local function IsNotNull(value)-- Is neither nil nor zero
	return ((tonumber(value or 0) or 0)~=0)
end

--------------------------------------------------------------------------------
-- Keywords used to modify unit/feature/weapon stats according to modoptions
--------------------------------------------------------------------------------
local KeyWord_ModOptionTag="ModifyStatistics"

local KeyWords_Property={"Property","parameter","P"}
local KeyWords_Custom={"customparams","Custom","cp","C"}-- Not supported yet
local KeyWords_Unit={"Unit","units","U"}
local KeyWords_Feature={"Feature","features","F","wreckage","wreckages","wreck","wrecks","corpse","corpses"}
local KeyWords_Weapon={"Weapon","weapons","W"}
local KeyWords_Skip={"Skip"}
local KeyWords_Set={"Set","="}
local KeyWords_Add={"Add","+"}
local KeyWords_Subtract={"Subtract","Substract","Sub","-"}
local KeyWords_Multiply={"Multiply","Mult","*","x"}
local KeyWords_Divide={"Divide","Div","/"}
local KeyWords_Help={"Help","h","?"}

local TypeList={
		{TypeName="unit", DefsTable=UnitDefs, KeyWords=KeyWords_Unit, },
		{TypeName="feature", DefsTable=FeatureDefs, KeyWords=KeyWords_Feature, },
		{TypeName="weapon", DefsTable=WeaponDefs, KeyWords=KeyWords_Weapon, },
	}

local function IsHeroUnitName(name)
	local HeroPrefix="mega"
	return string.len(name)>string.len(HeroPrefix)
		and string.lower(string.sub(name,1,string.len(HeroPrefix)))==string.lower(HeroPrefix)
end

local Aliases={
	{
		KeyWords={"hero","heroes","mega","megas"},
		Criterion=function(ud)
			local HeroPrefix="mega"
			return IsHeroUnitName(ud.unitname)
		end
	},
	{
		KeyWords={"spam","spams","light","small"},
		Criterion=function(ud)
			return IsNotNull(ud.canattack)
				and tonumber(ud.footprintx)==2
				and tonumber(ud.footprintz)==2
				and (ud.movementclass=="LIGHT" or not IsNotNull(ud.canmove))
				and tonumber(ud.maxdamage)<=1000
				and not IsHeroUnitName(ud.unitname)
		end
	},
	{
		KeyWords={"artillery","artilleries","arty","arties","medium"},
		Criterion=function(ud)
			return IsNotNull(ud.canmove)
				and IsNotNull(ud.canattack)
				and (tonumber(ud.maxdamage)>1000 or ud.movementclass~="LIGHT")
				and tonumber(ud.maxdamage)>=1000
				and tonumber(ud.maxdamage)<2500
				and #(ud.buildoptions or {})==0
				and not IsHeroUnitName(ud.unitname)
		end
	},
	{
		KeyWords={"heavy","heavies"},
		Criterion=function(ud)
			return IsNotNull(ud.canmove)
				and IsNotNull(ud.canattack)
				and tonumber(ud.maxdamage)>2500
				and #(ud.buildoptions or {})==0
				and not IsHeroUnitName(ud.unitname)
		end
	},
	{
		KeyWords={"constructor","constructors","con","cons"},
		Criterion=function(ud)
			return IsNotNull(ud.canmove)
				and tonumber(ud.maxdamage)>900
				and #(ud.buildoptions or {})>=1
		end
	},
	{
		KeyWords={"home","homebase","homebases"},
		Criterion=function(ud)
			return tonumber(ud.footprintx)>7 and tonumber(ud.footprintz)>7
		end
	},
	{
		KeyWords={"fac","factory","factories","minifac","minifacs"},
		Criterion=function(ud)
			return tonumber(ud.footprintx)==4
				and tonumber(ud.footprintz)==4
				and (#(ud.buildoptions or {})>=1 or string.lower(ud.unitname)=="port")
		end
	},
	{
		KeyWords={"building","buildings"},
		Criterion=function(ud)
			return tonumber(ud.footprintx)>3
				and tonumber(ud.footprintz)>3
		end
	},
	{
		KeyWords={"special","specials"},
		Criterion=function(ud)
			return tonumber(ud.footprintx)==4
				and tonumber(ud.footprintz)==4
				and #(ud.buildoptions or {})==0
				and string.lower(ud.unitname)~="port"
		end
	},
	{
		KeyWords={"mobile"},
		Criterion=function(ud)
			return IsNotNull(ud.canmove)
				and tonumber(ud.maxvelocity)>0
		end
	},
	{
		KeyWords={"everything","every","any","all"},
		Criterion=function(ud)
			return true
		end
	},
}

local AliasReferenceTable = {}-- Filled by FillAliasReferenceTable called by ApplyAllModifiers


--------------------------------------------------------------------------------
-- Function used to modifiy unit/feature/weapon stats according to modoptions
--------------------------------------------------------------------------------

local function OperatorSet(initial,operand)
	return operand
end

local function OperatorAdd(initial,operand)
	return tonumber(initial)+operand
end

local function OperatorSubtract(initial,operand)
	return tonumber(initial)-operand
end

local function OperatorMultiply(initial,operand)
	return tonumber(initial)*operand
end

local function OperatorDivide(initial,operand)
	return tonumber(initial)/operand
end

local function FillAliasReferenceTable()
	AliasReferenceTable={}
	for _,Category in ipairs(Aliases) do
		for _,Keyword in ipairs(Category.KeyWords) do
			AliasReferenceTable[string.lower(Keyword)]=Category.Criterion
		end
	end
end

local function AddWarningInCustomParams(Definition,NewChangeString)
	if not Definition.customparams then
		Definition.customparams={}
	end
	if not Definition.customparams.rebalanciation then
		Definition.customparams.rebalanciation=NewChangeString
	else
		Definition.customparams.rebalanciation=Definition.customparams.rebalanciation.."\n"..NewChangeString
	end
end

local function ModifyStat(DefsTable,name,property,operator,operand)
	if not DefsTable[name] then
		Spring.Echo("Error, there is no \""..name.."\"")
	else
		local oldValue=DefsTable[name][property]
		if type(oldValue)=="table" then -- Special case for damage table
			for k,v in pairs(DefsTable[name][property]) do
				local oldSubValue=DefsTable[name][property][k]
				if operator~=OperatorSet and not tonumber(oldSubValue) then
					Spring.Echo("Error, "..name.."'s "..property.." to "..tostring(k).." is \""..tostring(oldSubValue).."\" which is not a number but a "..type(oldSubValue))
				else
					DefsTable[name][property][k]=operator(DefsTable[name][property][k],operand)
					local newSubValue=DefsTable[name][property][k]
					Spring.Echo(name.."'s "..property.." to "..tostring(k).." modified from "..tostring(oldSubValue).." to "..tostring(newSubValue))
					AddWarningInCustomParams(DefsTable[name],""..property.." to "..tostring(k).." modified from "..tostring(oldSubValue).." to "..tostring(newSubValue))
				end
			end
		elseif operator==OperatorSet or tonumber(oldValue) then
			DefsTable[name][property]=operator(oldValue,operand)
			local newValue=DefsTable[name][property]
			Spring.Echo(name.."'s "..property.." modified from "..tostring(oldValue).." to "..tostring(newValue))
			AddWarningInCustomParams(DefsTable[name],""..property.." modified from "..tostring(oldValue).." to "..tostring(newValue))
		elseif oldValue~=nil then
			Spring.Echo("Error, "..name.."'s "..property.." cannot be modified from \""..tostring(oldValue).."\"")
		else
			local PossibleProperties=nil
			for k,v in pairs(DefsTable[name]) do
				PossibleProperties=(PossibleProperties and PossibleProperties..", " or "")..tostring(k)
			end
			Spring.Echo("Error, "..name.."'s "..property.." does not exist. Choose amongst:"..PossibleProperties)
		end
	end
end

local function RunModifierLine(line)

	local words={}
	if type(line)=="string" then
		words=GetWords(line)
	elseif type(line)=="table" then
		words=line
	else
		return false
	end

	local DefsTable, NamesTable, property, subfield = nil, nil, nil, nil
	local used = 0

	while(#words>0) do

		local found,param,fcofw,fcosw,iwc
		-- fcofw = first char of first word
		-- fcosw = first char of second word
		-- iwc = initial word count

		iwc=#words

		local operand, operator = nil, nil

		-- Skip
		found,param=isAnyKeyWord(words[1],KeyWords_Skip)
		if found then
			Eat(words)
			if not param then
				if isInteger(words[1]) then
					param=Eat(words)
				else
					param="1"
				end
			end
			for k=1,tonumber(param) do
				Eat(words)
			end
		end

		-- Help
		found,param=isAnyKeyWord(words[1],KeyWords_Help)
		if found and not param then
			Eat(words)
			local AllDefs={"UnitDefs","FeatureDefs","WeaponDefs"}
			for _,DefName in ipairs(AllDefs) do
				local DefTable=loadstring("return "..DefName)()
				Spring.Echo("================================================================================")
				Spring.Echo(string.upper(DefName).." (pre-game)")
				for name,stats in pairs(DefTable) do
					Spring.Echo("--------------------------------------------------------------------------------")
					Spring.Echo(DefName.."[ "..string.upper(name).." ]")
					Spring.Echo("")
					for key,value in pairs(stats) do
						if type(value)=="table" then
							local txt=nil
							for k,v in pairs(value) do
								txt=(txt and txt..", " or "").."["..tostring(k).."]="..tostring(v)
								if type(v)=="table" and v.name then
									txt=txt..tostring(v.name)
								end
							end
							Spring.Echo(tostring(key).." = {"..(txt or "").."}")
						else
							Spring.Echo(tostring(key).." = "..tostring(value))
						end
					end
				end
				Spring.Echo("================================================================================")
			end
			for _,Category in ipairs(Aliases) do
				local AliasedUnits={}
				for n,ud in pairs(UnitDefs) do
					if Category.Criterion(ud) then
						table.insert(AliasedUnits,n)
					end
				end
				Spring.Echo("Alias: "..table.concat(Category.KeyWords,", "))
				Spring.Echo("Stands for: "..table.concat(AliasedUnits,", "))
				Spring.Echo(" ")
			end
			Spring.Echo("================================================================================")
		end

		-- Type (Unit/Feature/Weapon)
		-- (eventually followed by alias)
		for _,t in ipairs(TypeList) do
			found,param=isAnyKeyWord(words[1],t.KeyWords)
			if found and not param then -- If the keyword is one of the type
				Eat(words)
				used, property, DefsTable, NamesTable, operand, operator = 0, nil, nil, nil, nil, nil
				DefsTable=t.DefsTable
				if t.DefsTable[words[1]] then -- If the word following the type is a name
					NamesTable={[string.lower(Eat(words))]=true}
					while(DefsTable[string.lower(words[1])]) do
						NamesTable[string.lower(Eat(words))]=true
					end
				else
					local Crit=AliasReferenceTable[string.lower(words[1])]
					if Crit then -- If the word following the type is an alias
						Eat(words)
						local AliasedUnits={}
						for n,ud in pairs(UnitDefs) do -- Alias are always refering to units, even if we take the weapons or wreckage of that unit
							if Crit(ud) then
								table.insert(AliasedUnits,n)
							end
						end
						if not NamesTable then
							NamesTable={}
						end
						if t.DefsTable==UnitDefs then
							for _,n in ipairs(AliasedUnits) do
								NamesTable[n]=true
							end
						elseif t.DefsTable==FeatureDefs then
							for _,n in ipairs(AliasedUnits) do
								if UnitDefs[n].corpse then
									NamesTable[string.lower(UnitDefs[n].corpse)]=true
								else
									Spring.Echo(n.." has no wreck")
								end
							end
						elseif t.DefsTable==WeaponDefs then
							for _,n in ipairs(AliasedUnits) do
								if UnitDefs[n].weapons then
									for _,weapon in pairs(UnitDefs[n].weapons) do
										NamesTable[string.lower(weapon.name)]=true
									end
								else
									Spring.Echo(n.." has no weapon")
								end
							end
						else
							Spring.Echo("Error: A type was selected, which is not unit, feature or weapon!")
						end
						AliasedUnits=nil
					else
						Spring.Echo("Error, \""..words[1].."\" is not a valid "..t.TypeName.." name!")
						local PossibleNames=nil
						for k,v in pairs(t.DefsTable) do
							PossibleNames=(PossibleNames and PossibleNames..", " or "")..k
						end
						Spring.Echo("Choose "..t.TypeName.." name(s) amongst "..PossibleNames)
					end
				end
			end
		end

		-- Property
		found,param=isAnyKeyWord(words[1],KeyWords_Property)
		if found and not param then
			Eat(words)
			property=string.lower(Eat(words))
			used=0
		end

		-- Divider
		found,param=isAnyKeyWord(words[1],KeyWords_Divide)
		if found then
			Eat(words)
			if not param then
				param=Eat(words)
			end
			operator=OperatorDivide
			operand=tonumber(param)
		end

		-- Multiplier
		found,param=isAnyKeyWord(words[1],KeyWords_Multiply)
		if found then
			Eat(words)
			if not param then
				param=Eat(words)
			end
			operator=OperatorMultiply
			operand=tonumber(param)
		end

		-- Subtracter
		found,param=isAnyKeyWord(words[1],KeyWords_Subtract)
		if found then
			Eat(words)
			if not param then
				param=Eat(words)
			end
			operator=OperatorSubtract
			operand=tonumber(param)
		end

		-- Adder
		found,param=isAnyKeyWord(words[1],KeyWords_Add)
		if found then
			Eat(words)
			if not param then
				param=Eat(words)
			end
			operator=OperatorAdd
			operand=tonumber(param)
		end

		-- Setter
		found,param=isAnyKeyWord(words[1],KeyWords_Set)
		if found then
			Eat(words)
			if not param then
				param=Eat(words)
			end
			operator=OperatorSet
			operand=param
		end

		-- Implicit Setter
		if isFloat(words[1]) then
			operator=OperatorSet
			operand=tonumber(Eat(words))
		end

		-- Implicit:
		-- If not a keyword:
		-- - If last property wasn't used, then it's value
		-- - Otherwise check if it's unit/feature/weapon
		-- - If not then check if it's an alias
		-- - If not then it's a property
		if iwc==#words then
			if property and (used==0) and (not operand) and (not operator or operator==OperatorSet) then
				operand=Eat(words)
				if not operator and string.len(operand)>1 and string.sub(operand,1,1)=="=" then
					operand=string.sub(operand,2)
				end
				operator=OperatorSet
			else
				local isCategory=false
				for _,t in ipairs(TypeList) do
					if t.DefsTable[string.lower(words[1])] and not isCategory then
						if used~=0 or property or operand or operator or DefsTable~=t.DefsTable then
							used, property, DefsTable, NamesTable, operand, operator = 0, nil, nil, nil, nil, nil
							DefsTable=t.DefsTable
							NamesTable={[string.lower(Eat(words))]=true}
						end
						while(DefsTable[string.lower(words[1])]) do
							NamesTable[string.lower(Eat(words))]=true
						end
						isCategory=true
					end
				end
				if not isCategory then
					local Crit=AliasReferenceTable[string.lower(words[1])]
					if Crit then -- If the word following the type is an alias
						Eat(words)
						if used~=0 or property or operand or operator then
							used, property, DefsTable, NamesTable, operand, operator = 0, nil, nil, nil, nil, nil
						end
						local AliasedUnits={}
						for n,ud in pairs(UnitDefs) do -- Alias are always refering to units, even if we take the weapons or wreckage of that unit
							if Crit(ud) then
								table.insert(AliasedUnits,n)
							end
						end
						for _,t in ipairs(TypeList) do
							local found,param=isAnyKeyWord(words[1],t.KeyWords)
							if found and not param then -- If the keyword is one of the type
								Eat(words)
								used, property, DefsTable, NamesTable, operand, operator = 0, nil, nil, nil, nil, nil
								DefsTable=t.DefsTable
							end
						end
						if not DefsTable then
							DefsTable=TypeList[1].DefsTable
						end
						if not NamesTable then
							NamesTable={}
						end
						if DefsTable==UnitDefs then
							for _,n in ipairs(AliasedUnits) do
								NamesTable[n]=true
							end
						elseif DefsTable==FeatureDefs then
							for _,n in ipairs(AliasedUnits) do
								if UnitDefs[n].corpse then
									NamesTable[string.lower(UnitDefs[n].corpse)]=true
								else
									Spring.Echo(n.." has no wreck")
								end
							end
						elseif DefsTable==WeaponDefs then
							for _,n in ipairs(AliasedUnits) do
								if UnitDefs[n].weapons then
									for _,weapon in pairs(UnitDefs[n].weapons) do
										NamesTable[string.lower(weapon.name)]=true
									end
								else
									Spring.Echo(n.." has no weapon")
								end
							end
						else
							Spring.Echo("Error: A type was selected, which is not unit, feature or weapon!")
						end
						AliasedUnits=nil
					else
						property=string.lower(Eat(words))
						used=0
					end
				end
			end
		end

		if DefsTable and NamesTable and property and operator and operand then
			used=used+1
			for name,_ in pairs(NamesTable) do
				ModifyStat(DefsTable,name,property,operator,operand)
			end
		end
	end
end

local function ApplyAllModifiers()
	if Spring and Spring.GetModOptions and Spring.GetModOptions() then -- Don't crash unitsync
		FillAliasReferenceTable()
		StatsModifierLineList={}
		local KeyWordLength=string.len(KeyWord_ModOptionTag)
		for key,value in pairs(Spring.GetModOptions()) do
			if string.len(key)>KeyWordLength and string.lower(string.sub(key,1,KeyWordLength))==string.lower(KeyWord_ModOptionTag) then
				local ok=true
				for cn=KeyWordLength+1,string.len(key) do
					local c=string.sub(key,cn,cn)
					if c~="0" and c~="1" and c~="2" and c~="3" and c~="4" and c~="5" and c~="6" and c~="7" and c~="8" and c~="9" then
						ok=false
					end
				end
				if ok then
					if string.sub(value,1,1)=="\"" and string.sub(value,-1)=="\"" then
						value=string.sub(value,2,string.len(value)-1)
					end
					local status,ret=pcall(RunModifierLine,value)
					if not status then
						Spring.Echo("RunModifierLine failed to decode \""..value.."\"")
						Spring.Echo("The error was: "..ret)
					end
				end
			end
		end
	end
end


--------------------------------------------------------------------------------
-- Do it
--------------------------------------------------------------------------------
ApplyAllModifiers()
