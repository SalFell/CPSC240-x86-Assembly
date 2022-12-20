;****************************************************************************************************************************
;Program name: "Right Triangles". This program takes in the lengths of 2 sides of a right triangle and calculates the area  *
;and length of the hypotenuse. Copyright (C) 2022 Salvador Felipe.                                                          *
;                                                                                                                           *
;This file is part of the software program "Right Triangles".                                                               *
;Right Triangles is free software: you can redistribute it and/or modify it under the terms of the GNU General Public       *
;License version 3 as published by the Free Software Foundation.                                                            *
;Right Triangles is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied      *
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
;  Program name: Right Triangles
;  Programming languages: One module in X86, one module in C, and two bash files
;  Date program began: 2022 Sep 6
;  Date of last update: 2022 Sep 17
;  Date of reorganization of comments: 2022 Sep 4
;  Files in this program: pythagoras.cpp, triangle.asm, run.sh, gun.sh
;  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
;

;This file
;   File name: triangle.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm
;   Link: g++ -m64 -no-pie -o assign1.out triangle.o pythagoras.o -std=c++17
;   Purpose: This is the central module that will direct calls to different functions including printf, scanf, mulsd, and sqrt.
;            Using those functions, two inputted floats from a user will be used to calculate a right triangle's hypotenuse
;            and area. These calculations will be returned to the caller of this function (in pythagoras.c).

;===== Begin code area ================================================================================================
extern printf
extern scanf
extern fgets
extern stdin
extern strlen

INPUT_LEN equ 256
LARGE_BOUNDARY equ 64
SMALL_BOUNDARY equ 16

global triangle


section .data
	float_format		db "%lf", 0
  string_format   db "%s", 0

  last_name   db "Please enter your last name: ", 0
  title_prompt    db 10, "Please enter your title (Mr, Ms, Nurse, Engineer, etc): ", 0
	input_prompt		db 10, "Please enter the sides of your triangle separated by ws: ", 0
	hypotenuse		db 10, "The length of the hypotenuse is %.9lf units.", 10, 0
	enjoy_prompt		db 10, "Please enjoy your triangles %s %s.", 10, 0

section .bss
  ;reserve bytes for the name, title, and response given by user
  ;reserve 256 bytes for each
  name: resb INPUT_LEN
  title: resb INPUT_LEN
  response: resb INPUT_LEN


section .text

  triangle:

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

  push qword 0    ;remain on boundary
  ;======================input prompts=================================================
  ;last name prompt
  push qword 0
  mov rax, 0                                                  ;number of xmm parameters
  mov rdi, string_format
  mov rsi, last_name
  call printf
  pop rax

  ;store last name
  mov rax, 0
  mov rdi, name
  mov rsi, INPUT_LEN
  mov rdx, [stdin]
  call fgets

  ;remove newline from fgets
  mov rax, 0
  mov rdi, name
  call strlen

  sub rax, 1
  mov byte [name + rax], 0


  ;title prompt
  push qword 0
  mov rax, 0                                                  ;number of xmm parameters
  mov rdi, string_format
  mov rsi, title_prompt
  call printf
  pop rax

  ;store title
  mov rax, 0
  mov rdi, title
  mov rsi, INPUT_LEN
  mov rdx, [stdin]
  call fgets

  ;remove newline from fgets
  mov rax, 0
  mov rdi, title
  call strlen

  sub rax, 1
  mov byte [title + rax], 0

sides:
  ;input prompts
  push qword 0
  mov rax, 0                                                  ;number of xmm parameters
  mov rdi, input_prompt
  call printf
  pop rax

  ;store input 1
  push qword 0
  mov rax, 0
  mov rdi, float_format
  mov rsi, rsp
  call scanf
  movsd xmm15, [rsp]
  pop rax

  ;store input 2
  push qword 0
  mov rax, 0
  mov rdi, float_format
  mov rsi, rsp
  call scanf
  movsd xmm14, [rsp]
  pop rax

  ;======================check for negative inputs==============================
  mov rax, 0
  cvtsi2sd xmm10, rax   ;xmm10 = 0

  ucomisd xmm15, xmm10
  jbe sides   ;ask for inputs again until non-negatives

  ucomisd xmm14, xmm10
  jbe sides   ;ask for inputs again until non-negatives
  ;======================calculate hypotenuse===================================
  ;a = xmm15
  ;b = xmm14
  ;c = sqrt((a * a) + (b * b))
  movsd xmm13, xmm15
  mulsd xmm13, xmm13    ;using xmm13 to store value of a * a

  movsd xmm12, xmm14
  mulsd xmm12, xmm12    ;using xmm12 to store value of b * b

  addsd xmm13, xmm12    ;result stored in xmm13
  sqrtsd xmm11, xmm13   ;taking sqrt of xmm13, store answer in xmm11

  ;======================output hypotenuse======================================
  push qword 0
  mov rax, 1
  mov rdi, hypotenuse
  movsd xmm0, xmm11
  call printf
  pop rax

  push qword 0
  mov rax, 0
  mov rdi, enjoy_prompt
  mov rsi, title
  mov rdx, name
  call printf
  pop rax

  movsd xmm0, xmm11    ;return hypotenuse to pythagoras.c

reset:
  pop rax   ;reset initial push
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
