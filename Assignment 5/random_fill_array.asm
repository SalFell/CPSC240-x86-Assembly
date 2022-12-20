;****************************************************************************************************************************
; Program name: "C Quicksort Benchmark". This program takes in a user defined array size, populates the array with random   *
; random numbers, sorts and prints the array, calculates the execution time of the sort function, and returns the execution *
; time.                                                                                                                     *
; Copyright (C) 2022 Salvador Felipe.                                                                                       *
;                                                                                                                           *
; This file is part of the software program "C Quicksort Benchmark".                                                        *
; C Quicksort Benchmark is free software: you can redistribute it and/or modify it under the terms of the GNU General Public*
; License version 3 as published by the Free Software Foundation.                                                           *
; C Quicksort Benchmark is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the       *
; implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more     *
; details. A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                  *
;****************************************************************************************************************************
; References: Dr. Floyd Holliday, Johnson Tong, David
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
; Author information
;  Author name: Salvador Felipe
;  Author email: sfel@csu.fullerton.edu
;
; Program information
;  Program name: C Quicksort Benchmark
;  Programming languages: Four modules in X86, One module in C++, Three modules in C, One GDB bash file, and One bash file
;  Date program began: 2022 Oct 31
;  Date of last update: 2022 Dec 11
;  Date of reorganization of comments: 2022 Dec 11
;  Files in this program: driver.cpp, sort.c, display.c, show_wall_time.c, manager.asm,  random_fill_array.asm,
;  get_frequency.asm, atof.asm, gun.sh and run.sh
;  Status: Finished.  The program was tested extensively with no errors in Linux 2020 Edition.
;
; Purpose
;  This file contains the statements and functions to fill an array with random numbers using the built in functions rdrand
;  and isnan.
;
; This file
;   File name: random_fill_array.asm
;   Language: X86-64 with Intel syntax
;   Max page width: 132 columns
;   Compile: nasm -f elf64 -l random_fill_array.lis -o random_fill_array.o random_fill_array.asm
;   Link: g++ -m64 -no-pie -o QSBench.out driver.o sort.o manager.o random_fill_array.o get_frequency.o atof.o display.o -std=c17
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
