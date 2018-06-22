
if addon.InGetInfo then
	return {
		name    = "Circuit Growth",
		desc    = "Kernel Panic Load Animation",
		author  = "zwzsg",
		date    = "14 november 2013",
		license = "Free",
		layer   = 0,
		depend  = {"LoadProgress"},
		enabled = true,
	}
end

local lastLoadMessage,messageCount="",0
local Font,vsx,vsy,Matrix,u,v,DisplayList,LogoDL,animationProgress,loadProgress,oneRand

local Kernel_Panic_Logo={x=225,y=88,{
	x=0,y=50,
	--[[K]]{{1,1,10,1,10,14,23,1,35,1,19,17,32,30,26,36,10,20,10,37,1,37}},
	--[[E]]{{40,1,71,1,64,8,48,8,48,15,63,15,66,18,62,22,48,22,48,29,62,29,70,37,40,37}},
	--[[R]]{{77,1,84,1,84,16,88,16,103,1,111,1,96,16,107,16,107,30,100,37,77,37},{84,22,100,22,100,26,95,31,84,31}},
	--[[N]]{{116,1,125,1,125,30,130,30,138,22,138,1,147,1,147,27,137,37,116,37}},
	--[[E]]{{156,1,187,1,179,9,163,9,163,16,175,16,175,22,163,22,163,29,179,29,187,37,156,37}},
	--[[L]]{{193,1,224,1,217,8,202,8,202,37,193,28}},
	},{
	x=30,y=0,
	--[[P]]{{1,1,8,1,8,16,20,16,30,26,19,37,1,37},{8,23,17,23,17,30,8,30}},
	--[[A]]{{34,1,40,1,40,16,61,16,61,1,67,1,67,24,54,37,46,37,34,25},{41,22,60,22,52,30,49,30}},
	--[[N]]{{75,1,83,1,83,29,93,29,98,24,98,1,106,1,106,28,97,37,75,37}},
	--[[I]]{{112,1,120,9,120,29,112,37}},
	--[[C]]{{126,1,155,1,162,8,134,8,134,30,159,30,152,37,126,37}},
}}

local function Scribble(sentence,x,y,s)
	local s=s/sentence.y
	local x,y=x-s*sentence.x/2,y-s*sentence.y/2
	for _,word in ipairs(sentence) do
		local x,y=x+s*word.x,y+s*word.y
		for _,letter in ipairs(word) do
			for _,loop in ipairs(letter) do
				gl.BeginEnd(GL.LINE_LOOP,function()
					for p=1,#loop-1,2 do
						gl.Vertex(x+s*loop[p],y+s*loop[p+1])
					end
				end)
			end
		end
	end
end

