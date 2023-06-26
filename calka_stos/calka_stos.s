.data
wsp1_0: .float 1.0
wsp1_1: .float 7.0
wsp2: .float 4.0
pol: .float 2.0
.text
.global integral

integral:
	push %rbp	
	mov %rsp, %rbp

	sub $16, %rsp  # rezerwujemy miejsce na zmienne

	fild 24(%rbp)  # n
	fld 16(%rbp)   # A
	fld 20(%rbp)   # B

	fsubp
	fdivp		# k = (B-A)/n
	fstp -16(%rbp)  # zapisujemy k
	fldz            # 0 na stos - wynik
	mov $0, %rax    # rax as an iterator
petla:
	fld 16(%rbp)    # A
	fld -16(%rbp)   # A k
	push %rax
	fild (%rsp)	# A k i
	pop %rax
	fmulp		# A i*k
	faddp		# A+i*k
	fld -16(%rbp)   # A+i*k k
	fld pol 	# A+i*k k 0.5
	fdiv %st(1),%st # A+i*k 0.5k
	fstpl -24(%rbp)
	faddp	        # x = A + k/2 + i * k
	fld %st(0)	# x x
	fld wsp1_1	# x x 7 
	fld wsp1_0	# x x 7 1
	fdivp		# x x 1/7
	fmulp		# x 1/7x
	fld wsp2	# x 1/7x 4
	faddp		# x 1/7x+4
	fmulp		# 1/7x^2 + 4
	faddp		# dodaj do wyniku
	inc %rax	# inkrementacja licznika
	cmp %rax, 24(%rbp)	# warunek petli sprawdzany
	jne petla
	
	fld -16(%rbp)		
	fmulp
	fstp -16(%rbp)
	
	movss -16(%rbp), %xmm0	# zapis wyniku do xmm0
	mov %rbp, %rsp
	pop %rbp
ret