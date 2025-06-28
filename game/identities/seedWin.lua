
local Identity=require("game.identity")
local Object=require("game.object")
local Seq=require("lib.sequence")
local Tween=require("lib.tween")
local NBS=require("lib.nbs")

local victory=NBS.loadTrack("victory")

Identity.new(nil,nil, "seedwin",999,1,{
	---@param self Seed
	---@param identity string
	ENTER=function (self, screen, identity)
		
		self.sprite:setFrame(Identity.IDENTITIES[identity or "p.sunflower"].seed)
		self.hitbox:setDim(0,0,24,24)
		self.fall=Tween.new{
			from=0,
			to=1,
			easing="linear",
			duration=0.75,
			tick=function (v, t)
				self:setPos(self.pos+vec(0,math.cos(v*3.14)*1))
			end,
		}
	end,
	
	---@param self Seed
	CLICK=function (self, s)
		s:sound("minecraft:block.grass.break",1,1)
		s.musicPlayer:setTrack(victory):play(true)
		self.fall:stop()
		self.fall=Tween.new{
			from=self.pos,
			to=(-s.camPos-s.resolution*0.5)-vec(12,12),
			easing="outQuad",
			duration=5,
			tick=function (v)
				self:setPos(v)
			end,
		}
		Tween.new{
			from=0,
			to=1,
			easing="inQuad",
			duration=5,
			tick=function (v)
				s.setOverlay(1,1,1,v)
			end,
			onFinish=function ()
				s.win=true
				self:free()
			end
		}
	end
})