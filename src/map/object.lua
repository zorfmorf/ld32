
-- simply implement all objects here, each as separate class
-- we dont not no filthy inheritance

House = Class{}

function House:init()
    self.res = {6, 0}
    self.name = "House"
    self.villager = 2
    self.cost = { wood = 2}
end


function House:onSpawn()
    
end


-- sawmill

Sawmill = Class{}

function Sawmill:init()
    self.res = {7, 1}
    self.name = "Sawmill"
    self.villager = 0
    self.cost = { stone = 2, wood = 3}
end


function Sawmill:onSpawn()
    
end


-- mason

Mason = Class{}

function Mason:init()
    self.res = {6, 1}
    self.name = "Mason"
    self.villager = 0
    self.cost = { stone = 2, wood = 3}
end


function Mason:onSpawn()
    
end