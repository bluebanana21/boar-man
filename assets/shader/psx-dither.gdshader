shader_type canvas_item;

uniform int color_depth : hint_range(1, 8) = 5;
uniform bool dithering = true;

int max_value_from_bits(int bits) {
	return (1 << bits) - 1;
}

int dithering_pattern(ivec2 fragcoord) {
	const int pattern[] = {
		-4, +0, -3, +1, 
		+2, -2, +3, -1, 
		-3, +1, -4, +0, 
		+3, -1, +2, -2
	};
	
	int x = fragcoord.x % 4;
	int y = fragcoord.y % 4;
	
	return pattern[y * 4 + x];
}

void fragment() {
	ivec2 uv = ivec2(FRAGCOORD.xy);
	vec3 color = texelFetch(TEXTURE, uv, 0).rgb;
	
	// Convert from 0 to 1 to 0 to 255.
	ivec3 intColor = ivec3(color * 255.0f);
	int bitshift = (8 - color_depth);
	int maxColor = max_value_from_bits(color_depth);
		
	// Apply the dithering.
	if (dithering) {
		ivec3 ditherApplied = intColor + ivec3(dithering_pattern(uv));
		intColor = clamp(ditherApplied >> bitshift, 0, maxColor);
	}
	else {
		intColor = clamp(intColor >> bitshift, 0, maxColor);
	}
	
	// Convert back to 0 to 1.
	COLOR.rgb = vec3(intColor) / float(maxColor);
}