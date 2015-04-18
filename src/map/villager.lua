
Villager = Class{}

local quads = nil


function Villager:init(x, y)
    self.x = x
    self.y = y
    
    self.hunger = math.random() * 0.03 + 0.01
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
        quads.default = love.graphics.newQuad(TILE_SIZE * 7, 0, 4, 11, TILE_SIZE * 10, TILE_SIZE * 10)
        quads.hungry = love.graphics.newQuad(TILE_SIZE * 7 + 4, 0, 4, 11, TILE_SIZE * 10, TILE_SIZE * 10)
    end
    if self.state == "idle" and self.food < 0 then return quads.hungry end
    return quads.default
end


function Villager:update(dt)
    -- get food and eat something
    self.food = self.food - self.hunger * dt
    if self.food <= 0 then
        self.food = self.food + game:getFood(0.1)
    end
    
    
    -- if idle wait and maybe get a job
    if self.state == "idle" then
        self.idle = self.idle + dt
        if self.idle > self.avgIdle then
            self.idle = 0
            if self.job then
                
                if self.food >= 0 then
                    self.state = "walking"
                    
                    -- if not at job, go to job, otherwise to jobtarget
                    if self.job.loc.x == math.floor(self.x) and 
                        self.job.loc.y == math.floor(self.y) then
                        self.job:produce()
                        self.target = self.job.targets[math.random(1, #self.job.targets)]
                    else
                        self.target = self.job.loc
                    end
                end
                
            else
                self.job = game:getJob()
                if self.job then
                    self.target = self.job.loc
                    self.state = "walking"
                end
            end
        end
    end
    
    -- if walking then go to target
    if self.state == "walking" then
        if self.target.x == math.floor(self.x) and 
           self.target.y == math.floor(self.y) then
            self.target = nil
            self.state = "idle"
            self.dir = nil
        else
            if not self.dir then 
                self.dir = { x = 0, y = 0, wx = 0, wy = 0 }
            
                -- check directions to walk to
                if math.floor(self.x) - self.target.x > 0 then self.dir.x = -1 end
                if math.floor(self.x) - self.target.x < 0 then self.dir.x = 1 end
                if math.floor(self.y) - self.target.y > 0 then self.dir.y = -1 end
                if math.floor(self.y) - self.target.y < 0 then self.dir.y = 1 end
                
                -- if both directions are set eliminate a random one
                if not (self.dir.x == 0) and not (self.dir.y == 0) then
                    if math.random(0, 1) == 0 then
                        self.dir.x = 0
                    else
                        self.dir.y = 0
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
