#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi
import os

class TestFileOE(unittest.TestCase):
	def setUp(self):
		fn = 'TestFileOE.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=10, step=0.1)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_opt_eff_interp(self):
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 0.1), 0)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 1.1), 10)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 2.1), 20)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 3.1), 30)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 4.1), 40)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 5.1), 0)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 6.1), 18)
		self.assertGreater(self.res.interpolate('oeff.eff[1]', 7.1), 8)
		self.assertLess(self.res.interpolate('oeff.eff[1]', 7.1), 10)
		self.assertGreater(self.res.interpolate('oeff.eff[1]', 8.1), 8)
		self.assertLess(self.res.interpolate('oeff.eff[1]', 8.1), 20)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[2]', 1.1), 15)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[2]', 2.1), 25)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[2]', 3.1), 35)
		self.assertAlmostEqual(self.res.interpolate('oeff.eff[2]', 4.1), 45)

		os.system('rm TestFileOE_*')
		os.system('rm TestFileOE')
		os.system('rm TestFileOE.c')
		os.system('rm TestFileOE.o')
		os.system('rm TestFileOE.makefile')

if __name__ == '__main__':
	unittest.main()
