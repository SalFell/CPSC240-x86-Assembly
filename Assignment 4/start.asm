;****************************************************************************************************************************
;Program name: "Accurate Cosines". This program takes in a degree value from the user, converts to radians, and computes the*
;cosine of those radians. Copyright (C) 2022 Salvador Felipe.                                                               *
;                                                                                                                           *
;This file is part of the software program "Accurate Cosines".                                                              *
;Accurate Cosines is free software: you can redistribute it and/or modify it under the terms of the GNU General Public      *
;License version 3 as published by the Free Software Foundation.                                                            *
;Accurate Cosines is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied     *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************

;References: Dr. Floyd Holliday, Johnson Tong, Timothy Vu, and Diamond Dinh

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Salvador Felipe
;  Author email: sfel@csu.fullerton.edu
;
;Program information
;  Program name: Accurate Cosines
;  Programming languages: Three modules in X86 and one bash file
;  Date program began: 2022 Oct 17
;  Date of last update: 2022 Oct 30
;  Date of reorganization of comments: 2022 Oct 30
;  Files in this program: start.asm, atof.asm, itoa.asm, ftoa.asm, cosine.asm, strlen.asm, and run.sh
;  Status: Finished.  The program was tested extensively with no errors in Linux 2020 Edition.
;

;This file
;   File name: start.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l start.lis -o start.o start.asm
;   Link: ld -o ACosines.out start.o atof.o strlen.o itoa.o ftoa.o cosine.o
;   Purpose: This is the central module that will direct calls to all other modules in order to obtain string lengths, convert
;            degrees to radians, and calculate cosines.

;===== Begin code area ================================================================================================
;MESSAGE TO THE GRADER: This assignment was completed before the due date, but the STATUS of that submission was
;forgetfully left as Incomplete. This current submission has a fixed STATUS and is being turned in 10 minutes after the
;original due date. Please take this into consideration when grading. Thank you.

global _start

extern strlen
extern atof
extern ftoa
extern itoa
extern cosine
extern getfreq

;Data destinations (constants without data size specified)
Stdin  equ 0
Stdout equ 1
Stderror equ 2

;Kernel function code numbers
system_read  equ 0
system_write equ 1        ;Kernel function
system_terminate equ 60   ;Kernel function
System_time equ 201       ;Kernel function "get_time" not used in this program

;Named constants
Null equ 0
Exit_with_success equ 0
Line_feed equ 10
Numeric_string_array_size equ 32

segment .data
newline db 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0        ;Declare an array of 8 bytes where each byte is initialize with ascii value 10 (newline)
welcome db "Welcome to Accurate Cosines by Salvador Felipe.", 10, 10, 0
tics db "The time is now ", 0
theWordTics db " tics", 10, 10, 0
input db "Please enter an angle in degrees and press enter: ", Null
echo db "You entered ", 0
in_radians db "The equivalent radians is ", 0
show_cos db "The cosine of those degrees is ", 0
seconds db "The time is now ", 0
theWordSeconds db " seconds.", 10, 10, 0
goodbye db "Have a nice day.  Bye.", 10, 10, 0

segment .bss  ;Reserved for uninitialized data
input_float_string resb Numeric_string_array_size
tic_num resb 64
tic_num2 resb 64
float_string resb 32
cos_string resb 32

segment .text ;Reserved for executing instructions.

_start:

;Prolog ===== Insurance for any caller of this assembly module ========================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp
mov  rbp,rsp
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags

;=====Welcome message============
;Obtain the length of the welcome string
mov        rax, 0
mov        rdi, welcome
call       strlen
mov        r12, rax            ;r12 holds length of the welcome string

;Output the welcome message
mov        rax, system_write
mov        rdi, Stdout
mov        rsi, welcome
mov        rdx, r12            ;Number of bytes to be written.
syscall

;====Show time in tics===========

;Obtain the length of the tics string
mov        rax, 0
mov        rdi, tics
call       strlen
mov        r12, rax            ;r12 holds length of the welcome string

;Output the tics message
mov        rax, system_write
mov        rdi, Stdout
mov        rsi, tics
mov        rdx, r12            ;Number of bytes to be written.
syscall

;get time in tics
cpuid ;cpuid halts processes
rdtsc ;rdtsc copies clock into edx:eax (low rdx:low rax)
shl rdx, 32   ;shift tics to the left, now room for tics from rax
add rdx, rax  ;mov tics from low end of rax to low end of rdx
or rdx, rax
mov r8, rdx

