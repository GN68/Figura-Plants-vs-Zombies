---@param model ModelPart
---@param process fun(model:ModelPart)?
---@return ModelPart
local function deepCopyModel(model,process)
	local copy = model:copy(model:getName())
	if process then process(copy) end
	for key, child in pairs(copy:getChildren()) do
		copy:removeChild(child):addChild(deepCopyModel(child,process))
	end
	return copy
end

return deepCopyModel