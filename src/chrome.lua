local grid = 8

local leftX = 16 * g.scale
local rightX = (g.width - 16) * g.scale
local topY = grid * g.scale
local bottomY = (g.height - 16 * 2) * g.scale

local fuelX = 64 * g.scale
local fuelH = 16 * g.scale

local bossX = 64 * g.scale
local bossY = 16 * g.scale
local bossH = 16 * g.scale
local bossW = g.width - 16 - 64

return {

	drawFuel = function()
		g:label('Jump', leftX, bottomY)
		love.graphics.setColor(g.colors.black)
		love.graphics.rectangle('line', fuelX, bottomY + g.scale, player.fuelMax * g.scale, fuelH)
		love.graphics.setColor(g.colors.greenLight)
		love.graphics.rectangle('line', fuelX, bottomY, player.fuelMax * g.scale, fuelH)
		if player.fuel > 0 then
			love.graphics.rectangle('fill', fuelX, bottomY, player.fuel * g.scale, fuelH)
		end
	end,

	drawAim = function()
		-- g:label('+', (g.width / 2 - 4) * g.scale, (g.height / 2 - 9) * g.scale)
		-- love.graphics.setColor(g.colors.greenLight)
		-- love.graphics.circle('line', (g.width / 2 - 4 + 4) * g.scale, (g.height / 2 + 4) * g.scale, 32 * g.scale)
		-- love.graphics.line((g.width / 2 - 8) * g.scale, (g.height / 2 + 4) * g.scale, (g.width / 2 + 8) * g.scale, (g.height / 2 + 4) * g.scale)
	end,

	drawBoss = function()
		if g.bossHealth > 0 then
			g:label('Boss', 16 * g.scale, bossY)
			love.graphics.setColor(g.colors.black)
			love.graphics.rectangle('line', bossX, bossY + g.scale, g.bossMax * (bossW / g.bossMax) * g.scale, bossH)
			love.graphics.setColor(g.colors.greenLight)
			love.graphics.rectangle('line', bossX, bossY, g.bossMax * (bossW / g.bossMax) * g.scale, bossH)
			love.graphics.rectangle('fill', bossX, bossY, g.bossHealth * (bossW / g.bossMax) * g.scale, bossH)
		end
	end,

	drawDebug = function()
		g:label('Enemies ' .. enemies.current, 0, bottomY - 16 * g.scale, 'right', rightX)
		g:label('Bullets ' .. bullets.current, 0, bottomY, 'right', rightX)
	end,

	load = function()
	end,

	draw = function(self)
		self.drawFuel()
		self.drawAim()
		self.drawBoss()
		self.drawDebug()
		g:resetColor()
	end,

	update = function()
	end

}