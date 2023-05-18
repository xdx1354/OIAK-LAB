all: add

add: add.o
	ld add.o -o add -m elf_i386

add.o: add.s
	as add.s -o add.o --32 -g

clean: add add.o
	rm add add.o