all: rdtsc_

rdtsc_: rdtsc64.c rdtsc_.s
	gcc -no-pie rdtsc_.s rdtsc64.c -o rdtsc_

clean:
	rm rdtsc_