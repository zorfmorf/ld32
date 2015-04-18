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
        food = 2,
        ore = 1
    }
end


function game:init()
    prepareQuads()
    self.res = prepareResources()
    self.buildtarget = nil
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
