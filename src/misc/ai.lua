
-- TODO
Ai = Class{}

function Ai:init(island)
    self.island = island
    self.timer = 0
    self.incr = 2 + math.random() * 3
    self.build = nil
    self.builds = {
        house = math.random(2, 4),
        farm = math.random(2, 3),
        mason = math.random(1, 3),
        mine = math.random(1, 2),
        sawmill = math.random(1, 2),
        tower = math.random(1, 2)
    }
    -- hack so that the small island has a chance
    if self.island.id == 2 then
        self.builds.mason = 1
        self.builds.sawmill = 1
    end
end


function Ai:calcFreeTile(tries)
    while tries > 0 do
        tries = tries - 1
        local x = math.random(1, self.island.xmax)
        local y = math.random(1, self.island.ymax)
        if self.island.tiles[x] and self.island.tiles[x][y] then
            if not (self.island.tiles[x][y].object or self.island.tiles[x][y].edge ) then
                return {x=x, y=y}
            end
        end
    end
    return nil
end


function Ai:planBuild()
    if self.builds.house > 0 or #self.island.game.joblist > 1 then
        self.build = House(self.island)
        self.builds.house = self.builds.house - 1
    elseif self.builds.farm > 0 or self.island.game.res.food < 1 then
        self.build = Farm(self.island)
        self.builds.farm = self.builds.farm - 1
    elseif self.builds.sawmill > 0 then
        self.build = Sawmill(self.island)
        self.builds.sawmill = self.builds.sawmill - 1
    elseif self.builds.mason > 0 then
        self.build = Mason(self.island)
        self.builds.mason = self.builds.mason - 1
    elseif self.builds.mine > 0 then
        self.build = Mine(self.island)
        self.builds.mine = self.builds.mine - 1
    elseif self.builds.tower > 0 then
        self.build = Tower(self.island)
        self.builds.tower = self.builds.tower - 1
    else
        local v = math.random(1, 6)
        local iter = 1
        for build,a in pairs(self.builds) do
            if iter == v then
                self.builds[build] = 1
                return
            end            
            iter = iter + 1
        end
    end
end


function Ai:decide()
    if self.build then
        if self.island.game:canPay(self.build) then
            local t = self:calcFreeTile(30)
            if t then
                self.island:placeObject(t.x, t.y, self.build)
                self.build = nil
            end
        end
    else
        self:planBuild()
    end
end


function Ai:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.incr then
        self.timer = 0
        self:decide()
    end
end