Menu = class( GameObject )

function Menu:init()
end

function Menu:update( dt )
end

function Menu:keypress( key )
    if key == "space" then
        love.setScene( Game )
    end
end

function Menu:draw()
    love.graphics.print( "Menu Scene", 5, 45 )
end