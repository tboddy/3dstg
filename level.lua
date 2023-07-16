local animateEnemyInterval = 6
local animateEnemyLimit = animateEnemyInterval * 4

local enemyImages, enemyTypes, enemyColors = {}, {'fairy', 'yinyang'}, {'blue', 'red', 'green', 'yellow'} -- big

local function animateFairy(i)
	if enemies.list[i].clock % animateEnemyLimit == 0 then
		enemies.list[i].model.mesh:setTexture(enemyImages[enemies.list[i].type][enemies.list[i].image][1])
	elseif enemies.list[i].clock % animateEnemyLimit == animateEnemyInterval then
		enemies.list[i].model.mesh:setTexture(enemyImages[enemies.list[i].type][enemies.list[i].image][2])
	elseif enemies.list[i].clock % animateEnemyLimit == (animateEnemyInterval * 2) then
		enemies.list[i].model.mesh:setTexture(enemyImages[enemies.list[i].type][enemies.list[i].image][1])
	elseif enemies.list[i].clock % animateEnemyLimit == (animateEnemyInterval * 3) then
		enemies.list[i].model.mesh:setTexture(enemyImages[enemies.list[i].type][enemies.list[i].image][3])
	end
end

local gruntSpawn = 40

local function spawnGrunt(angle, shoots)
	enemies:spawn({
		position = {math.cos(angle) * gruntSpawn, -1 - math.random(0, 10), math.sin(angle) * gruntSpawn},
		size = 3,
		type = 'fairy',
		image = 'blue',
		health = 2,
		speed = 0.4,
		loader = function(i)
			enemies.list[i].nums[1] = math.random(0, 240)
		end,
		updater = function(i)
			if enemies.list[i].type == 'fairy' then animateFairy(i) end
			if enemies.list[i].clock % 30 < 20 then
				if enemies.list[i].clock % 30 == 0 then
					enemies.list[i].velocity[1] = (player.pos.x - 16 + math.random() * 32) - enemies.list[i].pos.x
					enemies.list[i].velocity[3] = (player.pos.z - 16 + math.random() * 32) - enemies.list[i].pos.z
				end
				enemies.list[i].pos.x = enemies.list[i].pos.x + enemies.list[i].velocity[1] * enemies.list[i].speed * g.dt
				enemies.list[i].pos.z = enemies.list[i].pos.z + enemies.list[i].velocity[3] * enemies.list[i].speed * g.dt
			end
			if enemies.list[i].clock > 0 and enemies.list[i].clock % 240 == enemies.list[i].nums[1] then
				bullets:spawn({
					image = 'red',
					position = {
						enemies.list[i].pos.x, enemies.list[i].pos.y, enemies.list[i].pos.z
					},
					target = {
						player.pos.x,
						player.pos.y,
						player.pos.z
					},
					speed = (50 - cpml.vec3.dist(enemies.list[i].pos, player.pos)) * .02
				})
			end
		end
	})
end

local function animateYinyang(i)
	if enemies.list[i].health <= 4 and not enemies.list[i].nums[2] then
		enemies.list[i].nums[2] = true
		enemies.list[i].model.mesh:setTexture(enemyImages.yinyang.yellow[1])
	elseif enemies.list[i].health <= 2 and not enemies.list[i].nums[3] then
		enemies.list[i].nums[3] = true
		enemies.list[i].model.mesh:setTexture(enemyImages.yinyang.red[1])
	end
end

local electrodeSpawn

local function spawnElectrode(angle)
	electrodeSpawn = math.random(20, 30)
	enemies:spawn({
		position = {math.cos(angle) * electrodeSpawn, -1, math.sin(angle) * electrodeSpawn},
		size = 3,
		type = 'yinyang',
		image = 'green',
		health = 6,
		speed = 0.4,
		loader = function(i)
			enemies.list[i].nums[5] = 0
			enemies.list[i].nums[6] = 0.3
			enemies.list[i].nums[7] = g.phi / 4
			enemies.list[i].nums[8] = math.random(0, 60)
		end,
		updater = function(i)
			animateYinyang(i)
			if enemies.list[i].clock % 120 < 60 then
				enemies.list[i].pos.y = enemies.list[i].pos.y - 0.75 * g.dt
			else
				enemies.list[i].pos.y = enemies.list[i].pos.y + 0.75 * g.dt
			end
			if enemies.list[i].clock % 60 == enemies.list[i].nums[8] then
				local angle = 0
				for j = 1, 4 do
					bullets:spawn({
						image = 'blue',
						position = {
							enemies.list[i].pos.x, enemies.list[i].pos.y, enemies.list[i].pos.z
						},
						target = {
							enemies.list[i].pos.x + math.cos(angle + enemies.list[i].nums[5]),
							enemies.list[i].pos.y + enemies.list[i].nums[6],
							enemies.list[i].pos.z + math.sin(angle + enemies.list[i].nums[5])
						},
						speed = 12
					})
					angle = angle + g.tau / 4
					enemies.list[i].nums[6] = enemies.list[i].nums[6] - 0.15
					if enemies.list[i].nums[6] < -0.5 then enemies.list[i].nums[6] = 0.3 end
				end
				enemies.list[i].nums[5] = enemies.list[i].nums[5] + enemies.list[i].nums[7]
			end
		end
	})
