#! /bin/env python

from __future__ import division
import unittest
import os

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestMoltenSaltMedium(unittest.TestCase):
	def setUp(self):
		fn = 'TestMoltenSaltMedium.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=2, step=0.1)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_moltenSalt_props(self):
		delta = 1 # error tolerated (percentage)

		self.assertLessEqual(self.res.interpolate('err_avg_cp_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_eta_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_h_rho_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_h_fg_p_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_h_s_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_h_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_lamda_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_p_rho_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_p_sat_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_rho_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_s_rho_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_s_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_T_h_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_T_sat_p_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_T_s_test', 1), delta)

		os.system('rm TestMoltenSaltMedium_*')
		os.system('rm TestMoltenSaltMedium')
		os.system('rm TestMoltenSaltMedium.c')
		os.system('rm TestMoltenSaltMedium.o')
		os.system('rm TestMoltenSaltMedium.makefile')

if __name__ == '__main__':
	unittest.main()
