

#version 410


uniform sampler2D uImage00;
uniform sampler2D uImage01;


layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;


void main()
{
	vec4 v1 = texture(uImage00, texCoorVar.xy);
	vec4 v2 = texture(uImage01, texCoorVar.xy);

	vec4 colorOut = v1 * v2.x;

	rtFragColor = vec4(0.0, 1.0, 1.0, 1.0);//colorOut;
}
