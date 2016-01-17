#include "SDL2/SDL.h"
#include "SDL2/SDL_opengl.h"
#include <stdio.h>
int running = 1;

int initGL()
{
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glClearColor(0.f, 0.f, 0.f, 1.f);
	if (glGetError() != GL_NO_ERROR)
	{
		return 0;
	}
	return 1;
}

void renderGL(SDL_Window* window)
{
	glClear(GL_COLOR_BUFFER_BIT);
	glBegin(GL_QUADS);
		glVertex2f(-0.5f, -0.5f);
		glVertex2f(0.5f, -0.5f);
		glVertex2f(0.5f, 0.5f);
		glVertex2f(-0.5f, 0.5f);
	glEnd();
	SDL_GL_SwapWindow(window);
}

void handleEvents()
{
	SDL_Event ev;
	while (SDL_PollEvent(&ev))
	{
		if (ev.type == SDL_Quit)
		{
			running = false;
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
	if (!initGL())
	{
		printf("OpenGL init failed\n");
		SDL_DestroyWindow(window);
		SDL_Quit();
	}
	while (running)
	{
		renderGL(window);
		handleEvents();
	}

	SDL_Quit();
	return 0;
}