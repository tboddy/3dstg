return {

	scale = 2,
	clock = 0,
	clockLimit = 65535,

	width = 854,
	height = 480,

	bossHealth = 0,
	bossMax = 0,

	tau = math.pi * 2,

	dt = 1,

	colors = {
		black = hex.rgb('060608'),
		greenLight = hex.rgb('92dcba')
	},

	fogShader = love.graphics.newShader(g3d.shaderpath, 'res/fog.frag'),

	font = function(self)
		return love.graphics.newFont('res/font.ttf', 13 * self.scale)
	end,

	resetColor = function(self)
		love.graphics.setColor(hex.rgb('ffffff'))
	end,

	label = function(self, input, lX, y, lAlign, lLimit, big)
		local x = 0 if lX then x = lX end
		local align = 'left' if lAlign then align = lAlign end
		local limit = g.width if lLimit then limit = lLimit end
		love.graphics.setFont(self:font())
		love.graphics.setColor(self.colors.black)
		love.graphics.printf(input, x, y + g.scale, limit, align)
		love.graphics.setColor(self.colors.greenLight)
		love.graphics.printf(input, x, y, limit, align)
		self:resetColor()
	end

}