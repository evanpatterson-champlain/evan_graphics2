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
	
	drawPhong_multi_mrt_fs4x.glsl
	Draw Phong shading model for multiple lights with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variables for textures; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Phong shading model
//	Note: test all data and inbound values before using them!
//	5) set location of final color render target (location 0)
//	6) declare render targets for each attribute and shading component



uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];

uniform sampler2D uTex_dm;

// in position
in vec4 viewSpacePos;
in vec4 normVar;

// in texture
in vec4 texCoorVar;

layout (location = 0) out vec4 colorOut;
layout (location = 1) out vec4 viewPosOut;
layout (location = 2) out vec4 viewNormOut;
layout (location = 3) out vec4 texCoorOut;
layout (location = 4) out vec4 diffMapOut;
layout (location = 6) out vec4 diffTotalOut;

out vec4 rtFragColor;


void main()
{
	vec4 tex_out = textureProj(uTex_dm, texCoorVar);

	vec3 col = vec3(0.0);

	vec3 outVec = vec3(0.0);

	vec4 normalizedNormVar = normalize(normVar);

	for(int i = 0; i < uLightPos.length; i++){
		vec4 l = normalize(uLightPos[i] - viewSpacePos);
		float lighting = max(dot(normalizedNormVar, l), 0.0);
		vec3 diffuse = tex_out.xyz * lighting;
		vec3 specular = pow(max(dot(reflect(-l, normalizedNormVar), normalize(uLightPos[i] - viewSpacePos)), 0.0), 8.0) * vec3(0.7);

		outVec += diffuse + specular;

		col += uLightCol[i] * dot(normalizedNormVar, normalize(uLightPos[i] - viewSpacePos));
	}

	col /= 4.0;
	
	colorOut = vec4(1.0);//vec4(mix(max(outVec, 0.0), col, 0.5), 1.0);
}
