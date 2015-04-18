
hud = {}

local delta = 0
local font = nil
local text = "Implementing buildings and resources"
local tileset = love.graphics.newImage("img/tileset.png")

function hud:init()
    font = {
        h = love.graphics.newFont("font/SFPixelate.ttf", 30),
        b = love.graphics.newFont("font/SFPixelate.ttf", 20)
    }
end


-- custom button draw function
local function buildbutton(build)
    return 
        function (state, title, x,y,w,h)
            
            love.graphics.setColor(Color.white)
            
            -- states: normal, hot, active
            if state == "active" then
                love.graphics.setColor(Color.highlight_green)
            end
            
            if game.buildtarget and game.buildtarget.name == build.name then
                love.graphics.rectangle("line", x, y, w, h)
            end
            
            love.graphics.draw(tileset, quads[build.res[1]][build.res[2]], x, y)
            love.graphics.print(title, x + TILE_SIZE, y + TILE_SIZE * 0.5 - love.graphics.getFont():getHeight() * 0.5)
            
            love.graphics.setColor(Color.white)
        end
end


local function createBuildingButton(build)
    if Gui.Button{ text = build.name, draw = buildbutton(build) } then game.buildtarget = build end
end


function hud:update(dt)
    
    delta = delta + dt
    
    -- build toolbar
    love.graphics.setFont(font.b)
    Gui.group.push{ grow = "down", pos = {screen.w - 145, 80}, size = {126}, bkg = true, border = true, pad = 6}
        Gui.Label{ text = "Buildmenu" }
        createBuildingButton(House())
        createBuildingButton(Sawmill())
        createBuildingButton(Mason())
    Gui.group.pop{}
    
    -- current message of the day
    love.graphics.setFont(font.h)
    local toprint = text
    if math.floor(delta * 2) % 4 == 1 then toprint = toprint .. "." end
    if math.floor(delta * 2) % 4 == 2 then toprint = toprint .. ".." end
    if math.floor(delta * 2) % 4 == 3 then toprint = toprint .. "..." end
    Gui.Label{ text = toprint, pos = {100, 20} }
end


function hud:draw()
    love.graphics.setColor(Color.white)
    Gui.core.draw()
end
