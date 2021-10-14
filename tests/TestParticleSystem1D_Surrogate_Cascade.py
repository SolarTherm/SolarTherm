#! /bin/env python

from __future__ import division
import unittest

#import cleantest
from solartherm import simulation
from solartherm import postproc

import os
import shutil
#@pytest.mark.skip(reason="Broken?")

class TestParticleSystem1DSurrogate(unittest.TestCase):
	def setUp(self):
		fn = './PhysicalParticleCO21D_1stApproach_SurrogateReceiverCascade_OnTheFlySurrogate.mo'
		sim = simulation.Simulator(fn)

		#Compiling the model using old front end
		sim.compile_model(args=["-d=nonewInst"])

		sim.compile_sim(args=['-s'])
	
		#Copy the OELT
		shutil.copy("./OELT_ParticleSystem1D_Cascade/OELT_Solstice.motab",".")
	
		SM=1.5
		t_storage=14.0 
		fb=0.6 
		R1=100.0 
		Th_refractory_hot_tank=1.0 
		Th_refractory_cold_tank=0.5 
		H_tower=200.0

		par_n  = [
			"SM","t_storage","fb",
			"R1","Th_refractory_hot_tank",
			"Th_refractory_cold_tank", "H_tower"
		]

		par_v = [
			str(SM), str(t_storage), str(fb),
			str(R1), str(Th_refractory_hot_tank),
			str(Th_refractory_cold_tank), str(H_tower)
		]

		#Load the init xml and overwrite them
		sim.load_init(); sim.update_pars(par_n, par_v)

		#Simulate
		sim.simulate(stop="1y", step="3600", solver="dassl", nls="homotopy")
	
		#Read the result file
		res = postproc.SimResultElec(sim.res_fn)
		self.perf = res.calc_perf()
		os.remove("OELT_Solstice.motab")

	def test_particle_system_1D_surrogate(self):
		#Start comparing the perf with pre-run numbers
		print('index, epy (MWh/year),lcoe peaker ($/MWh),capf (%),srev ($')
		print(self.perf)

		EPY = self.perf[0]
		LCOE = self.perf[1]
		CF = self.perf[2]

		assert(abs(LCOE - 156.55162680330525) <0.01) #LCOE
		assert(abs(EPY - 185023.329231224) < 0.01) #EPY
		assert(abs(CF - 21.12138461543653) < 0.01) #CF
#		self.assertAlmostEqual(self.perf[0], 349.78, 2) # epy
#		self.assertAlmostEqual(self.perf[1], 97.26, 2) # LCOE
#		self.assertAlmostEqual(self.perf[2], 39.93, 2) # Capacity factor

if __name__ == '__main__':
	unittest.main()
	
	
	
	
	


