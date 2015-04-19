state_lost = {}

function state_lost:enter()
    
end


function state_lost:update(dt)
    
end


function state_lost:draw()
    local text = "You loose ..."
    local font = love.graphics.getFont()
    love.graphics.print(text, screen.w * 0.5, screen.h * 0.5, 0, 1, 1, font:getWidth(text) + 0.5, font:getHeight() * 0.5)
end
