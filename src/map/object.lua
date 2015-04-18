-- simply implement all objects here, each as separate class
-- we dont not no filthy inheritance

House = Class{}

function House:init()
    self.res = {6, 0}
    self.name = "House"
    self.villager = 3
    self.jobs = 0
    self.buildtime = 3
    self.cost = { wood = 2}
end


function House:onSpawn(island)
    FLAGS.house = true
end


-- sawmill

Sawmill = Class{}

function Sawmill:init()
    self.res = {7, 1}
    self.name = "Sawmill"
    self.villager = 0
    self.cost = { stone = 2, wood = 3}
    self.jobs = 4
    self.buildtime = 5
    self.worker = {}
end


function Sawmill:onSpawn(island)
    self.targets = island:getTargetList("tree")
    FLAGS.sawmill = true
end


function Sawmill:produce(tind)
    game:produce("wood", 0.1)
end


-- mason

Mason = Class{}

function Mason:init()
    self.res = {6, 1}
    self.name = "Mason"
    self.villager = 0
    self.cost = { stone = 2, wood = 3}
    self.jobs = 5
    self.buildtime = 5
    self.worker = {}
end


function Mason:onSpawn(island)
    FLAGS.mason = true
    self.targets = island:getTargetList("stone")
end


function Mason:produce(tind)
    
    -- handle resource usage
    if tind then
        
        -- TODO Fix and/or implement
        if false and amount > 0 and self.tind then
            local tile = map.islands[self.job.island][self.target.x][self.target.y]
            if tile and tile.amount then
                tile.amount = tile.amount - amount
            end
            self.tind = nil
        end
    end
    
    -- actually produce
    game:produce("stone", 0.1)
end

-- farm

Farm = Class{}

function Farm:init()
    self.res = {6, 2}
    self.name = "Farm"
    self.villager = 0
    self.cost = { stone = 1, wood = 3}
    self.jobs = 2
    self.buildtime = 5
    self.worker = {}
    self.idle = 10
end


function Farm:onSpawn(island)
    FLAGS.farm = true
end


function Farm:produce()
    game:produce("food", 1)
end

-- mine

Mine = Class{}

function Mine:init()
    self.res = {7, 2}
    self.name = "Mine"
    self.villager = 0
    self.cost = { stone = 3, wood = 3}
    self.jobs = 4
    self.buildtime = 5
    self.worker = {}
    self.idle = 3
end


function Mine:onSpawn(island)
    FLAGS.mine = true
end


function Mine:produce()
    game:produce("ore", 0.1)
end
