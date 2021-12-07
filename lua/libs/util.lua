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

--  @function table_count
--      | description: Count how many elements are present in the table
--      | params:
--          table tbl: Table to iterate
--      | return number len
function table_count( tbl )
    return table_reduce( tbl, function( acc ) return acc + 1 end, 0 )
end

--  @function table_reduce
--      | description: Iterate a table and accumulate a value
--      | params:
--          table tbl: Table to iterate
--          function callback: Function (number acc, any v, any k, table tbl) who must return the new value of the accumulator
--          any value = 0: Start value
--      | return any acc
function table_reduce( tbl, callback, value )
    local acc = value or 0

    for k, v in pairs( tbl ) do
        acc = callback( acc, v, k, tbl )
    end

    return acc
end

function print_table( tbl, tabs )
    tabs = tabs or 0
    
    local tab = tabs > 0 and ( "\t" ):rep( tabs ) or ""
    print( tab .. "{" )
    for k, v in pairs( tbl ) do
        if type( v ) == "table" then
            print( tab .. "\t" .. tostring( k ) .. " = " )
            print_table( v, tabs + 1 )
        else
            print( tab .. "\t" .. tostring( k ) .. " = " .. tostring( v ) )
        end
    end
    print( tab .. "}" )
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

--  @function round
--      | description: Round a float to specified decimals number
--      | params:
--          number value: Float number to round
--          number decimals: Number of decimals
--      | return: number rounded
function round( value, decimals )
    local div = 10 ^ decimals
    return math.floor( value * div ) / div
end

--  @function collide
--      | description: Compute a AABB collision test on given coordinates
--      | params:
--          number a_x: X position of A object
--          number a_y: Y position of A object
--          number a_w: Width of A object
--          number a_h: Height of A object
--          number b_x: X position of B object
--          number b_y: Y position of B object
--          number b_w: Width of B object
--          number b_h: Height of B object
--      | return: boolean is_collide
function collide( a_x, a_y, a_w, a_h, b_x, b_y, b_w, b_h )
    return a_x < b_x + b_w and a_y < b_y + b_h 
       and b_x < a_x + a_w and b_y < a_y + a_h
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

--  @function tileset
--      | description: Create a table of quads of the given image according to a constant quad size
--      | params:
--          Image image: Image/Tileset reference
--          number quad_w: Quad Width
--          number quad_h: Quad Height
--      | return: table quads
function tileset( image, quad_w, quad_h )
    local quads = {}

    quad_h = quad_h or quad_w

    local w, h = image:getDimensions()
    for y = 0, h - quad_h, quad_h do
        for x = 0, w - quad_w, quad_w do
            quads[#quads + 1] = love.graphics.newQuad( x, y, quad_w, quad_h, w, h )
        end
    end

    return quads
end

--  @function load_json_animations
--      | description: Load an Aseprite-generated JSON file and create defined-quads
--      | params:
--          string filename: JSON filename
--      | return: table anims
local cached_anims = {}
local json_parser = require "lua.libs.json"
function load_json_animations( filename )
    if cached_anims[filename] then return cached_anims[filename] end
    local json = love.filesystem.read( filename )
    if not json then return false end
    
    local content = json_parser.decode( json )
    if not content then return false end
    
    local anims = {}
    local w, h = content.meta.size.w, content.meta.size.h
    for i, v in ipairs( content.meta.frameTags ) do
        anims[v.name] = {}
        for i = v.from, v.to do
            local frame = content.frames[i + 1]
            anims[v.name][#anims[v.name] + 1] = {
                quad = love.graphics.newQuad( frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h, w, h ),
                duration = frame.duration,
                name = frame.filename,
            }
        end
    end

    return anims
end

function quads_from_animations( anims )
    local quads = {}

    for k, anims in pairs( anims ) do
        quads[k] = {}
        for i, v in ipairs( anims ) do
            quads[k][#quads[k] + 1] = v.quad
        end
    end

    return quads
end

--  @function image
--      | description: Load and cache the specified image
--      | params:
--          string path: Image path
--      | return Image image
local images = {}
function image( path )
    if not images[path] then
        images[path] = love.graphics.newImage( "assets/images/" .. path )
    end
    
    return images[path]
end

--  @function clamp
--      | description: Clamp a value between bounds
--      | params:
--          number value: Value to clamp
--          number min: Minimal value
--          number max: Maximal value
--      | return number clamped_value
function clamp( value, min, max )
    return value < min and min or value > max and max or value
end

--  @function rgb
--      | description: Create a color table
--      | params:
--          number r: Red component
--          number g: Green component
--          number b: Blue component
--          number a = 255: Alpha component
--      | return table color
function rgb( r, g, b, a )
    return {
        r / 255,
        g / 255,
        b / 255,
        ( a or 255 ) / 255,
    }
end

--  @function alpha
--      | description: Create a color table from another color with the specified alpha
--      | params:
--          table color: Color table
--          number a: Alpha value
--      | return table color
function alpha( color, a )
    return {
        color[1],
        color[2],
        color[3],
        a,
    }
end

--  @function some
--      | description: Checks if one of the values in a table pass a test callback
--      | params:
--          table tbl: Table to check the values
--          function callback: Test-callback, called for each values (until it returns true) with:
--              any value: Current value
--              any key: Current key
--              table tbl: Table used
--      | return boolean test_checked
function some( tbl, callback )
    for k, v in pairs( tbl ) do
        if callback( v, k, tbl ) then
            return true
        end
    end

    return false
end

--
local offset = -SIZE_FACTOR
function draw_outlined_text( text, font, x, y, limit, align, color, scale )
    local w = font:getWidth( text )
    local h = font:getHeight()

    scale = scale or 1

    local origin_x, origin_y = 0, 0
    if align == "center" then
        x, y = x + w / 2 * scale - limit / 2 * scale, y + h / 2
        origin_x, origin_y = w / 2, h / 2
    elseif align == "right" then
        x = x - limit
    end

    --  outlined text
    love.graphics.setFont( font )
    love.graphics.setColor( BLACK )
    love.graphics.printf( text, x, y - h, limit, align, 0, scale, scale, origin_x, origin_y )
    
    --  text
    love.graphics.setColor( color )
    love.graphics.printf( text, x + offset, y - h + offset, limit, align, 0, scale, scale, origin_x, origin_y )
end
