// Author : Salvador Felipe
// Author email : sfel @csu.fullerton.edu
// Date : October 12, 2022
// Section ID: MW 12 - 2 pm
//===== Begin code area ===========================================================================================================

#include <iostream>

extern "C" void show_data(double arr[], int arr_size);

//Prints the contents of the array, up to arr_size, determined by the fill asm module
void show_data(double arr[], int arr_size) {
  for (int i = 0; i < arr_size; i++)
  {
    printf("%.8lf\n", arr[i]);
  }
  std::cout << std::endl;
}
