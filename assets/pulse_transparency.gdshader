shader_type spatial;
render_mode blend_mix;

uniform sampler2D TEXTURE;
uniform float Frequency : hint_range(0.1, 10.0) = 1.0;
uniform float MaxOpacity : hint_range(0.0, 1.0) = 1.0;
uniform float MinimumOpacity : hint_range(0.0, 1.0) = 0.5;
uniform float TriplanarSharpness : hint_range(0.0, 4.0) = 1.0;

vec4 triplanar_blend(vec3 position, vec3 normal) {
    vec3 abs_normal = abs(normal);
    abs_normal = pow(abs_normal, vec3(TriplanarSharpness));
    abs_normal /= (abs_normal.x + abs_normal.y + abs_normal.z);

    vec4 x_plane = texture(TEXTURE, position.yz);
    vec4 y_plane = texture(TEXTURE, position.zx);
    vec4 z_plane = texture(TEXTURE, position.xy);

    return x_plane * abs_normal.x + y_plane * abs_normal.y + z_plane * abs_normal.z;
}

void fragment() {
    vec3 local_pos = VERTEX;          // Use local vertex position
    vec3 local_normal = normalize(NORMAL);  // Use local normal

    vec4 tex_color = triplanar_blend(local_pos, local_normal);

    float time_based_factor = sin(Frequency * TIME) * 0.5 + 0.5;
    float final_opacity = mix(MinimumOpacity, MaxOpacity, time_based_factor);

    ALBEDO = tex_color.rgb;
    ALPHA = tex_color.a * final_opacity;
}
