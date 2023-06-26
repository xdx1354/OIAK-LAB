.data
a: .float 0.0               # poczatek przedzialu na ktorym liczymy calke
b: .float 0.0               # koniec przedzialu
x: .float 0.0               # obecny punkt "pomiaru"
n: .float 0.0               # liczba "fragmentow" na ktore dzielimy przedzial [a,b]
h: .float 0.0               # wysokosc prostokata
k: .float 0.0               # szerokosc jednego prostokata
srodek: .float 0.0          # polowa szerokosci prostokata
dwa: .float 2.0
siedem: .float 7.0
cztery: .float 4.0
pole: .float 0.0
suma: .float 0.0


.text


.global sum
.type sum, @function
sum:                            # argumenty funkcji ktore sa float przekazywane sa przez rejestry %xmm


       movss   %xmm0, a        # wczytanie parametrow
       movss   %xmm1, b
       movss   %xmm2, n


       # WYZNACZANIE K
       flds    b               # b na stos
       fsubs   a               # b-a, wynik na szczycie stosu
       fdivs   n               # (b-a)/n, wynik na szczycie stosu
       fsts    k               # zapisanie wyniku ze szczytu stosu do k


       # WYZNACZANIE K/2
       fdivs   dwa             # na szczycie stosu jest nadal k = (b-a)/n. Dzielimy k/2 by wyznaczyc srodek boku prostokata
       fstps   srodek          # wpisane wyniku do srodek


       # WYZNACZANIE x0 -- pierwszy punkt "pomiaru"
       flds    a               # wrzucam pozycje startowa na stos 
       fadds   srodek          # dodaje do niej srodek by otrzymac srodek pierwszego prostokata
       fstps   x               # zapisuje to do x
       cvtps2dq     %xmm2, %xmm2    # funkcja zamieniajca liczbe float na double word
       movd         %xmm2, %ecx     # wczytanie do licznika petli


suma_pol:
       # h = f(x1), gdzie x1 = x0 + 1/2k, czyli obecny srodek prostokata
       flds    x               # wczytuje x
       fdivs   siedem          # dzielenie przez 7, obecny stam 1/7*x
       fadds   cztery          # dodawanie 4, obecny stam 1/7*x + 4
       fmuls   x               # mnozenie razy x, obecny stam 1/7*x^2 + 4x
       fsts    h               # zapisuje do h


       # pole = h * k
       fmuls   k
       fstps   pole


       # suma += pole
       flds    suma
       fadds   pole              # pole jest juz na sczycie stosu
       fstps   suma              # zapisuje do suma


       # przesuwanie miejsca pomiaru ''
       flds    x
       fadds   k               # x1 = x0 + 1/2k + k        dalej srodek prostokata tylko, ze kolejnego
       fstps   x


       loop    suma_pol


       end_sum:
       flds    suma
       movss   suma, %xmm0
       ret



