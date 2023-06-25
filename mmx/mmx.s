.data

  wynik: .float 0,0,0,0
  jeden: .float 1,1,1,1
  zero: .float 0,0,0,0

.text
.global calka
.type calka, @function


calka:
push %rcx

  mov $0, %ecx # licznik petli
  movups tabSTARTX, %xmm0 # xmm0: x
  movups zero, %xmm4      # xmm4: wynik = 0
  movups jeden, %xmm5     # xmm2: 1
  movups tabDX, %xmm6     # xmm3: dx

  petla:
  
  movups %xmm0, %xmm1     # xmm1: x
  mulps %xmm1, %xmm1      # xmm1: x*x
  movups %xmm5, %xmm2     # xmm2: 1
  subps %xmm1, %xmm2      # xmm2: 1- x*x
  movups %xmm0, %xmm3     # xmm3: x
  divps %xmm3, %xmm2      # xmm2:( 1- x*x )/x
  mulps %xmm6, %xmm2	  # xmm2: xmm2*dx
  addps %xmm2, %xmm4      # xmm4: WYNIK += xmm2

  addps %xmm6, %xmm0      # dodaję 4 * dx do x'a
  addps %xmm6, %xmm0
  addps %xmm6, %xmm0
  addps %xmm6, %xmm0

  add $4, %ecx            # dodaję 4 do licznika pętli
  cmp %ecx, ilosc
  je return
  jmp petla

  return:
  #mulps %xmm6, %xmm4      # xmm2:( Wynik )* dx, korzystajac z tego ze dx*a + dx*b = dx(a+b)
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
