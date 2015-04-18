
state_ingame = {}

Camera = require "lib.hump.camera"


function state_ingame:enter()
    game:init()
    map:init()
    camera = Camera(600, 300)
end


function state_ingame:update(dt)
    game:update(dt)
    map:update(dt)
    hud:update(dt)
end


function state_ingame:draw()
    
    love.graphics.setDefaultFilter( "nearest", "nearest" )
    map:draw()
    hud:draw()
    
end


function state_ingame:keypressed(key, isrepeat)
    Gui.keyboard.pressed(key)
    if key == "left" then camera:move(-C_MOV, 0) end
    if key == "right" then camera:move(C_MOV, 0) end
    if key == "up" then camera:move(0, -C_MOV) end
    if key == "down" then camera:move(0, C_MOV) end
end


function state_ingame:mousereleased(x, y, button)
    if button == "l" and game.buildtarget then
        local mx, my = camera:mousepos()
        local result = map:place(mx, my, game.buildtarget)
        if result then game.buildtarget = nil end
    end
end
