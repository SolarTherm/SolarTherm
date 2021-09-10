#! /bin/env python
from __future__ import division
import unittest
from solartherm import simulation, postproc
import os

class TestCatromOE(unittest.TestCase):
	def setUp(self):
		print("RUNNING SETUP")
		fn = 'TestCatromOE.mo'
		sim = simulation.Simulator(fn)
		print("COMPILING MODEL")
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step=300)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_opt_eff_interp(self):
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 0.1), 0)
		os.system('rm TestCatromOE_*')
		os.system('rm TestCatromOE')
		os.system('rm TestCatromOE.c')
		os.system('rm TestCatromOE.o')
		os.system('rm TestCatromOE.makefile')

if __name__ == '__main__':
	unittest.main()
