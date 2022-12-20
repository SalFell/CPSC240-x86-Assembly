#!/bin/bash


#Author: Salvador Felipe
#Program name: Harmonic Mean
#Purpose: script file to run the program files together.


#Clear any previously compiled outputs
rm -f *.o, *.lis, *out

#echo "This is program <Quicksort Benchmark>"

#echo "Assembling driver.cpp"
g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp

#echo "Assembling display.c"
gcc -c -Wall -no-pie -m64 -std=c17 -o display.o display.c

#echo "Assembling supervisor.asm"
nasm -f elf64 -l supervisor.lis -o supervisor.o supervisor.asm

#echo "Assembling supervisor.asm"
nasm -f elf64 -l hsum.lis -o hsum.o hsum.asm

#echo "Assembling random_fill_array.asm"
nasm -f elf64 -l random_fill_array.lis -o random_fill_array.o random_fill_array.asm

#echo "Link the object files already created"
g++ -m64 -no-pie -o HMean.out driver.o supervisor.o hsum.o random_fill_array.o display.o -std=c17

#echo "Run the program."
./HMean.out

#echo "End Program."

rm -f *.o, *.lis, *out
