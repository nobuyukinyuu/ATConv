shader_type canvas_item;

//shift colors using texture
uniform sampler2D gradient;


void fragment() {
	float v = texture(TEXTURE, UV).r;
	COLOR.rgb = texture(gradient, vec2(v, 0.0)).rgb;
	COLOR.a = texture(TEXTURE, UV).a;
}
