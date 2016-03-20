#ifndef SOLI_TABLES_H
#define SOLI_TABLES_H

#include <stdlib.h>

#define VECTOR_INIT_CAP 10

typedef struct {
	size_t len; // current length
	size_t cap; // allocated length
	double *v; // values
} Vector;

typedef struct {
	size_t len; // current length
	size_t cap; // allocated length
	Vector *v; // values
} VectorV;

typedef struct {
	size_t nr; // number of rows
	size_t nc; // number of columns
	double **v; // row array pointer
} Table;

int vector_init(Vector *vec);
void vector_free(Vector *vec);
int vector_add(Vector *vec, double val);
void vector_set(Vector *vec, size_t i, double val);
double vector_get(const Vector *vec, size_t i);

int vectorv_init(VectorV *vec);
void vectorv_free(VectorV *vec);
int vectorv_add(VectorV *vec, Vector *val);
void vectorv_set(VectorV *vec, size_t i, Vector *val);
Vector *vectorv_get(const VectorV *vec, size_t i);

int table_init(Table *table, size_t nr, size_t nc);
int table_init_csv(Table *table, const char *fn, const char *delim);
void table_print(const Table *table);
void table_free(Table *table);

#endif
