.data

  wynik: .float 0,0,0,0
  siedem: .float 7,7,7,7
  jeden: .float 1,1,1,1
  zero: .float 0,0,0,0
  cztery: .float 4,4,4,4
  jeden_siedem: .float 0.1428,0.1428,0.1428,0.1428


.text
.global calka
.type calka, @function
# 1/7x^2 + 4x

calka:
push %rcx

  mov $0, %ecx # licznik petli
  movups tabSTARTX, %xmm0 # xmm0: x
  movups zero, %xmm4      # xmm4: wynik = 0
  movups jeden, %xmm5     # xmm2: 1
  movups tabDX, %xmm6     # xmm3: dx
  movups jeden_siedem, %xmm7    # xmm7: 7

  petla:
  
  movups %xmm0, %xmm1     # xmm1: x
  # mulps %xmm1, %xmm1      # xmm1: x*x
  # movups %xmm5, %xmm2     # xmm2: 1
  # divps %xmm7, %xmm2      # xmm2: 1/7
  mulps %xmm7, %xmm1      # xmm2: 1/7 * x*
  # movups %xmm0, %xmm3     # xmm3: x
  movups cztery, %xmm5    # xmm4: 4
  addps %xmm5, %xmm1      # xmm2: 1/7 * x +4
  movups %xmm0, %xmm5     # xmm1: x
  mulps %xmm5, %xmm1
  # mulps %xmm6, %xmm2	    # xmm2: xmm2*dx
  addps %xmm1, %xmm4      # xmm4: WYNIK += xmm2 dodaje do sumy wysokosci wszystkich poprzednich prostokatow

  movups cztery, %xmm9
  mulps %xmm6, %xmm9      # xmm5: 4*dx
  addps %xmm9, %xmm0

  /*
  addps %xmm6, %xmm0      # dodaję 4 * dx do x'a
  addps %xmm6, %xmm0
  addps %xmm6, %xmm0
  addps %xmm6, %xmm0
*/
  # przyspieszenie kosztem dokladnosci
  
  add $4, %ecx            # dodaję 4 do licznika pętli
  cmp %ecx, ilosc
  je return
  jmp petla

  return:
  mulps %xmm6, %xmm4      # xmm2:( Wynik )* dx, korzystajac z tego ze dx*a + dx*b = dx(a+b)
  movups %xmm4, wynik
  emms
  flds wynik
  fadds wynik+4
  fadds wynik+8
  fadds wynik+12  # zwracanie wartosci poprzez zachowanie jej w %st
  fstps wynik
  movl wynik, %eax
pop %rcx
ret
