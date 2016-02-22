#ifndef ST_TABLE_H
#define ST_TABLE_H

#include <stdlib.h>

void *st_table_init(size_t nr, size_t nc);
void *st_table_init_csv(const char *fn, const char *delim);
//void *st_table_init_sym(const char *fn, const char *delim, size_t n, size_t m,
//		const char *sym);
void st_table_free(void *table);

int st_table_grid_transform(void *table, size_t n, size_t m, const char *sym);
double st_table_catrom_interp(const void *table, double x, double y,
		double x_step, double y_step);

#endif
