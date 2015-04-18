-- simply implement all objects here, each as separate class
-- we dont not no filthy inheritance

House = Class{}

function House:init()
    self.res = {6, 0}
    self.name = "House"
    self.villager = 2
    self.jobs = 0
    self.cost = { wood = 2}
end


function House:onSpawn(island)
    
end


-- sawmill

Sawmill = Class{}

function Sawmill:init()
    self.res = {7, 1}
    self.name = "Sawmill"
    self.villager = 0
    self.cost = { stone = 2, wood = 3}
    self.jobs = 4
    self.worker = {}
end


function Sawmill:onSpawn(island)
    self.targets = island:getTargetList("tree")
end


function Sawmill:produce()
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
    self.worker = {}
end


function Mason:onSpawn(island)
    self.targets = island:getTargetList("stone")
end


function Mason:produce()
    game:produce("stone", 0.1)
end
