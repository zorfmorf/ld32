
Island = Class{}


function Island:init(x, y)
    
    -- player id
    self.owner = 1
    
    -- position
    self.x = x
    self.y = y
    
    -- create default island
    self.tiles = generateIsland()
    
    
    -- list of villagers
    self.villager = {}
    
    self.xs = math.random() * 0.2 - 0.1
    self.ys = math.random() * 0.2 - 0.1
end


function Island:getTargetList(target)
    local targets = {}
    for i,row in pairs(self.tiles) do
        for j,entry in pairs(row) do
            if entry and entry.object and entry.object == target then
                table.insert(targets, { x=i,y=j } )
            end
        end
    end
    return targets
end


function Island:update(dt)
    self.x = self.x + self.xs * dt
    self.y = self.y + self.ys * dt
    
    -- TODO: delete
    if self.x < -20 then self.x = 50 end
    if self.x > 50 then self.x = -20 end
    if self.y < -20 then self.y = 40 end
    if self.y > 40 then self.y = -20 end
    
    for i,villager in pairs(self.villager) do
        villager:update(dt)
    end
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
    for i,vil in pairs(self.villager) do
        batch:add(vil:getQuad(), 
            math.floor(self.x * TILE_SIZE) + math.floor(vil:getX() * TILE_SIZE), 
            math.floor(self.y * TILE_SIZE) + math.floor(vil:getY() * TILE_SIZE))
    end
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
        if obj.villager then
            for i=1,obj.villager do
                table.insert(self.villager, Villager(x + 0.5, y + 0.8))
            end
        end
        obj.loc = {x=x, y=y}
        obj:onSpawn(self)
        game:onSpawn(obj)
    else
        print( "Could not place object", obj.name, "at", x, y )
    end
end
