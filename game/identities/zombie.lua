--[[ NOTES
first spawn=sunflower cooldown*3
-- Health: 270, 1300 - 270
-- Cost: 50
]]

---@class Zombie : Object
---@field isWalking boolean

--[────────────────────────-< DEPENDENCIES >-────────────────────────]--

local Seq=require("lib.sequence")
local Frame=require("lib.ui.frame")
local Identity=require("game.identity")
local Object=require("game.object")

--[────────────────────────-< ASSETS >-────────────────────────]--

local texZombie=textures["textures.zombie"]
local texCone=textures["textures.cone_head"]
local texBucket=textures["textures.bucket"]

local function aSeed(tex)return Frame.new(tex,180,0,205,23,-1,-1)end
local function aIdle(tex)return Frame.newArray(tex,0,0,34,57,5)end
local function aWalk(tex)return Frame.shiftArray(Frame.newArray(tex,0,59,43,116,7),vec(-8,0))end
local function aEat(tex) return Frame.newArray(tex,0,118,36,175,7)end

local fZombIdle=aIdle(texZombie)
local fZombWalk=aWalk(texZombie)
local fZombEat=aEat(texZombie)
local fZombDie=Frame.newArray(texZombie,0,177,43,210,9)
local fBurn=Frame.new(texZombie,242,14,268,57)

--[────────────────────────-< FUNCTIONS >-────────────────────────]--

---@param fIdle Frame[]
---@param fWalk Frame[]
---@param fEat Frame[]
---@param dmgSound Minecraft.soundID?
---@param dmgPitch number?
---@return function
local function mkEnter(fIdle,fWalk,fEat,dmgSound,dmgPitch,dmgVolume)
	---@param self Zombie
	return function (self, s,useless) --[────────-< ENTER >-────────]--
		if not useless then
			s.waveHealth=s.waveHealth+self.health
			s.totalHealth=s.totalHealth+self.health
		end
		self.dmgSound=dmgSound
		self.dmgPitch=dmgPitch
		self.dmgVolume=dmgVolume
		self.fIdle=fIdle
		self.fWalk=fWalk
		self.fEat=fEat
		self.tint=vec(1,1,1)
		self.speed=1
		self.hitbox:setDim(27,5,0,0):setLayer("zombies")
		self:setPos(-128,-128)
		self.isWalking=true
		self.isEating=true
		self.isMunch=false
		self.i=math.random(1,256)
	end
end

---@param self Zombie
local function TICK(self, s) --[────────-< TICK >-────────]--
	self.i=self.i+1
	local sp= self.speed*(s.lvl.bowling and 4 or 1)
	
	if self.pos.x > -96 and s.playing then
		s.dead(self)
	end
	
	local clth=self.health<270 -- normal zombie health
	if self.health > 0 then
		
		local plant=self.hitbox:getCollidingBox("plants")
		if plant then
			local fEat=clth and fZombEat or self.fEat
			self.sprite:setFrame(Frame.scroll(fEat,self.i*0.3))
			local shouldMunch=self.sprite.frame == fEat[2] or self.sprite.frame == fEat[5]
			if shouldMunch ~= self.isMunch then
				if shouldMunch then
					plant.object:damage(20)
					s:sound("minecraft:entity.generic.eat",1)
				end
				self.isMunch=shouldMunch
			end
		else
			if self.isWalking then
				self:move(0.2*sp,0)
				self.sprite:setFrame(Frame.scroll(clth and fZombWalk or self.fWalk,self.i*0.17*sp))
			else
				self.sprite:setFrame(Frame.scroll(clth and fZombIdle or self.fIdle,self.i*0.15*sp))
			end
		end
	end
end

---@param s Screen
---@param amount any
local function DAMAGED(self, s, amount) --[────────-< DAMAGED >-────────]--
	if not self.useless then
		s.waveHealth=s.waveHealth-math.min(amount,self.health)
	end
	
	if self.health>270 and self.dmgSound then
		s:sound(self.dmgSound,self.dmgPitch,self.dmgVolume)
	end
	
	self.sprite:setColor(self.tint*vec(0.6,0.6,0.6))
	Seq.new()
	:add(5,function ()self.sprite:setColor(self.tint)end)
	:start()
end


local function DEATH(self, s)--[────────-< DEATH >-────────]--
	if not self.useless then
		s.waveHealth=s.waveHealth-math.max(self.health,0)
	end
	self.i=0
	if self.burnt then
		self.sprite:setFrame(fBurn)
		Seq.new():add(40,function ()self:free()end):start()
	else
		local function s()
			self.sprite:setFrame(Frame.clamped(fZombDie,self.i*0.3))
		end
		local seq=Seq.new()
		seq:start()
		for i=0, #fZombDie-1, 1 do seq:add(i*3,s)end
		
		seq:add(9,function () self.hitbox:setEnabled(false)end)
		:add((#fZombDie+3)*3,function ()self:free()end)
	end
end


--[────────────────────────-< IDENTITY REGISTRATION >-────────────────────────]--

Identity.new(aSeed(texZombie),fZombIdle[1], "z.zombie",50,270,{
	ENTER=mkEnter(fZombIdle,fZombWalk,fZombEat),
	TICK=TICK,
	DAMAGED=DAMAGED,
	DEATH=DEATH,
})

local fConeIdle=aIdle(texCone)
Identity.new(aSeed(texCone),fConeIdle[1], "z.conehead",75,570,{
	ENTER=mkEnter(fConeIdle,aWalk(texCone),aEat(texCone),"minecraft:entity.item.pickup",0.3),
	TICK=TICK,DAMAGED=DAMAGED,DEATH=DEATH,
})

local fBucketIdle=aIdle(texBucket)
Identity.new(aSeed(texBucket),fBucketIdle[1], "z.bucket",125,1300,{
	ENTER=mkEnter(fBucketIdle,aWalk(texBucket),aEat(texBucket),"minecraft:entity.zombie.attack_iron_door",1.2,0.5),
	TICK=TICK,DAMAGED=DAMAGED,DEATH=DEATH,
})