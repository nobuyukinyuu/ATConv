shader_type canvas_item;
uniform vec2 grid_size = vec2(8.0,8.0);
uniform vec2 tex_size = vec2(48.0,64.0);

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	if ((mod(UV.x*tex_size.x, grid_size.x) < 0.5) || (mod(UV.y*tex_size.y, grid_size.y) < 0.5)) {
		COLOR = 1.0 - (1.0-c * 1.0-vec4(0.0, 0.0, 1.0, 0.25));
	} else {
		COLOR = c;
	}
}