return {

	scale = 1,
	clock = 0,
	clockLimit = 65535,

	width = 1920,
	height = 1080,

	bossHealth = 0,
	bossMax = 0,

	tau = math.pi * 2,
	phi = 1.61803398875,

	dt = 1,
	debug = '',

	colors = {
		black = hex.rgb('000000'),
		greenLight = hex.rgb('92dcba')
	},

	fogShader = love.graphics.newShader(g3d.shaderpath, 'res/fog.frag'),
	transparentShader = love.graphics.newShader(g3d.shaderpath, 'res/transparent.frag'),
	moreTransparentShader = love.graphics.newShader(g3d.shaderpath, 'res/moretransparent.frag'),

	font = function(self)
		return love.graphics.newFont('res/font.ttf', 32)
	end,

	resetColor = function(self)
		love.graphics.setColor(hex.rgb('ffffff'))
	end,

	mask = love.graphics.newImage('res/mask.png'),

	label = function(self, input, lX, y, lAlign, lLimit, big)
		local x = 0 if lX then x = lX end
		local align = 'left' if lAlign then align = lAlign end
		local limit = g.width if lLimit then limit = lLimit end
		love.graphics.setFont(self:font())
		love.graphics.setColor(self.colors.black)
		love.graphics.printf(input, x, y + 2, limit, align)
		love.graphics.setColor(self.colors.greenLight)
		love.graphics.printf(input, x, y, limit, align)
		self:resetColor()
	end

}