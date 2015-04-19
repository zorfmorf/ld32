
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
    
    -- list of towers to make things easier the next time
    self.towers = {}
    
    -- fire information
    self.fire = 0
    
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
    
    if self.fire > 0 then 
        self.fire = self.fire - dt
    else
        self.collisions = nil
    end
    
    local wx = screen.w / TILE_SIZE
    local wy = screen.h / TILE_SIZE
    
    if self.x < -1 then self.x = self.x + wx + 1 end
    if self.x > wx then self.x = (self.x - wx) - 1 end
    if self.y < -1 then self.y = self.y + wy + 1 end
    if self.y > wy + 1 then self.y = (self.y - wy) - 1 end
    
    self.game:update(dt)
    if self.ai then self.ai:update(dt) end
    
    for i,villager in pairs(self.villager) do
        villager:update(dt)
    end
end


function Island:calcDrawPos(px, py)
    local tx = math.floor(self.x * TILE_SIZE) + math.floor(px * TILE_SIZE)
    local ty = math.floor(self.y * TILE_SIZE) + math.floor(py * TILE_SIZE)
    if tx > screen.w then tx = tx - screen.w - TILE_SIZE end
    if ty > screen.h then ty = ty - screen.h - TILE_SIZE end
    return tx, ty
end


function Island:drawTiles(batch)
    for i,row in pairs(self.tiles) do
        for j,entry in pairs(row) do
            if entry and entry.tile then
                local tx, ty = self:calcDrawPos(i, j)
                batch:add( quads[entry.tile[1]][entry.tile[2]], tx, ty)
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
                        end
                        
                        -- towers extra because of ai
                        if entry.object.name == "Tower" and not entry.object.counted then 
                            if self.id == 1 then FLAGS.tower = FLAGS.tower + 1 end
                            entry.object.counted = true
                            table.insert(self.towers, entry.object)
                        end
                    end
                end
                
                if toDraw then
                    local tx, ty = self:calcDrawPos(i, j)
                    batch:add( toDraw, tx, ty)
                end
            end
        end
    end
end


function Island:drawChars(batch)
    for i,vil in pairs(self.villager) do
        if not (vil.job and vil.job.name == "Mine" and vil.state == "idle") then
            local tx, ty = self:calcDrawPos(vil:getX(), vil:getY())
            batch:add(vil:getQuad(), tx, ty)
        end
    end
end


function Island:drawCollisions(batch)
    if self.collisions then
        for i,c in ipairs(self.collisions) do
            batch:add(quads[7][6], c.x - TILE_SIZE * 0.5, c.y - TILE_SIZE * 0.5)
        end
    end
end


function Island:drawLasers()
    if self.fire > 0 then
        love.graphics.setLineStyle("rough")
        love.graphics.setShader(SHADER)
        love.graphics.setLineWidth(4)
        for i,tower in ipairs(self.towers) do
            local target = self.towers[1]
            if self.towers[i+1] then target = self.towers[i+1] end
            love.graphics.setColor(Color.laser)
            local sx, sy = self:calcDrawPos(tower.loc.x + 0.5, tower.loc.y + 0.2)
            local tx, ty = self:calcDrawPos(target.loc.x + 0.5, target.loc.y + 0.2)
            love.graphics.line({sx, sy, tx, ty})
        end
        love.graphics.setLineWidth(1)
        love.graphics.setShader()
        love.graphics.setLineStyle("smooth")
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
    if self.game.res.mana >= 1 then
        self.xs = self.xs + x * I_MOV
        self.ys = self.ys + y * I_MOV
        self.game.res.mana = self.game.res.mana - 1
    end
end


function Island:destroyObject(x, y)
    local tile = self.tiles[x][y]
    local obj = tile.object
    tile.object = nil
    obj.deleted = true
    for i,v in pairs(self.villager) do
        v:deleteObj(obj)
    end
    
    if obj.name == "Farm" then
        self.game.res.food = math.max(0, self.game.res.food - 10)
    end
    
    -- inform ai about demise
    if self.ai then self.ai:lost(obj.name) end
end


function Island:doFire()
    if self.fire <= 0 and #self.towers > 1 then
        self.fire = 0.6
        self.game.res.mana = self.game.res.mana - 1
        
        -- now calculate collisions ... boah this is going to be annoying
        self.collisions = {}
        for i,tower in ipairs(self.towers) do
            local target = self.towers[1]
            if self.towers[i+1] then target = self.towers[i+1] end
            local sx, sy = self:calcDrawPos(tower.loc.x + 0.5, tower.loc.y + 0.2)
            local tx, ty = self:calcDrawPos(target.loc.x + 0.5, target.loc.y + 0.2)
            local p1 = {x=sx,y=sy}
            local p2 = {x=tx,y=ty}
            local r = TILE_SIZE * 0.5
            for index,island in pairs(map.islands) do
                if not (index == self.id) then
                    for k,row in pairs(island.tiles) do
                        for l,tile in pairs(row) do
                            if tile and tile.object and type(tile.object) == 'table' then
                                local cx, cy = island:calcDrawPos(k, l)
                                local c = {x=cx+r,y=cy+r}
                                if circleLineCollision(p1, p2, c, r) then
                                    island:destroyObject(k, l)
                                    table.insert(self.collisions, c)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
