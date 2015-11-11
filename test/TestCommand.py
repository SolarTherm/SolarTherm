#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import os

class TestCommand(unittest.TestCase):
	def setUp(self):
		if os.path.isfile('TestCommandTouched'):
			os.remove('TestCommandTouched')

		fn = 'TestCommand.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=1, step=0.1)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_touching(self):
		self.assertEqual(self.res.get_interp('result', 0), 0)
		self.assertTrue(os.path.isfile('TestCommandTouched'))

if __name__ == '__main__':
	unittest.main()
