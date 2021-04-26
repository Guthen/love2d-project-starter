Entities, Entity = {}, class( GameObject )

--  position
Entity.x, Entity.y = 0, 0
Entity.origin_x, Entity.origin_y = 0, 0
Entity.scale_x, Entity.scale_y = 1, 1
Entity.ang = 0

--  image
Entity.image = image( "player.png" )
Entity.quad_id, Entity.quads = 1, quads( Entity.image )
Entity.anim_fps, Entity.anim_time, Entity.anim_loop = 5, 0, true
Entity.shader = nil
Entity.color = WHITE

--  methods
function Entity:init( x, y, ... )
    self.x, self.y = x or self.x, y or self.y

    Entities[self.id] = self
end

function Entity:get_frame_duration()
    return 1 / self.anim_fps
end

function Entity:update_anim( dt )
    local duration = self:get_frame_duration()

    self.anim_time = self.anim_time + dt
    if self.anim_time >= duration then
        if self.quad_id + 1 > #self.quads then
            if self.anim_loop then
                self.quad_id = 1
            end
        else
            self.quad_id = self.quad_id + 1
        end
        
        self.anim_time = self.anim_time - duration
    end
end

function Entity:update( dt )
    self:update_anim( dt )
end

function Entity:draw()
    love.graphics.setShader( self.shader )
    love.graphics.setColor( self.color )

    if self.quads[self.quad_id] then
        love.graphics.draw( self.image, self.quads[self.quad_id], self.x, self.y, self.ang, SIZE_FACTOR * self.scale_x, SIZE_FACTOR * self.scale_y, self.origin_x, self.origin_y )
    else
        love.graphics.draw( self.image, self.x, self.y, self.ang, SIZE_FACTOR * self.scale_x, SIZE_FACTOR * self.scale_y, self.origin_x, self.origin_y )
    end

    love.graphics.setShader()

    if DEBUG then
        local w, h
        if self.quads[self.quad_id] then
            w, h = select( 3, self.quads[self.quad_id]:getViewport() )
        else
            w, h = self.image:getWidth(), self.image:getHeight()
        end

        love.graphics.setColor( GREEN )
        love.graphics.rectangle( "line", self.x, self.y, w * SIZE_FACTOR, h * SIZE_FACTOR )
    end
end

function Entity:destroy()
    Entities[self.id] = nil
    GameObject.destroy( self )
end