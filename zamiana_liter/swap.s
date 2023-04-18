STDOUT = 1
STDIN = 0
SYSWRITE32 = 4
SYSREAD = 3
EXIT_SUCCESS = 0
SYSEXIT32 = 1
SYSCALL32 = 0x80

.data
    input: .space 20

.text

    msg: .ascii "Give input: "
    len = .-msg
.global _start
_start:
    mov $SYSWRITE32, %eax
    mov $STDOUT, %ebx
    mov $msg, %ecx
    mov $len, %edx
    int $SYSCALL32
    
    # pobieranie inputu
    mov $SYSREAD, %eax
    mov $STDIN, %ebx
    mov $input, %ecx
    mov $40, %edx
    int $SYSCALL32

    mov %eax, %esi                  # w esi przechochowywana bedzie dlugosc inputu
    dec %esi                        # iterujemy od 0, dlugosc liczona jest od 1

    # petla zamieniajaca male litery na duze
    xor %edi, %edi                  # edi to licznik petli
    

    loop:
        subb $0x20, input(%edi)
        inc %edi
        cmp %esi, %edi
        jl loop


    # zamiana miejscami w parach

    call print

    xor %edi, %edi  
    sub $1, %esi
   /*
    push input(%edi)
    mov $1, %edx                       
    movb input(%edx,%edi,1), %ah
    movb %ah, input(%edi)    
    pop input(%edx,%edi, 1)                   
    */

    loop2:
    mov $1, %edx
    movb input(%edx, %edi), %ah
    movb input(%edi), %bh
    movb %bh, input(%edx, %edi)
    movb %ah, input(%edi)
    add $2, %edi
    cmp %esi, %edi
    jl loop2


    call print

    mov $SYSEXIT32, %eax
    mov $EXIT_SUCCESS, %ebx
    int $SYSCALL32

print:
    mov $SYSWRITE32, %eax
    mov $STDOUT, %ebx
    mov $input, %ecx
    mov $40, %edx
    int $SYSCALL32
    ret
