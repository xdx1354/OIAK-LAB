#include <stdio.h>

extern float integral(float p1, float p2, int rec);
//unsigned int rdtsc_p(char bol, int iter);

int main(){
    float A = 2.0f;
    float B = 5.0f;
    int n = 1000.0f;
    float result = integral(A,B,n);

    ///int start = rdtsc_p(1,10);
    printf("Calka wynosi: %f\n", result);
    //int koniec = rdtsc_p(1,10);
    //printf("czas: %.4d\n", koniec-start);
    return 0;
}