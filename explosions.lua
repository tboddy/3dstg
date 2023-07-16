local explosionInterval = 3
local explosionLimit = explosionInterval * 5

local explosionImages, explosionTypes = {}, {'red', 'blue', 'green', 'yellow', 'gray'}

return {

	count = 64,
	list = {},

	spawn = function(self, spawner)
		i = -1
		for j = 1, self.count do if i == -1 and not self.list[j].active then i = j break end end
		if i > -1 then
			self.list[i].active = true
			self.list[i].size = spawner.size
			self.list[i].clock = 0
			self.list[i].pos.x = spawner.pos[1]
			self.list[i].pos.y = spawner.pos[2]
			self.list[i].pos.z = spawner.pos[3]
			self.list[i].image = spawner.image
			self.list[i].model = g3d.newModel({
		    {-1,0,-1},
		    {1, 0,-1},
		    {-1,0, 1},
		    {1, 0, 1},
		    {1, 0,-1},
		    {-1,0, 1}}, explosionImages[self.list[i].image][1])
			self.list[i].model:compress()
		end
	end,

	load = function(self)

		for i = 1, #explosionTypes do
			local images = {}
			for j = 1, 5 do
				table.insert(images, love.graphics.newImage('res/explosions/' .. explosionTypes[i] .. j .. '.png'))
			end
			explosionImages[explosionTypes[i]] = images
		end

		for i = 1, self.count do
			table.insert(self.list, {
				active = false,
				image = '',
				pos = cpml.vec3.new(0, 0, 0),
				model = nil
			})
		end
	end,

	update = function(self)
		for i = 1, self.count do
			if self.list[i].active then
				if self.list[i].clock == 0 then
					self.list[i].model.mesh:setTexture(explosionImages[self.list[i].image][1])
				elseif self.list[i].clock == explosionInterval then
					self.list[i].model.mesh:setTexture(explosionImages[self.list[i].image][2])
				elseif self.list[i].clock == (explosionInterval * 2) then
					self.list[i].model.mesh:setTexture(explosionImages[self.list[i].image][3])
				elseif self.list[i].clock == (explosionInterval * 3) then
					self.list[i].model.mesh:setTexture(explosionImages[self.list[i].image][4])
				elseif self.list[i].clock == (explosionInterval * 4) then
					self.list[i].model.mesh:setTexture(explosionImages[self.list[i].image][5])
				elseif self.list[i].clock >= explosionLimit then
					self.list[i].active = false
					self.list[i].model = nil
				end
				self.list[i].clock = self.list[i].clock + 1
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
		    self.list[i].model:draw(g.fogShader)
			end
		end
	end

}