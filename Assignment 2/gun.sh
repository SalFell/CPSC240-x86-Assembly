#!/bin/bash


#Author: Salvador Felipe
#Program name: Right Triangles
#Purpose: script file to run the program files together.


#Clear any previously compiled outputs
rm -f *.o, *out

#echo "This is program <Right Triangles>"

#echo "Compile the C++ module pythagoras.c"
gcc -c -Wall -no-pie -m64 -std=c17 -o pythagoras.o pythagoras.c -g

#echo "Assembling triangle.asm"
nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm -g -gdwarf

#echo "Link the two object files already created"
gcc -m64 -no-pie -o Triangles.out triangle.o pythagoras.o -std=c17 -g

#echo "Run the program."
gdb ./Triangles.out

#echo "End Program."

#rm -f *.o, *.lis, *out
