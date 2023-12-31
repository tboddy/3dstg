local level = require 'level'
local boss = require 'boss'

local treeY, bushY, grassY = 1.25, -0.5, 2

local offsetReturner = function()
	return math.random(0, g.phi) / 64
end


local lineOffset, yOffset, bushOffset, grassOffset, lastWave

return {

	tileCount = 1024,
	tiles = {},
	clock = 0,
	currentWave = 1,

	spawnAngle1 = 0,
	spawnAngle2 = 0,

	spawn = function(self, model, texture, x, y, z, rotation, scale, sky, prop, transparent)
		i = -1
		for j = 1, self.tileCount do if i == -1 and not self.tiles[j].active then i = j break end end
		if i > -1 then
			self.tiles[i].active = true
			self.tiles[i].sky = sky or false
			self.tiles[i].prop = prop or false
			self.tiles[i].transparent = transparent or false
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
		-- self:spawn('sky', 'sky', 0, 0, 0, nil, {5, -5, 5}, true)

		self:spawn('ground', 'ground', 0, 2, 0, nil, {4.5, -2.5, 4.5})
		self:spawn('cylinder', 'blank', 0, 2, 0, nil, {4.25, -4.25, 4.25})

		local propAngle, treeLine, bushLine, grassLine = 0, 40, 38, 22
		local angleOffset

		for i = 1, 32 do

			-- firsttrees
			lineOffset, yOffset, angleOffset = treeLine - math.random(0, 2), treeY + math.random(0, 1), offsetReturner()
			self:spawn('props/tree1', 'props/tree', math.cos(propAngle + angleOffset) * lineOffset, yOffset, math.sin(propAngle + angleOffset) * lineOffset, {0, math.random(0, g.tau), 0},
				nil, false, true)
			lineOffset, yOffset, angleOffset = treeLine - math.random(0, 2), treeY + math.random(0, 1), offsetReturner()
			self:spawn('props/tree2', 'props/tree', math.cos(propAngle + math.pi / 32 + angleOffset) * lineOffset, yOffset, math.sin(propAngle + math.pi / 32 + angleOffset) * lineOffset,
				{0, math.random(0, g.tau), 0}, nil, false, true)

			-- then bushes
			bushOffset, angleOffset = bushLine - math.random(0, 1), offsetReturner()
			self:spawn('props/bush1', 'props/bush', math.cos(propAngle + angleOffset + math.pi / 64) * bushOffset, bushY, math.sin(propAngle + angleOffset + math.pi / 64) * bushOffset,
				{0, math.random(0, g.tau), 0}, nil, false, true)
			bushOffset, angleOffset = bushLine - math.random(0, 1), offsetReturner()
			self:spawn('props/bush2', 'props/bush', math.cos(propAngle + angleOffset + math.pi / 64 + math.pi / 32) * bushOffset, bushY,
				math.sin(propAngle + angleOffset + math.pi / 64 + math.pi / 32) * bushOffset, {0, math.random(0, g.tau), 0}, nil, false, true)

			-- some grass
			grassOffset, angleOffset = grassLine + math.random(0, 15), offsetReturner()
			self:spawn('props/grass1', 'props/misc', math.cos(propAngle + angleOffset) * grassOffset, grassY, math.sin(propAngle + angleOffset) * grassOffset, {0, math.random(0, g.tau), 0},
				nil, false, true, true)
			grassOffset, angleOffset = grassLine + math.random(0, 15), offsetReturner()
			self:spawn('props/grass1', 'props/misc', math.cos(propAngle + math.pi / 32 + angleOffset) * grassOffset, grassY, math.sin(propAngle + math.pi / 32 + angleOffset) * grassOffset,
				{0, math.random(0, g.tau), 0}, nil, false, true, true)

			propAngle = propAngle + math.pi / 16
		end

		level.load()

	end,

	update = function(self)

		if lastWave ~= self.currentWave then
			chrome.waveMessageClock = chrome.messageTime
			lastWave = self.currentWave
			self.clock = -chrome.messageTime
		end

		if self.clock >= 0 then
			if self.clock == 0 then
				g.gemCount = 0
			end
			level.waves[self.currentWave]()
		end

		g.fogShader:send('player', g3d.camera.position)
		g.transparentShader:send('player', g3d.camera.position)
		g.moreTransparentShader:send('player', g3d.camera.position)

		for i = 1, self.tileCount do
			if self.tiles[i].active then
				if self.tiles[i].sky then
					self.tiles[1].model:setTranslation(g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3])
					-- self.tiles[1].model:setRotation(-g3d.camera.up[1], -g3d.camera.up[3], -g3d.camera.up[2])
				end
			end
		end
		if self.clock < g.clockLimit then self.clock = self.clock + 1 end
	end,

	draw = function(self)
		for i = 1, self.tileCount do
			if self.tiles[i].active then
				if(self.tiles[i].sky) then self.tiles[i].model:draw()
				-- self.tiles[i].transparent and g.transparentShader or 
				else self.tiles[i].model:draw(g.fogShader) end
			end
		end
	end

}