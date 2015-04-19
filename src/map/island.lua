
Island = Class{}


function Island:init(x, y, id)
    
    self.id = id
    
    -- game
    self.game = Game(self)
    
    -- ai if necessary
    self.ai = nil
    if self.id > 1 then self.ai = Ai(self) end
    
    -- position
    self.x = x
    self.y = y
    
    -- create default island
    self.tiles = generateIsland()
    
    -- find max values
    self:calcMax()
    
    -- list of villagers
    self.villager = {}
    
    self.xs = 0--math.random() * 0.1 - 0.05
    self.ys = 0--math.random() * 0.1 - 0.05
end


function Island:calcMax()
    self.xmax = 0
    self.ymax = 0
    for i,row in pairs(self.tiles) do
        for j,entry in pairs(row) do
            if entry then
                self.xmax = math.max(self.xmax, i)
                self.ymax = math.max(self.ymax, j)
            end
        end
    end
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
    
    self.game:update(dt)
    if self.ai then self.ai:update(dt) end
    
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
                    if entry.object.buildtime > 0 then
                        toDraw = quads[6][3]
                    else
                        if self.id == 1 then
                            -- set finished build flags
                            if entry.object.name == "Sawmill" then FLAGS.sawmill = true end
                            if entry.object.name == "House" then FLAGS.house = true end 
                            if entry.object.name == "Mason" then FLAGS.mason = true end
                            if entry.object.name == "Farm" then FLAGS.farm = true end
                            if entry.object.name == "Mine" then FLAGS.mine = true end
                            if entry.object.name == "Tower" then FLAGS.tower = true end
                        end
                    end
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
        if not (vil.job and vil.job.name == "Mine" and vil.state == "idle") then
            batch:add(vil:getQuad(), 
                math.floor(self.x * TILE_SIZE) + math.floor(vil:getX() * TILE_SIZE), 
                math.floor(self.y * TILE_SIZE) + math.floor(vil:getY() * TILE_SIZE))
        end
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
        obj.loc = {x=x, y=y}
        obj:onSpawn(self)
        obj.islandId = self.id
        self.game:onSpawn(obj, self)
        if self.id == 1 then hud.checkbuildable = -1 end
    else
        print( "Could not place object", obj.name, "at", x, y )
    end
end


function Island:move(x, y)
    if self.game.res.mana > 0 then
        self.xs = self.xs + x * I_MOV
        self.ys = self.ys + y * I_MOV
        self.game.res.mana = self.game.res.mana - 1
    end
end
