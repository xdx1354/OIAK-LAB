#include <stdio.h>

extern float sum(float a, float b, float n);
unsigned int rdtsc_p(char bol, int iter);

int main(){
    int start = rdtsc_p(1, 10); 
    float result = sum(2.0f, 5.0f, 100000.0f);
    int koniec = rdtsc_p(1, 10);
    printf("Calka z tej funkcji wynosi: %.4f\n", result);
    printf("czas: %.4d\n", koniec-start);
    return 0;
}