Game = class( GameObject )

function Game:init()
end

function Game:update( dt )
end

function Game:keypress( key )
    if key == "r" then
        love.setScene( Menu )
    end
end

function Game:draw()
    love.graphics.print( "Game Scene", 5, 25 )
end