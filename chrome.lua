local grid = 32
local bottomY = g.height - grid * 2
local rightX = (g.width - grid)

local bossW = g.width - grid * 11
local barH = 24

local aimPos = {0, 0}

return {

	drawScore = function()
		g:label('SCORE 0000000000', 0, grid, 'right', g.width - grid)
		-- g:label('HIGH  0000000000', 0, grid * 2.25, 'right', g.width - grid)
	end,

	drawFuel = function()
		g:label('UP', grid, bottomY)
		love.graphics.setColor(g.colors.black)
		love.graphics.rectangle('line', grid * 2.5, bottomY + 4 + 2, player.fuelMax * 2, barH)
		love.graphics.setColor(g.colors.greenLight)
		love.graphics.rectangle('line', grid * 2.5, bottomY + 4, player.fuelMax * 2, barH)
		if player.fuel > 0 then
			love.graphics.rectangle('fill', grid * 2.5, bottomY + 4, player.fuel * 2, barH)
		end
	end,

	updateAim = function(self)
		aimPos.x = g.width / 2
		aimPos.y = g.height / 2
	end,

	drawAim = function(self)
		local crossOff, crossSize = 8, 24
		love.graphics.setColor(g.colors.greenLight)
		love.graphics.line(aimPos.x - crossSize, aimPos.y, aimPos.x - crossOff, aimPos.y)
		love.graphics.line(aimPos.x + crossOff, aimPos.y, aimPos.x + crossSize, aimPos.y)
		love.graphics.line(aimPos.x, aimPos.y - crossSize, aimPos.x, aimPos.y - crossOff)
		love.graphics.line(aimPos.x, aimPos.y + crossOff, aimPos.x, aimPos.y + crossSize)

		-- love.graphics.circle('line', aimPos.x, aimPos.y, 48)
	end,

	drawBoss = function()
		if g.bossHealth > 0 then
			love.graphics.setColor(g.colors.black)
			love.graphics.rectangle('line', grid, grid + 4 + 2, g.bossMax * (bossW / g.bossMax), barH)
			love.graphics.setColor(g.colors.greenLight)
			love.graphics.rectangle('line', grid, grid + 4, g.bossMax * (bossW / g.bossMax), barH)
			love.graphics.rectangle('fill', grid, grid + 4, g.bossHealth * (bossW / g.bossMax), barH)
			g:label('MIKE GOUTOKUJI', grid, grid * 2.25)
		end
	end,

	drawHealth = function()

		g:label(player.health, 0, bottomY - grid + 4, 'center', g.width, true)

	end,

	drawDebug = function()
		g:label(enemies.current .. ' ENM', 0, bottomY - grid * 2.5, 'right', rightX)
		g:label(bullets.current .. ' BUL', 0, bottomY - grid * 1.25, 'right', rightX)
		g:label(love.timer.getFPS() .. ' FPS', 0, bottomY, 'right', rightX)
	end,

	load = function()
	end,

	update = function(self)
		self:updateAim()
	end,

	draw = function(self)
		self.drawScore()
		self.drawFuel()
		self.drawHealth()
		self.drawBoss()
		self:drawAim()
		self.drawDebug()
		g:resetColor()
	end

}