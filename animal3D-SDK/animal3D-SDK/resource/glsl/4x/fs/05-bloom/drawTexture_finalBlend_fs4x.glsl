

#version 410


uniform sampler2D uImage00;
uniform sampler2D uImage01;


layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;


void main()
{
	

	rtFragColor = texture(uImage01, texCoorVar.xy);
}
