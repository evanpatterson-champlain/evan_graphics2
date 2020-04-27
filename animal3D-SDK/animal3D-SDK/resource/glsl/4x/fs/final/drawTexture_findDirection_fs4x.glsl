

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
vec4 green = vec4(0.0, 1.0, 0.0, 1.0);
vec4 white = vec4(1.0);

in vec4 absCoord;

vec2 iBasis = vec2(1.0, 0.0);
vec2 jBasis = vec2(0.0, 1.0);

vec2 getNormal(){
	vec2 dir = texture(uImage00, texCoorVar.xy).gb;
	if(dir == vec2(0.0)) {
		return vec2(0.0);
	}
	else {
		return (dir * 2.0)-1.0;
	}
}


float magnitude(vec2 vec){
	return sqrt((vec.x * vec.x) + (vec.y * vec.y));
}


void main()
{
	// sample from line map
	vec4 thisPoint = texture(uImage00, texCoorVar.xy);


	
	if(thisPoint.r == 0.0 && getNormal() != vec2(0.0)){
		int matrixIndex;
		for(int i = 0; i < matrixDimension; i++) {
			for(int j = 0; j < matrixDimension; j++) {
				matrixIndex = (i * matrixDimension) + j;
				localLines[matrixIndex] = uSize * vec2(i - middleValue, j - middleValue);
			}
		}

		vec2 direction1 = vec2(0.0);
		vec2 direction2 = vec2(0.0);
		vec2 direction = vec2(0.0);
		for(int i = 0; i < matrixDimension; i++) {
			for(int j = 0; j < matrixDimension; j++) {
				matrixIndex = (i * matrixDimension) + j;
				if(texture(uImage00, texCoorVar.xy + localLines[matrixIndex]).r == 0.0){
					vec2 curDirection = vec2((i - middleValue), (j - middleValue));
					curDirection *= sign(curDirection.x);
					if(curDirection.y > 0){
						direction1 += curDirection;
					}
					else{
						direction2 += curDirection;
					}
				}
			}
		}

		if(magnitude(direction1) > magnitude(direction2)){
			direction = normalize(direction1);
		}
		else{
			direction = normalize(direction2);
		}

		vec2 invDirection1 = vec2(-direction.y, direction.x); // clockwise
		vec2 invDirection2 = vec2(direction.y, -direction.x); // counter

		if(dot(invDirection1, getNormal()) > dot(invDirection2, getNormal()) && invDirection1.y > invDirection2.y){
			direction = invDirection1;
		}
		else{
			direction = invDirection2;
		}

		rtFragColor = vec4(0.0, ((direction)+1.0)/2.0, 1.0);

		

	}
	else{
		rtFragColor = vec4(1.0, 1.0, 1.0, 1.0);
	}

	
}
