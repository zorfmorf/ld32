
-- load libs
Gui = require "lib.quickie"
Gamestate = require "lib.hump.gamestate"
Class = require "lib.hump.class"


-- require everything in directory
local function requireDir( dir )
    dir = dir or ""
    local entities = love.filesystem.getDirectoryItems( dir )
    for i, files in ipairs(entities) do
        local trim = string.gsub( files, ".lua", "")
        require(dir .. "/" .. trim)
    end
end

requireDir( 'state' )
requireDir( 'map' )
requireDir( 'misc' )
requireDir( 'view' )


function love.load()
    math.randomseed(os.time())
    
    Gamestate.registerEvents()
    Gamestate.switch(state_ingame)
end


function love.update(dt)
    update_screen()
end


function love.draw()
    
end


function love.keypressed(key, isrepeat)
    if key == "escape" then love.event.push("quit") end
end

function love.textinput(str)
    gui.keyboard.textinput(str)
end
