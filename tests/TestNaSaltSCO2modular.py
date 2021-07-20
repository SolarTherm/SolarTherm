#! /bin/env python
# -*- coding: utf-8 -*-

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

import os

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/NaSaltSCO2System_modular.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='300s',solver='dassl', nls='homotopy')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		def getval(n):
			return self.res.interpolate(n,1)

#		self.assertAlmostEqual(self.perf[0], 569076.05, 2) # epy
#		self.assertAlmostEqual(self.perf[1], 75.17, 2) # LCOE
#		self.assertAlmostEqual(self.perf[2], 64.96, 2) # Capacity factor
#		self.assertAlmostEqual(getval('R_des')/1e6, 633.04, 2) # Receiver thermal input
#		self.assertAlmostEqual(getval('Q_rec_out')/1e6, 581.38, 2) # Receiver thermal output
#		self.assertAlmostEqual(getval('P_gross')/1e6, 111.0, 2) # Power block gross rating
#		self.assertAlmostEqual(getval('SM'), 2.67, 2) # Solar multiple
#		self.assertAlmostEqual(getval('H_tower'), 47.0, 2) # Tower height
#		self.assertAlmostEqual(getval('n_heliostat'), 2822.0, 2) # Number of heliostas
#		self.assertAlmostEqual(getval('n_modules'), 58.0, 2) # Number of modules
		print("-----------------------------------------------------------------------")
		print('Energy per year:                          %6.2f MWh'%(self.perf[0]))
		print('Capacity factor:                          %6.2f %%'%(self.perf[2]))
		print('LCOE:                                     $%6.2f/MWh'%(self.perf[1]))
		print("-----------------------------------------------------------------------")
		print('Receiver thermal input at design point:   %6.2f MW'%(getval('R_des')/1e6))
		print('Receiver thermal output at design point:  %6.2f MW'%(getval('Q_rec_out')/1e6))
		print('Power block gross rating at design point: %6.2f MW'%(getval('P_gross')/1e6))
		print('Solar multiple:                           %4.2f   '%(getval('SM')))
		print('Tower height (per module):                %4.1f  m'%(getval('H_tower')))
		print('Number of heliostats (per module):        %i'%(getval('n_heliostat')))
		print('Number of modules:                        %i'%(getval('n_modules')))
		os.system('rm NaSaltSCO2System_modular*')

if __name__ == '__main__':
	unittest.main()
