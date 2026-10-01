shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.24, 0.65, 0.12, 0.92);
uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 0.6);
uniform float shine_pos : hint_range(0.0, 1.0) = 0.3;
uniform float shine_width : hint_range(0.01, 0.5) = 0.12;

void fragment() {
	vec4 color = base_color;

	// Diagonal shine streak that can be animated by moving shine_pos
	float diagonal = (UV.x + UV.y) * 0.5;
	float shine = smoothstep(shine_pos - shine_width, shine_pos, diagonal)
		- smoothstep(shine_pos, shine_pos + shine_width, diagonal);
	color = mix(color, shine_color, shine * shine_color.a);

	// Slight darkening toward the bottom edge, like depth/thickness
	color.rgb *= mix(0.85, 1.0, UV.y);

	COLOR = color;
}