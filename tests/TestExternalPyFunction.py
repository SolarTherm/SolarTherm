#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
import os

class TestExternalC(unittest.TestCase):
	def setUp(self):
		fn = 'TestExternalPyFunc.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=4, step=0.01)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_squaring(self):
		self.assertTrue(abs(self.res.interpolate('y', 1)-1)/1<0.01)
		self.assertTrue(abs(self.res.interpolate('y', 2)-4)/4<0.01)
		os.system('rm TestExternalPyFunc_*')
		os.system('rm TestExternalPyFunc')
		os.system('rm TestExternalPyFunc.c')
		os.system('rm TestExternalPyFunc.o')
		os.system('rm TestExternalPyFunc.makefile')

if __name__ == '__main__':
	unittest.main()
