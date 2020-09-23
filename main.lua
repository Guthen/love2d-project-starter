--  > Pixel-Art Filter
love.graphics.setDefaultFilter( "nearest" )

--  > Dependencies
require "lua.libs.require"
require "lua.libs.*"
require "lua.scenes.*"
require "lua.*"

--  > Framework
function love.load()
    love.setScene( Game )
end

function love.setScene( scene, ... )
    if love._scene then love._scene:destroy() end

    local args = { ... }
    timer( 0, function() 
        love._scene = scene( unpack( args ) )
    end )
end

function love.update( dt )
    GameObjects.call( "update", dt )

    --  > Timers
    for k, v in pairs( Timers ) do
        v.time = v.time + dt
        if v.time >= v.max_time then
            v.callback()
            Timers[k] = nil
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
