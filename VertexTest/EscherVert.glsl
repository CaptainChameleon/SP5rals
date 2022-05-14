#define PROCESSING_LIGHT_SHADER
#define PI 3.1415926538

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec3 lightNormal[8];

attribute vec4 vertex;
attribute vec3 normal;

varying vec3 vertNormal;
varying vec3 vertLightDir;

varying vec2 texCoords;

void main() {
  // Vertex in clip coordinates
  gl_Position = transform * vertex;

  // Normal vector in eye coordinates is passed
  // to the fragment shader
  vertNormal = normalize(normalMatrix * normal);

  // Assuming that there is only one directional light.
  // Its normal vector is passed to the fragment shader
  // in order to perform per-pixel lighting calculation.  
  vertLightDir = -lightNormal[0];
  
  texCoords = vec2(gl_Position.x, gl_Position.y);
  //texCoord = (vec2(gl_Position.x, gl_Position.y) + vec2(1.0)) / vec2(2.0);
  //texCoord = vec2(0.5 + atan(gl_Position.x , gl_Position.z) / 2*PI, 0.5 + asin(gl_Position.y) / PI);
}
