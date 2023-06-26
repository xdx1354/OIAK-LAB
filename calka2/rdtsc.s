.global rdtsc_p

.text

rdtsc_p:
    push %rbp
    mov %rsp, %rbp
    # # pop %rbx

    # pierwszy argument w %rdi  bool
    # drugi argument w %rsi     liczba iteracji
    cmp $0, %rsi
    je exit2                     # sprawdzenie czy nie zostal podany parametr iter = 0

    loop:
    cmp $0, %rdi                # jesli rdi != 0 skok do bezposredniego wykonania rdtscp
    je if

    xor %rax, %rax              # w przeciwnym wypadku cpuid + rdtsc
    cpuid                       
    rdtsc                       # wynik %rax = mlodsze, %rdx = starsze  
    jmp warunek

    if:
    rdtscp                      # wynik %rdx:%rax 

    warunek:                    # sprawdzam warunek petli
    dec %rsi                    # zmniejszam licznik
    cmp $0, %rsi
    jne loop                    # jesli jeszcze nie jest rowne zero to kolejna iteracja  


    exit:                       # wyjscie z programu
    shl $32, %rdx               # shift %rdx 32 bits to left
    or %rdx, %rax               # or na tych rejestrach laczy
    # #pop %rbx                 # przywracamy %rbx
    leave                       # przywraca %rbp
    ret                         # zwraca kontrole do miejsca wywolania, zdejmuje adres ze stosu


    exit2:                      # uwzglednienie przypadku gdy zosta podany iter = 0 
    mov $0, %rax                # wynik zostanie wtedy ustawiony na 0
    leave                       
    ret 

        # %rbp = Base Pointer, wskazuje na obecny stack frame
        # %rbx = Base Register, 
        
        /* 
        leave = 
        mov %rbp, %rsp
        pop %rbp
        */