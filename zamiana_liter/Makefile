all: swap

swap: swap.o
	ld swap.o -o swap -m elf_i386

swap.o: swap.s
	as swap.s -o swap.o --32

clean: swap swap.o
	rm swap swap.o