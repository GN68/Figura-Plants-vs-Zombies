--[[NOTES

Sun cost: 100
proj/sec: 1.425
Recharge: 7.5 sec
Damage: 20
Toughness: 300

]]

local Debug=require("lib.ui.debug")


local SHOOT_COOLDOWN=28.5

local P = require("./plantUtils") ---@module "game.identities.plantUtils"
local Sprite=require("lib.ui.sprite")
local Frame=require("lib.ui.frame")

local Identity=require("game.identity")
local Object=require("game.object")
local Hitbox=require("game.hitbox")


local tex=textures["textures.grass"]
local fStill=Frame.new(tex,245,208,268,225)

Identity.new(nil,fStill[1], "lawnmower",100, 300,{
	---@param self Peashooter
	ENTER=function (self, screen)
		self.hitbox:setDim(27,16,0,0)
		self.sprite:setFrame(fStill)
		self.isActive = false
	end,
	
	---@param self Peashooter
	TICK=function (self, screen)
		local zs = self.hitbox:getCollidingBoxes("zombies")
		if #zs > 0 and not self.isActive then
			self.isActive = true
			screen:sound("minecraft:block.note_block.hat",0.5,1)
		end
		
		if self.isActive then
			for key, value in pairs(zs) do
				value.object:damage(999999)
				value.object:free()
			end
			self:move(-6,0)
			if self.pos.x < -360 then
				self:free()
			end
		end
	end,
	
	
	DEATH=function (self, screen)self:free()end,
	
	---@param self Peashooter
	EXIT=function (self, screen)
	end
	
})
