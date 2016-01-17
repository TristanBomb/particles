CC=gcc
SOURCES=main.c
FLAGS=-Wall -pedantic
LIBDIRS=-L/usr/lib/x86_64-linux-gnu
INCLUDEDIRS=-I/usr/include
LIBS=-lSDL2 -lSDL2main -lGL
OUTFILE=out.a

all:
	$(CC) $(SOURCES) $(FLAGS) $(LIBDIRS) $(INCLUDEDIRS) $(LIBS) -o $(OUTFILE) 