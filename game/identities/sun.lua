
---@class Sun : Object

local Identity=require("game.identity")
local Object=require("game.object")
local Tween =require("lib.tween")
local Seq=require("lib.sequence")

local Frame=require("lib.ui.frame")

local tex=textures["textures.sun"]
local fSun=Frame.newArray(tex,0,17,24,41,2)

Identity.new(nil,nil, "sun",25,1,{
	---@param self Seed
	ENTER=function (self, screen, amount, fell)
		self.i=0
		self.amount=amount or 25
		self.hitbox:setDim(0,0,25,25)
		if fell then
			local to=-vec(math.lerp(120,280,math.random()),math.lerp(65,155,math.random()))
			self.fall=Tween.new{
				from=vec(to.x,-27),
				to=to,
				easing="linear",
				duration=-(to.y+27)/60,
				tick=function (v, t)
					self:setPos(v)
				end
			}
		else
			self.fall=Tween.new{
				from=0,
				to=1,
				easing="linear",
				duration=0.5,
				tick=function (v, t)
					self:setPos(self.pos + vec(0,math.cos(v*3.14)*0.2))
				end
			}
		end
	end,
	
	TICK=function (self, screen)
		self.i=self.i+0.5
		self.sprite:setFrame(Frame.scroll(fSun,self.i))
	end,
	
	CLICK=function (self, screen)
		Seq.new()
		:add(0,function ()screen:sound("minecraft:block.note_block.harp",2^(-3/12),0.3)end)
		:add(2,function ()screen:sound("minecraft:block.note_block.harp",2^(0/12),0.3)end)
		:add(4,function ()screen:sound("minecraft:block.note_block.harp",2^(5/12),0.3)end)
		:start()
		if self.fall then
			self.fall:stop()
		end
		self.hitbox:setEnabled(false)
		Tween.new{
			from=self.pos,
			to=vec(-87,-17),
			duration=0.5,
			easing="outQuad",
			tick=function (v)
				self:setPos(v)
			end,
			onFinish=function ()
				screen.addSun(self.amount)
				self:free()
			end
		}
	end
})