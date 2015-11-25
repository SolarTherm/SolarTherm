#include "table.h"
#include <omc/c/ModelicaUtilities.h>
// ModelicaError in libOpenModelicaRuntimeC.so
// Doesn't return so not much point freeing stuff up

void *new_table(size_t np, size_t ni, size_t nd)
{
	Table *table = malloc(sizeof(Table));
	if (!table)
		ModelicaError("Cannot allocate table memory\n");

	table->np = np;
	table->ni = ni;
	table->nd = nd;

	table->p = malloc(np*sizeof(double *));
	if (!table->p)
		ModelicaError("Cannot allocate table memory\n");
	for (size_t i=0; i<table->np; i++) {
		table->p[i] = malloc((ni+nd)*sizeof(double));
		if (!table->p[i])
			ModelicaError("Cannot allocate table memory\n");
	}

	return table;
}

void delete_table(void *vtable)
{
	Table *table = (Table *)vtable;
	if (!table)
		return;

	for (size_t i=0; i<table->np; i++)
		free(table->p[i]);
	free(table->p);
	free(table);
}
