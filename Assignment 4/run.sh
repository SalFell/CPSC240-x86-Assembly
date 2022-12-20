#!/bin/bash


#Author: Salvador Felipe
#Program name: Accurate Cosines
#Purpose: script file to run the program files together.


#Clear any previously compiled outputs
rm -f *.o, *.lis, *out

#echo "This is program <Accurate Cosines>"

#echo "Assembling start.asm"
nasm -f elf64 -l start.lis -o start.o start.asm

#echo "Assembling atof.asm"
nasm -f elf64 -l atof.lis -o atof.o atof.asm

#echo "Assembling itoa.asm"
nasm -f elf64 -l itoa.lis -o itoa.o itoa.asm

#echo "Assembling ftoa.asm"
nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm

#echo "Assembling strlen.asm"
nasm -f elf64 -l strlen.lis -o strlen.o strlen.asm

#echo "Assembling cosine.asm"
nasm -f elf64 -l cosine.lis -o cosine.o cosine.asm

#echo "Assembling getCPUFreq.asm"
nasm -f elf64 -l getCPUFreq.lis -o getCPUFreq.o getCPUFreq.asm

#echo "Link the two object files already created"
ld -o ACosines.out start.o atof.o strlen.o itoa.o ftoa.o cosine.o getCPUFreq.o

#echo "Run the program."
./ACosines.out

#echo "End Program."

rm -f *.o, *.lis, *out
