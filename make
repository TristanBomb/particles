CC=gcc
SOURCES=main.c
FLAGS=-Wall -pedantic
LIBS=-lSDL
OUTFILE=out.a

all:
	$(CC) $(SOURCES) $(FLAGS) $(LIBS) -o $(OUTFILE) 