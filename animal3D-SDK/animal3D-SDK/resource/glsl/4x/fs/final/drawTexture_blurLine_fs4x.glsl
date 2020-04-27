

#version 410


layout (location = 0) out vec4 rtFragColor;

uniform double uTime;
uniform vec2 uSize;

in vec4 texCoorVar;

vec2 hash( vec2 p ) { 
	p = vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3)));
	return fract(sin(p)*18.5453); 
}

float voronoi( in vec2 x )
{
    vec2 gridLoc = floor(x);
    vec2 f = fract(x);

	vec3 m = vec3(8.0);

    for(int j=-1; j <= 1; j++)
    {
        for(int i=-1; i <= 1; i++)
        {
            vec2  dir = vec2(float(i), float(j));

            vec2  h = hash(gridLoc + dir);

            vec2  r = dir - f + (0.5+(0.5*sin((float(uTime))+6.2831*h)));

		    float dist = length(r);

            if(dist <m.x ){
                m = vec3(dist, h);
		    }
        }
    }

    return m.y+m.z;
}

void main()
{
    
    float c = voronoi(((1.0/(uSize.x * 5.0)) + sin(float(uTime))) * texCoorVar.xy);
	
    rtFragColor = vec4(vec3(c)/2.0, 1.0 );
}


