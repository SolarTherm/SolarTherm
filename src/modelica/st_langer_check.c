#include <stdio.h>
#include <gsl/gsl_linalg.h>

void langer_check (double azi, double ele, const double points[][3], const int simplices[][3], int ntriangles, int* triangle){
	gsl_vector *b = gsl_vector_alloc (3);
	gsl_vector_set(b, 0, cos(azi)*cos(ele));
	gsl_vector_set(b, 1, sin(azi)*cos(ele));
	gsl_vector_set(b, 2, sin(ele));
	int s,i,j, coord, vertice;
	double res;
	for (i = 0; i < ntriangles; i++){
		gsl_matrix *m = gsl_matrix_alloc(3,3);
		for (coord = 0; coord < 3; coord++){
			for (vertice = 0; vertice < 3; vertice++){
				gsl_matrix_set(m, coord, vertice, points[simplices[i][vertice]][coord]);
			}
		}
		gsl_vector *x = gsl_vector_alloc (3);
		gsl_permutation * p = gsl_permutation_alloc (3);
		gsl_linalg_LU_decomp (m, p, &s);
		gsl_linalg_LU_solve (m, p, b, x);
		gsl_permutation_free (p);
		res = gsl_vector_min(x);
		if (res > 0 || fabs(res) < 1e-6){
			// printf("Minimum wi for triangle %d is %g\n",i,res);
			// printf("Position at vertices: [%d, %d, %d]\n",simplices[i][0],simplices[i][1],simplices[i][2]);
			for (j = 0; j < 3; j++)
			{
				triangle[j] = simplices[i][j];
			}
		}
		gsl_vector_free(x);
		gsl_matrix_free(m);
	}
	gsl_vector_free(b);

  return;
}
