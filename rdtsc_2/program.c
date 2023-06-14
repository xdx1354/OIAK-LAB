#include <stdio.h>
#include <unistd.h>

unsigned long long rdtsc_p(char bool, int iter);

int main(){
    unsigned long long result, t1, t2;

    t1 = rdtsc_p(0, 10);
    sleep(1);
    t2 = rdtsc_p(0, 10);

    result = t2 - t1;

    printf("%llu\n", t2);

}
// bool == 1    cpuid + rdtsc
// bool == 0    rdtscp
// iter == liczba iteracji