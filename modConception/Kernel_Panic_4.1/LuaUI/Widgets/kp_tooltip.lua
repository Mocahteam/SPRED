
-- ToDo:
-- - Factorise Build Button and Live Unit Tooltip (GenerateUnitTooltip(u,ud) where u=nil for Build Buttons?)
-- - Factorise Kamikaze weapon and normal weapon
-- - Find way to show Terminal and Firewall weapons
-- - Make a list of unit whose damage shan't be displayed, removed the two if ud.name~="mineblaster" then


function widget:GetInfo()
	return {
		name = "Kernel Panic Tooltip",
		desc = "Replace the default Spring tooltip by one customised for K.P.",
		author = "zwzsg",
		date = "January 16th, 2009",
		license = "Public Domain",
		layer = 10,
		enabled = true
	}
end


function widget:Initialize()
	Spring.SendCommands({"tooltip 0"})
	Spring.SendCommands({"ctrlpanel LuaUI/Widgets/KP_CtrlPanel.txt"})
end


function widget:Shutdown()
	WG.KP_ToolTip=nil
	Spring.SendCommands({"tooltip 1"})
end


-- The round2 function from http://lua-users.org/wiki/SimpleRound fails on 0.11
function FormatNbr(x,digits)
	local _,fractional = math.modf(x)
	if fractional==0 then
		return x
	elseif fractional<0.01 then
		return math.floor(x)
	elseif fractional>0.99 then
		return math.ceil(x)
	else
		local ret=string.format("%."..(digits or 0).."f",x)
		if digits and digits>0 then
			while true do
				local last = string.sub(ret,string.len(ret))
				if last=="0" or last=="." then
					ret = string.sub(ret,1,string.len(ret)-1)
				end
				if last~="0" then
					break
				end
			end
		end
		return ret
	end
end


