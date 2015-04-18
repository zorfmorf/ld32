
local islandcounter = 0

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
                    setTile(target, i, j, { tile = {0, 0}, edge = true })
                end
                
                if empty(tiles, i-1, j) and 
                   empty(tiles, i-1, j-1) and 
                   empty(tiles, i, j-1) and
                   empty(tiles, i+1, j) and
                   empty(tiles, i, j+1) and
                   not empty(tiles, i-1, j+1) then
                    setTile(target, i, j, { tile = {2, 0}, edge = true })
                end
                
                if empty(tiles, i-1, j) and 
                   empty(tiles, i-1, j-1) and 
                   empty(tiles, i, j-1) and
                   empty(tiles, i+1, j) and
                   empty(tiles, i, j+1) and
                   not empty(tiles, i+1, j-1) then
                    setTile(target, i, j, { tile = {0, 2}, edge = true })
                end
                
                if empty(tiles, i-1, j) and 
                   empty(tiles, i+1, j+1) and 
                   empty(tiles, i, j-1) and
                   empty(tiles, i+1, j) and
                   empty(tiles, i, j+1) and
                   not empty(tiles, i-1, j-1) then
                    setTile(target, i, j, { tile = {2, 2}, edge = true })
                end
                
                if empty(tiles, i-1, j) and 
                   empty(tiles, i, j-1) and 
                   empty(tiles, i, j+1) and
                   not empty(tiles, i+1, j) then
                    setTile(target, i, j, { tile = {0, 1}, edge = true })
                end
                
                if empty(tiles, i+1, j) and 
                   empty(tiles, i, j-1) and 
                   empty(tiles, i, j+1) and
                   not empty(tiles, i-1, j) then
                    setTile(target, i, j, { tile = {2, 1}, edge = true })
                end
                
                if empty(tiles, i, j+1) and 
                   empty(tiles, i-1, j) and 
                   empty(tiles, i+1, j) and
                   not empty(tiles, i, j-1) then
                    setTile(target, i, j, { tile = {1, 2}, edge = true })
                end
                
                if empty(tiles, i, j-1) and 
                   empty(tiles, i-1, j) and 
                   empty(tiles, i+1, j) and
                   not empty(tiles, i, j+1) then
                    setTile(target, i, j, { tile = {1, 0}, edge = true })
                end
                
                if empty(tiles, i+1, j+1) and 
                   not empty(tiles, i-1, j) and 
                   not empty(tiles, i, j-1) then
                    setTile(target, i, j, { tile = {3, 0}, edge = true })
                end
                
                if empty(tiles, i-1, j+1) and 
                   not empty(tiles, i+1, j) and 
                   not empty(tiles, i, j-1) then
                    setTile(target, i, j, { tile = {4, 0}, edge = true })
                end
                
                if empty(tiles, i+1, j-1) and 
                   not empty(tiles, i-1, j) and 
                   not empty(tiles, i, j+1) then
                    setTile(target, i, j, { tile = {3, 1}, edge = true })
                end
                
                if empty(tiles, i-1, j-1) and 
                   not empty(tiles, i+1, j) and 
                   not empty(tiles, i, j+1) then
                    setTile(target, i, j, { tile = {4, 1}, edge = true })
                end
                
            end
            
            -- END: UGLY
            
        end
    end
    
    -- replace tiles
    for i,row in pairs(tiles) do
        for j,entry in pairs(row) do
            if entry == 1 then 
                tiles[i][j] = { tile = {1, 1}, object = nil, edge = false }
                local rand = math.random(0, 6)
                if rand == 0 then tiles[i][j].object = "tree" end
                if rand == 1 then tiles[i][j].object = "stone" end
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

function generateIsland()
    
    local tiles = {
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
        
    if islandcounter == 1 then
        tiles = {
            {0,0,1,1,0},
            {0,1,1,1,0},
            {0,1,1,1,1},
            {1,1,1,1,1},
            {0,1,1,0,0}
        }
    end
    
    
    fixIsland(tiles)
    
    islandcounter = islandcounter + 1
    return tiles
end