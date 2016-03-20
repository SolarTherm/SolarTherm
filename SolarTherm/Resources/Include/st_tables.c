#ifndef ST_TABLE_C
#define ST_TABLE_C

#include <stdlib.h>
#include <errno.h>
//#include <omc/c/ModelicaUtilities.h>
#include <ModelicaUtilities.h>

#include "solinterp/tables.h"
#include "solinterp/symmetries.h"
#include "solinterp/interpolation.h"

#include "solinterp/symmetries.c"
#include "solinterp/tables.c"
#include "solinterp/interpolation.c"

void *st_table_init(size_t nr, size_t nc);
void *st_table_init_csv(const char *fn, const char *delim);
//void *st_table_init_sym(const char *fn, const char *delim, size_t n, size_t m,
//		const char *sym);
void st_table_free(void *table);

int st_table_grid_transform(void *table, size_t n, size_t m, const char *sym);
double st_table_catrom_interp(const void *table, double x, double y,
		double x_step, double y_step);

void *st_table_init(size_t nr, size_t nc)
{
	Table *table = malloc(sizeof(Table));
	if (!table)
		ModelicaError("Table allocation\n");

	if (table_init(table, nr, nc))
		ModelicaError("Table allocation\n");

	return table;
}

void *st_table_init_csv(const char *fn, const char *delim)
{
	Table *table = malloc(sizeof(Table));
	if (!table)
		ModelicaError("Table allocation\n");

	if (table_init_csv(table, fn, delim)) {
		switch (errno) {
		case ENOENT:
			ModelicaError("Table file not found\n");
			break;
		case ENOMEM:
			ModelicaError("Table allocation\n");
			break;
		default:
			ModelicaError("Table initialisation\n");
			break;
		}
	}

	if (table->nr == 0 || table->nc == 0)
		ModelicaError("Table contains no data\n");

	return table;
}

/* Load table from file and apply symmetries
 */
//void *st_table_init_sym(const char *fn, const char *delim, size_t n, size_t m,
//		const char *sym)
//{
//	Table *table = st_table_init_csv(fn, delim);
//
//	if (grid_transform(table, n, m, sym))
//		ModelicaError("Grided table allocation\n");
//
//	return table;
//}

void st_table_free(void *table)
{
	table_free(table);
}

int st_table_grid_transform(void *table, size_t n, size_t m, const char *sym)
{
	if (grid_transform(table, n, m, sym))
		ModelicaError("Grided table allocation\n");
	return 0;
}

double st_table_catrom_interp(const void *table, double x, double y,
		double x_step, double y_step)
{
	return catrom_interp(table, x, y, x_step, y_step);
}

#endif
