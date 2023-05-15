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
         # taki switch case sprawdzajacy w jakich przedzialach miesci sie kod ascii danego znaku
        cmpb $0x66, input(%edi)             # sprawdzam czy kod ASCII litery - kod ASCII 'a'-1 jest wiekszy od kodu 'f'
        jg toZero                           # Jesli tak to zamieniam na zero

        cmpb $0x60, input(%edi)             # sprawdzam czy jest wieksze/rowne kod ASCII 'a'
        jg toBig                            # jesli tak to zamieniam na duze

        cmpb $0x39, input(%edi)              # sprawdzam czy jest wieksze niz kod ASCII 9
        jg toZero                           # jesli tak to zamieniam na 0

        cmpb $0x30, input(%edi)              # sprawdzam czy jest mniejsze niz kod ASCII 0
        jl toZero                           # jesli tak to zamieniam na 0

        inc %edi
        cmp %esi, %edi  
        jl loop                            # default case = cyfra od 0 do 9 pozostaje bez zmiany
        jmp endOfLoop 

        toBig:                              # zamiana z malych na duze
            subb $0x20, input(%edi)         # odejmuje 32 (0x20 w zapisie 16) od wartosci litery - zamieniam jej kod ASCII na duza 
            inc %edi                        # zwieksz licznik
            cmp %esi, %edi                  # sprawdzanie warunku %edi - %esi
            jl loop                         # jesli spelniony warunek to skok na poczatek
            jmp endOfLoop                   # jesli nie zostal spelniony warunek petli to wychodzimy 

        toZero:                            # zamiana na zera
            movb $0x30, input(%edi)         # wpisuje kod ascii zera
            inc %edi                       
            cmp %esi, %edi              
            jl loop                         # jesli sa litery dalej to wracam na poczatek
            jmp endOfLoop                   # jesli nie zostal spelniony warunek petli to wychodzimy 

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


