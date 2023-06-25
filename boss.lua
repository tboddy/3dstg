local spawnPos = {0,0,0}

function table.shallow(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

return {

	oneSpawn = function()
		g.bossHealth = 50
		g.bossMax = g.bossHealth
		enemies:spawn({
			position = {0, -2, 0},
			size = 4,
			boss = true,
			image = 'mike',
			health = g.bossHealth,
			updater = function(i)
				g.bossHealth = enemies.list[i].health
				if enemies.list[i].clock % 2 == 0 then
					if enemies.list[i].clock == 0 then
						table.insert(enemies.list[i].nums, 0)
						table.insert(enemies.list[i].nums, 10)
						table.insert(enemies.list[i].nums, 0)
						table.insert(enemies.list[i].nums, 0)
					end
					if enemies.list[i].clock % 60 == 0 then enemies.list[i].nums[3] = 0 end
					spawnPos = table.shallow(enemies.list[i].position)
					for j = 1, 8 do
						bullets:spawn({
							size = 0.5,
							position = spawnPos,
							image = j % 2 == 0 and 'blue' or 'green',
							target = {
								spawnPos[1] + math.cos(enemies.list[i].nums[(j % 2 == 0 and 1 or 4)] + (g.tau / 8) * j) * enemies.list[i].nums[2],
								spawnPos[2] + enemies.list[i].nums[3] + 1,
								spawnPos[3] + math.sin(enemies.list[i].nums[(j % 2 == 0 and 1 or 4)] + (g.tau / 8) * j) * enemies.list[i].nums[2]
							},
							speed = j % 2 == 0 and 2 or 1
						})
					end

					enemies.list[i].nums[1] = enemies.list[i].nums[1] + 0.1
					enemies.list[i].nums[4] = enemies.list[i].nums[4] - 0.15
					enemies.list[i].nums[3] = enemies.list[i].nums[3] - 0.15
				end
			end
		})
	end

}