all: swap2

swap2: swap2.o
	ld swap2.o -o swap2 -m elf_i386

swap2.o: swap2.s
	as swap2.s -o swap2.o --32

clean: swap2 swap2.o
	rm swap2 swap2.o