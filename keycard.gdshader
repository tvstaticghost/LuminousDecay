shader_type canvas_item;

uniform float pulse_speed : hint_range(0.1, 5.0) = 2.0;
uniform float pulse_strength : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    float pulse = sin(TIME * pulse_speed) * pulse_strength;

    COLOR = tex + vec4(vec3(pulse), 0.0);
}
