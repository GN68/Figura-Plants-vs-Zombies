local object = require "game.object"
local identity = require "game.identity"
local z="z.zombie"

---@type Level
local level={
	suns=999,
	skip=true,
	sunTimer=5,
	grass=1,
	next="lvl2",
	inventory = {"p.sunflower","p.peashooter","p.cherrybomb","z.zombie"},
	grid_range=vec(0,2,9,3),
	prize="p.sunflower",
	waves={
		{c={[1]={z}}},
	},
	fun=function (s,lvl)
		s.spawnTimer = 0
	end
}

return level