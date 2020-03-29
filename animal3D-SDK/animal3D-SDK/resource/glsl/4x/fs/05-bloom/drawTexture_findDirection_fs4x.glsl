

#version 410

uniform sampler2D uImage00;

layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;

const int matrixSize = 36;
const int matrixDimension = 6;
const int middleValue = matrixDimension / 2;

vec2 localLines[matrixSize];

float pixelSize = 1.0 / 512.0;


void main()
{
	// sample from line map
	vec4 thisPoint = texture(uImage00, texCoorVar.xy);




	if(thisPoint.x == 0.0){
		int matrixIndex;
		for(int i = 0; i < matrixDimension; i++) {
			for(int j = 0; j < matrixDimension; j++) {
				matrixIndex = (i * matrixDimension) + j;
				localLines[matrixIndex] = pixelSize * vec2(i - middleValue, j - middleValue);

			}
		}

		vec2 col = vec2(0.0);
		for(int i = 0; i < matrixDimension; i++) {
			for(int j = 0; j < matrixDimension; j++) {
				matrixIndex = (i * matrixDimension) + j;
				if(texture(uImage00, texCoorVar.xy + localLines[matrixIndex]).r == 0.0){
					col += vec2((i - middleValue), (j - middleValue));
				}

			}
		}
		
		rtFragColor = vec4(col, 0.0, 1.0);
	}
	else{
		rtFragColor = vec4(1.0);
	}

	
	
}
