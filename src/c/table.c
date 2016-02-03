#include "table.h"
#include <omc/c/ModelicaUtilities.h>
// ModelicaError in libOpenModelicaRuntimeC.so
// doesn't return so not much point freeing stuff up

void *new_table(size_t np, size_t ni, size_t nd)
{
	Table *table = malloc(sizeof(Table));
	if (!table)
		ModelicaError("Cannot allocate table memory\n");

	table->np = np;
	table->ni = ni;
	table->nd = nd;
	table->grided = 0;
	table->sep = NULL;

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

void free_table(void *vtable)
{
	Table *table = (Table *)vtable;
	if (!table)
		return;

	for (size_t i=0; i<table->np; i++)
		free(table->p[i]);
	free(table->p);
	free(table->sep);
	free(table);
}

// Convert indices for indenpendent variables into an index into table
// Returns zero if table is not grided
size_t table_index_2(const Table *table, size_t j0, size_t j1)
{
	size_t tind = 0;
	if (table->grided)
		tind = table->sep[0]*j0 + table->sep[1]*j1;
	return tind;
}

// Convert indices for indenpendent variables into an index into table
// Returns zero if table is not grided
size_t table_index(const Table *table, const size_t *ind)
{
	size_t tind = 0;
	if (table->grided)
		for (size_t j=0; j<table->ni; j++)
			tind += table->sep[j]*ind[j];
	return tind;
}

void check_grided(Table *table)
{
	// Clear current state
	table->grided = 0;
	free(table->sep);
	table->sep = NULL;
	// Table has no data or no independent indices
	if (table->np == 0 || table->ni == 0)
		return;

	// Table only has a single independent index
	if (table->ni == 1) {
		table->grided = 1;
		table->sep = malloc(sizeof(size_t));
		table->sep[0] = 1;
		return;
	}

	size_t *sep = malloc(table->ni*sizeof(size_t));
	// Work out separation assuming sorted so that lower index independent
	// variables are changing slower
	for (size_t j=0; j<table->ni; j++) {
		size_t i = 1;
		while (i < table->np && table->p[i][j] == table->p[i-1][j]) {
			i++;
		}
		sep[j] = i;
		if (j > 0) {
			// Check that our assumtion is true
			if (sep[j] > sep[j-1]) {
				free(sep);
				return;
			}
		}
	}

	for (size_t j=0; j<table->ni; j++) {
		size_t sep_p = j > 0 ? sep[j-1] : table->np;
		size_t nval = sep_p/sep[j]; // Number of unique values
		size_t nblk = table->np/sep_p; // How many separate blocks to check
		size_t nsep = sep[j]; // Number of consecutive values per block
		for (size_t v=0; v<nval; v++) {
			double val = table->p[nsep*v][j];
			for (size_t b=0; b<nblk; b++) {
				for (size_t s=0; s<nsep; s++) {
					if (val != table->p[nsep*v + sep_p*b + s][j]) {
						free(sep);
						return;
					}
				}
			}
		}
	}

	table->grided = 1;
	table->sep = sep;
}
