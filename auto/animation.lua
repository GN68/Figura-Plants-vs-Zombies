
--[────────────────────────────────────────-< AvatarNBT Documentation >-────────────────────────────────────────]--

---@class AvatarNBT.Vector3 : Vector3
---@field [0] number
---@field [1] number
---@field [2] number

---@class AvatarNBT.Model
---@field chld AvatarNBT.Model[]
---@field name string
---@field anim AvatarNBT.AnimationData?
---@field piv AvatarNBT.Vector3

---@class AvatarNBT.AnimationData
---@field data {scl:AvatarNBT.AnimationTrack, rot:AvatarNBT.AnimationTrack, pos:AvatarNBT.AnimationTrack}
---@field id integer

---@class AvatarNBT.AnimationTrack
---@field [number] AvatarNBT.Keyframe

---@class AvatarNBT.Keyframe
---@field pre AvatarNBT.Vector3
---@field time number
---@field int "linear"|

---@class AvatarNBT.AnimationIdentity
---@field name string
---@field len number # length
---@field mdl string # Model name
---@field loop "loop"|"hold"|nil # Loop type, nil if none

--[────────────────────────-< Library Documentation >-────────────────────────]--
---@class AvatarNBT.AnimationIdentity.Parsed : AvatarNBT.AnimationIdentity


---@class ModelPart
---@field isPlaying boolean
---@field isHolding boolean # if teh animation is paused at the end of the animation


--[────────────────────────────────────────-< NBT Animation Parsing >-────────────────────────────────────────]--

-- NOTE: The typings are only related to the animation library, not everything is included.
---@type {animations:AvatarNBT.AnimationIdentity[],models:{name:"models",child:AvatarNBT.Model[]}}
local nbt = avatar:getNBT()




---@type table<string,AvatarNBT.AnimationIdentity.Parsed>
local animationIdentities = {}
local animationIdentityLookup = {}
local animationStates = {}


for id, animation in ipairs(nbt.animations) do
	local name = animation.mdl .. "." .. animation.name
	---@cast animation AvatarNBT.AnimationIdentity.Parsed
	animationIdentities[name] = animation
	animationIdentityLookup[name] = id
	animation.tracks = {}
end


---@param track AvatarNBT.AnimationTrack
local function parseAnimationTrack(track)
	for index, keyframe in ipairs(track) do
	---@diagnostic disable-next-line: assign-type-mismatch
		keyframe.pre = vec(table.unpack(keyframe.pre))
	end
	return track
end

--- Convert the model tree to a nested map for efficiency
---@param entry AvatarNBT.Model
---@param model ModelPart
local function parseNBTModelData(entry,model)
	if entry.anim then
		---@param index integer
		---@param timeline AvatarNBT.AnimationData
		for index, timeline in ipairs(entry.anim) do
			local id = timeline.id+1
			if timeline.data then
				timeline.data.scl = timeline.data.scl and parseAnimationTrack(timeline.data.scl)
				timeline.data.rot = timeline.data.rot and parseAnimationTrack(timeline.data.rot)
				timeline.data.pos = timeline.data.pos and parseAnimationTrack(timeline.data.pos)
			end
			
			animationIdentities[id] = animationIdentities[id] or {}
			animationIdentities[id][model] = timeline
		end
	end
	
	if entry.chld then
		for index, child in ipairs(entry.chld) do
			local name = child.name
			parseNBTModelData(child,model[name])
		end
	end
end

parseNBTModelData(nbt.models,models)


--[────────────────────────────────────────-< Extra APIs >-────────────────────────────────────────]--


---@class ModelPart
local ModelPart = {}
ModelPart.__index = ModelPart


local function playAnimation(self,id)
	local timeline = animationIdentities[id][self]
	if timeline then
		print(timeline.data)
	end
	for _, child in ipairs(self:getChildren()) do
		playAnimation(child,id)
	end
end


function ModelPart:play(animation)
	local id = animationIdentityLookup[animation]
	playAnimation(self,id)
end


local ogIndex = figuraMetatables.ModelPart.__index
figuraMetatables.ModelPart.__index = function (self, key)
	return ogIndex(self,key) or ModelPart[key]
end


--[────────────────────────────────────────-< Playground >-────────────────────────────────────────]--


models.testion:play("testion.spin")


