local texs = textures:getTextures()
local i = 1

local CHUNK_SIZE = 32

local x = 0
local y = 0

local tex = texs[1]
local dim = tex:getDimensions()

events.WORLD_RENDER:register(function (delta)
	local region = vec(x,y,math.min(x+CHUNK_SIZE,dim.x-1),math.min(y+CHUNK_SIZE,dim.y-1))
	tex:applyFunc(region.x,region.y,region.z-region.x,region.w-region.y,function (col, x, y)
		if col.x == 1 and col.y == 0 and col.z == 0 then
			return vec(0,0,0,0)
		end
	end)
	
	x = x + CHUNK_SIZE
	if x >=dim.x then
		x = 0
		y = y + CHUNK_SIZE
		if y >= dim.y then
			i = i + 1
			x = 0
			y = 0
			if i >= #texs then
				events.WORLD_RENDER:remove("texturePreprocessor")
				return
			end
			tex:update()
			tex = texs[i]
			dim = tex:getDimensions()
		end
	end
	
end,"texturePreprocessor")