;****************************************************************************************************************************
;Program name: "Floating Point Numbers". This program takes in 2 float numbers as inputs and checks to see if they are      *
;proper float numbers. If one of the numbers is not a float, an error will be returned and the program will exit. Otherwise,*
;it will compare the 2 numbers to see which is the largest. The smaller number will be returned to this driver file. The    *
;largest will be held in the prompts.asm file. Copyright (C) 2022 Salvador Felipe.                                          *
;                                                                                                                           *
;This file is part of the software program "Floating Point Numbers".                                                        *
;Floating Point Numbers is free software: you can redistribute it and/or modify it under the terms of the GNU General Public*
;License version 3 as published by the Free Software Foundation.                                                            *
;Quadratic is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied            *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************

;References: Dr. Floyd Holliday, Johnson Tong, and Chandra Lindy

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Salvador Felipe
;  Author email: sfel@csu.fullerton.edu
;
;Program information
;  Program name: Floating Point Numbers
;  Programming languages: One module in X86, two modules in C++, and one bash file
;  Date program began: 2022 Aug 22
;  Date of last update: 2022 Sep 4
;  Date of reorganization of comments: 2022 Sep 4
;  Files in this program: driver.cpp, prompts.asm, isfloat.cpp, run.sh
;  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
;

;This file
;   File name: prompts.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l prompts.lis -o prompts.o prompts.asm
;   Link: g++ -m64 -no-pie -o assign1.out prompts.o driver.o isfloat.o -std=c++17
;   Purpose: This is the central module that will direct calls to different functions including printf, scanf, isfloat, and atof.
;            Using those functions, two inputted floats from a user will be compared. The smaller float will be
;            returned to the caller of this function (in main.cpp). The larger float will be kept/stored in this file.

;===== Begin code area ================================================================================================
extern printf
extern scanf
extern isfloat
extern atof

global prompts


section .data
	input_format		db "%s %s", 0

	input_prompt		db "Please enter two float numbers separated by white space. Press enter after the second input.", 10, 10, 0
	inputed_numbers		db 10, "These numbers were entered: %.13lf and %.13lf", 10, 10, 0
	largest_number		db "The larger number is %.13lf", 10, 10, 0
	return_prompt		db "This assembly module will now return execution to the driver module.", 10, 0
	smallest_return		db "The smaller number will be returned to the driver.", 10, 10, 0
  error_prompt  db 10, "An invalid input was detected. You may run this program again", 10, 10, 0


section .text

  prompts:

  push rbp
  mov rbp, rsp
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

  ;======================input prompt=================================================
  mov rax, 0                                                  ;number of xmm parameters
  mov rdi, input_prompt
  call printf

  ;========================store inputs================================================
  sub rsp, 2048                                               ;allocate space for 2 strings
  mov rax, 0                                                  ;number of xmm parameters
  mov rdi, input_format   ;"%s%s"
  mov rsi, rsp
  mov rdx, rsp
  add rdx, 1024
  mov r15, rsp
  mov r14, rdx
  call scanf

  ;===================check if inputs are floats======================================
  mov rax, 0
  mov rdi, r15
  call isfloat                                                ;validate inputs from rdi
  cmp rax, 0                                                  ;result is in rax. comparing result of isfloat with 0
  je invalidFloat

  mov rax, 0
  mov rdi, r14
  call isfloat
  cmp rax, 0
  je invalidFloat

  ;==================finish check======================================================

  ;===============is a float, convert 1st num to float and store=======================
  mov rax, 0
  mov rdi, r15
  call atof
  movsd xmm15, xmm0                                           ;xmm15 is first input

  ;====convert 2nd num to float and store====
  mov rax, 0
  mov rdi, r14
  call atof
  movsd xmm14, xmm0                                           ;xmm14 is second input

  ;==================finish converting and storing======================================

  add rsp, 2048                                               ;reset rsp

  ;======================output the two floats======================================
  mov rax, 2
  mov rdi, inputed_numbers
  movsd xmm0, xmm15
  movsd xmm1, xmm14
  call printf

  ;=======================compare the two floats. put largest in xmm9====================
  ucomisd xmm15, xmm14
  jbe second_num_greater

  first_num_greater:
    mov rax, 1                                                ;1 xmm parameter
    mov rdi, largest_number                                   ;output largest number
    movsd xmm0, xmm15
    call printf

    movsd xmm9, xmm15                                         ;store larger number in xmm9
    jmp x14_smaller_end

  second_num_greater:
    mov rax, 1                                                ;1 xmm parameter
    mov rdi, largest_number                                   ;output largest number
    movsd xmm0, xmm14
    call printf

    movsd xmm9, xmm14                                         ;store larger number in xmm9
    jmp x15_smaller_end

  ;==============print error=============================================================
  invalidFloat:
    mov rax, 0                                                ;0 xmm parameters
    mov rdi, error_prompt
    call printf

    mov rax, -1
    cvtsi2sd xmm13, rax                                       ;convert -1 to double
    movsd xmm0, xmm13                                         ;return -1 to caller
    add rsp, 2048                                             ;restore rsp

    jmp reset

  ;======print exit statements and return to driver=======
  x15_smaller_end:
    mov rax, 0
    mov rdi, return_prompt
    call printf

    mov rax, 0
    mov rdi, smallest_return
    call printf

    movsd xmm0, xmm15                                         ;return smaller number to caller

    jmp reset

  x14_smaller_end:
    mov rax, 0
    mov rdi, return_prompt
    call printf

    mov rax, 0
    mov rdi, smallest_return
    call printf

    movsd xmm0, xmm14                                         ;return smaller number to caller

reset:
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
