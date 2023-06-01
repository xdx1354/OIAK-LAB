#include <stdio.h>
#include <unistd.h>

unsigned long long rdtsc_p(char val, int iter);

int main(){
    unsigned long long result, t1, t2;

    t1 = rdtsc_p(1, 10);
    sleep(1);
    t2 = rdtsc_p(1, 10);

    result = t2 - t1;

    printf("%llu\n", result);

}