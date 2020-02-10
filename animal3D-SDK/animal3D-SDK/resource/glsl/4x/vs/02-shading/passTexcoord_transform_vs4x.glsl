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
	
	passTexcoord_transform_vs4x.glsl
	Vertex shader that passes texture coordinate. Outputs transformed position 
		attribute and atlas transformed texture coordinate attribute.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for MVP matrix; see demo code for hint
//	2) correctly transform input position by MVP matrix
//	3) declare texture coordinate attribute; see graphics library for location
//	4) declare atlas transform; see demo code for hint
//	5) declare texture coordinate outbound varying
//	6) correctly transform input texture coordinate by atlas matrix

layout (location = 0) in vec4 aPosition;

uniform mat4 uMVP;
uniform mat4 uMV;

layout (location = 8) in vec4 texCoor;
uniform mat4 uAtlas;
out vec4 texCoorVar;

layout (location = 2) in vec4 normIn;
uniform mat4 uMV_nrm;
out vec4 normVar;

out vec4 viewForNormal;

void main()
{
	gl_Position = uMVP * aPosition;
	texCoorVar = uAtlas * texCoor;
	normVar = uMV_nrm * normIn;
	viewForNormal = uMV * aPosition;
}