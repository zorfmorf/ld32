
map = {}

local tileset = love.graphics.newImage( "img/tileset.png" )
local cloudbkg = love.graphics.newImage( "img/cloudbkg.png" )


function map:init()
    self.time = 0
    self.islands = {}
    table.insert(self.islands, Island(1, 2, #self.islands + 1))
    table.insert(self.islands, Island(12, 10, #self.islands + 1))
    table.insert(self.islands, Island(16, 1, #self.islands + 1))
    
    local h = House()
    h.buildtime = 0
    self.islands[1]:placeObject(6, 5, h)
    
    self.clouds = {}
    table.insert(self.clouds, Cloud(3, 3))
    table.insert(self.clouds, Cloud(20, 10))
    table.insert(self.clouds, Cloud(6, 10))
    
    self.batch = love.graphics.newSpriteBatch( tileset, 1000 )
end


function map:update(dt)
    self.time = self.time + dt
    for i,island in ipairs(self.islands) do
        island:update(dt)
    end
    
    self.clouds[math.random(1, #self.clouds)]:update(dt)
end


function map:draw()
    
    love.graphics.draw(cloudbkg)
    
    for i,island in ipairs(self.islands) do
        
        -- draw tiles
        self.batch:clear()
        island:drawTiles(self.batch)
        love.graphics.draw(self.batch)
        
        -- draw mouse highlight
        if island.game.buildtarget and i == 1 then
            local mx, my = love.mouse.getPosition()
            local tile, tx, ty = island:getTile(mx, my)
            if tile then
                love.graphics.setColor(Color.highlight_green)
                if tile.object or tile.edge then love.graphics.setColor(Color.highlight_red) end
                love.graphics.rectangle("fill", math.floor((island.x + tx) * TILE_SIZE), math.floor((island.y + ty) * TILE_SIZE), TILE_SIZE, TILE_SIZE)
            end
            love.graphics.setColor(Color.white)
        end
        
        -- draw objects
        self.batch:clear()
        island:drawObjects(self.batch)
        love.graphics.draw(self.batch)
        
        -- draw characters
        self.batch:clear()
        island:drawChars(self.batch)
        love.graphics.draw(self.batch)
        
    end
    
    -- now draw lasers if any
    SHADER:send("time", self.time)
    for i,island in ipairs(self.islands) do
        self.batch:clear()
        island:drawCollisions(self.batch)
        love.graphics.draw(self.batch)
        island:drawLasers()
    end
    
    for i,cloud in ipairs(self.clouds) do
        love.graphics.setColor(Color.white)
        cloud:draw()
    end
    
end


function map:getTile(x, y)
    
    for i=#self.islands,1,-1 do
        local tile = self.islands[i]:getTile(x, y)
        if tile then
            return tile
        end
    end
    
    return nil
end


function map:place(x, y, obj)
    for i=1,1 do --#self.islands,1,-1 do
        local tile, tx, ty = self.islands[i]:getTile(x, y)
        if tile and not tile.edge and not tile.object then
            self.islands[i]:placeObject(tx, ty, obj)
            return true
        end
    end
    return false
end
