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
	
	passLightingData_transform_vs4x.glsl
	Vertex shader that prepares and passes lighting data. Outputs transformed 
		position attribute and all others required for lighting.
*/

#version 410

layout (location = 0) in vec4 aPosition;

uniform mat4 uMV;
uniform mat4 uP;

out vec4 viewSpacePos;

// normals
layout (location = 2) in vec4 normIn;
uniform mat4 uMV_nrm;
out vec4 normVar;


layout (location = 8) in vec4 texCoor;
uniform mat4 uAtlas;
out vec4 texCoorVar;


layout (location = 10) in vec4 tangIn;


out vec4 viewPos_;


out vec4 absolutePosition;


void main()
{
	viewSpacePos = uMV * aPosition;

	viewPos_ = aPosition;

	normVar = uMV_nrm * normIn;
	gl_Position = uP * viewSpacePos;
	
	//texture
	texCoorVar = uAtlas * texCoor;

	absolutePosition = aPosition;
}