function GenerateNewTooltip()
	local CurrentTooltip = Spring.GetCurrentTooltip()
	local NewTooltip = ""
	local HotkeyTooltip = ""
	local FoundTooltipType = nil
	local mx,my,gx,gy,gz,id

	mx,my = Spring.GetMouseState()
	if mx and my then
		local _,pos = Spring.TraceScreenRay(mx,my,true,true)
		if pos then
			gx,gy,gz=unpack(pos)
		end
		local kind,var1 = Spring.TraceScreenRay(mx,my,false,true)
		if kind=="unit" then
			id = var1
		end
	end

	if Spring.GetSelectedUnitsCount()>=1 then
		if Spring.GetSelectedUnitsCount()==1 then
			NewTooltip=NewTooltip.."\255\128\255\128One\255\196\255\196 unit selected\255\255\255\255\n"
		else
			NewTooltip=NewTooltip.."\255\128\255\128"..Spring.GetSelectedUnitsCount().."\255\196\255\196 units selected\255\255\255\255\n"
		end
	end

	local TerrainType = string.match(CurrentTooltip,"Terrain type: (.+)\nSpeeds T/K/H/S ")
	local TerrainSpeeds = string.match(CurrentTooltip,"Speeds T/K/H/S (.+)\nHardness")
	if TerrainType~=nil then
		NewTooltip=NewTooltip.."\255\255\255\64"..TerrainType
		if TerrainSpeeds~=nil then
			TerrainSpeedList={}
			for Speed in string.gmatch(TerrainSpeeds,"[0-7]+.[0-7]+") do
				table.insert(TerrainSpeedList,Speed)
			end
			if #TerrainSpeedList>=1 then
				local DiffSpeed = false
				for _,Speeds in pairs(TerrainSpeedList) do
					if Speeds~=TerrainSpeedList[1] then
						DiffSpeed = true
					end
				end
				for i=1,#TerrainSpeedList do
					while true do
						local last = string.sub(TerrainSpeedList[i],string.len(TerrainSpeedList[i]))
						if last=="0" or last=="." then
							TerrainSpeedList[i] = string.sub(TerrainSpeedList[i],1,string.len(TerrainSpeedList[i])-1)
						end
						if last~="0" then
							break
						end
					end
				end
				if DiffSpeed then
					NewTooltip=NewTooltip.."\nSpeeds x "..TerrainSpeeds
				else
					NewTooltip=NewTooltip.."\nSpeed x"..TerrainSpeedList[1]
				end
			end
		end
		if gx and gz then
			NewTooltip=NewTooltip.."\n\n("..(32)*math.floor((gx+16)/32)..","..(32)*math.floor((gz+16)/32)..")"
			--NewTooltip=NewTooltip.."\n\n("..math.floor(gx+0.5)..","..math.floor(gz+0.5)..")"
		end
		FoundTooltipType="terrain"
	end

	local workertimer = 128 -- Todo: read from selectunitlist
	local unitpre = string.match(CurrentTooltip,"(.-)\nBuild:") or string.match(CurrentTooltip,"(.-)\n\255\255\255\255Build:") or ""
	local unitname = string.match(CurrentTooltip,"Build: (.+) %- ")
	local unitdesc = string.match(CurrentTooltip," %- (.+)\nHealth ")
	local unithealth = string.match(CurrentTooltip,"Health (.+)\nMetal")
	local unitbuildtime = string.match(CurrentTooltip.."\n","Build time (.-)\n")
	local unitmetalcost = string.match(CurrentTooltip,"Metal cost (.-)\nEnergy cost ")
	local unitenergycost = string.match(CurrentTooltip,"\nEnergy cost (.-) Build time ")
	if unitname and unitdesc and unithealth and unitbuildtime then
		local fud = nil
		for _,ud in pairs(UnitDefs) do
			--[[
			Spring.Echo("ud.humanName=",ud.humanName)
			Spring.Echo("ud.tooltip=",ud.tooltip)
			Spring.Echo("ud.health=",ud.health)
			Spring.Echo("ud.buildTime=",ud.buildTime)
			]]--
			if ud.humanName==unitname and ud.tooltip==unitdesc and ""..ud.health==unithealth and
				""..ud.buildTime==unitbuildtime and ""..ud.metalCost==unitmetalcost and ""..ud.energyCost==unitenergycost then
				fud=ud
			end
		end
		if fud then
			NewTooltip = NewTooltip.."\n"..unitpre.."\n"..fud.humanName.." ("..fud.tooltip..")\n"..
				"\255\213\213\255".."Build time: ".."\255\170\170\255"..
				math.floor((29+math.floor(31+fud.buildTime/(workertimer/32)))/30).."s\n"..
				"\255\255\213\213Health: ".."\255\255\170\170"..fud.health
			if fud.canKamikaze then
				local weapname=fud.selfDExplosion
				local weap=nil
				for wid,weaponDef in pairs(WeaponDefs) do
					if weaponDef.name==weapname then
						weap=WeaponDefs[wid]
					end
				end
				if weap then
					local weapon_action="Damage"
					if weap.damages and weap.damages.paralyzeDamageTime and weap.damages.paralyzeDamageTime>0 then
						weapon_action="Paralyze"
					end
					NewTooltip = NewTooltip.."   \255\255\213\213"..weapon_action..": \255\255\170\170"..FormatNbr(weap.damages[Game.armorTypes.default],2).."/once"
				end
			elseif fud.weapons and fud.weapons[1] and fud.weapons[1].weaponDef then
				local weap=WeaponDefs[fud.weapons[1].weaponDef]
				if weap and weap.damages[Game.armorTypes.default]>1 then
					if fud.name~="mineblaster" then
						local weapon_action="Damage"
						if weap.damages and weap.damages.paralyzeDamageTime and weap.damages.paralyzeDamageTime>0 then
							weapon_action="Paralyze"
						end
						NewTooltip = NewTooltip.."   \255\255\205\125"..weapon_action..": \255\255\178\057"..
							FormatNbr(weap.damages[Game.armorTypes.default],2).."\255\255\205\125/\255\255\178\057"..FormatNbr(weap.reload,1).."s"
					end
				end
			end
			NewTooltip = NewTooltip.."\255\255\255\255\n"
			if fud.speed and fud.speed>0 then
				NewTooltip = NewTooltip.."\255\193\255\187Speed: \255\134\255\121"..FormatNbr(fud.speed,2).."\255\255\255\255\n"
			end
			FoundTooltipType="knownbuildbutton"
		else
			NewTooltip = NewTooltip.."\n"..unitpre.."\n"..unitname.." ("..unitdesc..")\n"..
				"\255\255\213\213Health: ".."\255\255\170\170"..unithealth..
				"\n\255\213\213\255Build time: ".."\255\170\170\255"..
				math.floor((29+math.floor(31+unitbuildtime/(workertimer/32)))/30).."s"..
				"\255\255\255\255\n"
			FoundTooltipType="unknownbuildbutton"
		end
	end

	local isItLiveUnitTooltip = string.match(CurrentTooltip,"Experience (.+) Cost ")
	if isItLiveUnitTooltip or CurrentTooltip=="" then
		-- id being calucated way above
		if not id and Spring.GetSelectedUnitsCount()>=1 then
			id = Spring.GetSelectedUnits()[Spring.GetSelectedUnitsCount()]
		end
		if id then
			local u=id
			local ud=UnitDefs[Spring.GetUnitDefID(u)]
			local health,maxHealth,paralyzeDamage,captureProgress,buildProgress = Spring.GetUnitHealth(u)
			stunned_or_beingbuilt, stunned, beingbuilt = Spring.GetUnitIsStunned(u)
			NewTooltip = NewTooltip.."\n"..ud.humanName.." ("..ud.tooltip..")\n"
			if buildProgress and buildProgress<1 then
				NewTooltip = NewTooltip.."\255\213\213\255".."Build progress: ".."\255\170\170\255"..FormatNbr(100*buildProgress).."%\n"
			end
			NewTooltip = NewTooltip.."\255\255\213\213Health: ".."\255\255\170\170"..math.floor(health).."\255\255\213\213/\255\255\170\170"..math.floor(maxHealth)
			if stunned then
				NewTooltip = NewTooltip.."\255\194\173\255   paralysed"
			end
			if Spring.GetUnitIsCloaked(u) then
				NewTooltip = NewTooltip.."\255\170\170\170   cloacked"
			end
			if ud.canKamikaze then
				local weapname=ud.selfDExplosion
				local weap=nil
				for wid,weaponDef in pairs(WeaponDefs) do
					if weaponDef.name==weapname then
						weap=WeaponDefs[wid]
					end
				end
				if weap then
					local weapon_action="Damage"
					if weap.damages and weap.damages.paralyzeDamageTime and weap.damages.paralyzeDamageTime>0 then
						weapon_action="Paralyze"
					end
					NewTooltip = NewTooltip.."\n\255\255\213\213Damage: \255\255\170\170"..FormatNbr(weap.damages[Game.armorTypes.default],2).."/once"
				end
			elseif ud.weapons and ud.weapons[1] and ud.weapons[1].weaponDef then
				local weap=WeaponDefs[ud.weapons[1].weaponDef]
				if weap.damages[Game.armorTypes.default]>1 then
					if ud.name~="mineblaster" then
						local weapon_action="Damage"
						if weap.damages and weap.damages.paralyzeDamageTime and weap.damages.paralyzeDamageTime>0 then
							weapon_action="Paralyze"
						end
						NewTooltip = NewTooltip.."\n\255\255\205\125"..weapon_action..": \255\255\178\057"..
						FormatNbr(weap.damages[Game.armorTypes.default],2).."\255\255\205\125/\255\255\178\057"..FormatNbr(weap.reload,1).."s"
					end
				end
			end
			if Spring.GetUnitExperience(u) and Spring.GetUnitExperience(u)>0 then
				NewTooltip = NewTooltip.."\255\255\255\255    XP: "..FormatNbr(Spring.GetUnitExperience(u),4)
			end
			NewTooltip = NewTooltip.."\255\255\255\255\n"
			if Spring.GetSpectatingState() or Spring.AreTeamsAllied(Spring.GetUnitTeam(u),Spring.GetMyTeamID()) then
				if ud.name=="port" or ud.name=="connection" then
					NewTooltip = NewTooltip.."\n\255\255\255\128Bufferised Packets: \255\255\255\057"..(Spring.GetTeamRulesParam(Spring.GetUnitTeam(u),"bufferSize") or "?").."\255\255\255\255\n"
				end
			end
			if ud.speed and ud.speed>0 then
				local vx,vy,vz = Spring.GetUnitVelocity(u)
				local speed = 30*math.sqrt(vx*vx+vz*vz)
				NewTooltip = NewTooltip.."\255\193\255\187Speed: \255\134\255\121"..FormatNbr(speed).."\255\193\255\187/\255\134\255\121"..FormatNbr(ud.speed,2).."\255\255\255\255\n"
			end
			local ONS_Mode = Spring.GetTeamRulesParam(Spring.GetUnitTeam(u),"ONS_Mode")
			local ONS_TeamMaxLinks = Spring.GetUnitRulesParam(u,"ONS_TeamMaxLinks") or Spring.GetTeamRulesParam(Spring.GetUnitTeam(u),"ONS_TeamMaxLinks")
			local ONS_Shielded = Spring.GetUnitRulesParam(u,"ONS_Shielded")
			local ONS_FromCenter = Spring.GetUnitRulesParam(u,"ONS_FromCenter")
			local ONS_SourceID = Spring.GetUnitRulesParam(u,"ONS_SourceID")
			local ONS_FromExtremity = Spring.GetUnitRulesParam(u,"ONS_FromExtremity")
			local ONS_isExtremity = Spring.GetUnitRulesParam(u,"ONS_isExtremity")
			if ONS_Mode and ONS_Mode~=0 then
				if ONS_Shielded==1 then
					NewTooltip=NewTooltip.."\255\064\255\064Shielded\255\255\255\255:\n"
				elseif ONS_Shielded==0 then
					NewTooltip=NewTooltip.."\255\255\064\064Un-shielded\255\255\255\255:\n"
				elseif ONS_Shielded then
					NewTooltip=NewTooltip.."\255\255\255\255Shield state = "..(ONS_Shielded or "?").."\255\255\255\255:\n"
				end
				if ONS_FromCenter and ONS_TeamMaxLinks then
					NewTooltip=NewTooltip..ONS_FromCenter.."/"..ONS_TeamMaxLinks.." links from center"
				end
				if ONS_SourceID then
					NewTooltip=NewTooltip.."   (Linked)"
				else
					if ONS_FromCenter~=nil and ONS_FromCenter==0 then
						NewTooltip=NewTooltip.."   (Source)"
					elseif ONS_Shielded then
						if buildProgress and buildProgress<1 then
							NewTooltip=NewTooltip.."   (Un-built)"
						else
							NewTooltip=NewTooltip.."   (Un-linked)"
						end
					end
				end
				if ONS_FromExtremity and ONS_TeamMaxLinks then
					NewTooltip=NewTooltip.."\n"..ONS_FromExtremity.."/"..ONS_TeamMaxLinks.." links from extremity"
				end
				if ONS_isExtremity~=nil then
					if ONS_isExtremity==1 then
						NewTooltip=NewTooltip.."   (Is Extremity)"
					end
					if ONS_isExtremity==0 then
						NewTooltip=NewTooltip.."   (Is NOT Extremity)"
					end
				end
			end

			FoundTooltipType="liveunit"

		end
	end

	local hotkeys = string.match(CurrentTooltip.."\n","Hotkeys: (.-)\n")
	if hotkeys then
		HotkeyTooltip = "\n\255\255\196\128Hotkeys: ".."\255\255\128\001"..hotkeys.."\255\255\255\255"
		CurrentTooltip=string.gsub(CurrentTooltip.."\n","Hotkeys: .-\n","")
		NewTooltip=NewTooltip..HotkeyTooltip
		CurrentTooltip=CurrentTooltip..HotkeyTooltip
	end

	local action = string.match(CurrentTooltip,"(.-)\n")
	if action then
		action = string.match(action,"(.-): ")
		if action then
			CurrentTooltip=string.gsub(CurrentTooltip,"(.-): ","",1)
			CurrentTooltip="\255\170\255\170"..action..":\255\255\255\255 "..CurrentTooltip
		end
	end

	if FoundTooltipType then
		return NewTooltip
	else
		return CurrentTooltip
	end
