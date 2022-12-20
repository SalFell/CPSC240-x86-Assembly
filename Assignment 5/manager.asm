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
;  This file contains the statements and functions to ask for user input, call random_fill_array.asm, call sort.c,
;  call display.c, calculate the execution time of the sort function, and return the execution time.
;
; This file
;   File name: manager.asm
;   Language: X86-64 with Intel syntax
;   Max page width: 132 columns
;   Compile: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;   Link: g++ -m64 -no-pie -o QSBench.out driver.o sort.o manager.o random_fill_array.o get_frequency.o atof.o display.o -std=c17
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
extern getfreq
extern fsort

LARGE_BOUNDARY equ 10000000  ;allocate memory for 64-bit float array that can hold 1M numbers
global manager

segment .data
input db "Please input the count of number of data items to be placed into the array with maximum 10 million): ", 0
filled_message db 10, "The array has been filled with non-deterministic random 64-bit float numbers.", 10, 10, 0
begin_array db "Here are 10 numbers of the array at the beginning.", 10, 0
middle_array db "Here are 10 numbers starting at the middle of the array.", 10, 0
end_array db "Here are the last 10 numbers of the array.", 10, 0
begin_tics db "The time is now %lu tics. Sorting will begin", 10, 10, 0
end_tics db "The time is now %lu tics. Sorting has finished", 10, 10, 0
seconds db "Total sort time is %lu tics which equals %lf seconds.", 10, 10, 0
return_message db "The bench mark time will be returned to the driver.", 10, 10, 0

one_int db "%d", 0

segment .bss  ;Reserved for uninitialized data
floatArray resq LARGE_BOUNDARY  ;Array of 64-bit floats

segment .text ;Reserved for executing instructions.

manager:
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

  cmp r14, LARGE_BOUNDARY ;if array size > 10M
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

  ;=====display unsorted array==========================================
  push qword 0
  mov rax, 0
  mov rdi, begin_array
  call printf
  pop rax

  cmp r14, 10 ;if array size <= 10
  jle lessThanten ;print all elements

  ;else print first, middle, and last 10 elements
  ;call display for first 10 elements in array
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, 0           ; Starting index of array.
  mov rdx, 10          ; Number of elements to display.
  call display        ; Display the array.
  pop rax

  ;middle 10 message
  push qword 0
  mov rax, 0
  mov rdi, middle_array
  call printf
  pop rax

  ;calculate middle start index
  mov rdx, 0
  mov rax, r14
  mov rcx, 2
  div rcx       ;divide by 2
  mov r12, rax
  sub r12, 5  ;first index of middle 10

  ;call display for middle 10 elements in array
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, r12           ; Starting index of array.
  mov rdx, 10          ; Number of elements to display.
  call display        ; Display the array.
  pop rax

  ;last 10 message
  push qword 0
  mov rax, 0
  mov rdi, end_array
  call printf
  pop rax

  ;calculate end start index
  mov r12, r14  ;make copy of array size
  sub r12, 10  ;first index of last 10

  ;call display for the last 10 elements
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, r12           ; Starting index of array.
  mov rdx, 10          ; Number of elements to display.
  call display        ; Display the array.
  pop rax

  jmp read_clock

lessThanten:
  ;call display for all elements in array
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, 0           ; Starting index of array.
  mov rdx, r14          ; Number of elements to display.
  call display        ; Display the array.
  pop rax

  ;middle 10 message
  push qword 0
  mov rax, 0
  mov rdi, middle_array
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

  ;last 10 message
  push qword 0
  mov rax, 0
  mov rdi, end_array
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

