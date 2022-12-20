#!/bin/bash


#Author: Salvador Felipe
#Program name: Quicksort Benchmark
#Purpose: script file to run the program files together.


#Clear any previously compiled outputs
rm -f *.o, *.lis, *out

#echo "This is program <Quicksort Benchmark>"

#echo "Assembling driver.cpp"
g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp -g

#echo "Assembling sort.c"
gcc -c -Wall -no-pie -m64 -std=c17 -o sort.o sort.c -g

#echo "Assembling display.c"
gcc -c -Wall -no-pie -m64 -std=c17 -o display.o display.c -g

#echo "Assembling show_wall_time.c"
gcc -c -Wall -no-pie -m64 -std=c17 -o show_wall_time.o show_wall_time.c -g

#echo "Assembling manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm -g -gdwarf

#echo "Assembling random_fill_array.asm"
nasm -f elf64 -l random_fill_array.lis -o random_fill_array.o random_fill_array.asm -g -gdwarf

#echo "Assembling get_frequency.asm"
nasm -f elf64 -l get_frequency.lis -o get_frequency.o get_frequency.asm -g -gdwarf

#echo "Assembling atof.asm"
nasm -f elf64 -l atof.lis -o atof.o atof.asm -g -gdwarf

#echo "Link the object files already created"
g++ -m64 -no-pie -o QSBench.out driver.o sort.o manager.o random_fill_array.o get_frequency.o atof.o display.o -std=c17 -g

#echo "Run the program."
gdb ./QSBench.out

#echo "End Program."

rm -f *.o, *.lis, *out
