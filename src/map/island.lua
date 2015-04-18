
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


local function setTile(tiles, x, y, value)
    if not tiles[x] then tiles[x] = {} end
    if not tiles[x][y] then tiles[x][y] = {} end
    tiles[x][y] = value
end

local function empty(tiles, x, y)
    if tiles and tiles[x] and tiles[x][y] and not (tiles[x][y] == 0) then return false end
    return true
end


-- create nice border around tiles
local function fixIsland(tiles)
    local target = {}
    
    -- prepare targets
    for i = 0, #tiles + 1 do
        for j = 0, #tiles[1] + 1 do
            
            -- BEGIN: UGLY
            
            if empty(tiles, i, j) then
                
                if empty(tiles, i-1, j) and 
                   empty(tiles, i-1, j-1) and 
                   empty(tiles, i, j-1) and
                   empty(tiles, i+1, j) and
                   empty(tiles, i, j+1) and
                   not empty(tiles, i+1, j+1) then
                    setTile(target, i, j, { tile = {0, 0} })
                end
                
                if empty(tiles, i-1, j) and 
                   empty(tiles, i-1, j-1) and 
                   empty(tiles, i, j-1) and
                   empty(tiles, i+1, j) and
                   empty(tiles, i, j+1) and
                   not empty(tiles, i-1, j+1) then
                    setTile(target, i, j, { tile = {2, 0} })
                end
                
                if empty(tiles, i-1, j) and 
                   empty(tiles, i-1, j-1) and 
                   empty(tiles, i, j-1) and
                   empty(tiles, i+1, j) and
                   empty(tiles, i, j+1) and
                   not empty(tiles, i+1, j-1) then
                    setTile(target, i, j, { tile = {0, 2} })
                end
                
                if empty(tiles, i-1, j) and 
                   empty(tiles, i+1, j+1) and 
                   empty(tiles, i, j-1) and
                   empty(tiles, i+1, j) and
                   empty(tiles, i, j+1) and
                   not empty(tiles, i-1, j-1) then
                    setTile(target, i, j, { tile = {2, 2} })
                end
                
                if empty(tiles, i-1, j) and 
                   empty(tiles, i, j-1) and 
                   empty(tiles, i, j+1) and
                   not empty(tiles, i+1, j) then
                    setTile(target, i, j, { tile = {0, 1} })
                end
                
                if empty(tiles, i+1, j) and 
                   empty(tiles, i, j-1) and 
                   empty(tiles, i, j+1) and
                   not empty(tiles, i-1, j) then
                    setTile(target, i, j, { tile = {2, 1} })
                end
                
                if empty(tiles, i, j+1) and 
                   empty(tiles, i-1, j) and 
                   empty(tiles, i+1, j) and
                   not empty(tiles, i, j-1) then
                    setTile(target, i, j, { tile = {1, 2} })
                end
                
                if empty(tiles, i, j-1) and 
                   empty(tiles, i-1, j) and 
                   empty(tiles, i+1, j) and
                   not empty(tiles, i, j+1) then
                    setTile(target, i, j, { tile = {1, 0} })
                end
                
                if empty(tiles, i+1, j+1) and 
                   not empty(tiles, i-1, j) and 
                   not empty(tiles, i, j-1) then
                    setTile(target, i, j, { tile = {3, 0} })
                end
                
                if empty(tiles, i-1, j+1) and 
                   not empty(tiles, i+1, j) and 
                   not empty(tiles, i, j-1) then
                    setTile(target, i, j, { tile = {4, 0} })
                end
                
                if empty(tiles, i+1, j-1) and 
                   not empty(tiles, i-1, j) and 
                   not empty(tiles, i, j+1) then
                    setTile(target, i, j, { tile = {3, 1} })
                end
                
                if empty(tiles, i-1, j-1) and 
                   not empty(tiles, i+1, j) and 
                   not empty(tiles, i, j+1) then
                    setTile(target, i, j, { tile = {4, 1} })
                end
                
            end
            
            -- END: UGLY
            
        end
    end
    
    -- replace tiles
    for i,row in pairs(tiles) do
        for j,entry in pairs(row) do
            if entry == 1 then 
                tiles[i][j] = { tile = {1, 1}, object = nil }
                local rand = math.random(0, 7)
                if rand == 0 then tiles[i][j].object = "tree" end
                if rand == 1 then tiles[i][j].object = "stone" end
                if rand == 2 then tiles[i][j].object = "house" end
            end
        end
    end
    
    -- now apply targes
    for i,row in pairs(target) do
        for j, entry in pairs(row) do
            setTile(tiles, i, j, entry)
        end
    end
    
    -- now remove obsolete zeros
    for i,row in pairs(tiles) do
        for j,entry in pairs(row) do
            if entry == 0 then tiles[i][j] = nil end
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
    self.tiles = {
            { 0,0,0,1,1,1,0,0,0 },
            { 0,1,1,1,1,1,1,0,0 },
            { 0,1,1,1,1,1,1,0,0 },
            { 1,1,1,1,1,1,1,0,0 },
            { 1,1,1,1,1,1,1,1,0 },
            { 0,1,1,1,1,1,1,1,1 },
            { 0,0,1,1,1,1,1,1,1 },
            { 0,0,1,1,1,1,1,1,0 },
            { 0,0,0,0,1,1,0,0,0 } 
        }
    fixIsland(self.tiles)
    
    self.xs = 0.1
    self.ys = 0.2
end


function Island:update(dt)
    self.x = self.x + self.xs * dt
    self.y = self.y + self.ys * dt
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
                local toDraw = quads[5][1]
                
                if entry.object == "house" then toDraw = quads[6][0] end
                if entry.object == "stone" then toDraw = quads[5][0] end
                
                batch:add( toDraw,
                           math.floor(self.x * TILE_SIZE) + math.floor(i * TILE_SIZE),
                           math.floor(self.y * TILE_SIZE) + math.floor(j * TILE_SIZE))
            end
        end
    end
end


function Island:drawChars(batch)
    
end
