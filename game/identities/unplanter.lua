
local Identity=require("game.identity")
local Frame=require("lib.ui.frame")


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


local tex=textures["textures.shovel"]
local fShovel=Frame.new(tex,36,0,63,13)
Identity.new(nil,nil, "unplanter",999,1,{
	ENTER=function (self, screen,bowl)
		self.sprite:setFrame(fShovel)
		self.bowl=bowl
		self.hitbox:setDim(-99,-99,99,99)
	end,
	
	TICK=function (self, screen)
		local tpos=snap(screen.gmPos.x,screen.gmPos.y,screen)
		self.tpos=tpos
		if tpos then
			self:setPos(tpos+vec(-math.abs(math.sin(client:getSystemTime()/200)*8)-8,0))
			self.sprite:setVisible(true)
		else
			self.sprite:setVisible(false)
		end
	end,
	
	EXIT=function (self, screen)
		if self.bowl then
			self.bowl.back()
		end
	end,
	
	---@param self Seed
	CLICK=function (self, screen)
		self:free()
		screen.planter=nil
		if self.tpos then
			local id=self.tpos:toString()
			local plant=screen.plants[id]
			if plant then
				screen:sound("minecraft:block.grass.break")
				plant:damage(9999)
				screen.plants[id]=nil
			end
		end
	end
})