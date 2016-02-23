#! /bin/env python2

import unittest

from solartherm import simulation
from solartherm import postproc

class TestWeatherTable(unittest.TestCase):
	def setUp(self):
		fn = 'TestWeatherTable.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=3, step=0.01)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_table(self):
		self.assertAlmostEqual(self.res.get_interp('linear.y[1]', 0.5), 2.5)
		self.assertAlmostEqual(self.res.get_interp('linear.y[1]', 0.5), 2.5)
		self.assertAlmostEqual(self.res.get_interp('linear.y[1]', 1.5), 2)
		self.assertAlmostEqual(self.res.get_interp('linear.y[1]', 2.5), 2.5)
		self.assertAlmostEqual(self.res.get_interp('cderiv.y[1]', 0), 3)
		self.assertAlmostEqual(self.res.get_interp('cderiv.y[1]', 1), 2)
		self.assertAlmostEqual(self.res.get_interp('cderiv.y[1]', 2), 2)
		self.assertAlmostEqual(self.res.get_interp('cderiv.y[1]', 3), 3)
		self.assertAlmostEqual(self.res.get_interp('cseg.y[1]', 0.5), 3)
		self.assertAlmostEqual(self.res.get_interp('cseg.y[1]', 1.5), 2)
		self.assertAlmostEqual(self.res.get_interp('cseg.y[1]', 2.5), 2)

if __name__ == '__main__':
	unittest.main()
