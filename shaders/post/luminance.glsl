uniform sampler2D SceneTex;
uniform float PixelWidth;
uniform float PixelHeight;

void main( void )
{
	const vec3 weights = vec3( 0.2125, 0.7154, 0.0721 );
	vec2 halfPixel = vec2( PixelWidth, PixelHeight );
	vec4 texel = texture2D( SceneTex, gl_TexCoord[0].st + vec2( halfPixel.x, halfPixel.y ) );
	float grey = dot( texel.rgb, weights );
	float max_grey = grey;
	float avg_grey = 0.25 * log( 0.001 + grey );

	texel = texture2D( SceneTex, gl_TexCoord[0].st + vec2( -halfPixel.x, halfPixel.y ) );
	grey = dot( texel.rgb, weights );
	max_grey = max( max_grey, grey );
	avg_grey += 0.25 * log( 0.001 + grey );

	texel = texture2D( SceneTex, gl_TexCoord[0].st + vec2( -halfPixel.x, -halfPixel.y ) );
	grey = dot( texel.rgb, weights );
	max_grey = max( max_grey, grey );
	avg_grey += 0.25 * log( 0.001 + grey );

	texel = texture2D( SceneTex, gl_TexCoord[0].st + vec2( halfPixel.x, -halfPixel.y ) );
	grey = dot( texel.rgb, weights );
	max_grey = max( max_grey, grey );
	avg_grey += 0.25 * log( 0.001 + grey );

	gl_FragColor = vec4( exp( avg_grey ), max_grey, 0.0, 1.0 );
}
