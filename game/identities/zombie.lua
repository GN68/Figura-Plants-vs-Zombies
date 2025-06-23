--[[ NOTES
first spawn=sunflower cooldown * 3
-- Health: 270
-- Cost: 50
]]

---@class Zombie : Object
---@field isWalking boolean

local Debug=require("lib.ui.debug")
local Seq=require("lib.sequence")
local Seq=require("lib.sequence")

local Sprite=require("lib.ui.sprite")
local Frame=require("lib.ui.frame")

local Identity=require("game.identity")
local Object=require("game.object")
local Hitbox=require("game.hitbox")


local texZombie=textures["textures.zombie"]
local fSeed=Frame.new(texZombie,180,30,203,50)

local fZombie=Frame.newArray(texZombie,0,0,34,50,5)
local fZombieWalk=Frame.newArray(texZombie,0,52,41,105,7)
local fZombieEat=Frame.newArray(texZombie,0,107,36,157,7)
local fZombieDie=Frame.newArray(texZombie,0,159,43,192,9)
local fZombieBurn=Frame.new(texZombie,208,8405,194)



Identity.new(fSeed,fZombie[1], "zombie",50,270,{
	---@param self Zombie
	ENTER=function (self, screen)
		self.hitbox:setDim(27,20,0,0):setLayer("zombies")
		self:setPos(-128,-128)
		self.isWalking=false
		self.isEating=true
		self.isMunch=false
		self.i=math.random(1,256)
		self.groanCooldown=math.random(2,5)*20
	end,
	
	---@param self Zombie
	TICK=function (self, screen)
		self.i=self.i+1
		if self.health > 0 then
			self.groanCooldown=self.groanCooldown-1
			if self.groanCooldown <= 0 then
				self.groanCooldown=math.random(4,10)*20
				screen:sound("minecraft:entity.zombie.ambient",1.2,0.2)
			end
			
			local plant=self.hitbox:getCollidingBox("plants")
			if plant then
				self.sprite:setFrame(Frame.scroll(fZombieEat,self.i*0.3))
				local shouldMunch=self.sprite.frame == fZombieEat[2] or self.sprite.frame == fZombieEat[5]
				if shouldMunch ~= self.isMunch then
					if shouldMunch then
						plant.object:damage(20)
						screen:sound("minecraft:entity.generic.eat",1)
					end
					self.isMunch=shouldMunch
				end
			else
				if self.isWalking then
					self:setPos(self.pos.x+0.2,self.pos.y)
					self.sprite:setFrame(Frame.scroll(fZombieWalk,self.i*0.1))
				else
					self.sprite:setFrame(Frame.scroll(fZombie,self.i*0.15))
				end
			end
		end
	end,
	DAMAGED=function (self, screen)
		self.sprite:setColor(0.6,0.6,0.6)
		Seq.new()
		:add(5,function ()self.sprite:setColor(1,1,1)end)
		:start()
	end,
	DEATH=function (self, screen)
		self.i=0
		local function s()
			self.sprite:setFrame(Frame.clamped(fZombieDie,self.i*0.3))
		end
		local seq=Seq.new()
		seq:start()
		for i=0, #fZombieDie-1, 1 do seq:add(i*3,s)end
		
		seq:add(9,function () self.hitbox:setEnabled(false)end)
		:add((#fZombieDie+3)*3,function ()self:free()end)
	end
})