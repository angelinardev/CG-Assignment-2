#version 440

// Include our common vertex shader attributes and uniforms
#include "../fragments/vs_common.glsl"
#include "../fragments/math_constants.glsl"

layout(location = 7) out vec3 outTexWeights;
uniform float u_Scale;

uniform sampler2D myTextureSampler;

void main() {

	vec3 vert = inPosition;
	vert.z = texture(myTextureSampler, inUV).r * u_Scale; //change r to whatever colour we need

	vec3 displacedPos = inPosition +(inNormal * vert.z);
	//pass to frag shader
	//height = vert.z;

	gl_Position = u_ModelViewProjection * vec4(vert, 1.0);

	// Lecture 5
	// Pass vertex pos in world space to frag shader
	outWorldPos = (u_Model * vec4(vert, 1.0)).xyz;

	// Normals
	outNormal = mat3(u_NormalMatrix) * inNormal;

    // We use a TBN matrix for tangent space normal mapping
    vec3 T = normalize(vec3(mat3(u_NormalMatrix) * inTangent));
    vec3 B = normalize(vec3(mat3(u_NormalMatrix) * inBiTangent));
    vec3 N = normalize(vec3(mat3(u_NormalMatrix) * inNormal));
    mat3 TBN = mat3(T, B, N);

    // We can pass the TBN matrix to the fragment shader to save computation
    outTBN = TBN;

	// Pass our UV coords to the fragment shader
	outUV = inUV;

	///////////
	outColor = inColor;

	// We have some calculation to determine the texture weights
    // In this case, we are going to use cos and sin to generate texture
    // weights based on the z coord of the model in world coords
//    outTexWeights = vec3(
//        (sin(outWorldPos.z /u_Scale + M_PI) + 1) / 2,
//        (sin(outWorldPos.z /u_Scale) + 1) / 2, (sin(outWorldPos.z /u_Scale)+1.0)/3 
//    );
//	outTexWeights = vec3(
//        (sin(2.0*outWorldPos.z /u_Scale + 7.0*M_PI/2) + 1) / 2,
//        (sin(2.0*outWorldPos.z /u_Scale + M_PI) + 1) / 4, (sin(2.0*outWorldPos.z /u_Scale + M_PI/2) + 1) / 4
//    );
	outTexWeights = vec3(
        (sin(2.0*outWorldPos.z /u_Scale + 7.0*M_PI/2) + 1) / 2,
        (sin(2.0*outWorldPos.z /u_Scale + M_PI/2) + 1) / 4, (sin(2.0*outWorldPos.z /u_Scale + M_PI) + 1) / 4
    );
	

}