#include <stdio.h>
unsigned int       calka();
unsigned int rdtsc_p(char bol, int iter);

float a  = 2.0;
float b  = 5.0;
float DX;
float tabDX[4];
float tabSTARTX[4];
int   ilosc = 100000;

int main() {
  unsigned int start, end;
  float wynik = 0;
  float x     = a;

  //ilosc = (b-a)/DX;
  DX = (b-a)/ilosc;

  // calka 2--------------------------------------
  start = rdtsc_p(0,10);

  for (int i = 0; i < 4; i++) tabDX[i] = DX;

  for (int i = 0; i < 4; i++) tabSTARTX[i] = a + DX * i;

  unsigned int temp = calka();
  wynik = *(float*)&temp;
  end   = rdtsc_p(0,10);
  printf("%.6f, czas %d\n", wynik, end - start);
  //printf("wynik = %.4f\n",wynik);

  return 0;
}