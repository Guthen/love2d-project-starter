--  > GameObjects
GameObjects = {}
local objects, id = {}, 0

--  @function GameObjects.call
--      | description: Call every GameObject on specified function
--      | params:
--          string key: Function's key/name to call
--          varargs ...: All parameters to pass in the function's call
function GameObjects.call( key, ... )
    for k, v in pairs( objects ) do
        v[key]( v, ... )
    end
end

--  @class GameObject
--      | description: 
--          Represent a game object in the game world. A game object has an update and a draw phase, 
--          both called each frame.
--      | member:
--          GameObject:init
--          GameObject:update
--          GameObject:keypress
--          GameObject:mousepress
--          GameObject:draw
--          GameObject:destroy
GameObject = class()

--  @function GameObject:construct
--      | description: Construct GameObject : called when a new instance is created
function GameObject:construct()
    id = id + 1
    self.id = id
    objects[self.id] = self

    self:init()
end

--  @function GameObject:init
--      | description: Initialize GameObject
function GameObject:init()
end

--  @function GameObject:update
--      | description: Update GameObject
--      | params:
--          number dt: Delta-Time between last frame and current frame
function GameObject:update( dt )
end

--  @function GameObject:keypress
--      | description: Called when a key has been pressed on keyboard
--      | params:
--          string key: Key name which has been pressed
function GameObject:keypress( key )
end

--  @function GameObject:mousepress
--      | description: Called when a mouse button has been pressed
--      | params:
--          number button: Mouse button which has been pressed
function GameObject:mousepress( button, x, y )
end

--  @function GameObject:draw
--      | description: Draw GameObject
function GameObject:draw()
end

--  @function GameObject:destroy
--      | description: Destroy GameObject
function GameObject:destroy()
    objects[self.id] = nil
end