format: .asciz "%lu\n"

.global fibb

.text

fibb:
    push %ebp                       # zachowuje na stosie wskaznik na poprzednia ramke
    mov %esp, %ebp                  # 
    push %ebx                       # ** ebx to rejestr zachowywany po stronie wywolywanego, wiec musimy zadbac by nie zostal nadpisany

    cmpl $0, 8(%ebp)                # ebp wskazuje na adres poczatku stosu ktory rosnie w dol, 8bajtow wyzej nad poczatkiem stosu jest nasz argument
    jz zero                         # porownujemy czy jest rowny 0


    cmpl $1, 8(%ebp)                # sprawdzamy czy to jest 1
    je jeden

    movl 8(%ebp), %edx              # wpisujemy 32bit nasz obecny nr wyrazu w ciagu do policzenia do rejestru %edx
    dec %edx                        # dekrementacja bo rekurencyjnie policzymy poprzedni (n-1) wyraz
    push %edx                       # przez stos przekazujemy argument
    call fibb                       # rekurencyjne wywolanie funkcji
    pop %edx                        # odzyskujemy %edx by wiedziec jaki element nalezy liczyc nastepnie
    mov %eax, %ebx                  # ** przechowywujemy wartosc zwracana przez wwywolanie fibb w %ebx

    dec %edx                        # dekrementacja bo rekurencyjnie policzymy teraz n-2 wyraz
    push %edx                       # przez stos przekazujemy argument
    call fibb                       # rekurencyjne wywolanie funkcji
    pop %edx                        # odzyskujemy %edx by wiedziec jaki element nalezy liczyc nastepnie
    add %ebx, %eax                  # sumujemy wyrazy (n-1) + (n-2)
    jmp wyjscie

    jeden:
    mov $1, %eax
    jmp wyjscie


    zero:
    mov $0, %eax

    wyjscie:
    # wypisywanie obecnie zwracanej wartosci funkcji fibb przy uzyciu printf
    push %eax                       # drugi argument funkcji printf
    pushl $format                   # pierwszy argument funcji printf
    call printf                     # wywolanie funkcji
    add $4, %esp                    # mozemy zapomniec adres ciagu foramtujacego, przesuwamy wskaznik stack pointera ??
    pop %eax                        # przywracamy rejestr eax (zachowywany po stronie wywolujacego)

    pop %ebx                        # ** tutaj po wykonaniu calej funkcji przywracamy %ebx w nienaruszonym stanie
    pop %ebp
    ret
