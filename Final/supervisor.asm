;****************************************************************************************************************************
; Program name: "Harmonic Mean". This program takes in a user defined array size, populates the array with random numbers,  *
; prints the array, and calculates the harmonic sum and harmonic mean of the array, and returns the mean to the driver.     *
; Copyright (C) 2022 Salvador Felipe.                                                                                       *
;                                                                                                                           *
; This file is part of the software program "Harmonic Mean".                                                                *
; Harmonic Mean is free software: you can redistribute it and/or modify it under the terms of the GNU General Public        *
; License version 3 as published by the Free Software Foundation.                                                           *
; Harmonic Mean is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the               *
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more     *
; details. A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                  *
;****************************************************************************************************************************
; References: Johnson Tong
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
; Author information
;  Author name: Salvador Felipe
;  Course number: CPSC240-01
;  Final Program Test
;  Author email: sfel@csu.fullerton.edu
;
; Program information
;  Program name: Harmonic Mean
;  Programming languages: Three modules in X86, One module in C++, One module in C, and One bash file
;  Date program began: 2022 Dec 12
;  Date of last update: 2022 Dec 12
;  Date of reorganization of comments: 2022 Dec 12
;  Files in this program: driver.cpp, display.c, supervisor.asm, random_fill_array.asm, hsum.asm and run.sh
;  Status: Finished.  The program was tested extensively with no errors in Linux 2020 Edition.
;
; Purpose
;  This file contains the statements and functions to ask for user input, call random_fill_array.asm,
;  call display.c, call hsum.asm, and calculate and return the harmonic mean.
;
; This file
;   File name: supervisor.asm
;   Language: X86-64 with Intel syntax
;   Max page width: 132 columns
;   Compile: nasm -f elf64 -l supervisor.lis -o supervisor.o supervisor.asm
;   Link: g++ -m64 -no-pie -o HMean.out driver.o supervisor.o hsum.o random_fill_array.o display.o -std=c17
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;
;===== Begin code area ===========================================================================================================

extern printf
extern scanf
extern random_fill_array
extern display
extern hsum

LARGE_BOUNDARY equ 1000000  ;allocate memory for 64-bit float array that can hold 1M numbers
global supervisor

segment .data
input db "Please input the count of number of data items to be placed into the array with maximum 1 million): ", 0
filled_message db 10, "The array has been filled with non-deterministic random 64-bit float numbers.", 10, 10, 0
show_array db "Here are the values in the array:", 10, 0
hsum_message db 10, "The harmonic sum is %.10g", 10, 10, 0
hmean_message db "The harmonic mean is %.10g", 10, 10, 0
return_message db "The supervisor will return the mean to the caller.", 10, 10, 0

one_int db "%d", 0

segment .bss  ;Reserved for uninitialized data
floatArray resq LARGE_BOUNDARY  ;Array of 64-bit floats

segment .text ;Reserved for executing instructions.

supervisor:
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

  push qword 0    ;remain on boundary

askUser:
  ;=====ask for user defined array size========
  push qword 0
  mov rax, 0
  mov rdi, input
  call printf
  pop rax

  ; Take user input and store it in r14.
  push qword 0
  mov rax, 0
  mov rdi, one_int
  mov rsi, rsp
  call scanf
  mov r14, [rsp]
  pop rax

  cmp r14, LARGE_BOUNDARY ;if array size > 1M
  jg askUser           ;ask for user input again

  ;=====fill array with random numbers==================================
  ;Call random_fill_array function and store the # of values into r14.
  mov rax, 0
  mov rdi, floatArray    ; Address of array.
  mov rsi, r14           ; Max size of array.
  call random_fill_array
  mov r14, rax           ; Save size of array into r14.

  ;=====display filled message
  push qword 0
  mov rax, 0
  mov rdi, filled_message
  call printf
  pop rax

  ;=====display array==========================================
  push qword 0
  mov rax, 0
  mov rdi, show_array
  call printf
  pop rax

  ;call display for all elements in array
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, 0           ; Starting index of array.
  mov rdx, r14          ; Number of elements to display.
  call display        ; Display the array.
  pop rax

  ;=====calculate harmonic sum==========================================
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, r14          ; Number of elements to display.
  call hsum
  movsd xmm15, xmm0         ; Save harmonic sum into xmm15
  pop rax

  ;=====display harmonic sum==========================================
  push qword 0
  mov rax, 1
  mov rdi, hsum_message
  movsd xmm0, xmm15
  call printf
  pop rax

  ;=====calculate harmonic mean==========================================
  cvtsi2sd xmm14, r14
  divsd xmm15, xmm14

  ;=====display harmonic mean==========================================
  push qword 0
  mov rax, 1
  mov rdi, hmean_message
  movsd xmm0, xmm15
  call printf
  pop rax

  ;=====exit================================================
exit:
  push qword 0
  mov rax, 0
  mov rdi, return_message
  call printf
  pop rax

  pop rax                                                    ;Pop initial push
  movsd xmm0, xmm15 ;return harmonic mean to caller

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
