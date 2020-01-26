#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

class TestSTTable(unittest.TestCase):
	def setUp(self):
		fn = 'TestSTTable.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=4, step=0.01)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_interp(self):
		self.assertEqual(self.res.interpolate('res', 0), 0)
		self.assertEqual(self.res.interpolate('val', 0), 3.)

if __name__ == '__main__':
	unittest.main()
