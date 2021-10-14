#ifndef STTABLES_H
#define STTABLES_H

#include <stddef.h>

#ifdef __linux__
# define ST_EXPORT
#elif defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__) || defined(_WIN64)
# ifdef ST_TABLES_DLL
#  define ST_EXPORT __declspec(dllexport)
# else
#  define ST_EXPORT __declspec(dllimport)
# endif
#endif

ST_EXPORT void *st_table_init(size_t nr, size_t nc);
ST_EXPORT void *st_table_init_csv(const char *fn, const char *delim);
//void *st_table_init_sym(const char *fn, const char *delim, size_t n, size_t m,
//		const char *sym);
ST_EXPORT void st_table_free(void *table);

ST_EXPORT int st_table_grid_transform(void *table, size_t n, size_t m, const char *sym);
ST_EXPORT double st_table_catrom_interp(const void *table, double x, double y,
		double x_step, double y_step);

#endif

