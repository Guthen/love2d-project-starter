#define MAX_COLORS 2

uniform int len;
uniform vec4 target_colors[MAX_COLORS];
uniform vec4 replace_colors[MAX_COLORS];

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec4 texture_color = Texel( tex, texture_coords );

    for ( int i = 0; i < len; i++ ) {
        vec4 target_color = target_colors[i];
        vec4 replace_color = replace_colors[i];

        if ( texture_color == target_color ) {
            return replace_color * color;
        }
    }

    return texture_color * color;
}