#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
import os

class TestSolsticePyFunc(unittest.TestCase):
	def setUp(self):
		fn = 'TestSolsticeOELT.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=10, step=0.1)
		self.res = postproc.SimResult(sim.model + '_res.mat')


	def test_touching(self):
		
		self.assertEqual(round(self.res.interpolate('opt_eff', 0),4), 0.7388)


if __name__ == '__main__':
	unittest.main()