read_clock:
  ;=====read clock============
      ;early tics
  ;get tics and store in r13.
  mov rax, 0
  mov rdx, 0

  ;stop system and read clock time.
  cpuid
  rdtsc

  shl rdx, 32     ;shift all the bits of rax 32 bits to the left.
  add rdx, rax    ;our number of tics.
  mov r13, rdx    ;store the number of tics in r13.

  ;=====call sort====================
  push qword 0
  mov rax, 0
  mov rdi, begin_tics
  mov rsi, r13
  call printf
  pop rax

  push qword 0
  mov rax, 0
  mov rdi, floatArray  ; Address of array.
  mov rsi, r14 ;size of array
  call fsort
  pop rax

  ;=====read clock====================
      ;late tics
  ;get tics and store in r12.
  mov rax, 0
  mov rdx, 0

  ;stop system and read clock time.
  cpuid
  rdtsc

  shl rdx, 32     ;shift all the bits of rax 32 bits to the left.
  add rdx, rax    ;our number of tics.
  mov r12, rdx    ;store the number of tics in r12.

  push qword 0
  mov rax, 0
  mov rdi, end_tics  ;print end tics
  mov rsi, r12
  call printf
  pop rax

  ;=====calculate runtime=================
  ;late tics - early tics / frequency
  ;Calculate elapsed time.
  mov rax, 0
  mov r11, r12
  sub r13, r11  ;r13 holds elapsed time in tics
  cvtsi2sd xmm10, r13  ;Convert r13 to a double and store in xmm10.

  ;Get the frequency and store it in xmm11.
  mov rax, 1
  call getfreq
  movsd xmm11, xmm0

  divsd xmm10, xmm11  ; xmm10 holds elapsed time in seconds.

  ; Get value of 1 billion and store it in xmm10.
  mov rax, 0x41cdcd6500000000
  push rax
  movsd xmm9, [rsp]
  pop rax

  ; Divide elapsed time by 1 billion to get elapsed time in seconds.
  divsd xmm10, xmm9

  ;=====output runtime in seconds
  ;Print the frequency of the user's machine.
  push qword 0
  mov rax, 1
  mov rdi, seconds
  mov rsi, r11  ; Elapsed time in tics.
  movsd xmm0, xmm10 ; Elapsed time in seconds.
  call printf
  pop rax

  ;=====display sorted array=======================
  push qword 0
  mov rax, 0
  mov rdi, begin_array
  call printf
  pop rax

  cmp r14, 10  ;if array size <= 10
  jle lessThantenSorted   ;print all elements

  ;else print first, middle, and last 10 elements
  ;call display for first 10 elements in array
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, 0           ; Starting index of array.
  mov rdx, 10          ; Number of elements to display.
  call display        ; Display the array.
  pop rax

  ;middle 10 message
  push qword 0
  mov rax, 0
  mov rdi, middle_array
  call printf
  pop rax

  ;calculate middle start index
  mov rdx, 0
  mov rax, r14
  mov rcx, 2
  div rcx       ;divide by 2
  mov r12, rax
  sub r12, 5  ;first index of middle 10

  ;call display for middle 10 elements in array
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, r12           ; Starting index of array.
  mov rdx, 10          ; Number of elements to display.
  call display        ; Display the array.
  pop rax

  ;last 10 message
  push qword 0
  mov rax, 0
  mov rdi, end_array
  call printf
  pop rax

  ;calculate end start index
  mov r12, r14  ;make copy of array size
  sub r12, 10  ;first index of last 10

  ;call display for the last 10 elements
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, r12           ; Starting index of array.
  mov rdx, 10          ; Number of elements to display.
  call display        ; Display the array.
  pop rax

  jmp exit

lessThantenSorted:
  ;call display for all elements in array
  push qword 0
  mov rax, 0
  mov rdi, floatArray   ; Address of array.
  mov rsi, 0           ; Starting index of array.
  mov rdx, r14          ; Number of elements to display.
  call display        ; Display the array.
  pop rax

  ;middle 10 message
  push qword 0
  mov rax, 0
  mov rdi, middle_array
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

  ;last 10 message
  push qword 0
  mov rax, 0
  mov rdi, end_array
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

  ;=====exit================================================
exit:
  push qword 0
  mov rax, 0
  mov rdi, return_message
  call printf
  pop rax

  pop rax
  movsd xmm0, xmm10 ;return elapsed time in seconds.

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
