
local Identity=require("game.identity")
local Object=require("game.object")
local Frame=require("lib.ui.frame")

local tex=textures["textures.shovel"]
local fBowl=Frame.new(tex,0,0,34,13)
local fShovel=Frame.new(tex,36,0,63,13)
local fBowlEmpty=Frame.new(tex,65,0,99,13)

Identity.new(nil,nil, "shovel",999,1,{
	ENTER=function (self, screen)
		self:setPos(-320,-192)
		self.sprite:setFrame(fBowl)
		self.hitbox:setDim(0,0,34,13)
		self.back = function ()
		self.sprite:setFrame(fBowl)
		end
	end,
	
	
	
	---@param self Seed
	CLICK=function (self, screen)
		if screen.planter then
			screen:sound("minecraft:block.metal_pressure_plate.click_off")
			screen.planter:free()
			screen.planter=nil
			self.sprite:setFrame(fBowl)
		else
			self.sprite:setFrame(fBowlEmpty)
			screen:sound("minecraft:item.shovel.flatten")
			screen.planter = Object.new("unplanter",screen,self)
		end
	end
})