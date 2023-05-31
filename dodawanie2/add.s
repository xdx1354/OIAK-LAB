STDOUT = 1
STDIN = 0
SYSWRITE32 = 4
SYSREAD = 3
EXIT_SUCCESS = 0
SYSEXIT32 = 1
SYSCALL32 = 0x80

.data
    number:  .word 0x9222, 0x1234, 0x4444, 0x2222         
    len = .-number
    result:  .word 0, 0, 0, 0

.text
     

.global _start
_start:

    clc                             # czyszcze flagi
    movl $number, %esi
    movl $result, %ebx
    movl $0, %ecx

loop:
    popf                            # pobieram rejestr flag ze stosu
    movw (%esi, %ecx, 2), %ax       # wczytywanie 16-bit slowa do AX
    adcw (%esi, %ecx, 2), %ax       # dodaje do niego znow to samo slowo, wynik w %ax
    # movw %ax, (%ebx, %ecx, 2)       # zapisuje wynik w tym samym miejscu pamieci wzgledme result (na tej samej pozycji result)
    movw %ax, (%esi, %ecx, 2)
    pushf                           # pushuje rejest flag by flaga carry nie zostala nadpisana przy porowaniu warunku petli (cmpl)
    
    incl %ecx                       # zwieksznie licznika petli
    cmpl $4, %ecx                   # sprawdzam czy nie skonczyly sie slowa
    jne loop                        # jesli nie mamy jeszcze 2 iteracji to jump do loop


koniec:

  # konczenie programu z exit code 0
    mov $SYSEXIT32, %eax
    mov $EXIT_SUCCESS, %ebx
    int $SYSCALL32


/*
    operacje w gdb
    gdb nazwa       =       wlacza dany plik w gdb 
    b 39            =       dodaje break point w 39 linii
    run             =       odapla program
    i r             =       wyswietla rejestry
    x /2xw &number  =       examine /2baty jako hexadecimal word?   &number to adres w pamieci, tu poczatek liczby opisanej etykieta number
    c               =       continue    wznownienie po break point
    q               =       quit        wyjscie



*/



