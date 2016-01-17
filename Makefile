CC=gcc
SOURCES=main.c
FLAGS=-Wall -pedantic
LIBDIRS=-L/usr/lib/x86_64-linux-gnu
INCLUDEDIRS=-I/usr/include
LIBS=-lSDL2 -lSDL2main -lG
OUTFILE=a.out

all:
	$(CC) $(SOURCES) $(FLAGS) $(LIBDIRS) $(INCLUDEDIRS) $(LIBS) -o $(OUTFILE) 