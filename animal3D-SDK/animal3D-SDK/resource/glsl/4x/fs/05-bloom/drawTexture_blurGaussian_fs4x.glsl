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
	
	drawTexture_blurGaussian_fs4x.glsl
	Draw texture with Gaussian blurring.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) declare uniforms for pixel size and sampling axis
//	2) implement Gaussian blur function using a 1D kernel (hint: Pascal's triangle)
//	3) sample texture using Gaussian blur function and output result

uniform sampler2D uImage00;

uniform vec2 uAxis;
uniform vec2 uSize;


in vec4 texCoorVar;


layout (location = 0) out vec4 rtFragColor;





const int numbOfColors = 9;


vec3 outColors[numbOfColors];
float weights[numbOfColors];



float MultiplyBySelf(float num, int p){
	for(int i = 0; i < p; i++){
		num *= num;
	}
	return num;
}


vec4 Add(vec4 lhs, vec2 rhs){
	return vec4(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z, lhs.w);
}


void InitWeights(){
	weights[0] = 70;
	weights[1] = 56;
	weights[2] = 56;
	weights[3] = 28;
	weights[4] = 28;
	weights[5] = 8;
	weights[6] = 8;
	weights[7] = 1;
	weights[8] = 1;
}


vec3 GenerateColors(vec4 textureCoordinates, vec2 offset){
	for(int i = 0; i < numbOfColors; i++){
		float n = float(i);
		vec2 offsetCur = offset * floor((n + 1.0) / 2.0);
		if(i % 2 == 0){
			offsetCur *= -1.0;
		}
		outColors[i] = textureProj(uImage00, min(max(Add(textureCoordinates, offsetCur), 0.0), 1.0)).rgb * weights[i];
	}
	vec3 sum = vec3(0.0);
	for(int i = 0; i < numbOfColors; i++){
		sum += outColors[i];
	}
	return sum;
}




void main()
{
	InitWeights();
	vec3 outColor = GenerateColors(texCoorVar, uAxis * uSize);
	rtFragColor = vec4(outColor/MultiplyBySelf(2.0, 3), 1.0);
}
