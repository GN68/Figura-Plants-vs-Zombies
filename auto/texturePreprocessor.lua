local texs=textures:getTextures()
local i=1

local CHUNK_SIZE=128

local x=0
local y=0

local tex=texs[1]
local dim=tex:getDimensions()

events.WORLD_RENDER:register(function (delta)
	local r=vec(x,y,math.min(x+CHUNK_SIZE,dim.x),math.min(y+CHUNK_SIZE,dim.y))
	tex:applyFunc(r.x,r.y,r.z-r.x,r.w-r.y,function (col, x, y)
		if col.x > 0.9 and col.y == 0 and col.z == 0 then
			return vec(0,0,0,0)
		end
	end)
	
	
	x=x+CHUNK_SIZE
	if x >=dim.x then
		x=0
		y=y+CHUNK_SIZE
		if y >= dim.y then
			i=i+1
			x=0
			y=0
			if i > #texs then
				tex:update()
				events.WORLD_RENDER:remove("texturePreprocessor")
				return
			end
			tex:update()
			tex=texs[i]
			dim=tex:getDimensions()
		end
	end
end,"texturePreprocessor")