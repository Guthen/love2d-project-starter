
vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec4 texture_color = Texel( tex, texture_coords );

    float avg = ( texture_color.r + texture_color.g + texture_color.b ) / 3.5f;
    return color * vec4( avg, avg, avg, texture_color.a );
}