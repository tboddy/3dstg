local bulletImages, bulletTypes = {}, {'red', 'green', 'blue', 'yellow', 'gray'}
local killClock = 0

return {

	count = 768,
	current = 0,
	list = {},

	killAll = false,

	spawn = function(self, spawner)
		if (killClock == 0 and not spawner.player) or spawner.player then
			i = -1
			for j = 1, self.count do if i == -1 and not self.list[j].active then i = j break end end
			if i > -1 then
				self.list[i].active = true
				self.list[i].pos = cpml.vec3.new(spawner.position[1], spawner.position[2] - 0.5, spawner.position[3])
				self.list[i].target[1] = spawner.target[1]
				self.list[i].target[2] = spawner.target[2]
				self.list[i].target[3] = spawner.target[3]
				self.list[i].clock = 0
				self.list[i].visible = spawner.player or false
				self.list[i].size = spawner.size or 1
				self.list[i].nums = {}
				self.list[i].player = spawner.player or false
				self.list[i].speed = spawner.speed
				self.list[i].velocity[1] = (spawner.target[1] - spawner.position[1]) * spawner.speed
				self.list[i].velocity[2] = (spawner.target[2] - spawner.position[2]) * spawner.speed
				self.list[i].velocity[3] = (spawner.target[3] - spawner.position[3]) * spawner.speed
				self.list[i].image = spawner.image
				self.list[i].updater = spawner.updater or nil
				self.list[i].model = g3d.newModel({
			    {-1,0,-1},
			    {1, 0,-1},
			    {-1,0, 1},
			    {1, 0, 1},
			    {1, 0,-1},
			    {-1,0, 1}}, bulletImages[self.list[i].image][1])
				self.list[i].model:compress()
			end
		end
	end,

	killBullet = function(self, i, explode)
		self.list[i].active = false
		self.list[i].model = nil
	end,

	load = function(self)

		for i = 1, #bulletTypes do
			local images = {}
			for j = 1, 4 do
				table.insert(images, love.graphics.newImage('res/bullets/' .. bulletTypes[i] .. '-' .. j .. '.png'))
			end
			bulletImages[bulletTypes[i]] = images
		end


		for i = 1, self.count do
			table.insert(self.list, {
				active = false,
				image = '',
				velocity = {0, 0, 0},
				target = {0, 0, 0},
				type = 0,
				clock = 0,
				visible = false,
				player = false,
				model = nil,
				size = 1
			})
		end
	end,

	bulletLimit = 45,

	update = function(self)
		self.current = 0
		for i = 1, self.count do
			if self.list[i].active then
				self.current = self.current + 1
				if self.list[i].updater then self.list[i].updater(i) end
				self.list[i].pos.x = self.list[i].pos.x + self.list[i].velocity[1] * g.dt
				self.list[i].pos.y = self.list[i].pos.y + self.list[i].velocity[2] * g.dt
				self.list[i].pos.z = self.list[i].pos.z + self.list[i].velocity[3] * g.dt

				if self.list[i].clock >= 2 and not self.list[i].visible then
					self.list[i].visible = true
				end

				if self.list[i].clock % 12 == 0 then
					self.list[i].model.mesh:setTexture(bulletImages[self.list[i].image][1])
				elseif self.list[i].clock % 12 == 3 then
					self.list[i].model.mesh:setTexture(bulletImages[self.list[i].image][2])
				elseif self.list[i].clock % 12 == 6 then
					self.list[i].model.mesh:setTexture(bulletImages[self.list[i].image][3])
				elseif self.list[i].clock % 12 == 9 then
					self.list[i].model.mesh:setTexture(bulletImages[self.list[i].image][4])
				end

				-- against tiles
				-- for j = 1, stage.tileCount do
				-- 	if stage.tiles[j].active and not stage.tiles[j].sky and not stage.tiles[j].prop then
				-- 		if stage.tiles[j].model:sphereIntersection(self.list[i].position[1], self.list[i].position[2], self.list[i].position[3], 0.5) then
				-- 			self:killBullet(i, true)
				-- 		end
				-- 	end
				-- end

				-- against y
				if self.list[i].pos.y > 1 or self.list[i].pos.y < -20 then
					if self.list[i].pos.y > 1 then
						explosions:spawn({
							image = self.list[i].image,
							size = 2,
							pos = {
								self.list[i].pos.x,
								self.list[i].pos.y,
								self.list[i].pos.z
							}
						})
					end
					self:killBullet(i, true)
				else

					-- against clock
					if self.list[i].clock > 240 then self:killBullet(i)

					-- kill all
					elseif
						killClock > 0 and not self.list[i].player then self:killBullet(i)
					else

						-- against enemies
						if self.list[i].player then for j = 1, enemies.count do
							if enemies.list[j].active and not enemies.list[j].gem then
								if cpml.vec3.dist(self.list[i].pos, enemies.list[j].pos) < enemies.list[j].size then
									enemies.list[j].hit = true
									explosions:spawn({
										image = 'gray',
										size = (enemies.list[j].health == 1 and 8 or 4),
										pos = {
											enemies.list[j].pos.x,
											enemies.list[j].pos.y,
											enemies.list[j].pos.z
										}
									})
									self:killBullet(i, true)
								end
							end
						end

						-- against player
						else if cpml.vec3.dist(self.list[i].pos, player.pos) < 1 then
							self:killBullet(i, true)
							player.health = player.health - 20
							bullets.killAll = true
						end end

					end
				end
				self.list[i].clock = self.list[i].clock + 1
			end
		end
		if self.killAll then
			self.killAll = false
			killClock = 20
		end
		if killClock > 0 then
			killClock = killClock - 1
		end
	end,

	draw = function(self)


		for i = 1, self.count do
			if self.list[i].active and self.list[i].visible then
		    local x_1, x_2, x_3 = g3d.camera.viewMatrix[1], g3d.camera.viewMatrix[2], g3d.camera.viewMatrix[3]
		    local y_1, y_2, y_3 = g3d.camera.viewMatrix[5], g3d.camera.viewMatrix[6], g3d.camera.viewMatrix[7]
		    local x1,y1,z1 = self.list[i].pos.x, self.list[i].pos.y, self.list[i].pos.z
		    local x2,y2,z2 = self.list[i].pos.x - y_1, self.list[i].pos.y - y_2, self.list[i].pos.z - y_3
		    local r = 0.5
		    n_x, n_y, n_z = x_1*r, x_2*r, x_3*r
		    self.list[i].model.mesh:setVertex(1, x1-n_x, y1-n_y, z1-n_z, 0,0)
		    self.list[i].model.mesh:setVertex(2, x1+n_x, y1+n_y, z1+n_z, 1,0)
		    self.list[i].model.mesh:setVertex(3, x2-n_x, y2-n_y, z2-n_z, 0,1)
		    self.list[i].model.mesh:setVertex(4, x2-n_x, y2-n_y, z2-n_z, 0,1)
		    self.list[i].model.mesh:setVertex(5, x2+n_x, y2+n_y, z2+n_z, 1,1)
		    self.list[i].model.mesh:setVertex(6, x1+n_x, y1+n_y, z1+n_z, 1,0)
		    if self.list[i].player then self.list[i].model:draw(g.fogShader)
		    else self.list[i].model:draw(g.fogShader) end
			end
		end

	end

}