require "lua.libs.util"

--  colors
BLACK = rgb( 0, 0, 0 )
WHITE = rgb( 255, 255, 255 )
RED = rgb( 255, 0, 0 )
GREEN = rgb( 0, 255, 0 )
BLUE = rgb( 0, 0, 255 )
PURPLE = rgb( 255, 0, 255 )

--  shaders
Shaders = {}

local path = "assets/shaders"
for i, v in ipairs( love.filesystem.getDirectoryItems( path ) ) do
    Shaders[v:gsub( "%.%w+$", "" ):upper()] = love.graphics.newShader( path .. "/" .. v )
end