#! /bin/env python2
# -*- coding: utf-8 -*-

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/NaSaltsCO2System.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='120s',solver='dassl')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		def getval(n):
			return self.res.interpolate(n,1)

		print "-----------------------------------------------------------------------"
		print 'Energy per year:                          %6.2f MW'%(self.perf[0])
		print 'LCOE:                                     %6.2f USD/MWh'%(self.perf[1])
		print 'Capacity factor:                          %6.2f %%'%(self.perf[2])
		print "-----------------------------------------------------------------------"
		print 'Receiver thermal input at design point:   %6.2f MW'%(getval('R_des')/1e6)
		print 'Receiver thermal output at design point:  %6.2f MW'%(getval('Q_rec_out')/1e6)
		print 'Power block gross rating at design point: %6.2f MW'%(getval('P_gross')/1e6)
		print 'Solar multiple:                           %4.1f   '%(getval('SM'))
		print 'Receiver diameter:                        %4.2f  m'%(getval('D_receiver'))
		print 'Receiver height:                          %4.2f  m'%(getval('H_receiver'))
		print 'Tower height:                             %4.1f  m'%(getval('H_tower'))
		print 'Number of heliostats:                     %4.1f  m'%(getval('n_heliostat'))

if __name__ == '__main__':
	unittest.main()
