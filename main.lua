g3d = require 'g3d'
hex = require 'lib.hex'

g = require 'src.globals'
chrome = require 'src.chrome'
stage = require 'src.stage'
bullets = require 'src.bullets'
enemies = require 'src.enemies'
player = require 'src.player'

local winWidth, winHeight = love.window.getDesktopDimensions()

function love.load()
	love.window.setTitle('lol rak game')
	local windowConfig = {
		vsync = true
	}
	love.window.setMode(g.width * g.scale, g.height * g.scale, windowConfig)
	love.graphics.setDefaultFilter("nearest")
	love.graphics.setLineStyle('rough')
	love.graphics.setLineWidth(1 * g.scale)
	love.graphics.setBackgroundColor(0,0,0)
	bullets:load()
	enemies:load()
	stage:load()
	player:load()
end

function love.update(dt)
	g.dt = dt
	player:update()
	stage:update()
	bullets:update()
	enemies:update()
	g.clock = g.clock + 1
	if g.clock >= g.clockLimit then g.clock = 0 end
end

function love.keypressed(k)
	if k == "escape" then love.event.push("quit") end
end

function love.mousemoved(x,y, dx,dy)
	g3d.camera.firstPersonLook(dx,-dy)
end

function love.draw()
	stage:draw()
	bullets:draw()
	enemies:draw()
	chrome:draw()
end

