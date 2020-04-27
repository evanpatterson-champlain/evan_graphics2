

#version 410


uniform sampler2D uImage00;

layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;

uniform vec2 uSize;


const int matrixSize = 400;
const int matrixDimension = 20;
const int middleValue = matrixDimension / 2;

float halfDimension = float(matrixDimension) / 2.0;

vec4 localSamples;


float similarity = 0.95;
float distRange = 0.2;

float lineWidth = 0.5;


vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
vec4 green = vec4(0.0, 1.0, 0.0, 1.0);
vec4 white = vec4(1.0);
vec4 black = vec4(vec3(0.0), 1.0);




void main()
{
	rtFragColor = white;

	distRange = 0.3 + (cos((texCoorVar.x) * 3.14159 * 50.0) * 0.1);
	// sampling all around to see if there are lines to copy from
	int matrixIndex;
	for(int i = 0; i < matrixDimension; i++) {
		for(int j = 0; j < matrixDimension; j++) {
			matrixIndex = (i * matrixDimension) + j;
			vec2 thisVector = vec2(i - middleValue, j - middleValue);
			vec2 otherloc = texCoorVar.xy + (uSize * thisVector);
			localSamples = texture(uImage00, otherloc);
			if(localSamples.r == 0.0) { // if sampled pixel is on a line
				
				vec2 otherDirection = normalize((localSamples.gb * 2.0)-1.0);
				vec2 thisDirection = normalize(thisVector);

				float otherDist = cos((otherloc.x + otherloc.y) * 3.14159 * 30.0) * lineWidth;
				float thisDist = length(thisVector);

				float dotProduct = dot(otherDirection, thisDirection);
				float distanceDifference = abs(abs(otherDist) - (thisDist/halfDimension));

				if((distanceDifference < distRange && (-sign(otherDist) * dotProduct) > similarity)){
					rtFragColor = black;
				}

			}
		}
	}
}
