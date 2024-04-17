#version 300 es

/* Assignment 5: Artistic Rendering
 * Original C++ implementation by UMN CSCI 4611 Instructors, 2012+
 * GopherGfx implementation by Evan Suma Rosenberg <suma@umn.edu>, 2022-2024
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CSCI 4611 IS PROHIBITED
 */ 

precision mediump float;

#define POINT_LIGHT 0
#define DIRECTIONAL_LIGHT 1

const int MAX_LIGHTS = 8;

uniform vec3 eyePosition;

uniform int numLights;
uniform int lightTypes[MAX_LIGHTS];
uniform vec3 lightPositions[MAX_LIGHTS];
uniform vec3 ambientIntensities[MAX_LIGHTS];
uniform vec3 diffuseIntensities[MAX_LIGHTS];
uniform vec3 specularIntensities[MAX_LIGHTS];

uniform vec3 kAmbient;
uniform vec3 kDiffuse;
uniform vec3 kSpecular;
uniform float shininess;

uniform int useTexture;
uniform sampler2D textureImage;

uniform sampler2D diffuseRamp;
uniform sampler2D specularRamp;

in vec3 vertPositionWorld;
in vec3 vertNormalWorld;
in vec4 vertColor;
in vec2 uv;

out vec4 fragColor;

// You should modify this fragment shader to implement a toon shading model
// First, you should copy and paste the code from your Phong fragment shader.
// Then, you can then modify it to use the diffuse and specular ramps. 

void main() 
{
    vec3 n = normalize(vertNormalWorld);

    // light calculations
    vec3 illumination = vec3(0, 0, 0);
    for(int i=0; i < numLights; i++)
    {
        // Ambient component
        illumination += kAmbient * ambientIntensities[i];

        // Don't forget to normalize the vectors!
        vec3 l;
        if(lightTypes[i] == POINT_LIGHT)
            l = normalize(lightPositions[i] - vertPositionWorld);
        else
            l = normalize(lightPositions[i]); 

        // Diffuse component
        float diffuseIntensity = (dot(n, l) + 1.0) / 2.0;
        vec3 diffuseComponent = texture(diffuseRamp, vec2(diffuseIntensity, 0.5)).rgb;
        illumination += diffuseComponent * kDiffuse * diffuseIntensities[i];

        // Compute the vector from the vertex to the eye
        vec3 e = normalize(eyePosition - vertPositionWorld);

        // Compute the halfway vector for the Blinn-Phong reflection model
        vec3 h = normalize(l + e);

        // Specular component
        float specularIntensity = pow(max(dot(h, n), 0.0), shininess);
        vec3 specularComponent = texture(specularRamp, vec2(specularIntensity, 0.5)).rgb;
        illumination += specularComponent * kSpecular * specularIntensities[i];
    }

    fragColor = vertColor;
    fragColor.rgb *= illumination;

    if(useTexture != 0)
    {
        fragColor *= texture(textureImage, uv);
    }
}