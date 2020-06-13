#! /bin/env python2

import unittest

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
		self.assertEqual(round(self.res.interpolate('T_p', 0),0), 575)
		self.assertEqual(round(self.res.interpolate('k_p', 0),0), 106)
		self.assertEqual(round(self.res.interpolate('rho_p', 0),0), 1880)

if __name__ == '__main__':
	unittest.main()
