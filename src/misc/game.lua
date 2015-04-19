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
    --[[return {
        wood = 10 * i,
        stone = 10 * i,
        food = 10 * i,
        ore = 0,
        mana = 10
    }]]--
    return {
        wood = 100 * i,
        stone = 100 * i,
        food = 100 * i,
        ore = 100,
        mana = 100
    }
end


function Game:init(island)
    self.island = island
    if not quads then prepareQuads() end
    self.res = prepareResources(1)
    if self.island.id > 1 then self.res = prepareResources(3) end
    self.buildtarget = nil
    self.joblist = {}
    self.housequeue = {}
end


function Game:update(dt)
    
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


function Game:getFood(value)
    local output = 0
    if self.res.food > 0 then
        self.res.food = math.max(0, self.res.food - value)
        output = value
    end
    return output
end
