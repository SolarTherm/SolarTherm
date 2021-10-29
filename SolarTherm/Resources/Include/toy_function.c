#include <stdlib.h>
#include <stdio.h>

void toyfunction(double, double, double*);

void toyfunction(double hf, double hp, double* res)
{
	res[0] = hf / hp * 120 - 20 + 30;
	res[1] = 120 -20 +30;
}
