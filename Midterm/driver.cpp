// Author : Salvador Felipe
// Author email : sfel @csu.fullerton.edu
// Date : October 12, 2022
// Section ID: MW 12 - 2 pm
//===== Begin code area ===========================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

    extern "C" const char *Manager();

int main(int argc, char *argv[])
{
  printf("Welcome to Max authored by Salvador Felipe.\n");

  const char* name = Manager();

  printf("\nThank you for using this software %s\n", name);
  printf("Bye.\nA zero was returned to the operating system.\n");
  return 0;
}
