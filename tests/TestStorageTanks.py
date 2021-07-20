#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestStorage(unittest.TestCase):
	def setUp(self):
		fn = 'TestStorageTanks.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		print(self.perf)
		self.assertTrue(abs(self.perf[0]- 393933.791)/393933.791<0.01) # epy
		self.assertTrue(abs(self.perf[1]- 160.352)/160.352<0.01) # LCOE
		self.assertTrue(abs(self.perf[2]- 44.969)/44.969<0.01) # Capacity factor
		os.system('rm TestStorageTanks_*')
		os.system('rm TestStorageTanks')
		os.system('rm TestStorageTanks.c')
		os.system('rm TestStorageTanks.o')
		os.system('rm TestStorageTanks.makefile')



if __name__ == '__main__':
	unittest.main()
