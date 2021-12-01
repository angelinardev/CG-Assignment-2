#version 440

// Include our common vertex shader attributes and uniforms
#include "../fragments/vs_common.glsl"
#include "../fragments/math_constants.glsl"

uniform float u_Scale;
uniform float delta;
uniform sampler2D myTextureSampler;


void main() {

	vec3 vert = inPosition;
	vert.z = texture(myTextureSampler, inUV).r * u_Scale; //change r to whatever colour we need

	vec3 displacedPos = inPosition +(inNormal * vert.z);

	vert.z = (sin(vert.x * 2.5 + (delta/2)) * 0.01 + (sin(vert.y * 1.0 + (delta/2))*0.04));

	gl_Position = u_ModelViewProjection * vec4(vert, 1.0);

	// Lecture 5
	// Pass vertex pos in world space to frag shader
	outWorldPos = (u_Model * vec4(vert, 1.0)).xyz;

	// Normals
	outNormal = mat3(u_NormalMatrix) * inNormal;

 

	// Pass our UV coords to the fragment shader
	outUV = inUV;
	///////////
	outColor = inColor;

	}