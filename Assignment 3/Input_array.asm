;****************************************************************************************************************************
;Program name: "Arrays". This program computes the sum of a user inputted array. Validation is done to ensure proper inputs *
;of integers. Copyright (C) 2022 Salvador Felipe.                                                                           *
;                                                                                                                           *
;This file is part of the software program "Arrays".                                                                        *
;Arrays is free software: you can redistribute it and/or modify it under the terms of the GNU General Public                *
;License version 3 as published by the Free Software Foundation.                                                            *
;Arrays is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied               *
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
;  Programming languages: Three modules in X86, one module in C, one module in C++, and one bash file
;  Date program began: 2022 Sep 19
;  Date of last update: 2022 Oct 9
;  Date of reorganization of comments: 2022 Oct 9
;  Files in this program: Main.c, Manager.asm, Input_array.asm, Sum.asm, Display_Array.asm, and run.sh
;  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
;

;This file
;   File name: Input_array.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l Input_array.lis -o Input_array.o Input_array.asm
;   Link: g++ -m64 -no-pie -o Arrays.out Input_array.o Sum.o Manager.o Display_Array.o Main.o -std=c++17
;   Purpose: This module will take in user inputs, validate for proper integers, and store in an array to be used by the
;            Manager.asm and Sum.asm module. If invalid inputs are detected, nothing is returned to Manager.asm

;===== Begin code area ================================================================================================
extern printf
extern scanf
extern isfloat
extern atol

global Input_array

segment .data

enter_prompt db "Enter a sequence of long integers separated by white space.,", 10, 0
enter_prompt_two db "After the last input press enter followed by Control+D:", 10, 0
float_format db "%s", 0

segment .bss  ;Reserved for uninitialized data

segment .text ;Reserved for executing instructions.

Input_array:

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
;============================================================================
push qword 0 ;staying on the boundary

; Taking information from parameters
mov r15, rdi  ; This holds the first parameter (the array)
mov r14, rsi  ; This holds the second parameter (the size of array)

;Prompts:=============================================
;"Please enter floating point numbers separated by ws,"
;"When finished press enter followed by Cntrl+D."
push qword 0
mov rax, 0
mov rdi, enter_prompt
call printf
pop rax

push qword 0
mov rax, 0
mov rdi, enter_prompt_two
call printf
pop rax
;======================================================
; let user enter numbers until cntrl + d is entered
mov r13, 0 ; for loop counter
beginLoop:
  cmp r14, r13 ; we want to exit loop when we hit the size of array
  je outOfLoop

  mov rax, 0
  mov rdi, float_format
  push qword 0
  mov rsi, rsp
  call scanf

  cdqe
  cmp rax, -1  ; loop termination condition: user enters cntrl + d.
  ;pop r12
  je outOfLoop

  ;Checks if user input is an integer========================================================
	mov rax, 0
	mov rdi, rsp			;Passing user input (Stored in rsp) into isfloat
	call isfloat			;If user input is long, return 1, else return 0
	cmp rax, 0				;Sees if user input is not int type
	je notAnInt
	;===============================================================================================

	;Converts any strings --> long
	mov rax, 0
	mov rdi, rsp				;Passing user input stored in rsp into atol
	call atol
	mov r11, rax				;Storing processeed value into r11
	pop r8

  mov [r15 + 8*r13], r11  ;at array[counter], place the input number
  inc r13  ;increment loop counter
  jmp beginLoop

notAnInt:
  ;pop r8
  jmp beginLoop

outOfLoop:
  pop rax ; counter push at the beginning
  mov rax, r13  ; store the number of things in the aray from the counter of for loop
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
