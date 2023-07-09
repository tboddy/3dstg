tick = require 'lib.tick'
g3d = require 'g3d'
cpml = require 'cpml'
maid64 = require 'lib.maid'
hex = require 'lib.hex'

g = require 'globals'
chrome = require 'chrome'
stage = require 'stage'
bullets = require 'bullets'
enemies = require 'enemies'
player = require 'player'

function love.load()
	love.graphics.setBackgroundColor(g.colors.black)
	tick.framerate = 60
	love.window.setTitle('lol rak game')
	local windowConfig = {
		vsync = false,
		minwidth = g.width / 2,
		minheight = g.height / 2,
		resizable = true
	}
	love.window.setMode(g.width * g.scale, g.height * g.scale, windowConfig)
	maid64.setup(g.width, g.height)
	love.graphics.setDefaultFilter('nearest')
	love.graphics.setLineStyle('rough')
	love.graphics.setLineWidth(2)
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
	chrome:update()
	g.clock = g.clock + 1
	if g.clock >= g.clockLimit then g.clock = 0 end
end

function love.keypressed(k)
	if k == 'escape' then love.event.push('quit') end
end

function love.mousemoved(x,y, dx,dy)
	g3d.camera.firstPersonLook(dx,-dy)
end

function love.resize(width, height)
	maid64.resize(width, height)
end

function love.draw()
	maid64.start()
	stage:draw()
	bullets:draw()
	enemies:draw()
	player:draw()
	chrome:draw()
	maid64.finish()
end