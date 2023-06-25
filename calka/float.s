.data
dwa: .float 2
siedem: .float 7
cztery: .float 4
buf:    .space 10

.text

.global sum
.type sum, @function
sum:                            # argumenty funkcji ktore sa float przekazywane sa przez rejestry %xmm
        # WYZNACZANIE K
        movss %xmm1, buf
        fld buf

        movss %xmm0, buf
        fld %xmm0
        pxor %xmm3, %xmm3
        fsubp                  # wczytuje b,a. robie b-a, pop, czyli wynik w ST()

        fld %xmm2              # ST(1) = b-a, ST(0) = n
        fdivp

        # WYZNACZANIE K/2
        fld    %ST(0)              # ST(1) = k, ST(0) = k
        fdivs   dwa             # ST(1) = k, ST(0) = k/2

        # WYZNACZANIE x0 -- pierwszy punkt "pomiaru"
        fldt   %xmm0            # ST(2) = k, ST(1) = k/2, ST(0) = a 
        fldl   %ST(1)            # ST(3) = k, ST(2) = k/2, ST(1) = a, ST(0) = k/2 
        faddp                   # ST(2) = k, ST(1) = k/2, ST(0) = a + k/2 = x0
        

        #  PETLA 
        cvtps2dq     %xmm2, %xmm2    # funkcja zamieniajca liczbe float na double word 
        movd         %xmm2, %ecx     # wczytanie do licznika petli
        # mov $iter, %ecx

zlicznanie_pol:
        # WYLICZANIE FUNKCJI h = f(x1), gdzie x1 = x0 + 1/2k, czyli obecny srodek prostokata
        flds    %ST(0)           # ST(3) = k, ST(2) = k/2, ST(1) = a + k/2 = x0, ST(0) = x0
        fmuls   %ST(1), %ST(0)    # ST(3) = k, ST(2) = k/2, ST(1) = a + k/2 = x0, ST(0) = x0^2
        fdivs   siedem          # ST(0) = 1/7*x^2
        fldz                    # ST(4) = k, ST(3) = k/2, ST(2) = a + k/2 = x0, ST(1) = 1/7*x^2, ST(0) = 0
        fadds %ST(2), %ST(0)      # ST(0) = x0
        fmuls cztery            # ST(0) = 4*x0
        faddp                   # ST(3) = k, ST(2) = k/2, ST(1) = a + k/2 = x0, ST(0) = f(x0)=h       

        # OBLICZANIE POLA
        fmuls   k               # ST(3) = k, ST(2) = k/2, ST(1) = a + k/2 = x0, ST(0) = h*k

        # AKTUALIZOWANIE SUMY suma += pole
        flds      %xmm3
        fadd
        movsd     %xmm0, %xmm4   
        fstp      %ST(0)           # pop ze stosu i zapisanie do rejestru
        movsd     %xmm0, %xmm3
        movsd     %xmm4, %xmm0

        # PRZESUWANIE "MIEJSCA POMIARU"
        fstp    %ST(0)           # ST(2) = k, ST(1) = k/2, ST(0) = a + k/2 = x0
        fadds   %ST(0), %ST(2)    # ST(2) = k, ST(1) = k/2, ST(0) = x0 + k

        loop    zlicznanie_pol  # petla sprawdza licznik w %ecx

        end_sum:
        
        movsd %xmm3, %xmm0
        ret

