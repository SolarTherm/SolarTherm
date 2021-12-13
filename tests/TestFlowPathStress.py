#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import os

class TestFlowPathStress(unittest.TestCase):
	def setUp(self):
		fn = '../examples/FlowPathStress.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model(args=['-d=nonewInst'])
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1d', step='5m', solver='dassl', nls='homotopy')

	def test_simple_system(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.

		print('Simulation finished')
		os.system('cp FlowPathStress*.mat ../examples/')
		os.system('rm FlowPathStress*')


if __name__ == '__main__':
	unittest.main()

