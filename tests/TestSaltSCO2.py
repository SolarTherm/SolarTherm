#! /bin/env python2
# -*- coding: utf-8 -*-

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/SaltSCO2System.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='300s',solver='dassl', nls='homotopy')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		def getval(n):
			return self.res.interpolate(n,1)

#		self.assertAlmostEqual(self.perf[0], 560675.35, 2) # epy
#		self.assertAlmostEqual(self.perf[1], 78.32, 2) # LCOE
#		self.assertAlmostEqual(self.perf[2], 64.00, 2) # Capacity factor
#		self.assertAlmostEqual(getval('R_des')/1e6, 741.98, 2) # Receiver thermal input
#		self.assertAlmostEqual(getval('Q_rec_out')/1e6, 587.65, 2) # Receiver thermal output
#		self.assertAlmostEqual(getval('P_gross')/1e6, 111.0, 2) # Power block gross rating
#		self.assertAlmostEqual(getval('SM'), 2.70, 2) # Solar multiple
#		self.assertAlmostEqual(getval('D_receiver'), 35.0, 2) # Receiver diameter
#		self.assertAlmostEqual(getval('H_receiver'), 20.0, 2) # Receiver height
#		self.assertAlmostEqual(getval('H_tower'), 175.0, 2) # Tower height
#		self.assertAlmostEqual(getval('n_heliostat'), 8134.0, 2) # Number of heliostas
		print "-----------------------------------------------------------------------"
		print 'Energy per year:                          %6.2f MWh'%(self.perf[0])
		print 'Capacity factor:                          %6.2f %%'%(self.perf[2])
		print 'LCOE:                                     $%6.2f/MWh'%(self.perf[1])
		print "-----------------------------------------------------------------------"
		print 'Receiver thermal input at design point:   %6.2f MW'%(getval('R_des')/1e6)
		print 'Receiver thermal output at design point:  %6.2f MW'%(getval('Q_rec_out')/1e6)
		print 'Power block gross rating at design point: %6.2f MW'%(getval('P_gross')/1e6)
		print 'Solar multiple:                           %4.2f   '%(getval('SM'))
		print 'Receiver diameter:                        %4.2f  m'%(getval('D_receiver'))
		print 'Receiver height:                          %4.2f  m'%(getval('H_receiver'))
		print 'Tower height:                             %4.1f  m'%(getval('H_tower'))
		print 'Number of heliostats:                     %i'%(getval('n_heliostat'))

if __name__ == '__main__':
	unittest.main()