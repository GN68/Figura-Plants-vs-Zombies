--[[ NOTES
first spawn = sunflower cooldown * 3
-- Health: 270
-- Cost: 50
]]

---@class Zombie : Object
---@field isWalking boolean

local Debug = require("lib.ui.debug")

local Sprite = require("lib.ui.sprite")
local Frame = require("lib.ui.frame")

local Identity = require("game.identity")
local Object = require("game.object")
local Hitbox = require("game.hitbox")


local texZombie = textures["textures.zombie"]
local fZombie = Frame.newArray(texZombie,0,0,34,50,5)
local fZombieWalk = Frame.newArray(texZombie,0,52,41,105,7)
local fIcon = Frame.new(texZombie,180,30,203,50)



Identity.new(fIcon, "zombie",{
	---@param self Zombie
	ENTER = function (self, screen)
		self.hitbox:setDim(27,20,0,0):setLayer("zombie")
		self:setPos(-128,-128)
		self.isWalking = false
		self.i = math.random(1,256)
	end,
	
	---@param self Zombie
	TICK = function (self, screen)
		self.i = self.i + 1
		if self.isWalking then
			self:setPos(self.pos.x + 0.2,self.pos.y)
			self.sprite:setFrame(Frame.scroll(fZombieWalk,self.i*0.1))
		else
			self.sprite:setFrame(Frame.scroll(fZombie,self.i*0.15))
		end
	end,
	
	CLICK = function (self, screen)
	end,
	
	EXIT = function (self, screen)
	end
})