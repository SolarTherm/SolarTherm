#! /bin/env python

from __future__ import division
import unittest

#import cleantest
from solartherm import simulation
from solartherm import postproc

import os
import shutil
import cleantest
import subprocess as sp
import pytest

@pytest.mark.skipif(sp.run(['omc','--version'], stdout = sp.PIPE, encoding='utf-8').stdout.split(".")[1] != '14', reason="Only works in omc 1.14")

class TestParticleSystem1DSurrogate(unittest.TestCase):
	def setUp(self):
		fn = '../examples/PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate.mo'
		sim = simulation.Simulator(fn)

		#Compiling the model using old front end
		sim.compile_model(args=["-d=nonewInst"])

		sim.compile_sim(args=['-s'])
	
		#Copy the OELT
		shutil.copy("./OELT_ParticleSystem1D_SingleAperture/OELT_Solstice.motab",".")
	
		SM=1.5
		t_storage=14.0 
		fb=0.6 
		R1=100.0 
		Th_refractory_hot_tank=1.0 
		Th_refractory_cold_tank=0.5 
		ar_rec=1.0 
		H_tower=200.0

		par_n  = [
			"SM","t_storage","fb",
			"R1","Th_refractory_hot_tank",
			"Th_refractory_cold_tank",
			"ar_rec", "H_tower"
		]

		par_v = [
			str(SM), str(t_storage), str(fb),
			str(R1), str(Th_refractory_hot_tank),
			str(Th_refractory_cold_tank),
			str(ar_rec), str(H_tower)
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

		print("System result:\nEPY: %s , LCOE = %s , CF = %s"%(EPY, LCOE, CF))

		assert(abs(round(LCOE,2) - 95.25) < 0.1) #LCOE
		assert(abs(round(EPY,2) - 301419.74) < 1) #EPY
		assert(abs(round(CF,2) - 34.40833577177072) < 0.5) #CF
		cleantest.clean('PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate')
#		self.assertAlmostEqual(self.perf[0], 349.78, 2) # epy
#		self.assertAlmostEqual(self.perf[1], 97.26, 2) # LCOE
#		self.assertAlmostEqual(self.perf[2], 39.93, 2) # Capacity factor

if __name__ == '__main__':
	unittest.main()
	
	
	
	
	


