local spawnPos = {0, 0, 0}

local function spawnGrunt(pos, dir, shoots)
	enemies:spawn({
		position = {pos[1], pos[2], pos[3]},
		image = 'fairyblue-1',
		health = 1,
		speed = 15,
		updater = function(i)

			-- shoot
			if enemies.list[i].nums[3] and enemies.list[i].clock == 60 * 3 then

				bullets:spawn({
					image = 'red',
					position = {
						enemies.list[i].position[1],
						enemies.list[i].position[2],
						enemies.list[i].position[3]
					},
					target = {
						enemies.list[i].position[1] + math.random(0, g.tau),
						enemies.list[i].position[2],
						enemies.list[i].position[3] + math.random(0, g.tau)
					},
					speed = 2
				})

			end

			-- move
			if enemies.list[i].clock == 0 then
				enemies.list[i].nums[1] = dir
				enemies.list[i].nums[2] = math.pi / 128
				enemies.list[i].velocity[1] = math.cos(enemies.list[i].nums[1])
				enemies.list[i].velocity[3] = math.sin(enemies.list[i].nums[1])
				enemies.list[i].nums[3] = shoots or nil
			end

			if enemies.list[i].clock >= 60 * 7 and enemies.list[i].clock % 2 == 0 and enemies.list[i].clock < 60 * 10 then
				enemies.list[i].nums[1] = enemies.list[i].nums[1] - enemies.list[i].nums[2]
				enemies.list[i].velocity[1] = math.cos(enemies.list[i].nums[1])
				enemies.list[i].velocity[2] = math.cos(enemies.list[i].nums[1]) / 3
				enemies.list[i].velocity[3] = math.sin(enemies.list[i].nums[1])
			end

			enemies.list[i].position[1] = enemies.list[i].position[1] + enemies.list[i].velocity[1] * enemies.list[i].speed * g.dt
			enemies.list[i].position[2] = enemies.list[i].position[2] + enemies.list[i].velocity[2] * enemies.list[i].speed * g.dt
			enemies.list[i].position[3] = enemies.list[i].position[3] + enemies.list[i].velocity[3] * enemies.list[i].speed * g.dt

			if enemies.list[i].clock > 600 then
				enemies:killEnemy(i)
			end

		end})
end


return {
	waveOne = function()

		if stage.clock >= 60 * 0 and stage.clock < 60 * 4 then
			if stage.clock % 45 == 0 then spawnGrunt({50, -2, 0}, math.pi, stage.clock % 90 == 45) end
		end

		if stage.clock >= 60 * 3 and stage.clock < 60 * (4 + 3) then
			if stage.clock % 45 == 0 then spawnGrunt({-50, -10, 0}, 0, stage.clock % 90 == 45) end
		end

		if stage.clock >= 60 * (3 + 3) and stage.clock < 60 * (4 + 3 + 3) then
			if stage.clock % 45 == 0 then spawnGrunt({0, -2, 50}, -math.pi / 2, stage.clock % 90 == 45) end
		end

		if stage.clock >= 60 * (3 + 3 + 3) and stage.clock < 60 * (4 + 3 + 3 + 3) then
			if stage.clock % 45 == 0 then spawnGrunt({0, -10, -50}, math.pi / 2, stage.clock % 90 == 45) end
		end

	end
}