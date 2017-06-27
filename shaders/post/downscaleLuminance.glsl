uniform sampler2D SceneTex;
uniform float PixelWidth;
uniform float PixelHeight;

void main( void )
{
    vec2 halfPixel = vec2( PixelWidth*0.5, PixelHeight*0.5 );
    vec4 texel = texture2D( SceneTex, gl_TexCoord[0].st + vec2( halfPixel.x, halfPixel.y ) );
    float max_grey = texel.g;
    float avg_grey = 0.25 * log( 0.001 + texel.r );

    texel		= texture2D( SceneTex, gl_TexCoord[0].st + vec2( halfPixel.x, -halfPixel.y ) );
    max_grey	= max( max_grey, texel.g );
    avg_grey	+= 0.25 * log( 0.001 + texel.r );

    texel		= texture2D( SceneTex, gl_TexCoord[0].st + vec2( -halfPixel.x, halfPixel.y ) );
    max_grey	= max( max_grey, texel.g );
    avg_grey	+= 0.25 * log( 0.001 + texel.r );

    texel		= texture2D( SceneTex, gl_TexCoord[0].st + vec2( -halfPixel.x, -halfPixel.y ) );
    max_grey	= max( max_grey, texel.g );
    avg_grey	+= 0.25 * log( 0.001 + texel.r );

    gl_FragColor = vec4( exp( avg_grey ), max_grey, 0.0, 1.0 );
}