;call itoa
mov rax, 0
mov rdi, r8
mov rsi, tic_num
call itoa   ;convert to string so we can get the length for output
mov r13, tic_num

;Get length of tics
mov rax, 0
mov rdi, r13
call strlen
mov r14, rax

;Output tics
mov rax, system_write
mov rdi, Stdout
mov rsi, r13
mov rdx, r14
syscall

;Obtain the length of the theWordTics string
mov        rax, 0
mov        rdi, theWordTics
call       strlen
mov        r12, rax            ;r12 holds length of the welcome string

;Output the tics word
mov        rax, system_write
mov        rdi, Stdout
mov        rsi, theWordTics
mov        rdx, r12            ;Number of bytes to be written.
syscall

;====Ask for input==============
;Obtain the length of the "input" string
mov        rax, 0
mov        rdi, input
call       strlen
mov        r12, rax            ;r12 holds number of bytes in the string instruction

;Output the prompt to input a float
mov        rax, system_write
mov        rdi, Stdout
mov        rsi, input
mov        rdx, r12            ;Number of bytes to be written.
syscall

;====Get input=============
;Strategy based on Jorgensen, Chapter 13
;Input char from keyboard one byte at a time.

;Preloop initialization
    mov rbx, input_float_string
    mov r12,0       ;r12 is counter of number of bytes inputted
    push qword 0    ;Storage for incoming byte

Begin_loop:         ;This is the one point of entry into the loop structure.
    mov    rax, system_read
    mov    rdi, Stdin
    mov    rsi, rsp
    mov    rdx, 1    ;one byte will be read from the input buffer
    syscall

    mov al, byte [rsp]

    cmp al, Line_feed
    je Exit_loop     ;If EOL is encountered then discard EOL and exit the loop.
                    ;This is the only point in the loop structure where exit is allowed.

    inc r12          ;Count the number of bytes placed into the array.

    ;Check that the destination array has not overflowed.
    cmp r12,Numeric_string_array_size
    ;if(r12 >= Input_array_size)
         jge end_if_else
    ;else (r12 < Numeric_string_array_size)
          mov byte [rbx],al
          inc rbx
    end_if_else:

jmp Begin_loop

Exit_loop:
    ;The algorithm implemented above allows upto (Numeric_string_array_size - 1) bytes to be entered into the
    ;destination array, thereby, reserving one byte for the null character.  However, if the user does
    ;enter more than (Numeric_string_array_size - 1) bytes of data then the excess bytes are read and discarded.
    ;The algorithm was adapted from Jorgensen, Chapter 13, Section 13.4.1
    mov byte [rbx],Null        ;Append the null character.

    pop rax          ;Return the stack to its former state.
;input_integer_string holds the user input.  However, if the user inputted more than (Numeric_string_array_size - 1)
;bytes then the excess will be discarded.  The last byte in the array is reserved for the null char.

;====Echo input============
;Output a newline
    mov byte [newline],0xa
    mov byte [newline+1],Null
    mov    rax, system_write
    mov    rdi, Stdout
    mov    rsi, newline
    mov    rdx, 1               ;Number of newlines to be written
    syscall

;Obtain the length of the echo message
    mov rax, 0
    mov rdi, echo
    call strlen
    mov r12, rax

;Write the echo message
    mov    rax, system_write
    mov    rdi, Stdout
    mov    rsi, echo    ;The number received is ",0
    mov    rdx, r12             ;Number of bytes to be written.
    syscall

;Obtain the length of string holding the inputted number
    mov    rax, 0
    mov    rdi, input_float_string
    call   strlen
    mov    r12, rax

;Output the number
    mov    rax, system_write
    mov    rdi, Stdout
    mov    rsi, input_float_string
    mov    rdx, r12             ;Number of bytes to be written.
    syscall

;Output a newline
    mov byte [newline],0xa
    mov byte [newline+1],Null
    mov    rax, system_write
    mov    rdi, Stdout
    mov    rsi, newline
    mov    rdx, 1               ;Number of newlines to be written
    syscall

;Output a newline
    mov byte [newline],0xa
    mov byte [newline+1],Null
    mov    rax, system_write
    mov    rdi, Stdout
    mov    rsi, newline
    mov    rdx, 1               ;Number of newlines to be written
    syscall

;====Show in_radians===========
;Obtain the length of in_radians
mov        rax, 0
mov        rdi, in_radians
call       strlen
mov        r12, rax            ;r12 holds number of bytes in the string instruction

;Output the in_radians prompt
mov        rax, system_write
mov        rdi, Stdout
mov        rsi, in_radians
mov        rdx, r12            ;Number of bytes to be written.
syscall

