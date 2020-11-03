Shaders = {}

local path = "assets/shaders"
for i, v in ipairs( love.filesystem.getDirectoryItems( path ) ) do
    Shaders[v:gsub( "%.%w+$", "" ):upper()] = love.graphics.newShader( path .. "/" .. v )
end
