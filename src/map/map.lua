
map = {}

local tileset = love.graphics.newImage( "img/tileset.png" )
local cloudbkg = love.graphics.newImage( "img/cloudbkg.png" )


function map:init()
    self.islands = {}
    table.insert(self.islands, Island(5, 2))
    
    self.clouds = {}
    table.insert(self.clouds, Cloud(3, 3))
    table.insert(self.clouds, Cloud(20, 10))
    table.insert(self.clouds, Cloud(6, 10))
    
    self.batch = love.graphics.newSpriteBatch( tileset, 10000 )
end


function map:update(dt)
    for i,island in ipairs(self.islands) do
        island:update(dt)
    end
end


function map:draw()
    
    love.graphics.draw(cloudbkg)
    
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
    
    
    for i,cloud in ipairs(self.clouds) do
        cloud:draw()
    end
    
end
