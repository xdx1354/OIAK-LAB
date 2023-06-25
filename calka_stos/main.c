#include <stdio.h>

extern float integral(float p1, float p2, int rec);

int main(){
    float A = 3.0f;
    float B = 4.0f;
    int n = 1000.0f;
    float result = integral(A,B,n);
    printf("Calka wynosi: %f\n", result);
    return 0;
}