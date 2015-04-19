
hud = {}

local delta = 0
local font = nil
local tileset = love.graphics.newImage("img/tileset.png")

local game = nil

function hud:init()
    
    self.helpdt = 0
    
    self.help = nil
    
    font = {
        h = love.graphics.newFont("font/SFPixelate.ttf", 30),
        b = love.graphics.newFont("font/SFPixelate.ttf", 20)
    }
    
    game = map.islands[1].game
    
    self.buttonquad = love.graphics.newQuad(6 * TILE_SIZE, 7 * TILE_SIZE, TILE_SIZE * 2, TILE_SIZE * 2, tileset:getWidth(), tileset:getHeight())
    
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
            
            if state == "hot" and not (build.name == "House") and not canbuild then
                love.graphics.print("Costs:", x - 120, y)
                local i = 1
                for res,amount in pairs(build.cost) do
                    love.graphics.print(tostring(amount).." "..res, x - 120, y + i * TILE_SIZE)
                    i = i + 1
                end
            end
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
    Gui.Label{ text = text, draw = buildicon(math.floor(amount * 10) * 0.1, quad)}
end


local function createMoveButton(text, quad)
    if Gui.Button{text = text, size = { "tight" },
        draw = function(state, title, x,y,w,h)
                love.graphics.setColor(Color.white)
                if not (state == "normal") then
                    love.graphics.setColor(Color.highlight_green)
                end
                if game.res.mana < 1 then love.graphics.setColor(Color.inactive) end
                love.graphics.draw(tileset, quad, x, y)
            end
        } and game.res.mana >= 1 then
        if text == "UU" then game.island:move(0, -1) end
        if text == "LL" then game.island:move(-1, 0) end
        if text == "RR" then game.island:move(1, 0) end
        if text == "DD" then game.island:move(0, 1) end
    end
end


function hud:buildHelpMessage(dt)
    self.help = nil
    if #game.island.towers == 1 then
        self.help = "Build a 2nd tower to attack!"
    elseif #game.joblist > 1 then
        self.helpdt = self.helpdt + dt
        if self.helpdt > 3 then
            self.help = "You have " .. #game.joblist .. " vacant jobs!"
        end
    else
        self.helpdt = 0
        if game.res.food < 5 then
            self.help = "Your food is low!"
        end
    end
end


function hud:update(dt)
    
    self:buildHelpMessage(dt)
    
    self.checkbuildable = self.checkbuildable - dt
    
    if self.checkbuildable < 0 then
        self.checkbuildable = 1
        for i, build in pairs(self.build) do
            build.buildable = game:canPay(build)
        end
    end
    
    
    delta = delta + dt
    
    love.graphics.setFont(font.b)
    
    Gui.group.push{ grow = "down"}
    
        Gui.Label{ text = "Happiness: "..tostring(math.floor(game.happy * 10) * 0.1), pos = {screen.w - 190, 5} }
    
        -- build toolbar
        Gui.group.push{ grow = "down", pos = {screen.w - 145, 40}, size = {126}}
            Gui.Label{ text = "Buildmenu" }
            createBuildingButton(self.build.house)
            if FLAGS.house then createBuildingButton(self.build.sawmill) end
            if FLAGS.sawmill then createBuildingButton(self.build.farm) end
            if FLAGS.farm then createBuildingButton(self.build.mason) end
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
    
    -- build magic display
    if FLAGS.tower > 0 then
        Gui.group.push{ grow = "right", pos = {0, screen.h - 70}}
            Gui.group.push{ grow = "down"}
                Gui.Label{ text = "", size = {TILE_SIZE}}
                createMoveButton("LL", quads[9][7])
            Gui.group.pop{}
            Gui.group.push{ grow = "down"}
                createMoveButton("UU", quads[9][5])
                createMoveButton("DD", quads[9][8])
            Gui.group.pop{}
            Gui.group.push{ grow = "down"}
            Gui.Label{ text = "", size = {TILE_SIZE}}
            createMoveButton("RR", quads[9][6])
            Gui.group.pop{}
        Gui.group.pop{}
    end
    
    -- build fire display
    if #game.island.towers > 1 then
        if Gui.Button{text = "", size = { TILE_SIZE * 2, TILE_SIZE * 2 }, pos = {150, screen.h - TILE_SIZE * 2}, draw = function(state, title, x,y,w,h)
                    love.graphics.setColor(Color.white)
                    if not (state == "normal") then
                        love.graphics.setColor(Color.highlight_green)
                    end
                    if game.res.mana < 1 then love.graphics.setColor(Color.inactive) end
                    love.graphics.draw(tileset, self.buttonquad, x, y)
                end
            } and game.res.mana >= 1 then
            game.island:doFire()
        end
    end
    
    -- current message of the day
    if self.help then
        love.graphics.setFont(font.h)
        Gui.Label{ text = self.help, pos = {10, 10} }
    end
end


function hud:fps()
    love.graphics.setFont(font.h)
    Gui.Label{ text = "FPS: "..love.timer.getFPS(), pos = {screen.w - 150, 20}}
end


function hud:draw()
    love.graphics.setColor(Color.white)
    Gui.core.draw()
end
