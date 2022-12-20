#!/bin/bash


#Author: Salvador Felipe
#Author email: sfel@csu.fullerton.edu
#Date: October 12, 2022
#Section ID: MW 12 - 2 pm


#Clear any previously compiled outputs
rm -f *.o, *.lis, *out

#echo "This is program <Arrays>"

#echo "Compile the C module driver.cpp"
g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp

#echo "Compile the C++ module show_data.cpp"
g++ -c -Wall -no-pie -m64 -std=c++17 -o show_data.o show_data.cpp

#echo "Compile the C++ module isfloat.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o isfloat.o isfloat.cpp -std=c++17

#echo "Assembling Manager.asm"
nasm -f elf64 -l Manager.lis -o Manager.o Manager.asm

#echo "Assembling max.asm"
nasm -f elf64 -l max.lis -o max.o max.asm

#echo "Assembling get_data.asm"
nasm -f elf64 -l get_data.lis -o get_data.o get_data.asm

#echo "Link the two object files already created"
g++ -m64 -no-pie -o Arrays.out get_data.o max.o Manager.o isfloat.o show_data.o driver.o -std=c++17

#echo "Run the program."
./Arrays.out

#echo "End Program."

rm -f *.o, *.lis, *out
