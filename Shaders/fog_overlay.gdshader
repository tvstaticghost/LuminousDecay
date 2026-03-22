shader_type canvas_item;

uniform float fog_strength = 0.1;
uniform float speed = 0.07;
uniform float scale = 4.0;

void fragment()
{
    vec2 uv = UV;

    float noise = sin(uv.x * scale + TIME * speed) *
                  sin(uv.y * scale + TIME * speed);

    float fog = (noise * 0.5 + 0.5) * fog_strength;

    COLOR = vec4(0.8, 0.8, 0.85, fog);
}