local params = require("lib.params")

---@class Frame
---@field texture Texture
---@field UV Vector4
---@field offset Vector2
local Frame = {}
Frame.__index = Frame


---@param texture Texture
---@param U1 number
---@param V1 number
---@param U2 number
---@param V2 number
---@param Ox number?
---@param Oy number?
---@return Frame
function Frame.new(texture,U1,V1,U2,V2,Ox,Oy)
	local new = setmetatable({},Frame)
	new.UV = vec(U1,V1,U2,V2)
	new.texture = texture
	new.offset = vec(Ox or 0,Oy or 0)
	return new
	
end

return Frame