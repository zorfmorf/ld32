-- simply implement all objects here, each as separate class
-- we dont not no filthy inheritance

House = Class{}

function House:init(island)
    self.res = {6, 0}
    self.name = "House"
    self.island = island
    self.villager = 3
    self.jobs = 0
    self.buildtime = 3
    self.cost = { wood = 2}
end


function House:onSpawn()
    
end


-- sawmill

Sawmill = Class{}

function Sawmill:init(island)
    self.res = {7, 1}
    self.name = "Sawmill"
    self.island = island
    self.villager = 0
    self.cost = { stone = 2, wood = 3}
    self.jobs = 4
    self.buildtime = 4
    self.worker = {}
end


function Sawmill:onSpawn()
    self.targets = self.island:getTargetList("tree")
end


function Sawmill:produce()
    self.island.game:produce("wood", 0.8)
end


-- mason

Mason = Class{}

function Mason:init(island)
    self.res = {6, 1}
    self.name = "Mason"
    self.villager = 0
    self.island = island
    self.cost = { stone = 2, wood = 3}
    self.jobs = 5
    self.buildtime = 4
    self.worker = {}
end


function Mason:onSpawn()
    self.targets = self.island:getTargetList("stone")
end


function Mason:produce()
    
    -- actually produce
    self.island.game:produce("stone", 0.6)
end

-- farm

Farm = Class{}

function Farm:init(island)
    self.res = {6, 2}
    self.name = "Farm"
    self.villager = 0
    self.island = island
    self.cost = { stone = 0, wood = 3}
    self.jobs = 2
    self.buildtime = 4
    self.worker = {}
    self.idle = 10
end


function Farm:onSpawn()
    
end


function Farm:produce()
    self.island.game:produce("food", 1.3)
end

-- mine

Mine = Class{}

function Mine:init(island)
    self.res = {7, 2}
    self.name = "Mine"
    self.villager = 0
    self.island = island
    self.cost = { stone = 3, wood = 3}
    self.jobs = 4
    self.buildtime = 4
    self.worker = {}
    self.idle = 3
end


function Mine:onSpawn()
    
end


function Mine:produce()
    self.island.game:produce("ore", 0.4)
end

-- tower

Tower = Class{}

function Tower:init(island)
    self.res = {7, 3}
    self.name = "Tower"
    self.villager = 0
    self.island = island
    self.cost = { stone = 10, wood = 5, ore = 15}
    self.jobs = 0
    self.buildtime = 10
    self.jobs = 5
    self.worker = {}
    self.idle = 4
    self.counted = false
end


function Tower:onSpawn()
    
end


function Tower:produce()
    self.island.game:produce("mana", 0.4)
end
