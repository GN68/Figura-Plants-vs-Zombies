local z="z.zombie"

---@type Level
local level={
	suns=99999,
	sunTimer=10000000,
	--inventory = {"p.sunflower","p.peashooter","p.cherrybomb","p.chomper","p.potatomine","p.wallnut","p.snowpea","p.repeater","z.zombie","z.conehead"},
	inventory = {"p.peashooter","p.cherrybomb","p.chomper","p.snowpea","p.repeater","p.wallnut","z.zombie","z.conehead","z.pole"},
	skip = true,
	prize="sunflower",
	waves={
		{c={[1]={z}}},
		{major=true,c={[1]={z}}},
	},
	fun=function (s,lvl)
		s.spawnTimer = 200
	end
}

return level