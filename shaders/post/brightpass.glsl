uniform sampler2D SceneTex;
uniform float Threshold;

void main( void )
{
	vec3 color = texture2D( SceneTex, gl_TexCoord[0].st ).rgb;
	gl_FragColor = vec4( clamp((color - Threshold) / (1.0 - Threshold), 0.0, 1.0), 1.0 );
}
