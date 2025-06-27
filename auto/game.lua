local Screen=require("lib.ui.screen")
local Frame=require("lib.ui.frame")
local Sprite=require("lib.ui.sprite")
local Debug=require("lib.ui.debug")
local Macros=require("lib.macros")
local Event =require("lib.event")
local params= require("lib.params")

local Identity=require("game.identity")
local Object=require("game.object")
local Hitbox=require("game.hitbox")

local Tween=require("lib.tween")
local Seq=require("lib.sequence")
local NBS=require("lib.nbs")

if avatar:getPermissionLevel() ~= "MAX" then
	error("Plants VS Zombies requires MAX permission level to work! do you wanna randomly crash and lose all your progress?!?")
end

local modelHardware=models.hardware
modelHardware:setParentType("SKULL")

local ASPECT_RATIO=256/192
local SENSITIVITY=0.007

SENSITIVITY=vec(SENSITIVITY,SENSITIVITY*ASPECT_RATIO)
---@cast SENSITIVITY Vector2

local mpos=vec(0,0)
local lrot=vec(0,0)

local modelScreen=models.hardware.base.screen


local s=Screen.new(modelScreen)

Debug:setParent(s.model)
--client.getViewer():getNbt().SelectedSlot

local w = textures:newTexture("1x1w",1,1):setPixel(0,0,vec(1,1,1))

--[────────────────────────────────────────-< GAME LOGIC >-────────────────────────────────────────]--
local overlay=models.hardware.base.screen.over:setPrimaryTexture("CUSTOM",w)
local modelTitle=models.hardware.base.screen.title
local modelMEssageOverlay=models.hardware.base.screen.messageOver:setVisible(false)

function s.setOverlay(r,g,b,a)
	local vec4 = params.vec4(r,g,b,a)
	overlay:setColor(vec4.x,vec4.y,vec4.z):setOpacity(vec4.w)
end

--[────────────────────────-< HUD >-────────────────────────]--

local titleTask=modelTitle:newText("Title"):setAlignment("CENTER"):setOutline(true)
local messageTask=modelTitle:newText("Message"):scale(0.05,0.05,1):pos(0,-3.3,0):setAlignment("CENTER"):setOutline(true)



local function title(text,scale,duration)
	scale=scale or 1
	local i=1/scale
	local pos=client:getCameraPos()+client:getCameraDir()
	--sounds:playSound("minecraft:block.anvil.place",pos, 0.1, 0.3)
	sounds:playSound("minecraft:block.sand.place",pos, 1, 0.5*i)
	sounds:playSound("minecraft:block.sand.break",pos, 1, 0.25*i)
	sounds:playSound("minecraft:block.note_block.snare",pos, 1, 0.25*i)
	sounds:playSound("minecraft:block.note_block.hat",pos, 1, 0.5*i)
	local scale=scale * 0.2
	titleTask:scale(scale,scale,scale)
	titleTask:setText(toJson({text=text,color="#ff0000"}))
	duration=(duration or 0.5) * 20
	Seq.new()
	:add(duration,function ()
		titleTask:setText("")
	end)
	:start()
end

local function message(text)
	if text then
		local lineCount=0
		text:gsub("\n",function () lineCount=lineCount+1 end)
		messageTask
		:setText(toJson({text=text,color="#ede1a5"}))
		:pos(0,-3.3+lineCount*0.25,0)
	else
		messageTask:setText("")
	end
	modelMEssageOverlay:setVisible(text and true):setOpacity(0.5)
end

--message("Test Message!\nLine2 test message")


local mPlant=NBS.loadTrack("plant")
local mSunny=NBS.loadTrack("sunny")
local mDed=NBS.loadTrack("ded")
mPlant.loop=true
mSunny.loop=true

s.musicPlayer=NBS.newMusicPlayer()



-- load identities
for index, value in ipairs(listFiles("game.identities")) do
	require(value)
end

--[────────────────────────-< Background >-────────────────────────]--

local texYard=textures["textures.yard"]
local texGrass=textures["textures.grass"]

overlay:setOpacity(0)

local fBackground=Frame.new(texYard)
local sBackground=Sprite.new(s,fBackground)
local size=fBackground.texture:getDimensions()

local fRollGrass=Frame.new(texGrass,245,227,259,268)

sBackground:setPos(-size.x,-size.y):setLayer(-1)

