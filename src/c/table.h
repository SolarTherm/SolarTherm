#ifndef TESTEXTERNALC_H
#define TESTEXTERNALC_H

#include <stdlib.h>

typedef struct {
	// independent variables should be increasing with priority to lower index
	double **p; // list of points
	size_t np; // number of points
	size_t ni; // number of independent values
	size_t nd; // number of dependent values
	size_t i; // last used point
} Table;

void *new_table(size_t np, size_t ni, size_t nd);
void delete_table(void *vtable);

#endif
