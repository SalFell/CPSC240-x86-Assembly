;Author: Salvador Felipe
;Author email: sfel@csu.fullerton.edu
;Date: October 12, 2022
;Section ID: MW 12 - 2 pm
;========================================================================================================
extern printf
extern scanf
;extern atof

global max


section .data

section .text

  max:

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
;==============================================================================================
  push qword 0 ; remain on the boundary

  ; Taking information from parameters
  mov r15, rdi  ; This holds the first parameter (the array)
  mov r14, rsi  ; This holds the second parameter (the number of elements in the array, not size)

  cvtsi2sd xmm15, [r15]   ;first element as float
  mov r12, 0    ;counter to help loop

begin_loop:
  mov rax, 1
  cmp r12, r14
  jge outOfLoop

  ucomisd xmm15, [r15 + 8 * r12]
  jb new_max
  inc r12

  jmp begin_loop

new_max:
  movsd xmm15, [r15 + 8 * r12]
  inc r12
  jmp begin_loop

outOfLoop:
  pop rax
  movsd xmm0, xmm15   ;return largest to caller

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
