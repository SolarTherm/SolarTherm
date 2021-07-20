#! /bin/env python

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

		self.assertTrue(abs(self.res.interpolate('opt_eff', 0)-0.8785)/0.8785<0.01)
		os.system('rm TestSolsticeOELT_*')
		os.system('rm TestSolsticeOELT')
		os.system('rm TestSolsticeOELT.c')
		os.system('rm TestSolsticeOELT.o')
		os.system('rm TestSolsticeOELT.makefile')
		os.system('rm -rf Test_SolsticeOELT')


if __name__ == '__main__':
	unittest.main()

