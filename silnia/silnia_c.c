#include <stdio.h>
/*NIE DZIALA*/
extern unsigned int silnia_32(unsigned int n);

int main(){
    unsigned int startingVal = 5;
    unsigned int res = silnia_32(startingVal);
    printf("%u",res);
    return 0;
}
