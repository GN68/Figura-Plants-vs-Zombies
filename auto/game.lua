local Screen = require("lib.ui.screen")
local Frame = require("lib.ui.frame")
local Sprite = require("lib.ui.sprite")
local Debug = require("lib.ui.debug")
local Macros = require("lib.macros")

local Identity = require("game.identity")
local Object = require("game.object")
local Hitbox = require("game.hitbox")

local Tween = require("lib.tween")
local Sequence = require("lib.sequence")
local NBS = require("lib.nbs")

if avatar:getPermissionLevel() ~= "MAX" then
	error("Plants VS Zombies requires MAX permission level to work! do you wanna randomy crash and lose all your progress?!?")
end

local modelHardware = models.hardware
modelHardware:setParentType("SKULL")

local ASPECT_RATIO = 256/192
local SENSITIVITY = 0.007

SENSITIVITY = vec(SENSITIVITY,SENSITIVITY*ASPECT_RATIO)
---@cast SENSITIVITY Vector2

local mpos = vec(0,0)
local lrot = vec(0,0)

local modelScreen = models.hardware.base.screen


local screen = Screen.new(modelScreen)

Debug:setParent(screen.model)
--client.getViewer():getNbt().SelectedSlot




--[────────────────────────────────────────-< GAME LOGIC >-────────────────────────────────────────]--
local overlay = models.hardware.base.screen.over
local modelTitle = models.hardware.base.screen.title
local modelMEssageOverlay = models.hardware.base.screen.messageOver:setVisible(false)

--[────────────────────────-< HUD >-────────────────────────]--

local titleTask = modelTitle:newText("Title"):setAlignment("CENTER"):setOutline(true)
local messageTask = modelTitle:newText("Message"):scale(0.05,0.05,1):pos(0,-3.3,0):setAlignment("CENTER"):setOutline(true)



local function title(text,scale,duration)
	scale = scale or 1
	local i = 1/scale
	local pos = client:getCameraPos() + client:getCameraDir()
	--sounds:playSound("minecraft:block.anvil.place",pos, 0.1, 0.3)
	sounds:playSound("minecraft:block.sand.place",pos, 1, 0.5*i)
	sounds:playSound("minecraft:block.sand.break",pos, 1, 0.25*i)
	sounds:playSound("minecraft:block.note_block.snare",pos, 1, 0.25*i)
	sounds:playSound("minecraft:block.note_block.hat",pos, 1, 0.5*i)
	local scale = scale * 0.2
	titleTask:scale(scale,scale,scale)
	titleTask:setText(toJson({text=text,color="#ff0000"}))
	duration = (duration or 0.5) * 20
	Sequence.new()
	:add(duration,function ()
		titleTask:setText("")
	end)
	:start()
end

local function message(text)
	local lineCount = 0
	text:gsub("\n",function () lineCount = lineCount + 1 end)
	messageTask
	:setText(toJson({text=text,color="#ede1a5"}))
	:pos(0,-3.3+lineCount*0.25,0)
	modelMEssageOverlay:setVisible(true):setOpacity(0.5)
end

message("Test Message!\nLine2 test message")
--message("Click on the seed packet to pick it up!")
--message("Click on the grass to plant your seed!")
--message("Nicely done!")
--message("Click on the falling sun to collect it!")
--message("Keep collecting sun!\n You'll need it to grow more plants!")
--message("Excellent! You've collected\nenough for your next plant!")
--message("Don't let the zombies reach your house!")

local mPlant = NBS.loadTrack("plant")
local mSunny = NBS.loadTrack("sunny")

local musicPlayer = NBS.newMusicPlayer()



-- load identities
for index, value in ipairs(listFiles("game.identities")) do
	require(value)
end

--[────────────────────────-< Background >-────────────────────────]--

local texYard = textures["textures.yard"]
local texGrass = textures["textures.grass"]

overlay:setOpacity(0)

local fBackground = Frame.new(texYard)
local sBackground = Sprite.new(screen,fBackground)
local size = fBackground.texture:getDimensions()

local fRollGrass = Frame.new(texGrass,245,227,259,268)

sBackground:setPos(-size.x,-size.y):setLayer(-1)

local fGrass = {
	Frame.new(texGrass,0,0,1,1),
	Frame.new(texGrass,0,170,240,206),
	Frame.new(texGrass,0,208,243,311),
	Frame.new(texGrass,0,0,245,168)
}

local fGrassPos = {
	vec(0,0),
	vec(-fGrass[2].dim.x-79,-123),
	vec(-fGrass[3].dim.x-76,-size.y+32),
	vec(-fGrass[4].dim.x-75,-size.y+6),
}


local sGrass1 = Sprite.new(screen):setLayer(-1)
local sGrass2 = Sprite.new(screen):setLayer(-0.8)
local function applyGrass(sGrass, i, trim)
	sGrass:setFrame(fGrass[i])
	sGrass:setPos(fGrassPos[i])
end

