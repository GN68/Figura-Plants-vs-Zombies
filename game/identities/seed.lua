
---@class Seed : Object
---@field planter Object?
---@field isActive boolean
---@field seedIdentity Object.Identity

local Identity=require("game.identity")
local Object=require("game.object")
local Seq=require("lib.sequence")

Identity.new(nil,nil, "seed",999,1,{
	---@param self Seed
	---@param identity Object.Identity
	ENTER=function (self, screen, identity)
		self.sprite:setFrame(identity.seed)
		self.seedIdentity=identity
		self.hitbox:setDim(0,0,24,24)
		screen.SUN_CHANGED:register(function ()
			if identity.cost <= screen.suns then
				self.sprite:setColor(1,1,1)
			else
				self.sprite:setColor(0.5,0.5,0.5)
			end
		end)
	end,
	
	---@param self Seed
	CLICK=function (self, screen)
		if screen.planter then
			screen.planter:free()
			screen.planter=nil
			self.isActive=false
		else
			if self.seedIdentity.cost <= screen.suns then
				self.isActive=true
				screen.planter=Object.new("planter",screen,self.seedIdentity)
			else
				screen:sound("minecraft:entity.player.attack.sweep",1.5,1)
				Seq.new()
				:add(2,function ()
					screen:sound("minecraft:entity.player.attack.sweep",1,1)
				end)
				:start()
				end
		end
	end
})