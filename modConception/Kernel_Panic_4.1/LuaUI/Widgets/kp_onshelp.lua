

function widget:GetInfo()
	return {
		name = "Kernel Panic O.N.S. help tips",
		desc = "Display info tips related to O.N.S. shields",
		author = "zwzsg",
		date = "January 5th, 2009",
		license = "Public Domain",
		layer = 15,
		enabled = true
	}
end

local small_shield_radius = 64
local large_shield_radius = 128
local refresh_period = 3 -- in seconds
local text_alpha = 0
local text_timer = 0
local text_lines = {}
local text_width = 0

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

local recently_attacked_enemy_shielded_buildings={}
local enemy_unshielded_buildings={}

function widget:Initialize()
	-- Useless if not ONS mode
	if Spring.GetModOptions()==nil or Spring.GetModOptions()["ons"]==nil or Spring.GetModOptions()["ons"]=="0" then
		widgetHandler:RemoveWidget()
		return
	else
		table.insert(text_lines,"The \255\128\255\128green shielded\255\255\255\255 buildings")
		table.insert(text_lines,"are invulnerable!")
		if Spring.GetModOptions()["ons"]=="1" then
			table.insert(text_lines,"")
			table.insert(text_lines,"You must kill every minifac")
			table.insert(text_lines,"to make the homebase vulnerable!")
		else
			table.insert(text_lines,"")
			table.insert(text_lines,"Go find and attack another building,")
			table.insert(text_lines,"one with the \255\255\128\128shield down\255\255\255\255!")
			if Spring.GetModOptions()["ons"]=="4" then
				table.insert(text_lines,"")
				table.insert(text_lines,"If there is none, build a building of yours")
				table.insert(text_lines,"next to an enemy green shield to take it down!")
			end
		end
	end
	text_width = 0
	for _,line in ipairs(text_lines) do
		if gl.GetTextWidth(line)>text_width then
			text_width=gl.GetTextWidth(line)
		end
	end
	if tonumber(string.sub(Game.version,1,4))<=0.785 and string.sub(Game.version,1,5)~="0.78+" then
		text_width = text_width*(vsx/vsy)*(4/3)
	end
end

