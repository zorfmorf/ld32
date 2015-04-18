
map = {}

local tileset = love.graphics.newImage( "img/tileset.png" )


function map:init()
    self.islands = {}
    table.insert(self.islands, Island(0, 0))
    
    self.batch = love.graphics.newSpriteBatch( tileset, 10000 )
end


function map:update(dt)
    for i,island in ipairs(self.islands) do
        island:update(dt)
    end
end


function map:draw()
    
    self.batch:clear()
    for i,island in ipairs(self.islands) do
        island:drawTiles(self.batch)
    end
    love.graphics.draw(self.batch)
    
    
    self.batch:clear()
    for i,island in ipairs(self.islands) do
        island:drawObjects(self.batch)
    end
    love.graphics.draw(self.batch)
    
    
    self.batch:clear()
    for i,island in ipairs(self.islands) do
        island:drawChars(self.batch)
    end
    love.graphics.draw(self.batch)
    
end
