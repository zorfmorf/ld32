
Villager = Class{}

local quads = nil


function Villager:init(x, y, island)
    self.x = x
    self.y = y
    self.island = island
    
    self.hunger = math.random() * 0.02 + 0.01
    self.food = 0
    
    self.xmod = math.random() * 0.4 - 0.2
    self.ymod = math.random() * 0.4 - 0.2
    
    self.state = "idle"
    self.idle = 0 -- time idle
    self.avgIdle = math.random() * 3 -- average idle time until tries to do something
end


function Villager:getX()
    return self.x + self.xmod
end


function Villager:getY()
    return self.y + self.ymod
end


function Villager:getQuad()
    if not quads then
        quads = {}
        for i = 1,3 do
            quads[i] = {}
            quads[i].default = love.graphics.newQuad(TILE_SIZE * 7 + (i-1) * 8, 0, 4, 11, TILE_SIZE * 10, TILE_SIZE * 10)
            quads[i].hungry = love.graphics.newQuad(TILE_SIZE * 7 + (i-1) * 8 + 4, 0, 4, 11, TILE_SIZE * 10, TILE_SIZE * 10)
        end
    end
    if self.state == "idle" and self.food < 0 and not (self.job and self.job.name == "Farm") then return quads[self.island.id].hungry end
    return quads[self.island.id].default
end


function Villager:getNearestTarget(list)
    local c = { index = 0, dist = 100000}
    for i,target in pairs(list) do
        local dist = math.sqrt( math.pow(self.x - target.x, 2) + math.pow(self.y - target.y, 2) )
        if dist < c.dist then
            c.index = i
            c.dist = dist
        end
    end    
    return list[c.index], c.index
end


function Villager:update(dt)
    
    -- get food and eat something
    if self.food >= 0 then
        self.food = self.food - self.hunger * dt
    end
    if self.food <= 0 then
        self.food = self.food + self.island.game:getFood(0.1)
    end
    
    
    -- if idle wait and maybe get a job
    if self.state == "idle" then
        self.idle = self.idle + dt
        if self.idle > self.avgIdle then
            self.idle = 0
            if self.job then
                
                if self.food >= 0 or self.job.name == "Farm" then
                    self.state = "walking"
                    
                    -- if at already built farm just sit in field
                    if self.job.name == "Farm" and self.job.buildtime <= 0 then
                        self.x = self.job.loc.x + 0.6
                        self.y = self.job.loc.y + 0.5
                        self.state = "idle"
                        self.job:produce()
                        return
                    end
                    
                    -- if not at job, go to job, otherwise to jobtarget
                    if math.abs(self.job.loc.x + 0.5 - self.x) < V_CLOSE_ENOUGH and 
                        math.abs(self.job.loc.y + 0.5 - self.y) < V_CLOSE_ENOUGH then
                        
                        if self.job.buildtime > 0 then
                            
                            self.job.buildtime = self.job.buildtime - dt
                            self.idle = self.avgIdle
                            self.state = "idle"
                            
                        else
                            self.job:produce(self.tind)
                            
                            if self.job.targets then
                                self.target, self.tind = self:getNearestTarget(self.job.targets)
                            else
                                -- if farmer put on field
                                if self.job.name == "Farm" then
                                    self.x = self.job.loc.x + 0.6
                                    self.y = self.job.loc.y + 0.5
                                    self.state = "idle"
                                else
                                    self.target = self.job.loc
                                end
                            end
                        end
                    else
                        self.target = self.job.loc
                    end
                end
                
            else
                self.job = self.island.game:getJob()
                if self.job then
                    self.target = self.job.loc
                    if self.job.idle then self.avgIdle = self.job.idle end
                    self.state = "walking"
                end
            end
        end
    end
    
    -- if walking then go to target
    if self.state == "walking" then
        if not self.target then
            self.state = "idle"
            self.dir = nil
            print("Error: no target for villager", self.island.id)
        elseif math.abs(self.target.x + 0.5 - self.x) < V_CLOSE_ENOUGH and 
            math.abs(self.target.y + 0.5 - self.y) < V_CLOSE_ENOUGH then
            self.target = nil
            self.state = "idle"
            self.dir = nil
        else
            if not self.dir then 
                self.dir = { x = 0, y = 0, wx = 0, wy = 0 }
            
                -- check directions to walk to
                if self.x - self.target.x > 0 then self.dir.x = -0.5 end
                if self.x - self.target.x < 0 then self.dir.x = 0.5 end
                if self.y - self.target.y > 0 then self.dir.y = -0.5 end
                if self.y - self.target.y < 0 then self.dir.y = 0.5 end
                
                -- if both directions are set eliminate one
                if not (self.dir.x == 0) and not (self.dir.y == 0) then
                    
                    -- check if one would go over a tile in the air
                    local tx = { x = math.floor(self.x + self.dir.x), y = math.floor(self.y) }
                    local ty = { x = math.floor(self.x), y = math.floor(self.y + self.dir.y) }
                    if not self.island.tiles[tx.x] or not self.island.tiles[tx.x][tx.y] or self.island.tiles[tx.x][tx.y].edge then
                        self.dir.x = 0
                    elseif not self.island.tiles[ty.x] or not self.island.tiles[ty.x][ty.y] or self.island.tiles[ty.x][ty.y].edge then
                        self.dir.y = 0
                    else
                        -- in this case just eliminate a random one
                        if math.random(0, 1) == 0 then
                            self.dir.x = 0
                        else
                            self.dir.y = 0
                        end
                    end
                end
            end
            
            local x = self.dir.x * V_SPEED * dt
            local y = self.dir.y * V_SPEED * dt
            
            self.x = self.x + x
            self.y = self.y + y
            self.dir.wx = self.dir.wx + math.abs(x)
            self.dir.wy = self.dir.wy + math.abs(y)
            
            if self.dir.wx >= 1 or self.dir.wy >= 1 then self.dir = nil end
        end
    end
end
