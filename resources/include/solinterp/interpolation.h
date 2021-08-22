#ifndef SOLI_INTERPOLATION_H
#define SOLI_INTERPOLATION_H

#include "tables.h"

double catrom_interp(const Table *table, double x, double y, double x_step, double y_step);

#endif
