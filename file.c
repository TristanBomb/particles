#include "file.h"
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

void readFile(const char* fileName, char* buffer[], const unsigned int length)
{
	FILE *fileHandle;
	char fileNameBuffer[2048] = { 0 };
	char absolutePath[2048] = { 0 };

	getcwd(absolutePath, 2048);
	strcat(fileNameBuffer, absolutePath);
	strcat(fileNameBuffer, "/");
	strcat(fileNameBuffer, fileName);
	printf("opening %s\n", fileNameBuffer);
	fileHandle = fopen(fileName, "r");
	fgets(*buffer, length, fileHandle);
	fclose(fileHandle);
}