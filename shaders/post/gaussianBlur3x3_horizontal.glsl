#version 120
uniform sampler2D SceneTex;
uniform float PixelWidth;
float pascal[7] = float[]( 1.0, 6.0, 15.0, 20.0, 15.0, 6.0, 1.0 );
float pascal_sum = pow( 2.0, 7.0-1.0 );

void main( void )
{
	vec2 coord = gl_TexCoord[0].st;
	vec3 color = vec3( 0.0 );

	for ( int i=0; i<7; i++ )
		color += pascal[i] * texture2D( SceneTex, coord + vec2( float(i-((7-1)/2)) * (PixelWidth/2.0), 0.0 ) ).rgb;
	color /= pascal_sum;

	gl_FragColor = vec4( color, 1.0 );
}
