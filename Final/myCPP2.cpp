//Wyatt Whiting - CS271 - Fall 2020 Oregon State University
#include <iostream>

using namespace std;

extern "C" void testTest(char * s);

int main()
{
	char myString[] = "Hello, world! Wyatt Whiting F2020 CS271 OSU";
	testTest(myString);

	return 0;
}