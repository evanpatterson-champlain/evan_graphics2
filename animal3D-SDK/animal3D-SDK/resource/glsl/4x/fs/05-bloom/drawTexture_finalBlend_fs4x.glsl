

#version 410


uniform sampler2D uImage00;


layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;


void main()
{
	

	rtFragColor = vec4(0.0, 1.0, 1.0, 1.0);
	//rtFragColor = texture(uImage00, texCoorVar.xy).rgba;
}
