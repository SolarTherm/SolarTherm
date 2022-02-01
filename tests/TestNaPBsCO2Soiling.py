#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi
import os

class TestNaPBsCO2Soiling(unittest.TestCase):
	def setUp(self):
		fn = '../examples/ASTRI/NaSTsCO2_Soiling.mo'
		self.sim = simulation.Simulator(fn)
		self.sim.compile_model()
		self.sim.compile_sim(args=['-s'])


	def test_4trucks(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.

		self.sim.update_pars(['casefolder', 'num_trucks'], ['../SolarTherm/Data/Optics/sodium','4']) # load existing OELT reduce oelt resolution
		self.sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='homotopy')

		res = postproc.SimResultElec(self.sim.res_fn)
		perf = res.calc_perf()

		self.assertTrue(abs(perf[0]- 472629.65)/472629.65<0.01) # epy
		self.assertTrue(abs(perf[1]- 72.96)/72.96<0.01) # LCOE
		self.assertTrue(abs(perf[2]- 54.37)/54.37<0.01) # Capacity factor


	def test_8trucks(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.

		self.sim.update_pars(['casefolder', 'num_trucks'], ['../SolarTherm/Data/Optics/sodium','8']) # load existing OELT reduce oelt resolution
		self.sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='homotopy')

		res = postproc.SimResultElec(self.sim.res_fn)
		perf = res.calc_perf()

		print(perf)
		self.assertTrue(abs(perf[0]- 476828.71)/476828.71<0.01) # epy
		self.assertTrue(abs(perf[1]- 73.73)/73.73<0.01) # LCOE
		self.assertTrue(abs(perf[2]- 54.43)/54.43<0.01) # Capacity factor
		os.system('rm NaSTsCO2*')

    		

if __name__ == '__main__':
	unittest.main()
