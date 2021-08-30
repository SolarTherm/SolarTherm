#include "interpolation.h"
#include <stdio.h>
#include <math.h>

/* Cubic Catmull-Rom spline interpolation.
 * p are values of 4 control points
 * u is fractional position between middle two control points for point of interest
 */
double catrom_spline(double p[4], double u)
{
	double q;
	q = (-u*u*u + 2*u*u - u)*p[0];
	q += (3*u*u*u - 5*u*u + 2)*p[1];
	q += (-3*u*u*u + 4*u*u + u)*p[2];
	q += (u*u*u - u*u)*p[3];
	return q/2;
}

/* Bicubic Catmull-Rom spline interpolation.
 * pnts are 16 control points surrounding point to interpolate
 * u and v are fractional position between central 4 control points for point of interest
 */
double catrom_spline_2d(double pnts[4][4], double u, double v)
{
	double p[4];
	p[0] = catrom_spline(pnts[0], v);
	p[1] = catrom_spline(pnts[1], v);
	p[2] = catrom_spline(pnts[2], v);
	p[3] = catrom_spline(pnts[3], v);
	//printf("%f, %f, %f, %f\n", p[0], p[1], p[2], p[3]);
	return catrom_spline(p, u);
}

/* Bicubic Catmull-Rom spline interpolation.
 * Assume that data in table is cyclic.
 * x value along table row direction
 * y value along table col direction
 */
double catrom_interp(const Table *table, double x, double y, double x_step, double y_step)
{
	size_t i;
	size_t j;
	size_t ii;
	size_t jj;
	size_t nx = table->nr - 1; // don't count grid position row
	size_t ny = table->nc - 1; // don't count grid position col
	double xoff = table->v[1][0];
	double yoff = table->v[0][1];
	double u = (x - xoff)/x_step;
	double v = (y - yoff)/y_step;
	size_t i_l = (size_t) floor(u) % nx;
	size_t j_l = (size_t) floor(v) % ny;
	u -= floor(u);
	v -= floor(v);
	//printf("%f, %f\n", u, v);
	double pnts[4][4];

	for (ii=0; ii<4; ii++) {
		for (jj=0; jj<4; jj++) {
			i = (nx + ii - 1 + i_l) % nx;
			j = (ny + jj - 1 + j_l) % ny;
			pnts[ii][jj] = table->v[i+1][j+1];
			//printf("%lu, %lu: %lu, %lu, %f\n", ii, jj, i, j, pnts[ii][jj]);
		}
	}
	
	return catrom_spline_2d(pnts, u, v);
}
