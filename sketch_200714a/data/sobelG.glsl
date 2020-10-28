// Adapted from:
// <a href="http://callumhay.blogspot.com/2010/09/gaussian-blur-shader-glsl.html" target="_blank" rel="nofollow">http://callumhay.blogspot.com/2010/09/gaussian-blur-shader-glsl.html</a>

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER;

uniform sampler2D texture;
uniform float mult;
uniform float type;
uniform float max;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform vec2 resolution;

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void main(void) {
  float x = 1.0 / resolution.x;
  float y = 1.0 / resolution.y;

  float PI = 3.14159265359;
  vec4 horizEdge = vec4( 0.0 );
  horizEdge -= texture2D( texture, vec2( vertTexCoord.x - x, vertTexCoord.y - y ) ) * 1.0;
  horizEdge -= texture2D( texture, vec2( vertTexCoord.x - x, vertTexCoord.y     ) ) * 2.0;
  horizEdge -= texture2D( texture, vec2( vertTexCoord.x - x, vertTexCoord.y + y ) ) * 1.0;
  horizEdge += texture2D( texture, vec2( vertTexCoord.x + x, vertTexCoord.y - y ) ) * 1.0;
  horizEdge += texture2D( texture, vec2( vertTexCoord.x + x, vertTexCoord.y     ) ) * 2.0;
  horizEdge += texture2D( texture, vec2( vertTexCoord.x + x, vertTexCoord.y + y ) ) * 1.0;

  vec4 vertEdge = vec4( 0.0 );
  vertEdge -= texture2D( texture, vec2( vertTexCoord.x - x, vertTexCoord.y - y ) ) * 1.0;
  vertEdge -= texture2D( texture, vec2( vertTexCoord.x    , vertTexCoord.y - y ) ) * 2.0;
  vertEdge -= texture2D( texture, vec2( vertTexCoord.x + x, vertTexCoord.y - y ) ) * 1.0;
  vertEdge += texture2D( texture, vec2( vertTexCoord.x - x, vertTexCoord.y + y ) ) * 1.0;
  vertEdge += texture2D( texture, vec2( vertTexCoord.x    , vertTexCoord.y + y ) ) * 2.0;
  vertEdge += texture2D( texture, vec2( vertTexCoord.x + x, vertTexCoord.y + y ) ) * 1.0;

  vec3 edge = sqrt((horizEdge.rgb * horizEdge.rgb) + (vertEdge.rgb * vertEdge.rgb));
  float x1 = (horizEdge.r+horizEdge.g+horizEdge.b)/3.0;
  float y1 = (vertEdge.r+vertEdge.g+vertEdge.b)/3.0;

  float a1 = map(atan(y1,x1),0.0-PI,PI,0.0,1.0);
  float b1 = map(y1,0.0-PI,PI,0.0,360.0);

  gl_FragColor = vec4(x1,y1,1.0,1.0)*1.0;


}
