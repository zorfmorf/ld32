
state_ingame = {}

local drawhud = true

local loop1 = love.audio.newSource("audio/loop.ogg")
local loop2 = love.audio.newSource("audio/loop2.ogg")

function state_ingame:enter()
    map:init()
    hud:init()
    loop1:setLooping(true)
    loop1:play()
end


function state_ingame:update(dt)
    map:update(dt)
    if drawhud then hud:update(dt) end
    if false then hud:fps() end
    
    if loop1:isPlaying() then
        for i,island in pairs(map.islands) do
            if #island.towers > 1 then
                loop1:stop()
                loop2:setLooping(true)
                loop2:play()
                return
            end
        end
    end
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
