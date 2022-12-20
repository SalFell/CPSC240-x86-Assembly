#!/bin/bash


#Author: Salvador Felipe
#Program name: Arrays
#Purpose: script file to run the program files together.


#Clear any previously compiled outputs
rm -f *.o, *.lis, *out

#echo "This is program <Arrays>"

#echo "Compile the C module Main.c"
gcc -c -Wall -no-pie -m64 -std=c17 -o Main.o Main.c

#echo "Compile the C++ module Display_Array.cpp"
g++ -c -Wall -no-pie -m64 -std=c++17 -o Display_Array.o Display_Array.cpp

#echo "Compile the C++ module isfloat.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o isfloat.o isfloat.cpp -std=c++17

#echo "Assembling Manager.asm"
nasm -f elf64 -l Manager.lis -o Manager.o Manager.asm

#echo "Assembling Sum.asm"
nasm -f elf64 -l Sum.lis -o Sum.o Sum.asm

#echo "Assembling Input_array.asm"
nasm -f elf64 -l Input_array.lis -o Input_array.o Input_array.asm

#echo "Assembling atol.asm"
nasm -f elf64 -o atol.o atol.asm

#echo "Link the two object files already created"
g++ -m64 -no-pie -o Arrays.out Input_array.o Sum.o Manager.o atol.o isfloat.o Display_Array.o Main.o -std=c++17

#echo "Run the program."
./Arrays.out

#echo "End Program."

rm -f *.o, *.lis, *out
