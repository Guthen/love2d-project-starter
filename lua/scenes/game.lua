Game = class( GameObject )

function Game:init()
    Entity( 50, 150 )
end

function Game:update( dt )
end

function Game:keypress( key )
    if key == "escape" then
        love.setScene( Menu )
    end
end

function Game:draw()
    love.graphics.print( "Game Scene", 5, 45 )
end