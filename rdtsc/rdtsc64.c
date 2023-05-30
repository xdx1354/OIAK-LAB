#include <stdio.h>
#include <unistd.h>

unsigned long long _rdtsc_(int val);

int main(){
    unsigned long long result, t1, t2;

    t1 = _rdtsc_(0);
    sleep(1);
    t2 = _rdtsc_(0);

    result = t2 - t1;

    printf("%llu\n", result);

}