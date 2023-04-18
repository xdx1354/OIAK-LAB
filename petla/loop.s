STDOUT = 1
SYSWRITE32 = 4
EXIT_SUCCESS = 0
SYSEXIT32 = 1

SYSCALL32 = 0x80

.section .data
number:
    .long 11234


.section .text
.global _start
_start:

mov $SYSWRITE32, %eax
mov $STDOUT, %ebx
mov $number, %ecx
mov $4, %edx
int $SYSCALL32

mov $SYSEXIT32, %eax
mov $EXIT_SUCCESS, %ebx
int $SYSCALL32
