/*
	Copyright 2011-2020 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	drawTexture_outline_fs4x.glsl
	Draw texture sample with outlines.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) implement outline algorithm - see render code for uniform hints

out vec4 rtFragColor;

uniform sampler2D uTex_dm;

in vec4 texCoorVar;

uniform vec4 uColor;
uniform double uAxis;
uniform vec2 uSize;

uniform sampler2D uImage1;

vec4 iBasis = vec4(1.0, 0.0, 0.0, 0.0);
vec4 jBasis = vec4(0.0, 1.0, 0.0, 0.0);

float lineSize = 0.005;
float tolerance = 0.003;



void main()
{
	
	vec4 camDistance = textureProj(uImage1, texCoorVar);

	vec4 rightLoc = texCoorVar + (iBasis * lineSize);
	vec4 leftLoc = texCoorVar - (iBasis * lineSize);
	vec4 upLoc = texCoorVar + (jBasis * lineSize);
	vec4 downLoc = texCoorVar - (jBasis * lineSize);

	bool rightDiff = (camDistance.x - textureProj(uImage1, rightLoc).x) > tolerance;
	bool leftDiff = (camDistance.x - textureProj(uImage1, leftLoc).x) > tolerance;
	bool upDiff = (camDistance.x - textureProj(uImage1, upLoc).x) > tolerance;
	bool downDiff = (camDistance.x - textureProj(uImage1, downLoc).x) > tolerance;

	float lineModifier;
	if (rightDiff || leftDiff || upDiff || downDiff) {
		lineModifier = 0.0;
	}
	else {
		lineModifier = 1.0;
	}

	rtFragColor = textureProj(uTex_dm, texCoorVar) * lineModifier;
	

}
