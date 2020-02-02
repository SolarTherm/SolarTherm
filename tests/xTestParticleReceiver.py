#! /bin/env python2
from __future__ import division
import unittest
from solartherm import simulation, postproc

class TestParticleReceiver(unittest.TestCase):
	def test1(self):
		print "RUNNING SETUP"
		fn = 'TestParticleReceiver.mo'
		sim = simulation.Simulator(fn)
		print "COMPILING MODEL"
		sim.compile_model()
		sim.compile_sim(args=['-s','-d=infoXmlOperations'])
#		sim.simulate(start=0, stop='1y', step=300,lv='-LOG_SUCCESS,-stdout,LOG_NLS_V,LOG_SOLVER,LOG_INIT,LOG_RES_INIT,LOG_SIMULATION,LOG_SOTI,LOG_DEBUG')
		sim.simulate(start=0, stop='1y', step=300,lv='-LOG_SUCCESS,-stdout')

		self.res = postproc.SimResult(sim.model + '_res.mat')
		
		#self.assertAlmostEqual(self.res.interpolate('oeff.eff[1]', 0.1), 0)
if __name__ == '__main__':
	unittest.main()
