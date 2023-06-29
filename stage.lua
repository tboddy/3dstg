local boss = require 'boss'

return {

	tileCount = 1024,
	tiles = {},

	spawn = function(self, model, texture, x, y, z, rotation, scale, sky)
		i = -1
		for j = 1, self.tileCount do if i == -1 and not self.tiles[j].active then i = j break end end
		if i > -1 then
			self.tiles[i].active = true
			self.tiles[i].sky = sky or false
			self.tiles[i].model = g3d.newModel('res/stage/' .. model .. '.obj', 'res/stage/' .. texture .. '.png', {x, y, z}, rotation or nil, scale or {-1, -1, 1})
		end
	end,

	load = function(self)
		for i = 1, self.tileCount do
			table.insert(self.tiles, {
				active = false,
				model = nil
			})
		end
		self:spawn('sky', 'sky', 0, 0, 0, nil, {100,100,100}, true)
		self:spawn('ground', 'ground', 0, 2, 0, nil, {4.1, -4, 4.1})
		self:spawn('cylinder', 'cylinder', 0, 2, 0, nil, {4, -4, 4})
		boss.oneSpawn()
	end,

	update = function(self)
		g.fogShader:send('player', g3d.camera.position)
		for i = 1, self.tileCount do
			if self.tiles[i].active then
				if self.tiles[i].sky then self.tiles[1].model:setTranslation(g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3]) end
			end
		end
	end,

	draw = function(self)
		for i = 1, self.tileCount do
			if self.tiles[i].active then
				if(self.tiles[i].sky) then self.tiles[i].model:draw()
				else self.tiles[i].model:draw(g.fogShader) end
			end
		end
	end

}