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
;  This file contains the statements and functions that will fill the array with random numbers. It will ignore
;  any NaN numbers and numbers that are near zero.
;
; This file
;   File name: random_fill_array.asm
;   Language: X86-64 with Intel syntax
;   Max page width: 132 columns
;   Compile: nasm -f elf64 -l random_fill_array.lis -o random_fill_array.o random_fill_array.asm
;   Link: g++ -m64 -no-pie -o HMean.out driver.o supervisor.o hsum.o random_fill_array.o display.o -std=c17
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;
;===== Begin code area ===========================================================================================================

global random_fill_array

extern isnan
extern rdrand

segment .data
segment .bss
segment .text

random_fill_array:

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

  ; Taking information from parameters
  mov r15, rdi  ; This holds the first parameter (the array)
  mov r14, rsi  ; This holds the second parameter (the size of array)
  mov r13, 0    ; Set a counter to 0

  ;=====begin loop===================================================================================================
  begin:
    rdrand rax  ; Get a random number
    cvtsi2sd xmm11, rax ; Convert it to a double
    mov rdi, rax
    call isnan    ;this is a library function; it returns 1 if the number is NaN
    cmp rax, 1
    je begin
    ;check if the number's stored exponent is 11 bits of zeros
    ;if it is, then the number is NaN
    shr rdi, 52
    cmp rdi, 0
    je begin
    ;else is not NaN
    movsd [r15 + 8 * r13], xmm11  ;store the random number in the array
    inc r13                      ;increment the counter
    cmp r13, r14    ;check array size, r14 is given array_size
    jl begin
  ;=====end loop=====================================================================================================

  pop rax     ;pop off the 0
  mov rax, r13    ;return the number of random numbers generated

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

;what does isnan return?
;1 if it is a NaN
;0 if it is not a NaN
