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
	
	drawLambert_multi_fs4x.glsl
	Draw Lambert shading model for multiple lights.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!





uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];

uniform sampler2D uTex_dm;


// in position
in vec4 viewSpacePos;
in vec4 normVar;

// in texture
in vec4 texCoorVar;

out vec4 rtFragColor;


void main()
{
	vec4 tex_out = max(textureProj(uTex_dm, texCoorVar).rgba, 0.0);

	float lighting = 0.0;

	vec4 col = vec4(0.0);

	vec4 normalizedNormal = normalize(normVar);

	for(int i = 0; i < uLightPos.length; i++){
		lighting += max(dot(normalizedNormal, normalize(uLightPos[i] - viewSpacePos)), 0.0);
		col += uLightCol[i] * dot(normalizedNormal, normalize(uLightPos[i] - viewSpacePos));
	}

	col /= 4.0;
	
	rtFragColor = mix(max(tex_out * lighting, 0.0), col, 0.5);
}