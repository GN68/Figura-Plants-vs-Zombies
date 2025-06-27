


--[────────────────────────-< DEPENDENCIES >-────────────────────────]--

local Seq=require("lib.sequence")
local Frame=require("lib.ui.frame")
local Identity=require("game.identity")
local Tween=require("lib.tween")

--[────────────────────────-< ASSETS >-────────────────────────]--

local texZombie=textures["textures.pole"]
local fSeed=Frame.new(texZombie,530,114,555,137)

local fZombie=Frame.newArray(texZombie,0,0,71,51,4)
local fZombieRun=Frame.newArray(texZombie,0,55,71,112,8)
local fZombieVault=Frame.newArray(texZombie,0,114,65,184,5)
local fZombieWalk=Frame.newArray(texZombie,334,153,367,209,7)
local fZombieEat=Frame.newArray(texZombie,292,0,324,53,7)
local fZombieDie=Frame.newArray(texZombie,334,114,381,151,5)
local fBurn=Frame.new(textures["textures.zombie"],242,14,268,57)

--[────────────────────────-< FUNCTIONS >-────────────────────────]--

---@param self Zombie
local function ENTER(self, s,useless)
	if not useless then
		s.waveHealth=s.waveHealth+self.health
		s.totalHealth=s.totalHealth+self.health
	end
	self.isVaulting=true
	self.tint=vec(1,1,1)
	self.speed=1
	self.hitbox:setDim(27,5,0,0):setLayer("zombies")
	self:setPos(-128,-128)
	self.isWalking=true
	self.isEating=true
	self.isMunch=false
	self.i=math.random(1,256)
end

---@param self Zombie
local function TICK(self, s)
	self.i=self.i+1
	local sp=self.speed
	
	if self.pos.x > -96 and s.playing then
		s.dead(self)
	end
	
	if self.health > 0 then
		
		local plant=self.hitbox:getCollidingBox("plants")
		if plant then
			if self.isVaulting then
				self.isVaulting=false
				self.vault=Tween.new{
					from=self.pos*1,
					to=self.pos+vec(51,0),
					duration=1,
					easing="linear",
					tick=function (v, t)
						self:setPos(v)
						self.sprite:setFrame(Frame.clamped(fZombieVault,t*7+1))
					end,
					onFinish=function ()
						self.finishedVaulting = true
					end
				}
			else
				if self.finishedVaulting then
					self.sprite:setFrame(Frame.scroll(fZombieEat,self.i*0.3))
					local shouldMunch=self.sprite.frame == fZombieEat[2] or self.sprite.frame == fZombieEat[5]
					if shouldMunch ~= self.isMunch then
						if shouldMunch then
							plant.object:damage(20)
							s:sound("minecraft:entity.generic.eat",1)
						end
						self.isMunch=shouldMunch
					end
				end
			end
		else
			if self.isWalking then
				if self.isVaulting then
					self:move(0.4*self.speed,0)
					self.sprite:setFrame(Frame.scroll(fZombieRun,self.i*0.4*sp))
				else
					if self.finishedVaulting then
						self:move(0.2*self.speed,0)
						self.sprite:setFrame(Frame.scroll(fZombieWalk,self.i*0.1*sp))
					end
				end
			else
				self.sprite:setFrame(Frame.scroll(fZombie,self.i*0.15*sp))
			end
		end
	end
end

local function DAMAGED(self, s, a)
	if not self.useless then
		s.waveHealth=s.waveHealth-math.min(a,self.health)
	end
	self.sprite:setColor(self.tint*vec(0.6,0.6,0.6))
	Seq.new()
	:add(5,function ()self.sprite:setColor(self.tint)end)
	:start()
end


local function DEATH(self, s)
	if not self.useless then
		s.waveHealth=s.waveHealth-math.max(self.health,0)
	end
	self.i=0
	if self.burnt then
		self.sprite:setColor(0,0,0)
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
end


--[────────────────────────-< IDENTITY REGISTRATION >-────────────────────────]--

Identity.new(fSeed,fZombie[1], "z.pole",75,270,{
	ENTER=ENTER,
	TICK=TICK,
	DAMAGED=DAMAGED,
	DEATH=DEATH,
})