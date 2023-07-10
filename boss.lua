local spawnPos = {0,0,0}

local function bossMove(i)
	enemies.list[i].velocity[1] = (player.pos.x - enemies.list[i].pos.x) * enemies.list[i].speed
	enemies.list[i].velocity[3] = (player.pos.z - enemies.list[i].pos.z) * enemies.list[i].speed
	enemies.list[i].pos.x = enemies.list[i].pos.x + enemies.list[i].velocity[1] * enemies.list[i].speed * g.dt
	enemies.list[i].pos.z = enemies.list[i].pos.z + enemies.list[i].velocity[3] * enemies.list[i].speed * g.dt
end

local circleCount = 0
local circleScale = {1, 1, 1}
local circleRot = {0, 0, 0}
local circleMod = 0.05

local function bossCircle(i)
	-- circleScale[3] = 1 + math.cos(circleCount) / 8
	-- circleScale[2] = 1 + math.sin(circleCount) / 8
	-- enemies.list[i].circle:setTransform(nil, circleRot, circleScale)
	-- circleCount = circleCount + g.dt
	-- if circleCount >= 1024 then circleCount = 0 end
end


-- mike

local function mikeOne(i)
	if enemies.list[i].clock % 5 == 0 and enemies.list[i].clock % 120 < 60 then
		if enemies.list[i].clock % 60 == 0 then
			enemies.list[i].nums[1] = math.random(0, math.pi)
		end
		if enemies.list[i].clock % 30 == 0 then
			enemies.list[i].nums[2] = 0.25
			enemies.list[i].nums[3] = enemies.list[i].clock % 240 < 120 and 1 or -1
		end
		local count, angle, image = 24, enemies.list[i].nums[1], 'red'
		if enemies.list[i].clock % 60 >= 15 then image = 'blue' end
		if enemies.list[i].clock % 60 >= 30 then image = 'green' end
		if enemies.list[i].clock % 60 >= 45 then image = 'yellow' end
		for j = 1, count do
			bullets:spawn({
				image = image,
				position = {
					enemies.list[i].pos.x,
					enemies.list[i].pos.y,
					enemies.list[i].pos.z
				},
				target = {
					enemies.list[i].pos.x + math.cos(angle),
					enemies.list[i].pos.y + enemies.list[i].nums[2],
					enemies.list[i].pos.z + math.sin(angle)
				},
				speed = enemies.list[i].clock % 60 < 30 and 15 or 10
			})
			angle = angle + g.tau / count
		end
		enemies.list[i].nums[1] = enemies.list[i].nums[1] + g.phi / count * enemies.list[i].nums[3]
		enemies.list[i].nums[2] = enemies.list[i].nums[2] - 0.15
	end
end

local function mikeTwo(i)

	local image = 'red'
	if enemies.list[i].clock % 60 >= 15 then image = 'blue' end
	if enemies.list[i].clock % 60 >= 30 then image = 'green' end
	if enemies.list[i].clock % 60 >= 45 then image = 'yellow' end
	if enemies.list[i].clock % 240 == 0 then enemies.list[i].nums[1] = math.random(0, g.tau) end
	for j = 1, 2 do
		bullets:spawn({
			image = image,
			position = {
				enemies.list[i].pos.x,
				enemies.list[i].pos.y,
				enemies.list[i].pos.z
			},
			target = {
				enemies.list[i].pos.x + math.cos(enemies.list[i].nums[1] * j),
				enemies.list[i].pos.y + 0.3 - math.random(),
				enemies.list[i].pos.z + math.sin(enemies.list[i].nums[1] * j)
			},
			speed = j % 2 == 0 and 10 or 15
		})
	end
	enemies.list[i].nums[1] = enemies.list[i].nums[1] + math.random(0, math.pi)

	if enemies.list[i].clock % 15 == 10 then
		local distance = 45 - cpml.vec3.dist(enemies.list[i].pos, player.pos)
		distance = distance / 20
		bullets:spawn({
			image = image,
			position = {
				enemies.list[i].pos.x,
				enemies.list[i].pos.y,
				enemies.list[i].pos.z
			},
			target = {
				player.pos.x,
				player.pos.y,
				player.pos.z
			},
			speed = distance
		})
	end

end

local function mikeThree(i)

end

return {

	mike = function()

		if stage.clock == 0 then
			g.bossHealth = 100
			g.bossMax = g.bossHealth
			enemies:spawn({
				position = {0, -1, 0},
				size = 3,
				boss = true,
				speed = 0.5,
				image = 'mike',
				health = g.bossHealth,
				updater = function(i)
					g.bossHealth = enemies.list[i].health
					bossMove(i)
					-- bossCircle(i)
					-- mikeTwo(i)
					-- mikeThree(i)
					if enemies.list[i].health > 75 then mikeOne(i)
					elseif enemies.list[i].health > 50 then mikeTwo(i)
					elseif enemies.list[i].health > 25 then mikeOne(i)
					else mikeTwo(i) end
				end
			})
		end

	end

}