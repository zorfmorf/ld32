
hud = {}

local delta = 0
local font = nil
local text = "Implementing enemy ai"
local tileset = love.graphics.newImage("img/tileset.png")

local game = nil

function hud:init()
    font = {
        h = love.graphics.newFont("font/SFPixelate.ttf", 30),
        b = love.graphics.newFont("font/SFPixelate.ttf", 20)
    }
    
    game = map.islands[1].game
    
    -- overwrite of default style
    Gui.core.style.color.normal.fg = Color.white
    
    -- save build buildings to reduce memory issue
    self.build = {
        house = House(map.islands[1]),
        sawmill = Sawmill(map.islands[1]),
        mason = Mason(map.islands[1]),
        farm = Farm(map.islands[1]),
        mine = Mine(map.islands[1]),
        tower = Tower(map.islands[1])
    }
    
    self.checkbuildable = 1
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
            
            if not canbuild then love.graphics.setColor(Color.inactive) end
            
            love.graphics.draw(tileset, quads[build.res[1]][build.res[2]], x, y)
            love.graphics.print(title, x + TILE_SIZE, y + TILE_SIZE * 0.5 - love.graphics.getFont():getHeight() * 0.5)
            
            love.graphics.setColor(Color.white)
        end
end


local function createBuildingButton(build)
    if Gui.Button{ text = build.name, draw = buildbutton(build, build.buildable) } and build.buildable then
        if build.name == "House" then game.buildtarget = House(map.islands[1]) end
        if build.name == "Sawmill" then game.buildtarget = Sawmill(map.islands[1]) end
        if build.name == "Mason" then game.buildtarget = Mason(map.islands[1]) end
        if build.name == "Farm" then game.buildtarget = Farm(map.islands[1]) end
        if build.name == "Mine" then game.buildtarget = Mine(map.islands[1]) end
        if build.name == "Tower" then game.buildtarget = Tower(map.islands[1]) end
    end
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
    Gui.Label{ text = text, draw = buildicon(math.floor(amount), quad)}
end


function hud:update(dt)
    
    self.checkbuildable = self.checkbuildable - dt
    
    if self.checkbuildable < 0 then
        self.checkbuildable = 1
        for i, build in pairs(self.build) do
            build.buildable = game:canPay(build)
        end
    end
    
    
    delta = delta + dt
    
    Gui.group.push{ grow = "down"}
    
        -- build toolbar
        love.graphics.setFont(font.b)
        Gui.group.push{ grow = "down", pos = {screen.w - 145, 80}, size = {126}}
            Gui.Label{ text = "Buildmenu" }
            createBuildingButton(self.build.house)
            if FLAGS.house then createBuildingButton(self.build.farm) end
            if FLAGS.farm then createBuildingButton(self.build.sawmill) end
            if FLAGS.sawmill then createBuildingButton(self.build.mason) end
            if FLAGS.mason then createBuildingButton(self.build.mine) end
            if FLAGS.mine then createBuildingButton(self.build.tower) end
        Gui.group.pop{}
        
        
        -- build ressource display
        Gui.group.push{ grow = "down", pos = {screen.w - 145, 100}, size = {126}}
            Gui.Label{ text = "Resources" }
            createResourceIcon("Stone", game.res.stone, quads[9][0])
            createResourceIcon("Wood", game.res.wood, quads[9][2])
            createResourceIcon("Food", game.res.food, quads[9][1])
            createResourceIcon("Ore", game.res.ore, quads[9][3])
            if FLAGS.tower then createResourceIcon("Mana", game.res.mana, quads[9][4]) end
        Gui.group.pop{}
        
    Gui.group.pop{}
    
    -- current message of the day
    love.graphics.setFont(font.h)
    Gui.Label{ text = text, pos = {100, 20} }
end


function hud:fps()
    love.graphics.setFont(font.h)
    Gui.Label{ text = "FPS: "..love.timer.getFPS(), pos = {screen.w - 150, 20}}
end


function hud:draw()
    love.graphics.setColor(Color.white)
    Gui.core.draw()
end