end

local gemCenter, gemLimit = cpml.vec2.new(0, 0), 35
local gemColor

local function spawnGem(color)
	local angle = math.random(0, g.tau)
	local offset = math.random(20, 30)
	g.gemCount = g.gemCount + 1
	enemies:spawn({
		position = {math.cos(angle) * offset, 0, math.sin(angle) * offset},
		size = 2,
		gem = true,
		health = 99,
		image = gemColor,
		loader = function(i)
			local angle = math.random(0, g.tau)
			local speed = 5
			enemies.list[i].velocity[1] = math.cos(angle) * speed
			enemies.list[i].velocity[3] = math.sin(angle) * speed
			enemies.list[i].nums[1] = 0
		end,
		updater = function(i)
			if enemies.list[i].clock % 5 == 0 then
				if cpml.vec2.dist(cpml.vec2.new(enemies.list[i].pos.x, enemies.list[i].pos.z), gemCenter) > gemLimit then
					enemies.list[i].velocity[1] = enemies.list[i].velocity[1] * -1
					enemies.list[i].velocity[3] = enemies.list[i].velocity[3] * -1
				end
			end
			enemies.list[i].pos.x = enemies.list[i].pos.x + enemies.list[i].velocity[1] * g.dt
			enemies.list[i].pos.z = enemies.list[i].pos.z + enemies.list[i].velocity[3] * g.dt
			if enemies.list[i].clock % 60 < 30 then
				enemies.list[i].pos.y = enemies.list[i].pos.y - 0.02
			else
				enemies.list[i].pos.y = enemies.list[i].pos.y + 0.02
			end
			enemies.list[i].nums[1] = enemies.list[i].nums[1] + 0.075
			if enemies.list[i].nums[1] >= g.tau then enemies.list[i].nums[1] = enemies.list[i].nums[1] - g.tau end
		end
	})
end

return {

	load = function()
		for i = 1, #enemyTypes do
			enemyImages[enemyTypes[i]] = {}
			for h = 1, #enemyColors do
				local images = {}
				if enemyTypes[i] == 'fairy' then
					for j = 1, 3 do
						table.insert(images, love.graphics.newImage('res/enemies/' .. enemyTypes[i] .. enemyColors[h] .. '-' .. j .. '.png'))
					end
				else
					table.insert(images, love.graphics.newImage('res/enemies/' .. enemyTypes[i] .. enemyColors[h] .. '.png'))
				end
				enemyImages[enemyTypes[i]][enemyColors[h]] = images
			end
		end
	end,

	waves = {

		-- 15 grunts, 5 electrodes, 1 mommy, 1 daddy
		function()

			-- family
			if stage.clock == 0 then
				g.gemCount = 0
				stage.spawnAngle1 = 0
				stage.spawnAngle2 = 0
				gemColor = 'red'
				for i = 1, 2 do 
					spawnGem()
					gemColor = 'blue'
				end
			end

			-- grunts
			if stage.clock < (15 * 5) then
				if stage.clock % 5 == 0 then
					spawnGrunt(stage.spawnAngle2, stage.clock % 30 == 0)
					stage.spawnAngle2 = stage.spawnAngle2 + g.tau / 15
				end
			end

			-- electrodes
			if stage.clock < (5 * 5) then
				if stage.clock % 5 == 0 then
					spawnElectrode(stage.spawnAngle1)
					stage.spawnAngle1 = stage.spawnAngle1 + g.tau / 5
				end
			end

		end,

		-- 17 grunts, 15 electrodes, 1 mommy, 1 daddy, 1 mikey, 5 hulks, 1 spheroid
		function()

			-- family
			if stage.clock == 0 then
				g.gemCount = 0
				stage.spawnAngle1 = 0
				stage.spawnAngle2 = 0
				gemColor = 'red'
				for i = 1, 3 do 
					spawnGem()
					gemColor = i == 1 and 'blue' or 'green'
				end
			end

			-- grunts
			if stage.clock < (17 * 5) then
				if stage.clock % 5 == 0 then
					spawnGrunt(stage.spawnAngle2, stage.clock % 30 == 0)
					stage.spawnAngle2 = stage.spawnAngle2 + g.tau / 17
				end
			end

			-- electrodes
			if stage.clock < (15 * 5) then
				if stage.clock % 5 == 0 then
					spawnElectrode(stage.spawnAngle1)
					stage.spawnAngle1 = stage.spawnAngle1 + g.tau / 15
				end
			end

		end

	}

}