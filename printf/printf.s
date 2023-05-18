STDOUT = 1
STDIN = 0
SYSWRITE32 = 4
SYSREAD = 3
EXIT_SUCCESS = 0
SYSEXIT32 = 1
SYSCALL32 = 0x80

# DOES NOT WORK

.section .data
text_string:
    .ascii "THE NUMBER IS %d\0"

.section .text
.globl _start
_start:

pushl $88
pushl $text_string
call printf
popl %eax
popl %eax


# konczenie programu z exit code 0
    mov $SYSEXIT32, %eax
    mov $EXIT_SUCCESS, %ebx
    int $SYSCALL32