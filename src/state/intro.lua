state_intro = {}

local pressed = false
local tut1 = love.graphics.newImage("img/tutorial1.png")
local tut2 = love.graphics.newImage("img/tutorial2.png")

function state_intro:enter()
    
end


function state_intro:update(dt)
    
end


function state_intro:draw()
    if pressed then
        love.graphics.draw(tut1)
    else
        love.graphics.draw(tut2)
    end
end

function state_intro:keypressed(key, isrepeat)
    if not isrepeat then
        if pressed then
            Gamestate.switch(state_ingame)
        else
            pressed = true
        end
    end
end
