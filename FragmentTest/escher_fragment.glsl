#ifdef GL_ES
precision medium float;
precision medium int;
#endif


#define PROCESSING_TEXTURE_SHADER


uniform vec2 u_resolution;
uniform sampler2D texture;

float texture_fragment_brightness(vec2 coords, float frag_size) {
	float frag_size_half = frag_size/2.0;
	vec4 texColor = vec4(0.0);
	float texels = 0.0;

	for(float i = coords.x - frag_size_half; i <= coords.x - frag_size_half; i+=0.001) {
        for(float j = coords.y - frag_size_half; j <= coords.y - frag_size_half; j+=0.001) {
			texColor += texture2D(texture, vec2(1.0 - i, 1.0 - j));
			texels += 1.0;
		}
	}
	texColor = texColor / texels;

	return smoothstep(0.0, 3.0, texColor.r + texColor.g + texColor.b);
}

vec3 square(vec2 fragCoords, vec2 coords, float size) {
    float point = 0.0;
    float halfSize = size/2.0;
    
    // bottom side
    point = step(coords.y - halfSize, fragCoords.y);
    // left side
    point *= step(coords.x - halfSize, fragCoords.x);
    // right side
    point *= step(1.0 - coords.x - halfSize, 1.0 - fragCoords.x);
    // up side
    point *= step(1.0 - coords.y - halfSize,  1.0 - fragCoords.y);
    
    return vec3(point);
}

vec3 escher_grid(vec2 fragCoords) {
  vec3 color = vec3(0.0);
	// 32.0 * (max_size + 0.2*max_size) = 1.0 -> 1.0 / max_squares * 1.2
	const float max_squares = 50.0;
	const float max_size = 1.0 / (1.2 * max_squares);
	const float min_size = max_size/5.0;
  const float gap = 1.2 * max_size;
	float size;
	float brightness;
  for(float i = gap/2.0; i <= 1.0 - (max_size/2.0); i+=gap) {
    for(float j = gap/2.0; j <= 1.0 - max_size/2.0; j+=gap) {
		  brightness = texture_fragment_brightness(vec2(i,j),max_size); // 0.0 - 1.0
      size = (1.0 - brightness) * max_size + brightness * min_size;
      color += square(fragCoords, vec2(i, j), size);
    }
  }
  return color;
}


void main(void) {
	vec2 st = gl_FragCoord.st/u_resolution;
	gl_FragColor = vec4(1.0 - escher_grid(st),1.0);
}
