STDOUT = 1
STDIN = 0
SYSWRITE32 = 4
SYSREAD = 3
EXIT_SUCCESS = 0
SYSEXIT32 = 1
SYSCALL32 = 0x80

.data
    input: .space 20

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

    # pobieranie inputu
    mov $SYSREAD, %eax
    mov $STDIN, %ebx
    mov $input, %ecx
    mov $40, %edx
    int $SYSCALL32

    mov %eax, %esi                  # w esi przechochowywana bedzie dlugosc inputu
    dec %esi                        # iterujemy od 0, dlugosc liczona jest od 1

    # petla zamieniajaca male litery na duze
    xor %edi, %edi                  # edi to licznik petli, tu go zerujemy
    

    loop:
         # sprawdzam czy litera jest mala
        cmpb $0x60, input(%edi)             # sprawdzam czy kod ASCII litery - kod ASCII 'a'-1 jest wiekszy od 0        ??cmpB
        jl toSmall                          # jesli jest to zanczy ze jest to mala liter i skacze do zamiany na duze    ?? jaki skok
        # wpp zamniana na male
        toBig:                              # zamiana z malych na duze
            subb $0x20, input(%edi)         # odejmuje 32 (0x20 w zapisie 16) od wartosci litery - zamieniam jej kod ASCII na duza 
            inc %edi                        # zwieksz licznik
            cmp %esi, %edi                  # sprawdzanie warunku %edi - %esi
            jl loop                         # jesli spelniony warunek to skok na poczatek
            jmp endOfLoop                   # jesli nie zostal spelniony warunek petli to wychodzimy 

        toSmall:                            # zamiana z duzych na male
            addb $0x20, input(%edi)         # dodaje 32 (kody ascii)
            inc %edi                        
            cmp %esi, %edi              
            jl loop                         # jesli sa litery dalej to wracam na poczatek
    endOfLoop:                              # koniec petli
    # zamiana miejscami w parach
    
    call print                          # funkcja wypisujaca obecny stan inputu

    xor %edi, %edi                      # zerowanie petli
    sub $1, %esi                        # zmniejszam licznik jeszcze o 1 w dol tak by nie wyjsc poza zakres
   
    loop2:                              # petla druga odpowiada za zamiane miejscami liter
    mov $1, %edx                        # wpisuje 1 do %edx, by potem korzystac z tego przy odwolywaniu sie do drugiej litery
    movb input(%edx, %edi), %ah         # kopiuje t[%edi + %edx] do %ah, czyli kopiowanie drugiej litery
    movb input(%edi), %bh               # kopiuje t[%edi] do %bh, czyli kopiowanie pierwszej litery
    movb %bh, input(%edx, %edi)         # wpisuje pierwsz w miejsce drugiej
    movb %ah, input(%edi)               # wpisuje druga w miejsce pierwszej
    add $2, %edi                        # dodaje 2 do licznika przed sprawdzeniem czy spelniony jest warunek petli                      i = i + 2
    cmp %esi, %edi                      #   
    jl loop2                            # jesli licznik %edi - %esi < 0, czyli l. petli - dl. wiadomosci < 0 to kolejna iteracja        i < len


    call print                          # funkcja drukowania

    # konczenie programu z exit code 0
    mov $SYSEXIT32, %eax
    mov $EXIT_SUCCESS, %ebx
    int $SYSCALL32

print:
    mov $SYSWRITE32, %eax
    mov $STDOUT, %ebx
    mov $input, %ecx
    mov $40, %edx
    int $SYSCALL32
    ret
