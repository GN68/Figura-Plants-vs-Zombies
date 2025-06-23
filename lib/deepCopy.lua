---@param model ModelPart
---@return ModelPart
local function deepCopyModel(model)
	local copy=model:copy(model:getName())
	for _, child in ipairs(model:getChildren()) do
		copy:removeChild(child)
		deepCopyModel(child):moveTo(copy)
	end
	return copy
end

return deepCopyModel