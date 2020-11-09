#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
from DyMat import DyMatFile as D

from math import pi

class TestLinprog(unittest.TestCase):
	def setUp(self):
		fn = './test_linprog.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m', solver='dassl', nls='homotopy')
		self.data = D('test_linprog_res_0.mat')

	def test_linprog(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		self.assertAlmostEqual(self.perf[0], 349.78, 2) # epy
		self.assertAlmostEqual(self.perf[1], 97.26, 2) # LCOE
		self.assertAlmostEqual(self.perf[2], 39.93, 2) # Capacity factor
		print(self.perf);

if __name__ == '__main__':
	unittest.main()
