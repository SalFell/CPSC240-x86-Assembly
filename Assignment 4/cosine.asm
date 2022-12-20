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
;  Author name: Timothy Vu
;  Author email: unknown
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
;   File name: itoa.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l cosine.lis -o cosine.o cosine.asm
;   Link: ld -o ACosines.out start.o atof.o strlen.o itoa.o ftoa.o cosine.o
;   Purpose: This module takes in a float variable and calculates the cosine of it. The result is then returned.

;===== Begin code area ================================================================================================
global cosine
segment .data

segment .bss

segment .text

cosine:

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

; double cosine(double)
; save the user input into a less volatile register ( this is X in the summation )
movsd xmm15, xmm0
; The relation between every term k, k+1 is:
; -1 * x^2
;-------------
;(2k+2)(2k+1)
; Start the term from 1.0 and multiply the recurrance relation against it until terminal

; Remember k is what iteration we are on
; x is the user inputted number

; Current (first) term of maclaurin series is 1.0 ( plug in k = 0 )
mov rax, 1
cvtsi2sd xmm14, rax
; we'll need the numbers 2.0, -1.0, and 1.0 to multiply floats
; (from 2k+1 and 2k+2)
mov rax, 1
cvtsi2sd xmm13, rax
mov rax, 2
cvtsi2sd xmm12, rax
mov rax, -1
cvtsi2sd xmm5, rax
; start k at 0, since we already have the first term of the sequence
mov r15, 0
cvtsi2sd xmm11, r15
; stop at 10,000,000
mov r14, 10000000
; Total sum so far
xorpd xmm10, xmm10
beginloop:
; Check if r15 (k) has hit r14 (10000000)
cmp r15, r14
je end
; Otherwise, add the current term of the sequence
addsd xmm10, xmm14
; Then, compute the next term of the sequence (place into xmm14)
; 2k+1 - xmm12 * xmm11 + xmm13
; creating temporary register for calculations xmm9
movsd xmm9, xmm12
mulsd xmm9, xmm11
addsd xmm9, xmm13

; 2k+2 - xmm12 * xmm11 + xmm12
; creating temporary register for calculations xmm8
movsd xmm8, xmm12
mulsd xmm8, xmm11
addsd xmm8, xmm12

; (2k+1) * (2k+2) - xmm8 * xmm9
mulsd xmm8, xmm9

; X^2 - user input at xmm15
; creating temporary register for calculations xmm7
movsd xmm7, xmm15
mulsd xmm7, xmm7

; X^2
; ----
; (2k+1) (2k+2) - result will be in xmm7
divsd xmm7, xmm8
; multiply -1 against this relation
mulsd xmm7, xmm5
; multiply the recurrance relation against the current term and set the current term to result
mulsd xmm14, xmm7
inc r15
cvtsi2sd xmm11, r15
jmp beginloop

end:
movsd xmm0, xmm10


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
