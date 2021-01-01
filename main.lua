--  pixel-art filter
love.graphics.setDefaultFilter( "nearest" )

--  global variables
DEBUG = false
SIZE_FACTOR = 3

--  dependencies
require "lua.libs.require"
require "lua.libs.*"
require "lua.game.*"
require "lua.scenes.*"
require "lua.*"

--  framework
function love.load()
    math.randomseed( os.time() )
    love.setScene( Game )
end

function love.setScene( scene, ... )
    if love._scene then GameObjects.reset() end

    local args = { ... }
    timer( 0, function() 
        love._scene = scene( unpack( args ) )
    end )
end

function love.update( dt )
    GameObjects.call( "update", dt )

    --  Timers
    for k, v in pairs( Timers ) do
        v.time = v.time + dt
        if v.time >= v.max_time then
            v.callback()
            Timers[k] = nil
        end
    end
end

function love.keypressed( key )
    if key == "," then
        DEBUG = not DEBUG
    end

    GameObjects.call( "keypress", key )
end

function love.mousepressed( x, y, button )
    GameObjects.call( "mousepress", button, x, y )
end

function love.wheelmoved( x, y )
    GameObjects.call( "wheelmove", x, y )
end

function love.draw()
    Camera:push()
    GameObjects.callSorted( "draw" )
    Camera:pop()
    
    if DEBUG then
        love.graphics.origin()
        love.graphics.setColor( WHITE )
        love.graphics.print( love.timer.getFPS() .. " FPS", 5, 5 )
        love.graphics.print( "#Entities: " .. table_count( Entities ), 5, 25 )
    end
end
