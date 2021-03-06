uniform sampler2D SceneTex;
uniform sampler2D BloomTex;
uniform float BloomMulti;
uniform float BloomSat;
uniform float SceneMulti;
uniform float SceneSat;

void main( void ) {
	const vec3 weights = vec3( 0.2125, 0.7154, 0.0721 );
	vec3 scene = texture2D( SceneTex, gl_TexCoord[0].st ).rgb;
	vec3 bloom = texture2D( BloomTex, gl_TexCoord[0].st ).rgb;

	bloom = mix( vec3( dot( bloom, weights ) ), bloom, BloomSat ) * BloomMulti;
	scene = mix( vec3( dot( scene, weights ) ), scene, SceneSat ) * SceneMulti;

	gl_FragColor = vec4( (1.0 - ((1.0 - scene) * (1.0 - bloom))), 1.0 );
}
