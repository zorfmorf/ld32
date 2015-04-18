
Cloud = Class{}


local img = love.graphics.newImage("img/cloud.png")

-- all clouds feel the same wind!

local mx = 0.05 - math.random() * 0.1
local my = 0.05 - math.random() * 0.1


function Cloud:init(x, y)
    self.x = x
    self.y = y
end


function Cloud:update(dt)
   self.x = self.x + mx * dt
   self.y = self.y + my * dt
end


function Cloud:draw()
    love.graphics.draw(img, math.floor(self.x * TILE_SIZE), math.floor(self.y * TILE_SIZE), 0, 2, 2 )
end
