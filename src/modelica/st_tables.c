#include <stdlib.h>
#include <errno.h>
//#include <omc/c/ModelicaUtilities.h>
#include <ModelicaUtilities.h>

#include "solinterp/symmetries.h"
#include "solinterp/interpolation.h"

#define ST_ISDLL
#include "st_tables.h"

void *st_table_init(size_t nr, size_t nc)
{
	Table *table = malloc(sizeof(Table));
	if (!table)
		ModelicaError("Table allocation\n");

	if (table_init(table, nr, nc)){
		table_free(table);
		free(table);
		ModelicaError("Table initialisation\n");
	}
	return table;
}

void *st_table_init_csv(const char *fn, const char *delim)
{
	Table *table = malloc(sizeof(Table)); // FIXME merge malloc into table_init.
	if(!table)
		ModelicaError("Table allocation\n"); // no return

	if(table_init_csv(table, fn, delim)) {
		switch (errno) {
		case ENOENT:
			table_free(table);
			free(table);
			ModelicaError("Table file not found\n"); // no return
			break;
		case ENOMEM:
			table_free(table);
			free(table);
			ModelicaError("Table allocation\n"); // no return
			break;
		default:
			table_free(table);
			free(table);
			ModelicaError("Table initialisation\n"); // no return
			break;
		}
	}

	if(table->nr == 0 || table->nc == 0){
		table_free(table);
		free(table);
		ModelicaError("Table contains no data\n"); // no return
	}

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

