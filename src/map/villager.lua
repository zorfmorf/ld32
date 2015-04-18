
Villager = Class{}

local quad = nil


function Villager:init(x, y)
    self.x = x
    self.y = y
    
    self.xmod = math.random() * 0.4 - 0.2
    self.ymod = math.random() * 0.4 - 0.2
    
end


function Villager:getX()
    return self.x + self.xmod
end


function Villager:getY()
    return self.y + self.ymod
end


function Villager:getQuad()
    if not quad then 
        quad = love.graphics.newQuad(TILE_SIZE * 7, 0, 2, 7, TILE_SIZE * 10, TILE_SIZE * 10)
    end
    return quad
end


function Villager:update(dt)
    -- TODO implement movement and ai
end
