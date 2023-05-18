STDOUT = 1
STDIN = 0
SYSWRITE32 = 4
SYSREAD = 3
EXIT_SUCCESS = 0
SYSEXIT32 = 1
SYSCALL32 = 0x80

.data
   number:  .word 0x9222, 0x3300, 0x9200, 0x5000              
   number_len = .-number            # dlugosc w bajtach
   number_mem = number_len / 2;     # wyznaczam ilosc blokow 16-bit


.text
     

.global _start
_start:

clc                             # czyszcze flagi
mov $number_len, %esi                    # wpisuje liczbe licznik 0



dec %esi
movw number(,%esi, 4), %ax    # wpisuje pierwsze 4 bajty do eax
addw  %ax, number(,%esi, 4)        # dodaje pierwsze bajty bez przeniesienia
# push %eax                       # wrzucam wynik na stos
dec %esi

loop:
    

    movw number (, %esi, 2), %ax
    adcw  %ax, number(,%esi, 2)                   # dodaje dwa bajty o  n*4 adresie poczatku bloku (dodawanie z przeniesieniem)
    movw number(, %esi, 2), %ax

    dec %esi                                    # zwiekszam licznik 
    pushf
    cmp $number_mem, %esi               
    je koniec                                   # jesli licznik rowny liczbie
    popf

    jmp loop

/*
# WERSJA DRUGA
clc                             # czyszcze flagi
mov $number_len, %esi           # wpisuje liczbe blokow


loop3:
    dec %esi
    movw number(, %esi, 4), %eax
    adcw number(, %esi, 4), %eax

    push %eax                       # wrzucam wynik na stos
    pushf                           # wrzucam flagi na stos
    
    cmpq $0, %esi                   # sprawdzam czy jest jeszcze co dodawac


*/






koniec:

    mov $SYSWRITE32, %eax
    mov $STDOUT, %ebx
    mov $number, %ecx
    mov $number_len, %edx
    int $SYSCALL32

  # konczenie programu z exit code 0
    mov $SYSEXIT32, %eax
    mov $EXIT_SUCCESS, %ebx
    int $SYSCALL32






