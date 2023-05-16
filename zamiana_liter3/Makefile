all: swap3

swap3: swap3.o
	ld swap3.o -o swap3 -m elf_i386

swap3.o: swap3.s
	as swap3.s -o swap3.o --32

clean: swap3 swap3.o
	rm swap3 swap3.o