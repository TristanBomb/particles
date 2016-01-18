#include "SDL2/SDL.h"
#define GLEW_STATIC
#include "GL/glew.h"
#include "SDL2/SDL_opengl.h"
#include <stdio.h>

const char* vertShader =  "#version 150"
							"in vec2 position //position of the point to shade"
							"void main()"
							"{"
							"	gl_Position = vec4(position, 0.0, 1.0);"
							"}";

const char* fragShader =   "#version 150"
							"out vec4 outColor //the color of the output pixel"
							"void main()"
							"{"
							"	outColor = vec4(1.0, 1.0, 1.0, 1.0);"
							"}";

int running = 1;
int mouseX = 0; 
int mouseY = 0;

GLuint makeGLShaders(vertexSource, fragmentSource)
{
	//now init the vertex shader
	GLint status; //gonna use this for both
	GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
	glShaderSource(vertexShader, 1, vertexSource, NULL);
	glCompileShader(vertexShader);
	glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &status);
	if (status != GL_TRUE)
	{
		return 0;
	}
	//now init the fragment (screenspace) shader
	GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(fragmentShader, 1, fragmentSource, NULL);
	glCompileShader(fragmentShader);
	glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &status);
	if (status != GL_TRUE)
	{
		return 0;
	}
	//now, put the two into a shader program
	GLuint shaderProgram = glCreateProgram();
	glAttachShader(shaderProgram, vertexShader);
	glAttachShader(shaderProgram, fragmentShader);
	//fragment shaders can write to weird output, but
	//we want the default: output 0.
	glBindFragDataLocation(shaderProgram, 0, "outColor");
	glLinkProgram(shaderProgram);
	return shaderProgram;
}

int initGL()
{
	float vertices[] = {
		-0.5f, 0.5f, //Vertex 1 (x,y)
		0.5f, 0.5f,  //Vertex 2
		0.5f, -0.5f, //Vertex 3
		-0.5f, -0.5f //Vertex 4
	};
	GLuint vao; //vertex array object
	//this just stores calls to "glVertexAttribPointer"
	glGenVertexArrays(1, &vao);
	glBindVertexArray(vao);
	GLuint vbo; //vertex buffer object
	//pretty much, this buffers the vertices to the
	//GPU instead of keeping them in RAM. this is
	//also what gets blitted to the screen
	glGenBuffers(1, &vbo); 
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
	GLuint shaderProgram = makeGLShaders(vertShader, fragShader);
	if (!shaderProgram)
	{
		return 0;
	}
	glUseProgram(shaderProgram);
	//now we have to link the input "position" with the actual vertex position
	//for the vertex shader.
	GLint posAttribute = glGetAttribLocation(shaderProgram, "position");
	glVertexAttribPointer(posAttribute, 2, GL_FLOAT, GL_FALSE, 0, 0);
	glEnableVertexAttribArray(posAttribute);
	if (glGetError() == GL_NO_ERROR) {
		return 1; //woo we did it, we init'd openGL
	}
	return 0;
}

void renderGL(SDL_Window* window)
{
	glDrawArrays(GL_TRIANGLES, 0, 4);
	SDL_GL_SwapWindow(window);
}

void handleEvents()
{
	SDL_Event ev;
	while (SDL_PollEvent(&ev))
	{
		if (ev.type == SDL_QUIT)
		{
			running = 0;
		} 
		else if (ev.type == SDL_MOUSEMOTION)
		{
			mouseX = ev.motion.x;
			mouseY = ev.motion.y;
		}
	}
}

int main(int argc, char** argv)
{
	if (SDL_Init(SDL_INIT_VIDEO) != 0)
	{
		printf("SDL_Init failed: %s\n", SDL_GetError());
		return -1;
	}
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
	SDL_Window* window = SDL_CreateWindow("Particles", 0, 0, 1366, 768, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN);
	if (!window)
	{
		printf("SDL_CreateWindow failed: %s\n", SDL_GetError());
		SDL_Quit();
		return -1;
	}
	SDL_GLContext glContext = SDL_GL_CreateContext(window);
	if (!glContext)
	{
		printf("OpenGL context failed: %s\n", SDL_GetError());
		SDL_DestroyWindow(window);
		SDL_Quit();
		return -1;
	}
	if (glewInit() != GLEW_OK)
	{
		printf("GLEW init failed: \n");
		SDL_GL_DeleteContext(glContext);
		SDL_DestroyWindow(window);
		SDL_Quit();
	}
	if (!initGL())
	{
		printf("OpenGL init failed\n");
		SDL_GL_DeleteContext(glContext);
		SDL_DestroyWindow(window);
		SDL_Quit();
	}
	while (running)
	{
		renderGL(window);
		handleEvents();
	}
	SDL_GL_DeleteContext(glContext);
	SDL_DestroyWindow(window);
	SDL_Quit();
	return 0;
}