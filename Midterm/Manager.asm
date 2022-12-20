;Author: Salvador Felipe
;Author email: sfel@csu.fullerton.edu
;Date: October 12, 2022
;Section ID: MW 12 - 2 pm
;===== Begin code area ================================================================================================
extern printf
extern scanf
extern fgets
extern strlen
extern stdin
extern get_data
extern show_data
extern max

INPUT_LEN equ 256 ; Max bytes of name, title, response
arraysize equ 6

global Manager

segment .data
name_format db "%s", 0
ask_name db "Please enter your name: ", 10, 0
enter_prompt db "Please enter floating point numbers separated by ws to be stored in a array of size 6 cells.,", 10, 0
enter_prompt_two db "After the last input press <enter> followed by <control+d>.", 10, 0
present_numbers db "These numbers are stored in the array",10,0
the_max_is db "The largest value in the array is %.8lf.", 10 ,0
exit_message db "The control module will now return the sum to the caller module.",10,0

segment .bss  ;Reserved for uninitialized data
the_array resq arraysize ; array of 6 quad words reserved before run time.
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

;Ask for inputs ==============================
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

; Fill the array using the get_data module==============
push qword 0
mov rax, 0
mov rdi, the_array ; array passed in as first param
mov rsi, arraysize         ; array size passed in as second param
call get_data
mov r15, rax
pop rax

;Show valid inputs==============
push qword 0
mov rax, 0
mov rdi, present_numbers
call printf
pop rax

; Display the numbers in the_array using the show_data module
push qword 0
mov rax, 0
mov rdi, the_array
mov rsi, r15
call show_data
pop rax

; Computing the max...=======================
push qword 0
mov rax, 0
mov rdi, the_array
mov rsi, arraysize
call max ;The max will be in xmm0
movsd xmm15, xmm0
pop rax

;Show largest value================
push qword 0
mov rax, 1
mov rdi, the_max_is
movsd xmm0, xmm15
call printf
pop rax

; The max will be returned to the caller module===============
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
