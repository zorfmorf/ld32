
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
    self.tiles = {}
    for i = 0, 6 do
        self.tiles[i] = {}
        for j = 0, 6 do
            self.tiles[i][j] = { tile = {1, 1}, object = nil }
            if i > 0 and i < 6 and j > 0 and j < 6 then
                if math.random(4) == 4 then self.tiles[i][j].object = {5, math.random(0, 1)} end
            end
            if i == 0 then self.tiles[i][j].tile = {0, 1} end
            if i == 6 then self.tiles[i][j].tile = {2, 1} end
            if j == 0 then self.tiles[i][j].tile = {1, 0} end
            if j == 6 then self.tiles[i][j].tile = {1, 2} end
        end
    end
    self.tiles[0][0].tile = {0, 0}
    self.tiles[6][0].tile = {2, 0}
    self.tiles[0][6].tile = {0, 2}
    self.tiles[6][6].tile = {2, 2}
    
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
                batch:add( quads[entry.object[1]][entry.object[2]],
                           math.floor(self.x * TILE_SIZE) + math.floor(i * TILE_SIZE),
                           math.floor(self.y * TILE_SIZE) + math.floor(j * TILE_SIZE))
            end
        end
    end
end


function Island:drawChars(batch)
    
end
