local grid = 16
local bottomY = g.height - grid * 2
local rightX = (g.width - grid)

local bossW = g.width - grid * 2
local bossX = 16

return {

	drawFuel = function()
		g:label('Jump', grid, bottomY - grid * 1.5)
		love.graphics.setColor(g.colors.black)
		love.graphics.rectangle('line', grid, bottomY + 1, player.fuelMax, grid)
		love.graphics.setColor(g.colors.greenLight)
		love.graphics.rectangle('line', grid, bottomY, player.fuelMax, grid)
		if player.fuel > 0 then
			love.graphics.rectangle('fill', grid, bottomY, player.fuel, grid)
		end
	end,

	drawAim = function()
		love.graphics.setColor(g.colors.greenLight)
		love.graphics.circle('line', (g.width / 2 - 4 + 4), (g.height / 2 + 4), 48)
	end,

	drawBoss = function()
		if g.bossHealth > 0 then
			love.graphics.setColor(g.colors.black)
			love.graphics.rectangle('line', grid, grid + 1, g.bossMax * (bossW / g.bossMax), grid)
			love.graphics.setColor(g.colors.greenLight)
			love.graphics.rectangle('line', grid, grid, g.bossMax * (bossW / g.bossMax), grid)
			love.graphics.rectangle('fill', grid, grid, g.bossHealth * (bossW / g.bossMax), grid)
			g:label('Mike Goutokuji', 16, 16 * 2.5)
		end
	end,

	drawHealth = function()
		g:label('100', 0, bottomY, 'center', g.width)
	end,

	drawDebug = function()
		g:label('Enemies ' .. enemies.current, 0, bottomY - grid * 1.5, 'right', rightX)
		g:label('Bullets ' .. bullets.current, 0, bottomY, 'right', rightX)
	end,

	load = function()
	end,

	draw = function(self)
		self.drawFuel()
		-- self.drawAim()
		self.drawHealth()
		self.drawBoss()
		self.drawDebug()
		g:resetColor()
	end,

	update = function()
	end

}