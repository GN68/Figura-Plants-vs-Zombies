
local P = require("./plantUtils") ---@module "game.identities.plantUtils"
local Sprite=require("lib.ui.sprite")
local Frame=require("lib.ui.frame")

local Identity=require("game.identity")
local Object=require("game.object")
local Hitbox=require("game.hitbox")


local tex=textures["textures.chomp"]
local fIdle=Frame.newArray(tex,0,0,47,43,9)
Frame.shiftArray(fIdle,vec(-18,3))
local fChomp=Frame.newArray(tex,0,45,49,96,6)
Frame.shiftArray(fChomp,vec(-16,3))
local fMunch=Frame.newArray(tex,306,45,342,82,3)
Frame.shiftArray(fMunch,vec(-10,3))

local fSeed=Frame.new(tex,420,45,445,71,-1,-1)
-- 42 seconds

Identity.new(fSeed,fIdle[1], "p.chomper",150, 300,{
	---@param self Peashooter
	ENTER=function (self, screen)
		self.hitbox:setDim(24,24,0,0):setLayer("plants")
		self.i=math.random(255)
		self.sight=Hitbox.new(self,-26,0,0,16,"sight")
		self.isEating = false
	end,
	
	---@param self Peashooter
	TICK=function (self, s)
		self.i=self.i+1
		self.sprite:setFrame(Frame.scroll(fIdle,self.i*0.25))
		
		if self.isEating then
			local i = self.i
			if i*0.25 <= 3 then
				self.sprite:setFrame(Frame.clamped(fChomp,self.i*0.25))
				if i*0.25 == 3 then
					s:sound("minecraft:entity.generic.eat",0.75)
					self.target:damage(69420) -- has to be this or it will break fr fr
					self.target:free()
				end
			else
				self.sprite:setFrame(Frame.scroll(fMunch,self.i*0.25))
				if i > 840 then --42 seconds
					self.isEating = false
				end
			end
		else
			local z = self.sight:getCollidingBox("zombies")
			if z then
				self.isEating = true
				self.i = 0
				self.target = z.object
			end
		end
	end,
	
	DEATH=function (self, screen)
		self:free()
		self.sight:free()
	end,
	
	---@param self Peashooter
	EXIT=function (self, screen)
		P.unplant(self,screen)
	end
	
})
