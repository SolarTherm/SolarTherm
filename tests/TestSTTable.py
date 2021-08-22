#! /bin/env python

from __future__ import division
import unittest, os, glob

import cleantest

from solartherm import simulation
from solartherm import postproc

class TestSTTable(unittest.TestCase):
	def setUp(self):
		#self.cwd = os.chdir(os.path.dirname(__file__))
		fn = 'TestSTTable.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=4, step=0.01)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def tearDown(self):
		pass#os.chdir(self.cwd)
		
	def test_interp(self):
		self.assertEqual(self.res.interpolate('res', 0), 0)
		self.assertEqual(self.res.interpolate('val', 0), 3.)
		cleantest.clean('TestSTTable')

if __name__ == '__main__':
	unittest.main()
	
# vim: ts=4:sw=4:noet:tw=80
