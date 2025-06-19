local model = models.hardware

model:setParentType("SKULL")

local ASPECT_RATIO = 256/192

local SENSITIVITY = vec(0.01/ASPECT_RATIO,0.01)

local mpos = vec(0,0)

local lrot = vec(0,0)


local modelScreen1 = models.hardware.base.screen

modelScreen1:setPrimaryRenderType("EMISSIVE_SOLID")


events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
	local rightHanded = client:getViewer():getActiveHand() == "MAIN_HAND"
	if ctx:find((rightHanded and "LEFT" or "RIGHT") .."_HAND$") then
		local rot = client:getCameraRot().xy
		local diff = (rot - (lrot or rot) + 180) % 360 - 180
		lrot = rot
		
		mpos = mpos + diff.yx * SENSITIVITY
		
		mpos.x = math.clamp(mpos.x,0,1)
		mpos.y = math.clamp(mpos.y,0,1)
		
		model:setPos(9 * (rightHanded and -1 or 1) + math.lerp(-8,8,mpos.x),4.4+math.lerp(0,12,mpos.y),0):rot(0,0,0)
	else
		model:setPos(0,4,1):scale():rot(90,0,0)
	end
end)