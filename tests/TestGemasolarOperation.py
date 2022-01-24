#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import numpy as np
import scipy.io as sio
import DyMat
import os

class TestFlowPathStress(unittest.TestCase):
	def setUp(self):
		fn = '../examples/GemasolarSystemOperation.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model(args=['-d=nonewInst'])
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='25h', step='5m', solver='dassl', nls='homotopy')

	def test_simple_system(self):
		print('Simulation finished')
		print('Starting post-processing')
		os.system('cp GemasolarSystemOperation*.mat ../examples/')
		os.system('rm GemasolarSystemOperation*')


if __name__ == '__main__':
	unittest.main()

