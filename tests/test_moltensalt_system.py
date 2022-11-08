#! /bin/env python
# -*- coding: utf-8 -*-

from __future__ import division
import unittest, warnings

import cleantest
from solartherm import simulation
from solartherm import postproc

from math import pi

import os
import pytest
#@pytest.mark.skip(reason="Need to be resolved")

class TestMoltenSaltSys(unittest.TestCase):
	def setUp(self):
		fn = '../examples/GemasolarSystem.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='120s',solver='dassl',nls='homotopy')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def testsystem(self):
		def getval(n):
			v=self.res.interpolate(n,1)
			v=float(v)
			return v

		if 1:
			self.assertAlmostEqual(self.perf[0], 107960.97, 2) # epy
			self.assertAlmostEqual(self.perf[1], 173.89, 2) # LCOE
			self.assertAlmostEqual(self.perf[2], 68.739, 2) # Capacity factor
			self.assertAlmostEqual(getval('R_des')/1e6, 180.24, 2) # Receiver thermal input
			self.assertAlmostEqual(getval('Q_rec_out')/1e6, 166.03, 2) # Receiver thermal output
			self.assertAlmostEqual(getval('P_gross')/1e6, 19.9, 2) # Power block gross rating
			self.assertAlmostEqual(getval('SM'), 3.15, 2) # Solar multiple
			self.assertAlmostEqual(getval('D_receiver'), 8.5, 2) # Receiver diameter
			self.assertAlmostEqual(getval('H_receiver'), 10.5, 2) # Receiver height
			self.assertAlmostEqual(getval('H_tower'), 114.75, 2) # Tower height
			self.assertAlmostEqual(getval('n_heliostat'), 2650, 1) # Number of heliostats
		else:
			warnings.warn("Test evaluation has been disabled")		
		
		print("-----------------------------------------------------------------------")
		print('Energy per year:                          %6.2f MWh'%(self.perf[0]))
		print('Capacity factor:                          %6.2f %%'%(self.perf[2]))
		print('LCOE:                                     $%6.2f/MWh'%(self.perf[1]))
		print("-----------------------------------------------------------------------")
		print('Receiver thermal input at design point:   %6.2f MW'%(getval('R_des')/1e6))
		print('Receiver thermal output at design point:  %6.2f MW'%(getval('Q_rec_out')/1e6))
		print('Power block gross rating at design point: %6.2f MW'%(getval('P_gross')/1e6))
		print('Solar multiple:                           %4.2f   '%(getval('SM')))
		print('Receiver diameter:                        %4.2f  m'%(getval('D_receiver')))
		print('Receiver height:                          %4.2f  m'%(getval('H_receiver')))
		print('Tower height:                             %4.1f  m'%(getval('H_tower')))
		print('Number of heliostats:                     %i'%(getval('n_heliostat')))

		cleantest.clean('GemasolarSystem')

if __name__ == '__main__':
	unittest.main()
