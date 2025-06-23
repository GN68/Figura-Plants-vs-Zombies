--[[NOTES

Sun cost: 100
proj/sec: 1.425
Recharge: 7.5 sec
Damage: 20
Toughness: 300

]]
---@class Planter : Object
---@field seedIdentity Object.Identity

local Debug=require("lib.ui.debug")
local Seq=require("lib.sequence")


local Sprite=require("lib.ui.sprite")
local Frame=require("lib.ui.frame")

local Identity=require("game.identity")
local Object=require("game.object")
local Hitbox=require("game.hitbox")

local S=50



local function snap(x,y,screen)
	local range=screen.range
	local tpos=vec(
	math.floor(x/26),
	math.floor(y/31))
	if tpos.x <= -4-range.x 
	and tpos.y <= -2-range.y 
	and tpos.x > -4-range.z 
	and tpos.y > -2-range.w then
		return vec(
		tpos.x*26-4,
		tpos.y*31+4
		)
	end
end

Identity.new(nil,nil, "planter",0,1,{
	
	---@param self Peashooter
	---@param identity Object.Identity
	ENTER=function (self, screen, identity)
		self.hitbox:setDim(-S,-S,S,S)
		self.sprite:setFrame(identity.icon)
		self.sprite:setColor(0.5,0.5,0.5)
		self.seedIdentity=identity
		screen:sound("minecraft:block.grass.place",1.5,1)
	end,
	TICK=function (self, screen)
		local pos=snap(screen.gmPos.x,screen.gmPos.y,screen)
		if pos then
			self:setPos(pos)
			self.sprite:setVisible(true)
		else
			self.sprite:setVisible(false)
		end
	end,
	
	---@param self Planter
	CLICK=function (self, screen)
		local id=self.pos:toString()
		if not screen.plants[id] then
			screen:sound("minecraft:block.grass.place",1,1)
			Object.new(self.seedIdentity.name,screen):setPos(self.pos)
			self:free()
			screen.addSun(-self.seedIdentity.cost)
			screen.planter=nil
		else
			screen:sound("minecraft:entity.player.attack.sweep",1.5,1)
			Seq.new()
			:add(2,function ()
				screen:sound("minecraft:entity.player.attack.sweep",1,1)
			end)
			:start()
		end
	end
})