#version 120
//
// simple.frag
//
varying vec3 diffuseColor;
varying vec2 t;
const vec3 c1 = vec3(1.0, 0.0, 0.0);
 
void main(void)
{
  if (mod(floor(t.x) + floor(t.y), 2.0) == 0.0) discard;
  gl_FragColor = vec4(diffuseColor * c1, 1.0);
}
