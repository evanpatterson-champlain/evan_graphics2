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
uniform sampler2D uTex_sm;

uniform sampler2D uImage02;

uniform double uTime;


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
layout (location = 5) out vec4 specMapOut;
layout (location = 6) out vec4 diffTotalOut;
layout (location = 7) out vec4 specTotalOut;


out vec4 rtFragColor;


vec4 red = vec4(1.0, 0.0, 0.0, 1.0);


float fullAve(vec3 v1){
	return (v1.x + v1.y + v1.z) / 3.0;
}

float sigmoid(float n, float slope, float threshold){
	return 1.0 / (1.0 + exp(-slope * (n - threshold)));
}


void main()
{
	vec3 tex_out = max(textureProj(uTex_dm, texCoorVar), 0.0).rgb;
	vec3 tex_out_s = max(textureProj(uTex_sm, texCoorVar), 0.0).rgb;

	float lightingTotal = 0.0; // lighting is basically diffuse
	float specularTotal = 0.0;

	vec3 colDiffuse = vec3(0.0);
	vec3 colSpecular = vec3(0.0);

	vec4 normalizedNormal = normalize(normVar);
	vec3 usedNormal = normalizedNormal.xyz;

	for(int i = 0; i < uLightPos.length; i++){
		vec3 l = normalize(uLightPos[i].xyz - viewSpacePos.xyz);
		float lighting = max(dot(usedNormal, l), 0.0);
		float specular = pow(max(dot(reflect(-l, usedNormal), normalize(-viewSpacePos.xyz)), 0.0), 8.0) * 0.7;

		lightingTotal += lighting;
		specularTotal += specular;

		colDiffuse += uLightCol[i].rgb * lighting;
		colSpecular += uLightCol[i].rgb * specular;
	}


	float pencilMarks1 = texture(uImage02, texCoorVar.xy).r;

	//colorOut = vec4(max((colDiffuse * tex_out) + (colSpecular * tex_out_s), 0.0), 1.0);

	vec4 stripes = max(vec4(mix(vec3(pencilMarks1), vec3(1.0), sigmoid(fullAve(colDiffuse) + fullAve(colSpecular), 5.0, 0.8)), 1.0), 0.0);


	colorOut = min(vec4(step(0.5, stripes.r) + tex_out, 1.0), 1.0);

	
	// view position
	viewPosOut = viewSpacePos;

	// normal
	viewNormOut = vec4(usedNormal, 1.0);

	// texture coordinates
	texCoorOut = texCoorVar;

	// diffuse map
	diffMapOut = vec4(tex_out, 1.0);

	// specular map
	specMapOut = vec4(tex_out_s, 1.0);

	// diffuse total
	diffTotalOut = vec4(colDiffuse, 1.0);

	// specular total
	specTotalOut = vec4(colSpecular, 1.0);


}
