local boss = require 'boss'

local map = {
	{0, 1, 1, 1, 1, 1, 1, 1, 0},
	{3, 5, 0, 0, 0, 0, 0, 6, 4},
	{3, 0, 0, 0, 0, 0, 0, 0, 4},
	{3, 0, 0, 0, 0, 0, 0, 0, 4},
	{3, 0, 0, 0, 0, 0, 0, 0, 4},
	{3, 0, 0, 0, 0, 0, 0, 0, 4},
	{3, 0, 0, 0, 0, 0, 0, 0, 4},
	{3, 7, 0, 0, 0, 0, 0, 8, 4},
	{0, 2, 2, 2, 2, 2, 2, 2, 0}
}

local stageModel, stageTexture

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

		self:spawn('arena', 'arena', 0, 2, 0, nil, {6, -6, 6})

		-- for x = 1, #map do
		-- 	for y = 1, #map do
		-- 		self:spawn('floor-flat', 'floor-flat-1', (x - 1 - #map / 2) * 8 + 4, 0, (y - 1 - #map / 2) * 8 + 4)
		-- 		if map[y][x] ~= 0 then
		-- 			stageModel = nil
		-- 			stageTexture = nil
		-- 			if map[y][x] == 1 then stageModel = 'wall-flat-north'
		-- 			elseif map[y][x] == 2 then stageModel = 'wall-flat-south'
		-- 			elseif map[y][x] == 3 then stageModel = 'wall-flat-west'
		-- 			elseif map[y][x] == 4 then stageModel = 'wall-flat-east'
		-- 			elseif map[y][x] == 5 then stageModel = 'wall-flat-corner-nw'
		-- 			elseif map[y][x] == 6 then stageModel = 'wall-flat-corner-ne'
		-- 			elseif map[y][x] == 7 then stageModel = 'wall-flat-corner-sw'
		-- 			elseif map[y][x] == 8 then stageModel = 'wall-flat-corner-se' end
		-- 			stageTexture = 'wall-flat-1'
		-- 			if stageModel and stageTexture then
		-- 				for i = 1, 3 do
		-- 					self:spawn(stageModel, stageTexture, (x - 1 - #map / 2) * 8 + 4, -8 * (i - 1), (y - 1 - #map / 2) * 8 + 4)
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end

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