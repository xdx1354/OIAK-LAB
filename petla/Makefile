all: loop

loop: loop.o
	ld loop.o -o loop -m elf_i386

loop.o: loop.s
	as loop.s -o loop.o --32

clean: loop loop.o
	rm loop loop.o