-- container for game information
Game = Class{}

quads = nil

local function prepareQuads()
    quads = {}
    for i = 0,9 do
        quads[i] = {}
        for j = 0,9 do
            quads[i][j] = love.graphics.newQuad(i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE * 10, TILE_SIZE * 10)
        end
    end
end

local function prepareResources(i)
    return {
        wood = 14 * i,
        stone = 10 * i,
        food = 20,
        ore = 0,
        mana = 0
    }
end


function Game:init(island)
    self.happy = 100
    self.island = island
    if not quads then prepareQuads() end
    self.res = prepareResources(1)
    if self.island.id > 1 then self.res = prepareResources(3) end
    self.buildtarget = nil
    self.joblist = {}
    self.housequeue = {}
end


function Game:update(dt)
    
    if self.island.id == 1 then
        if self.happy <= 0 then
            Gamestate.switch(state_lost)
        end
        if map.islands[2].game.happy <= 0 and map.islands[3].game.happy <= 0 then
            Gamestate.switch(state_won)
        end
    end
    
    
    for i,house in ipairs(self.housequeue) do
        
        if house.deleted then
            table.remove(self.housequeue, i)
            i = i - 1
        else
            house.buildtime = house.buildtime - dt
            if house.buildtime < 0 then
                for i=1,house.villager do
                    table.insert(self.island.villager, Villager(house.loc.x + 0.5, house.loc.y + 0.8, self.island))
                end
                table.remove(self.housequeue, i)
                i = i - 1
            end
        end
    end
    
end


function Game:pay(obj)
    for res,amount in pairs(obj.cost) do
        if self.res[res] then
            self.res[res] = self.res[res] - amount
        else
            print( "Invalid resource:", res, amount)
        end
    end
end


function Game:canPay(obj)
    for res,amount in pairs(obj.cost) do
        if self.res[res] < amount then return false end
    end
    return true
end


function Game:onSpawn(obj)
    self:pay(obj)
    while obj.jobs > 0 do
        table.insert(self.joblist, obj)
        obj.jobs = obj.jobs - 1
    end
    
    if obj.name == "House" then
        table.insert(self.housequeue, obj)
    end
end


function Game:getJob()
    while #self.joblist > 0 do
        local job = table.remove(self.joblist, math.random(1, #self.joblist))
        if not job.deleted then
            return job
        end
    end
    return nil
end


function Game:produce(res, amount)
    self.res[res] = self.res[res] + amount
end


function Game:getFood(value, dt)
    local output = 0
    if self.res.food >= value then
        self.res.food = self.res.food - value
        output = value
    else
        self.happy = self.happy - value * HAPPY_MOD * dt
        if self.island.id > 1 then self.happy = self.happy - 5 * dt end
    end
    return output
end
