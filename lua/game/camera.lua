Camera = {}
Camera.x, Camera.y = 0, 0
Camera.bounds = {
    min_x = 0, 
    max_x = 200,
    min_y = 0, 
    max_y = 200,
    active = false,
}

local w, h = love.graphics.getDimensions()
function Camera:center( x, y )
    local x, y = x - w / 2, y - h / 2
    self.x = self.bounds.active and clamp( x, self.bounds.min_x, self.bounds.max_x ) or x
    self.y = self.bounds.active and clamp( y, self.bounds.min_y, self.bounds.max_y ) or y
end

function Camera:getmousepos()
    local mx, my = love.mouse.getPosition()
    return self.x + mx, self.y + my
end

function Camera:push()
    love.graphics.push()
    love.graphics.translate( -self.x, -self.y )
end

function Camera:pop()
    love.graphics.pop()
end