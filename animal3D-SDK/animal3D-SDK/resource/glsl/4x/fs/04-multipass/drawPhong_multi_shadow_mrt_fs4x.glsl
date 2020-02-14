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
	
	drawPhong_multi_shadow_mrt_fs4x.glsl
	Draw Phong shading model for multiple lights with MRT output and 
		shadow mapping.
*/

#version 410

// ****TO-DO: 
//	0) copy existing Phong shader
//	1) receive shadow coordinate
//	2) perform perspective divide
//	3) declare shadow map texture
//	4) perform shadow test


uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];

uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;

// in position
in vec4 viewSpacePos;
in vec4 normVar;

// in texture
in vec4 texCoorVar;

out vec4 coordinates;


layout (location = 0) out vec4 colorOut;
/*
layout (location = 1) out vec4 viewPosOut;
layout (location = 2) out vec4 viewNormOut;
layout (location = 3) out vec4 texCoorOut;
layout (location = 4) out vec4 diffMapOut;
layout (location = 5) out vec4 specMapOut;
layout (location = 6) out vec4 diffTotalOut;
layout (location = 7) out vec4 specTotalOut;
*/

//shadows
in vec4 shadowCoord;
uniform sampler2D uTex_shadow;
uniform sampler2D uTex_proj;



float pow8(float f){
	f *= f;
	f *= f;
	f *= f;
	return f;
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
		float specular = pow8(max(dot(reflect(-l, usedNormal), normalize(-viewSpacePos.xyz)), 0.0)) * 0.7;

		lightingTotal += lighting;
		specularTotal += specular;

		colDiffuse += uLightCol[i].rgb * lighting;
		colSpecular += uLightCol[i].rgb * specular;
	}
	
	colorOut = vec4(max((colDiffuse * tex_out) + (colSpecular * tex_out_s), 0.0), 1.0);
	

	vec3 shadowCoordXYZ = shadowCoord.xyz / shadowCoord.w;

	float shadowSample = texture2D(uTex_shadow, shadowCoordXYZ.xy).r;


	float s = step(shadowCoordXYZ.z, (shadowSample + 0.0025)) * 0.8;

	colorOut.rgb *= (0.2 + s);

}