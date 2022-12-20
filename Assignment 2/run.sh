#!/bin/bash


#Author: Salvador Felipe
#Program name: Right Triangles
#Purpose: script file to run the program files together.


#Clear any previously compiled outputs
rm -f *.o, *.lis, *out

#echo "This is program <Right Triangles>"

#echo "Compile the C++ module pythagoras.cpp"
gcc -c -Wall -no-pie -m64 -std=c17 -o pythagoras.o pythagoras.c

#echo "Assembling triangle.asm"
nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm

#echo "Link the two object files already created"
gcc -m64 -no-pie -o Triangles.out triangle.o pythagoras.o -std=c17

#echo "Run the program."
./Triangles.out

#echo "End Program."

rm -f *.o, *.lis, *out