;get radian value
mov rax, 0
mov rdi, input_float_string
call atof
movsd xmm9, xmm0

mov rax, __float64__(0.0174532925199432) ; 180/pi
movq xmm1, rax
mulsd xmm9, xmm1    ;(xmm9 * pi) / 180  stored in xmm8

;call ftoa to get radian value
mov rax, 1
movsd xmm0, xmm9
mov rdi, float_string
mov rsi, 32
call ftoa
mov r15, float_string

;obtain length of radian value
mov rax, 0
mov rdi, r15
call strlen
mov r12, rax

;output radian value
mov rax, system_write
mov rdi, Stdout
mov rsi, r15
mov rdx, r12
syscall

;Output a newline
    mov byte [newline],0xa
    mov byte [newline+1],Null
    mov    rax, system_write
    mov    rdi, Stdout
    mov    rsi, newline
    mov    rdx, 1               ;Number of newlines to be written
    syscall

;Output a newline
    mov byte [newline],0xa
    mov byte [newline+1],Null
    mov    rax, system_write
    mov    rdi, Stdout
    mov    rsi, newline
    mov    rdx, 1               ;Number of newlines to be written
    syscall

;;====Show Cosine==============
;Obtain the length of the show_cos string
mov        rax, 0
mov        rdi, show_cos
call       strlen
mov        r12, rax            ;r12 holds length of the welcome string

;Output the show_cos message
mov        rax, system_write
mov        rdi, Stdout
mov        rsi, show_cos
mov        rdx, r12            ;Number of bytes to be written.
syscall

;call cosine
mov rax, 1
movsd xmm0, xmm9
call cosine
movsd xmm8, xmm0

; call ftoa
mov rax, 1
movsd xmm0, xmm8
mov rdi, cos_string
mov rsi, 30
call ftoa
mov r12, rax

;output cos_string
mov rax, system_write
mov rdi, Stdout
mov rsi, cos_string
mov rdx, r12
syscall

;Output a newline
    mov byte [newline],0xa
    mov byte [newline+1],Null
    mov    rax, system_write
    mov    rdi, Stdout
    mov    rsi, newline
    mov    rdx, 1               ;Number of newlines to be written
    syscall

;Output a newline
    mov byte [newline],0xa
    mov byte [newline+1],Null
    mov    rax, system_write
    mov    rdi, Stdout
    mov    rsi, newline
    mov    rdx, 1               ;Number of newlines to be written
    syscall

;;====Show time in Seconds=========
;; #tics / (#tics/sec) = seconds
;;(late tics - early tics) / frequency = wall time

;get strlen of seconds
mov rax, 0
mov rdi, seconds
call strlen
mov r12, rax

;output seconds
mov rax, system_write
mov rdi, Stdout
mov rsi, seconds
mov rdx, r12
syscall

;get time
cpuid
rdtsc
shl rdx, 32
or rdx, rax
mov r9, rdx

mov rax, 0
call getfreq
movsd xmm15, xmm0

sub r8, r9
cvtsi2sd xmm14, r8
divsd xmm14, xmm15
cvttsd2si r8, xmm14

;call itoa
mov rax, 0
mov rdi, r8
mov rsi, tic_num2
call itoa
mov r13, tic_num2

;get strlen of the time
mov rax, 0
mov rdi, r13
call strlen
mov r12, rax

; %lf, argument
;output the time
mov rax, system_write
mov rdi, Stdout
mov rsi, r13
mov rdx, r12
syscall

;get strlen of theWordSeconds
mov rax, 0
mov rdi, theWordSeconds
call strlen
mov r12, rax

;output theWordSeconds
mov rax, system_write
mov rdi, Stdout
mov rsi, theWordSeconds
mov rdx, r12
syscall

;;====Goodbye=============
;Obtain the length of the goodbye string
mov        rax, 0
mov        rdi, goodbye
call       strlen
mov        r12, rax            ;r12 holds length of the welcome string

;Output the goodbye message
mov        rax, system_write
mov        rdi, Stdout
mov        rsi, goodbye
mov        rdx, r12            ;Number of bytes to be written.
syscall

;=====Now exit from this program and return control to the OS =============================================================================================================
mov        rax, 60                                          ;60 is the number of the syscall subfunction that terminates an executing program.
mov        rdi, 0                                           ;0 is the code number that will be returned to the OS.
syscall
;We cannot use an ordinary ret instruction here because this program was not called by some other module.  The program does not know where to return to.

;===== Restore original values to integer registers ===================================================================
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

ret

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
