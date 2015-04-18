
Cloud = Class{}


local img = love.graphics.newImage("img/cloud.png")


function Cloud:init(x, y)
    self.x = x
    self.y = y
end


function Cloud:update(dt)
    
end


function Cloud:draw()
    love.graphics.draw(img, math.floor(self.x * TILE_SIZE), math.floor(self.y * TILE_SIZE), 0, 2, 2 )
end
