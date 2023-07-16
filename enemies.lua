local circleSize, killClock = 10, 0

return {

	count = 32,
	current = 0,
	list = {},
	killAll = true,

	spawn = function(self, spawner)
		i = -1
		for j = 1, self.count do if i == -1 and not self.list[j].active then i = j break end end
		if i > -1 then
			self.list[i].active = true
			self.list[i].pos = cpml.vec3.new(spawner.position[1], spawner.position[2], spawner.position[3])
			self.list[i].velocity[1] = 0
			self.list[i].velocity[2] = 0
			self.list[i].velocity[3] = 0
			self.list[i].speed = spawner.speed
			self.list[i].clock = 0
			self.list[i].hit = false
			self.list[i].boss = spawner.boss or false
			self.list[i].nums = {}
			self.list[i].health = spawner.health and spawner.health or 1
			self.list[i].size = spawner.size
			self.list[i].dist = spawner.gem and spawner.size * 1.25 or spawner.size / 2
			self.list[i].image = spawner.image
			self.list[i].type = spawner.type
			if spawner.gem then
				self.list[i].gem = true
				self.list[i].model = g3d.newModel('res/gems/gem.obj', 'res/gems/gem-' .. spawner.image ..'.png',
					{spawner.position[1], spawner.position[2], spawner.position[3]},
					nil, {spawner.size * 1.25, -spawner.size, spawner.size * 1.25})
			else
				local enemyImage = love.graphics.newImage('res/enemies/' .. spawner.type .. spawner.image .. (spawner.type == 'fairy' and '-1' or '') .. '.png')
				self.list[i].model = g3d.newModel({
			    {-1,0,-1},
			    {1, 0,-1},
			    {-1,0, 1},
			    {1, 0, 1},
			    {1, 0,-1},
			    {-1,0, 1}}, enemyImage)
			end
			self.list[i].model:compress()
			if spawner.boss then
				local circleImage = love.graphics.newImage('res/enemies/circle.png')
				self.list[i].circle = g3d.newModel({
			    {-1,0,-1},
			    {1, 0,-1},
			    {-1,0, 1},
			    {1, 0, 1},
			    {1, 0,-1},
			    {-1,0, 1}}, circleImage)
				self.list[i].circle:compress()
			end
			self.list[i].loader = spawner.loader or nil
			self.list[i].updater = spawner.updater or nil
		end
	end,

	load = function(self)
		for i = 1, self.count do
			table.insert(self.list, {
				active = false,
				velocity = {0, 0, 0},
				clock = 0,
				model = nil,
				circle = nil,
				updater = nil,
				hit = false,
				boss = false,
				health = 0
			})
		end
	end,

	killEnemy = function(self, i)
		if self.list[i].boss then
			g.bossHealth = 0
			bullets.killAll = true
			self.list[i].circle = nil
		end
		self.list[i].active = false
		self.list[i].model = nil
	end,

	hitEnemy = function(self, i)
		self.list[i].hit = false
		self.list[i].health = self.list[i].health - 1
		if self.list[i].health <= 0 then self:killEnemy(i) end
	end,

	getGem = function(self, i)
		print('get gem')
		self:killEnemy(i)
		g.gemCount = g.gemCount - 1
		chrome.gemMessageClock = chrome.messageTime
		if g.gemCount <= 0 then
			-- zone over
			stage.currentWave = stage.currentWave + 1
			bullets.killAll = true
			self.killAll = true
		end
	end,

	rotation = 0,

	update = function(self)
		self.current = 0
		for i = 1, self.count do
			if self.list[i].active then
				self.current = self.current + 1
				if self.list[i].loader and self.list[i].clock == 0 then self.list[i].loader(i) end
				if self.list[i].updater then self.list[i].updater(i) end

				if cpml.vec3.dist(self.list[i].pos, player.pos) < self.list[i].dist then
					if self.list[i].gem then
						self:getGem(i)
					else
						player.health = player.health - 10
						bullets.killAll = true
					end
				end

				if self.list[i].active then
					self.list[i].clock = self.list[i].clock + 1
					if self.list[i].clock >= g.clockLimit then self.list[i].clock = 60 end
					if self.list[i].hit then self:hitEnemy(i)
					elseif self.killAll then
						self:killEnemy(i)
					end
				end
			end
		end
		if self.killAll then self.killAll = false end
	end,

	draw = function(self)
		for i = 1, self.count do
			if self.list[i].active then
				if self.list[i].gem then
					self.list[i].model:setTranslation(self.list[i].pos.x, self.list[i].pos.y, self.list[i].pos.z)
					self.list[i].model:setRotation(0, self.list[i].nums[1], 0)
			    self.list[i].model:draw(g.fogShader)
				else
			    local x_1, x_2, x_3 = g3d.camera.viewMatrix[1], g3d.camera.viewMatrix[2], g3d.camera.viewMatrix[3]
			    local y_1, y_2, y_3 = g3d.camera.viewMatrix[5], g3d.camera.viewMatrix[6], g3d.camera.viewMatrix[7]
			    local x1,y1,z1 = self.list[i].pos.x, self.list[i].pos.y, self.list[i].pos.z

			    local x2,y2,z2 = self.list[i].pos.x - y_1 * self.list[i].size, self.list[i].pos.y - y_2 * self.list[i].size, self.list[i].pos.z - y_3 * self.list[i].size
			    local r = 0.5 * self.list[i].size
			    n_x, n_y, n_z = x_1*r, x_2*r, x_3*r

			    self.list[i].model.mesh:setVertex(1, x1-n_x, y1-n_y - self.list[i].size / 2, z1-n_z, 0,0)
			    self.list[i].model.mesh:setVertex(2, x1+n_x, y1+n_y - self.list[i].size / 2, z1+n_z, 1,0)
			    self.list[i].model.mesh:setVertex(3, x2-n_x, y2-n_y - self.list[i].size / 2, z2-n_z, 0,1)
			    self.list[i].model.mesh:setVertex(4, x2-n_x, y2-n_y - self.list[i].size / 2, z2-n_z, 0,1)
			    self.list[i].model.mesh:setVertex(5, x2+n_x, y2+n_y - self.list[i].size / 2, z2+n_z, 1,1)
			    self.list[i].model.mesh:setVertex(6, x1+n_x, y1+n_y - self.list[i].size / 2, z1+n_z, 1,0)

			    if self.list[i].boss then
				    x2,y2,z2 = self.list[i].pos.x - y_1 * circleSize, self.list[i].pos.y - y_2 * circleSize, self.list[i].pos.z - y_3 * circleSize
				    local r = 0.5 * circleSize
				    n_x, n_y, n_z = x_1*r, x_2*r, x_3*r
				    self.list[i].circle.mesh:setVertex(1, x1-n_x, y1-n_y - circleSize / 2, z1-n_z, 0,0)
				    self.list[i].circle.mesh:setVertex(2, x1+n_x, y1+n_y - circleSize / 2, z1+n_z, 1,0)
				    self.list[i].circle.mesh:setVertex(3, x2-n_x, y2-n_y - circleSize / 2, z2-n_z, 0,1)
				    self.list[i].circle.mesh:setVertex(4, x2-n_x, y2-n_y - circleSize / 2, z2-n_z, 0,1)
				    self.list[i].circle.mesh:setVertex(5, x2+n_x, y2+n_y - circleSize / 2, z2+n_z, 1,1)
				    self.list[i].circle.mesh:setVertex(6, x1+n_x, y1+n_y - circleSize / 2, z1+n_z, 1,0)
				    self.list[i].circle:draw(g.moreTransparentShader)
				  end
			    self.list[i].model:draw(g.fogShader)
			  end
			end
		end
	end

}