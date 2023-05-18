all: printf

printf: printf.o
	ld printf.o -o printf -m elf_i386

printf.o: printf.s
	as printf.s -o printf.o --32

clean: printf printf.o
	rm printf printf.o