//****************************************************************************************************************************
//Program name: "Right Triangles". This program takes in the lengths of 2 sides of a right triangle and calculates the area  *
//and length of the hypotenuse. Copyright (C) 2022 Salvador Felipe.                                                          *
//                                                                                                                           *
//This file is part of the software program "Right Triangles".                                                               *
//Right Triangles is free software: you can redistribute it and/or modify it under the terms of the GNU General Public       *
//License version 3 as published by the Free Software Foundation.                                                            *
//Right Triangles is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the              *
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
//  Programming languages: One module in X86, one modules in C, and two bash files
//  Date program began: 2022 Sep 6
//  Date of last update: 2022 Sep 17
//  Date of reorganization of comments: 2022 Sep 4
//  Files in this program: pythagoras.c, triangle.asm, run.sh, gun.sh
//  Status: Finished.  The program was tested extensively with no errors in Linux 2020 Edition.
//
//Purpose
//  This file contains the functions that will display the floating point numbers in the prompts.asm assembly file.
//
//This file
//   File name: pythagoras.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc - c - Wall - no - pie - m64 - std = c++ 17 - o pythagoras.o pythagoras.cpp
//   Link: gcc -m64 -no-pie -o assign2.out triangle.o pythagoras.o -std=c17
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern double triangle();

int main(int argc, char *argv[])
{
  printf("Welcome to the Right Triangles program maintained by Salvador Felipe.\n\n"
         "If errors are discovered please report them to Salvador Felipe at sfel@csu.fullerton.edu for a quick fix. "
         "At Columbia Software the customer comes first.\n\n");

  double num = triangle();

  printf("\nThe main function received this number %.4lf and plans to keep it.\n\n", num);
  printf("An integer zero will be returned to the operating system.  Bye.\n");
	return 0;
}
