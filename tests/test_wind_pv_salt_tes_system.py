#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
import DyMat

from math import pi
import os

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/WindPVsaltTESsystem.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m', solver='dassl', nls='homotopy', tolerance = '1e-06')
		self.mat = DyMat.DyMatFile(sim.res_fn)

	def test_sched(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		ref_annual_ouput = 388837.4366036075 # Reference annnual thermal output
		annual_output=self.mat.data('E_thermal')[-1]
		annual_output = annual_output/(1e6*3600) # Convert from J/year to MWh/year
		# Testing output
		self.assertTrue(abs(annual_output- ref_annual_ouput)/ref_annual_ouput<0.01)
		# Deleting simulation files
		os.system('rm WindPVsaltTESsystem*')

if __name__ == '__main__':
	unittest.main()
