-- container for game information
game = {}


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

local function prepareResources()
    return {
        wood = 8,
        stone = 3,
        food = 10,
        ore = 0
    }
end


function game:init()
    prepareQuads()
    self.res = prepareResources()
    self.buildtarget = nil
    self.joblist = {}
end


function game:update(dt)
    
end


function game:pay(obj)
    for res,amount in pairs(obj.cost) do
        if self.res[res] then
            self.res[res] = self.res[res] - amount
        else
            print( "Invalid resource:", res, amount)
        end
    end
end


function game:canPay(obj)
    for res,amount in pairs(obj.cost) do
        return self.res[res] >= amount
    end
end


function game:onSpawn(obj)
    game:pay(obj)
    while obj.jobs > 0 do
        table.insert(self.joblist, obj)
        obj.jobs = obj.jobs - 1
    end
end


function game:getJob()
    if #self.joblist > 0 then
        return table.remove(self.joblist, math.random(1, #self.joblist))
    end
    return nil
end


function game:produce(res, amount)
    self.res[res] = self.res[res] + amount
end


function game:getFood(value)
    local output = 0
    if self.res.food > 0 then
        self.res.food = math.max(0, self.res.food - value)
        output = value
    end
    return output
end
