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
		#sim.update_pars(['P_gross', 'D_receiver', 'H_receiver', 'SM' ],['111e6', '19', '20', '2.4']) 
		sim.simulate(start=0, stop='1y', step='120s',solver='dassl',nls='homotopy')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def testsystem(self):
		def getval(n):
			v=self.res.interpolate(n,1)
			v=float(v)
			return v

		if 1:
			assert abs(self.perf[0]-591111.07)/591111.07 <0.05
			assert abs(self.perf[1]-147.71)/147.71 <0.05
			assert abs(self.perf[2]-65.13)/65.13 <0.05
			assert abs(getval('R_des')/1e6-727.84)/727.84 <0.05
			assert abs(getval('Q_rec_out')/1e6- 669.90)/ 669.90 <0.05
			assert abs(getval('n_heliostat')-12662)/12662 <0.05

			self.assertAlmostEqual(getval('P_gross')/1e6, 115, 2) # Power block gross rating
			self.assertAlmostEqual(getval('SM'), 2.4, 2) # Solar multiple
			self.assertAlmostEqual(getval('D_receiver'), 17.65, 2) # Receiver diameter
			self.assertAlmostEqual(getval('H_receiver'), 21.6, 2) # Receiver height
			self.assertAlmostEqual(getval('H_tower'), 193.458, 2) # Tower height

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
