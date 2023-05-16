# swaping a-z to A-Z, and all other into space. Then reversing the order
# for example: Hel1#!LLO -> HEL   LLO -> OLL LEH
STDOUT = 1
STDIN = 0
SYSWRITE32 = 4
SYSREAD = 3
EXIT_SUCCESS = 0
SYSEXIT32 = 1
SYSCALL32 = 0x80

.data
    input: .space 20
    
    newline: .ascii "\n"
    newline_len = .-newline

.text
    msg: .ascii "Give input: "
    len = .-msg

.global _start
_start:
    # wypisywanie msg
    mov $SYSWRITE32, %eax
    mov $STDOUT, %ebx
    mov $msg, %ecx
    mov $len, %edx
    int $SYSCALL32

    # pobieranie inputu
    mov $SYSREAD, %eax
    mov $STDIN, %ebx
    mov $input, %ecx
    mov $20, %edx
    int $SYSCALL32

    mov %eax, %esi                  # w esi przechochowywana bedzie dlugosc inputu
    dec %esi                        # iterujemy od 0, dlugosc liczona jest od 1

    # petla zamieniajaca male litery na duze
    xor %edi, %edi                  # edi to licznik petli, tu go zerujemy
    

    loop:
         # taki switch case sprawdzajacy w jakich przedzialach miesci sie kod ascii danego znaku
        cmpb $0x7A, input(%edi)             # sprawdzam czy to jest znak po literze z w tablicy ascii
        jg toSpace                           # Jesli tak to zamieniam na spacje

        cmpb $0x60, input(%edi)             # sprawdzam czy jest wieksze/rowne kod ASCII 'a'
        jg toBig                            # jesli tak to zamieniam na duze

        cmpb $0x5A, input(%edi)              # sprawdzam czy jest wieksze niz kod ASCII Z
        jg toSpace                           # jesli tak to zamieniam na spacje

        cmpb $0x41, input(%edi)              # sprawdzam czy jest mniejsze niz kod ASCII A
        jl toSpace                           # jesli tak to zamieniam na spacje

        inc %edi
        cmp %esi, %edi  
        jl loop                            # default case = litery od A do Z pozostaja bez zmiany
        jmp endOfLoop 

        toBig:                              # zamiana z malych na duze
            subb $0x20, input(%edi)         # odejmuje 32 (0x20 w zapisie 16) od wartosci litery - zamieniam jej kod ASCII na duza 
            inc %edi                        # zwieksz licznik
            cmp %esi, %edi                  # sprawdzanie warunku %edi - %esi
            jl loop                         # jesli spelniony warunek to skok na poczatek
            jmp endOfLoop                   # jesli nie zostal spelniony warunek petli to wychodzimy 

        toSpace:                            # zamiana na spacje
            movb $0x20, input(%edi)         # wpisuje kod ascii spacji
            inc %edi                       
            cmp %esi, %edi              
            jl loop                         # jesli sa litery dalej to wracam na poczatek
            jmp endOfLoop                   # jesli nie zostal spelniony warunek petli to wychodzimy 

    endOfLoop:                              # koniec petli


    # zamiana kolejnosci
    call newLine
    call print                          # funkcja wypisujaca obecny stan inputu
    call newLine

    xor %edi, %edi                      # zerowanie petli
    # %esi to dlugosc slowa 0 - len-1
   
    loop2:                              # petla druga odpowiada za zamiane miejscami liter
                                        # w kazdej iteracji %edi przesuwa sie o litere do przodu, a %esi o litere do tylu (startujac od konca)
    movb input(%edi), %ah               # przepisuje n-ta litere idac od poczatku 
    movb input(%esi), %bh               # przepisuje n-ta litere idac od konca
    movb %bh, input(%edi)               # wpisuje pierwsza w miejsce drugiej
    movb %ah, input(%esi)               # wpisuje druga w miejsce pierwszej
    add $1, %edi                        # aktualizuje obydwa liczniki
    sub $1, %esi
    cmp %esi, %edi                      #   
    jl loop2                            # jesli sie jeszcze nie spotakly to kolejna iteracja



    # call newLine
    call print                          # funkcja drukowania
    call newLine

    # konczenie programu z exit code 0
    mov $SYSEXIT32, %eax
    mov $EXIT_SUCCESS, %ebx
    int $SYSCALL32

print:
    mov $SYSWRITE32, %eax
    mov $STDOUT, %ebx
    mov $input, %ecx
    mov $20, %edx
    int $SYSCALL32
    ret

newLine:
    mov $SYSWRITE32, %eax
    mov $STDOUT, %ebx
    mov $newline, %ecx
    mov $newline_len, %edx
    int $SYSCALL32
    ret


