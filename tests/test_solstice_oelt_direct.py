#! /bin/env python

from __future__ import division
import unittest

import os

class TestSolsticePyFunc(unittest.TestCase):
	def setUp(self):
		fn = '../src/modelica/run_solstice_windy.py'
		
		self.casedir = './test-solstice-direct'
		wea_file = '../SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab'
		field_type = 'multi-aperture'
		rcv_type = 'multi-aperture-parallel'
		sunshape = 'buie'
		method = 1
		csr = 0.028
		num_aperture = 3
		gamma = 360.0
		Q_in_rcv = 6050000
		H_rcv_1 = 6.
		W_rcv_1 = 6.
		H_rcv_2 = 6.
		W_rcv_2 = 6.
		H_rcv_3 = 6.
		W_rcv_3 = 6.
		n_H_rcv = 10.0
		n_W_rcv = 10.0
		tilt_rcv = 0.0
		W_helio = 1.2
		H_helio = 1.6
		H_tower = 70.
		R_tower = 5.0
		R1 = 24.5
		fb = 0.909
		helio_refl = 0.9
		slope_error = 0.001
		slope_error_windy = 0.0014
		windy_optics = 1.0
		n_rays = 5e6
		n_procs = 1.0
		verbose = 1.0
		gen_vtk = 0.0
		n_row_oelt = 3
		n_col_oelt = 6
		num_args=30
		
		var_names="method,csr,num_aperture,gamma,Q_in_rcv,H_rcv_1,H_rcv_2,H_rcv_3,W_rcv_1,W_rcv_2,W_rcv_3,n_H_rcv,n_W_rcv,tilt_rcv,W_helio,H_helio,H_tower,R_tower,R1,fb,helio_refl,slope_error,slope_error_windy,windy_optics,n_rays,n_procs,verbose,gen_vtk,n_row_oelt,n_col_oelt,"
		var_values="%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,"%(method,csr,num_aperture,gamma,Q_in_rcv,H_rcv_1,H_rcv_2,H_rcv_3,W_rcv_1,W_rcv_2,W_rcv_3,n_H_rcv,n_W_rcv,tilt_rcv,W_helio,H_helio,H_tower,R_tower,R1,fb,helio_refl,slope_error,slope_error_windy,windy_optics,n_rays,n_procs,verbose,gen_vtk,n_row_oelt,n_col_oelt,)
		
		os.system('python3 %s --casedir %s --wea_file %s --field_type %s --rcv_type %s --sunshape %s --num_args %s --var_names %s --var_vals %s'%(fn, self.casedir, wea_file, field_type, rcv_type, sunshape, num_args, var_names, var_values))


	def test_touching(self):
		
		check=os.path.exists(self.casedir+'/OELT_Solstice.motab')
		self.assertTrue(check)
		


if __name__ == '__main__':
	unittest.main()

