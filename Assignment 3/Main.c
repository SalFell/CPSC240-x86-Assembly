//****************************************************************************************************************************
//Program name: "Arrays". This program computes the sum of a user inputted array. Validation is done to ensure proper inputs *
//of integers. Copyright (C) 2022 Salvador Felipe.                                                                           *
//                                                                                                                           *
//This file is part of the software program "Arrays".                                                                        *
//Arrays is free software: you can redistribute it and/or modify it under the terms of the GNU General Public                *
//License version 3 as published by the Free Software Foundation.                                                            *
//Arrays is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the                       *
//implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more      *
//details. A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                   *
//****************************************************************************************************************************

//References: Dr. Floyd Holliday and Johnson Tong

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
// Author information
//  Author name: Salvador Felipe
//  Author email: sfel@csu.fullerton.edu
//
// Program information
//  Program name: Arrays
//  Programming languages: Three modules in X86, one modules in C, one module in C++, and one bash file
//  Date program began: 2022 Sep 19
//  Date of last update: 2022 Oct 9
//  Date of reorganization of comments: 2022 Oct 9
//  Files in this program: Main.c, Manager.asm, Input_array.asm, Sum.asm, Display_Array.asm, and run.sh
//  Status: Finished.  The program was tested extensively with no errors in Linux 2020 Edition.
//
// Purpose
//  This file contains the functions that will display the Welcome Message/Good-Bye Message. This file will also call Manager.asm
//  to start array calculations.
//
// This file
//   File name: Main.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc - c - Wall - no - pie - m64 - std = c17 - o Main.o Main.cpp
//   Link: g++ -m64 -no-pie -o Arrays.out Input_array.o Sum.o Manager.o Display_Array.o Main.o -std=c++17
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern const char* Manager();

int main(int argc, char *argv[])
{
  printf("Welcome to Array of Integers\n Brought to you by Salvador Felipe.\n");

  const char* name = Manager();

  printf("\nI hope you liked your arrays %s\n", name);
  printf("Main will return 0 to the operating system.   Bye.\n");
  return 0;
}
