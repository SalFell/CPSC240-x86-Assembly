#!/bin/bash


#Author: Salvador Felipe
#Program name: Right Triangles
#Purpose: script file to run the program files together.


#Clear any previously compiled outputs
rm -f *.o, *out

#echo "This is program <Right Triangles>"

#echo "Assembling start.asm"
nasm -f elf64 -l start.lis -o start.o start.asm -g -gdwarf

#echo "Assembling atof.asm"
nasm -f elf64 -l atof.lis -o atof.o atof.asm -g -gdwarf

#echo "Assembling itoa.asm"
nasm -f elf64 -l itoa.lis -o itoa.o itoa.asm -g -gdwarf

#echo "Assembling ftoa.asm"
nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm -g -gdwarf

#echo "Assembling strlen.asm"
nasm -f elf64 -l strlen.lis -o strlen.o strlen.asm -g -gdwarf

#echo "Link the two object files already created"
ld -o AccCosines.out start.o atof.o strlen.o itoa.o ftoa.o _math.o -g

#echo "Run the program."
gdb ./AccCosines.out

#echo "End Program."

#rm -f *.o, *.lis, *out
