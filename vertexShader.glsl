#version 150
in vec4 position;
void main() 
{
	gl_Position = vec4(position, 0.0, 1.0);
}