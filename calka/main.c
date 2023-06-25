#include <stdio.h>

extern float sum(float a, float b, float n);

int main(){
    float result = sum(1.0f, 2.0f, 200.0f);
    printf("Calka z tej funkcji wynosi: %.4f\n", result);
    return 0;
}