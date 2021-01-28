shader_type canvas_item;

uniform bool active = false;

//	Fragment function runs at every single pixel in the sprite
void fragment(){
	// Texture function does basically "what color is this pixel on the texture, 
	// and gets each singular pixel color in the big square of the sprite
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a); // previous_color.alpha
	vec4 new_color = previous_color;
	if(active == true){
		new_color = white_color;
	}
	COLOR = new_color;
}