Menu = class( GameObject )

function Menu:init()
end

function Menu:update( dt )
end

function Menu:keypress( key )
    if key == "r" then
        love.setScene( Game )
    end
end

function Menu:draw()
    love.graphics.print( "Menu Scene", 5, 25 )
end