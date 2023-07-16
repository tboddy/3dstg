return {

	scale = 2,
	clock = 0,
	clockLimit = 65535,

	width = 1920 / 2,
	height = 1080 / 2,

	bossHealth = 0,
	bossMax = 0,

	tau = math.pi * 2,
	phi = 1.61803398875,

	score = 0,
	highScore = 0,

	dt = 1,
	debug = '',

	gemCount = 0,

	colors = {
		black = hex.rgb('060608'),
		greenLight = hex.rgb('92dcba')
	},

	fogShader = love.graphics.newShader(g3d.shaderpath, 'res/fog.frag'),
	transparentShader = love.graphics.newShader(g3d.shaderpath, 'res/transparent.frag'),
	moreTransparentShader = love.graphics.newShader(g3d.shaderpath, 'res/moretransparent.frag'),
	lightShader = love.graphics.newShader(g3d.shaderpath, 'res/light.frag'),

	font = function(self)
		return love.graphics.newFont('res/font/dyna-gear-large.ttf', 16)
	end,

	bigFont = function(self)
		return love.graphics.newFont('res/font/dyna-gear-large.ttf', 32)
	end,

	resetColor = function(self)
		love.graphics.setColor(hex.rgb('ffffff'))
	end,

	label = function(self, input, lX, y, lAlign, lLimit, big)
		local x = 0 if lX then x = lX end
		local align = 'left' if lAlign then align = lAlign end
		local limit = g.width if lLimit then limit = lLimit end
		love.graphics.setFont(big and self:bigFont() or self:font())
		love.graphics.setColor(self.colors.black)
		love.graphics.printf(input, x, y + 2, limit, align)
		love.graphics.setColor(self.colors.greenLight)
		love.graphics.printf(input, x, y, limit, align)
		self:resetColor()
	end

}