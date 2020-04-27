

#version 410


uniform sampler2D uImage00;
uniform sampler2D uImage01;

layout (location = 0) out vec4 rtFragColor;

in vec4 texCoorVar;

uniform vec2 uSize;


vec4 iBasis = vec4(1.0, 0.0, 0.0, 0.0);
vec4 jBasis = vec4(0.0, 1.0, 0.0, 0.0);

vec4 rot45Basis = vec4(1.0, 1.0, 0.0, 0.0);
vec4 rot135Basis = vec4(-1.0, 1.0, 0.0, 0.0);

vec2 lineSize = uSize;
float tolerance = 0.002;



vec4 red = vec4(1.0, 0.0, 0.0, 1.0);


vec4 multiply(vec4 v4, vec2 v2){
	return vec4(v4.x * v2.x, v4.y * v2.y, v4.z, v4.w);
}

vec2 getNormal(){
	return texture(uImage01, texCoorVar.xy).rg;
}

vec2 passNormal(float difference, vec4 loc, float camDist, vec2 normal){
	vec2 newNormal = abs(1.0 - difference) * step(camDist - textureProj(uImage00, loc).x, 0.0) * getNormal();
	if(normal == vec2(0.0)){
		return newNormal;
	}
	else{
		return normal;
	}
}


void main()
{
	
	vec4 camDistance = texture(uImage00, texCoorVar.xy);

	vec4 rightLoc = texCoorVar + multiply(iBasis, lineSize);
	vec4 leftLoc = texCoorVar - multiply(iBasis, lineSize);
	vec4 upLoc = texCoorVar + multiply(jBasis, lineSize);
	vec4 downLoc = texCoorVar - multiply(jBasis, lineSize);

	float rightDiff = step(abs(camDistance.x - textureProj(uImage00, rightLoc).x),		tolerance);
	float leftDiff	= step(abs(camDistance.x - textureProj(uImage00, leftLoc).x),		tolerance);
	float upDiff	= step(abs(camDistance.x - textureProj(uImage00, upLoc).x),		tolerance);
	float downDiff	= step(abs(camDistance.x - textureProj(uImage00, downLoc).x),		tolerance);


	vec4 topRightLoc = texCoorVar + multiply(rot45Basis, lineSize);
	vec4 topLeftLoc = texCoorVar + multiply(rot135Basis, lineSize);
	vec4 bottonRightLoc = texCoorVar - multiply(rot135Basis, lineSize);
	vec4 bottomLeftLoc = texCoorVar - multiply(rot45Basis, lineSize);

	float topRightDiff			= step(abs(camDistance.x - textureProj(uImage00, topRightLoc).x),		tolerance);
	float topLeftDiff			= step(abs(camDistance.x - textureProj(uImage00, topLeftLoc).x),		tolerance);
	float bottonRightDiff		= step(abs(camDistance.x - textureProj(uImage00, bottonRightLoc).x),	tolerance);
	float bottomLeftDiff		= step(abs(camDistance.x - textureProj(uImage00, bottomLeftLoc).x),		tolerance);


	float lineModifier = rightDiff * leftDiff * upDiff * downDiff * topRightDiff * topLeftDiff * bottonRightDiff * bottomLeftDiff;

	vec2 normalAngle = vec2(0.0);

	normalAngle = passNormal(rightDiff, rightLoc, camDistance.x, normalAngle);
	normalAngle = passNormal(leftDiff, leftLoc, camDistance.x, normalAngle);
	normalAngle = passNormal(upDiff, upLoc, camDistance.x, normalAngle);
	normalAngle = passNormal(downDiff, downLoc, camDistance.x, normalAngle);
	normalAngle = passNormal(topRightDiff, topRightLoc, camDistance.x, normalAngle);
	normalAngle = passNormal(topLeftDiff, topLeftLoc, camDistance.x, normalAngle);
	normalAngle = passNormal(bottonRightDiff, bottonRightLoc, camDistance.x, normalAngle);
	normalAngle = passNormal(bottomLeftDiff, bottomLeftLoc, camDistance.x, normalAngle);

	rtFragColor = vec4(lineModifier, normalAngle, 1.0);
}
