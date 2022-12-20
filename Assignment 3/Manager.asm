;****************************************************************************************************************************
;Program name: "Arrays". This program computes the sum of a user inputted array. Validation is done to ensure proper inputs *
;of integers. Copyright (C) 2022 Salvador Felipe.                                                                           *
;                                                                                                                           *
;This file is part of the software program "Arrays".                                                               *
;Arrays is free software: you can redistribute it and/or modify it under the terms of the GNU General Public       *
;License version 3 as published by the Free Software Foundation.                                                            *
;Arrays is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied      *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************

;References: Dr. Floyd Holliday and Johnson Tong

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Salvador Felipe
;  Author email: sfel@csu.fullerton.edu
;
;Program information
;  Program name: Arrays
;  Programming languages: Three modules in X86, one modules in C, one module in C++, and one bash file
;  Date program began: 2022 Sep 19
;  Date of last update: 2022 Oct 9
;  Date of reorganization of comments: 2022 Oct 9
;  Files in this program: Main.c, Manager.asm, Input_array.asm, Sum.asm, Display_Array.asm, and run.sh
;  Status: Finished.  The program was tested extensively with no errors in Linux 2020 Edition.
;

;This file
;   File name: Manager.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l Manager.lis -o Manager.o Manager.asm
;   Link: g++ -m64 -no-pie -o Arrays.out Input_array.o Sum.o Manager.o Display_Array.o Main.o -std=c++17
;   Purpose: This is the central module that will direct calls to the modules Sum.asm, Input_array.asm, and Display_Array.cpp.
;            Using Input_array.asm and Sum.asm, the sum of a user-filled array will be computed and outputted in
;            Display_Array.cpp.

;===== Begin code area ================================================================================================
extern printf
extern scanf
extern fgets
extern strlen
extern stdin
extern Input_array
extern Display_Array
extern Sum

INPUT_LEN equ 256 ; Max bytes of name, title, response
LARGE_BOUNDARY equ 100

global Manager

segment .data
name_format db "%s", 0
ask_name db "Please enter your name: ", 10, 0
present_numbers db "These numbers were received and placed into the array:",10,0
the_sum_is db "The sum of these values is %.0lf.", 10 ,0
exit_message db "The control module will now return the sum to the caller module.",10,0

segment .bss  ;Reserved for uninitialized data
the_array resq LARGE_BOUNDARY ; array of 6 quad words reserved before run time.
name: resb INPUT_LEN

segment .text ;Reserved for executing instructions.

Manager:

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

push qword 0  ; remain on the boundary

;"Please enter you name: "===========
push qword 0
mov rax, 0
mov rdi, name_format
mov rsi, ask_name
call printf
pop rax

push qword 0
mov rax, 0
mov rdi, name
mov rsi, INPUT_LEN ; read 256 bytes
mov rdx, [stdin]
call fgets
pop rax

; Remove newline char from fgets input=================
mov rax, 0 ; Indicate 0 floating point arguments
mov rdi, name ; Move name into the first argument register
call strlen ; Call external function strlen, which returns the length of the string leading up to '\0'

sub rax, 1 ; The length is stored in rax. Here we subtract 1 from rax to obtain the location of '\n'
mov byte [name + rax], 0 ; Replace the byte where '\n' exits with '\0'
mov rax, name


; Fill the array using the Input_array module==============
push qword 0
mov rax, 0
mov rdi, the_array ; array passed in as first param
mov rsi, LARGE_BOUNDARY         ; array size passed in as second param
call Input_array
mov r15, rax
pop rax

;"The numbers you entered are these: "==============
push qword 0
mov rax, 0
mov rdi, present_numbers
call printf
pop rax
; Display the numbers in the_array using the Display module
push qword 0
mov rax, 0
mov rdi, the_array
mov rsi, r15
call Display_Array
pop rax
; Computing the sum...
push qword 0
mov rax, 0
mov rdi, the_array
mov rsi, LARGE_BOUNDARY
call Sum ;The sum will be in xmm0
movsd xmm15, xmm0
pop rax

; The sum of these values is ....================
push qword 0
mov rax, 1
mov rdi, the_sum_is
movsd xmm0, xmm15
call printf
pop rax

; The sum will be returned to the caller module===============
push qword 0
mov rax, 0
mov rdi, exit_message
call printf
pop rax

pop rax ; counter push at the beginning

movsd xmm0, xmm15
mov rax, name
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
