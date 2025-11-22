shader_type canvas_item;

uniform int outline_radius = 1;                // how many pixels to check in each direction
uniform float outline_size = 1.0;             // multiplies TEXTURE_PIXEL_SIZE (thickness)
uniform vec4 outline_color = vec4(0.0,0.0,0.0,1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec2 px = TEXTURE_PIXEL_SIZE * outline_size;

    bool drawn = false;

    // If the sprite pixel is visible, draw it
    if (tex.a > 0.0) {
        COLOR = tex;
        drawn = true;
    } else {
        // Otherwise check neighbors for any opaque pixel -> draw outline
        for (int x = -outline_radius; x <= outline_radius; x++) {
            for (int y = -outline_radius; y <= outline_radius; y++) {
                vec2 offset = vec2(float(x), float(y)) * px;
                vec4 sample = texture(TEXTURE, UV + offset);
                if (sample.a > 0.0) {
                    COLOR = outline_color;
                    drawn = true;
                    break;
                }
            }
            if (drawn) { break; }
        }
    }

    // Nothing found — keep fully transparent
    if (!drawn) {
        COLOR = vec4(0.0);
    }
}