end


local FontSize
local xTooltipSize = 0
local yTooltipSize = 0

function widget:DrawScreenEffects(vsx,vsy)
	WG.KP_ToolTip=nil
	if Spring.IsGUIHidden() then
		return
	end

	local nttString = GenerateNewTooltip()
	local nttList = {}
	local maxWidth = 0
	for line in string.gmatch(nttString,"[^\r\n]+") do
		table.insert(nttList,"\255\255\255\255"..line)
		if gl.GetTextWidth(line)>maxWidth then
			maxWidth=gl.GetTextWidth(line)
		end
	end

	if not FontSize then
		FontSize = math.max(8,4+vsy/100)
	end

	local TextWidthFixHack = 1
	if tonumber(string.sub(Game.version,1,4))<=0.785 and string.sub(Game.version,1,5)~="0.78+" then
		TextWidthFixHack = (vsx/vsy)*(4/3)
	end
	xTooltipSize = FontSize*(1+maxWidth*TextWidthFixHack)
	yTooltipSize = FontSize*(1+#nttList)

	-- Bottom left position by default
	local x1,y1,x2,y2=0,0,xTooltipSize,yTooltipSize

	-- if there's a KP_OnsHelpTip, and if it is on bottom left corner, then place KP_ToolTip above
	if WG.KP_OnsHelpTip and WG.KP_OnsHelpTip.x1 and WG.KP_OnsHelpTip.y1 and WG.KP_OnsHelpTip.x1==0 and WG.KP_OnsHelpTip.y1==0 then
		y1=WG.KP_OnsHelpTip.y2 or 0
		y2=y1+yTooltipSize
	end

	-- Note: this line is done even if the KP_ToolTip is devoid of text
	-- The only case where KP_ToolTip is nil are when the widget is off or the GUI is hidden
	WG.KP_ToolTip={x1=x1,y1=y1,x2=x2,y2=y2,xSize=xTooltipSize,ySize=yTooltipSize,FontSize=FontSize}

	gl.Blending(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA) -- default
	if WG.MidKnightBG then
		gl.Color(1,1,1,1)
		gl.Texture("bitmaps/tooltipbg.png")
		gl.TexRect(x1,y1,x2*1.2,y2*1.2,0.01,0.99,0.99,0.01)
		gl.Texture(false)
	else
		gl.Color(0,1,0,0.5)
		gl.Rect(x1,y1,x2,y2)
		gl.Color(0,1,0,1)
		gl.LineWidth(1)
		gl.Shape(GL.LINE_LOOP,{
			{v={x1,y2}},{v={x2,y2}},
			{v={x2,y1}},{v={x1,y1}},})
		gl.Color(1,1,1,1)
	end
	for k=1,#nttList do
		gl.Text(nttList[k],x1+FontSize/2,y1+FontSize*(#nttList+0.5-k),FontSize,'o')
	end
	gl.Text("\255\255\255\255 ",0,0,FontSize,'o') -- Reset color to white for other widgets using gl.Text
	if not WG.MidKnightBG then
		gl.Color(0,1,0,0.15)
		gl.Rect(x1,y1,x2,y2)
		gl.Color(1,1,1,1)
	end
end


function widget:MouseWheel(up,value)
	local xMouse,yMouse = Spring.GetMouseState()
	if xMouse < xTooltipSize and yMouse < yTooltipSize and not Spring.IsGUIHidden() then
		if up then
			FontSize = math.max(FontSize - 1,2)
		else
			FontSize = FontSize + 1
		end
		return true
	end
	return false
end



