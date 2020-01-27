CC = gcc
CFLAGS = -Wall -m32 -std=c99
CFLAGS64 = -Wall -m64 -std=c99

all: clean main.o uquantize.o
	$(CC) $(CFLAGS) -o prog main.o uquantize.o

all64: clean main_64.o uquantize_64.o
	$(CC) $(CFLAGS64) -o prog64 main_64.o uquantize_64.o

uquantize.o: uquantize.s
	nasm -f elf32 uquantize.s

uquantize_64.o: uquantize_64.asm
	nasm -felf64 uquantize_64.asm

main.o: main.c
	$(CC) $(CFLAGS) -fpack-struct=1 -c main.c

main_64.o: main.c
	$(CC) $(CFLAGS64) -fpack-struct=1 -c -o main_64.o main.c 	

clean:
	rm -f *.o
