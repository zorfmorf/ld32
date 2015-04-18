
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
local function buildbutton(build, canbuild)
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
            
            if not canbuild then love.graphics.setColor(Color.highlight_red) end
            
            love.graphics.draw(tileset, quads[build.res[1]][build.res[2]], x, y)
            love.graphics.print(title, x + TILE_SIZE, y + TILE_SIZE * 0.5 - love.graphics.getFont():getHeight() * 0.5)
            
            love.graphics.setColor(Color.white)
        end
end


local function createBuildingButton(build)
    local canbuild = game:canPay(build)
    if Gui.Button{ text = build.name, draw = buildbutton(build, canbuild) } and canbuild then game.buildtarget = build end
end


local function buildicon(amount, quad)
    return
        function(state, text, align, x,y,w,h)
            love.graphics.setColor(Color.white)
            love.graphics.draw(tileset, quad, x, y - 5)
            love.graphics.print(amount, x + TILE_SIZE + 10, y + TILE_SIZE * 0.5 - love.graphics.getFont():getHeight() * 0.5)
            
            --love.graphics.print(text, x + TILE_SIZE * 1.5, y + TILE_SIZE * 0.5 - love.graphics.getFont():getHeight() * 0.5)
        end
end


local function createResourceIcon(text, amount,  quad)
    Gui.Label{ text = text, draw = buildicon(amount, quad)}
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
    
    
    -- build ressource display
    love.graphics.setFont(font.b)
    Gui.group.push{ grow = "down", pos = {screen.w - 145, screen.h - 180}, size = {126}, bkg = true, border = true, pad = 6}
        Gui.Label{ text = "Resources" }
        createResourceIcon("Stone", game.res.stone, quads[9][0])
        createResourceIcon("Wood", game.res.wood, quads[9][2])
        createResourceIcon("Food", game.res.food, quads[9][1])
        createResourceIcon("Ore", game.res.ore, quads[9][3])
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
