#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
import os

class TestExternalC(unittest.TestCase):
	def setUp(self):
		fn = 'TestExternalPyStr.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=4, step=1)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_squaring(self):
		self.assertEqual(self.res.interpolate('y', 1), 15)
		self.assertEqual(self.res.interpolate('y', 2), 15)
		os.system('rm TestExternalPyStr_*')
		os.system('rm TestExternalPyStr')
		os.system('rm TestExternalPyStr.c')
		os.system('rm TestExternalPyStr.o')
		os.system('rm TestExternalPyStr.makefile')

if __name__ == '__main__':
	unittest.main()
