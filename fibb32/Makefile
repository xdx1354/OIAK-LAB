all: fibb

fibb: fibb_c.c fibb.s
	gcc -m32 fibb.s fibb_c.c -o fibb

clean:
	rm fibb