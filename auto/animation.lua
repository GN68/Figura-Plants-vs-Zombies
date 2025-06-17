local nbt = avatar:getNBT()

local modelData = nbt.models

---@class AvatarNBT.Vector3
---@field [0] number
---@field [1] number
---@field [2] number

---@class AvatarNBT.Model
---@field child AvatarNBT.Model[]
---@field name string
---@field anim AvatarNBT.AnimationData?
---@field piv AvatarNBT.Vector3


---@class AvatarNBT.AnimationData
---@field data {scl:AvatarNBT.AnimationTrack, rot:AvatarNBT.AnimationTrack, pos:AvatarNBT.AnimationTrack}


---@class AvatarNBT.AnimationTrack
---@field [number] AvatarNBT.Keyframe

---@class AvatarNBT.Keyframe
---@field pre AvatarNBT.Vector3
---@field time number
---@field int "linear"|

--[[


models.path:play("dance")





]]


local AnimationPlayer = {}
AnimationPlayer.__index = AnimationPlayer