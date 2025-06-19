local params = require("lib.params")

---@class Frame
---@field UV Vector4
---@field UVn Vector4 # Normalized
---@field texture Texture
---@field textureDimensions Vector2
---@field offset Vector2
local Frame = {}
Frame.__index = Frame


---@param texture Texture
---@param U1 number?
---@param V1 number?
---@param U2 number?
---@param V2 number?
---@param Ox number?
---@param Oy number?
---@return Frame
function Frame.new(texture,U1,V1,U2,V2,Ox,Oy)
	local new = setmetatable({},Frame)
	local dim = texture:getDimensions()
	if not U1 or not V1 or not U2 or not V2 then
		U1 = 0
		V1 = 0
		U2 = dim.x
		V2 = dim.y
	end
	new.UV = vec(U1,V1,U2,V2)
	new.texture = texture
	new.textureDimensions = dim
	new.UVn = new.UV / dim.xyxy
	new.offset = vec(Ox or 0,Oy or 0)
	return new
end

return Frame