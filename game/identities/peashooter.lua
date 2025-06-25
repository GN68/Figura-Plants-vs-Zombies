--[[NOTES

Sun cost: 100
proj/sec: 1.425
Recharge: 7.5 sec
Damage: 20
Toughness: 300

]]
---@class Peashooter : Object
---@field isShooting boolean
---@field shootCooldown integer
---@field sight Hitbox

local Debug=require("lib.ui.debug")


local SHOOT_COOLDOWN=28.5

local P = require("./plantUtils") ---@module "game.identities.plantUtils"
local Sprite=require("lib.ui.sprite")
local Frame=require("lib.ui.frame")

local Identity=require("game.identity")
local Object=require("game.object")
local Hitbox=require("game.hitbox")


local tex=textures["textures.peashooter"]
local fIdle=Frame.newArray(tex,1,1,28,32,8) 
Frame.offset2Array(fIdle,{vec(0,0),vec(-1,0),vec(-2,0),vec(-1,0),vec(0,0),vec(2,0),vec(2,0),vec(2,0)})
local fShoot=Frame.newArray(tex,235,1,262,32,3)
Frame.offset2Array(fShoot,{vec(0,0),vec(-2,0),vec(-4,0)})
local fSeed=Frame.new(tex,321,2,344,23)


Identity.new(fSeed,fIdle[1], "p.peashooter",100, 300,{
	---@param self Peashooter
	ENTER=function (self, screen)
		self.hitbox:setDim(27,16,0,0):setLayer("plants")
		self.isShooting=true
		self.shootCooldown=SHOOT_COOLDOWN + math.random()
		self.sight=Hitbox.new(nil,"sight")
		local function a()
			self.sight:setDim(-320,self.pos.y,self.pos.x	,self.pos.y+16)
		end
		self.MOVED:register(a)
		a()
		self.i=math.random(1,256)
	end,
	
	---@param self Peashooter
	TICK=function (self, screen)
		self.i=self.i+1
		self.shootCooldown=self.shootCooldown-1
		self.sprite:setFrame(Frame.scroll(fIdle,self.i*0.25))
		local zamb=self.sight:getCollidingBox("zombies")
		if zamb then
			if  self.shootCooldown <= 0 then
				self.shootCooldown=SHOOT_COOLDOWN
				Object.new("peashooter.proj",screen):setPos(self.pos)
				screen:sound("minecraft:ui.toast.in",3,0.2)
			end
			self.sprite:setFrame(Frame.clamped(fShoot,self.shootCooldown*0.25,true))
		end
	end,
	
	
	DEATH=function (self, screen)
		self:free()
	end,
	
	---@param self Peashooter
	EXIT=function (self, screen)
		self.sight:free()
		P.unplant(self,screen)
	end
	
})
