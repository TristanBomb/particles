#include "SDL2/SDL.h"
#include "GL/glew.h"
#include "SDL2/SDL_opengl.h"
#include <stdio.h>
#include "file.h"

int running;
int mouseX;
int mouseY;

int handleGLerror(const char place[])
{
	GLenum error;

	error = glGetError();
	if (error == GL_NO_ERROR) 
	{
		return 0;
	}
	else if (error = GL_INVALID_VALUE) 
	{
		printf("GL_INVALID_VALUE at %s\n", place);	
		return 0;
	}
	else
	{
		printf("%s openGL error: %i\n", place, error);
		return 1;
	}
}

GLuint makeGLShaders(GLchar* vertexSource, GLchar* fragmentSource)
{
	//now init the vertex shader
	GLint status; //gonna use this for both
	GLuint vertexShader;
	GLint vertexLength;
	GLchar errorMessage[256];
	GLuint fragmentShader;
	GLint fragmentLength;
	GLuint shaderProgram;

	vertexShader = glCreateShader(GL_VERTEX_SHADER);
	vertexLength = strlen(vertexSource);
	glShaderSource(vertexShader, 1, (const GLchar * const*)&vertexSource, &vertexLength);
	glCompileShader(vertexShader);
	glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &status);
	if (status != GL_TRUE)
	{
		glGetShaderInfoLog(vertexShader, 256, NULL, errorMessage);
		printf("make vertex shader compile fail: %s\n", errorMessage);
		return 0;
	}
	//now init the fragment (screenspace) shader
	fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
	fragmentShader = strlen(fragmentSource);
	glShaderSource(fragmentShader, 1, (const GLchar * const*)&fragmentSource, &fragmentLength);
	glCompileShader(fragmentShader);
	glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &status);
	if (status != GL_TRUE)
	{
		glGetShaderInfoLog(fragmentShader, 256, NULL, errorMessage);
		printf("make vertex shader compile fail: %s\n", errorMessage);
		return 0;
	}
	handleGLerror("post shader compile");
	//now, put the two into a shader program
	shaderProgram = glCreateProgram();
	glAttachShader(shaderProgram, vertexShader);
	glAttachShader(shaderProgram, fragmentShader);
	handleGLerror("post shader attach");
	//fragment shaders can write to weird output, but
	//we want the default: output 0.
	glBindFragDataLocation(shaderProgram, 0, "outColor");
	glLinkProgram(shaderProgram);
	handleGLerror("post shader link");
	return shaderProgram;
}

int initGL()
{
	GLuint vao; //vertex array object
	//this just stores calls to "glVertexAttribPointer"
	GLuint vbo; //vertex buffer object
	//pretty much, this buffers the vertices to the
	//GPU instead of keeping them in RAM. this is
	//also what gets blitted to the screen
	char vertShader[512];
	char fragShader[512];
	GLuint shaderProgram;
	GLint posAttribute;
	float vertices[] = {
		-0.5f, 0.5f, //Vertex 1 (x,y)
		0.5f, 0.5f,  //Vertex 2
		0.5f, -0.5f, //Vertex 3
		-0.5f, -0.5f //Vertex 4
	};

	glGenVertexArrays(1, &vao);
	glBindVertexArray(vao);
	glGenBuffers(1, &vbo); 
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
	readFile("vertexShader.glsl", vertShader, 512);
	readFile("fragShader.glsl", fragShader, 512);
	shaderProgram = makeGLShaders(vertShader, fragShader);
	if (!shaderProgram)
	{
		printf("shaders did not compile\n");
		return 1;
	}
	handleGLerror("post shader");
	glUseProgram(shaderProgram);
	//now we have to link the input "position" with the actual vertex position
	//for the vertex shader.
	posAttribute = glGetAttribLocation(shaderProgram, "position");
	glVertexAttribPointer(posAttribute, 2, GL_FLOAT, GL_FALSE, 0, 0);
	glEnableVertexAttribArray(posAttribute);
	return (handleGLerror("final"));
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
	SDL_Window* window;
	SDL_GLContext glContext;

	running = 1;
	if (SDL_Init(SDL_INIT_VIDEO) != 0)
	{
		printf("SDL_Init failed: %s\n", SDL_GetError());
		return -1;
	}
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
	window = SDL_CreateWindow("Particles", 0, 0, 1366, 768, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN);
	if (!window)
	{
		printf("SDL_CreateWindow failed: %s\n", SDL_GetError());
		SDL_Quit();
		return -1;
	}
	glContext = SDL_GL_CreateContext(window);
	if (!glContext)
	{
		printf("OpenGL context failed: %s\n", SDL_GetError());
		SDL_DestroyWindow(window);
		SDL_Quit();
		return -1;
	}
	glewExperimental = GL_TRUE;
	if (glewInit() != GLEW_OK)
	{
		printf("GLEW init failed: \n");
		SDL_GL_DeleteContext(glContext);
		SDL_DestroyWindow(window);
		SDL_Quit();
		return -1;
	}
	if (initGL() == 1)
	{
		printf("OpenGL init failed\n");
		SDL_GL_DeleteContext(glContext);
		SDL_DestroyWindow(window);
		SDL_Quit();
		return -1;
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