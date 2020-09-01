--  > Pixel-Art Filter
love.graphics.setDefaultFilter( "nearest" )

--  > Dependencies
require "lua.libs.class"
require "lua.libs.timer"
require "lua.libs.util"
require "lua.libs.gameobjects"

--  > Game
require "lua.shaders"


--  > Framework
function love.load()
end

function love.update( dt )
    GameObjects.call( "update", dt )

    --  > Timers
    for i, v in ipairs( Timers ) do
        v.time = v.time + dt
        if v.time >= v.max_time then
            v.callback()
            table.remove( Timers, i )
        end
    end
end

function love.keypressed( key )
    GameObjects.call( "keypress", key )
end

function love.mousepressed( x, y, button )
    GameObjects.call( "mousepress", button, x, y )
end

function love.draw()
    GameObjects.call( "draw" )
    
    love.graphics.origin()
    love.graphics.print( love.timer.getFPS() .. " FPS", 5, 5 )
end