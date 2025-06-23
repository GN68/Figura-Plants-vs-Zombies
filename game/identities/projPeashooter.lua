---@class Peashooter.Projectile : Object

local Sprite=require("lib.ui.sprite")
local Frame=require("lib.ui.frame")

local Identity=require("game.identity")

local DAMAGE=20

local tex=textures["textures.peashooter"]
local frame=Frame.new(tex,348,12,357,21,0,20)

local fHit=Frame.newArray(tex,360,1,371,32,2)
Frame.applyOffsettoAll(fHit,vec(0,10))

local fShadow=
Frame.new(textures["textures.shadows"],20,1,29,5,0,0)
--Frame.new(textures["textures.shadows"],1,1,17,8,-4,-3)

local function delete(self)
	self:free()
	self.shadow:free()
end

Identity.new(nil,nil, "peashooter.proj",100,1,{
	
	---@param self Peashooter
	ENTER=function (self, screen)
		self.shadow=Sprite.new(screen,fShadow):setLayer(-0.8)
		self.sprite:setFrame(frame)
		self.hitbox:setDim(10,10,0,0)
	end,
	
	---@param self Peashooter
	TICK=function (self, screen)
		if not self.hit then
			self:move(-6,0)
			if self.pos.x < -350 then
				return delete(self)
			end
			local hit=self.hitbox:getCollidingBoxes("zombies")
			if #hit > 0 then
				self.hit=1
				hit[1].object:damage(DAMAGE)
				self.hitbox:setEnabled(false)
				screen:sound("minecraft:block.big_dripleaf.break",1.5)
			end
		else
			self.hit=self.hit+1
			local f=math.floor(self.hit/5*#fHit+1)
			self.sprite:setFrame(fHit[f])
			if self.hit >= 5 then
				return delete(self)
			end
		end
		self.shadow:setPos(self.pos)
	end,
})