function widget:GameFrame(f)

	-- Calculate the text staying for a full period, then fading out for the next period if no more shield attacked
	if text_alpha>0 then
		if (f-text_timer)/30.0>refresh_period then
			text_alpha = (2*refresh_period-(f-text_timer)/30.0)/(refresh_period)
			if text_alpha<0 then
				text_alpha=0
				text_timer=0
			end
		end
	end

	if f%(30*refresh_period)<0.1 then -- not too often
		local buildings={}
		for _,id in ipairs(Spring.GetTeamUnits(Spring.GetLocalTeamID())) do
			local CmdQ=Spring.GetCommandQueue(id)
			if CmdQ and CmdQ[1] then
				local cmd=CmdQ[1]
				if cmd.id==CMD.MOVE
				or cmd.id==CMD.PATROL
				or cmd.id==CMD.FIGHT
				or cmd.id==CMD.ATTACK
				or cmd.id==CMD.AREA_ATTACK
				or cmd.id==CMD.DGUN
				or cmd.id==CMD_SPECIAL 
				or cmd.id==CMD_NX
				or cmd.id==CMD_BUG2MINE
				or cmd.id==CMD_DISPATCH
				or cmd.id==CMD_DEPLOY
				or cmd.id==CMD_BOMBARD 
				or cmd.id==CMD_AIRSTRIKE then
					if #cmd.params==1 then -- 1 parameters: unitid
						if isAnyBuilding[Spring.GetUnitDefID(cmd.params[1])] then
							table.insert(buildings,cmd.params[1])
						end
					elseif #cmd.params==3 then -- 3 parameters: mappos
						for _,b in ipairs(Spring.GetUnitsInCylinder(cmd.params[1],cmd.params[3],small_shield_radius)) do
							if isSmallBuilding[Spring.GetUnitDefID(b)] then
								table.insert(buildings,b)
							end
						end
						for _,b in ipairs(Spring.GetUnitsInCylinder(cmd.params[1],cmd.params[3],large_shield_radius)) do
							if isBigBuilding[Spring.GetUnitDefID(b)] then
								table.insert(buildings,b)
							end
						end
					elseif #cmd.params==4 then -- 4 parameters: mappos+radius
						for _,b in ipairs(Spring.GetUnitsInCylinder(cmd.params[1],cmd.params[3],cmd.params[4]+small_shield_radius)) do
							if isSmallBuilding[Spring.GetUnitDefID(b)] then
								table.insert(buildings,b)
							end
						end
						for _,b in ipairs(Spring.GetUnitsInCylinder(cmd.params[1],cmd.params[3],cmd.params[4]+large_shield_radius)) do
							if isBigBuilding[Spring.GetUnitDefID(b)] then
								table.insert(buildings,b)
							end
						end
					elseif #cmd.params==6 then -- 6 parameters: startpos+endpos
						for _,b in ipairs(Spring.GetUnitsInRectangle(cmd.params[1],cmd.params[3],cmd.params[4],cmd.params[6])) do
							if isAnyBuilding[Spring.GetUnitDefID(b)] then
								table.insert(buildings,b)
							end
						end
					end
				end
			end
		end

		recently_attacked_enemy_shielded_buildings={}

		for _,u in ipairs(buildings) do
			if Spring.IsUnitVisible(u) and not Spring.IsUnitAllied(u) then
				GreenShieldState,_=Spring.GetUnitShieldState(u)
				-- if GreenShieldState and GreenShieldState>0.5 then -- Only work in gadget or for allied units
				if Spring.GetUnitRulesParam(u,"ONS_Shielded") and  Spring.GetUnitRulesParam(u,"ONS_Shielded")==1 then
					for p,v in ipairs(recently_attacked_enemy_shielded_buildings) do
						if u==v then
							table.remove(recently_attacked_enemy_shielded_buildings,p)
						end
					end
					table.insert(recently_attacked_enemy_shielded_buildings,u)
					text_alpha=1.0
					text_timer=f
				end
			end
		end

	end
end

