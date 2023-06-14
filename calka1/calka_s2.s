iter = 100
.data
a: .float 0.0
b: .float 0.0
x: .float 0
n: .float 0
h: .float 0
k: .float 0
k_pol: .float 0
dwa: .float 2
siedem: .float 7
cztery: .float 4
pole: .float 0
suma: .float 0

.text

.global sum
.type sum, @function
sum:
        movss   %xmm0, a
        movss   %xmm1, b
        movss   %xmm2, n

#obliczanie k
        flds    b
        fsubs   a
        fdivs   n
        fsts    k

#obliczanie k_pol
        fdivs   dwa
        fstps   k_pol

#x0 = a + 1/2k
        flds    a
        fadds   k_pol
        fstps   x

        mov     $iter, %ecx
adding_fields:
#obliczanie h = f(x+1/2k)
        flds    x
        fmuls   x
        fmuls   x
        fdivs   siedem
        fsubs   cztery
        fsts    h

#obliczanie pole = k *h
        fmuls   k
        fstps   pole

#obliczanie suma = suma + pole
        flds    suma
        fadds   pole
        fstps   suma

#zwiekszenie x o k
        flds    x
        fadds   k
        fstps   x

        loop    adding_fields

end_sum:
        flds    suma
        movss   suma, %xmm0
        ret
        