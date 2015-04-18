
Cloud = Class{}


local img = love.graphics.newImage("img/cloud.png")

-- all clouds feel the same wind!

local mx = 0.1 - math.random() * 0.2
local my = 0.1 - math.random() * 0.2


function Cloud:init(x, y)
    self.x = x
    self.y = y
end


function Cloud:update(dt)
   self.x = self.x + mx * dt
   self.y = self.y + my * dt
   
   -- TODO: delete
    if self.x < -30 then self.x = 60 end
    if self.x > 60 then self.x = -30 end
    if self.y < -30 then self.y = 40 end
    if self.y > 40 then self.y = -30 end
end


function Cloud:draw()
    love.graphics.draw(img, math.floor(self.x * TILE_SIZE), math.floor(self.y * TILE_SIZE), 0, 2, 2 )
end
