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

local Tween=require("lib.tween")

local texZombie=textures["textures.zombie"]
local fSeed=Frame.new(texZombie,180,30,203,50)

local fZombie=Frame.newArray(texZombie,0,0,34,50,5)
local fZombieWalk=Frame.newArray(texZombie,0,52,41,105,7)
local fZombieEat=Frame.newArray(texZombie,0,107,36,157,7)
local fZombieDie=Frame.newArray(texZombie,0,159,43,192,9)
local fBurn=Frame.new(texZombie,208,8,233,50)


Identity.new(fSeed,fZombie[1], "z.zombie",50,270,{
	---@param self Zombie
	ENTER=function (self, s,useless)
		if not useless then
			s.waveHealth=s.waveHealth+self.health
			s.totalHealth=s.totalHealth+self.health
		end
		self.hitbox:setDim(27,5,0,0):setLayer("zombies")
		self:setPos(-128,-128)
		self.isWalking=true
		self.isEating=true
		self.isMunch=false
		self.i=math.random(1,256)
	end,
	
	---@param self Zombie
	TICK=function (self, s)
		self.i=self.i+1
		
		if self.pos.x > -96 and s.playing then
			s.dead(self)
		end
		
		if self.health > 0 then
			
			local plant=self.hitbox:getCollidingBox("plants")
			if plant then
				self.sprite:setFrame(Frame.scroll(fZombieEat,self.i*0.3))
				local shouldMunch=self.sprite.frame == fZombieEat[2] or self.sprite.frame == fZombieEat[5]
				if shouldMunch ~= self.isMunch then
					if shouldMunch then
						plant.object:damage(20)
						s:sound("minecraft:entity.generic.eat",1)
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
	DAMAGED=function (self, s, a)
		if not self.useless then
			s.waveHealth=s.waveHealth-math.min(a,self.health)
		end
		self.sprite:setColor(0.6,0.6,0.6)
		Seq.new()
		:add(5,function ()self.sprite:setColor(1,1,1)end)
		:start()
	end,
	DEATH=function (self, s)
		s:sound("minecraft:entity.zombie.death",1)
		if not self.useless then
			s.waveHealth=s.waveHealth-math.max(self.health,0)
		end
		self.i=0
		if self.burnt then
			self.sprite:setFrame(fBurn)
			Seq.new():add(40,function ()self:free()end):start()
		else
			local function s()
				self.sprite:setFrame(Frame.clamped(fZombieDie,self.i*0.3))
			end
			local seq=Seq.new()
			seq:start()
			for i=0, #fZombieDie-1, 1 do seq:add(i*3,s)end
			
			seq:add(9,function () self.hitbox:setEnabled(false)end)
			:add((#fZombieDie+3)*3,function ()self:free()end)
		end
	end,
})