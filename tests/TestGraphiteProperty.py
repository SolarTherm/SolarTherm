#! /bin/env python

import unittest
import os

from solartherm import simulation
from solartherm import postproc

class TestWeatherTable(unittest.TestCase):
	def setUp(self):
		fn = 'TestGraphiteProperty.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=3, step=0.01)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_table(self):

		self.assertEqual(self.res.interpolate('T_p', 0).round(), 575)
		self.assertEqual(self.res.interpolate('k_p', 0).round(), 106)
		self.assertEqual(self.res.interpolate('rho_p', 0).round(), 1880)
		os.system('rm TestGraphiteProperty_*')
		os.system('rm TestGraphiteProperty')
		os.system('rm TestGraphiteProperty.c')
		os.system('rm TestGraphiteProperty.o')
		os.system('rm TestGraphiteProperty.makefile')

if __name__ == '__main__':
	unittest.main()
