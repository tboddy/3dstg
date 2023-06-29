local spawnPos = {0,0,0}

local function bossMove(i)
	enemies.list[i].velocity[1] = (player.position[1] - enemies.list[i].position[1]) * enemies.list[i].speed
	enemies.list[i].velocity[3] = (player.position[3] - enemies.list[i].position[3]) * enemies.list[i].speed
	enemies.list[i].position[1] = enemies.list[i].position[1] + enemies.list[i].velocity[1] * enemies.list[i].speed * g.dt
	enemies.list[i].position[3] = enemies.list[i].position[3] + enemies.list[i].velocity[3] * enemies.list[i].speed * g.dt
	-- enemies.list[i].position[1] = enemies.list[i].position[1] + g.dt
end

local function bossOnePatternOne(i)
	if enemies.list[i].clock % 2 == 0 then
		if enemies.list[i].clock == 0 then
			table.insert(enemies.list[i].nums, 0)
			table.insert(enemies.list[i].nums, 10)
			table.insert(enemies.list[i].nums, 0)
			table.insert(enemies.list[i].nums, 0)
		end
		if enemies.list[i].clock % 60 == 0 then enemies.list[i].nums[3] = 2 end
		for j = 1, 8 do
			bullets:spawn({
				size = 0.5,
				image = j % 2 == 0 and 'blue' or 'green',
				position = {
					enemies.list[i].position[1],
					enemies.list[i].position[2],
					enemies.list[i].position[3]
				},
				target = {
					enemies.list[i].position[1] + math.cos(enemies.list[i].nums[(j % 2 == 0 and 1 or 4)] + (g.tau / 8) * j) * enemies.list[i].nums[2],
					enemies.list[i].position[2] + enemies.list[i].nums[3],
					enemies.list[i].position[3] + math.sin(enemies.list[i].nums[(j % 2 == 0 and 1 or 4)] + (g.tau / 8) * j) * enemies.list[i].nums[2]
				},
				speed = j % 2 == 0 and 2 or 1
			})
		end
		enemies.list[i].nums[1] = enemies.list[i].nums[1] + 0.1
		enemies.list[i].nums[4] = enemies.list[i].nums[4] - 0.15
		enemies.list[i].nums[3] = enemies.list[i].nums[3] - 0.2
	end
end

return {

	oneSpawn = function()
		g.bossHealth = 50
		g.bossMax = g.bossHealth
		enemies:spawn({
			position = {5, -2, 0},
			size = 2,
			boss = true,
			speed = 0.5,
			image = 'mike',
			health = g.bossHealth,
			updater = function(i)
				g.bossHealth = enemies.list[i].health
				bossMove(i)
				bossOnePatternOne(i)
			end
		})
	end

}