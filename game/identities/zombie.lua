local Debug = require("lib.ui.debug")

local Sprite = require("lib.ui.sprite")
local Frame = require("lib.ui.frame")

local Identity = require("game.identity")
local Object = require("game.object")
local Hitbox = require("game.hitbox")


local texZombie = textures["textures.zombie"]
local fZombie = Frame.newArray(texZombie,0,0,34,50,0,0,5)
local fZombieWalk = Frame.newArray(texZombie,0,52,41,105,0,0,7)
local fIcon = Frame.new(texZombie,180,30,203,50)

local function scrollFrame(frames,i)
	return frames[math.floor(i%#frames)+1]
end

Identity.new(fIcon, "zombie",{
	ENTER = function (self, screen)
		self.hitbox:setDim(27,45,0,0)
		self:setPos(-128,-128)
		self.isWalking = false
		self.i = math.random(1,256)
	end,
	
	TICK = function (self, screen)
		self.i = self.i + 1
		if self.isWalking then
			self:setPos(self.pos.x + 0.1,self.pos.y)
			self.sprite:setFrame(scrollFrame(fZombieWalk,self.i*0.1))
		else
			self.sprite:setFrame(scrollFrame(fZombie,self.i*0.15))
		end
	end,
	
	CLICK = function (self, screen)
	end,
	
	EXIT = function (self, screen)
	end
})