local function ScribbleFancy(sentence,x,y,s)

	-- Save Logo
	if not LogoDL then
		LogoDL=gl.CreateList(Scribble,sentence,x,y,s)
	end

	-- Draw the wobbling logo
	gl.Blending("add")
	gl.LineWidth(1)
	gl.Color(0,0.05,0.05,1)-- Faint Cyan
	gl.PushMatrix()
	local cos,sin,clock=math.cos,math.sin,os.time()%60+os.clock()+47*oneRand
	local theta=((clock/5)%1)*2*math.pi-- Where 5 is the period in second
	for alpha=0,6.28,2*math.pi/32 do
		local a=6*cos(alpha+theta);
		local b=2*sin(alpha+theta);
		local tx=a*cos(theta)-b*sin(theta);
		local ty=a*sin(theta)+b*cos(theta);
		gl.Translate(tx,ty,0)
		gl.CallList(LogoDL)
		gl.Translate(-tx,-ty,0)
	end
	gl.PopMatrix()
	gl.LineWidth(1)

	-- Draw the logo tail
	gl.Blending("add")
	local rx,ry=x+sentence.x*cos(theta),y+sentence.y/2*sin(theta)
	local s=s/sentence.y
	local x,y=x-s*sentence.x/2,y-s*sentence.y/2
	local rx=x+s*sentence.x/2*(1+cos(((clock/13)%1)*2*math.pi))-- Where 13 is the period in second
	local ry=y+s*sentence.y/2*(1+sin(((clock/17)%1)*2*math.pi))-- Where 17 is the period in second
	for _,word in ipairs(sentence) do
		local x,y=x+s*word.x,y+s*word.y
		for _,letter in ipairs(word) do
			for _,loop in ipairs(letter) do
				gl.BeginEnd(GL.QUAD_STRIP,function()
					for p=0,#loop,2 do
						local x,y=x+s*loop[1+p%#loop],y+s*loop[1+(p+1)%#loop]
						gl.Color(0,0.1,0,1)-- Faint Green
						gl.Vertex(x,y)
						local dx,dy=x-rx,y-ry
						local d=math.sqrt(dx^2+dy^2)
						dx,dy=vsy/3*dx/d,vsy/3*dy/d
						gl.Color(0,0,0,1)-- Black
						gl.Vertex(x+dx,y+dy)
					end
				end)
			end
		end
	end
	gl.Color(1,1,1,1)
	gl.Blending(false)
end

local function DrawTitle()
	ScribbleFancy(Kernel_Panic_Logo,vsx*0.5,vsy*0.6,vsy/3)
end

local function DrawInfo()
	Font=Font or gl.LoadFont("FreeSansBold.otf", 50, 10, 5)
	Font:Print(lastLoadMessage, vsx*0.5, vsy*0.2, vsx/40, "cvo")
	Font:Print("Spring "..Game.version.." "..Game.buildFlags,7,vsy-7,16,"ao")
	Font:Print(Game.modShortName.." "..Game.modVersion,vsx-7,vsy-7,16,"rao")
end

local function Toss()
	return math.random()>0.5 and 1 or 0
end

local function InitializeCells()
	if not(vsx and vsy) then
		return
	end
	-- Betterize Random
	for k=1,80+os.time()%200 do
		math.random()
	end
	oneRand=math.random()
	local nct=3*math.sqrt(vsy)
	-- nct is the number of circuit tracks vertically.
	-- I made it neither constant nor proportionnal to screen size, but inbetween
	u=2+math.ceil(nct*vsx/math.min(vsx,vsy))
	v=2+math.ceil(nct*vsy/math.min(vsx,vsy))
	-- Initialize cells at 0
	local a={}
	for x=1,u do
		a[x]={}
		for y=1,v+1 do
			a[x][y]=0
		end
	end
	-- Initialize border cells at random
	for x=1,u do
		a[x][1]=Toss()
		a[x][v]=Toss()
	end
	for y=1,v do
		a[1][y]=Toss()
		a[u][y]=Toss()
	end
	return a
end

local function IterateCells(a)
	local b={}
	-- Recopy half of the border cells (frozen)
	for x=1,u do
		b[x]={}
		b[x][1]=a[x][1]
	end
	for y=1,v do
		b[1][y]=a[1][y]
	end
	-- Make non border cells evolve
	for x=2,u-1 do
		for y=2,v-1 do
			local n=a[x+1][y+1]+
					a[x+1][y+0]+
					a[x+1][y-1]+
					a[x-1][y+1]+
					a[x-1][y+0]+
					a[x-1][y-1]+
					a[x+0][y+1]+
					a[x+0][y-1]
			if n==3 then
				b[x][y]=1--Birth
			elseif n<=4 then
				b[x][y]=a[x][y]--Survival
			else
				b[x][y]=0--Death
			end
		end
	end
	-- Recopy other half of the border cells (frozen)
	for x=1,u do
		b[x][v]=a[x][v]
	end
	for y=1,v do
		b[u][y]=a[u][y]
	end
	return b
end



local function KillFourCells(a)
	-- Copy a to b
	local b={}
	for x=1,u do
		b[x]={}
		for y=1,v do
			b[x][y]=a[x][y]
		end
	end
	-- Remove squares
	for x=3,u-1 do
		for y=3,v-1 do
			if a[x][y]+a[x-1][y]+a[x][y-1]+a[x-1][y-1]==4 then
				local hasKilled=false
				for i=x-1,x do
					for j=y-1,y do
						if a[i-1][j]+a[i+1][j]+a[i][j-1]+a[i][j+1]==3 then
							b[i][j]=0
							hasKilled=true
						end
					end
				end
				if not hasKilled then
					b[x][y]=0
				end
			end
		end
	end
	-- Remove diamonds
	for x=2,u-1 do
		for y=2,v-1 do
			if a[x-1][y]+a[x+1][y]+a[x][y-1]+a[x][y+1]==4 and a[x][y]==0 then
				b[x][y]=1
			end
		end
	end
	return b
end


local function DrawCircuit(A)
	gl.Texture(false)
	gl.Color(0.3,0.5,0,1)-- Dark Green
	gl.LineWidth(1)

	local s=(vsx/(u-1)+vsy/(v-1))/2--Scale: distance between tracks

	local vias={}

	gl.BeginEnd(GL.LINES,function()

		-- Draw tracks
		for i=2,u-1 do
			for j=2,v-1 do
				if A[i][j]~=0 then
					local line=function(i2,j2)
						gl.Vertex(i*s-s,j*s-s)
						gl.Vertex(i2*s-s,j2*s-s)
					end

					-- Draw horizontal & vertical tracks
					if A[i-1][j]~=0 then
						line(i-1,j)
					end
					if A[i+1][j]~=0 then
						line(i+1,j)
					end
					if A[i][j-1]~=0 then
						line(i,j-1)
					end
					if A[i][j+1]~=0 then
						line(i,j+1)
					end

					-- Draw diagonal tracks
					if A[i-1][j-1]~=0 and not (A[i-1][j]~=0 or A[i][j-1]~=0) then
						line(i-1,j-1)
					end
					if A[i-1][j+1]~=0 and not (A[i-1][j]~=0 or A[i][j+1]~=0) then
						line(i-1,j+1)
					end
					if A[i+1][j-1]~=0 and not (A[i+1][j]~=0 or A[i][j-1]~=0) then
						line(i+1,j-1)
					end
					if A[i+1][j+1]~=0 and not (A[i+1][j]~=0 or A[i][j+1]~=0) then
						line(i+1,j+1)
					end

				end
			end
		end

		-- Draw vias
		local circle=function(i,j)
			local x,y,r=i*s-s,j*s-s,s/3
			gl.Vertex(x+r*math.cos(0),y+r*math.sin(0))
			for a=0,6.2,math.pi/8 do
				gl.Vertex(x+r*math.cos(a),y+r*math.sin(a))
				gl.Vertex(x+r*math.cos(a),y+r*math.sin(a))
			end
			gl.Vertex(x+r*math.cos(0),y+r*math.sin(0))
		end
		for i=2,u-1 do
			for j=2,v-1 do
				if A[i][j]~=0 then
					if A[i-1][j]+A[i-1][j-1]+A[i-1][j+1]+A[i][j-1]+A[i][j+1]==0
					or A[i+1][j]+A[i+1][j-1]+A[i+1][j+1]+A[i][j-1]+A[i][j+1]==0
					or A[i][j-1]+A[i-1][j-1]+A[i+1][j-1]+A[i-1][j]+A[i+1][j]==0
					or A[i][j+1]+A[i-1][j+1]+A[i+1][j+1]+A[i-1][j]+A[i+1][j]==0 then
						circle(i,j)
						vias[1+#vias]={i,j}
					end
				end
			end
		end

	end)

	-- Drill vias
	gl.Color(0,0,0,1)
	for _,via in ipairs(vias) do
		gl.BeginEnd(GL.TRIANGLE_FAN,function()
			local x,y,r=via[1]*s-s,via[2]*s-s,s/3-1
			gl.Vertex(x,y)
			for a=0,6.3,math.pi/8 do
				gl.Vertex(x+r*math.cos(a),y+r*math.sin(a))
			end
		end)
	end

	gl.LineWidth(1)
	gl.Color(1,1,1,1)

end


local function GrowCircuit()

	-- Initialize
	if not Matrix then
		Matrix=InitializeCells()
		animationProgress=0
	end

	-- Next lattice iteration
	if loadProgress>=animationProgress then
		while loadProgress>=animationProgress do
			Matrix=IterateCells(Matrix)
			animationProgress=animationProgress+2/(3*math.min(u,v))
		end
		if DisplayList then
			gl.DeleteList(DisplayList)
		end
		DisplayList=gl.CreateList(DrawCircuit,KillFourCells(KillFourCells(Matrix)))
	end

	-- Show it
	if DisplayList then
		gl.CallList(DisplayList)
	end

end



function addon.LoadProgress(message, replaceLastLine)
	lastLoadMessage = message
	messageCount=messageCount+1
end

function addon.DrawLoadScreen()
	local cachedLoadProgress = SG.GetLoadProgress()
	if cachedLoadProgress>=0 then
		loadProgress=cachedLoadProgress
	else
		loadProgress=math.max(messageCount/30,math.min((messageCount+1)/30,(loadProgress or 0)+0.007))
	end
	if not (vsx and vsy) then
		vsx, vsy = gl.GetViewSizes()
	end
	gl.PushMatrix()
	gl.Scale(1/vsx,1/vsy,1)
	GrowCircuit()
	DrawTitle()
	DrawInfo()
	gl.PopMatrix()
end

function addon.Shutdown()
	if DisplayList then
		gl.DeleteList(DisplayList)
		DisplayList=nil
	end
	if Font then
		gl.DeleteFont(Font)
		Font=nil
	end
	if LogoDL then
		gl.DeleteList(LogoDL)
		LogoDL=nil
	end
end
