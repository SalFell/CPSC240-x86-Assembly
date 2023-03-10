//****************************************************************************************************************************
//Program name: "Floating Point Numbers". This program takes in 2 float numbers as inputs and checks to see if they are      *
//proper float numbers. If one of the numbers is not a float, an error will be returned and the program will exit. Otherwise,*
//it will compare the 2 numbers to see which is the largest. The smaller number will be returned to this driver file. The    *
//largest will be held in the prompts.asm file. Copyright (C) 2022 Salvador Felipe.                                          *
//                                                                                                                           *
//This file is part of the software program "Floating Point Numbers".                                                        *
//Floating Point Numbers is free software: you can redistribute it and/or modify it under the terms of the GNU General Public*
//License version 3 as published by the Free Software Foundation.                                                            *
//Floating Point Numbers is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the       *
//implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more      *
//details. A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                   *
//****************************************************************************************************************************

//References: Dr. Floyd Holliday, Johnson Tong, and Chandra Lindy

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Salvador Felipe
//  Author email: sfel@csu.fullerton.edu
//
//Program information
//  Program name: Floating Point Numbers
//  Programming languages: One module in X86, two modules in C++, and one bash file
//  Date program began: 2022 Aug 22
//  Date of last update: 2022 Sep 4
//  Date of reorganization of comments: 2022 Sep 4
//  Files in this program: driver.cpp, prompts.asm, isfloat.cpp, run.sh
//  Status: Finished.  The program was tested extensively with no errors in Linux 2020 Edition.
//
//Purpose
//  This file contains the functions that will display the floating point numbers in the prompts.asm assembly file.
//
//This file
//   File name: driver.cpp
//   Language: C++
//   Max page width: 132 columns
//   Compile: g++ - c - Wall - no - pie - m64 - std = c++ 17 - o driver.o driver.cpp
//   Link: g++ -m64 -no-pie -o assign1.out prompts.o driver.o isfloat.o -std=c++17
//   Optimal print specification: 132 columns width, 7 points, monospace, 8??x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>
#include <iostream>

                                                 extern "C" double
                                                 prompts();

int main(int argc, char *argv[])
{
  std::cout.precision(7);

  printf("Welcome to FLoating Points Numbers programmed by Salvador Felipe.\n"
         "Mr. Felipe has been studying CS for the last two years.\n\n");
  double num = prompts();

  if(num == -1){
    std::cout << "The driver module received this float number " << std::fixed;
    std::cout << num << " and will keep it.\n";
  } else{
    printf("The driver module received this float number %.13lf and will keep it.\n", num);
  }
  std::cout << "The driver module will return integer 0 to the operating system.\n";
	std::cout << "Have a nice day. Good-bye.\n";
	return 0;
}