local function rollGrass(i)
	local sRollGrass1 = Sprite.new(screen,fRollGrass):setLayer(0)
	local sRollGrass2 = Sprite.new(screen,fRollGrass):setLayer(0)
	
	if i == 4 then
		applyGrass(sGrass2,i)
		return
	end
	
	applyGrass(sGrass1,i)
	applyGrass(sGrass2,i+1)
	
	Tween.new({
		from = 0,
		to = 243,
		duration = 1.5,
		easing="linear",
		tick = function (v, t)
			v = math.floor(v)
			sRollGrass1:setPos(-83-5-v+5,-27-32*(i-1+3)):setVisible(true)
			sRollGrass2:setPos(-83-5-v+5,-27-32*(1-i+3)):setVisible(true)
			local o = math.floor(math.lerp(1,240,t))
			if i == 1 then
				sGrass2:setFrame(Frame.new(texGrass,0,170,o,206))
				sGrass2:setPos(vec(-79-o,-121))
			elseif i == 2 then
				sGrass2:setFrame(Frame.new(texGrass,0,208,o,311))
				sGrass2:setPos(vec(-77-o,-size.y+32))
			elseif i == 3 then
				sGrass2:setFrame(Frame.new(texGrass,0,0,o,168))
				sGrass2:setPos(vec(-75-o,-size.y+6))
			end
		end,
		onFinish = function ()
			sRollGrass1:setVisible(false)
			sRollGrass2:setVisible(false)
		end
	})
end

local function setCamTarget(x,d)
	Tween.new({
		from = screen.camPos.x,
		to = x,
		duration = d or 2,
		easing="inOutQuad",
		tick = function (v, t)
			screen:setCamPos(v,0)
		end,
		id="camTarget"
	})
end

--setCamTarget(70)
--setCamTarget(190)


--[────────────────────────-< Game Startup Sequence >-────────────────────────]--

local inventory = {"peashooter"}
local levels = {}

for i, path in ipairs(listFiles("game.levels")) do
	levels[i] = require(path)
end

function loadLevel(level)
	local aStart = Sequence.new()
	
	aStart:add(1*20,function ()
		musicPlayer:setTrack(mPlant):play(true)
		setCamTarget(190)
	end)
	
	aStart:add(4*20,function ()
		setCamTarget(70,2)
	end)
	
	aStart:add(6*20,function ()
		rollGrass(1)
	end)
	
	aStart:add(7*20,function ()title("ready")end)
	aStart:add(7.6*20,function ()title("set")end)
	aStart:add(8.2*20,function ()title("PLANT!",1.2,1)end)
	aStart:add(9*20,function ()musicPlayer:setTrack(mSunny):play(true) end)
	
	aStart:add(10*20,function ()
		
	end)
	
	aStart:start()
end


--loadLevel()
local peashooter = Object.new("peashooter",screen)
peashooter:setPos(-100,-108)
		
for i = 1, 1, 1 do
	local zambie = Object.new("zombie",screen)
	zambie:setPos(-200,-108)
	zambie.isWalking = math.random() > 0.5
end

rollGrass(4)
setCamTarget(70)
musicPlayer:setTrack(mSunny)
--musicPlayer:play()

--[────────────────────────-<  >-────────────────────────]--



--[────────────────────────-< Game Clock >-────────────────────────]--

local game = Macros.new(function (events, ...)
	
	events.WORLD_TICK:register(function ()
		Object.tick(screen)
		Sequence.tick()
		musicPlayer:setPos(client:getCameraPos() + client:getCameraDir())
		Debug:setOffset(screen.camPos)
	end)
	
	-- SCREEN BOUNDARIES
	events.WORLD_RENDER:register(function (delta)
		
		--screen:setCamPos(mpos.x*512-256,mpos.y*512-256)
		
		screen:setDir(client:getCameraDir())
		local t = client:getSystemTime() / 1000
		Debug:clear()
	end)
end)





--[────────────────────────────────────────-< HANDHELD HANDLER >-────────────────────────────────────────]--






local isActive = false
local wasActive = false
events.WORLD_RENDER:register(function (delta)
	if isActive ~= wasActive then
		wasActive = isActive
		game:setActive(isActive)
	end
	isActive = false
end)

events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
	local rightHanded = client:getViewer():getActiveHand() == "MAIN_HAND"
	if ctx:find((rightHanded and "LEFT" or "RIGHT") .."_HAND$") then
		isActive = true
		local rot = client:getCameraRot().xy
		local diff = (rot - (lrot or rot) + 180) % 360 - 180
		
		lrot = rot
		if rot.x < 89 and rot.x > -89 then -- stops the cursor from freaking out
			mpos = mpos + diff.yx * SENSITIVITY
		end
		
		---@cast mpos Vector2
		mpos.x = math.clamp(mpos.x,0,1)
		mpos.y = math.clamp(mpos.y,0,1)
		
		
		--modelHardware:setPos(9 * (rightHanded and -1 or 1) + math.lerp(-8,8,mpos.x),4.4+math.lerp(0,12,mpos.y),0):rot(0,0,0)
		modelHardware:setPos(9 * (rightHanded and -1 or 1),10.5,0):rot(0,0,0)
	else
		modelHardware:setPos(0,0,-6):scale():rot(90,0,0)
	end
end)