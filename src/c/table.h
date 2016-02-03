#ifndef TABLE_H
#define TABLE_H

#include <stdlib.h>

typedef struct {
	// independent variables should be increasing with priority to lower index
	double **p; // list of points
	size_t np; // number of points
	size_t ni; // number of independent values
	size_t nd; // number of dependent values
	int grided; // table is grided
	size_t *sep; // if grided then separation of independent varaibles in table
	size_t i; // last used point
} Table;

void *new_table(size_t np, size_t ni, size_t nd);
void free_table(void *vtable);
size_t table_index(const Table *table, const size_t *ind);
size_t table_index_2(const Table *table, size_t j0, size_t j1);
void check_grided(Table *table);

#endif
