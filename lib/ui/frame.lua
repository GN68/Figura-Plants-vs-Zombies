local params=require("lib.params")

---@class Frame
---@field UV Vector4
---@field UVn Vector4 # Normalized
---@field texture Texture
---@field dim Vector2
---@field texDim Vector2
---@field offset Vector2
local Frame={}
Frame.__index=Frame


---@param texture Texture
---@param U1 number?
---@param V1 number?
---@param U2 number?
---@param V2 number?
---@param Ox number?
---@param Oy number?
---@return Frame
function Frame.new(texture,U1,V1,U2,V2,Ox,Oy)
	local new=setmetatable({},Frame)
	local dim=texture:getDimensions()
	if not U1 or not V1 or not U2 or not V2 then
		U1=0
		V1=0
		U2=dim.x-1
		V2=dim.y-1
	else
	end
	new.UV=vec(U1,V1,U2+1,V2+1)
	new.texture=texture
	new.dim=new.UV.zw-new.UV.xy
	new.texDim=texture:getDimensions()
	new.UVn=new.UV / dim.xyxy
	new.offset=vec(Ox or 0,Oy or 0)
	return new
end

local t=vec(0,0)
local debugOutput={}

---@param texture Texture
---@param U1 number?
---@param V1 number?
---@param U2 number?
---@param V2 number?
---@param count number?
---@param autoOffsetDetection boolean? # NOTE: Developer tool, used to align frames together quickly
---@return Frame[]
function Frame.newArray(texture,U1,V1,U2,V2,count,autoOffsetDetection)
	local array={}
	local shift=vec(U2-U1+2, 0)
	
	if autoOffsetDetection then
		t=vec(0,0)
		debugOutput=""
	end
	
	local pos=vec(0,0)
	for i=1, count, 1 do
		local dim=vec(U1+pos.x,V1+pos.y,U2+pos.x,V2+pos.y)
		if autoOffsetDetection then
			texture:applyFunc(dim.x,dim.y,dim.z-dim.x,dim.w-dim.y,function (col, x, y)
				local pos=vec(x-dim.x,y-dim.y)
				if col.x == 0 and col.y == 0 and col.z == 1 then -- blue pixel atcs as a tracking point
					if i == 1 then
						t=pos -- tracking origin
					end
					print(pos.x-t.x,pos.y-t.y)
					debugOutput=debugOutput .. ("vec(%s,%s),\n"):format(pos.x-t.x,pos.y-t.y)
				end
			end)
		end
		array[i]=Frame.new(texture,U1+pos.x,V1+pos.y,U2+pos.x,V2+pos.y)
		pos=pos+shift
	end
	if autoOffsetDetection and true then
		host:setClipboard(debugOutput)
		print("saved to clipboard")
	end
	return array
end



---@param frames Frame[]
---@param offsets Vector2[]
function Frame.applyOffsetToArray(frames,offsets)
	for index, value in ipairs(frames) do
		value.offset=offsets[index]
	end
end

---@param frames Frame[]
---@param offset Vector2
function Frame.applyOffsettoAll(frames,offset)
	for index, value in ipairs(frames) do
		value.offset=offset
	end
end


function Frame.scroll(frames,i,debug)
	local frame=math.floor(i%#frames)+1
	if debug then
		local timeline={}
		for j=1, #frames, 1 do
			timeline[j]={text="|",color=(j==frame and "#ff0000" or "#000000")}
		end
		timeline[#timeline+1]={text=" "..frame,color="#ffffff"}
		host:setActionbar(toJson(timeline))
	end
	return frames[frame]
end

function Frame.clamped(frames,i,flip)
	if flip then
		i=#frames-i
	end
	return frames[math.clamp(1,#frames,math.floor(i))]
end


return Frame