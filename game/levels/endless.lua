
local z="z.zombie"
local c="z.conehead"
local b="z.bucket"
local p="z.pole"

---@type Level
local level={
	suns=999999,
	skip=true,
	inventory={"p.sunflower","p.peashooter","p.cherrybomb","p.wallnut","p.potatomine","p.snowpea","p.chomper","p.repeater"},
	prize="p.sunflower",
	waves={
		{c={[1]={z}}},
	},
	fun=function (s,lvl)
		s.spawnTimer=0
	end
}

local function siksik(array,count,type) --  to squeeze in between people
	if count > 0 then
		array[count]=array[count] or {}
		array[count][#array[count]+1]=type
	end
end

---@param zombie integer
---@param cone integer
---@param bucket integer
---@param pole integer
---@return table
local function mkContent(zombie,cone,bucket,pole)
	local content={}
	siksik(content,zombie,z)
	siksik(content,cone,c)
	siksik(content,bucket,b)
	siksik(content,pole,p)
	return content
end

local c=0
local difficulty=6
for w=1, 50, 1 do
	for r=1, 7, 1 do
		difficulty=difficulty+0.2
		c=c+1
		local diff=math.lerp(difficulty*0.75, difficulty, r)
		local wave={c=mkContent(
		math.floor(diff*0.3), -- zombie weights
		math.floor(diff*0.3*0.2), -- cone weights
		math.floor(diff*0.3*0.15), -- bucket weights
		math.floor(diff*0.3*0.1)  -- pole weights
	)}
	level.waves[c]=wave
		if r == 7 then
			wave.major=true
		end
	end
end


return level