

#version 410

uniform sampler2D uImage00;
uniform sampler2D uImage01;

layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;

uniform vec2 uSize;

const int matrixSize = 36;
const int matrixDimension = 6;
const int middleValue = matrixDimension / 2;

vec2 localLines[matrixSize];

vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
vec4 white = vec4(1.0);

in vec4 absCoord;

void main()
{
	// sample from line map
	vec4 thisPoint = texture(uImage00, texCoorVar.xy);


	
	if(thisPoint.x == 0.0){
		int matrixIndex;
		for(int i = 0; i < matrixDimension; i++) {
			for(int j = 0; j < matrixDimension; j++) {
				matrixIndex = (i * matrixDimension) + j;
				localLines[matrixIndex] = uSize * vec2(i - middleValue, j - middleValue);
			}
		}

		vec2 direction = vec2(0.0);
		for(int i = 0; i < matrixDimension; i++) {
			for(int j = 0; j < matrixDimension; j++) {
				matrixIndex = (i * matrixDimension) + j;
				if(texture(uImage00, texCoorVar.xy + localLines[matrixIndex]).r == 0.0){
					vec2 curDirection = vec2((i - middleValue), (j - middleValue));
					curDirection *= sign(curDirection.x);
					direction += curDirection;
				}
			}
		}

		direction = normalize(direction);

		// distance and direction are passed on
		float absDistance = (cos((texCoorVar.x + texCoorVar.y) * 3.14159 * 50.0) + 1.0) / 3.0;

		rtFragColor = vec4(0.0, direction * absDistance, 1.0);
		
	}
	else{
		rtFragColor = vec4(1.0);
	}


	
}