local fGrass={
	Frame.new(texGrass,0,0,1,1),
	Frame.new(texGrass,0,170,240,206),
	Frame.new(texGrass,0,208,243,311),
	Frame.new(texGrass,0,0,245,168)
}

local fGrassPos={
	vec(0,0),
	vec(-fGrass[2].dim.x-78,-125),
	vec(-fGrass[3].dim.x-76,-size.y+32),
	vec(-fGrass[4].dim.x-74,-size.y+6),
}


local sGrass1=Sprite.new(s):setLayer(-1)
local sGrass2=Sprite.new(s):setLayer(-0.8)
local function applyGrass(sGrass, i, trim)
	sGrass:setFrame(fGrass[i])
	sGrass:setPos(fGrassPos[i])
end

local function rollGrass(i)
	local sRollGrass1=Sprite.new(s,fRollGrass):setLayer(0)
	local sRollGrass2=Sprite.new(s,fRollGrass):setLayer(0)
	
	if i==4 then
		applyGrass(sGrass2,i)
		return
	end
	
	applyGrass(sGrass1,i)
	applyGrass(sGrass2,i+1)
	
	Tween.new({
		from=0,
		to=243,
		duration=1.5,
		easing="linear",
		tick=function (v, t)
			v=math.floor(v)
			sRollGrass1:setPos(-83-5-v+5,-27-32*(i-1+3)):setVisible(true)
			sRollGrass2:setPos(-83-5-v+5,-27-32*(1-i+3)):setVisible(true)
			local o=math.floor(math.lerp(1,240,t))
			if i==1 then
				sGrass2:setFrame(Frame.new(texGrass,0,170,o,206))
				sGrass2:setPos(vec(-79-o,-125))
			elseif i==2 then
				sGrass2:setFrame(Frame.new(texGrass,0,208,o,311))
				sGrass2:setPos(vec(-76-o,-size.y+32))
			elseif i==3 then
				sGrass2:setFrame(Frame.new(texGrass,0,0,o,168))
				sGrass2:setPos(vec(-75-o,-size.y+6))
			end
		end,
		onFinish=function ()
			sRollGrass1:setVisible(false)
			sRollGrass2:setVisible(false)
		end
	})
end

function s.setCamTarget(x,d)
	Tween.new({
		from=s.camPos.x,
		to=x,
		duration=d or 2,
		easing="inOutQuad",
		tick=function (v, t)
			s:setCamPos(v,0)
		end,
		id="camTarget"
	})
end

--setCamTarget(70)
--setCamTarget(190)




--[────────────────────────-< Game Startup Sequence >-────────────────────────]--

local inventory={"p.peashooter"}
local uiInv={}
local levels={}

for i, path in ipairs(listFiles("game.levels")) do
	levels[path:match("[^.]+$")]=require(path)
end

s.plants={}
s.suns=0
s.sunfalls=false
s.SUN_CHANGED=Event.new()
s.shake=0
s.canSpawnZombies=false
s.spawnTimer=0
s.waveZombies={}

local sunTimer=0
local lvl={} ---@type Level

function s.dead(z)
	s.setCamTarget(0)
	s.playing = false
	
	local m=function ()s:sound("minecraft:entity.generic.eat",1,1)end
	
	Tween.new{
		from=z.pos*1,
		to=vec(-70,-128),
		duration=3,
		easing="linear",
		tick=function (v, t)
			z:setPos(v)
		end,
		onFinish=function ()
			z:free()
			s:sound("minecraft:entity.zombie.ambient",1,1)
			Seq.new()
			:add(10,m)
			:add(20,m)
			:add(30,m)
			:add(40,function ()
				s:sound("minecraft:entity.goat.screaming.death",1,1)
				m()
			end)
			:add(50,m)
			:add(60,function ()
				s.loadLevel(lvl.name)
			end)
			:start()
		end,
	}
	s.musicPlayer:setTrack(mDed):play(true)
end

function s.addSun(value)
	s.suns=s.suns+value
	s.SUN_CHANGED:invoke()
end

--[────────-< Sun Display >-────────]--
local uiSun=Sprite.new(s,Frame.new(textures["textures.sun"],0,0,15,15))
uiSun:setPos(-87,-17)
local sunText=s.model:newText("sun"):setText("25"):setOutline(true):setPos(-3.5,-17)


s.SUN_CHANGED:register(function ()
	sunText:setText(s.suns)
end)


