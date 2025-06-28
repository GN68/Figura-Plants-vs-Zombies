---@diagnostic disable: assign-type-mismatch
--[[______  __ 
  / ____/ | / /  by: GNanimates | Discord: @GN68s | Youtube: @GNamimates
 / / __/  |/ / name: Tween Library v2
/ /_/ / /|  /  desc: a library that makes it easier to create tweens
\____/_/ |_/ Source: https://github.com/lua-gods/GNs-Avatar-3/blob/main/libraries/tween.lua

NOTE: Figura trims off all comments automatically by default. 
so all of this comment will be stripped out before being processed by Figura.
]] --[[

 MIT LICENSE

	Copyright (c) 2014 Enrique García Cota, Yuichi Tateno, Emmanuel Oga
	https://github.com/kikito/tween.lua/blob/master/tween.lua
	
	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

-- easing

-- Adapted from https://github.com/EmmanuelOga/easing. See LICENSE.txt for credits.
-- Heavily modified to be normalized

local pow, sin, cos, pi, sqrt, asin=math.pow, math.sin, math.cos, math.pi, math.sqrt, math.asin

-- Linear
local function linear(t)
	return t
end
--[ [
-- Quad
local function inQuad(t)
	return t^2
end

local function outQuad(t)
	return -t*(t-2)
end

local function inOutQuad(t)
	t=t*2
	if t < 1 then return 0.5*t^2 end
	t=t-1
	return -0.5*(t*(t-2)-1)
end

---@alias EaseTypes string
---| "linear"
---
---| "inQuad"
---| "outQuad"
---| "inOutQuad"
---| "outInQuad"
---
---| "inCubic"
---| "outCubic"
---| "inOutCubic"
---| "outInCubic"
---
---| "inQuart"
---| "outQuart"
---| "inOutQuart"
---| "outInQuart"
---
---| "inQuint"
---| "outQuint"
---| "inOutQuint"
---| "outInQuint"
---
---| "inSine"
---| "outSine"
---| "inOutSine"
---| "outInSine"
---
---| "inExpo"
---| "outExpo"
---| "inOutExpo"
---| "outInExpo"
---
---| "inCirc"
---| "outCirc"
---| "inOutCirc"
---| "outInCirc"
---
---| "inElastic"
---| "outElastic"
---| "inOutElastic"
---| "outInElastic"
---
---| "inBack"
---| "outBack"
---| "inOutBack"
---| "outInBack"
---
---| "inBounce"
---| "outBounce"
---| "inOutBounce"
---| "outInBounce"


---@class Tween
local Tween={
	easings={
  linear   =linear,
  inQuad   =inQuad,    outQuad   =outQuad,    inOutQuad   =inOutQuad}
}

local queries={}
local sysTime

local tweenProcessor=models:newPart("TweenProcessor","WORLD") -- set to "WORLD" so it always runs when the player is loaded

local isActive=false
local setActive ---@type function

local function process()
	sysTime=client:getSystemTime() / 1000
	for id, tween in pairs(queries) do
		local duration=(sysTime-tween.start) / tween.duration
		if duration < 1 then
			local w=tween.easing(duration)
			tween.tick(math.lerp(tween.from,tween.to, w), duration)
		else
			tween.tick(tween.to, 1)
			tween.onFinish()
			setActive(next(queries) and true or false)
			queries[id]=nil
		end
	end
end


setActive=function (toggle)
	if isActive ~= toggle then
		tweenProcessor.midRender=toggle and process or nil
		isActive=toggle
	end
end


---@class TweenInstanceCreation
---@field id any?
---
---@field from number|Vector.any
---@field to number|Vector.any
---
---@field duration number
---@field period number?
---@field overshoot number?
---@field amplitude number?
---
---@field easing EaseTypes|(fun(t: number): number|Vector.any)
---
---@field tick fun(v : number|Vector.any,t : number)
---@field onFinish function?


---An instance of a tween query
---@class TweenInstance
---@field id any
---
---@field from number|Vector.any
---@field to number|Vector.any
---
---@field duration number
---@field package start number?
---@field period number?
---@field overshoot number?
---@field amplitude number?
---
---@field easing fun(t: number): number|Vector.any
---
---@field tick fun(v : number|Vector.any,t : number)
---@field onFinish function?
local TweenInstance={}
TweenInstance.__index=TweenInstance

local function placeholder() end


---Creates a new Tween instance
---***
---FIELDS:  
--- | Field       | Default    | Description                                                                                                                                     |
--- | ----------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
--- | `id`        | `?`        | The unique ID of the tween                                                                                                                      |
--- | `from`      | `0`        | The starting value of the tween                                                                                                                 |
--- | `to`        | `1`        | The ending value of the tween                                                                                                                   |
--- | `amplitude` | `1`        | The height of the oscillation (springiness). **only used for the elastic easings**                                                              |
--- | `period`    | `1`        | The frequency of the oscillation (how fast it bounces). **only used for the elastic easings**                                                   |
--- | `overshoot` | `1.7`      | controls how much the back easing will "go past" the starting position before moving toward the final value. **only used for the back easings** |
--- | `duration`  | `1`        | how long the tween will take in seconds                                                                                                         |
--- | `easing`    | `ar`       | The name of theeasing function to use                                                                                                           |
--- | `tick`      | `?`        | a callback function that gets called everytime the tween ticks                                                                                  |
--- | `onFinish`  | `?`        | a callback function that gets called when the tween finishes                                                                                    |
---@param cfg TweenInstanceCreation
---@return TweenInstance
function Tween.new(cfg)
	local id=cfg.id or #queries+1
	---@type TweenInstance
	
	local new={
		start=isActive and sysTime or (client:getSystemTime()/1000),
		from=cfg.from or 0,
		to=cfg.to or 1,
		period=cfg.period or 1,
		overshoot=cfg.overshoot or 5,
		duration=cfg.duration or 1,
		easing=Tween.easings[cfg.easing] or (type(cfg.easing) == "function" and cfg.easing) or linear,
		tick=cfg.tick or placeholder,
		onFinish=cfg.onFinish or placeholder,
		id=cfg.id
	}
	setmetatable(new, {__index=Tween})
	new.tick(new.from, 0)
	queries[id]=new
	
	setActive(true)
	return new
end

---Stops this TweenInstance
function TweenInstance:stop()
	Tween.stop(self.id,true)
end

---Skips the given TweenInsatnce to finish instantly
function TweenInstance:skip()
	Tween.stop(self.id)
end


---Stops the tween with the given ID. if `cancel` is true, it NOT will call the `onFinish` function
---@param id any
---@param cancel boolean?
function Tween.stop(id, cancel)
	if not cancel and queries[id] then
		queries[id].onFinish()
	end
	queries[id]=nil
end

return Tween
