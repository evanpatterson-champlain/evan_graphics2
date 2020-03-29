

#version 410


uniform sampler2D uImage00;

layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;


vec4 iBasis = vec4(1.0, 0.0, 0.0, 0.0);
vec4 jBasis = vec4(0.0, 1.0, 0.0, 0.0);

vec4 rot45Basis = vec4(0.70710678118, 0.70710678118, 0.0, 0.0);
vec4 rot135Basis = vec4(-0.70710678118, 0.70710678118, 0.0, 0.0);

float lineSize = 0.005;
float tolerance = 0.002;


void main()
{
	
	vec4 camDistance = texture(uImage00, texCoorVar.xy);

	vec4 rightLoc = texCoorVar + (iBasis * lineSize);
	vec4 leftLoc = texCoorVar - (iBasis * lineSize);
	vec4 upLoc = texCoorVar + (jBasis * lineSize);
	vec4 downLoc = texCoorVar - (jBasis * lineSize);

	bool rightDiff = (camDistance.x - textureProj(uImage00, rightLoc).x) > tolerance;
	bool leftDiff = (camDistance.x - textureProj(uImage00, leftLoc).x) > tolerance;
	bool upDiff = (camDistance.x - textureProj(uImage00, upLoc).x) > tolerance;
	bool downDiff = (camDistance.x - textureProj(uImage00, downLoc).x) > tolerance;


	vec4 topRightLoc = texCoorVar + (rot45Basis * lineSize);
	vec4 topLeftLoc = texCoorVar + (rot135Basis * lineSize);
	vec4 bottonRightLoc = texCoorVar - (rot135Basis * lineSize);
	vec4 bottomLeftLoc = texCoorVar - (rot45Basis * lineSize);

	bool topRightDiff = (camDistance.x - textureProj(uImage00, topRightLoc).x) > tolerance;
	bool topLeftDiff = (camDistance.x - textureProj(uImage00, topLeftLoc).x) > tolerance;
	bool bottonRightDiff = (camDistance.x - textureProj(uImage00, bottonRightLoc).x) > tolerance;
	bool bottomLeftDiff = (camDistance.x - textureProj(uImage00, bottomLeftLoc).x) > tolerance;


	float lineModifier = 1.0;
	if (rightDiff || leftDiff || upDiff || downDiff) {
		lineModifier = 0.0;
	}
	if(topRightDiff || topLeftDiff || bottonRightDiff || bottomLeftDiff){
		lineModifier = 0.0;
	}

	rtFragColor = vec4(vec3(lineModifier), 1.0);
	
}
