#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestSodiumMedium(unittest.TestCase):
	def setUp(self):
		fn = 'TestSodiumMedium.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=2, step=0.1)
		self.res = postproc.SimResult(sim.model + '_res.mat')
	
	def test_sodium_props(self):
		delta = 2 # error tolerated (percentage)
		
		self.assertLessEqual(self.res.interpolate('err_avg_cp_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_cv_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_gamma_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_eta_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_eta_v_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_h_rho_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_h_fg_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_h_s_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_h_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_lamda_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_lamda_v_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_p_rho_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_p_v_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_rho_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_rho_v_T_test', 1), delta)
		self.assertLessEqual(self.res.interpolate('err_avg_s_rho_test', 1), delta)
    	self.assertLessEqual(self.res.interpolate('err_avg_s_T_test', 1), delta)
    	self.assertLessEqual(self.res.interpolate('err_avg_T_h_test', 1), delta)
    	self.assertLessEqual(self.res.interpolate('err_avg_T_p_test', 1), delta)
    	self.assertLessEqual(self.res.interpolate('err_avg_T_s_test', 1), delta)
    	self.assertLessEqual(self.res.interpolate('err_avg_vs_T_test', 1), delta)
    		
if __name__ == '__main__':
	unittest.main()

























