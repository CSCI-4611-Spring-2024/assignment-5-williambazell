#version 300 es

/* Assignment 5: Artistic Rendering
 * Original C++ implementation by UMN CSCI 4611 Instructors, 2012+
 * GopherGfx implementation by Evan Suma Rosenberg <suma@umn.edu>, 2022-2024
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CSCI 4611 IS PROHIBITED
 */ 


precision mediump float;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform float thickness;

in vec3 position;
in vec3 normal;

// You should start by coping and pasting the code from your Phong vertex shader.
// You will then need to modify it to displace each vertex by the outline thickness,
// making the drawn object slightly larger than the original object.
// Note that this shader only needs to calculate gl_Position and does not need to
// pass any other output variables to the fragment shader.

void main() 
{
    // First, you will need compute both the position and normal in world space,
    // then convert them into view space.

    // Next, you should set the z-component of the view space normal to zero
    // and then normalize it. This represents the direction outward from the
    // vertex in XY coordinates relative to the camera.
    
    // The view space vertex position should then be translated in this direction
    // by correct distance, which is the thickness of the silhouette online.

    // Finally, you should project this position into screen coordinates and
    // assign it to the gl_Position variable, which will be passed to the 
    // fragment shader.

    vec3 worldPos = vec3(modelMatrix * vec4(position, 1.0));
    vec3 worldNorm = normalize(vec3(normalMatrix * vec4(normal, 0.0)));
    vec3 viewPos = vec3(viewMatrix * vec4(worldPos, 1.0));
    vec3 viewNorm = normalize(vec3(viewMatrix * vec4(worldNorm, 0.0)));
    vec3 outlineNorm = normalize(vec3(viewNorm.x, viewNorm.y, 0.0));
    vec3 vertexPos = viewPos + outlineNorm * thickness;
    gl_Position = projectionMatrix * vec4(vertexPos, 1.0);
}