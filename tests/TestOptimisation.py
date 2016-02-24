#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

class TestExternalC(unittest.TestCase):
	def setUp(self):
		fn = 'TestOptimisation.mo'
		model = 'AO'
		sim = simulation.Simulator(fn, model=model)
		# For some reason won't compile with Modelica library
		sim.compile_model(libs=[], args=['-g=Optimica'])
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=1, step=0.02, solver='optimization')
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_optimum(self):
		self.assertAlmostEqual(self.res.interpolate('x1', 0), 1.0, 5)
		self.assertAlmostEqual(self.res.interpolate('x2', 0), 0.0, 5)
		self.assertAlmostEqual(self.res.interpolate('u', 1), 5.0, 5)
		#from solartherm import plotting
		#plotting.plot_res(self.res, ['u'])

if __name__ == '__main__':
	unittest.main()
