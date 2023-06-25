iter = 100
.data
# przypisanie wartosci etykietom, alokacja w pamieci miejsca na "zmienne"
a: .float 0.0               # poczatek przedzialu na ktorym liczymy calke
b: .float 0                 # koniec przedzialu
x: .float 0                 # obecny punkt "pomiaru"
n: .float 0                 # liczba "fragmentow" na ktore dzielimy przedzial [a,b]
cztery_x: .float 0
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

	cmp $0, %xmm3
	jne licz_float 

sum:                            # argumenty funkcji ktore sa float przekazywane sa przez rejestry %xmm
        movsl   %xmm0, a        # wczytanie parametrow
        movsl   %xmm1, b
        movsl   %xmm2, n

        # WYZNACZANIE K
        fldl    b               # load na stos
        fsubl   a               # sub b-a, wynik na szczycie stosu
        fdivl   n               # div (b-a)/n, wynik na szczycie stosu
        fstl    k               # store stack, zapisanie wyniku (ze szczytu stosu) do k

        # WYZNACZANIE K/2
        fdivl   dwa             # na szczycie stosu jest nadal k = (b-a)/n. Dzielimy k/2 by wyznaczyc srodek boku prostokata
        fstpl   k_middle        # wpisane wyniku do k_pol

        # WYZNACZANIE x0 -- pierwszy punkt "pomiaru"
        fldl    a               # wrzucam pozycje startowa na stos  
        faddl   k_middle        # dodaje do niej k_middle by otrzymac srodek pierwszego prostokata
        fstpl   x               # zapisuje to do x

        #  PETLA 
        cvtps2dq     %xmm2, %xmm2    # funkcja zamieniajca liczbe float na double word 
        movd         %xmm2, %ecx     # wczytanie do licznika petli
        # mov $iter, %ecx

zlicznanie_pol:
        # WYLICZANIE FUNKCJI h = f(x1), gdzie x1 = x0 + 1/2k, czyli obecny srodek prostokata
        fldl    x               # wczytuje x i mnoze x^2
        fmull   x
        fdivl   siedem          # dzielenie przez 7, obecny stam 1/7*x^2
        fstpl    h
        
        fldl    x
        fmull   cztery
        fstl   cztery_x        # wyliczam 4x i zapisuje do pamieci
        
        faddl   cztery_x        # wczytuje h i dodaje do tego cztery_x
        fstl    h               # zapisuje do h

        # OBLICZANIE POLA -- pole = h * k
        fmull   k
        fstpl   pole

        # AKTUALIZOWANIE SUMY suma += pole
        fldl    suma
        faddl   pole              # pole jest juz na sczycie stosu
        fstpl   suma              # zapisuje do suma

        # PRZESUWANIE "MIEJSCA POMIARU"
        fldl    x
        faddl   k               # x1 = x0 + 1/2k + k        dalej srodek prostokata tylko, ze kolejnego
        fstpl   x

        loop    zlicznanie_pol  # petla sprawdza warunek w iter

        end_sum:
        fldl    suma
        movsl   suma, %xmm0
        ret


licz_float:
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
        flds    x               # wczytuje x i mnoze x^2
        fmuls   x
        fdivs   siedem          # dzielenie przez 7, obecny stam 1/7*x^2
        fstps   h
        
        flds    x
        fmuls   cztery
        fsts    cztery_x        # wyliczam 4x i zapisuje do pamieci
        
        fadds   cztery_x        # wczytuje h i dodaje do tego cztery_x
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



