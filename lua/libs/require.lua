
local _require = require
function require( path )
    if path:match( "%*$" ) then
        path = path:gsub( "%.%*$", "" ):gsub( "%.", "/" )
        for i, v in ipairs( love.filesystem.getDirectoryItems( path ) ) do
            local no_extension = v:gsub( "%.lua$", "" )
            if not ( no_extension == v ) then
                require( path .. "/" .. no_extension )
            end
        end
    else
        return _require( path )
    end
end