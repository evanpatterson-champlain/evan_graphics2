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
uniform sampler2D uImage01;


uniform vec2 uSize;


in vec4 texCoorVar;


layout (location = 0) out vec4 rtFragColor;

int matrixDimension = 6;


vec3 getImage00(vec2 coord){
	return texture(uImage00, coord).rgb;
}

vec3 getImage01(vec2 coord){
	return texture(uImage01, coord).rgb;
}


void main()
{

	vec3 myId = getImage00(texCoorVar.xy);
	float n = 0;
	vec3 aveColor = vec3(0.0);
	for(int i = -matrixDimension; i <= matrixDimension; i++) {
		for(int j = -matrixDimension; j <= matrixDimension; j++) {
			vec2 offset = texCoorVar.xy + (uSize * vec2(i, j));
			if(myId == getImage00(offset)){
				n+=1;
				aveColor += getImage01(offset);
			}
		}
	}

	//also try gaussian blur but on neighboring cells

	rtFragColor = vec4(aveColor/n, 1.0);
}