---@param wave Level.Wave
local function spawnWave(wave)
	for z in pairs(s.waveZombies) do
		z.useless=true
	end
	s:sound("minecraft:entity.zombie.ambient")
	s.waveZombies = {}
	s.spawnTimer=100
	s.waveHealth=0
	s.totalHealth=1
	local x=0
	if wave.major then
	end
	
	
	for count, names in pairs(wave.c) do
		for _, name in ipairs(names) do
			for i=1, count, 1 do
				x=x + 1
				local z=Object.new(name,s) ---@type Zombie
				local y
				if lvl.grass==1 then
					y=3
				elseif lvl.grass==2 then
					y=math.random(2,4)
				else
					y=math.random(1,5)
				end
				s.waveZombies[z]=1
				z:setPos(-350-x*8,-(y+1)*31+4)
				z.isWalking=true
			end
		end
	end
end


function s.loadLevel(level)
	Tween.new{
		from=1,
		to=0,
		easing="linear",
		duration=0.5,
		tick=function (v)
			s.setOverlay(1,1,1,v)
		end,
	}
	s.waveHealth=0
	s.wave=1
	s.totalHealth=1
	
	s.spawnTimer=600 -- 45 seconds
	sunTimer=200
	lvl=levels[level] ---@type Level
	lvl.name=level
	applyGrass(sGrass1,lvl.grass or 4)
	sunText:setVisible(false)
	
	s.suns=lvl.suns or 50
	
	s.SUN_CHANGED:invoke()
	
	--print(lvl)
	s.range=lvl.grid_range or vec(0,0,9,5)
	--[────────-< UI >-────────]--
	Object.purgeAll()
	
	for i, name in ipairs(lvl.inventory or inventory) do
		local ui=Object.new("seed",s,Identity.IDENTITIES[name])
		ui:setPos(-109-i*24,-24)
		ui.sprite:setVisible(false)
		ui.hitbox:setEnabled(false)
		uiSun:setVisible(false)
		uiInv[i]=ui
	end
	
	--[────────-< Startup Sequence >-────────]--
	for key, value in pairs(s.plants) do
		value:free()
	end
	local aStart=Seq.new()
	
	local pZ = {}
	
	for i = 1, 10, 1 do
		
		local id={}
		for _, w in pairs(lvl.waves) do
			for _, zs in pairs(w.c) do
				for _, z in pairs(zs) do
					id[#id+1] = z
				end
			end
		end
		local z=Object.new(id[math.random(#id)],s,true)
		:setPos(math.lerp(-360,-430,math.random()),math.lerp(-40,-170,math.random()))
		z.isWalking = false
		z.isSilent = true
		pZ[i]=z
	end
	
	s.canSpawnZombies=false
	aStart:add(1*20,function ()
		s.musicPlayer:setTrack(mPlant):play(true)
		s.setCamTarget(190)
	end)
	
	aStart:add(4*20,function ()
		s.setCamTarget(70,2)
	end)
	
	aStart:add(6*20,function ()
		for i,z in ipairs(pZ) do
			z:free()
		end
		rollGrass(lvl.grass or 4)
		uiSun:setVisible(true)
		sunText:setVisible(true)
		for i, name in pairs(uiInv) do
			uiInv[i].sprite:setVisible(true)
		end
	end)
	
	aStart:add(7*20,function ()title("ready")end)
	aStart:add(7.6*20,function ()title("set")end)
	aStart:add(8.2*20,function ()
		title("PLANT!",1.2,1)
		s.playing = true
		s.canSpawnZombies=true
		for i, name in pairs(uiInv) do
			uiInv[i].hitbox:setEnabled(true)
		end
	end)
	aStart:add(9*20,function ()s.musicPlayer:setTrack(mSunny):play(true) end)
	
	--[────────────────────────-< Tutorial Message >-────────────────────────]--
	aStart:add(10*20,function ()
		if level=="lvl1" then -- hard code the tutorial lmao
			message("Click on the seed packet to pick it up!")
			s.canSpawnZombies=false
			Seq.new()
			:add(0,function ()
				s.stopSunFall=true
				return (not uiInv[1].isActive) -- pickup peashooter
			end) 
			:add(1,function ()
				message("Click on the grass to plant your seed!")
				return not next(s.plants)
			end)
			:add(1,function ()
				message("Nicely done!")
			end)
			:add(39,function ()
				scriptedSun=Object.new("sun",s,25,true,true)
			end)
			:add(40,function ()
				message("Click on the falling sun to collect it!")
				return s.suns < 75
			end)
			:add(41,function ()
				message("Keep collecting sun!\n You'll need it to grow more plants!")
			end)
			:add(101,function ()
				scriptedSun=Object.new("sun",s,25,true,true)
			end)
			:add(120,function ()
				return s.suns < 100
			end)
			:add(121,function ()
				message("Excellent! You've collected\nenough for your next plant!")
				return s.suns ~= 0
			end)
			:add(122,function ()
				message("Don't let the zombies reach your house!")
				s.stopSunFall=false
			end)
			:add(182,function ()
				message()
				s.canSpawnZombies=true
				s.spawnTimer=0
			end)
			:start()
		end
	end)
	aStart:start()
	if lvl.skip then
		aStart.time=9999
	end
	if lvl.fun then
		lvl.fun(s,lvl)
	end
end

s.loadLevel("sandbox")
--local peashooter=Object.new("peashooter",screen)
--peashooter:setPos(-100,-108)
		
--for i=1, 10, 1 do
--	local zambie=Object.new("zombie",screen)
--	zambie:setPos(-260,-120)
--	zambie.isWalking=math.random() > 0.5
--end

--rollGrass(4)
--setCamTarget(70)
--musicPlayer:play()

--[────────────────────────-<  >-────────────────────────]--



--[────────────────────────-< Game Clock >-────────────────────────]--

local game=Macros.new(function (events, ...)
	events.WORLD_TICK:register(function ()
		s.shake=s.shake * 0.2
		Object.tick(s)
		Seq.tick()
		NBS.tick()
		s.musicPlayer:setPos(client:getCameraPos()+client:getCameraDir())
		Hitbox:tick(s)
		Debug:setOffset(s.camPos)
		
		if s.win then
			s.win = false
			s.loadLevel(lvl.next)
		end
		
		if not s.stopSunFall then
		sunTimer=sunTimer - 1
		if sunTimer < 0 then
			sunTimer=200 -- 10 seconds
			Object.new("sun",s,25,true)
		end
		--print(s.totalHealth / 2, s.waveHealth)
		s.spawnTimer=s.spawnTimer - 1
		if s.canSpawnZombies then
			if s.spawnTimer < 0 then
				if lvl.waves[s.wave] then
					if s.totalHealth / 2 > s.waveHealth then -- 50% rule
						if s.spawnTimer < -2 then
							s.spawnTimer = 100

						else
							spawnWave(lvl.waves[s.wave])
							s.wave=s.wave + 1
						end
					end
				else
					if s.waveHealth == 0 then -- WIN
						s.sunfalls=false
						s.canSpawnZombies = false
						Object.new("seedwin",s,lvl.prize):setPos(-256,-128)
					end
				end
			end
		end
	end
	
	end)
	
	-- SCREEN BOUNDARIES
	events.WORLD_RENDER:register(function (delta)
		s:setCamPos(s.camPos)
		
		s:setDir(client:getCameraDir())
		local t=client:getSystemTime() / 1000
		Debug:clear()
	end)
end)





--[────────────────────────────────────────-< HANDHELD HANDLER >-────────────────────────────────────────]--






local isActive=false
local wasActive=false
events.WORLD_RENDER:register(function (delta)
	if isActive ~= wasActive then
		wasActive=isActive
		game:setActive(isActive)
	end
	isActive=false
end)

events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
	local rightHanded=client:getViewer():getActiveHand()=="MAIN_HAND"
	if ctx:find((rightHanded and "LEFT" or "RIGHT") .."_HAND$") then
		isActive=true
		local rot=client:getCameraRot().xy
		local diff=(rot-(lrot or rot)+180)%360-180
		
		lrot=rot
		if rot.x < 89 and rot.x > -89 then -- stops the cursor from freaking out
			mpos=mpos+diff.yx * SENSITIVITY
		end
		
		---@cast mpos Vector2
		mpos.x=math.clamp(mpos.x,0,1)
		mpos.y=math.clamp(mpos.y,0,1)
		s:setMousePos(mpos)
		
		--modelHardware:setPos(9 * (rightHanded and -1 or 1),10.5,0):rot(0,0,0)
		modelHardware:setPos(9 * (rightHanded and -1 or 1)+math.lerp(-8,8,mpos.x),4.4+math.lerp(0,12,mpos.y),0):rot(0,0,0)
	else
		modelHardware:setPos(0,0,-6):scale():rot(90,0,0)
	end
end)