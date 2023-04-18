#program drukuje 10 razy liczbe jako kod ascii

STDOUT = 1
SYSWRITE32 = 4
EXIT_SUCCESS = 0
SYSEXIT32 = 1

SYSCALL32 = 0x80

.section .data
number:
    .ascii "11234 \n"
len = .-number


.section .text
.global _start
_start:

xor %esi, %esi

loop:
    mov $SYSWRITE32, %eax
    mov $STDOUT, %ebx
    mov $number, %ecx
    mov $len, %edx
    int $SYSCALL32
    inc %esi
    cmp $10, %esi
    jl loop

mov $SYSEXIT32, %eax
mov $EXIT_SUCCESS, %ebx
int $SYSCALL32
