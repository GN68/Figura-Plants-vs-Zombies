

local P=require("./plantUtils") ---@module "game.identities.plantUtils"
local Frame=require("lib.ui.frame")
local Seq=require("lib.sequence")

local Identity=require("game.identity")
local Object=require("game.object")
local Hitbox=require("game.hitbox")

local tex=textures["textures.repeat"]
local fIdle=Frame.newArray(tex,28,0,56,30,5)
Frame.offset2Array(fIdle,{vec(0,0),
vec(-1,0),
vec(-2,-1),
vec(1,-1),
vec(2,-2),
})
local fShoot=Frame.newArray(tex,178,0,204,30,2)
Frame.offset2Array(fShoot,{vec(0,0),vec(-2,0),vec(-4,0)})

local fSeed=Frame.new(tex,0,0,25,22,-1)


Identity.new(fSeed,fIdle[1], "p.repeater",200, 300,{
	---@param self Peashooter
	ENTER=function (self, screen)
		self.hitbox:setDim(27,16,0,0):setLayer("plants")
		self.isShooting=true
		self.shootC=28.5
		self.shootT=99
		self.sight=Hitbox.new(nil,"sight")
		local function a()
			self.sight:setDim(-320,self.pos.y,self.pos.x	,self.pos.y+16)
		end
		self.MOVED:register(a)
		a()
		self.i=math.random(1,256)
	end,
	
	---@param self Peashooter
	TICK=function (self, screen)
		self.i=self.i+1
		self.shootC=self.shootC-1
		self.shootT=self.shootT+1
		local zamb=self.sight:getCollidingBox("zombies")
		if zamb then
			if  self.shootC <= 0 then
				self.shootC=28.5
				self.shootT=0
				Seq.new():add(5,function ()Object.new("peashooter.proj",screen):setPos(self.pos) self.shootT=0 end):start()
				Object.new("peashooter.proj",screen):setPos(self.pos)
				screen:sound("minecraft:ui.toast.in",3,0.2)
			end
		end
		if self.shootT < 2 then
			self.sprite:setFrame(fShoot[1])
		else
			self.sprite:setFrame(Frame.scroll(fIdle,self.i*0.125))
		end
	end,
	
	
	DEATH=function (self, screen)
		self:free()
	end,
	
	---@param self Peashooter
	EXIT=function (self, screen)
		self.sight:free()
		P.unplant(self,screen)
	end
	
})
