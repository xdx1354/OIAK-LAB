.global rdtsc_p
.text

rdtsc_p:
    push %ebp
    mov %esp, %ebp              # przygotowanie ramki stosu
    push %ebx                   # odkladam na stos by zachowac
    push %ecx                   # tak samo jak wyzej

    # pierwszy argument w 8(%ebp)
    # drugi argument w 12(%ebp)

    mov 8(%ebp), %ebx           # w %ebx bedzie char
    mov 12(%ebp), %ecx          # w %ecx bedzie licznik petli

    loop:
    
    cmpb $1, %bl                # porownuje czy w mlodzszych 8bit %ebx jest 1
    je jeden
    # to sie wykona jesli jest zero
    rdtscp                      # wynik bedzie w %edx:%eax
    jmp warunek

    jeden:                      # to sie wykona jesli jest jeden
    xor %eax, %eax              # czy trzeba zachowac %eax na stosie?
    cpuid
    rdtsc                       # wynik bedzie w %edx:%eax


    warunek:
    dec %ecx                    # dekrementuje licznik
    cmpl %ecx, 0                # jesli rowny zero wyjscie z programu
    jne loop                    # jesli nie to skok do petli




    koniec:
    pop %ecx
    pop %ebx
    pop %ebp
    ret
