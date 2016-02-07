#include "file.h"
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>

void readFile(const char fileName[], char* buffer, const unsigned int length)
{
	FILE *fileHandle;
	char fileNameBuffer[2048] = { 0 };
	char absolutePath[2048] = { 0 };
	char fileLineBuffer[2048] = { 0 };
	char fileContents[4096] = { 0 };

	getcwd(absolutePath, 2048);
	strcat(fileNameBuffer, absolutePath);
	strcat(fileNameBuffer, "/");
	strcat(fileNameBuffer, fileName);
	printf("opening %s\n", fileNameBuffer);
	fileHandle = fopen(fileNameBuffer, "r");
	if (fileHandle == NULL)
	{
		printf("failed open errno: %i\n", errno);
	}
	while(fgets(fileLineBuffer, length, fileHandle))
	{
		strcat(fileContents, fileLineBuffer);
	}
	fclose(fileHandle);
	strcpy(buffer, fileContents);
	printf("%s\n", buffer);
}