function widget:DrawScreenEffects(vsx, vsy)
	WG.KP_OnsHelpTip=nil
	if Spring.IsGUIHidden() then
		return
	end

	-- Draw billboards over player-attacked green shields
	if text_alpha>0 then
		gl.ResetState()

		for _,u in ipairs(recently_attacked_enemy_shielded_buildings) do
			if Spring.ValidUnitID(u) and not Spring.GetUnitIsDead(u) then

				-- Calculating unit_shield_screen_radius (and getting usx, usy)
				local usx,usy,unit_shield_world_radius,unit_shield_screen_radius
					if isBigBuilding[Spring.GetUnitDefID(u)] then
						unit_shield_world_radius = large_shield_radius
					else
						unit_shield_world_radius = small_shield_radius
					end
					local ux,uy,uz=Spring.GetUnitPosition(u)
					uy=uy+unit_shield_world_radius
					usx,usy = Spring.WorldToScreenCoords(ux,uy,uz)
					local camx,camy,camz = Spring.GetCameraDirection()
					local orthcamx = camy*camz
					local orthcamy = -2*camx*camz
					local orthcamz = camx*camy
					local orthcamlength = math.sqrt(orthcamx*orthcamx+orthcamy*orthcamy+orthcamz*orthcamz)
					orthcamx = unit_shield_world_radius*orthcamx/orthcamlength
					orthcamy = unit_shield_world_radius*orthcamy/orthcamlength
					orthcamz = unit_shield_world_radius*orthcamz/orthcamlength
					local up96sx,up96sy=Spring.WorldToScreenCoords(ux+orthcamx,uy+orthcamy,uz+orthcamz)
					unit_shield_screen_radius = math.sqrt((up96sx-usx)*(up96sx-usx)+(up96sy-usy)*(up96sy-usy))

				-- Drawing the ONS Tip
				if Spring.IsSphereInView(ux,uy,uz) then

					local FontSize = unit_shield_screen_radius*5/(1+text_width)
					local xONSTipSize=FontSize*(1+text_width)
					local yONSTipSize=FontSize*(1+#text_lines)
					gl.Color(0.75,0.5,1,0.2)
					gl.Rect(usx-xONSTipSize/2,usy,usx+xONSTipSize/2,usy+yONSTipSize)
					gl.Color(1,1,1,0.1)
					for n,_ in ipairs(text_lines) do
						gl.Text(text_lines[n], usx-xONSTipSize/2+FontSize/2, usy+yONSTipSize+(-0.5-n)*FontSize, FontSize ,'o')
					end
					gl.Color(0.75,0.5,1,0.05)
					gl.Rect(usx-xONSTipSize/2,usy,usx+xONSTipSize/2,usy+yONSTipSize)
					gl.Color(0.75,0.5,1,0.5)
					gl.LineWidth(FontSize/4)
					gl.Shape(GL.LINES,{
						{v={usx-xONSTipSize/2+FontSize/4,usy+yONSTipSize-FontSize/8}},
						{v={usx+xONSTipSize/2-FontSize/4,usy+yONSTipSize-FontSize/8}},
						{v={usx+xONSTipSize/2-FontSize/8,usy+yONSTipSize}},
						{v={usx+xONSTipSize/2-FontSize/8,usy}},
						{v={usx+xONSTipSize/2-FontSize/4,usy+FontSize/8}},
						{v={usx-xONSTipSize/2+FontSize/4,usy+FontSize/8}},
						{v={usx-xONSTipSize/2+FontSize/8,usy}},
						{v={usx-xONSTipSize/2+FontSize/8,usy+yONSTipSize}},})
					gl.Color(1,1,1,1)
				end
			end
		end
	end

	-- Find unit under cursor
	local mx,my = Spring.GetMouseState()
	local u=nil
	if mx and my then
		local kind,var1 = Spring.TraceScreenRay(mx,my,false,true)
		if kind=="unit" then
			u = var1
		end
	end

	-- Draw tooltip-like thing about ONS status when over a shield
	if u and isAnyBuilding[Spring.GetUnitDefID(u)] and Spring.GetUnitRulesParam(u,"ONS_Shielded") then

		-- Get team and players of that unit
		local TeamID=Spring.GetUnitTeam(u)
		local TeamPlayerNames=nil
		local _,_,_,isAiTeam=Spring.GetTeamInfo(TeamID)
		for _,PlayerID in ipairs(Spring.GetPlayerList(TeamID,true)) do
			local PlayerName=Spring.GetPlayerInfo(PlayerID)
			TeamPlayerNames=(TeamPlayerNames and TeamPlayerNames.."," or "")..PlayerName
		end
		if isAiTeam then
			TeamPlayerNames=(TeamPlayerNames and TeamPlayerNames.."," or "").."Bot"
		end

		-- The text to display:
		local ONS_Mode=Spring.GetTeamRulesParam(TeamID,"ONS_Mode") or "Unknown"
		local txt="Team"..TeamID.."("..(TeamPlayerNames or "")..") ONS status:"
		txt=txt.."\r\n\255\128\255\255    "
		if ONS_Mode==0 then
			txt=txt.."No ONS"
		elseif ONS_Mode==1 then
			txt=txt.."Homebase-only ONS"
		elseif ONS_Mode==2 then
			txt=txt.."Weak ONS"
		elseif ONS_Mode==3 then
			txt=txt.."Strong ONS"
		elseif ONS_Mode==4 then
			txt=txt.."Ultra ONS"
		else
			txt=txt.."Unknown ONS mode"
		end
		txt=txt.."\255\255\255\255"
		if ONS_Mode==0 then
			txt=txt.."\r\nONS mode not activated."
		elseif ONS_Mode==1 then
			txt=txt.."\r\nHomebase shielded as long as one building is up."
		elseif ONS_Mode==2 then
			txt=txt.."\r\nEvery extremities unshielded."
		elseif ONS_Mode==3 then
			txt=txt.."\r\nFurthest extremities unshielded."
		elseif ONS_Mode==4 then
			txt=txt.."\r\nBuildings near enemies buildings unshielded."
		else
			txt=txt.."\r\nUndocumented kind of ONS."
		end

		-- Calculating where to display, then display it
		local FontSize=WG.KP_ToolTip and WG.KP_ToolTip.FontSize or nil
		local xSize = 0
		local ySize = 0
		local nttString = txt
		local nttList = {}
		local maxWidth = 0
		if not FontSize then
			FontSize = math.max(8,4+vsy/100)
		end
		local TextWidthFixHack = 1
		if tonumber(string.sub(Game.version,1,4))<=0.785 and string.sub(Game.version,1,5)~="0.78+" then
			TextWidthFixHack = (vsx/vsy)*(4/3)
		end
		for line in string.gmatch(nttString,"[^\r\n]+") do
			table.insert(nttList,"\255\255\255\255"..line)
			if gl.GetTextWidth(line)>maxWidth then
				maxWidth=gl.GetTextWidth(line)
			end
		end
		xSize = FontSize*(1+maxWidth*TextWidthFixHack)
		ySize = FontSize*(1+#nttList)

		-- Bottom right position by default
		local x1,y1,x2,y2=vsx-xSize,0,vsx,ySize

		-- If KP_ToolTip, then place near it
		if WG.KP_ToolTip then
			if xSize<1.5*WG.KP_ToolTip.xSize and ySize>0.7*WG.KP_ToolTip.ySize then
				-- Place the KP_OnsHelpTip just next to KP_ToolTip, right of it, top edge aligned to it
				x1=WG.KP_ToolTip.x2--+FontSize
				x2=x1+xSize
				y2=math.max(WG.KP_ToolTip.y2,ySize)
				ySize=math.max(WG.KP_ToolTip.ySize,ySize)--Not sure if I want
				y1=y2-ySize
			else
				-- Place KP_OnsHelpTip just below KP_ToolTip
				-- That is, place KP_OnsHelpTip at bottom left corner and let KP_ToolTip place itself above
				xSize=math.max(xSize,WG.KP_ToolTip.xSize)
				x1,y1,x2,y2=0,0,xSize,ySize
			end
		end

		-- Saving the position of KP_OnsHelpTip pos for KP_ToolTip to access it
		WG.KP_OnsHelpTip={x1=math.min(x1,x2),y1=math.min(y1,y2),x2=math.max(x1,x2),y2=math.max(y1,y2),xSize=math.abs(x2-x1),ySize=math.abs(y2-y1)}

		gl.ResetState()
		gl.Blending(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA) -- default
		gl.Color(0.75,0.5,1,0.5)
		gl.Rect(x1,y1,x2,y2)
		gl.Color(0.75,0.5,1,1)
		gl.LineWidth(1)
		gl.Shape(GL.LINE_LOOP,{
			{v={x1,y2}},{v={x2,y2}},
			{v={x2,y1}},{v={x1,y1}},})
		gl.Color(1,1,1,1)
		for k=1,#nttList do
			gl.Text(nttList[k],x1+FontSize/2,y2-FontSize*(0.5+k),FontSize,'o')
		end
		gl.Text("\255\255\255\255 ",0,0,FontSize,'o') -- Reset color to white for other widgets using gl.Text
		gl.Color(0.75,0.5,1,0.15)
		gl.Rect(x1,y1,x2,y2)
		gl.Color(1,1,1,1)
		gl.ResetState()

	end

end

function widget:Shutdown()
	WG.KP_OnsHelpTip=nil
end


