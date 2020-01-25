CC = gcc
CFLAGS = -Wall -m32 -std=c99

all: main.o uquantize.o
	$(CC) $(CFLAGS) -o prog main.o uquantize.o

uquantize.o: uquantize.s
	nasm -f elf32 -o uquantize.o uquantize.s

main.o: main.c
	$(CC) $(CFLAGS) -fpack-struct=1 -c -o main.o main.c

clean:
	rm -f *.o
