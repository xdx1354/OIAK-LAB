.global silnia_32       # NIE DZIALA

.text

silnia_32:
    push %ebp
    mov %esp, %ebp
    push %ebx

    cmpl $0, 8(%ebp)            # sprawdzam czy jest teraz 1
    je base_case
    cmpl $1, 8(%ebp)            # sprawdzam czy jest 1
    je base_case

    # w przeciwnym przypadku wykonuje dalej rekurencje
    mov 8(%ebp), %edx      # przenosze zawartosc wrzucona na stos z %edx w poprzednim wywolaniu do rejstru
    dec %edx                # zmiejszam o 1
    push %edx               # wrzucam na stos
    call silnia_32          # rekurencyjnie wywoluje       
    pop %edx
    imul %edx, %eax
    # mov %eax, %ebx

    jmp exit


    base_case:
        mov $1, %eax            # zwraca wartosc 1 
        jmp exit

    exit:
        pop %ebx
        pop %ebp
        ret

