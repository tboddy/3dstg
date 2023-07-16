local grid = 16
local bottomY = g.height - grid * 2
local rightX = (g.width - grid)

local bossW = grid * 49 
local barH = grid

local aimPos = {x = g.width / 2, y = g.height / 2 + 4}

return {

	messageTime = 90,

	drawScore = function()
		g:label('HIGH ' .. string.format('%010d', g.highScore), 0, grid, 'right', g.width - grid)
		g:label('SCORE ' .. string.format('%010d', g.score), 0, grid * 2.5, 'right', g.width - grid)
	end,

	drawFuel = function()
		g:label('UP', grid, bottomY)
		love.graphics.setColor(g.colors.black)
		love.graphics.rectangle('line', grid * 2.5, bottomY + g.scale, player.fuelMax * 2, barH)
		love.graphics.setColor(g.colors.greenLight)
		love.graphics.rectangle('line', grid * 2.5, bottomY, player.fuelMax * 2, barH)
		if player.fuel > 0 then
			love.graphics.rectangle('fill', grid * 2.5, bottomY, player.fuel * 2, barH)
		end
	end,

	updateAim = function(self)
	end,

	drawAim = function(self)
		local crossOff, crossSize = 4, 12
		love.graphics.setColor(g.colors.greenLight)
		-- love.graphics.rectangle('line', aimPos.x - g.scale, aimPos.y - g.scale, g.scale, g.scale)
		-- love.graphics.line(aimPos.x - crossSize, aimPos.y, aimPos.x - crossOff, aimPos.y)
		-- love.graphics.line(aimPos.x + crossOff, aimPos.y, aimPos.x + crossSize, aimPos.y)
		-- love.graphics.line(aimPos.x, aimPos.y - crossSize, aimPos.x, aimPos.y - crossOff)
		-- love.graphics.line(aimPos.x, aimPos.y + crossOff, aimPos.x, aimPos.y + crossSize)

		love.graphics.circle('line', aimPos.x, aimPos.y, 6)
		love.graphics.circle('line', aimPos.x, aimPos.y, 1)
	end,

	drawBoss = function()
		if g.bossHealth > 0 then
			love.graphics.setColor(g.colors.black)
			love.graphics.rectangle('line', grid, grid + g.scale, g.bossMax * (bossW / g.bossMax), barH)
			love.graphics.setColor(g.colors.greenLight)
			love.graphics.rectangle('line', grid, grid, g.bossMax * (bossW / g.bossMax), barH)
			love.graphics.rectangle('fill', grid, grid, g.bossHealth * (bossW / g.bossMax), barH)
			g:label('MIKE GOUTOKUJI', grid, grid * 2.5)
		end
	end,

	drawHealth = function()
		g:label(player.health, 0, bottomY - grid, 'center', g.width, true)
	end,

	gemMessageClock = 0,
	waveMessageClock = 0,

	drawWave = function(self)
		g:label('WAVE ' .. string.format('%02d', stage.currentWave), grid, grid)
		if g.gemCount > 0 then
			g:label(string.format('%02d', g.gemCount) .. ' GEM' .. (g.gemCount > 1 and 'S' or '') .. ' LEFT', grid, grid * 2.5)
		end
		if self.gemMessageClock > 0 then
			g:label((g.gemCount > 0 and 'GOT A GEM!' or 'GOT ALL GEMS!'), 0, grid, 'center', g.width)
		end
		if self.waveMessageClock > 0 then
			g:label('START WAVE ' .. string.format('%02d', stage.currentWave), 0, g.height / 2 - 8, 'center', g.width)
		end
	end,

	drawDebug = function()
		g:label(string.format('%03d', enemies.current) .. ' ENEMIES', 0, bottomY - grid * 1.5, 'right', rightX)
		g:label(string.format('%03d', bullets.current) .. ' BULLETS', 0, bottomY, 'right', rightX)
		-- g:label((love.timer.getFPS() * 2) .. ' FPS', 0, bottomY, 'right', rightX - grid * 2)
	end,

	load = function()
	end,

	update = function(self)
		self:updateAim()
		if self.gemMessageClock > 0 then
			self.gemMessageClock = self.gemMessageClock - 1
		end
		if self.waveMessageClock > 0 then
			self.waveMessageClock = self.waveMessageClock - 1
		end
	end,

	draw = function(self)
		self.drawScore()
		self.drawFuel()
		self.drawHealth()
		self.drawBoss()
		if self.waveMessageClock == 0 then self:drawAim() end
		self:drawWave()
		self.drawDebug()
		g:resetColor()
	end

}