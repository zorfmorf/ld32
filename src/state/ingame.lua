
state_ingame = {}


function state_ingame:enter()
    map:init()
end


function state_ingame:update(dt)
    map:update(dt)
end


function state_ingame:draw()
    
    love.graphics.scale()
    map:draw()
    
end
