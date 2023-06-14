#include <stdio.h>

extern float sum(float a, float b, float n);

int main(){
    float result = sum(1.0f, 3.0f, 10.0f);
    printf("Calka z tej funkcji wynosi: %.4f\n", result);
    return 0;
}