local bulletTexture

return {

	count = 2048,
	current = 0,
	list = {},

	killAll = false,

	spawn = function(self, spawner)
		i = -1
		for j = 1, self.count do if i == -1 and not self.list[j].active then i = j break end end
		if i > -1 then
			self.list[i].active = true
			self.list[i].position[1] = spawner.position[1]
			self.list[i].position[2] = spawner.position[2] + 0.5
			self.list[i].position[3] = spawner.position[3]
			self.list[i].clock = 0
			self.list[i].visible = spawner.player or false
			self.list[i].size = spawner.size or 1
			self.list[i].player = spawner.player or false
			self.list[i].speed = spawner.speed
			self.list[i].velocity[1] = (spawner.target[1] - spawner.position[1]) * spawner.speed
			self.list[i].velocity[2] = (spawner.target[2] - spawner.position[2]) * spawner.speed
			self.list[i].velocity[3] = (spawner.target[3] - spawner.position[3]) * spawner.speed
			bulletTexture = love.graphics.newImage('res/bullets/' .. spawner.image .. '.png')
			self.list[i].model = g3d.newModel({
		    {-1,0,-1},
		    {1, 0,-1},
		    {-1,0, 1},
		    {1, 0, 1},
		    {1, 0,-1},
		    {-1,0, 1}
				}, bulletTexture)
		end
	end,

	killBullet = function(self, i, explode)
		self.list[i].active = false
		self.list[i].model = nil
	end,

	load = function(self)
		for i = 1, self.count do
			table.insert(self.list, {
				active = false,
				position = {0, 0, 0},
				image = '',
				velocity = {0, 0, 0},
				type = 0,
				clock = 0,
				visible = false,
				player = false,
				model = false,
				size = 1
			})
		end
	end,

	update = function(self)
		self.current = 0
		for i = 1, self.count do
			if self.list[i].active then
				self.current = self.current + 1
				self.list[i].position[1] = self.list[i].position[1] + self.list[i].velocity[1] * g.dt
				self.list[i].position[2] = self.list[i].position[2] + self.list[i].velocity[2] * g.dt
				self.list[i].position[3] = self.list[i].position[3] + self.list[i].velocity[3] * g.dt

				if self.list[i].clock >= 2 and not self.list[i].visible then
					self.list[i].visible = true
				end

				-- against tiles
				for j = 1, stage.tileCount do
					if stage.tiles[j].active then
						if stage.tiles[j].model:sphereIntersection(self.list[i].position[1], self.list[i].position[2], self.list[i].position[3], 0.5) then
							self:killBullet(i, true)
						end
					end
				end

				-- against enemies
				if self.list[i].player then
					for j = 1, enemies.count do
						if enemies.list[j].active then
							if enemies.list[j].hitbox:sphereIntersection(self.list[i].position[1], self.list[i].position[2], self.list[i].position[3], 0.5) then
								enemies.list[j].hit = true
								self:killBullet(i, true)
							end
						end
					end

				end

				-- kill all
				if self.killAll and not self.list[i].player then self:killBullet(i) end

				if self.list[i].clock >= 3600 then self:killBullet(i) end

				self.list[i].clock = self.list[i].clock + 1

			end
		end
		if self.killAll then
			self.killAll = false
		end
	end,

	draw = function(self)
		for i = 1, self.count do
			if self.list[i].active and self.list[i].visible then
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
			end
		end
	end

}