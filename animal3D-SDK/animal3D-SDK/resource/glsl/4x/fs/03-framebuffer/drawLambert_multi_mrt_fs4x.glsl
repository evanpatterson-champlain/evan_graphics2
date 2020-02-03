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
	
	drawLambert_multi_mrt_fs4x.glsl
	Draw Lambert shading model for multiple lights with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
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

//out vec4 rtFragColor;

layout (location = 0) out vec4 colorOut;
layout (location = 1) out vec4 viewPosOut;
layout (location = 2) out vec4 viewNormOut;
layout (location = 3) out vec4 texCoorOut;
layout (location = 4) out vec4 diffMapOut;
layout (location = 6) out vec4 diffTotalOut;



void main()
{
	vec4 tex_out = max(textureProj(uTex_dm, texCoorVar), 0.0);

	float lighting = 0.0;

	vec4 col = vec4(0.0);

	vec4 normalizedNormal = normalize(normVar);

	for(int i = 0; i < uLightPos.length; i++){
		lighting += max(dot(normalizedNormal, normalize(uLightPos[i] - viewSpacePos)), 0.0);
		col += uLightCol[i] * dot(normalizedNormal, normalize(uLightPos[i] - viewSpacePos));
	}

	col /= 4.0;
	
	// full color
	colorOut = mix(max(tex_out * lighting, 0.0), col, 0.5);
	colorOut.a = 1.0;

	// view position
	viewPosOut = viewSpacePos;

	// normal
	viewNormOut = normalizedNormal;
	viewNormOut.a = 1.0;
	
	// texture coordinates
	texCoorOut = texCoorVar;

	// diffuse map
	diffMapOut = min(tex_out * lighting, 1.0);
	diffMapOut.a = 1.0;

	// diffuse total
	diffTotalOut = mix(vec4(1.0), col*4.0, 0.3) * lighting;
	diffTotalOut.a = 1.0;

}
