local grid = 32
local bottomY = g.height - grid * 2
local rightX = (g.width - grid)

local bossW = g.width - grid * 11
local barH = 24

return {

	drawScore = function()
		g:label('Score 0000000000', 0, grid, 'right', g.width - grid)
		g:label('High 0000000000', 0, grid * 2.25, 'right', g.width - grid)
	end,

	drawFuel = function()
		g:label('^', grid, bottomY + 6)
		love.graphics.setColor(g.colors.black)
		love.graphics.rectangle('line', grid * 2.5, bottomY + 4 + 2, player.fuelMax * 2, barH)
		love.graphics.setColor(g.colors.greenLight)
		love.graphics.rectangle('line', grid * 2.5, bottomY + 4, player.fuelMax * 2, barH)
		if player.fuel > 0 then
			love.graphics.rectangle('fill', grid * 2.5, bottomY + 4, player.fuel * 2, barH)
		end
	end,

	drawAim = function()
		love.graphics.setColor(g.colors.greenLight)
		love.graphics.circle('line', g.width / 2, g.height / 2, 48)
	end,

	drawBoss = function()
		if g.bossHealth > 0 then
			love.graphics.setColor(g.colors.black)
			love.graphics.rectangle('line', grid, grid + 4 + 2, g.bossMax * (bossW / g.bossMax), barH)
			love.graphics.setColor(g.colors.greenLight)
			love.graphics.rectangle('line', grid, grid + 4, g.bossMax * (bossW / g.bossMax), barH)
			love.graphics.rectangle('fill', grid, grid + 4, g.bossHealth * (bossW / g.bossMax), barH)
			g:label('hairy ball fart', grid, grid * 2.25)
		end
	end,

	drawHealth = function()
		g:label('100', 0, bottomY, 'center', g.width)
	end,

	drawDebug = function()
		-- g:label('Enemies ' .. enemies.current, 0, bottomY - grid * 1.25, 'right', rightX)
		-- g:label('Bullets ' .. bullets.current, 0, bottomY, 'right', rightX)
		-- g:label(debug, 0, bottomY, 'right', rightX)
	end,

	load = function()
	end,

	draw = function(self)
		self.drawScore()
		self.drawFuel()
		self.drawHealth()
		self.drawBoss()
		self.drawAim()
		self.drawDebug()
		g:resetColor()
	end,

	update = function()
	end

}