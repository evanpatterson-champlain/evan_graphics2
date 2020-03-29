

#version 410


uniform sampler2D uImage00;

layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;


void main()
{
	rtFragColor = texture(uImage00, texCoorVar.xy);
}
