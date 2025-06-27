
local P = require("./plantUtils") ---@module "game.identities.plantUtils"
local Frame=require("lib.ui.frame")
local Identity=require("game.identity")


local tex=textures["textures.wallnut"]
local fIdle=Frame.newArray(tex,54,0,81,31,2)
local fBowls=Frame.newArray(tex,112,0,143,32,8)

local fSeed=Frame.new(tex,0,7,25,31,-1,-1)
-- 15 seconds

Identity.new(fSeed,fIdle[1], "p.wallnut",50, 4000,{
	---@param self Peashooter
	ENTER=function (self, screen)
		self.hitbox:setDim(24,24,0,0):setLayer("plants")
		self.i=0
		self.d=0
	end,
	
	---@param self Peashooter
	TICK=function (self, s)
		self.i=self.i+1
		if s.lvl.bowling then --[────────────────────────-< BOWLING LOGIC >-────────────────────────]--
			P.unplant(self,s)
			self.sprite:setFrame(Frame.scroll(fBowls,self.i*0.5))
			self.hitbox:setLayer("b"):setDim(24,3,0,0)
			self:move(-3,self.d)
			local z=self.hitbox:getCollidingBox("zombies")
			if z and z~=self.l then
				z.object:damage(math.max(270,z.object.health/1.5))
				s:sound("minecraft:block.rooted_dirt.break",0.2,1)
				s:sound("minecraft:entity.player.attack.sweep",0.5,1)
				s.shake=0.001
				self.l=z
				if self.d==0 then
					self.d=(math.random(1)*2-1)*3
				else
					self.d=-self.d
				end
			end
			if self.pos.y > -30 then self.d=-3 end
			if self.pos.y < -183 then self.d=3 end
			if self.pos.x < -350 then self:free() end
		else
			self.sprite:setFrame(fIdle[self.health<1333 and 2 or 1])
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
