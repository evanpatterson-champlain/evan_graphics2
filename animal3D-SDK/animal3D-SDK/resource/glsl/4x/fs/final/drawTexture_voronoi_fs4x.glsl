

#version 410



#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

layout (location = 0) out vec4 rtFragColor;

uniform float uTime;

in vec4 texCoorVar;

vec2 hash( vec2 p ) { 
	p = vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))); 
	return fract(sin(p)*18.5453); 
}

// return distance, and cell id
float voronoi( in vec2 x )
{
    vec2 n = floor( x );
    vec2 f = fract( x );

	vec3 m = vec3( 8.0 );
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2  g = vec2( float(i), float(j) );
        vec2  o = hash( n + g );
        vec2  r = g - f + (0.5+(0.5*sin((uTime * 100.0)+6.2831*o)));
		float d = dot( r, r );
        if( d<m.x ){
            m = vec3( d, o );
		}
    }

    return m.y+m.z;
}

void main()
{
    
    // computer voronoi pattern
    float c = voronoi((14.0 + sin(100.0*uTime)) * texCoorVar.xy);

    // colorize
    vec3 col = 0.5 + 0.5*cos( c * 6.2831 + vec3(0.0,1.0,2.0) );
	
    rtFragColor = vec4(vec3(uTime), 1.0);//vec4(vec3(c), 1.0 );
}