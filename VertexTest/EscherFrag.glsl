#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


uniform vec2 u_resolution;

varying vec3 vertNormal;
varying vec3 vertLightDir;

varying vec2 texCoords;

vec3 square(vec2 st, vec2 coords, float size) {
    float point = 0.0;
    float halfSize = size/2.0;
    
    //bottom side
    point = step(coords.y - halfSize, st.y);
    //left side
    point *= step(coords.x - halfSize, st.x);
    // right side
    point *= step(1.0 - coords.x - halfSize, 1.0 - st.x);
    // up side
    point *= step(1.0 - coords.y - halfSize,  1.0 - st.y);
    
    return vec3(point);
}

vec3 escher_grid(vec2 st, float intensity) {
    vec3 color = vec3(0.0);
  // 32.0 * (max_size + 0.2*max_size) = 1.0 -> 1.0 / max_squares * 1.2
  const float max_squares = 35.0;
  const float max_size = 1.0 / (1.2 * max_squares);
  const float min_size = max_size/5.0;
  const float gap = 1.2 * max_size;
  
  float size;
  for(float i = -1.0 + gap/2.0; i <= 1.0 - (max_size/2.0); i+=gap) {
    for(float j = -1.0 + gap/2.0; j <= 1.0 - max_size/2.0; j+=gap) {
      size = (1.0 - intensity) * max_size + intensity * min_size;
      color += square(st, vec2(i, j), size);
    }
  }
  
  return color;
}


void main() {  
  float intensity;
  
  // Producto escalar normal y vector hacia la fuente de luz
  intensity = max(0.0, dot(vertLightDir, vertNormal));

  vec2 st = texCoords/u_resolution;
  gl_FragColor = vec4(1.0 - escher_grid(st, intensity), 1.0);
  //gl_FragColor = color;
}
