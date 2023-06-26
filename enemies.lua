return {

	count = 32,
	current = 0,
	list = {},


	spawn = function(self, spawner)
		i = -1
		for j = 1, self.count do if i == -1 and not self.list[j].active then i = j break end end
		if i > -1 then
			self.list[i].active = true
			self.list[i].position[1] = spawner.position[1]
			self.list[i].position[2] = spawner.position[2]
			self.list[i].position[3] = spawner.position[3]
			self.list[i].clock = 0
			self.list[i].hit = false
			self.list[i].boss = spawner.boss or false
			self.list[i].nums = {}
			self.list[i].health = spawner.health
			self.list[i].size = spawner.size / 5 * 4
			local enemyImage = love.graphics.newImage('res/enemies/' .. spawner.image .. '.png')
			self.list[i].model = g3d.newModel({
		    {-1,0,-1},
		    {1, 0,-1},
		    {-1,0, 1},
		    {1, 0, 1},
		    {1, 0,-1},
		    {-1,0, 1}}, enemyImage)
			self.list[i].hitbox = g3d.newModel('res/enemies/hitbox.obj', 'res/enemies/hitbox.png', self.list[i].position)
			self.list[i].model:setTransform({0,-spawner.size,0}, nil, {spawner.size,spawner.size,spawner.size})
			self.list[i].hitbox:setTransform({0, -spawner.size / 2, 0}, nil, {spawner.size / 2,spawner.size / 2,spawner.size / 2})
			self.list[i].updater = spawner.updater or nil
		end
	end,

	load = function(self)
		for i = 1, self.count do
			table.insert(self.list, {
				active = false,
				position = {0, 0, 0},
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
				self.list[i].clock = self.list[i].clock + 1
				if self.list[i].clock >= g.clockLimit then self.list[i].clock = 60 end
				if self.list[i].hit then self:hitEnemy(i) end
			end
		end
	end,

	draw = function(self)
		for i = 1, self.count do
			if self.list[i].active then
		    local x_1, x_2, x_3 = g3d.camera.viewMatrix[1], g3d.camera.viewMatrix[2], g3d.camera.viewMatrix[3]
		    local y_1, y_2, y_3 = g3d.camera.viewMatrix[5], g3d.camera.viewMatrix[6], g3d.camera.viewMatrix[7]
		    local x1,y1,z1 = self.list[i].position[1], self.list[i].position[2], self.list[i].position[3]
		    local x2,y2,z2 = self.list[i].position[1] - y_1, self.list[i].position[2] - y_2, self.list[i].position[3] - y_3
		    local r = 0.5
		    n_x, n_y, n_z = x_1*r, x_2*r, x_3*r
		    
		    self.list[i].model.mesh:setVertex(1, x1-n_x, y1-n_y, z1-n_z, 0,0)
		    self.list[i].model.mesh:setVertex(2, x1+n_x, y1+n_y, z1+n_z, 1,0)
		    self.list[i].model.mesh:setVertex(3, x2-n_x, y2-n_y, z2-n_z, 0,1)
		    self.list[i].model.mesh:setVertex(4, x2-n_x, y2-n_y, z2-n_z, 0,1)
		    self.list[i].model.mesh:setVertex(5, x2+n_x, y2+n_y, z2+n_z, 1,1)
		    self.list[i].model.mesh:setVertex(6, x1+n_x, y1+n_y, z1+n_z, 1,0)
		    self.list[i].model:draw(g.fogShader)

		    -- self.list[i].hitbox:draw()
			end
		end
	end

}