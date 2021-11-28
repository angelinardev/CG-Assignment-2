#version 430

#include "../fragments/fs_common_inputs.glsl"

// We output a single color to the color buffer
layout(location = 0) out vec4 frag_color;


layout(location = 7) in vec3 inTextureWeights;
//layout(location = 5) in float inheight;

////////////////////////////////////////////////////////////////
/////////////// Instance Level Uniforms ////////////////////////
////////////////////////////////////////////////////////////////

// Represents a collection of attributes that would define a material
// For instance, you can think of this like material settings in 
// Unity
struct Material {
	sampler2D Diffuse;
	float     Shininess;
	sampler2D sand;
	sampler2D grass;
	sampler2D rock;
};
// Create a uniform for the material
uniform Material u_Material;


////////////////////////////////////////////////////////////////
///////////// Application Level Uniforms ///////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/multiple_point_lights.glsl"

////////////////////////////////////////////////////////////////
/////////////// Frame Level Uniforms ///////////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/frame_uniforms.glsl"

// https://learnopengl.com/Advanced-Lighting/Advanced-Lighting
void main() {
	// Normalize our input normal
	vec3 normal = normalize(inNormal);

	// Will accumulate the contributions of all lights on this fragment
	// This is defined in the fragment file "multiple_point_lights.glsl"
	vec3 lightAccumulation = CalcAllLightContribution(inWorldPos, normal, u_CamPos.xyz, u_Material.Shininess);

	// By we can use this lil trick to divide our weight by the sum of all components
    // This will make all of our texture weights add up to one! 
    vec3 texWeight = inTextureWeights / dot(inTextureWeights, vec3(1,1,1));

	// Perform our texture mixing, we'll calculate our albedo as the sum of the texture and it's weight
	//low height-sand
	//medium height - grass
	//high - rock
	vec4 sandColor = texture(u_Material.sand, inUV);
	vec4 grassColor = texture(u_Material.grass, inUV);
	vec4 rockColor = texture(u_Material.rock, inUV);

	vec4 textureColor = rockColor * texWeight.x + grassColor*texWeight.y + sandColor*texWeight.z;
	//vec4 textureColor = sandColor;
	
	// combine for the final result
	vec3 result = lightAccumulation  * inColor * textureColor.rgb;

	frag_color = vec4(result, textureColor.a);
}
