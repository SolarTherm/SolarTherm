#include "tables.h"
#include <stdio.h>
#include <string.h>

int vector_init(Vector *vec){
	vec->len = 0;
	vec->cap = VECTOR_INIT_CAP;
	vec->v = malloc(VECTOR_INIT_CAP*sizeof(double));
	if (!vec->v)
		return -1;
	return 0;
}

void vector_free(Vector *vec){
	free(vec->v);
}

int vector_add(Vector *vec, double val){
	if (vec->len == vec->cap) {
		double *newv = realloc(vec->v, 2*vec->cap*sizeof(double));
		if (!newv)
			return -1;
		vec->v = newv;
		vec->cap *= 2;
	}
	vec->v[vec->len] = val;
	vec->len++;
	return 0;
}

void vector_set(Vector *vec, size_t i, double val){
	vec->v[i] = val;
}

double vector_get(const Vector *vec, size_t i){
	return vec->v[i];
}

int vectorv_init(VectorV *vec){
	vec->len = 0;
	vec->cap = VECTOR_INIT_CAP;
	vec->v = malloc(VECTOR_INIT_CAP*sizeof(Vector));
	if (!vec->v)
		return -1;
	return 0;
}

void vectorv_free(VectorV *vec){
	size_t i;
	for (i=0; i<vec->len; i++)
		vector_free(&(vec->v[i]));
	free(vec->v);
}

int vectorv_add(VectorV *vec, Vector *val){
	if (vec->len == vec->cap) {
		Vector *newv = realloc(vec->v, 2*vec->cap*sizeof(Vector));
		if (!newv)
			return -1;
		vec->v = newv;
		vec->cap *= 2;
	}
	vec->v[vec->len] = *val;
	vec->len++;
	return 0;
}

void vectorv_set(VectorV *vec, size_t i, Vector *val){
	vec->v[i] = *val;
}

Vector *vectorv_get(const VectorV *vec, size_t i){
	return &(vec->v[i]);
}

int table_init(Table *table, size_t nr, size_t nc){
	size_t i;
	table->nr = nr;
	table->nc = nc;

	table->v = calloc(nr,sizeof(double *));
	if (!table->v)
		return -1;

	for (i=0; i<nr; i++) {
		table->v[i] = malloc(nc*sizeof(double));
		if (!table->v[i])
			return -1;
	}

	return 0;
}

/* Load in table from file
 * Any line that starts with a # or is blank is ignored.
 * Only loads table if it is rectangular (all elements present).
 */
int table_init_csv(Table *table, const char *fn, const char *delim){
	const size_t BUFFLEN = 2048;
	char line[BUFFLEN];
	size_t i;
	size_t j;

	VectorV rows;
	if (vectorv_init(&rows))
		return -1;

	FILE *file;

 	file = fopen(fn, "r");
	if (!file)
		return -1;

	while (fgets(line, BUFFLEN, file)) {
		if (line[0] == '#') {
		} else if (strlen(line) <= 1) {
		} else {
			Vector row;
			if (vector_init(&row))
				return -1;
			char *tok = strtok(line, delim);
			while (tok) {
				double val = atof(tok);
				if (vector_add(&row, val))
					return -1;
				tok = strtok(NULL, delim);
			}
			if (vectorv_add(&rows, &row)) // rows takes ownership of memory
				return -1;
		}
	}

	fclose(file);

	size_t nr = rows.len;
	size_t nc = 0;
	int rect = 1; // whether or not table is rectangular

	if (nr > 0)
		nc = vectorv_get(&rows, 0)->len;
	for (i=0; i<nr; i++)
		rect = rect && (vectorv_get(&rows, i)->len == nc);

	if (rect) {
		table->nr = nr;
		table->nc = nc;
		table->v = calloc(nr,sizeof(double *));
		if (!table->v)
			return -1;
		for (i=0; i<nr; i++) {
			table->v[i] = malloc(nc*sizeof(double));
			if (!table->v[i])
				return -1;
			for (j=0; j<nc; j++)
				table->v[i][j] = vector_get(vectorv_get(&rows, i), j);
		}
	} else {
		table->nr = 0;
		table->nc = 0;
	}

	vectorv_free(&rows);

	return 0;
}

void table_print(const Table *table){
	size_t i;
	size_t j;
	for (i=0; i<table->nr; i++) {
		for (j=0; j<table->nc; j++) {
			printf("%.1f", table->v[i][j]);
			if (j < table->nc-1)
				printf(", ");
		}
		printf("\n");
	}
}

void table_free(Table *table){
	size_t i;
	/* if we are freeing a failed table_init, then there may be NULLs */
	if(!table || !table->v)
		return;
	for (i=0; i<table->nr; i++)
		if(NULL!=table->v[i])free(table->v[i]);
	free(table->v);
}

