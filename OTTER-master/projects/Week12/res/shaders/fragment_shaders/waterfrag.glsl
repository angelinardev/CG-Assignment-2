#version 430

layout(location = 0) in vec3 inWorldPos;
layout(location = 1) in vec4 inColor;
layout(location = 2) in vec3 inNormal;
layout(location = 3) in vec2 inUV;
// We output a single color to the color buffer
layout(location = 0) out vec4 frag_color;

// Represents a collection of attributes that would define a material
// For instance, you can think of this like material settings in 
// Unity
struct Material {
	sampler2D Diffuse;
	float     Shininess;
	sampler2D water;
};
// Create a uniform for the material
uniform Material u_Material;


// https://learnopengl.com/Advanced-Lighting/Advanced-Lighting
void main() {

// Get the albedo from the diffuse / albedo map
	vec4 textureColor = texture(u_Material.water, inUV);


	frag_color = vec4(textureColor.r,textureColor.g,textureColor.b,0.5);

	}

