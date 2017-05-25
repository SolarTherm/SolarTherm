#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestSimpleSystem(unittest.TestCase):
	def setUp(self):
		fn = '../examples/SimpleSystem.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m',solver='dassl')
		self.res = postproc.SimResult(sim.res_fn)

		# TODO need to restore calc_perf functionality
		#self.perf = self.res.calc_perf()

	def test_simple_system(self):
		# TODO need to add specific tests here
		pass

if __name__ == '__main__':
	unittest.main()
