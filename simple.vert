#version 120
//
// simple.vert
//
invariant gl_Position;
attribute vec3 position;
uniform mat4 projectionMatrix;
varying vec3 diffuseColor;
uniform vec3 lightDirection;
uniform vec3 lightColor;
varying vec2 t;

void main(void)
{
  t = position.xy * 4.0;
  diffuseColor = vec3(dot(lightDirection, position)) * lightColor;
  gl_Position = projectionMatrix * vec4(position, 1.0);
}
