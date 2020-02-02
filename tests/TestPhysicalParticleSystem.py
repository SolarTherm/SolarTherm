#! /bin/env python2
# -*- coding: utf-8 -*-

from __future__ import division
import unittest
import os

from solartherm import simulation
from solartherm import postproc

from math import pi

RUNSIM=1
VERBOSE=0

class TestPhysicalParticleSystem(unittest.TestCase):
	def test_sched(self):
		fn = '../examples/PhysicalParticleSystem.mo'
		sim = simulation.Simulator(fn)
		resfn = sim.model + '_res.mat'
		global RUNSIM, VERBOSE
		if RUNSIM=='if-needed':
			RUNSIM = os.path.getctime(resfn) < os.path.getctime(fn)
			print "RUNSIM = %s ('if-needed' test)"%(RUNSIM,)
		if RUNSIM:
			sim.compile_model()
			sim.compile_sim(args=['-s'])
			sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')
			assert(resfn == sim.res_fn)
		self.res = postproc.SimResultElec(resfn)
		self.perf = self.res.calc_perf()

		def gettmax(n):
			return self.res.get_time(n)[-1]

		def getval(n,u=False):
			v = self.res.interpolate(n,gettmax(n))
			if u:
				u1 = self.res.get_unit(n)
				return v,u1
			return v

		def getperf(n):
			i = self.res.perf_n.index(n)
			return self.perf[i], self.res.perf_u[i]

		if VERBOSE:
			print "\nRESULTS\n-------"
			print "\nDesign parameters"
			for n in ['Q_rec_des','Q_blk_des','P_gross','P_net','P_name']:
				print '%s = %f MW' % (n,getval(n)/1e6)
			for n in ['H_tower','SM','t_storage','A_field']:
				v,u = getval(n,u=True)
				print '%s = %f %s'%(n,v,u)
			print 'ΔT_storage = %f °C' % (getval('T_hot_des')-getval('T_cold_des'))

			print "\nFinancial parameters"
			for n in ['pri_field','pri_site','pri_hx','pri_block'
					,'pri_receiver','pri_om_name','t_life','t_cons','r_contg','r_indirect'
					,'r_cons','r_disc']:
				#print '%s = %f M USD'%(v,getval(v)/1e6)
				v,u = getval(n,u=True)
				print '%s = %f %s'%(n,v,u)
			n = 'pri_storage'; print '%s = %f %s'%(n,getval(n)*3.6e6,"USD/kJ")

			print "\nCapital costs"
			for n in ['C_hx','C_receiver','C_storage','C_field_total','C_pb','C_cap_total','C_cap']:
				print '%s = %f M USD'%(n,getval(n)/1e6)
				#v,u = getval(n,u=True)

			print "\nHigh-level metrics"
			for n in ['lcoe','epy','capf']:
				v,u = getperf(n)
				print '%s = %f %s'%(n,v,u)

		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		self.assertAlmostEqual(getval('A_field'),1.473e6,delta=2e3);
		self.assertEqual(getval('SM'),2.5);
		self.assertEqual(getval('eff_blk'),0.5023);
		self.assertAlmostEqual(getval('P_name'),100e6,delta=0.1e6);
		self.assertAlmostEqual(getval('Q_blk_des'),199.076e6,delta=1e6);
		self.assertAlmostEqual(getval('Q_rec_des'),497.69e6,delta=1e6);
		self.assertAlmostEqual(getval('T_hot_des')-getval('T_cold_des'),219.7,delta=0.01) # K
		self.assertEqual(getval('t_storage'),14) # h
		self.assertEqual(getval('pri_field'), 75) # USD/m²
		self.assertEqual(getval('pri_site'),10) # USD/m²
		self.assertEqual(getval('pri_hx'),0.175) # USD/W
		self.assertAlmostEqual(getval('pri_storage')*3.6e6,17.9,delta=0.05);
		self.assertEqual(getval('r_cons'),0.06);
		self.assertEqual(getval('r_indirect'),0.13);
		self.assertEqual(getval('r_contg'),0.1);
		self.assertEqual(getval('r_disc'),0.07);
		self.assertAlmostEqual(getval('C_cap_total'),317.2e6,delta=1e6);

		#self.assertAlmostEqual(self.perf[0], 430309.98, 2) # epy
		self.assertAlmostEqual(getperf('lcoe')[0], 59.19, delta=2) # USD/MWh
		#self.assertAlmostEqual(self.perf[2], 49.12, 2) # Capacity factor
		#print(self.perf);

if __name__ == '__main__':
	#RUNSIM='if-needed'
	RUNSIM=1
	VERBOSE=1
	unittest.main()
