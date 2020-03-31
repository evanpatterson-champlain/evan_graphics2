

#version 410


uniform sampler2D uImage00;

layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;

uniform vec2 uSize; // about 1216 on my computer


const int matrixSize = 400;
const int matrixDimension = 20;
const int middleValue = matrixDimension / 2;

float halfDimension = float(matrixDimension) / 2.0;

vec4 localSamples;


float similarity = 0.1;
float distRange = 0.2;


vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
vec4 green = vec4(0.0, 1.0, 0.0, 1.0);
vec4 white = vec4(1.0);
vec4 black = vec4(vec3(0.0), 1.0);


void main()
{
	rtFragColor = white;


	//if(texture(uImage00, texCoorVar.xy).r != 0.0){
	// sampling all around to see if there are lines to copy from
	int matrixIndex;
	for(int i = 0; i < matrixDimension; i++) {
		for(int j = 0; j < matrixDimension; j++) {
			matrixIndex = (i * matrixDimension) + j;
			localSamples = texture(uImage00, texCoorVar.xy + (uSize * vec2(i - middleValue, j - middleValue)));
			if(localSamples.r == 0.0) { // if sampled pixel is on a line
				

				vec2 otherVector = localSamples.gb;
				vec2 thisVector = vec2(i - middleValue, j - middleValue);
				
				
				vec2 otherDirection = normalize(localSamples.gb);
				vec2 thisDirection = normalize(thisVector);

				float otherDist = length(otherVector);
				float thisDist = length(thisVector);



				float dotProduct = abs(dot(otherDirection, thisDirection));
				float distanceDifference = abs(otherDist - (thisDist/halfDimension));


				if(distanceDifference < distRange && dotProduct < similarity){
					rtFragColor = black;
				}

			}
		}
	}

	

	
}
