--  @function table_copy
--      | description: Recursively copy all keys-values of a table to a new fresh table
--      | params:
--          table tbl: Source table to copy
--      | return: table copy
function table_copy( tbl )
    local copy = {}

    for k, v in pairs( tbl ) do
        if type( v ) == "table" then 
            copy[k] = table_copy( v ) 
        else
            copy[k] = v
        end
    end

    return copy
end

--  @function lerp
--      | description: Linear-Interpolation between two values
--      | params:
--          number t: Must be between 0 and 1
--          number from: Minimum value to interpolate
--          number to: Maximum value to interpolate
--      | return: number value
function lerp( t, from, to )
    return ( 1 - t ) * from + t * to
end

--  @function approach
--      | description: Approach a value from an other
--      | params:
--          number inc: Increment number
--          number from: Minimum value
--          number to: Maximum value
--      | return: number value
function approach( inc, from, to )
    if from < to then
        return math.min( from + inc, to )
    elseif from > to then
        return math.max( from - inc, to )
    end
    
    return to
end

--  @function distance
--      | description: Computes distance (in pixels) between two points
--      | params:
--          number a_x: X position of first point
--          number a_y: Y position of first point
--          number b_x: X position of second point
--          number b_x: Y position of second point
--      | return: number distance
function distance( a_x, a_y, b_x, b_y )
    return math.sqrt( ( b_x - a_x ) ^ 2 + ( b_y - a_y ) ^ 2 )
end

--  @function direction_angle
--      | description: Computes angle (in radians) between two points
--      | params:
--          number a_x: X position of first point
--          number a_y: Y position of first point
--          number b_x: X position of second point
--          number b_x: Y position of second point
--      | return: number angle
function direction_angle( a_x, a_y, b_x, b_y )
    return math.atan2( b_y - a_y, b_x - a_x )
end

--  @function quads
--      | description: Create a table of quads of the given image
--      | params:
--          Image image: Image/Tileset reference
--      | return: table quads
function quads( image )
    local quads = {}

    local w, h = image:getDimensions()
    for x = 0, w - h, h do
        quads[#quads + 1] = love.graphics.newQuad( x, 0, h, h, w, h )
    end

    return quads
end