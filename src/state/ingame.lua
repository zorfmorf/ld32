
state_ingame = {}

Camera = require "lib.hump.camera"


function state_ingame:enter()
    game:prepareQuads()
    map:init()
    camera = Camera(600, 300)
end


function state_ingame:update(dt)
    map:update(dt)
    hud:update(dt)
end


function state_ingame:draw()
    
    love.graphics.setDefaultFilter( "nearest", "nearest" )
    map:draw()
    hud:draw()
    
end


function state_ingame:keypressed(key, isrepeat)
    gui.keyboard.pressed(key)
end


function state_ingame:mousereleased(x, y, button)
    if button == "l" and game.buildtarget then
        local mx, my = camera:mousepos()
        local result = map:place(mx, my, game.buildtarget)
        if result then game.buildtarget = nil end
    end
end
