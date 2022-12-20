#!/bin/bash


#Author: Salvador Felipe
#Program name: FLoating Point Numbers
#Purpose: script file to run the program files together.


#Clear any previously compiled outputs
rm -f *.o, *.lis, *out

#echo "This is program <Floating Point Numbers>"

#echo "Compile the C++ module driver.cpp"
g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp

#echo "Assemble isfloat.cpp"
g++ -c -Wall -no-pie -m64 -std=c++17 -o isfloat.o isfloat.cpp

#echo "Assembling prompts.asm"
nasm -f elf64 -l prompts.lis -o prompts.o prompts.asm

#echo "Link the two object files already created"
g++ -m64 -no-pie -o assign1.out prompts.o driver.o isfloat.o -std=c++17

#echo "Run the program."
./assign1.out

#echo "End Program."

rm -f *.o, *.lis, *out
