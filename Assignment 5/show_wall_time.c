//****************************************************************************************************************************
// Program name: "C Quicksort Benchmark". This program takes in a user defined array size, populates the array with random   *
// random numbers, sorts and prints the array, calculates the execution time of the sort function, and returns the execution *
// time.                                                                                                                     *
// Copyright (C) 2022 Salvador Felipe.                                                                                       *
//                                                                                                                           *
// This file is part of the software program "C Quicksort Benchmark".                                                        *
// C Quicksort Benchmark is free software: you can redistribute it and/or modify it under the terms of the GNU General Public*
// License version 3 as published by the Free Software Foundation.                                                           *
// C Quicksort Benchmark is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the       *
// implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more     *
// details. A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                  *
//****************************************************************************************************************************

// References: Dr. Floyd Holliday, Johnson Tong, David

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
// Author information
//  Author name: Salvador Felipe
//  Author email: sfel@csu.fullerton.edu
//
// Program information
//  Program name: C Quicksort Benchmark
//  Programming languages: Four modules in X86, One module in C++, Three modules in C, One GDB bash file, and One bash file
//  Date program began: 2022 Oct 31
//  Date of last update: 2022 Dec 11
//  Date of reorganization of comments: 2022 Dec 11
//  Files in this program: driver.cpp, sort.c, display.c, show_wall_time.c, manager.asm, random_fill_array.asm,
//  get_frequency.asm, atof.asm, gun.sh and run.sh
//  Status: Finished.  The program was tested extensively with no errors in Linux 2020 Edition.
//
// Purpose
//  This file uses C to return the current time and date in the following format: "Day Month Date Time Year"
//
// This file
//   File name: show_wall_time.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc -c -Wall -no-pie -m64 -std=c17 -o show_wall_time.o show_wall_time.c
//   Link: g++ -m64 -no-pie -o QSBench.out driver.o sort.o manager.o random_fill_array.o get_frequency.o atof.o display.o -std=c17
//   Optimal print specification: 132 columns width, 7 points, monospace, 8??x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <string.h>
#include <unistd.h>

char *show_wall_time()
{
  struct timeval tv;
  struct tm *tm;
  char *timeString;
  gettimeofday(&tv, NULL);
  tm = localtime(&tv.tv_sec);
  timeString = asctime(tm);
  timeString[strlen(timeString) - 1] = '\0';
  return timeString;
}
//===== End code area =============================================================================================================
