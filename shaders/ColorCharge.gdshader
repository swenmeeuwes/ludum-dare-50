shader_type canvas_item;

uniform float color_amount = 0.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	float color_avg = (tex_color.r + tex_color.g + tex_color.b) / 3.0;
	vec4 gs_color = vec4(color_avg, color_avg, color_avg, tex_color.a);
	
	COLOR = mix(gs_color, tex_color, color_amount);
}