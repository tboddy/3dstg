local isShooting

local accumulator = 0
local frametime = 1/60
local rollingAverage = {}

local speed = 0.055
local friction = 0.8
local gravity = 0.0075
local jump = 0.014
local maxFallSpeed = 0.35

local jumping = false
local jumped = false

local shotInterval = 10
local shotClock = shotInterval

local shovelModel = g3d.newModel('res/shovel.obj', 'res/shovel.png', {0, 0, 0}, nil, {-1, -1, 1})


return {

	fuel = 0,
	fuelMax = 88,
	health = 100,

	addCollisionModel = function(self, model)
		table.insert(self.collisionModels, model)
		return model
	end,

	collisionTest = function(self, mx,my,mz)
		local bestLength, bx,by,bz, bnx,bny,bnz
		for _,model in ipairs(self.collisionModels) do
			local len, x,y,z, nx,ny,nz = model:capsuleIntersection(
				self.pos.x + mx,
				self.pos.y + my - 2,
				self.pos.z + mz,
				self.pos.x + mx,
				self.pos.y + my + 2,
				self.pos.z + mz,
				self.radius)
			if len and (not bestLength or len < bestLength) then
				bestLength, bx,by,bz, bnx,bny,bnz = len, x,y,z, nx,ny,nz
			end
		end
		return bestLength, bx,by,bz, bnx,bny,bnz
	end,

	moveAndSlide = function(self, mx,my,mz)
		local len,x,y,z,nx,ny,nz = self:collisionTest(mx,my,mz)
		self.pos.x = self.pos.x + mx
		self.pos.y = self.pos.y + my
		self.pos.z = self.pos.z + mz
		local ignoreSlopes = ny and ny < -0.7
		if len then
			local speedLength = math.sqrt(mx^2 + my^2 + mz^2)
			if speedLength > 0 then
				local xNorm, yNorm, zNorm = mx / speedLength, my / speedLength, mz / speedLength
				local dot = xNorm*nx + yNorm*ny + zNorm*nz
				local xPush, yPush, zPush = nx * dot, ny * dot, nz * dot
				my = (yNorm - yPush) * speedLength
				if ignoreSlopes then my = 0 end
				if not ignoreSlopes then
					mx = (xNorm - xPush) * speedLength
					mz = (zNorm - zPush) * speedLength
				end
			end
			self.pos.y = self.pos.y - ny * (len - self.radius)
			if not ignoreSlopes then
				self.pos.x = self.pos.x - nx * (len - self.radius)
				self.pos.z = self.pos.z - nz * (len - self.radius)
			end
		end
		return mx, my, mz, nx, ny, nz
	end,

	interpolate = function(self, fraction)
		for i = 1, 3 do
			if i ~= 2 then
				g3d.camera.position[i] = self.pos[i == 1 and 'x' or 'z'] + self.speed[i]*fraction
			end
		end
		g3d.camera.lookInDirection()
	end,

	updatePlayerShot = function(self)
		if love.mouse.isDown(1) and shotClock >= shotInterval then
			shotClock = 0
		end
		if shotClock == 0 then
			bullets:spawn({
				image = 'gray',
				position = {
					g3d.camera.position[1],
					g3d.camera.position[2] + 1,
					g3d.camera.position[3]
				},
				target = {
					g3d.camera.target[1],
					g3d.camera.target[2] + 1,
					g3d.camera.target[3]
				},
				speed = 80,
				player = true
			})
		end
		shotClock = shotClock + 1
		if shotClock >= g.clockLimit then shotClock = shotInterval end
	end,

	updateMovement = function(self)
		local moveX,moveY = 0,0
		self.speed[1] = self.speed[1] * friction
		self.speed[3] = self.speed[3] * friction
		if love.keyboard.isDown('w') then moveY = moveY - 1 end
		if love.keyboard.isDown('a') then moveX = moveX + 1 end
		if love.keyboard.isDown('s') then moveY = moveY + 1 end
		if love.keyboard.isDown('d') then moveX = moveX - 1 end
		local wasOnGround = self.onGround

		if love.keyboard.isDown('space') and not jumping and self.fuel > 1 and not jumped then
			jumping = true
		elseif not love.keyboard.isDown('space') and jumping then
			jumping = false
			jumped = false
		end

		if jumping and not jumped then
			if love.keyboard.isDown('space') and self.fuel > 0 then
				self.fuel = self.fuel - 3
				self.speed[2] = self.speed[2] - jump
				if self.fuel <= 1 then
					self.fuel = 0
				end
			end
			if self.fuel == 0 and wasOnGround then
				jumped = true
			end
		end

		if not jumping or (jumping and jumped) then
			if self.fuel < self.fuelMax then
				self.fuel = self.fuel + 2
				if self.fuel > self.fuelMax then self.fuel = self.fuelMax end
			end
		end

		self.speed[2] = math.min(self.speed[2] + gravity, maxFallSpeed)
		if moveX ~= 0 or moveY ~= 0 then
			local angle = math.atan2(moveY,moveX)
			local direction = g3d.camera.getDirectionPitch()
			local directionX, directionZ = math.cos(direction + angle)*speed, math.sin(direction + angle + math.pi)*speed
			self.speed[3] = self.speed[3] + directionX
			self.speed[1] = self.speed[1] + directionZ
		end

		local _, nx, ny, nz
		_, self.speed[2], _, nx, ny, nz = self:moveAndSlide(0, self.speed[2], 0)
		self.onGround = ny and ny < -0.7

		if not self.onGround and wasOnGround and self.speed[2] > 0 then
			local len,x,y,z,nx,ny,nz = self:collisionTest(0,self.stepDownSize,0)
			local mx, my, mz = 0,self.stepDownSize,0
			if len then
				self.pos.y = self.pos.y + my
				local speedLength = math.sqrt(mx^2 + my^2 + mz^2)
				if speedLength > 0 then
					local xNorm, yNorm, zNorm = mx / speedLength, my / speedLength, mz / speedLength
					local dot = xNorm*nx + yNorm*ny + zNorm*nz
					local xPush, yPush, zPush = nx * dot, ny * dot, nz * dot
					my = (yNorm - yPush) * speedLength
				end
				self.pos.y = self.pos.y - ny * (len - self.radius)
				self.speed[2] = 0
				self.onGround = true
			end
		end

		self.speed[1], _, self.speed[3], nx, ny, nz = self:moveAndSlide(self.speed[1], 0, self.speed[3])

		for i=1, 3 do
			local p = i == 1 and 'x' or 'z'
			if i == 2 then p = 'y' end
			self.lastSpeed[i] = self.speed[i]
			g3d.camera.position[i] = self.pos[p]
		end

		g3d.camera.lookInDirection()
		self:updatePlayerShot()
		-- self.pos.x = self.pos.x
		-- self.pos.y = self.pos.y
		-- self.pos.z = self.pos.z
	end,

	update = function(self)
		table.insert(rollingAverage, g.dt)
		if #rollingAverage > 60 then
			table.remove(rollingAverage, 1)
		end
		local avg = 0
		for i,v in ipairs(rollingAverage) do
			avg = avg + v
		end
		accumulator = accumulator + avg/#rollingAverage
		while accumulator > frametime do
			accumulator = accumulator - frametime
			self:updateMovement(g.dt)
		end
		self:interpolate(accumulator/frametime)

		shovelModel:setTranslation(g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3])
		shovelModel:setRotation(g3d.camera.viewMatrix[1], g3d.camera.viewMatrix[2], 0)
	end,

	draw = function(self)
		-- shovelModel:draw()
	end,

	load = function(self)
		self.fuel = self.fuelMax
		self.pos = cpml.vec3.new(0, -3, 0)
		self.speed = setmetatable({0,0,0}, {})
		self.lastSpeed = setmetatable({0,0,0}, {})
		self.normal = setmetatable({0,1,0}, {})
		self.radius = 1
		self.onGround = false
		self.stepDownSize = 0.075
		self.collisionModels = {}
		for i = 1, stage.tileCount do
			if stage.tiles[i].active and not stage.tiles[i].sky and not stage.tiles[i].prop then
				self:addCollisionModel(stage.tiles[i].model)
			end
		end
	end

}