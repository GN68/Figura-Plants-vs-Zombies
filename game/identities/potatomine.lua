
local P = require("./plantUtils") ---@module "game.identities.plantUtils"
local Sprite=require("lib.ui.sprite")
local Frame=require("lib.ui.frame")

local Identity=require("game.identity")
local Object=require("game.object")
local Hitbox=require("game.hitbox")


local tex=textures["textures.potato_mine"]
local fNew=Frame.new(tex,30,1,57,24)
local fIdle=Frame.newArray(tex,1,26,28,49,2)
local mfDoom=Frame.new(tex,1,51,51,94,-12)

local fSeed=Frame.new(tex,5,2,28,24)
-- 15 seconds

Identity.new(fSeed,fIdle[1], "p.potatomine",25, 300,{
	---@param self Peashooter
	ENTER=function (self, screen)
		self.hitbox:setDim(24,24,0,0):setLayer("plants")
		self.i=0
	end,
	
	---@param self Peashooter
	TICK=function (self, screen)
		self.i=self.i+1
		if not self.bombed then
			if self.i < 300 then -- 15 seconds
				self.sprite:setFrame(fNew)
			else
				self.sprite:setFrame(Frame.scroll(fIdle,self.i*0.25))
				local z = self.hitbox:getCollidingBoxes("zombies")
				if #z > 0 and not self.bombed then
					for _,z in pairs(z) do
						z.object.burnt = true
						z.object:damage(1800)
					end
					self.sprite:setFrame(mfDoom)
					self.i = 0
					self.bombed = true
					screen.shake = 1
					screen:sound("minecraft:entity.generic.explode",0.5,1)
					screen:sound("minecraft:entity.generic.explode",0.75,1)
				end
			end
		end
		if self.bombed and self.i > 40 then
			self:free()
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
