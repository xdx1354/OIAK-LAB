.global _rdtsc_

.text

_rdtsc_:
    push %rbp
    mov %rsp, %rbp
    push %rbx

    cmp $0, %rdi                # jesli rdi != 0 skok do bezposredniego wykonania rdtscp
    jnz if

    xor %rax, %rax
    cpuid                       # serializing instruction, tworzy bariere sprawdzajaca czy wszystkie poprzednie funkcje sie juz wykonaly przed przjesciem dalej
    rdtscp                      # wczytanie TSC do %rax = mlodsze, %rdx = starsze  (Time Stamp Counter)
    jmp exit

    if:
        rdtsc                  # wczytanie TSC do %rdx:%rax 

    exit:
        shl $32, %rdx           # shift %rdx 32 bits to left
        or %rdx, %rax           # or na tych rejestrach laczy
        pop %rbx                    # przywracamy %rbx
        leave                       # przywraca %rbp
        ret                     # zwraca kontrole do miejsca wywolania, zdejmuje adres ze stosu


        # %rbp = Base Pointer, wskazuje na obecny stack frame
        # %rbx = Base Register, 
        
        /* 
        leave = 
        mov %rbp, %rsp
        pop %rbp
        */