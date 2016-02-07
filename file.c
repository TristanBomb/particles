#include "file.h"
#include <stdio.h>

char* readFile(const char* fileName, char* buffer, const unsigned int length)
{
	FILE *fileHandle;

	fileHandle = fopen(fileName, "r");
	fgets(buffer, length, fileHandle);
	fclose(fileHandle);
	return buffer;
}