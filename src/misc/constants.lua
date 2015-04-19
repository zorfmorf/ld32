
TILE_SIZE = 32

Color = {
    white = {255, 255, 255, 255},
    black = {0, 0, 0, 255},
    highlight_red = {230, 100, 100, 150},
    highlight_green = {100, 230, 100, 150},
    background = {102, 102, 102, 180},
    inactive = {102, 102, 102, 255},
    laser = {221, 37, 5, 150}
}

V_SPEED = 1
V_CLOSE_ENOUGH = 0.2

C_MOV = 100

I_MOV = 0.3

FLAGS = {}
FLAGS.tower = 0

SHADER = love.graphics.newShader [[
        extern number time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
            return vec4(abs(sin(time * 2)), abs(cos(time)), abs(sin(time)), 0.5);
        }
    ]]