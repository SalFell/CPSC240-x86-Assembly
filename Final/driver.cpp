//****************************************************************************************************************************
// Program name: "Harmonic Mean". This program takes in a user defined array size, populates the array with random numbers,  *
// prints the array, and calculates the harmonic sum and harmonic mean of the array, and returns the mean to the driver.     *
// Copyright(C) 2022 Salvador Felipe.                                                                                        *
//                                                                                                                           *
// This file is part of the software program "Harmonic Mean".                                                                *
// Harmonic Mean is free software: you can redistribute it and/or modify it under the terms of the GNU General Public        *
// License version 3 as published by the Free Software Foundation.                                                           *
// Harmonic Mean is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the               *
// implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more     *
// details. A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                  *
//****************************************************************************************************************************

// References: Johnson Tong

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
// Author information
//  Author name: Salvador Felipe
//  Course number: CPSC240-01
//  Final Program Test
//  Author email: sfel@csu.fullerton.edu
//
// Program information
//  Program name: Harmonic Mean
//  Programming languages: Four modules in X86, One module in C++, Three modules in C, One GDB bash file, and One bash file
//  Date program began: 2022 Dec 12
//  Date of last update: 2022 Dec 12
//  Date of reorganization of comments: 2022 Dec 12
//  Files in this program: driver.cpp, display.c, supervisor.asm, random_fill_array.asm, hsum.asm and run.sh
//  Status: Finished.  The program was tested extensively with no errors in Linux 2020 Edition.
//
// Purpose
//  This file contains the driver module. It will call the supervisor module and display the results.
//
// This file
//   File name: driver.cpp
//   Language: C++
//   Max page width: 132 columns
//   Compile: g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp
//   Link: g++ -m64 -no-pie -o HMean.out driver.o supervisor.o hsum.o random_fill_array.o display.o -std=c17
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================

#include <iostream>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern "C" double
supervisor();

int main(int argc, char *argv[])
{
  std::cout<< "Welcome to Harmonic Mean by Salvador Felipe\n\n";

  std::cout<< "This program will compute the harmonic mean of your numbers.\n\n";

  double hmean = supervisor();

  printf("The main program received %.10g and will keep it for a while.\n\n", hmean);

  std::cout << "Enjoy your winter break\n\n";
  return 0;
}
