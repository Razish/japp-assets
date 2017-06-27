#version 120

uniform sampler2D SceneTex;
uniform float PixelWidth;
float pascal[13] = float[]( 1.0, 12.0, 66.0, 220.0, 495.0, 792.0, 924.0, 792.0, 495.0, 220.0, 66.0, 12.0, 1.0 );
float pascal_sum = pow( 2.0, 13.0-1.0 );

void main( void )
{
	vec2 coord = gl_TexCoord[0].st;
	vec3 color = vec3( 0.0 );

	for ( int i=0; i<13; i++ )
		color += pascal[i] * texture2D( SceneTex, coord + vec2( float(i-((13-1)/2)) * (PixelWidth/2.0), 0.0 ) ).rgb;
	color /= pascal_sum;

	gl_FragColor = vec4( color, 1.0 );
}
