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

in vec3 position;
in vec3 normal;
in vec4 color;
in vec2 texCoord;

out vec3 vertPositionWorld;
out vec3 vertNormalWorld;
out vec4 vertColor;
out vec2 uv;

// You should copy and paste the code from your Phong vertex shader.
// You do not need to further modify it.

void main() 
{
    vertPositionWorld = (modelMatrix * vec4(position, 1)).xyz;
    vertNormalWorld = normalize((normalMatrix * vec4(normal, 0)).xyz);
    vertColor = color;
    uv = texCoord.xy; 
    gl_Position = projectionMatrix * viewMatrix * vec4(vertPositionWorld, 1);
}