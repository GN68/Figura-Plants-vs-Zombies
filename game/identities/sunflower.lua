-- https://plantsvszombies.wiki.gg/wiki/Sunflower_(PvZ)
---@class Sunflower : Object
---@field sunCooldown integer

local Debug=require("lib.ui.debug")


local SUN_COOLDOWN=480

local P=require("./plantUtils") ---@module "game.identities.plantUtils"
local Sprite=require("lib.ui.sprite")
local Frame=require("lib.ui.frame")

local Identity=require("game.identity")
local Object=require("game.object")
local Hitbox=require("game.hitbox")


local tex=textures["textures.sunflower"]
local fIdle=Frame.newArray(tex,28,0,57,32,6,false)
Frame.offset2Array(fIdle,{vec(0,0),vec(-1,0),vec(-3,0),vec(-4,0),vec(-4,0),vec(-4,0)})

local fSeed=Frame.new(tex,0,7,25,31)


Identity.new(fSeed,fIdle[1], "p.sunflower",50, 300,{
	---@param self Peashooter
	ENTER=function (self, screen)
		self.hitbox:setDim(27,16,0,0):setLayer("plants")
		self.sunCooldown=math.random(80,160) -- She will produce the first sunlight in 4 to 8 seconds, and then every 24 seconds normally.
		self.i=math.random(1,256)
	end,
	
	---@param self Peashooter
	TICK=function (self, screen)
		self.i=self.i+1
		self.sunCooldown=self.sunCooldown - 1
		self.sprite:setFrame(Frame.pingPong(fIdle,self.i*0.5))
		if self.sunCooldown <= 0 then
			self.sunCooldown=SUN_COOLDOWN
			Object.new("sun",screen):setPos(self.pos)
		end
	end,
	
	
	DEATH=function (self, screen)
		self:free()
	end,
	
	---@param self Peashooter
	EXIT=function (self, screen)
		P.unplant(self,screen)
	end
	
})
