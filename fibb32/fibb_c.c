#include <stdio.h>

unsigned long fibb(unsigned int);       // prototyp funkcji

int main(){
    unsigned long input;
    unsigned long result;

    scanf("%lu", &input);                // ul = unsigned long, przekazujemy adres inputu tak by moc do niego cos zapisac
    result = fibb(input);                             // wywolanie funkcji
    printf("%lu\n", result);

    return 0;
}

/*
        gcc -m32 fibb_c.c fibb.s -o fibb
            -no-pie     moze byc potrzebny taki przelacznik 
*/
