
--[────────────────────────-< DEPENDENCIES >-────────────────────────]--

local P = require("./plantUtils") ---@module "game.identities.plantUtils"
local Frame=require("lib.ui.frame")

local Identity=require("game.identity")
local Hitbox=require("game.hitbox")

--[────────────────────────-< ASSETS >-────────────────────────]--
local tex=textures["textures.cherry_bomb"]
local fIdle={
	Frame.new(tex,0,28,33,65),
	Frame.new(tex,35,28,81,65),
}

local fBoom=Frame.newArray(tex,83,0,174,67,3)
Frame.shiftArray(fBoom,vec(-35,-20))
local fSeed=Frame.new(tex,0,0,25,25,-1,0)

--[────────────────────────-< STATISTICS >-────────────────────────]--
local R = 24

Identity.new(fSeed,fIdle[1], "p.cherrybomb",150, 300,{
	---@param self Peashooter
	ENTER=function (self, screen)
		self.range = Hitbox.new(self,-R,-R*1.2,R*2,R*2.4)
		self.hitbox:setDim(24,24,0,0):setLayer("plants")
		self.i = 0
	end,
	
	---@param self Peashooter
	TICK=function (self, screen)
		self.i=self.i+1
		local i=self.i
		if self.i<20 then
			self.sprite:setFrame(fIdle[math.floor(i/10)+1])
			self.sprite:setPos(self.pos+vec(math.random(-1,1),math.random(-1,1)))
		else
			if i == 20 then --[────────-< EXPLODE >-────────]--
				screen.shake = 1
				screen:sound("minecraft:entity.generic.explode",0.5,1)
				screen:sound("minecraft:entity.generic.explode",0.75,1)
				for _, value in ipairs(self.range:getCollidingBoxes("zombies")) do
					value.object.burnt = true
					value.object:damage(99999999)
				end
			end
			self.sprite:setFrame(Frame.clamped(fBoom,(i-20)/4))
			if i > 36 then
				self:damage(999)
			end
		end
	end,
	
	DEATH=function (self, screen)
		self:free()
		self.range:free()
	end,
	
	---@param self Peashooter
	EXIT=function (self, screen)
		P.unplant(self,screen)
	end
	
})
