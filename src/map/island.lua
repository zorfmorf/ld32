
Island = Class{}

local quads = nil


local function prepareQuads()
    quads = {}
    for i = 0,9 do
        quads[i] = {}
        for j = 0,9 do
            quads[i][j] = love.graphics.newQuad(i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE * 10, TILE_SIZE * 10)
        end
    end
end


function Island:init(x, y)
    
    if not quads then prepareQuads() end
    
    -- player id
    self.owner = 1
    
    -- position
    self.x = x
    self.y = y
    
    -- create default island
    self.tiles = generateIsland()
    
    self.xs = math.random() * 0.4 - 0.2
    self.ys = math.random() * 0.4 - 0.2
end


function Island:update(dt)
    self.x = self.x + self.xs * dt
    self.y = self.y + self.ys * dt
    
    -- TODO: delete
    if self.x < -30 then self.x = 60 end
    if self.x > 60 then self.x = -30 end
    if self.y < -30 then self.y = 40 end
    if self.y > 40 then self.y = -30 end
end


function Island:drawTiles(batch)
    for i,row in pairs(self.tiles) do
        for j,entry in pairs(row) do
            if entry and entry.tile then
                batch:add( quads[entry.tile[1]][entry.tile[2]],
                           math.floor(self.x * TILE_SIZE) + math.floor(i * TILE_SIZE),
                           math.floor(self.y * TILE_SIZE) + math.floor(j * TILE_SIZE))
            end
        end
    end
end


function Island:drawObjects(batch)
    for i,row in pairs(self.tiles) do
        for j,entry in pairs(row) do
            if entry and entry.object then
                
                -- defaults to tree
                local toDraw = nil
                
                if entry.object == "tree" then toDraw = quads[5][1] end
                if entry.object == "stone" then toDraw = quads[5][0] end
                
                -- okay its an actual object
                if not toDraw and entry.object then
                    toDraw = quads[entry.object.res[1]][entry.object.res[2]]
                end
                
                if toDraw then
                    batch:add( toDraw,
                           math.floor(self.x * TILE_SIZE) + math.floor(i * TILE_SIZE),
                           math.floor(self.y * TILE_SIZE) + math.floor(j * TILE_SIZE))
                end
            end
        end
    end
end


function Island:drawChars(batch)
    
end


function Island:getTile(x, y)
    local tx = math.floor(x / TILE_SIZE - self.x)
    local ty = math.floor(y / TILE_SIZE - self.y)
    if self.tiles[tx] and self.tiles[tx][ty] then
        return self.tiles[tx][ty], tx, ty
    end
    return nil
end


function Island:placeObject(x, y, obj)
    if self.tiles[x] and self.tiles[x][y] then
        self.tiles[x][y].object = obj
        obj:onSpawn()
    else
        print( "Could not place object", obj.name, "at", x, y )
    end
end
