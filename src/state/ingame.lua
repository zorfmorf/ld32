
state_ingame = {}

local drawhud = true

function state_ingame:enter()
    map:init()
    hud:init()
end


function state_ingame:update(dt)
    map:update(dt)
    if drawhud then hud:update(dt) end
    hud:fps()
end


function state_ingame:draw()
    
    love.graphics.setDefaultFilter( "nearest", "nearest" )
    map:draw()
    hud:draw()
    
end


function state_ingame:keypressed(key, isrepeat)
    Gui.keyboard.pressed(key)
    --if key == "left" then camera:move(-C_MOV, 0) end
    --if key == "right" then camera:move(C_MOV, 0) end
    --if key == "up" then camera:move(0, -C_MOV) end
    --if key == "down" then camera:move(0, C_MOV) end
    if key == "f1" then drawhud = not drawhud end
end


function state_ingame:mousereleased(x, y, button)
    
    local game = map.islands[1].game
    
    if button == "l" and game.buildtarget then
        local mx, my = love.mouse.getPosition()
        local result = map:place(mx, my, game.buildtarget)
        if result then game.buildtarget = nil end
    end
end
