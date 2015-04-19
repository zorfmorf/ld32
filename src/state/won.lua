
state_won = {}

function state_won:enter()
    
end


function state_won:update(dt)
    
end


function state_won:draw()
    local text = "You won!"
    local font = love.graphics.getFont()
    love.graphics.print(text, screen.w * 0.5, screen.h * 0.5, 0, 1, 1, font:getWidth(text) + 0.5, font:getHeight() * 0.5)
end

