local circleSize = 10

return {

	count = 32,
	current = 0,
	list = {},

	spawn = function(self, spawner)
		spawner.size = 3
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
			self.list[i].health = spawner.health
			self.list[i].size = spawner.size
			local enemyImage = love.graphics.newImage('res/enemies/' .. spawner.image .. '.png')
			self.list[i].model = g3d.newModel({
		    {-1,0,-1},
		    {1, 0,-1},
		    {-1,0, 1},
		    {1, 0, 1},
		    {1, 0,-1},
		    {-1,0, 1}}, enemyImage)
			if spawner.boss then
				local circleImage = love.graphics.newImage('res/enemies/circle.png')
				self.list[i].circle = g3d.newModel({
			    {-1,0,-1},
			    {1, 0,-1},
			    {-1,0, 1},
			    {1, 0, 1},
			    {1, 0,-1},
			    {-1,0, 1}}, circleImage)
			end
			self.list[i].hitbox = g3d.newModel('res/enemies/hitbox.obj', 'res/enemies/hitbox.png', spawner.position)
			self.list[i].hitbox:setTransform({0, -spawner.size / 2, 0}, nil, {spawner.size / 4 * 3,spawner.size / 4 * 3,spawner.size / 4 * 3})
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
				hitbox = nil,
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
		self.list[i].hitbox = nil
	end,

	hitEnemy = function(self, i)
		self.list[i].hit = false
		self.list[i].health = self.list[i].health - 1
		if self.list[i].health <= 0 then self:killEnemy(i) end
	end,

	rotation = 0,

	update = function(self)
		self.current = 0
		for i = 1, self.count do
			if self.list[i].active then
				self.current = self.current + 1
				if self.list[i].updater then self.list[i].updater(i) end
				if self.list[i].active then
			    self.list[i].hitbox:setTransform({self.list[i].pos.x, self.list[i].pos.y, self.list[i].pos.z})
					self.list[i].clock = self.list[i].clock + 1
					if self.list[i].clock >= g.clockLimit then self.list[i].clock = 60 end
					if self.list[i].hit then self:hitEnemy(i) end
				end
			end
		end
	end,

	draw = function(self)
		for i = 1, self.count do
			if self.list[i].active then
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
		    -- self.list[i].hitbox:draw()
			end
		end
	end

}