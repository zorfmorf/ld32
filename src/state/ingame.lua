
state_ingame = {}

Camera = require "lib.hump.camera"

local font = love.graphics.newFont("font/SFPixelate.ttf", 30)
local delta = 0
local text = "Currently Implementing tile selection"

function state_ingame:enter()
    map:init()
    camera = Camera(600, 300)
end


function state_ingame:update(dt)
    map:update(dt)
    delta = delta + dt
end


function state_ingame:draw()
    
    love.graphics.setDefaultFilter( "nearest", "nearest" )
    
    map:draw()
    
    love.graphics.setFont(font)
    local toprint = text
    if math.floor(delta * 2) % 4 == 1 then toprint = toprint .. "." end
    if math.floor(delta * 2) % 4 == 2 then toprint = toprint .. ".." end
    if math.floor(delta * 2) % 4 == 3 then toprint = toprint .. "..." end
    love.graphics.print(toprint, 100, 20)
    
end


function state_ingame:mousepressed(x, y, button)
    if button == "l" then
        local mx, my = camera:mousepos()
        local result = map:place(mx, my, House())
    end
end
