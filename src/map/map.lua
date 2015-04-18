
map = {}

local tileset = love.graphics.newImage( "img/tileset.png" )
local cloudbkg = love.graphics.newImage( "img/cloudbkg.png" )


function map:init()
    self.islands = {}
    table.insert(self.islands, Island(5, 2))
    table.insert(self.islands, Island(18, 10))
    
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
    
    self.clouds[math.random(1, #self.clouds)]:update(dt)
end


function map:draw()
    
    love.graphics.draw(cloudbkg)
    
    
    for i,island in ipairs(self.islands) do
        
        self.batch:clear()
        island:drawTiles(self.batch)
        love.graphics.draw(self.batch)
        
        self.batch:clear()
        island:drawObjects(self.batch)
        love.graphics.draw(self.batch)
        
        self.batch:clear()
        island:drawChars(self.batch)
        love.graphics.draw(self.batch)
        
    end
    
    for i,cloud in ipairs(self.clouds) do
        cloud:draw()
    end
    
end
