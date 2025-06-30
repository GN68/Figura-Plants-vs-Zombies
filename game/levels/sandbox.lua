local z="z.zombie"

---@type Level
local level={
	suns=99999,
	sunTimer=10000000,
	--inventory={"p.sunflower","p.peashooter","p.cherrybomb","p.chomper","p.potatomine","p.wallnut","p.snowpea","p.repeater","z.zombie","z.conehead"},
	inventory={"p.sunflower","p.cherrybomb","p.chomper","p.snowpea","p.repeater","p.wallnut","z.zombie","z.bucket","z.pole"},
	skip=true,
	prize="p.sunflower",
	waves={
		{c={[0]={z}}},
	},
	fun=function (s,lvl)
		s.spawnTimer=99999999
	end
}

return level