iter = 100
.data
# przypisanie wartosci etykietom, alokacja w pamieci miejsca na "zmienne"
a: .float 0.0               # poczatek przedzialu na ktorym liczymy calke
b: .float 0                 # koniec przedzialu
x: .float 0                 # obecny punkt "pomiaru"
n: .float 0                 # liczba "fragmentow" na ktore dzielimy przedzial [a,b]
h: .float 0                 # wysokosc prostokata
k: .float 0                 # szerokosc jednego prostokata
k_middle: .float 0          # polowa szerokosci prostokata
dwa: .float 2
siedem: .float 7
cztery: .float 4
pole: .float 0
suma: .float 0

.text

.global sum
.type sum, @function
sum:                            # argumenty funkcji ktore sa float przekazywane sa przez rejestry %xmm
        movss   %xmm0, a        # wczytanie parametrow
        movss   %xmm1, b
        movss   %xmm2, n

        # WYZNACZANIE K
        flds    b               # load na stos
        fsubs   a               # sub b-a, wynik na szczycie stosu
        fdivs   n               # div (b-a)/n, wynik na szczycie stosu
        fsts    k               # store stack, zapisanie wyniku (ze szczytu stosu) do k

        # WYZNACZANIE K/2
        fdivs   dwa             # na szczycie stosu jest nadal k = (b-a)/n. Dzielimy k/2 by wyznaczyc srodek boku prostokata
        fstps   k_middle        # wpisane wyniku do k_pol

        # WYZNACZANIE x0 -- pierwszy punkt "pomiaru"
        flds    a               # wrzucam pozycje startowa na stos  
        fadds   k_middle        # dodaje do niej k_middle by otrzymac srodek pierwszego prostokata
        fstps   x               # zapisuje to do x

        #  PETLA 
        cvtps2dq     %xmm2, %xmm2    # funkcja zamieniajca liczbe float na double word 
        movd         %xmm2, %ecx     # wczytanie do licznika petli
        # mov $iter, %ecx

zlicznanie_pol:
        # WYLICZANIE FUNKCJI h = f(x1), gdzie x1 = x0 + 1/2k, czyli obecny srodek prostokata
        flds    x               # wczytuje x i mnoze x^3
        fmuls   x
        fmuls   x
        fdivs   siedem          # dzielenie przez 7, obecny stam 1/7*x^3
        fsubs   cztery          # odejmowanie 4, obecny stam 1/7*x^3 - 4
        fsts    h               # zapisuje do h

        # OBLICZANIE POLA -- pole = h * k
        fmuls   k
        fstps   pole

        # AKTUALIZOWANIE SUMY suma += pole
        flds    suma
        fadds   pole              # pole jest juz na sczycie stosu
        fstps   suma              # zapisuje do suma

        # PRZESUWANIE "MIEJSCA POMIARU"
        flds    x
        fadds   k               # x1 = x0 + 1/2k + k        dalej srodek prostokata tylko, ze kolejnego
        fstps   x

        loop    zlicznanie_pol  # petla sprawdza warunek w iter

        end_sum:
        flds    suma
        movss   suma, %xmm0
        ret

