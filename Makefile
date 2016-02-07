CC=gcc
SOURCES=main.c file.c
FLAGS=-Wall -pedantic -g
LIBDIRS=-L/usr/lib/x86_64-linux-gnu
INCLUDEDIRS=-I/usr/include
LIBS=-lSDL2 -lSDL2main -lGL -lGLEW
OUTFILE=a.out

all:
	$(CC) $(SOURCES) $(FLAGS) $(LIBDIRS) $(INCLUDEDIRS) $(LIBS) -o $(OUTFILE) 