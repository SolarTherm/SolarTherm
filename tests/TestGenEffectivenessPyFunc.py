#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
import os
import DyMat

class TestSolsticePyFunc(unittest.TestCase):
	def setUp(self):
		fn = 'TestGenEffectivenessPyFunc.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=100, step=0.1)
		self.res =DyMat.DyMatFile(sim.model + '_res.mat')


	def test_touching(self):

		self.assertTrue(abs(self.res.data("eff_chg")[0]- 0.9153633)/0.9153633<0.01) 
		self.assertTrue(abs(self.res.data("eff_dischg")[0]-0.91367516)/0.91367516<0.01) 

		os.system('rm TestGenEffectivenessPyFunc_*')
		os.system('rm TestGenEffectivenessPyFunc')
		os.system('rm TestGenEffectivenessPyFunc.c')
		os.system('rm TestGenEffectivenessPyFunc.o')
		os.system('rm TestGenEffectivenessPyFunc.makefile')


if __name__ == '__main__':
	unittest.main()

